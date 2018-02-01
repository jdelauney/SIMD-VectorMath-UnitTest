{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZVector2f.+(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq  xmm0, [A]
  movq  xmm1, [B]
  addps xmm0, xmm1
  movq  RAX, {%H-}xmm0
end;

class operator TGLZVector2f.-(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq  xmm0, [A]
  movq  xmm1, [B]
  subps xmm0, xmm1
  movq  RAX, {%H-}xmm0
end;

class operator TGLZVector2f.*(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq  xmm0, [A]
  movq  xmm1, [B]
  mulps xmm0, xmm1
  movq  RAX, {%H-}xmm0
end;

class operator TGLZVector2f.*(constref A: TGLZVector2f; constref B : TGLZVector2i): TGLZVector2f; assembler; nostackframe; register;
asm
  movq  xmm0, [A]
  //movq  xmm1,
  cvtpi2ps xmm2, [B]
  mulps xmm0, xmm2
  movq  RAX, {%H-}xmm0
end;



class operator TGLZVector2f./(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq  xmm0, [A]
  movq  xmm1, [B]
  divps xmm0, xmm1
  movq  RAX, {%H-}xmm0
end;

class operator TGLZVector2f.+(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  shufps xmm1, xmm1, $00
  addps  xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;

class operator TGLZVector2f.-(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  shufps xmm1, xmm1, $00
  subps  xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;

class operator TGLZVector2f.*(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  shufps xmm1, xmm1, $00
  mulps  xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;

class operator TGLZVector2f./(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  shufps xmm1, xmm1, $00
  divps  xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;


{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector2f.Min(constref B: Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [B]
  shufps xmm1, xmm1, $00
  minps  xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;

function TGLZVector2f.Min(constref B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq  xmm0, [RCX]
  movq  xmm1, [B]
  minps xmm0, xmm1
  movq  RAX, {%H-}xmm0
end;


function TGLZVector2f.Max(constref B: Single): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [B]
  shufps xmm1, xmm1, $00
  maxps  xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;

function TGLZVector2f.Max(constref B: TGLZVector2f): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq  xmm0, [RCX]
  movq  xmm1, [B]
  maxps xmm0, xmm1
  movq  RAX,  {%H-}xmm0 //RAX ????
end;

function TGLZVector2f.Clamp(constref AMin, AMax: Single): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq   xmm0, [RCX] //movq ????
  movq   xmm1, [AMin]
  movq   xmm2, [AMax]
  shufps xmm1, xmm1, $00 // Replicate AMin
  shufps xmm2, xmm2, $00 // Replicate AMax
  maxps  xmm0, xmm1
  minps  xmm0, xmm2
  movq  RAX,  {%H-}xmm0
end;

function TGLZVector2f.Clamp(constref AMin, AMax: TGLZVector2f): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [AMin]
  movq   xmm2, [AMax]
  maxps  xmm0, xmm1
  minps  xmm0, xmm2
  movq   RAX,  {%H-}xmm0
end;

function TGLZVector2f.MulAdd(constref A,B:TGLZVector2f): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [A]
  movq   xmm2, [B]
  Mulps  xmm0, xmm1
  Addps  xmm0, xmm2
  movq RAX, xmm0
end;

function TGLZVector2f.MulDiv(constref A,B:TGLZVector2f): TGLZVector2f;Assembler;nostackframe;register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [A]
  movq   xmm2, [B]
  Mulps  xmm0, xmm1
  Divps  xmm0, xmm2
  movq RAX, xmm0
end;

function TGLZVector2f.Length:Single;Assembler;nostackframe;register;
asm
  movq     xmm0, [RCX]
  mulps    xmm0, xmm0
  movshdup xmm1, xmm0
  addps    xmm0, xmm1
  sqrtss   xmm0, xmm0
end;

function TGLZVector2f.LengthSquare:Single;Assembler;nostackframe;register;
asm
  movq     xmm0, [RCX]
  mulps    xmm0, xmm0
  movshdup xmm1, xmm0
  addps    xmm0, xmm1
end;

function TGLZVector2f.Distance(constref A:TGLZVector2f):Single;Assembler;nostackframe;register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [A]
  subps  xmm0, xmm1
  mulps  xmm0, xmm0
  //haddps xmm0, xmm0
  movshdup xmm1, xmm0
  addps    xmm0, xmm1
  sqrtss xmm0, xmm0
  movq   RAX, {%H-}xmm0
end;

function TGLZVector2f.DistanceSquare(Constref A:TGLZVector2f):Single;Assembler;nostackframe;register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [A]
  subps  xmm0, xmm1
  mulps  xmm0, xmm0
  //haddps xmm0, xmm0
  movshdup xmm1, xmm0
  addps    xmm0, xmm1
end;

function TGLZVector2f.Normalize : TGLZVector2f;Assembler;nostackframe;register;
asm
  movq   xmm2, [RCX]    // Y X
  movaps xmm0, xmm2
  mulps  xmm2, xmm2      // Y*Y X*X
  pshufd xmm1, xmm2, $01 // X*X Y*Y
  addps  xmm2, xmm1      // (X*X+Y*Y) (2x)
  sqrtps xmm2, xmm2
  divps  xmm0, xmm2
  //rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y)) (4x)
  //mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  movq    RAX, xmm0
end;

// function Reflect(I, NRef : TVector2f):TVector2f
function TGLZVector2f.Round: TGLZVector2i;assembler;nostackframe;register;
asm
  // Rounding mode defaults to round-to-nearest
  movq     xmm0, [RCX]
  cvtps2dq xmm0, xmm0
  movq     rax, xmm0
end;



function TGLZVector2f.Trunc: TGLZVector2i;assembler;//nostackframe;register;
asm
  movq     xmm0, [RCX]
 {$i macro_sse_win64_trunc_xmm0-xmm0.inc}
  movq   rax, xmm0
end;

function TGLZVector2f.Floor : TGLZVector2i; assembler;//nostackframe;register;
asm
  movq     xmm0, [RCX]
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00002000;                    // Set bits Round Mask Down
  //{$endif}
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtps2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax
  movq   rax, xmm0
end;

function TGLZVector2f.Ceil : TGLZVector2i; assembler;//nostackframe;register;
asm
  movq     xmm0, [RCX]
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00004000;                    // Set bits Round Mask up
  //{$endif}
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtps2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax
  movq     rax, xmm0
end;

function TGLZVector2f.Fract: TGLZVector2f; assembler;//nostackframe;register;
asm
  movq     xmm0, [RCX]
  movaps   xmm1, xmm0
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00006000                    // Set bits
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtps2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax
  cvtdq2ps xmm0, xmm0
  subps    xmm1, xmm0 // A - Trunc(A)
  movq     rax, xmm1
end;

function TGLZVector2f.Sqrt: TGLZVector2f; assembler;nostackframe;register;
asm
  movq   xmm0,[RCX]
  sqrtps xmm0, xmm0
  movq   rax, xmm0
end;

function TGLZVector2f.InvSqrt: TGLZVector2f; assembler;nostackframe;register;
asm
  movq   xmm0,[RCX]
  rsqrtps xmm0, xmm0
  movq   rax, xmm0
end;

function TGLZVector2f.ModF(Constref A : TGLZVector2f): TGLZVector2f; assembler;nostackframe;register;
asm
  movq     xmm0, [RCX]
  movaps   xmm1, xmm0
  movq     xmm2, [A]
  divps    xmm0, xmm2
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00006000                   // Set bits
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtps2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax
  cvtdq2ps xmm0, xmm0
  mulps    xmm0, xmm2
  subps    xmm1, xmm0 // A - Trunc(A)
  movq     rax, xmm1
end;

function TGLZVector2f.fMod(Constref A : TGLZVector2f): TGLZVector2i; assembler;nostackframe;register;
asm
  movq     xmm0, [RCX]
  movaps   xmm1, xmm0
  movq     xmm2, [A]

  divps    xmm0, xmm2
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00002000                    // Set bits
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtps2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax

  cvtdq2ps xmm0, xmm0
  mulps    xmm0, xmm2
  subps    xmm1, xmm0 // A - Trunc(A)

  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00006000                   // Set bits
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtps2dq xmm1, xmm1
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax

  movq rax, xmm1
end;

{%endregion%}
