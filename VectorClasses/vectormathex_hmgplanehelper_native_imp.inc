{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

// Internal for pascal only

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

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

function TGLZHmgPlaneHelper.EvaluatePoint(constref Point : TGLZVector) : Single;
begin
  Result := Self.X*point.X+Self.Y*point.Y+Self.Z*point.Z+Self.W;
end;

{%endregion%}

{$ENDIF}
