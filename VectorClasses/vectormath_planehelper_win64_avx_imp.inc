//procedure TGLZVectorHelper.CreatePlane(constref p1, p2, p3 : TGLZVector);assembler;
//asm
//vxorps xmm0, xmm0, xmm0
//end;
//
//function TGLZVectorHelper.NormalizePlane:TGLZHmgPlane;assembler;
////   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
////   Result :=Self * n;
//asm
//vxorps xmm0, xmm0, xmm0
//end;
//
//function TGLZVectorHelper.DistancePlaneToPoint(constref point : TGLZVector) : Single; assembler;
//asm
//vxorps xmm0, xmm0, xmm0
//movss [RESULT], {%H-}xmm0
//end;
//
//function TGLZVectorHelper.DistancePlaneToSphere(constref Center : TGLZVector; constref Radius:Single) : Single; assembler;
//asm
//vxorps xmm0, xmm0, xmm0
//movss [RESULT], {%H-}xmm0
//end;
//
//function TGLZVectorHelper.PointProject(constref origin, direction : TGLZVector) : Single; assembler;
//asm
//vxorps xmm0, xmm0, xmm0
//movss [RESULT], {%H-}xmm0
//end;
