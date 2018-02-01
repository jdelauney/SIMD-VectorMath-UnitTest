


function TGLZVector2fHelper.Step(ConstRef B : TGLZVector2f) : TGLZVector2f;assembler; //register; nostackframe;
asm
  //if self.X <= B.X then result.X := 0;
  movlps xmm0, [RCX]
  movlps xmm1, [B]
  comiss xmm0, xmm1
  jbe @NextStep
  movss [RESULT]0, {%H-}xmm0
@NextStep:
  //if self.Y <= B.Y then result.Y := 0;
  movlps xmm0, [RCX]4
  movlps xmm1, [B]4
  comiss xmm0, xmm1
  jbe @Finish
  movss [RESULT]4, {%H-}xmm0
@finish:
end;

function TGLZVector2fHelper.Saturate : TGLZVector2f;assembler; register; nostackframe;
asm
  movq xmm0, [RCX]
  movaps xmm1, [RIP+cOneVector4f]
  movaps xmm2, [RIP+cNullVector4f]
  maxps xmm0,xmm2
  minps xmm0,xmm1


  //minps xmm0,xmm2
  //minps xmm0,xmm1
  //movhlps xmm1,xmm0
  movq   rax,  {%H-}xmm0
end;

function TGLZVector2fHelper.SmoothStep(ConstRef A, B : TGLZVector2f) : TGLZVector2f; assembler; register; nostackframe;
Const
  cVecSet3 : TGLZVector4f = (x:3.0;y:3.0;z:3.0;w:3.0);
asm
  movq   xmm0, [RCX]
  //Saturate((self-a)/(b-a))
  movq   xmm1, [A]
  subps  xmm0, xmm1
  movq   xmm2, [B]
  subps  xmm2, xmm1
  divps  xmm0, xmm2
  maxps  xmm0, XMMWORD PTR [RIP+cNullVector4f]
  minps  xmm0, XMMWORD PTR [RIP+cOneVector4f]


  //result :=t*t * ((3.0 - t*2.0))
  movaps  xmm1, xmm0

  mulps   xmm0, xmm0
  movaps  xmm2, XMMWORD PTR [RIP+cVecSet3]
  addps   xmm1, xmm1            //t*2
  subps   xmm2, xmm1
  mulps   xmm0, xmm2
  movq   rax,  {%H-}xmm0
end;

function TGLZVector2fHelper.Lerp(Constref B: TGLZVector2f; Constref T:Single): TGLZVector2f;assembler; register; nostackframe;
asm
  movq xmm0, [RCX]
  movq xmm1, [B]
  movlps xmm2, [T]
  shufps xmm2, xmm2, 0
  subps xmm1, xmm0
  mulps xmm1,xmm2
  addps xmm0,xmm1
  movq   rax,  {%H-}xmm0
end;
