{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

procedure TGLZBoundingSphere.Create(Const x,y,z: Single;Const r: single = 1.0);
begin
 Center.Create(x,y,z,1);
 Radius := r;
end;

procedure TGLZBoundingSphere.Create(Const AValue : TGLZAffineVector;Const r: single = 1.0);
begin
  Center.Create(AValue,1);
  Radius := r;
end;

procedure TGLZBoundingSphere.Create(Const AValue : TGLZVector;Const r: single = 1.0);
begin
  Center := AValue;
  Center.W := 1;
  Radius := r;
end;

function TGLZBoundingSphere.ToString: String;
begin
  Result := '{' +Self.Center.ToString + ' R: ' + FloattoStrF(Self.Radius,fffixed,5,5) + '}';
end;

function TGLZBoundingSphere.Contains(const TestBSphere: TGLZBoundingSphere) : TGLZSpaceContains;
var
  D2: Single;
begin
  D2 := Self.Center.DistanceSquare(TestBSphere.Center); // VectorDistance2(MainBSphere.Center, TestBSphere.Center);

  if D2 < Sqr(Self.Radius + TestBSphere.Radius) then
  begin
    if D2 < Sqr(Self.Radius - TestBSphere.Radius) then Result := ScContainsFully
    else
      Result := ScContainsPartially;
  end
  else Result := ScNoOverlap;
end;

function TGLZBoundingSphere.Intersect(const TestBSphere: TGLZBoundingSphere): Boolean;
begin
  Result := Self.Center.DistanceSquare(TestBSphere.Center) < Sqr(Self.Radius + TestBSphere.Radius);
end;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

{%region%----[ Operators ]------------------------------------------------------}

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

{%endregion%}

{%endregion%}

{$ENDIF}
