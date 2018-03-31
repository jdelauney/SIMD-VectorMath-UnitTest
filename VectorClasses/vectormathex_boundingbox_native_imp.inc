{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX



procedure TGLZBoundingBox.Create(Const AValue : TGLZVector);
begin
  SetPlanBB(Self, 0,  AValue.X);
  SetPlanBB(Self, 1, -AValue.X);
  SetPlanBB(Self, 2,  AValue.Y);
  SetPlanBB(Self, 3, -AValue.Y);
  SetPlanBB(Self, 4,  AValue.Z);
  SetPlanBB(Self, 5, -AValue.Z);
end;

class operator TGLZBoundingBox.+(ConstRef A, B : TGLZBoundingBox):TGLZBoundingBox;overload;
var
  I, J: Integer;
  C1, C2 : TGLZBoundingBox;
begin
  C1 := A;
  C2 := B;
  for I := 0 to 7 do
  begin
    for J := 0 to 3 do
      if C1.Points[CBBFront[J]].X < C2.Points[I].X then SetPlanBB(C1, 0, C2.Points[I].X);
    for J := 0 to 3 do
      if C1.Points[CBBBack[J]].X > C2.Points[I].X then SetPlanBB(C1, 1, C2.Points[I].X);
    for J := 0 to 3 do
      if C1.Points[CBBLeft[J]].Y < C2.Points[I].Y then SetPlanBB(C1, 2, C2.Points[I].Y);
    for J := 0 to 3 do
      if C1.Points[CBBRight[J]].Y > C2.Points[I].Y then SetPlanBB(C1, 3, C2.Points[I].Y);
    for J := 0 to 3 do
      if C1.Points[CBBTop[J]].Z < C2.Points[I].Z then SetPlanBB(C1, 4, C2.Points[I].Z);
    for J := 0 to 3 do
      if C1.Points[CBBBottom[J]].Z > C2.Points[I].Z then SetPlanBB(C1, 5, C2.Points[I].Z);
  end;
  Result := C1;
end;

class operator TGLZBoundingBox.+(ConstRef A: TGLZBoundingBox; ConstRef B : TGLZVector):TGLZBoundingBox;overload;
var
  I: Integer;
begin
  for I := 0 to 7 do
   result.Points[I] := A.Points[I] + B;
end;

class operator TGLZBoundingBox.=(ConstRef A, B : TGLZBoundingBox):Boolean;overload;
begin
  Result := CompareMem(@A, @B, SizeOf(TGLZBoundingBox));

(*  Result := (A.Points[0] = B.Points[0]) and
            (A.Points[1] = B.Points[1]) and
            (A.Points[2] = B.Points[2]) and
            (A.Points[3] = B.Points[3]) and
            (A.Points[4] = B.Points[4]) and
            (A.Points[5] = B.Points[5]) and
            (A.Points[6] = B.Points[6]) and
            (A.Points[7] = B.Points[7]); *)
end;

function TGLZBoundingBox.Transform(ConstRef M:TGLZMAtrix):TGLZBoundingBox;
var
  I: Integer;
begin
  Result := Self;
  for I := 0 to 7 do
    Result.Points[I] := M * Result.Points[I];
end;

function TGLZBoundingBox.MinX : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].X;
  for I := 1 to 7 do
    Result := Math.Min(Result, Self.Points[I].X);
end;

function TGLZBoundingBox.MaxX : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].X;
  for I := 1 to 7 do
    Result := Math.Max(Result, Self.Points[I].X);
end;

function TGLZBoundingBox.MinY : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Y;
  for I := 1 to 7 do
    Result := Math.Min(Result, Self.Points[I].y);
end;

function TGLZBoundingBox.MaxY : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Y;
  for I := 1 to 7 do
    Result := Math.Max(Result, Self.Points[I].Y);
end;

function TGLZBoundingBox.MinZ : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Z;
  for I := 1 to 7 do
    Result := Math.Min(Result, Self.Points[I].Z);
end;

function TGLZBoundingBox.MaxZ : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Z;
  for I := 1 to 7 do
    Result := Math.Max(Result, Self.Points[I].Z);
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
