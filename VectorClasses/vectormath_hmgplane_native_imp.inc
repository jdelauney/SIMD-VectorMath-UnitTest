{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

// Internal for pascal only
procedure TGLZHmgPlane.CalcNormal(constref p1, p2, p3 : TGLZVector);
var
   v1, v2 : TGLZVector;
begin
   v1:=p2-p1;
   v2:=p3-p1;
   v1.pCrossProduct(v2);
   Self.AsVector := v1.Normalize;
end;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

{ TODO 1 -oASM -cTHmgPlane : Create(point, normal) AddASM Version }
procedure TGLZHmgPlane.Create(constref point, normal : TGLZVector);
begin
   Self.AsNormal3:= normal.AsVector3f;
   Self.W:=-(Point.DotProduct(normal));
end;

function TGLZHmgPlane.Distance(constref Center : TGLZVector; constref Radius:Single) : Single;
var dist : single;
begin
  dist := Self.Distance(Center);
  result := 0.0;
  if(Abs(dist) > Radius) then
    if Dist > 0 then
      result := dist - radius
    else
      result := dist + radius;
end;

function TGLZHmgPlane.IsInHalfSpace(constref point: TGLZVector): Boolean;
begin
  //Result := (EvaluatePoint(point) > 0);
  Result := ((Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W) > 0;
end;

function TGLZHmgPlaneHelper.PlaneContains(const Location, Normal: TGLZVector; const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;
var
  Plane: TGLZHmgPlane;
begin
 Plane.Create(Location, Normal);
 Result := plane.Contains(TestBSphere);
end;

function TGLZHmgPlaneHelper.Contains(const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;
var
   Dist: Single;
begin
  Dist := self.Distance(TestBSphere.Center);

  if Abs(Dist) < TestBSphere.Radius then
    Result := ScContainsPartially
  else if Dist < 0 then
    Result :=  ScNoOverlap
  else
    Result := ScContainsFully;
end;



{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

procedure TGLZHmgPlane.Create(constref p1, p2, p3 : TGLZVector);
begin
  CalcNormal(p1, p2, p3);
  Self.W:=-(p1.DotProduct(Self.AsVector));
end;


{%region%----[ Operators ]------------------------------------------------------}

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZHmgPlane.Perpendicular(constref P : TGLZVector4f) : TGLZVector4f;
var
   dot : Single;
begin
   dot:= Self.AsVector.DotProduct(P);
   Result.X:=P.X-Dot * Self.X;
   Result.Y:=P.Y-Dot * Self.Y;
   Result.Z:=P.Z-Dot * Self.Z;
   Result.W:=P.W;
end;

function TGLZHmgPlane.Reflect(constref V: TGLZVector4f): TGLZVector4f;
begin
  //  Result:=Self.Combine(Self, N, 1, -2*VectorDotProduct(Self, N));
//  Result := Self - (N*(2 * N.Dotproduct(Self)));
  Result :=  V - (Self.AsVector * (2 * V.DotProduct(Self.AsVector)));
end;

function TGLZHmgPlane.Distance(constref point : TGLZVector) : Single;
begin
  result:= (Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W;
end;

function TGLZHmgPlane.AbsDistance(constref point : TGLZVector) : Single;
begin
  result:= system.abs((Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W);
end;

function TGLZHmgPlane.Normalized:TGLZHmgPlane;
begin
   Result := self;
   Result.Normalize;
end;

procedure TGLZHmgPlane.Normalize;
var
   n : Single;
begin
   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
   Self.AsVector.pMul(n);
end;

{%endregion%}

function TGLZHmgPlaneHelper.EvaluatePoint(constref Point : TGLZVector) : Single;
begin
  Result := Self.X*point.X+Self.Y*point.Y+Self.Z*point.Z+Self.W;
end;

{%endregion%}

{$ENDIF}
