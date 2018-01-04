{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZVector4i.+(constref A, B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  {$ifdef TEST}
    addps  xmm0,[B]
  {$else}
    movaps xmm1,[B]
    paddd  xmm0, xmm1
  {$endif}
  movaps [RESULT], xmm0
end;

class operator TGLZVector4i.-(constref A, B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  {$ifdef TEST}
    psubd  xmm0,[B]
  {$else}
    movdqa xmm1,[B]
    psubd  xmm0, xmm1
  {$endif}
  movaps [RESULT], xmm0
end;

class operator TGLZVector4i.*(constref A, B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  {$ifdef TEST}
    mulps  xmm0,[B]
  {$else}
    movdqa xmm1,[B]
    PMULUDQ  xmm0, xmm1
  {$endif}
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.div(constref A, B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  {$ifdef TEST}
    movdqa xmm0,[A]
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
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.+(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  {$ifdef TEST}
    movlps  xmm1,[B]
  {$else}
    movss  xmm1,[B]
  {$endif}
  shufps xmm1, xmm1, $00
  paddd  xmm0,xmm1
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.-(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  {$ifdef TEST}
    movlps  xmm1,[B]
  {$else}
    movss  xmm1,[B]
  {$endif}
  shufps xmm1, xmm1, $00
  psubd  xmm0, xmm1
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.*(constref A: TGLZVector4i; constref B:Single): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm2,[A]
  cvtdq2ps xmm0, xmm2
  {$ifdef TEST}
    movlps  xmm1,[B]
  {$else}
    movss  xmm1,[B]
  {$endif}
  shufps xmm1, xmm1, $00
//  PMULUDQ  xmm0, xmm1
  mulps xmm0, xmm1
  cvtps2dq xmm0, xmm0 // default round
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.*(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  movdqa xmm0,[B]
  shufps xmm1, xmm1, $00
  PMULUDQ  xmm0, xmm1
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.Div(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  {$ifdef TEST}
    movlps  xmm1,[B]
  {$else}
    movss  xmm1,[B]
  {$endif}
    shufps xmm1, xmm1, $00
  //  PDIVUDQ  xmm0,xmm1

  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.-(constref A: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm1,[A]
  movdqa xmm0,[RIP+cNullVector4i]
  psubd  xmm0,xmm1
  movdqa [RESULT],xmm0
End;

class operator TGLZVector4i.= (constref A, B: TGLZVector4i): boolean; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  {$ifdef TEST}
//    movaps xmm1,[B]

    //cmpps  xmm0, [B], cSSE_OPERATOR_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 0 = Operator Equal
    PCMPEQD   xmm0, [B]
  {$else}
    movdqa xmm1,[B]
    cmpps  xmm0, xmm1, cSSE_OPERATOR_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 0 = Operator Equal
  {$endif}
  movmskps eax, xmm0
  xor eax, $F
  setz al
end;


class operator TGLZVector4i.<> (constref A, B: TGLZVector4i): boolean; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
 // movdqa xmm1,[B]
  //cmpps  xmm0, xmm1, cSSE_OPERATOR_NOT_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 4 = Operator Not Equal
  PCMPEQD  xmm0, [B]
  movmskps eax, xmm0
  or eax, $f  //xor
  setz al
end;

{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector4i.Abs: TGLZVector4i; assembler; nostackframe; register;
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

function TGLZVector4i.DivideBy2:TGLZVector4i;assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  PSRLD xmm0, 1
  movaps [RESULT],xmm0
end;

function TGLZVector4i.Min(constref B: Longint): TGLZVector4i; assembler; nostackframe; register;
asm
 xorps xmm0,xmm0
end;

function TGLZVector4i.Min(constref B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
 xorps xmm0,xmm0
end;

function TGLZVector4i.Max(constref B: Longint): TGLZVector4i; assembler; nostackframe; register;
asm
 xorps xmm0,xmm0
end;

function TGLZVector4i.Max(constref B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
xorps xmm0,xmm0
end;

function TGLZVector4i.Clamp(constref AMin, AMax: Longint): TGLZVector4i; assembler; nostackframe; register;
asm
xorps xmm0,xmm0
end;

function TGLZVector4i.Clamp(Constref AMin, AMax: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
xorps xmm0,xmm0
end;

function TGLZVector4i.MulAdd(Constref B, C: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
xorps xmm0,xmm0
end;

function TGLZVector4i.MulDiv(Constref B, C: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
xorps xmm0,xmm0
end;

(* function TGLZVector4i.Combine(constref V2: TGLZVector4i; constref F1: Single): TGLZVector4i;assembler; nostackframe; register;
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

function TGLZVector4i.Combine2(constref V2: TGLZVector4i; const F1, F2: Single): TGLZVector4i;assembler; nostackframe; register;
asm
  movaps xmm0,[RCX]
  movaps xmm1, [V2]
  {$ifdef TEST}
    movlps xmm2, [F2{%H-}]
  {$else}
    movss xmm2, [F2{%H-}]
  {$endif}


  shufps xmm2, xmm2, $00 // replicate
  shufps xmm3, xmm3, $00 // replicate F1 already there

  mulps xmm0, xmm3  // Self * F1
  mulps xmm1, xmm2  // V2 * F2

  addps xmm0, xmm1  // (Self * F1) + (V2 * F2)

  andps xmm0, [RIP+cSSE_MASK_NO_W]
  movhlps xmm1,xmm0
  //movups [RESULT], xmm0

end;

function TGLZVector4i.Combine3(constref V2, V3: TGLZVector4i; const F1, F2, F3: Single): TGLZVector4i;  assembler; nostackframe; register;
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
  movhlps xmm1,xmm0
  //movups [RESULT], xmm0
end; *)



{%endregion%}

{%region%----[ Operations on Self ]-----------------------------------------------}



{%endregion%}
