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

