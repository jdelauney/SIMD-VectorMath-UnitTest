{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX


// Turn (Y axis)
function TGLZMatrixHelper.Turn( Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(AffineVectorMake(Self.V[1].V[0], Self.V[1].V[1], Self.V[1].V[2]), Angle);
  Result:=Self * m;
end;

// Turn (direction)
function TGLZMatrixHelper.Turn(constref MasterUp: TGLZVector; Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(MasterUp, Angle);
  Result:=Self * m;
end;

// Pitch (X axis)
function TGLZMatrixHelper.Pitch(Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(AffineVectorMake(Self.V[0].V[0], Self.V[0].V[1], Self.V[0].V[2]), Angle);
  Result:=Self * m;
end;

// Pitch (direction)
function TGLZMatrixHelper.Pitch(constref MasterRight: TGLZVector; Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(MasterRight, Angle);
  Result := Self * m;
end;

// Roll (Z axis)
function TGLZMatrixHelper.Roll(Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(AffineVectorMake(Self.V[2].V[0], Self.V[2].V[1], Self.V[2].V[2]), Angle);
  Result := Self * m;
end;

// Roll (direction)
function TGLZMatrixHelper.Roll(constref MasterDirection: TGLZVector; Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(MasterDirection, Angle);
  Result := Self * m;
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
