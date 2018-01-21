procedure TGLZVectorHelper.CreatePlane(constref p1, p2, p3 : TGLZVector);
begin
  CalcPlaneNormal(p1, p2, p3);
  Self.W:=-p1.DotProduct(Self);
end;


function TGLZVectorHelper.NormalizePlane : TGLZHmgPlane; assembler;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZVectorHelper.DistancePlaneToPoint(constref point : TGLZVector) : Single;assembler;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZVectorHelper.DistancePlaneToSphere(constref Center : TGLZVector; constref Radius:Single) : Single; assembler;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZHmgPlane.Perpendicular(constref P : TGLZVector4f) : TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[P]
  vmovaps xmm1, [RCX]
  vandps xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  movaps xmm2, xmm0
 // Self.Dot(N) RESULT in xmm0
  vdpps xmm0, xmm0, xmm1, 01110001b //or $F1
  vShufps xmm0, xmm0,xmm0, $0
  vmulps xmm0, xmm0, xmm2    // (Dot * Self)
  vsubps xmm0, xmm2, xmm0    // self - (Dot * Self)
  vmovaps [RESULT], xmm0
end;

function TGLZHmgPlane.Reflect(constref V: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
 vmovaps xmm0,[V]
 vmovaps xmm1, [RCX]
 vmovaps xmm2, xmm1
 vmovaps xmm3, xmm0
 // N.Dot(SELF) RESULT in xmm1
 vdpps xmm1, xmm1, xmm0, 01110001b //or $F1
 vShufps xmm1, xmm1,xmm1, $0  // Replicate
 vaddps xmm1, xmm1,xmm1  // (2 * N.Dot(Self))
 vmulps xmm1, xmm1, xmm2 // ((2 * N.Dot(Self)) * N)
 vsubps xmm3, xmm3, xmm1 // Self - ((2 * N.Dot(Self)) * N)
 vmovaps [RESULT], xmm3
end;
