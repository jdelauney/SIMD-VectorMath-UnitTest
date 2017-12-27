{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZVector2f.+(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [A]
  movq xmm1, [B]
  addps  xmm0, xmm1
end;

class operator TGLZVector2f.-(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [A]
  movq xmm1, [B]
  subps  xmm0, xmm1
end;

class operator TGLZVector2f.*(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [A]
  movq xmm1, [B]
  mulps  xmm0, xmm1
end;

class operator TGLZVector2f./(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [A]
  movq xmm1, [B]
  divps  xmm0, xmm1
end;

class operator TGLZVector2f.+(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [A]
  movq xmm1, [B]
  shufps xmm1, xmm1, $00
  addps  xmm0, xmm1
end;

class operator TGLZVector2f.-(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [A]
  movq xmm1, [B]
  shufps xmm1, xmm1, $00
  subps  xmm0, xmm1
end;

class operator TGLZVector2f.*(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [A]
  movq xmm1, [B]
  shufps xmm1, xmm1, $00
  mulps  xmm0, xmm1
end;

class operator TGLZVector2f./(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [A]
  movq xmm1, [B]
  shufps xmm1, xmm1, $00
  divps  xmm0, xmm1
end;


{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector2f.Min(constref B: Single): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [RDI]
  movq xmm1, [B]
  shufps xmm1, xmm1, $00
  minps  xmm0, xmm1
end;

function TGLZVector2f.Min(constref B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  movq xmm0, [RDI]
  movq xmm1, [B]
  minps  xmm0, xmm1
end;


function TGLZVector2f.Max(constref B: Single): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq xmm0, [RDI]
  movq xmm1, [B]
  shufps xmm1, xmm1, $00
  maxps  xmm0, xmm1
end;

function TGLZVector2f.Max(constref B: TGLZVector2f): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq xmm0, [RDI]
  movq xmm1, [B]
  maxps  xmm0, xmm1
end;

function TGLZVector2f.Clamp(constref AMin, AMax: Single): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq   xmm0, [RDI] //movq ????
  movq   xmm1, [AMin]
  movq   xmm2, [AMax]
  shufps xmm1, xmm1, $00 // Replicate AMin
  shufps xmm2, xmm2, $00 // Replicate AMax
  maxps  xmm0, xmm1
  minps  xmm0, xmm2
end;

function TGLZVector2f.Clamp(constref AMin, AMax: TGLZVector2f): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq   xmm0, [RDI]
  movq   xmm1, [AMin]
  movq   xmm2, [AMax]
  maxps  xmm0, xmm1
  minps  xmm0, xmm2
end;

function TGLZVector2f.MulAdd(constref A,B:TGLZVector2f): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq   xmm0, [RDI]
  movq   xmm1, [A]
  movq   xmm2, [B]
  Mulps  xmm0, xmm1
  Addps  xmm0, xmm2
end;

function TGLZVector2f.MulDiv(constref A,B:TGLZVector2f): TGLZVector2f;Assembler; nostackframe;register;
asm
  movq   xmm0, [RDI]
  movq   xmm1, [A]
  movq   xmm2, [B]
  Mulps  xmm0, xmm1
  Divps  xmm0, xmm2
end;

function TGLZVector2f.Length:Single;Assembler;nostackframe;register;
asm
  movq xmm0, [RDI]
  mulps xmm0, xmm0
  movshdup xmm1,xmm0
  addps  xmm0, xmm1
  sqrtss xmm0, xmm0
end;

function TGLZVector2f.LengthSquare:Single;Assembler;nostackframe;register;
asm
  movq xmm0, [RDI]
  mulps xmm0, xmm0
  movshdup xmm1,xmm0
  addps  xmm0, xmm1
end;

function TGLZVector2f.Distance(constref A:TGLZVector2f):Single;Assembler; nostackframe;register;
asm
  movq xmm0, [RDI]
  movq xmm1, [A]
  subps xmm0, xmm1
  mulps xmm0, xmm0
  haddps xmm0, xmm0
  sqrtss xmm0, xmm0
end;

function TGLZVector2f.DistanceSquare(Constref A:TGLZVector2f):Single;Assembler; nostackframe;register;
asm
  movq xmm0, [RDI]
  movq xmm1, [A]
  subps xmm0, xmm1
  mulps xmm0, xmm0
  haddps xmm0, xmm0
end;

function TGLZVector2f.Normalize : TGLZVector2f;Assembler;nostackframe;register;
asm
  movq  xmm2, [RDI]    // Y X
  movaps  xmm0, xmm2
  mulps   xmm2, xmm2      // Y*Y X*X
  pshufd  xmm1, xmm2, $01 // X*X Y*Y
  addps   xmm2, xmm1      // (X*X+Y*Y) (2x)
  sqrtps xmm2, xmm2
  divps xmm0, xmm2
  //rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y)) (4x)
  //mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  //movq    rax, xmm0
end;

// function DotProduct(A:TVector2f):TVector2f;
// function Reflect(I, NRef : TVector2f):TVector2f
//function Round: TVector2I;
//function Trunc: TVector2I;

{%endregion%}
