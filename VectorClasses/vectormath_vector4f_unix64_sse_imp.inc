{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZVector4f.+(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movaps  xmm1, [B]
  addps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector4f.-(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movaps  xmm1, [B]
  subps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector4f.*(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movaps  xmm1, [B]
  mulps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector4f./(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movaps  xmm1, [B]
  divps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector4f.+(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movss   xmm1, [B]
  shufps  xmm1, xmm1, $00
  addps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector4f.-(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movss   xmm1, [B]
  shufps  xmm1, xmm1, $00
  subps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector4f.*(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movss   xmm1, [B]
  shufps  xmm1, xmm1, $00
  mulps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector4f./(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movss   xmm1, [B]
  shufps  xmm1, xmm1, $00
  divps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector4f.-(constref A: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm1, [A]
  movaps  xmm0, [RIP+cNullVector4f]
  subps   xmm0, xmm1
  movhlps xmm1, xmm0
End;

class operator TGLZVector4f.= (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps  xmm1, [A]
  movaps  xmm0, [B]
  cmpps   xmm0, xmm1, cSSE_OPERATOR_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 0 = Operator Equal
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

class operator TGLZVector4f.<= (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movaps  xmm1, [B]
  cmpps   xmm0, xmm1, cSSE_OPERATOR_LESS_OR_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 2 = Operator Less or Equal
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

class operator TGLZVector4f.>= (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movaps  xmm1, [B]
  cmpps   xmm0, xmm1, cSSE_OPERATOR_NOT_LESS    //  Yes: $FFFFFFFF, No: $00000000 ; 6 = Operator Not Less Or Equal
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

class operator TGLZVector4f.< (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movaps  xmm1, [B]
  cmpps   xmm0, xmm1, cSSE_OPERATOR_LESS    //  Yes: $FFFFFFFF, No: $00000000 ; 1 = Operator Less Than
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

class operator TGLZVector4f.>(constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps  xmm0, [A]
  movaps  xmm1, [B]
  cmpps   xmm0, xmm1, cSSE_OPERATOR_NOT_LESS_OR_EQUAL     //  Yes: $FFFFFFFF, No: $00000000 ; 5 = Operator Not Less Than
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

class operator TGLZVector4f.<> (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps   xmm0, [A]
  movaps   xmm1, [B]
  cmpps    xmm0, xmm1, cSSE_OPERATOR_NOT_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 4 = Operator Not Equal
  movmskps eax,  xmm0
  or       eax,  eax
  setnz    al
end;

{%endregion%}
{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector4f.Abs: TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  andps   xmm0, [RIP+cSSE_MASK_ABS]
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Negate:TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  xorps   xmm0, [RIP+cSSE_MASK_NEGATE]
  movhlps xmm1, xmm0
End;

function TGLZVector4f.DivideBy2:TGLZVector4f;assembler; nostackframe; register;
asm
  movups  xmm0, [RDI]
  movups  xmm1, [RIP+cHalfOneVector4f]
  mulps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Distance(constref A: TGLZVector4f):Single;assembler; nostackframe; register;
//result := sqrt(sqr(Self.X-A.X)+ sqr(Self.Y-A.Y) + sqr(Self.Z-A.Z));
Asm
  {$IFDEF USE_ASM_SSE_4}
    movaps xmm0, [RDI]
    movaps xmm1, [A]
    subps  xmm0, xmm1
    andps  xmm0, [RIP+cSSE_MASK_NO_W]
    dpps   xmm0, xmm0, $FF;
    sqrtss xmm0, xmm0
  {$ELSE}
    {$IFDEF USE_ASM_SSE_3}
       movaps xmm0, [RDI]
       movaps xmm1, [A]
       subps  xmm0, xmm1
       andps  xmm0, [RIP+cSSE_MASK_NO_W]
       mulps  xmm0, xmm0
       haddps xmm0, xmm0
       haddps xmm0, xmm0
       sqrtss xmm0, xmm0
    {$ELSE}
       movaps  xmm1, [RDI]
       movaps  xmm0, [A]
       subps   xmm1, xmm0
       andps   xmm1, [RIP+cSSE_MASK_NO_W]
       mulps   xmm1, xmm1
       movhlps xmm0, xmm1
       addss   xmm0, xmm1
       shufps  xmm1, xmm1, $55
       addss   xmm0, xmm1
       {.$IFDEF USE_ASM_SIMD_HIGHPRECISION}
       // High Precision
       sqrtss  xmm0, xmm0
       {.$ELSE
           // Low precision - note : may be very inaccurate
           rsqrtss xmm0, xmm0
           rcpss xmm0, xmm0
       .$ENDIF}
     {$ENDIF}
  {$ENDIF}
end;

function TGLZVector4f.DistanceSquare(constref A: TGLZVector4f):Single;assembler; nostackframe; register;
Asm

  {$IFDEF USE_ASM_SSE_4}
    movaps xmm0, [RDI]
    movaps xmm1, [A]
    subps  xmm0, xmm1
    andps  xmm0, [RIP+cSSE_MASK_NO_W]
    dpps   xmm0, xmm0, $FF
    // movss [RESULT], {%H-}xmm0
  {$ELSE}
    {$IFDEF USE_ASM_SSE_3}
       {$ifdef TEST}
          movq   xmm0, [RDI]   // move 64 bits and clear top  x,y,0,0   ** Not working on Win10 64bit
          movq   xmm1, [A]     // move 64 bits and clear top  x1,y1,0,0
          subps  xmm0, xmm1    // x-x1,y-y1,0,0
          mulps  xmm0, xmm0    // (x-x1)^2,(y-y1)^2,0,0
          movss  xmm1, [RDI]8  // z,0,0,0
          movss  xmm2, [A]8    //z1,0,0,0
          subps  xmm1, xmm2    //z-z1,0,0,0
          mulps  xmm1, xmm1    //(z-z1)^2,0,0,0
          addps  xmm0, xmm1    //(x-x1)^2+(z-z1)^2, (y-y1)^2, 0, 0
          haddps xmm0, xmm0    //(x-x1)^2+(z-z1)^2 + (y-y1)^2, 0, 0
          //movshdup    xmm1, xmm0
          //addps       xmm0, xmm1
          //movhlps     xmm1, xmm0
          //addss       xmm0, xmm1
       {$else}
          movaps xmm0, [RDI]
          movaps xmm1, [A]
          subps  xmm0, xmm1
          andps  xmm0, [RIP+cSSE_MASK_NO_W]
          mulps  xmm0, xmm0
          haddps xmm0, xmm0
          haddps xmm0, xmm0
          // Instead of haddps :
          //movshdup    xmm1, xmm0
          //addps       xmm0, xmm1
          //movhlps     xmm1, xmm0
          //addss       xmm0, xmm1
       {$endif}

    {$ELSE}
         movaps  xmm1, [RDI]
         movaps  xmm0, [A]
         subps   xmm1, xmm0
         andps   xmm1, [RIP+cSSE_MASK_NO_W]
         mulps   xmm1, xmm1
         movhlps xmm0, xmm1
         addss   xmm0, xmm1
         shufps  xmm1, xmm1, $55
         addss   xmm0, xmm1
  {$ENDIF}
{$ENDIF}
end;

//function TGLZVector4f.LengthSquare:Single;assembler; nostackframe; register;
function TGLZVector4f.Length:Single;assembler; nostackframe; register;
asm
  {$IFDEF USE_ASM_SSE_4}
    movaps xmm0, [RDI]
    andps  xmm0, [RIP+cSSE_MASK_NO_W]
    dpps   xmm0, xmm0, $FF;
    sqrtss xmm0, xmm0
  {$ELSE}
    //we need to remove W component ?
    {$IFDEF USE_ASM_SSE_3}
      movaps xmm0, [RDI]
      andps  xmm0, [RIP+cSSE_MASK_NO_W]
      mulps  xmm0, xmm0
      haddps xmm0, xmm0
      haddps xmm0, xmm0
      sqrtss xmm0, xmm0
    {$ELSE}
      movaps  xmm1,[RDI]
      //andps xmm1, [RIP+cSSE_MASK_NO_W]
      mulps   xmm1, xmm1
      movhlps xmm0, xmm1
      addss   xmm0, xmm1
      shufps  xmm1, xmm1, $55
      addss   xmm0, xmm1
      {.$IFDEF USE_ASM_SIMD_HIGHPRECISION}
      // High Precision
      sqrtss  xmm0, xmm0
      {.$ELSE
          // Low precision - note : may be very inaccurate
          rsqrtss xmm0, xmm0
          rcpss   xmm0, xmm0
      .$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

function TGLZVector4f.LengthSquare:Single;assembler; nostackframe; register;
Asm
  {$IFDEF USE_ASM_SSE_4}
    movaps xmm0, [RDI]
    andps  xmm0, [RIP+cSSE_MASK_NO_W]
    dpps   xmm0, xmm0, $FF;
  {$ELSE}

    {$IFDEF USE_ASM_SSE_3}
      movaps xmm0, [RDI]
      andps  xmm0, [RIP+cSSE_MASK_NO_W] //we need to remove W component
      mulps  xmm0, xmm0
      {$ifdef TEST}
        movshdup xmm1, xmm0
        addps    xmm0, xmm1
        movhlps  xmm1, xmm0
        addss    xmm0, xmm1
      {$else}
        haddps   xmm0, xmm0
        haddps   xmm0, xmm0
      {$endif}
    {$ELSE}
      movaps  xmm1, [RDI]
      //andps xmm1, [RIP+cSSE_MASK_NO_W]
      mulps   xmm1, xmm1
      movhlps xmm0, xmm1
      addss   xmm0, xmm1
      shufps  xmm1, xmm1, $55
      addss   xmm0, xmm1
    {$ENDIF}
{$ENDIF}
end;

function TGLZVector4f.Spacing(constref A : TGLZVector4f) : Single; assembler; nostackframe; register;
asm
  //Result:=Abs(v2.X-Self.X)+Abs(v2.Y-Self.Y)+Abs(v2.Z-Self.Z)+Abs(v2.W-Self.W);
  movaps xmm1, [RDI]
  movaps xmm0, [A]
  subps  xmm0, xmm1
  andps  xmm0, [RIP+cSSE_MASK_ABS]
  {$IFDEF USE_ASM_SSE_3}
    {$ifdef TEST}
      movshdup xmm1, xmm0
      addps    xmm0, xmm1
      movhlps  xmm1, xmm0
      addss    xmm0, xmm1
    {$else}
      haddps   xmm0, xmm0
      haddps   xmm0, xmm0
    {$endif}
  {$else}
     movhlps xmm1, xmm0             // xmm1 =  - | -  | w  | z  |
     addss   xmm1, xmm0             // x + z
     shufps  xmm0, xmm0, 00000001b  // xmm0 =  - | -  | -  | y  |
     addss   xmm0, xmm1             // (x + z ) + y
     shufps  xmm1, xmm1, 01010101b  // xmm1 =  - | -  | -  | w  |
     addss  xmm0, xmm1              // (x + z  + y) + w
  {$endif}
end;

function TGLZVector4f.CrossProduct(constref A: TGLZVector4f): TGLZVector4f;assembler; nostackframe; register;
asm
  // Place unaligned data to registers
  //v1:x,y,z,w
  movaps xmm0, [RDI]
  //v2:x,y,z,w
  movaps xmm1, [A]                // xmm1 = v2
  movaps xmm2, xmm0               // xmm2 = v1 // move aligned data
  movaps xmm3, xmm1               // xmm3 = v2

  // shuffle members
  // becarefull at the order in the register (right to left )= w z x y )
  // 1st arg xmm = w z y x = 11 10 01 00
  // 2nd arg xmm = w z y x = 11 10 01 00
  // 3rd arg where to place members of 1st arg in 2nd arg
  // becarefull reading from right to left
  shufps  xmm0, xmm0, $c9  //w z y x -> $c9 = 11 00 10 01 -> w x z y

  shufps  xmm1, xmm1, $d2  //w z y x -> $d2 = 11 01 00 10 -> w y x z
  shufps  xmm2, xmm2, $d2
  shufps  xmm3, xmm3, $c9
  // scale
  mulps   xmm0, xmm1
  mulps   xmm2, xmm3
  // sub the results
  subps   xmm0, xmm2
  // cross product will always return a vector this is not needed
  // even if you cress two points with unit W, resultant W will be 0 due to subraction
  //  addps   xmm0, [rip+cWOnevector4f] // it would better change by logical operator
  movhlps xmm1, xmm0
end;

// if the return is > 0 then the angle between the 2 vectors is  > 90° else is < 90°
// Usefull for conputing backface culling and lighting
function TGLZVector4f.DotProduct(constref A: TGLZVector4f):Single;assembler; nostackframe; register;
asm
  {$IFDEF USE_ASM_SSE_4}
    movups xmm0, [RDI]
    movups xmm1, [A]
     // Becarefull at the order of mask Right to Left
     // 4 high bits: which elements should be summed. (w,z,y,x)
     // 4 low bits: which output slots should contain the result. (3,2,1,0)
     // mask =  0111b 0001;
     dpps  xmm0, xmm1, 01110001b //or $F1
     //movss [RESULT], {%H-}xmm0
  {$ELSE}
    {$IFDEF USE_ASM_SSE_3}
       movups xmm1, [RDI]
       movups xmm0, [A]
       andps  xmm1, [RIP+cSSE_MASK_NO_W]
       mulps  xmm0, xmm1
       haddps xmm0, xmm0
       haddps xmm0, xmm0
       // movss [RESULT], xmm1
    {$ELSE}
      movups  xmm0,[RDI]
      movups  xmm1, [A]
      andps   xmm0, [RIP+cSSE_MASK_NO_W]
      mulps   xmm0, xmm1            //   xmm0 =  w | z  | y  | x  |
      movhlps xmm1, xmm0            //   xmm1 =  - | -  | w  | z  |
      addps   xmm1, xmm0            //   x + z
      // How to with shufps
      //  In xmm0 =  w | z  | y  | x  |
      //          = 11 | 10 | 01 | 00 |
      // Out xmm0 =  - | -  | -  | Y  |
      //          = 00 | 00 | 00 | 01 | ==> 00000001b
      shufps xmm0, xmm0, 00000001b  //   xmm1 =  - | -  | -  | y  |
      addps  xmm0, xmm1             // (x + z ) + y
    {$ENDIF}
  {$ENDIF}
end;

function TGLZVector4f.Norm:Single;assembler; nostackframe; register;
asm
  movaps xmm0, [RDI]
  mulps  xmm0, xmm0
  movaps xmm1, xmm0
  shufps xmm0, xmm1, $4e
  addps  xmm0, xmm1
  shufps xmm1, xmm0, $11
  addps  xmm0, xmm1
end;

function TGLZVector4f.Normalize: TGLZVector4f;  assembler; nostackframe; register;
asm
  // 3 reg usage so could unroll loops 5 at a time in 64bit
  movaps  xmm0, [RDI]
  movaps  xmm2, xmm0
  mulps   xmm2, xmm2
  movaps  xmm1, [RIP+cOneVector4f]
  movhlps xmm1, xmm2        //  |Z^2|*|1|1|
{$ifdef USE_ASM_SSE_3}
  haddps  xmm2, xmm2
{$else}
  addss   xmm1, xmm2         //    |z^2+x^2*|1|1|
  shufps  xmm2, xmm2, 01010101b
{$endif}
  addss   xmm1, xmm2         //  |x^2 + y^2 + z^2|*|1|1|
  sqrtps  xmm1, xmm1         //  |Sqrt(x^2 + y^2 + z^2)|*|1|1|
  movd    eax,  xmm1
  add     eax,  eax            // get rid of sign bit if it exists
  jz @origin
  shufps  xmm1, xmm1, 11000000b  // |sqrt(Norm)|sqrt(Norm)|sqrt(Norm)|1|
  divps   xmm0, xmm1
@origin:
  movhlps xmm1, xmm0          // sf 5.48
end;

function TGLZVector4f.Min(constref B: Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm1, [B]
  shufps  xmm1, xmm1, $00 // Replicate B
  minps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Min(constref B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [B]
  minps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Max(constref B: Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm1, [B]
  shufps  xmm1, xmm1, $00 // Replicate B
  maxps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Max(constref B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [B]
  maxps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Clamp(constref AMin, AMax: Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm2, [AMin]
  movss   xmm3, [AMax]
  shufps  xmm2, xmm2, $00 // Replicate AMin
  shufps  xmm3, xmm3, $00 // Replicate AMax
  maxps   xmm0, xmm2
  minps   xmm0, xmm3
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Clamp(Constref AMin, AMax: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [AMin]
  movaps  xmm2, [AMax]
  maxps   xmm0, xmm1
  minps   xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector4f.MulAdd(Constref B, C: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [B]
  movaps  xmm2, [C]
  mulps   xmm0, xmm1
  addps   xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector4f.MulSub(Constref B, C: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RDI]
  //movaps xmm1, [B]
  //movaps xmm2, [C]
  mulps  xmm0, XMMWORD PTR [B] //xmm1
  Subps  xmm0, XMMWORD PTR [C] //xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector4f.MulDiv(Constref B, C: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [B]
  movaps  xmm2, [C]
  mulps   xmm0, xmm1
  Divps   xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Lerp(Constref B: TGLZVector4f; Constref T:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [B]
  movss   xmm2, [T]
  shufps  xmm2, xmm2, $0
  andps   xmm2, [RIP+cSSE_MASK_NO_W]
  subps   xmm1, xmm0
  mulps   xmm1, xmm2

  addps   xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.AngleCosine(constref A : TGLZVector4f): Single; assembler; nostackframe; register;
//Result:=Self.DotProduct(A)/(Self.Length*A.Length);
asm
  movaps xmm0, [RDI]
  movaps xmm1, [A]
  movaps xmm2, xmm0 // Coypy Self
  movaps xmm4, xmm1 // Copy A

 // DotProd in xmm0 Result in xmm3
 {$IFDEF USE_ASM_SSE_4}
    dpps   xmm0, xmm1, 01110001b //or $F1
    movaps xmm3, xmm0
 {$ELSE}
   {$IFDEF USE_ASM_SSE_3}
     andps  xmm0, [RIP+cSSE_MASK_NO_W]
     mulps  xmm1, xmm0
     haddps xmm1, xmm1
     haddps xmm1, xmm1
     movaps xmm3, xmm1
   {$ELSE}
     mulps   xmm1, xmm0
     movhlps xmm0, xmm1
     addps   xmm0, xmm1
     shufps  xmm1, xmm1, 00000001b
     addps   xmm1, xmm0
     movaps  xmm3, xmm1
   {$ENDIF}
 {$ENDIF}
  // Length Self in xmm2 result in xmm2
  andps xmm2, [RIP+cSSE_MASK_NO_W]
  {$IFDEF USE_ASM_SSE_4}
    dpps   xmm2, xmm2, $FF;
    sqrtss xmm2, xmm2
  {$ELSE}
    mulps  xmm2, xmm2
    {$IFDEF USE_ASM_SSE_3}
      haddps xmm2, xmm2
      haddps xmm2, xmm2
      sqrtss xmm2, xmm2
    {$ELSE}
      movhlps xmm1, xmm2
      addss   xmm1, xmm2
      shufps  xmm2, xmm2, $55
      addss   xmm1, xmm2
      sqrtss  xmm2, xmm1
    {$ENDIF}
  {$ENDIF}
  // Lenght A in xmm4 result in xmm4
  andps xmm4, [RIP+cSSE_MASK_NO_W]
  {$IFDEF USE_ASM_SSE_4}
    dpps   xmm4, xmm4, $FF;
    sqrtss xmm4, xmm4
  {$ELSE}
    mulps    xmm4, xmm4
    {$IFDEF USE_ASM_SSE_3}
      haddps xmm4, xmm4
      haddps xmm4, xmm4
      sqrtss xmm4, xmm4
    {$ELSE}
      movhlps xmm1, xmm4
      addss   xmm1, xmm4
      shufps  xmm4, xmm4, $55
      addss   xmm1, xmm4
      sqrtss  xmm4, xmm1
    {$ENDIF}
  {$ENDIF}
  mulps xmm2, xmm4
  divps xmm3, xmm2
  movss xmm0, xmm3
end;

function TGLZVector4f.AngleBetween(Constref A, ACenterPoint : TGLZVector4f): Single;
Var
  vResult  :  Single;
begin
  asm
    movups xmm0, [rdi]
    mov    rax,  [A]
    movups xmm1, [rax]
    mov    rax,  [ACenterPoint]
    movups xmm2, [rax]
    subps  xmm0, xmm2
    subps  xmm1, xmm2

    // Normalize xmm0 result in xmm2
    movaps xmm3, xmm0
    andps  xmm3, [RIP+cSSE_MASK_ONLY_W]
    andps  xmm0, [RIP+cSSE_MASK_NO_W]
    movaps xmm2, xmm0
    {$IFDEF USE_ASM_SSE_3}
      mulps  xmm0, xmm0
      haddps xmm0, xmm0
      haddps xmm0, xmm0
    {$ELSE}
      mulps  xmm0, xmm0
      movaps xmm5, xmm0
      shufps xmm0, xmm5, $4e
      addps  xmm0, xmm5
      movaps xmm5, xmm0
      shufps xmm5, xmm5, $11
      addps  xmm0, xmm5
    {$ENDIF}
    {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
      // High Precision
      sqrtps xmm0, xmm0
      divps  xmm2, xmm0
    {$ELSE}
      // Low precision
      rsqrtps xmm0, xmm0       //approximate reciprocal
      mulps   xmm2, xmm0
    {$ENDIF}
    addps  xmm2, xmm3
    // Normalize xmm1 result in xmm4
    movaps xmm3, xmm1
    andps  xmm3, [RIP+cSSE_MASK_ONLY_W]
    andps  xmm1, [RIP+cSSE_MASK_NO_W]
    movaps xmm4, xmm1
    {$IFDEF USE_ASM_SSE_3}
      mulps  xmm1, xmm1
      haddps xmm1, xmm1
      haddps xmm1, xmm1
    {$ELSE}
      mulps  xmm1, xmm1
      movaps xmm5, xmm1
      shufps xmm1, xmm5, $4e
      addps  xmm1, xmm5
      movaps xmm5, xmm1
      shufps xmm5, xmm5, $11
      addps  xmm1, xmm5
    {$ENDIF}
    {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
      // High Precision
      sqrtps xmm1, xmm1
      divps  xmm4, xmm1
    {$ELSE}
      // Low precision
      rsqrtps xmm1, xmm1       //approximate reciprocal
      mulps   xmm4, xmm1
    {$ENDIF}
    addps  xmm4,xmm3

    // AngleCosine
    movaps xmm1, xmm4
    movaps xmm0, xmm2 // Copy A

   // DotProd  xmm0/xmm1 Result in xmm3
   {$IFDEF USE_ASM_SSE_4}
      dpps   xmm0, xmm1, 01110001b //or $F1
      movaps xmm3, xmm0
   {$ELSE}
     {$IFDEF USE_ASM_SSE_3}
       andps  xmm0, [RIP+cSSE_MASK_NO_W]
       mulps  xmm1, xmm0
       haddps xmm1, xmm1
       haddps xmm1, xmm1
       movaps xmm3, xmm1
     {$ELSE}
       mulps   xmm1, xmm0
       movhlps xmm0, xmm1
       addps   xmm0, xmm1
       shufps  xmm1, xmm1, 00000001b
       addps   xmm1, xmm0
       movaps  xmm3, xmm1
     {$ENDIF}
   {$ENDIF}
    // Length xmm2 result in xmm2
    andps xmm2, [RIP+cSSE_MASK_NO_W]
    {$IFDEF USE_ASM_SSE_4}
      dpps   xmm2, xmm2, $FF;
      sqrtss xmm2, xmm2
    {$ELSE}
      mulps   xmm2, xmm2
      {$IFDEF USE_ASM_SSE_3}
        haddps xmm2, xmm2
        haddps xmm2, xmm2
        sqrtss xmm2, xmm2
      {$ELSE}
        movhlps xmm1, xmm2
        addss   xmm1, xmm2
        shufps  xmm2, xmm2, $55
        addss   xmm1, xmm2
        sqrtss  xmm2, xmm1
      {$ENDIF}
    {$ENDIF}
    // Lenght  xmm4 result in xmm4
    andps xmm4, [RIP+cSSE_MASK_NO_W]
    {$IFDEF USE_ASM_SSE_4}
      dpps   xmm4, xmm4, $FF;
      sqrtss xmm4, xmm4
    {$ELSE}
      mulps  xmm4, xmm4
      {$IFDEF USE_ASM_SSE_3}
        haddps xmm4, xmm4
        haddps xmm4, xmm4
        sqrtss xmm4, xmm4
      {$ELSE}
        movhlps xmm1, xmm4
        addss   xmm1, xmm4
        shufps  xmm4, xmm4, $55
        addss   xmm1, xmm4
        sqrtss  xmm4, xmm1
      {$ENDIF}
    {$ENDIF}
    mulps xmm2, xmm4
    divps xmm3, xmm2
    movss [vResult], {%H-}xmm3
  end;
  Result := ArcCos(vResult);
end;

function TGLZVector4f.Combine(constref V2: TGLZVector4f; constref F1: Single): TGLZVector4f;assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [V2]
  movss   xmm2, [F1]
  shufps  xmm2, xmm2, $00 // replicate

  mulps   xmm1, xmm2      // V2*F1
  addps   xmm0, xmm1      // Self + (V2*F1)

  andps   xmm0, [RIP+cSSE_MASK_NO_W]
  movhlps xmm1,xmm0
end;

function TGLZVector4f.Combine2(constref V2: TGLZVector4f; const F1, F2: Single): TGLZVector4f;assembler; nostackframe; register;
asm
  movaps  xmm2, [RDI]     // get in one hit V1
  movaps  xmm3, [V2]      // get in one hit V2

  shufps  xmm0, xmm0, $00 // replicate  F1
  shufps  xmm1, xmm1, $00 // replicate  F2

  mulps   xmm0, xmm2      // Self * F1
  mulps   xmm1, xmm3      // V2 * F2

  addps   xmm0, xmm1      // (Self * F1) + (V2 * F2)

  andps   xmm0, [RIP+cSSE_MASK_NO_W]
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Combine3(constref V2, V3: TGLZVector4f; const F1, F2, F3: Single): TGLZVector4f;  assembler; nostackframe; register;
asm
 movaps  xmm3, [RDI]

 movaps  xmm4, [V2]
 movaps  xmm5, [V3]

 shufps  xmm0, xmm0, $00 // replicate  F1
 shufps  xmm1, xmm1, $00 // replicate  F2
 shufps  xmm2, xmm2, $00 // replicate  F3

 mulps   xmm0, xmm3      // Self * F1
 mulps   xmm4, xmm1      // V2 * F2
 mulps   xmm5, xmm2      // V3 * F3

 addps   xmm0, xmm4      // (Self * F1) + (V2 * F2)
 addps   xmm0, xmm5      // ((Self * F1) + (V2 * F2)) + (V3 * F3)

 andps   xmm0, [RIP+cSSE_MASK_NO_W]
 movhlps xmm1,xmm0
end;

function TGLZVector4f.Round: TGLZVector4i;assembler;nostackframe;register;
asm
  // Rounding mode defaults to round-to-nearest
  movaps   xmm0, [RDI]
  cvtps2dq xmm0, xmm0
  movhlps  xmm1, xmm0
  movq     RAX,  xmm0
  movq     RDX,  xmm1
end;


function TGLZVector4f.Trunc: TGLZVector4i;assembler;nostackframe;register;
asm
  movaps   xmm0, [RDI]
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  {$ifdef TEST}
  and      eax,  [RIP+cSSE_ROUND_MASK]
  or       eax,  [RIP+cSSE_ROUND_MASK_TRUNC] // Set bits
  {$else}
                   // smaller opcode
  and      eax,  $00009FFF
  or       eax,  $00006000                   // Set bits
  {$endif}
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtps2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax                               // free used stack
  movhlps  xmm1, xmm0
  movq     RAX,  xmm0
  movq     RDX,  xmm1
end;


function TGLZVector4f.Floor : TGLZVector4i; assembler;//nostackframe;register;
asm
  movaps     xmm0, [RDI]
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
  movhlps  xmm1, xmm0
  movq     RAX,  xmm0
  movq     RDX,  xmm1
end;

function TGLZVector4f.Ceil : TGLZVector4i; assembler;//nostackframe;register;
asm
  movaps     xmm0, [RDI]
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
  movhlps  xmm1, xmm0
  movq     RAX,  xmm0
  movq     RDX,  xmm1
end;

function TGLZVector4f.Fract: TGLZVector4f; assembler;//nostackframe;register;
asm
  movaps     xmm0, [RDI]
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

end;

function TGLZVector4f.Sqrt: TGLZVector4f;assembler;nostackframe;register;
asm
  // Rounding mode defaults to round-to-nearest
  //movaps     xmm0, [RCX]
  sqrtps xmm0, XMMWORD PTR [RDI]//xmm0
  movhlps xmm1,xmm0
end;

function TGLZVector4f.InvSqrt: TGLZVector4f;assembler;nostackframe;register;
asm
  // Rounding mode defaults to round-to-nearest
  //movaps     xmm0, [RCX]
  rsqrtps xmm0, XMMWORD PTR [RDI]//xmm0
  movhlps xmm1,xmm0
end;
{%endregion%}

{%region%----[ Operations on Self ]-----------------------------------------------}

(* procedure TGLZVector4f.pAdd(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
   movaps  xmm0, [RDI]
   movaps  xmm1, [A]
   addps   xmm0, xmm1
   movaps [RDI], xmm0
End;

procedure TGLZVector4f.pSub(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
   movaps  xmm0, [RDI]
   movaps  xmm1, [A]
   subps   xmm0, xmm1
   movaps [RDI], xmm0
End;

procedure TGLZVector4f.pMul(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
   movaps  xmm0, [RDI]
   movaps  xmm1, [A]
   mulps   xmm0, xmm1
   movaps [RDI], xmm0
End;

procedure TGLZVector4f.pDiv(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
   movaps  xmm0, [RDI]
   movaps  xmm1, [A]
   divps   xmm0, xmm1
   movaps [RDI], xmm0
End;

procedure TGLZVector4f.pAdd(constref A: Single); assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm1, [A]
  shufps  xmm1, xmm1,0
  addps   xmm0, xmm1
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pSub(constref A: Single); assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm1, [A]
  shufps  xmm1, xmm1,0
  subps   xmm0, xmm1
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pMul(constref A: Single); assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm1, [A]
  shufps  xmm1, xmm1,0
  mulps   xmm0, xmm1
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pDiv(constref A: Single); assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm1, [A]
  shufps  xmm1, xmm1,0
  divps   xmm0, xmm1
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pInvert;assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  xorps   xmm0, [RIP+cSSE_MASK_NEGATE]
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pNegate; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  xorps   xmm0, [RIP+cSSE_MASK_NEGATE]
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pAbs; assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [RIP+cSSE_MASK_ABS]
  andps   xmm0, xmm1
  movaps [RDI], xmm0
end;

procedure TGLZVector4f.pDivideBy2;assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [RIP+cHalfOneVector4f]
  mulps   xmm0, xmm1
  movaps [RDI], xmm0
end;

procedure TGLZVector4f.pCrossProduct(constref A: TGLZVector4f);assembler; nostackframe; register;
asm
  // Place unaligned data to registers
 //v1:x,y,z,w
  movaps xmm0, [RDI]
 //v2:x,y,z,w
  movaps xmm1, [A]                 // xmm1 = v2
  movaps xmm2, xmm0                // xmm2 = v1 // move aligned data
  movaps xmm3, xmm1                // xmm3 = v2

  // shuffle members
  // becarefull at the order in the register (right to left )= w z x y )
  // 1st arg xmm = w z y x = 11 10 01 00
  // 2nd arg xmm = w z y x = 11 10 01 00
  // 3rd arg where to place members of 1st arg in 2nd arg
  // becarefull reading from right to left
  shufps  xmm0, xmm0, $C9  //w z y x -> $c9 = 11 00 10 01 -> w x z y

  shufps  xmm1, xmm1, $D2  //w z y x -> $d2 = 11 01 00 10 -> w y x z
  shufps  xmm2, xmm2, $D2
  shufps  xmm3, xmm3, $C9
  // scale
  mulps   xmm0, xmm1
  mulps   xmm2, xmm3
  // sub the results
  subps   xmm0, xmm2
//  addps   xmm0, [rip+cWOnevector4f]
  movaps [RDI], xmm0
end;

procedure TGLZVector4f.pNormalize;  assembler; nostackframe; register;
asm
  movaps xmm0, [RDI]
  movaps xmm3, xmm0
  andps  xmm3, [RIP+cSSE_MASK_ONLY_W]
  andps  xmm0, [RIP+cSSE_MASK_NO_W]
  movaps xmm2, xmm0
  {$IFDEF USE_ASM_SSE_3}
    movaps xmm1, xmm0
    mulps  xmm0, xmm0
    haddps xmm0, xmm0
    haddps xmm0, xmm0
  {$ELSE}
    mulps  xmm0, xmm0
    movaps xmm1, xmm0
    shufps xmm0, xmm1, $4e
    addps  xmm0, xmm1
    movaps xmm1, xmm0
    shufps xmm1, xmm1, $11
    addps  xmm0, xmm1
  {$ENDIF}
  {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
    // High Precision
    sqrtps xmm0, xmm0
    divps  xmm2, xmm0
  {$ELSE}
    // Low precision
    rsqrtps xmm0, xmm0       //approximate reciprocal
    mulps   xmm2, xmm0
  {$ENDIF}
  addps   xmm2, xmm3
  movaps [RDI], xmm2
end;

procedure TGLZVector4f.pMin(constref B: TGLZVector4f); assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [B]
  minps   xmm0, xmm1
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pMin(constref B: Single); assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm1, [B]
  shufps  xmm1, xmm1, $00
  minps   xmm0, xmm1
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pMax(constref B: TGLZVector4f); assembler; nostackframe; register;
asm
   movaps  xmm0, [RDI]
   movaps  xmm1, [B]
   maxps   xmm0, xmm1
   movaps [RDI], xmm0
End;

procedure TGLZVector4f.pMax(constref B: Single); assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm1, [B]
  shufps  xmm1, xmm1, $00
  maxps   xmm0, xmm1
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pClamp(Constref AMin, AMax: TGLZVector4f); assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movaps  xmm2, [AMin]
  movaps  xmm3, [AMax]
  maxps   xmm0, xmm2
  minps   xmm0, xmm3
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pClamp(constref AMin, AMax: Single); assembler; nostackframe; register;
asm
  movaps  xmm0, [RDI]
  movss   xmm2, [AMin]
  movss   xmm3, [AMax]
  shufps  xmm2, xmm2, $00 // Replicate AMin
  shufps  xmm3, xmm3, $00 // Replicate AMax
  maxps   xmm0, xmm2
  minps   xmm0, xmm3
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pMulAdd(Constref B, C: TGLZVector4f); assembler; nostackframe; register; // (Self*B)+c
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [B]
  movups  xmm2, [C]
  mulps   xmm0, xmm1
  addps   xmm0, xmm2
  movaps [RDI], xmm0
End;

procedure TGLZVector4f.pMulDiv(Constref B, C: TGLZVector4f); assembler; nostackframe; register; // (Self*B)-c
asm
  movaps  xmm0, [RDI]
  movaps  xmm1, [B]
  movaps  xmm2, [C]
  mulps   xmm0, xmm1
  divps   xmm0, xmm2
  movaps [RDI], xmm0
End;  *)

{%endregion%}
