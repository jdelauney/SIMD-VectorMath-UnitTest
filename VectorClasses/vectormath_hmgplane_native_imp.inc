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

function TGLZHmgPlane.IsInHalfSpace(constref point: TGLZVector): Boolean;
begin
  Result := ((Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W) > 0;
end;

{ TODO 1 -oASM -cTHmgPlane : Create(point, normal) AddASM Version }
procedure TGLZHmgPlane.Create(constref point, normal : TGLZVector);
begin
   Self.AsNormal3:= normal.AsVector3f;
   Self.W:=-(Point.DotProduct(normal));
end;


function TGLZHmgPlaneHelper.PlaneContains(const Location, Normal: TGLZVector; const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;
var
  Plane: TGLZHmgPlane;
begin
 Plane.Create(Location, Normal);
 Result := plane.Contains(TestBSphere);
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

// helpers

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

{%endregion%}

{$ENDIF}