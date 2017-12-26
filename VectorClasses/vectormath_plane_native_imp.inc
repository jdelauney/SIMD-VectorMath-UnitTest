procedure TGLZHmgPlaneHelper.Create(constref p1, p2, p3 : TGLZVector);
begin
  Self.CalcPlaneNormal(p1, p2, p3);
  Result.W:=-p1.DotProduct(Self);
end;

function TGLZHmgPlaneHelper.DistanceToPoint(constref point : TGLZVector) : Single;
begin
   result:= abs((Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W);
end;

function TGLZHmgPlaneHelper.DistanceToSphere(constref Center : TGLZVector; constref Radius:Single) : Single;
var dist : single;
begin
  dist := Self.DistanceToPoint(Center);
  result := 0.0;
  if(dist > Radius) then result := dist - radius
end;

function TGLZHmgPlaneHelper.NormalizePlane:TGLZHmgPlane;
var
   n : Single;
begin
   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
   Result :=Self * n;
end;

(* function TGLZHmgPlaneHelper.EvaluatePoint(constref point : TGLZVector) : Single;
// EAX contains address of plane
// EDX contains address of point
// result is stored in ST(0)
{$ifndef GEOMETRY_NO_ASM}
asm
      FLD DWORD PTR [EAX]
      FMUL DWORD PTR [EDX]
      FLD DWORD PTR [EAX + 4]
      FMUL DWORD PTR [EDX + 4]
      FADDP
      FLD DWORD PTR [EAX + 8]
      FMUL DWORD PTR [EDX + 8]
      FADDP
      FLD DWORD PTR [EAX + 12]
      FADDP
{$else}
begin
   Result:=Self.X*PointX+Self.Y*Point.Y+Self.Z*Point.Z+Self.W;
{$endif}
end; *)

(* function TGLZHmgPlaneHelper.PointIsInHalfSpace(constref planePoint, planeNormal : TGLZVector) : Boolean;
{$ifndef GEOMETRY_NO_ASM}
asm
   fld   dword ptr [eax]         // 27
   fsub  dword ptr [edx]
   fmul  dword ptr [ecx]
   fld   dword ptr [eax+4]
   fsub  dword ptr [edx+4]
   fmul  dword ptr [ecx+4]
   faddp
   fld   dword ptr [eax+8]
   fsub  dword ptr [edx+8]
   fmul  dword ptr [ecx+8]
   faddp
   ftst
   fstsw ax
   sahf
   setnbe al
   ffree st(0)
{$else}
begin
   Result:=(PointPlaneDistance(point, planePoint, planeNormal)>0); // 44
{$endif}
end; *)


