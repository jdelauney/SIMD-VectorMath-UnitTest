{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZVector2i.+(constref A, B: TGLZVector2i): TGLZVector2i; assembler; nostackframe; register;
asm
  movq  xmm0, [A]
  movq  xmm1, [B]
  paddd xmm0, xmm1
  movq  RAX, {%H-}xmm0
end;

class operator TGLZVector2i.-(constref A, B: TGLZVector2i): TGLZVector2i; assembler; nostackframe; register;
asm
  movq  xmm0, [A]
  movq  xmm1, [B]
  psubd  xmm0, xmm1
  movq  RAX, {%H-}xmm0
end;

class operator TGLZVector2i.*(constref A, B: TGLZVector2i): TGLZVector2i; assembler; nostackframe; register;
asm
  movq  xmm0, [A]
  movq  xmm1, [B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  mulps  xmm0,xmm1
  cvtps2dq xmm0, xmm0 //Round
  movq  RAX, {%H-}xmm0
end;


class operator TGLZVector2i.Div(constref A, B: TGLZVector2i): TGLZVector2i; assembler; nostackframe; register;
asm
  movq  xmm0, [A]
  movq  xmm1, [B]
  cvtdq2ps xmm0,xmm0
  cvtdq2ps xmm1,xmm1
  divps  xmm0,xmm1

 //cvtps2dq xmm0, xmm0
  push rcx
  {$i macro_sse_win64_trunc_xmm0-xmm0.inc}
  pop rcx

  movq  RAX, {%H-}xmm0
end;

class operator TGLZVector2i.+(constref A: TGLZVector2i; constref B:Single): TGLZVector2i; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  pshufd xmm1, xmm1, $00
  paddd xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;
          class operator TGLZVector2i.+(constref A: TGLZVector2i; constref B:Integer): TGLZVector2i; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  pshufd xmm1, xmm1, $00
  paddd xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;

class operator TGLZVector2i.-(constref A: TGLZVector2i; constref B:Single): TGLZVector2i; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  pshufd xmm1, xmm1, $00
  psubd  xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;

class operator TGLZVector2i.-(constref A: TGLZVector2i; constref B:Integer): TGLZVector2i; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  pshufd xmm1, xmm1, $00
  psubd  xmm0, xmm1
  movq   RAX, {%H-}xmm0
end;

class operator TGLZVector2i.*(constref A: TGLZVector2i; constref B:Single): TGLZVector2i; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  cvtdq2ps xmm0, xmm0
  shufps xmm1, xmm1, $00
  mulps  xmm0, xmm1
  cvtps2dq xmm0, xmm0
  movq   RAX, {%H-}xmm0
end;

class operator TGLZVector2i./(constref A: TGLZVector2i; constref B:Single): TGLZVector2i; assembler; nostackframe; register;
asm
  movq   xmm0, [A]
  movq   xmm1, [B]
  cvtdq2ps xmm0, xmm0
  shufps xmm1, xmm1, $00
  divps  xmm0, xmm1
  cvtps2dq xmm0, xmm0
  movq   RAX, {%H-}xmm0
end;

class operator TGLZVector2i.Div(constref A: TGLZVector2i; constref B:Integer): TGLZVector2i; assembler; register; nostackframe;
asm
  movq     xmm0, [A]
  movq     xmm1, [B]
  cvtdq2ps xmm0, xmm0
  cvtdq2ps xmm1, xmm1
  shufps   xmm1, xmm1, $00
  divps    xmm0, xmm1
  push rcx
  {$i macro_sse_win64_trunc_xmm0-xmm0.inc}
  pop rcx
  movq   RAX, {%H-}xmm0
end;


{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector2i.Min(constref B: Integer): TGLZVector2i; assembler; nostackframe; register;
asm
  movq   xmm0, [RCX]
  movd     xmm1, [B]
  cvtdq2ps xmm0, xmm0
  cvtdq2ps xmm1, xmm1
  shufps   xmm1, xmm1, $00
  minps    xmm0,xmm1
  cvtps2dq xmm0, xmm0
  movq     RAX, {%H-}xmm0
end;

function TGLZVector2i.Min(constref B: TGLZVector2i): TGLZVector2i;assembler; nostackframe; register;
asm
  movq  xmm0, [RCX]
  movq     xmm1, [B]
  cvtdq2ps xmm0, xmm0
  cvtdq2ps xmm1, xmm1
  minps    xmm0, xmm1
  cvtps2dq xmm0, xmm0
  movq     RAX, {%H-}xmm0
end;


function TGLZVector2i.Max(constref B: Integer): TGLZVector2i;assembler; nostackframe; register;
asm
  movq     xmm0, [RCX]
  movq     xmm1, [B]
  cvtdq2ps xmm0, xmm0
  cvtdq2ps xmm1, xmm1
  shufps   xmm1, xmm1, $00
  maxps    xmm0, xmm1
  cvtps2dq xmm0, xmm0
  movq     RAX, {%H-}xmm0
end;

function TGLZVector2i.Max(constref B: TGLZVector2i): TGLZVector2i;assembler; nostackframe; register;
asm
  movq     xmm0, [RCX]
  movq     xmm1, [B]
  cvtdq2ps xmm0, xmm0
  cvtdq2ps xmm1, xmm1
  maxps    xmm0, xmm1
  cvtps2dq xmm0, xmm0
  movq     RAX,  {%H-}xmm0
end;

function TGLZVector2i.Clamp(constref AMin, AMax: Integer): TGLZVector2i; assembler; nostackframe; register;
asm
  movq   xmm0, [RCX] //movq ????
  movq   xmm1, [AMin]
  movq   xmm2, [AMax]
  shufps xmm1, xmm1, $00 // Replicate AMin
  shufps xmm2, xmm2, $00 // Replicate AMax
  maxps  xmm0, xmm1
  minps  xmm0, xmm2
  movq   RAX,  {%H-}xmm0
end;

function TGLZVector2i.Clamp(constref AMin, AMax: TGLZVector2i): TGLZVector2i;assembler; nostackframe; register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [AMin]
  movq   xmm2, [AMax]
  maxps  xmm0, xmm1
  minps  xmm0, xmm2
  movq   RAX,  {%H-}xmm0
end;

function TGLZVector2i.MulAdd(constref A, B: TGLZVector2i): TGLZVector2i;assembler; nostackframe; register;
asm
  movq     xmm0, [RCX]
  movq     xmm1, [A]
  movq     xmm2, [B]
  cvtdq2ps xmm0, xmm0
  cvtdq2ps xmm1, xmm1
  cvtdq2ps xmm2, xmm2
  Mulps    xmm0, xmm1
  Addps    xmm0, xmm2
  cvtps2dq xmm0, xmm0
  movq     RAX,  {%H-}xmm0
end;

function TGLZVector2i.MulDiv(constref A, B: TGLZVector2i): TGLZVector2i; assembler; nostackframe; register;
asm
  movq   xmm0, [RCX]
  movq     xmm1, [A]
  movq     xmm2, [B]
  cvtdq2ps xmm0, xmm0
  cvtdq2ps xmm1, xmm1
  cvtdq2ps xmm2, xmm2
  Mulps    xmm0, xmm1
  Divps    xmm0, xmm2
  push rcx
  {$i macro_sse_win64_trunc_xmm0-xmm0.inc}
  pop rcx
  movq     RAX, {%H-}xmm0
end;

function TGLZVector2i.Length: Single; assembler; nostackframe; register;
asm
  movq     xmm0, [RCX]
  cvtdq2ps xmm0, xmm0
  mulps    xmm0, xmm0
  movshdup xmm1, xmm0
  addps    xmm0, xmm1
  sqrtss   xmm0, xmm0
end;

function TGLZVector2i.LengthSquare: Single;assembler; nostackframe; register;
asm
  movq     xmm0, [RCX]
  cvtdq2ps xmm0, xmm0
  mulps    xmm0, xmm0
  movshdup xmm1, xmm0
  addps    xmm0, xmm1
end;

function TGLZVector2i.Distance(constref A: TGLZVector2i): Single;assembler; nostackframe; register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [A]
  cvtdq2ps xmm0, xmm0
  cvtdq2ps xmm1, xmm1
  subps  xmm0, xmm1
  mulps  xmm0, xmm0
  //haddps xmm0, xmm0
  movshdup xmm1, xmm0
  addps    xmm0, xmm1
  sqrtss xmm0, xmm0
  movq   RAX, {%H-}xmm0
end;

function TGLZVector2i.DistanceSquare(constref A: TGLZVector2i): Single;assembler; nostackframe; register;
asm
  movq   xmm0, [RCX]
  movq   xmm1, [A]
  cvtdq2ps xmm0, xmm0
  cvtdq2ps xmm1, xmm1
  subps  xmm0, xmm1
  mulps  xmm0, xmm0
  //haddps xmm0, xmm0
  movshdup xmm1, xmm0
  addps    xmm0, xmm1
end;

// function Reflect(I, NRef : TVector2i):TVector2i

function TGLZVector2i.Abs: TGLZVector2i; assembler; nostackframe; register;
asm
  movq      xmm0, [RCX]
  pxor      xmm1, xmm1     // 0 out xmm1
  pcmpgtd   xmm1, xmm0     // set all 1s where neg
  movdqa    xmm2, xmm1     // make copy of above
  pand      xmm2, [RIP+cSSE_MASK_ONE]  // mask off one where negative
  pxor      xmm0, xmm1     // flip bit if negative
  paddd     xmm0, xmm2     // +1 if negative
  movq      RAX, xmm0
end;

function TGLZVector2iHelper.Normalize: TGLZVector2f;assembler; nostackframe; register;
asm
  movq   xmm2, [RCX]    // Y X
  cvtdq2ps xmm2, xmm2
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

{%endregion%}
