{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZVector4f.+(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  {$ifdef TEST}
    addps  xmm0,[B]
  {$else}
    movaps xmm1,[B]
    addps  xmm0, xmm1
  {$endif}
  movaps [RESULT], xmm0
end;

class operator TGLZVector4f.-(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  {$ifdef TEST}
    subps  xmm0,[B]
  {$else}
    movaps xmm1,[B]
    subps  xmm0, xmm1
  {$endif}
  movaps [RESULT], xmm0
end;

class operator TGLZVector4f.*(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  {$ifdef TEST}
    mulps  xmm0,[B]
  {$else}
    movaps xmm1,[B]
    mulps  xmm0, xmm1
  {$endif}
  movaps [RESULT], xmm0
end;

class operator TGLZVector4f./(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  {$ifdef TEST}
    movaps xmm0,[A]
    {$ifdef USE_ASM_SIMD_HIGHPRECISION}
       divps  xmm0,[B]
    {$else}
      movaps xmm1,[B]
      rcpps  xmm1, xmm1
      mulps  xmm0,xmm1
    {$endif}
  {$else}
    movaps xmm0,[A]
    movaps xmm1,[B]
    {$ifdef USE_ASM_SIMD_HIGHPRECISION}
       divps  xmm0,xmm1
    {$else}
      rcpps  xmm1, xmm1
      mulps  xmm0,xmm1
    {$endif}
  {$endif}
  movaps [RESULT], xmm0
end;

class operator TGLZVector4f.+(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  {$ifdef TEST}
    movlps  xmm1,[B]
  {$else}
    movss  xmm1,[B]
  {$endif}
  shufps xmm1, xmm1, $00
  addps  xmm0,xmm1
  movaps [RESULT], xmm0
end;

class operator TGLZVector4f.-(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  {$ifdef TEST}
    movlps  xmm1,[B]
  {$else}
    movss  xmm1,[B]
  {$endif}
  shufps xmm1, xmm1, $00
  subps  xmm0, xmm1
  movaps [RESULT], xmm0
end;

class operator TGLZVector4f.*(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  {$ifdef TEST}
    movlps  xmm1,[B]
  {$else}
    movss  xmm1,[B]
  {$endif}
  shufps xmm1, xmm1, $00
  mulps  xmm0, xmm1
  movaps [RESULT], xmm0
end;

class operator TGLZVector4f./(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  {$ifdef TEST}
    movlps  xmm1,[B]
  {$else}
    movss  xmm1,[B]
  {$endif}
  {$ifdef USE_ASM_SIMD_HIGHPRECISION}
    shufps xmm1, xmm1, $00
    divps  xmm0,xmm1
  {$else}
    shufps xmm1, xmm1, $00
    rcpps  xmm1, xmm1
    mulps  xmm0,xmm1
  {$endif}
  movaps [RESULT], xmm0
end;

class operator TGLZVector4f.-(constref A: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm1,[A]
  movaps xmm0,[RIP+cNullVector4f]
  subps xmm0,xmm1
  movaps [RESULT],xmm0
End;

class operator TGLZVector4f.= (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  {$ifdef TEST}
//    movaps xmm1,[B]
    cmpps  xmm0, [B], cSSE_OPERATOR_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 0 = Operator Equal
  {$else}
    movaps xmm1,[B]
    cmpps  xmm0, xmm1, cSSE_OPERATOR_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 0 = Operator Equal
  {$endif}
  movmskps eax, xmm0
  xor eax, $F
  setz al
end;

class operator TGLZVector4f.<= (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movaps xmm1,[B]
  cmpps  xmm0, xmm1, cSSE_OPERATOR_LESS_OR_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 2 = Operator Less or Equal
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

class operator TGLZVector4f.>= (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movaps xmm1,[B]
  cmpps  xmm0, xmm1, cSSE_OPERATOR_NOT_LESS     //  Yes: $FFFFFFFF, No: $00000000 ; 6 = Operator Not Less Or Equal
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

class operator TGLZVector4f.< (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movaps xmm1,[B]
  cmpps  xmm0, xmm1, cSSE_OPERATOR_LESS    //  Yes: $FFFFFFFF, No: $00000000 ; 1 = Operator Less Than
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

class operator TGLZVector4f.>(constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movaps xmm1,[B]
  cmpps  xmm0, xmm1,  cSSE_OPERATOR_NOT_LESS_OR_EQUAL   //  Yes: $FFFFFFFF, No: $00000000 ; 5 = Operator Not Less Than
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

class operator TGLZVector4f.<> (constref A, B: TGLZVector4f): boolean; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movaps xmm1,[B]
  cmpps  xmm0, xmm1, cSSE_OPERATOR_NOT_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 4 = Operator Not Equal
  movmskps eax, xmm0
  or eax, eax
  setnz al
end;

{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector4f.Abs: TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    andps    xmm0, [RIP+cSSE_MASK_ABS]
  {$else}
    movaps   xmm1, [RIP+cSSE_MASK_ABS]
    andps    xmm0, xmm1
  {$endif}
  movaps   [RESULT], xmm0
end;

function TGLZVector4f.Negate:TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    xorps xmm0,[RIP+cSSE_MASK_NEGATE]
  {$else}
  movaps xmm1,[RIP+cSSE_MASK_NEGATE]
  xorps xmm0, xmm1
  {$endif}
  movaps [RESULT],xmm0
End;

function TGLZVector4f.DivideBy2:TGLZVector4f;assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    mulps xmm0,[RIP+cHalfOneVector4f]
  {$else}
    movaps xmm1,[RIP+cHalfOneVector4f]
    mulps xmm0, xmm1
  {$endif}
  movaps [RESULT],xmm0
end;

function TGLZVector4f.Distance(constref A: TGLZVector4f):Single;assembler; nostackframe; register;
Asm

  {$IFDEF USE_ASM_SSE_4}
    movaps xmm0,[RCX]
    movaps  xmm1, [A]
    subps   xmm0, xmm1
    andps xmm0, [RIP+cSSE_MASK_NO_W]
    dpps xmm0, xmm0, $FF
    sqrtss xmm0, xmm0
    // movss [RESULT], {%H-}xmm0
  {$ELSE}
    {$IFDEF USE_ASM_SSE_3}
       {$ifdef TEST}
          movq xmm0, [RCX]         // move 64 bits and clear top  x,y,0,0
          movq xmm1, [A]           // move 64 bits and clear top  x1,y1,0,0
          subps xmm0, xmm1   // x-x1,y-y1,0,0
          mulps xmm0, xmm0   // (x-x1)^2,(y-y1)^2,0,0
          movss xmm1, [rcx]8      // z,0,0,0
          movss xmm2, [A]8        //z1,0,0,0
          subps  xmm1, xmm2   //z-z1,0,0,0
          mulps  xmm1, xmm1   //(z-z1)^2,0,0,0
          addps  xmm0, xmm1   //(x-x1)^2+(z-z1)^2, (y-y1)^2, 0, 0
          haddps xmm0, xmm0  //(x-x1)^2+(z-z1)^2 + (y-y1)^2, 0, 0
          //movshdup    xmm1, xmm0
          //addps       xmm0, xmm1
          //movhlps     xmm1, xmm0
          //addss       xmm0, xmm1
       {$else}
          movaps xmm0,[RCX]
          movaps  xmm1, [A]
          subps   xmm0, xmm1
          andps xmm0, [RIP+cSSE_MASK_NO_W]
          mulps   xmm0, xmm0
          haddps xmm0, xmm0
          haddps xmm0, xmm0
          // Instead of haddps :
          //movshdup    xmm1, xmm0
          //addps       xmm0, xmm1
          //movhlps     xmm1, xmm0
          //addss       xmm0, xmm1
       {$endif}
       sqrtss xmm0, xmm0
       // movss [RESULT], {%H-}xmm0
    {$ELSE}
      {$ifdef TEST}
        movq xmm0, [RCX]         // move 64 bits and clear top  x,y,0,0   ** Not working on Win10 64bit
        movq xmm1, [A]           // move 64 bits and clear top  x1,y1,0,0
        subps xmm0, xmm1   // x-x1,y-y1,0,0
        mulps xmm0, xmm0   // (x-x1)^2,(y-y1)^2,0,0
        movss xmm1, [rcx]8      // z,0,0,0
        movss xmm2, [A]8        //z1,0,0,0
        subps  xmm1, xmm2   //z-z1,0,0,0
        mulps  xmm1, xmm1   //(z-z1)^2,0,0,0
        addps  xmm0, xmm1   //(x-x1)^2+(z-z1)^2, (y-y1)^2, 0, 0
        haddps xmm0, xmm0  //(x-x1)^2+(z-z1)^2 + (y-y1)^2, 0, 0
        //movshdup    xmm1, xmm0
        //addps       xmm0, xmm1
        //movhlps     xmm1, xmm0
        //addss       xmm0, xmm1
        sqrtss xmm0, xmm0
      {$else}
         movaps xmm1,[RCX]
         movaps  xmm0, [A]
         subps   xmm1, xmm0
         andps xmm1, [RIP+cSSE_MASK_NO_W]
         mulps   xmm1, xmm1
         movhlps xmm0, xmm1
         addss xmm0, xmm1
         shufps xmm1, xmm1, $55
         addss xmm0, xmm1
         {.$IFDEF USE_ASM_SIMD_HIGHPRECISION}
         // High Precision
         sqrtss xmm0, xmm0
         {.$ELSE
             // Low precision - note : may be very inaccurate
             rsqrtss xmm0, xmm0
             rcpss xmm0, xmm0
         .$ENDIF}
         //movss [RESULT], {%H-}xmm0
       {$ENDIF}
  {$ENDIF}
{$ENDIF}
end;

//function TGLZVector4f.LengthSquare:Single;assembler; nostackframe; register;
function TGLZVector4f.Length:Single;assembler; nostackframe; register;
Asm
  {$IFDEF USE_ASM_SSE_4}
    movaps xmm0,[RCX]
    andps xmm0, [RIP+cSSE_MASK_NO_W]
    dpps xmm0, xmm0, $FF;
    {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
      sqrtss xmm0, xmm0
    {$ELSE}
      // Low precision - note : may be very inaccurate
      rsqrtss xmm0, xmm0
      rcpss xmm0, xmm0
    {$ENDIF}
  {$ELSE}

    {$IFDEF USE_ASM_SSE_3}
      movaps xmm0,[RCX]
      andps xmm0, [RIP+cSSE_MASK_NO_W] //we need to remove W component
      mulps   xmm0, xmm0
      {$ifdef TEST}
        movshdup    xmm1, xmm0
        addps       xmm0, xmm1
        movhlps     xmm1, xmm0
        addss       xmm0, xmm1
      {$else}
        haddps xmm0, xmm0
        haddps xmm0, xmm0
      {$endif}
      {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
        sqrtss xmm0, xmm0
      {$ELSE}
        // Low precision - note : may be very inaccurate
        rsqrtss xmm0, xmm0
        rcpss xmm0, xmm0
      {$ENDIF}
    {$ELSE}
      movaps xmm1,[RCX]
      //andps xmm1, [RIP+cSSE_MASK_NO_W]
      mulps   xmm1, xmm1
      movhlps xmm0, xmm1
      addss xmm0, xmm1
      shufps xmm1, xmm1, $55
      addss xmm0, xmm1
      {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
        sqrtss xmm0, xmm0
      {$ELSE}
          // Low precision - note : may be very inaccurate
          rsqrtss xmm0, xmm0
          rcpss xmm0, xmm0
      {$ENDIF}
    {$ENDIF}
{$ENDIF}
end;

function TGLZVector4f.DistanceSquare(constref A: TGLZVector4f):Single;assembler; nostackframe; register;
Asm

  {$IFDEF USE_ASM_SSE_4}
    movaps xmm0,[RCX]
    movaps  xmm1, [A]
    subps   xmm0, xmm1
    andps xmm0, [RIP+cSSE_MASK_NO_W]
    dpps xmm0, xmm0, $FF
    // movss [RESULT], {%H-}xmm0
  {$ELSE}
    {$IFDEF USE_ASM_SSE_3}
       {$ifdef TEST}
          movq xmm0, [RCX]         // move 64 bits and clear top  x,y,0,0   ** Not working on Win10 64bit
          movq xmm1, [A]           // move 64 bits and clear top  x1,y1,0,0
          subps xmm0, xmm1   // x-x1,y-y1,0,0
          mulps xmm0, xmm0   // (x-x1)^2,(y-y1)^2,0,0
          movss xmm1, [rcx]8      // z,0,0,0
          movss xmm2, [A]8        //z1,0,0,0
          subps  xmm1, xmm2   //z-z1,0,0,0
          mulps  xmm1, xmm1   //(z-z1)^2,0,0,0
          addps  xmm0, xmm1   //(x-x1)^2+(z-z1)^2, (y-y1)^2, 0, 0
          haddps xmm0, xmm0  //(x-x1)^2+(z-z1)^2 + (y-y1)^2, 0, 0
          //movshdup    xmm1, xmm0
          //addps       xmm0, xmm1
          //movhlps     xmm1, xmm0
          //addss       xmm0, xmm1
       {$else}
          movaps xmm0,[RCX]
          movaps  xmm1, [A]
          subps   xmm0, xmm1
          andps xmm0, [RIP+cSSE_MASK_NO_W]
          mulps   xmm0, xmm0
          haddps xmm0, xmm0
          haddps xmm0, xmm0
          // Instead of haddps :
          //movshdup    xmm1, xmm0
          //addps       xmm0, xmm1
          //movhlps     xmm1, xmm0
          //addss       xmm0, xmm1
       {$endif}

       // movss [RESULT], {%H-}xmm0
    {$ELSE}
         movaps xmm1,[RCX]
         movaps  xmm0, [A]
         subps   xmm1, xmm0
         andps xmm1, [RIP+cSSE_MASK_NO_W]
         mulps   xmm1, xmm1
         movhlps xmm0, xmm1
         addss xmm0, xmm1
         shufps xmm1, xmm1, $55
         addss xmm0, xmm1
         //movss [RESULT], {%H-}xmm0
  {$ENDIF}
{$ENDIF}
end;

function TGLZVector4f.LengthSquare:Single;assembler; nostackframe; register;
Asm
  {$IFDEF USE_ASM_SSE_4}
    movaps xmm0,[RCX]
    andps xmm0, [RIP+cSSE_MASK_NO_W]
    dpps xmm0, xmm0, $FF;
  {$ELSE}

    {$IFDEF USE_ASM_SSE_3}
      movaps xmm0,[RCX]
      andps xmm0, [RIP+cSSE_MASK_NO_W] //we need to remove W component
      mulps   xmm0, xmm0
      {$ifdef TEST}
        movshdup    xmm1, xmm0
        addps       xmm0, xmm1
        movhlps     xmm1, xmm0
        addss       xmm0, xmm1
      {$else}
        haddps xmm0, xmm0
        haddps xmm0, xmm0
      {$endif}
    {$ELSE}
      movaps xmm1,[RCX]
      //andps xmm1, [RIP+cSSE_MASK_NO_W]
      mulps   xmm1, xmm1
      movhlps xmm0, xmm1
      addss xmm0, xmm1
      shufps xmm1, xmm1, $55
      addss xmm0, xmm1
    {$ENDIF}
{$ENDIF}
end;

function TGLZVector4f.Spacing(constref A : TGLZVector4f) : Single; assembler; nostackframe; register;
asm
  //Result:=Abs(v2.X-Self.X)+Abs(v2.Y-Self.Y)+Abs(v2.Z-Self.Z)+Abs(v2.W-Self.W);
  movaps xmm1, [RCX]
  movaps xmm0, [A]
  subps xmm0, xmm1
  andps xmm0, [RIP+cSSE_MASK_ABS]
  {$IFDEF USE_ASM_SSE_3}
    {$ifdef TEST}
      movshdup    xmm1, xmm0
      addps       xmm0, xmm1
      movhlps     xmm1, xmm0
      addss       xmm0, xmm1
    {$else}
      haddps xmm0, xmm0
      haddps xmm0, xmm0
    {$endif}
  {$else}
     movhlps xmm1, xmm0            // xmm1 =  - | -  | w  | z  |
     addss xmm1, xmm0              // x + z
     shufps xmm0, xmm0, 00000001b  // xmm0 =  - | -  | -  | y  |
     addss xmm0, xmm1              // (x + z ) + y
     shufps xmm1, xmm1, 01010101b  // xmm1 =  - | -  | -  | w  |
     addss xmm0, xmm1              // (x + z  + y) + w
  {$endif}
end;

function TGLZVector4f.CrossProduct(constref A: TGLZVector4f): TGLZVector4f;assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  movaps xmm1, [A]
  movaps xmm2, xmm0
  movaps xmm3, xmm1

  // shuffle members
  // becarefull at the order in the register (right to left )= w z x y )
  // 1st arg xmm = w z y x = 11 10 01 00
  // 2nd arg xmm = w z y x = 11 10 01 00
  // 3rd arg where to place members of 1st arg in 2nd arg

  shufps xmm0, xmm0, $c9  //w z y x -> $c9 = 11 00 10 01 -> w x z y
  shufps xmm1, xmm1, $d2  //w z y x -> $d2 = 11 01 00 10 -> w y x z

  shufps xmm2, xmm2, $d2
  shufps xmm3, xmm3, $c9
  // scale
  mulps  xmm0, xmm1
  mulps  xmm2, xmm3
  // sub the results
  subps  xmm0, xmm2
 // andps xmm0, [rip+cSSE_MASK_NO_W]
  addps xmm0, [rip+cWOnevector4f] // it would better change by logical operator
  movaps [RESULT], xmm0      // return result
end;

// if the return is > 0 then the angle between the 2 vectors is  > 90° else is < 90°
// Usefull for conputing backface culling and lighting
// https://www.codeproject.com/Articles/21024/Inner-Product-Experiment-CPU-FPU-vs-SSE
function TGLZVector4f.DotProduct(constref A: TGLZVector4f):Single;assembler; nostackframe; register;
asm
  {$IFDEF USE_ASM_SSE_4}
    movaps xmm0,[RCX]
    movaps xmm1, [A]
     // Becarefull at the order of mask Right to Left
     // 4 high bits: which elements should be summed. (w,z,y,x)
     // 4 low bits: which output slots should contain the result. (3,2,1,0)
     // mask =  0111b 0001;
     dpps xmm0, xmm1, 01110001b //or $F1
     //movss [RESULT], {%H-}xmm0
  {$ELSE}
    {$IFDEF USE_ASM_SSE_3}
       movaps xmm1,[RCX]
       movaps xmm0, [A]
       andps xmm1, [RIP+cSSE_MASK_NO_W]
       mulps xmm0, xmm1
      // {$ifdef TEST}
         movshdup    xmm1, xmm0
         addps       xmm0, xmm1
         movhlps     xmm1, xmm0
         addss       xmm0, xmm1
      // {$else}
         //haddps xmm0, xmm0
         //haddps xmm0, xmm0
      // {$endif}
       // movss [RESULT], xmm1
    {$ELSE}
      movaps xmm0,[RCX]
      movaps xmm1, [A]
      andps xmm0, [RIP+cSSE_MASK_NO_W]
      mulps  xmm0, xmm1             //   xmm0 =  w | z  | y  | x  |
      movhlps xmm1, xmm0            //   xmm1 =  - | -  | w  | z  |
      addps xmm1, xmm0              // x + z
      // How to with shufps
      //  In xmm0 =  w | z  | y  | x  |
      //          = 11 | 10 | 01 | 00 |
      // Out xmm0 =  - | -  | -  | Y  |
      //          = 00 | 00 | 00 | 01 | ==> 00000001b
      shufps xmm0, xmm0, 00000001b  //   xmm1 =  - | -  | -  | y  |
      addps xmm0, xmm1              // (x + z ) + y
      // movss [RESULT], {%H-}xmm0
    {$ENDIF}
  {$ENDIF}
end;

function TGLZVector4f.Norm:Single;assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  //andps xmm0, [RIP+cSSE_MASK_NO_W]
  mulps xmm0, xmm0
  movaps xmm1, xmm0
  shufps xmm0, xmm1, $4e
  addps xmm0, xmm1
  shufps xmm1, xmm0, $11
  addps xmm0, xmm1
 // movss [RESULT], {%H-}xmm0
end;

function TGLZVector4f.Normalize: TGLZVector4f;  assembler; nostackframe; register;
asm
// 3 reg usage so could unroll loops 5 at a time in 64bit
  movaps  xmm0, [RCX]
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
 // movhlps xmm1, xmm0          // sf 5.48
  movaps [RESULT], xmm0
end;


function TGLZVector4f.Min(constref B: Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    movlps  xmm1,[B]
  {$else}
    movss  xmm1,[B]
  {$endif}
  shufps xmm1, xmm1, $00 // Replicate B
  minps  xmm0, xmm1
  movaps [RESULT], xmm0
end;

function TGLZVector4f.Min(constref B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    minps  xmm0, [B]
  {$else}
    movaps xmm1, [B]
    minps  xmm0, xmm1
  {$endif}
  movaps [RESULT], xmm0
end;

function TGLZVector4f.Max(constref B: Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    movlps  xmm1,[B]    //|0|0|0|x|
    unpcklps xmm1, xmm1	//|0|0|x|x|
    unpcklps xmm1, xmm1	//|x|x|x|x|
  {$else}
    movss  xmm1,[B]
    shufps xmm1, xmm1, $00 // Replicate B
  {$endif}
  maxps  xmm0, xmm1
  movaps [RESULT], xmm0
end;

function TGLZVector4f.Max(constref B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    maxps  xmm0, [B]
  {$else}
    movaps xmm1, [B]
    maxps  xmm0, xmm1
  {$endif}
  movaps [RESULT], xmm0
end;

function TGLZVector4f.Clamp(constref AMin, AMax: Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    movlps xmm2, [AMin]
    movlps xmm3, [AMax]
  {$else}
    movss xmm2, [AMin]
    movss xmm3, [AMax]
  {$endif}
  shufps xmm2, xmm2, $00
  shufps xmm3, xmm3, $00
  maxps  xmm0, xmm2
  minps  xmm0, xmm3
  movaps [RESULT], xmm0
end;

function TGLZVector4f.Clamp(Constref AMin, AMax: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    maxps  xmm0, [AMin]
    minps  xmm0, [AMax]
  {$else}
    movaps xmm1, [AMin]
    movaps xmm2, [AMax]
    maxps  xmm0, xmm1
    minps  xmm0, xmm2
  {$endif}
  movaps [RESULT], xmm0
end;

function TGLZVector4f.MulAdd(Constref B, C: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    mulps  xmm0, [B]
    addps  xmm0, [C]
  {$else}
    movaps xmm1, [B]
    movaps xmm2, [C]
    mulps  xmm0, xmm1
    addps  xmm0, xmm2
  {$endif}
  movaps [RESULT], xmm0
end;

function TGLZVector4f.MulDiv(Constref B, C: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    mulps  xmm0, [B]
    Divps  xmm0, [C]
  {$else}
    movaps xmm1, [B]
    movaps xmm2, [C]
    mulps  xmm0, xmm1
    Divps  xmm0, xmm2
  {$endif}
  movaps [RESULT], xmm0
end;

function TGLZVector4f.Lerp(Constref B: TGLZVector4f; Constref T:Single): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  movups xmm1, [B]
  {$ifdef TEST}
    movlps  xmm2,[T]
  {$else}
    movss  xmm2,[T]
  {$endif}
  shufps xmm2,xmm2,0
  andps xmm2, [RIP+cSSE_MASK_NO_W]
  subps xmm1,xmm0
  mulps xmm1, xmm2
  addps xmm0, xmm1
  movaps [RESULT], xmm0
end;

function TGLZVector4f.AngleCosine(constref A : TGLZVector4f): Single; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  movups xmm1,[A]
  movaps xmm2, xmm0 // Coypy Self
  movaps xmm4, xmm1 // Copy A

 // DotProd in xmm0 Result in xmm3
 {$IFDEF USE_ASM_SSE_4}
    dpps xmm0, xmm1, 01110001b //or $F1
    movaps xmm3,xmm0
 {$ELSE}
   {$IFDEF USE_ASM_SSE_3}
     andps xmm0, [RIP+cSSE_MASK_NO_W]
     mulps xmm1, xmm0
     haddps xmm1, xmm1
     haddps xmm1, xmm1
     movaps xmm3,xmm1
   {$ELSE}
     mulps  xmm1, xmm0
     movhlps xmm0, xmm1
     addps xmm0, xmm1
     shufps xmm1, xmm1, 00000001b
     addps xmm1, xmm0
     movaps xmm3, xmm1
   {$ENDIF}
 {$ENDIF}
  // Length Self in xmm2 result in xmm2
  andps xmm2, [RIP+cSSE_MASK_NO_W]
  {$IFDEF USE_ASM_SSE_4}
    dpps xmm2, xmm2, $FF;
    sqrtss xmm2, xmm2
  {$ELSE}
    mulps   xmm2, xmm2
    {$IFDEF USE_ASM_SSE_3}
      haddps xmm2, xmm2
      haddps xmm2, xmm2
      sqrtss xmm2, xmm2
    {$ELSE}
      movhlps xmm1, xmm2
      addss xmm1, xmm2
      shufps xmm2, xmm2, $55
      addss xmm1, xmm2
      sqrtss xmm2, xmm1
    {$ENDIF}
  {$ENDIF}
  // Lenght A in xmm4 result in xmm4
  andps xmm4, [RIP+cSSE_MASK_NO_W]
  {$IFDEF USE_ASM_SSE_4}
    dpps xmm4, xmm4, $FF;
    sqrtss xmm4, xmm4
  {$ELSE}
    mulps   xmm4, xmm4
    {$IFDEF USE_ASM_SSE_3}
      haddps xmm4, xmm4
      haddps xmm4, xmm4
      sqrtss xmm4, xmm4
    {$ELSE}
      movhlps xmm1, xmm4
      addss xmm1, xmm4
      shufps xmm4, xmm4, $55
      addss xmm1, xmm4
      sqrtss xmm4, xmm1
    {$ENDIF}
  {$ENDIF}
  mulps xmm2,xmm4
  divps xmm3, xmm2
  //movss [RESULT], {%H-}xmm3
  movss xmm0, xmm3
end;

function TGLZVector4f.AngleBetween(Constref A, ACenterPoint : TGLZVector4f): Single;
Var
  vResult  :  Single;
begin
  asm
    movaps xmm0,[RCX]       //self is still in rcx
    mov rax, [A]            // A is a pointer on the stack
    movups xmm1, [RAX]
    mov rax, [ACenterPoint] // ACenterPoint is a pointer on the stack
    movups xmm2, [RAX]
    subps xmm0, xmm2
    subps xmm1, xmm2

    // Normalize xmm0 result in xmm2
    movaps xmm3,xmm0
    andps  xmm3, [RIP+cSSE_MASK_ONLY_W]
    andps  xmm0, [RIP+cSSE_MASK_NO_W]
    movaps xmm2, xmm0
    {$IFDEF USE_ASM_SSE_3}
      mulps  xmm0, xmm0
      haddps xmm0, xmm0
      haddps xmm0, xmm0
    {$ELSE}
      mulps xmm0, xmm0
      movaps xmm5, xmm0
      shufps xmm0, xmm5, $4e
      addps xmm0, xmm5
      movaps xmm5, xmm0
      shufps xmm5, xmm5, $11
      addps xmm0, xmm5
    {$ENDIF}
    {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
      // High Precision
      sqrtps xmm0, xmm0
      divps xmm2, xmm0
    {$ELSE}
      // Low precision
      rsqrtps xmm0, xmm0       //approximate reciprocal
      mulps xmm2, xmm0
    {$ENDIF}
    addps xmm2,xmm3
    // Normalize xmm1 result in xmm4
    movaps xmm3,xmm1
    andps  xmm3, [RIP+cSSE_MASK_ONLY_W]
    andps  xmm1, [RIP+cSSE_MASK_NO_W]
    movaps xmm4, xmm1
    {$IFDEF USE_ASM_SSE_3}
      mulps  xmm1, xmm1
      haddps xmm1, xmm1
      haddps xmm1, xmm1
    {$ELSE}
      mulps xmm1, xmm1
      movaps xmm5, xmm1
      shufps xmm1, xmm5, $4e
      addps xmm1, xmm5
      movaps xmm5, xmm1
      shufps xmm5, xmm5, $11
      addps xmm1, xmm5
    {$ENDIF}
    {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
      // High Precision
      sqrtps xmm1, xmm1
      divps xmm4, xmm1
    {$ELSE}
      // Low precision
      rsqrtps xmm1, xmm1       //approximate reciprocal
      mulps xmm4, xmm1
    {$ENDIF}
    addps xmm4,xmm3

    // AngleCosine
    movaps xmm1, xmm4
    movaps xmm0, xmm2 // Copy A

   // DotProd  xmm0/xmm1 Result in xmm3
   {$IFDEF USE_ASM_SSE_4}
      dpps xmm0, xmm1, 01110001b //or $F1
      movaps xmm3,xmm0
   {$ELSE}
     {$IFDEF USE_ASM_SSE_3}
       andps xmm0, [RIP+cSSE_MASK_NO_W]
       mulps xmm1, xmm0
       haddps xmm1, xmm1
       haddps xmm1, xmm1
       movaps xmm3,xmm1
     {$ELSE}
       mulps  xmm1, xmm0
       movhlps xmm0, xmm1
       addps xmm0, xmm1
       shufps xmm1, xmm1, 00000001b
       addps xmm1, xmm0
       movaps xmm3, xmm1
     {$ENDIF}
   {$ENDIF}
    // Length xmm2 result in xmm2
    andps xmm2, [RIP+cSSE_MASK_NO_W]
    {$IFDEF USE_ASM_SSE_4}
      dpps xmm2, xmm2, $FF;
      sqrtss xmm2, xmm2
    {$ELSE}
      mulps   xmm2, xmm2
      {$IFDEF USE_ASM_SSE_3}
        haddps xmm2, xmm2
        haddps xmm2, xmm2
        sqrtss xmm2, xmm2
      {$ELSE}
        movhlps xmm1, xmm2
        addss xmm1, xmm2
        shufps xmm2, xmm2, $55
        addss xmm1, xmm2
        sqrtss xmm2, xmm1
      {$ENDIF}
    {$ENDIF}
    // Lenght  xmm4 result in xmm4
    andps xmm4, [RIP+cSSE_MASK_NO_W]
    {$IFDEF USE_ASM_SSE_4}
      dpps xmm4, xmm4, $FF;
      sqrtss xmm4, xmm4
    {$ELSE}
      mulps   xmm4, xmm4
      {$IFDEF USE_ASM_SSE_3}
        haddps xmm4, xmm4
        haddps xmm4, xmm4
        sqrtss xmm4, xmm4
      {$ELSE}
        movhlps xmm1, xmm4
        addss xmm1, xmm4
        shufps xmm4, xmm4, $55
        addss xmm1, xmm4
        sqrtss xmm4, xmm1
      {$ENDIF}
    {$ENDIF}
    mulps xmm2,xmm4
    divps xmm3, xmm2
    movss [vResult], {%H-}xmm3
  end;
  Result := ArcCos(vResult);
end;

function TGLZVector4f.Combine(constref V2: TGLZVector4f; constref F1: Single): TGLZVector4f;assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  movaps xmm1, [V2]
  {$ifdef TEST}
    movlps  xmm2,[F1]
  {$else}
    movss  xmm2,[F1]
  {$endif}
  shufps xmm2, xmm2, $00 // replicate

  mulps xmm1, xmm2 //V2*F1
  addps xmm0, xmm1 // Self + (V2*F1)

  andps xmm0, [RIP+cSSE_MASK_NO_W]
  movaps [RESULT], xmm0
end;

function TGLZVector4f.Combine2(constref V2: TGLZVector4f; const F1, F2: Single): TGLZVector4f;assembler; // nostackframe; register;
asm
  movaps xmm0,[RCX]
  movaps xmm1, [V2]
  {$ifdef TEST}
    movss xmm2, [F2{%H-}]
  {$else}
    movss xmm2, [F2{%H-}]
  {$endif}


  shufps xmm2, xmm2, $00 // replicate
  shufps xmm3, xmm3, $00 // replicate F1 already there

  mulps xmm0, xmm3  // Self * F1
  mulps xmm1, xmm2  // V2 * F2

  addps xmm0, xmm1  // (Self * F1) + (V2 * F2)

  andps xmm0, [RIP+cSSE_MASK_NO_W]
  //movhlps xmm1,xmm0
  movups [RESULT], xmm0

end;

function TGLZVector4f.Combine3(constref V2, V3: TGLZVector4f; const F1, F2, F3: Single): TGLZVector4f;  assembler; //nostackframe; register;
asm
  movaps xmm0,[RCX]

  movaps xmm1, [V2]
  movaps xmm4, [V3]
  {$ifdef TEST}
    movlps xmm2, [F1{%H-}]
    movlps xmm3, [F2{%H-}]
    movlps xmm5, [F3{%H-}]
  {$else}
    movss xmm2, [F1{%H-}]
    movss xmm3, [F2{%H-}]
    movss xmm5, [F3{%H-}]
  {$endif}

  shufps xmm2, xmm2, $00 // replicate
  shufps xmm3, xmm3, $00 // replicate
  shufps xmm5, xmm5, $00 // replicate

  mulps xmm0, xmm2 // Self * F1
  mulps xmm1, xmm3 // V2 * F2
  mulps xmm4, xmm5 // V3 * F3

  addps xmm0, xmm1 // (Self * F1) + (V2 * F2)
  addps xmm0, xmm4 // ((Self * F1) + (V2 * F2)) + (V3 * F3)

  andps xmm0, [RIP+cSSE_MASK_NO_W]
  movups [RESULT], xmm0
end;

function TGLZVector4f.Round: TGLZVector4i;assembler;nostackframe;register;
asm
  // Rounding mode defaults to round-to-nearest
  movaps     xmm0, [RCX]
  cvtps2dq xmm0, xmm0
  movaps     [RESULT], xmm0
end;


function TGLZVector4f.Trunc: TGLZVector4i;assembler;nostackframe;register;
asm
  movaps     xmm0, [RCX]
  {$i macro_sse_win64_trunc_xmm0-xmm0.inc}
  movaps     [RESULT], xmm0
end;

{%endregion%}

{%region%----[ Operations on Self ]-----------------------------------------------}

procedure TGLZVector4f.pAdd(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
   movaps xmm0,[RCX]
   {$ifdef TEST}
     addps  xmm0,[A]
   {$else}
     movaps xmm1,[A]
     addps  xmm0, xmm1
   {$endif}
   movaps [RCX],xmm0
End;

procedure TGLZVector4f.pSub(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
   movaps xmm0,[RCX]
   {$ifdef TEST}
     subps  xmm0,[A]
   {$else}
     movaps xmm1,[A]
     subps  xmm0, xmm1
   {$endif}
   movaps [RCX],xmm0
End;

procedure TGLZVector4f.pMul(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
   movaps xmm0,[RCX]
   {$ifdef TEST}
     mulps  xmm0,[A]
   {$else}
     movaps xmm1,[A]
     mulps  xmm0, xmm1
   {$endif}
   movaps [RCX],xmm0
End;

procedure TGLZVector4f.pDiv(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
   movaps xmm0,[RCX]
   {$ifdef TEST}
     {$ifdef USE_ASM_SIMD_HIGHPRECISION}
        divps  xmm0,[A]
     {$else}
       movaps xmm1,[A]
       rcpps  xmm1, xmm1
       mulps  xmm0,xmm1
     {$endif}
   {$else}
     movaps xmm1,[A]
     {$ifdef USE_ASM_SIMD_HIGHPRECISION}
        divps  xmm0,xmm1
     {$else}
       rcpps  xmm1, xmm1
       mulps  xmm0,xmm1
     {$endif}
   {$endif}
   movaps [RCX],xmm0
End;

procedure TGLZVector4f.pAdd(constref A: Single); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    movlps  xmm1,[A]
  {$else}
    movss  xmm1,[A]
  {$endif}
  shufps xmm1, xmm1,0
  addps  xmm0, xmm1
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pSub(constref A: Single); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    movlps  xmm1,[A]
  {$else}
    movss  xmm1,[A]
  {$endif}
  shufps xmm1, xmm1,0
  subps  xmm0, xmm1
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pMul(constref A: Single); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    movlps  xmm1,[A]
  {$else}
    movss  xmm1,[A]
  {$endif}
  shufps xmm1, xmm1,0
  mulps  xmm0, xmm1
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pDiv(constref A: Single); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    movlps  xmm1,[A]
  {$else}
    movss  xmm1,[A]
  {$endif}
  shufps xmm1, xmm1,0
  divps  xmm0, xmm1
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pInvert;assembler; nostackframe; register;
asm
//  movaps xmm1,[RCX]
  movaps xmm0, [RIP+cNullVector4f]
  subps xmm0,[RCX] //xmm1
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pNegate; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    xorps xmm0, [RIP+cSSE_MASK_NEGATE]
  {$else}
    movaps xmm1, [RIP+cSSE_MASK_NEGATE]
    xorps xmm0, xmm1
  {$endif}
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pAbs; assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    andps    xmm0, [RIP+cSSE_MASK_ABS]
  {$else}
    movaps   xmm1, [RIP+cSSE_MASK_ABS]
    andps    xmm0, xmm1
  {$endif}
  movaps   [RCX], xmm0
end;

procedure TGLZVector4f.pDivideBy2;assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
      mulps xmm0,[RIP+cHalfOneVector4f]
  {$else}
     movaps xmm1, [RIP+cHalfOneVector4f]
     mulps xmm0, xmm1
  {$endif}
  movaps [RCX],xmm0
end;

procedure TGLZVector4f.pCrossProduct(constref A: TGLZVector4f);assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]

  movaps xmm1, [A]
  movaps xmm2, xmm0
  movaps xmm3, xmm1

  // shuffle members
  // becarefull at the order in the register (right to left )= w z x y )
  // 1st arg xmm = w z y x = 11 10 01 00
  // 2nd arg xmm = w z y x = 11 10 01 00
  // 3rd arg where to place members of 1st arg in 2nd arg
  // becarefull reading from right to left

  shufps xmm0, xmm0, $c9  //w z y x -> $c9 = 11 00 10 01 -> w x z y
  shufps xmm1, xmm1, $d2  //w z y x -> $d2 = 11 01 00 10 -> w y x z
  shufps xmm2, xmm2, $d2
  shufps xmm3, xmm3, $c9
  // scale
  mulps  xmm0, xmm1
  mulps  xmm2, xmm3
  // sub the results
  subps  xmm0, xmm2

  andps xmm0, [rip+cSSE_MASK_NO_W]
  addps xmm0, [rip+cWOnevector4f] // it would better change by logical operator
  //movhlps xmm1,xmm0
  movaps [RCX], xmm0
end;

procedure TGLZVector4f.pNormalize;  assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  movaps xmm3,xmm0
  andps  xmm3, [RIP+cSSE_MASK_ONLY_W]
  andps  xmm0, [RIP+cSSE_MASK_NO_W]
  movaps xmm2, xmm0
  {$IFDEF USE_ASM_SSE_3}
    mulps  xmm0, xmm0
    haddps xmm0, xmm0
    haddps xmm0, xmm0
  {$ELSE}
    mulps xmm0, xmm0
    movaps xmm1, xmm0
    shufps xmm0, xmm1, $4e
    addps xmm0, xmm1
    movaps xmm1, xmm0
    shufps xmm1, xmm1, $11
    addps xmm0, xmm1
  {$ENDIF}
  {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
    // High Precision
    sqrtps xmm0, xmm0
    divps xmm2, xmm0
  {$ELSE}
    // Low precision
    rsqrtps xmm0, xmm0       //approximate reciprocal
    mulps xmm2, xmm0
  {$ENDIF}
  addps xmm2,xmm3
  movaps [RCX], xmm2
end;

procedure TGLZVector4f.pMin(constref B: TGLZVector4f); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    minps  xmm0, [B]
  {$else}
    movaps xmm1, [B]
    minps  xmm0, xmm1
  {$endif}
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pMin(constref B: Single); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  movlps xmm1, [B]
  shufps xmm1,  xmm1, $00
  minps  xmm0, xmm1
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pMax(constref B: TGLZVector4f); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    maxps  xmm0, [B]
  {$else}
    movaps xmm1, [B]
    maxps  xmm0, xmm1
  {$endif}
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pMax(constref B: Single); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  movlps xmm1, [B]
  shufps xmm1, xmm1, $00
  maxps  xmm0, xmm1
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pClamp(Constref AMin, AMax: TGLZVector4f); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    maxps  xmm0, [AMin]
    minps  xmm0, [AMax]
  {$else}
    movaps xmm2, [AMin]
    movaps xmm3, [AMax]
    maxps  xmm0, xmm2
    minps  xmm0, xmm3
  {$endif}
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pClamp(constref AMin, AMax: Single); assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    movlps xmm2, [AMin]
    movlps xmm3, [AMax]
  {$else}
    movss xmm2, [AMin]
    movss xmm3, [AMax]
  {$endif}
  shufps xmm2, xmm2, 0 //xmm2, $00 // Replicate AMin
  shufps xmm3, xmm3,0 //xmm3, $00 // Replicate AMax
  maxps  xmm0, xmm2
  minps  xmm0, xmm3
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pMulAdd(Constref B, C: TGLZVector4f); assembler; nostackframe; register; // (Self*B)+c
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    mulps  xmm0, [B]
    addps  xmm0, [C]
  {$else}
    movaps xmm1, [B]
    movaps xmm2, [C]
    mulps  xmm0, xmm1
    addps  xmm0, xmm2
  {$endif}
  movaps [RCX],xmm0
End;

procedure TGLZVector4f.pMulDiv(Constref B, C: TGLZVector4f); assembler; nostackframe; register; // (Self*B)-c
asm
  movaps xmm0,[RCX]
  {$ifdef TEST}
    mulps  xmm0, [B] //xmm1
    Divps  xmm0, [C] //xmm2
  {$else}
    movaps xmm1, [B]
    movaps xmm2, [C]
    mulps  xmm0, xmm1
    Divps  xmm0, xmm2
  {$endif}
  movaps [RCX],xmm0
End;

{%endregion%}
