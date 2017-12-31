{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}


{ TODO 1 -oASM -cTHmgPlane : Create(point, normal) AddASM Version }
procedure TGLZVectorHelper.CreatePlane(constref point, normal : TGLZVector);
begin
   Self:=normal;
   Self.W:=-Point.DotProduct(normal);
end;
{ TODO 1 -oASM -cTHmgPlane : CalcPlaneNormal(p1, p2, p3)  Add ASM Version }
procedure TGLZVectorHelper.CalcPlaneNormal(constref p1, p2, p3 : TGLZVector);
var
   v1, v2 : TGLZVector;
begin
   v1:=p2-p1;
   v2:=p3-p1;
   Self:=v1.CrossProduct(v2);
   Self:=Self.Normalize;
end;

{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

procedure TGLZVectorHelper.CreatePlane(constref p1, p2, p3 : TGLZVector);
begin
  CalcPlaneNormal(p1, p2, p3);
  Self.W:=-p1.DotProduct(Self);
end;


{%region%----[ Operators ]------------------------------------------------------}

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZVectorHelper.DistancePlaneToPoint(constref point : TGLZVector) : Single;
begin
   result:= system.abs((Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W);
end;

function TGLZVectorHelper.DistancePlaneToSphere(constref Center : TGLZVector; constref Radius:Single) : Single;
var dist : single;
begin
  dist := Self.DistancePlaneToPoint(Center);
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

{%endregion%}

{$ENDIF}
