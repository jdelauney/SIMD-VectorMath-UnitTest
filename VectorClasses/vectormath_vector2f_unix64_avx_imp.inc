{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZVector2f.+(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq  xmm0, [A]
  vmovq  xmm1, [B]
  vaddps xmm0, xmm0, xmm1
end;

class operator TGLZVector2f.-(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq  xmm0, [A]
  vmovq  xmm1, [B]
  vsubps xmm0, xmm0, xmm1
end;

class operator TGLZVector2f.*(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq  xmm0, [A]
  vmovq  xmm1, [B]
  vmulps xmm0, xmm0, xmm1
end;

class operator TGLZVector2f./(constref A, B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq  xmm0, [A]
  vmovq  xmm1, [B]
  vdivps xmm0, xmm0, xmm1
end;

class operator TGLZVector2f.+(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq   xmm0, [A]
  vmovss  xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vaddps  xmm0, xmm0, xmm1
end;

class operator TGLZVector2f.-(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq   xmm0, [A]
  vmovss  xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vsubps  xmm0, xmm0, xmm1
end;

class operator TGLZVector2f.*(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq   xmm0, [A]
  vmovss  xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vmulps  xmm0, xmm0, xmm1
end;

class operator TGLZVector2f./(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq   xmm0, [A]
  vmovq   xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vdivps  xmm0, xmm0, xmm1
end;


{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector2f.Min(constref B: Single): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq   xmm0, [RDI]
  vmovss  xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vminps  xmm0, xmm0, xmm1
end;

function TGLZVector2f.Min(constref B: TGLZVector2f): TGLZVector2f; assembler; nostackframe; register;
asm
  vmovq  xmm0, [RDI]
  vmovq  xmm1, [B]
  vminps xmm0, xmm0, xmm1
end;


function TGLZVector2f.Max(constref B: Single): TGLZVector2f;Assembler; nostackframe;register;
asm
  vmovq   xmm0, [RDI]
  vmovss  xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vmaxps  xmm0, xmm0, xmm1
end;

function TGLZVector2f.Max(constref B: TGLZVector2f): TGLZVector2f;Assembler; nostackframe;register;
asm
  vmovq  xmm0, [RDI]
  vmovq  xmm1, [B]
  vmaxps xmm0, xmm0, xmm1
end;

function TGLZVector2f.Clamp(constref AMin, AMax: Single): TGLZVector2f;Assembler; nostackframe;register;
asm
  vmovq   xmm0, [RDI] //movq ????
  vmovss  xmm1, [AMin]
  vmovss  xmm2, [AMax]
  vshufps xmm1, xmm1, xmm1, $00 // Replicate AMin
  vshufps xmm2, xmm2, xmm2, $00 // Replicate AMax
  vmaxps  xmm0, xmm0, xmm1
  vminps  xmm0, xmm0, xmm2
end;

function TGLZVector2f.Clamp(constref AMin, AMax: TGLZVector2f): TGLZVector2f;Assembler; nostackframe;register;
asm
  vmovq  xmm0, [RDI]
  vmovq  xmm1, [AMin]
  vmovq  xmm2, [AMax]
  vmaxps xmm0, xmm0, xmm1
  vminps xmm0, xmm0, xmm2
end;

function TGLZVector2f.MulAdd(constref A,B:TGLZVector2f): TGLZVector2f;Assembler; nostackframe; register;
asm
  vmovq  xmm0, [RDI]
  vmovq  xmm1, [A]
  vmovq  xmm2, [B]
  vmulps xmm0, xmm0, xmm1
  vaddps xmm0, xmm0, xmm2
end;

function TGLZVector2f.MulDiv(constref A,B:TGLZVector2f): TGLZVector2f;Assembler; nostackframe; register;
asm
  vmovq   xmm0, [RDI]
  vmovq   xmm1, [A]
  vmovq   xmm2, [B]
  vmulps  xmm0, xmm0, xmm1
  vdivps  xmm0, xmm0, xmm2
end;

function TGLZVector2f.Length:Single;Assembler;nostackframe;register;
asm
  vmovq     xmm0, [RDI]
  vmulps    xmm0, xmm0, xmm0
  vmovshdup xmm1, xmm0
  vaddps    xmm0, xmm0, xmm1
  sqrtss    xmm0, xmm0
end;

function TGLZVector2f.LengthSquare:Single;Assembler;nostackframe;register;
asm
  vmovq     xmm0, [RDI]
  vmulps    xmm0, xmm0, xmm0
  vmovshdup xmm1, xmm0
  vaddps    xmm0, xmm0, xmm1
end;

function TGLZVector2f.Distance(constref A:TGLZVector2f):Single;Assembler; nostackframe;register;
asm
  vmovq   xmm0, [RDI]
  vmovq   xmm1, [A]
  vsubps  xmm0, xmm0, xmm1
  vmulps  xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vsqrtss xmm0, xmm0, xmm0
end;

function TGLZVector2f.DistanceSquare(Constref A:TGLZVector2f):Single;Assembler; nostackframe;register;
asm
  vmovq   xmm0, [RDI]
  vmovq   xmm1, [A]
  vsubps  xmm0, xmm0, xmm1
  vmulps  xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
end;


// todo this looks like work in progress.
function TGLZVector2f.Normalize : TGLZVector2f;Assembler;nostackframe;register;
asm
  movq   xmm2, [RDI]    // Y X
  movaps xmm0, xmm2
  mulps  xmm2, xmm2      // Y*Y X*X
  pshufd xmm1, xmm2, $01 // X*X Y*Y
  addps  xmm2, xmm1      // (X*X+Y*Y) (2x)
  sqrtps xmm2, xmm2
  divps  xmm0, xmm2
  //rsqrtps xmm0, xmm0      // (1 / Sqrt(X*X + Y*Y)) (4x)
  //mulps   xmm0, xmm2      // A * (1 / Sqrt(Dot(A, A)))
  //movq    rax, xmm0
end;

// function DotProduct(A:TVector2f):TVector2f;
// function Reflect(I, NRef : TVector2f):TVector2f
//function Round: TVector2I;
//function Trunc: TVector2I;

{%endregion%}
