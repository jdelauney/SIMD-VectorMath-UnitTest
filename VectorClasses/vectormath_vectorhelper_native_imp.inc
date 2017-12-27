function TGLZVectorHelper.PointProject(constref origin, direction : TGLZVector) : Single;
begin
   Result:= direction.X*(Self.X-origin.X)
           +direction.Y*(Self.Y-origin.Y)
           +direction.Z*(Self.Z-origin.Z);
end;

function TGLZVectorHelper.AverageNormal4(constref up, left, down, right: TGLZVector): TGLZVector;
var
  s,t,u,r: TGLZVector;
begin
  s := up - self;
  t := left - self;
  u := down - self;
  r := right - self;
  Result.X := s.Y*t.Z - s.Z*t.Y + t.Y*u.Z - t.Z*u.Y + u.Y*r.Z - u.Z*r.Y + r.Y*s.Z - r.Z*s.Y;
  Result.Y := s.Z*t.X - s.X*t.Z + t.Z*u.X - t.x*u.Z + u.Z*r.X - u.X*r.Z + r.Z*s.X - r.X*s.Z;
  Result.Z := s.X*t.Y - s.Y*t.X + t.X*u.Y - t.Y*u.X + u.X*r.Y - u.Y*r.X + r.X*s.Y - r.Y*s.X;
  Result := Result.Normalize;
end;

{%region%----[ TNativeGLZHmgPlane Helper ]------------------------------------------}

procedure TGLZVectorHelper.CreatePlane(constref p1, p2, p3 : TGLZVector);
begin
  CalcPlaneNormal(p1, p2, p3);
  Self.W:=-p1.DotProduct(Self);
end;

function TGLZVectorHelper.DistancePlaneToPoint(constref point : TGLZVector) : Single;
begin
   result:= System.abs( (Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W );
end;

function TGLZVectorHelper.DistancePlaneToSphere(constref Center : TGLZVector; constref Radius:Single) : Single;
var dist : single;
begin
  dist := DistancePlaneToPoint(Center);
  result := 0.0;
  if(dist > Radius) then result := dist - radius
end;

function TGLZVectorHelper.NormalizePlane:TGLZHmgPlane;
var
   n : Single;
begin
   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
   Result :=Self * n;
end;

{%endregion%}                             
