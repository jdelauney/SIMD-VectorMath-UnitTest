procedure TGLZHmgPlane.Create(constref p1, p2, p3 : TGLZVector);assembler; register;
asm
  movups xmm0, [p1]
  movups xmm1, [p2]
  mov    edx,  [p3]
  movups xmm2, [edx]

  movaps xmm4, xmm0
  movaps xmm5, xmm2
  movaps xmm6, xmm1

  shufps xmm4, xmm4, 11001001b   //|p1 T1|
  shufps xmm5, xmm5, 11001001b   //|p3 T1|
  shufps xmm6, xmm6, 11001001b   //|p2 T1|

  movaps xmm3, xmm6
  subps  xmm3, xmm5              //|T1(2-3)|
  subps  xmm5, xmm4              //|T1(3-1)|
  subps  xmm4, xmm6              //|T1(1-2)|

  movaps xmm6, xmm0              // stash p1 for later

  mulps  xmm0, xmm3              // NT1*(T1(2-3))
  mulps  xmm1, xmm5              // NT2*(T1(3-1))
  mulps  xmm2, xmm4              // NT3*(T1(1-2))
  addps  xmm1, xmm0              // NT1*(T1(2-3)) + NT2*(T1(3-1))
  addps  xmm1, xmm2              // NT1*(T1(2-3)) + NT2*(T1(3-1)) + NT3*(T1(1-2))
                                 // xmm1 now holds |-|B|A|C|
  movaps xmm0, xmm1              // stash for result

  {$ifdef USE_ASM_SSE_4}
    dpps     xmm1, xmm1, 01111111b  // result in all bytes
    sqrtps   xmm1, xmm1
  {$else}
    mulps    xmm1, xmm1
    {$ifdef USE_ASM_SSE_3}
      movhlps xmm2, xmm1
      haddps  xmm1, xmm1
      addss   xmm1, xmm2
    {$else}
      movhlps xmm2, xmm1
      addss   xmm2, xmm1
      shufps  xmm1, xmm1, 01010101b
      addss   xmm1, xmm2
    {$endif}
    sqrtss  xmm1, xmm1
    shufps  xmm1, xmm1, 00000000b // fill all byte with result.
  {$endif}
    divps   xmm0, xmm1            // xmm0 now holds (|-|B|A|C|)unitvector
    shufps  xmm0, xmm0, 11001001b // xmm0 now holds (|-|C|B|A|)unitvector


  {$ifdef USE_ASM_SSE_4}
    dpps     xmm6, xmm0, 01110001b
  {$else}
    mulps    xmm6, xmm0
    {$ifdef USE_ASM_SSE_3}
      movhlps xmm2, xmm6
      haddps  xmm6, xmm6
      addss   xmm6, xmm2
    {$else}
      movhlps xmm2, xmm6
      addss   xmm2, xmm6
      shufps  xmm6, xmm6, 01010101b
      addss   xmm6, xmm2
    {$endif}
  {$endif}

    xorps   xmm6, [cSSE_MASK_NEGATE] // xmm6 now holds |-|-|-|D|
    shufps  xmm6, xmm0, 10100000b        // xmm6 now holds |C|C|D|D|
    shufps  xmm6, xmm6, 00000011b        // xmm6 now holds |D|D|D|C|
    movlhps xmm0, xmm6
    movups [EAX], xmm0
end;

procedure TGLZHmgPlane.Normalize;assembler;
asm
  movups xmm0, [EAX]
  movaps   xmm2, xmm0
{$ifdef USE_ASM_SSE_4}
  dpps     xmm2, xmm2, 01110001b
{$else}
  mulps    xmm2, xmm2
  {$ifdef USE_ASM_SSE_3}
    movhlps xmm3, xmm2
    haddps  xmm2, xmm2
    addss   xmm2, xmm3
  {$else}
    movhlps xmm1, xmm2
    addss   xmm1, xmm2
    shufps  xmm2, xmm2, 01010101b
    addss   xmm2, xmm1
  {$endif}
{$endif}
  sqrtss  xmm2, xmm2
  shufps  xmm2, xmm2, 00000000b
  divps   xmm0, xmm2
  movups [EAX], xmm0
end;

function TGLZHmgPlane.Normalized:TGLZHmgPlane;assembler;
asm
  movups xmm0, [EAX]
  movaps   xmm2, xmm0
{$ifdef USE_ASM_SSE_4}
  dpps     xmm2, xmm2, 01110001b
{$else}
  mulps    xmm2, xmm2
  {$ifdef USE_ASM_SSE_3}
    movhlps xmm3, xmm2
    haddps  xmm2, xmm2
    addss   xmm2, xmm3
  {$else}
    movhlps xmm1, xmm2
    addss   xmm1, xmm2
    shufps  xmm2, xmm2, 01010101b
    addss   xmm2, xmm1
  {$endif}
{$endif}
  sqrtss  xmm2, xmm2
  shufps  xmm2, xmm2, 00000000b
  divps   xmm0, xmm2
  movups [RESULT], xmm0
end;

function TGLZHmgPlane.Distance(constref point : TGLZVector) : Single; assembler;
asm
  movss xmm0, [EAX]           // fastest 0-4% slower
  mulss xmm0, [POINT]
  movss xmm1, [EAX]4
  mulss xmm1, [POINT]4
  addss xmm0, xmm1
  movss xmm2, [EAX]8
  mulss xmm2, [POINT]8
  addss xmm0, [EAX]12
  addss xmm0, xmm2
  movss [RESULT], {%H-}xmm0
end;

function TGLZHmgPlane.AbsDistance(constref point : TGLZVector) : Single; assembler;
asm
  movss xmm0, [EAX]
  mulss xmm0, [POINT]
  movss xmm1, [EAX]4
  mulss xmm1, [POINT]4
  addss xmm0, xmm1
  movss xmm2, [EAX]8
  mulss xmm2, [POINT]8
  addss xmm0, [EAX]12
  addss xmm0, xmm2
  andps xmm0, [cSSE_MASK_ABS]
  movss [RESULT], {%H-}xmm0
end;


