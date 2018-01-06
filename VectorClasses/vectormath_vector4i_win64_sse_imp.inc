{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZVector4i.+(constref A, B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  {$ifdef TEST}
    paddd  xmm0,[B]
  {$else}
    movaps xmm1,[B]
    paddd  xmm0, xmm1
  {$endif}
  movdqa [RESULT], xmm0
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
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.*(constref A, B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  movdqa  xmm1,[B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  mulps  xmm0,xmm1
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.div(constref A, B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  movdqa xmm1,[B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  divps  xmm0,xmm1
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.+(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  movd  xmm1,[B]
  pshufd xmm1, xmm1, $00
  paddd  xmm0,xmm1
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.-(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  movd  xmm1,[B]
  pshufd xmm1, xmm1, $00
  psubd  xmm0, xmm1
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.*(constref A: TGLZVector4i; constref B:Single): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  cvtdq2ps xmm0,xmm0
  movlps  xmm1,[B]
  shufps xmm1, xmm1, $00
  mulps  xmm0,xmm1
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.*(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  movd  xmm1,[B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  shufps xmm1, xmm1, $00
  mulps  xmm0,xmm1
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

class operator TGLZVector4i.Div(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[A]
  movd  xmm1,[B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  shufps xmm1, xmm1, $00
  divps xmm0,xmm1
  cvtps2dq xmm0, xmm0
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
//  PCMPNED
  pcmpeqd  xmm0, [B]
  movmskps eax, xmm0
  or eax, $f  //xor
  setz al
end;

{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector4i.Abs: TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  andps    xmm0, [RIP+cSSE_MASK_ABS]
  movdqa   [RESULT], xmm0
end;

function TGLZVector4i.DivideBy2:TGLZVector4i;assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  PSRLD xmm0, 1
  movdqa [RESULT],xmm0
end;

(*function TGLZVector4i.Make(constref x,y,z:Integer;Constref w:Integer =1); assembler; nostackframe; register;
asm
  movd        xmm0,dword ptr [C3]
  movd        xmm1,dword ptr[C2]
  movd        xmm2,dword ptr[C1]
  movd        xmm3,dword ptr[C0]
  punpckldq   xmm3,xmm1
  punpckldq   xmm2,xmm0
  punpckldq   xmm3,xmm2 // XMM3 = vTemp
  // Mask off the low bits
  PAND    XMM3, [g_vMask1] // vTemp = _mm_and_si128(vTemp,g_vMask1);
  // 0xFFFFFFFF on true bits
  PCMPEQD XMM3, [g_vMask1] // vTemp = _mm_cmpeq_epi32(vTemp,g_vMask1);
  // 0xFFFFFFFF -> 1.0f, 0x00000000 -> 0.0f
  PAND    XMM3, [g_XMOne] // vTemp = _mm_and_si128(vTemp,g_XMOne);
  MOVUPS  TXMVECTOR([result]), XMM3// return _mm_castsi128_ps(vTemp);
end;  *)

function TGLZVector4i.Min(constref B: Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  movd  xmm1,[B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  shufps xmm1, xmm1, $00
  minps  xmm0,xmm1
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

function TGLZVector4i.Min(constref B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  movdqa  xmm1,[B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  minps  xmm0,xmm1
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

function TGLZVector4i.Max(constref B: Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  movd  xmm1,[B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  shufps xmm1, xmm1, $00
  maxps  xmm0,xmm1
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

function TGLZVector4i.Max(constref B: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  movdqa  xmm1,[B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  maxps  xmm0,xmm1
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

function TGLZVector4i.Clamp(constref AMin, AMax: Longint): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  cvtdq2ps xmm0,xmm0
  {$IFDEF TEST}
  movd  xmm1,[AMin]     //|0|0|0|x|
  punpckldq xmm1, xmm1	//|0|0|x|x|
  punpckldq xmm1, xmm1	//|x|x|x|x|
  movd  xmm2,[AMax]
  punpckldq xmm2, xmm2
  punpckldq xmm2, xmm2
  cvtdq2ps xmm1,xmm1
  cvtdq2ps xmm2,xmm2
  {$else}
  movd  xmm1,[AMin]
  cvtdq2ps xmm1,xmm1
  shufps xmm1, xmm1, $00
  movd  xmm2,[AMax]
  cvtdq2ps xmm2,xmm2
  shufps xmm2, xmm2, $00
  {$endif}
  maxps  xmm0,xmm1
  minps xmm0,xmm2
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

function TGLZVector4i.Clamp(Constref AMin, AMax: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  movdqa  xmm1,[AMin]
  movdqa  xmm2,[AMax]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  cvtdq2ps xmm2,xmm2
  maxps  xmm0,xmm1
  minps xmm0,xmm2
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

function TGLZVector4i.MulAdd(Constref B, C: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  movdqa  xmm1,[B]
  movdqa  xmm2,[C]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  cvtdq2ps xmm2,xmm2
  mulps  xmm0, xmm1
  addps  xmm0, xmm2
  cvtps2dq xmm0, xmm0
  movdqa [RESULT], xmm0
end;

function TGLZVector4i.MulDiv(Constref B, C: TGLZVector4i): TGLZVector4i; assembler; nostackframe; register;
asm
  push rax
  movdqa xmm0,[RCX]
  movdqa  xmm1,[B]
  movdqa  xmm2,[C]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  cvtdq2ps xmm2,xmm2
 // andps xmm2,[RIP+ cOneVector4f]
  mulps  xmm0, xmm1
  divps  xmm0, xmm2
  {$i macro_sse_win64_trunc_xmm0-xmm0.inc} //RAISE A SIGFPE WITH TIMING TEST
  movdqa [RESULT], xmm0
  pop rax
end;

 function TGLZVector4i.Combine(constref V2: TGLZVector4i; constref F1: Single): TGLZVector4i;assembler; nostackframe; register;
asm
  movdqa xmm0,[RCX]
  movdqa  xmm1,[V2]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  movlps  xmm2,[F1]

  //shufps xmm2, xmm2, $00 // replicate
  unpcklps xmm2, xmm2
  unpcklps xmm2, xmm2

  mulps xmm1, xmm2 //V2*F1
  addps xmm0, xmm1 // Self + (V2*F1)

  andps xmm0, [RIP+cSSE_MASK_NO_W]
  {$i macro_sse_win64_trunc_xmm0-xmm0.inc} //RAISE A SIGFPE WITH TIMING TEST
  movdqa [RESULT], xmm0
end;

(* function TGLZVector4i.Combine2(constref V2: TGLZVector4i; const F1, F2: Single): TGLZVector4i;assembler; nostackframe; register;
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
