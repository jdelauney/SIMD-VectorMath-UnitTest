{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX


// Swizzling

function TGLZVector2fHelper.GetXY : TGLZVector2f;
begin
   Result.Create(Self.X,Self.Y);
end;

function TGLZVector2fHelper.GetYX : TGLZVector2f;
begin
   Result.Create(Self.Y,Self.X);
end;

function TGLZVector2fHelper.GetXX : TGLZVector2f;
begin
   Result.Create(Self.X,Self.X);
end;

function TGLZVector2fHelper.GetYY : TGLZVector2f;
begin
   Result.Create(Self.Y,Self.Y);
end;


function TGLZVector2fHelper.GetXXY : TGLZVector4f;
begin
  Result.X := Self.X;
  Result.Y := Self.X;
  Result.Z := Self.Y;
  Result.W := 1;
end;

function TGLZVector2fHelper.GetYYY : TGLZVector4f;
begin
  Result.X := Self.Y;
  Result.Y := Self.Y;
  Result.Z := Self.Y;
  Result.W := 1;
end;

function TGLZVector2fHelper.GetXXX : TGLZVector4f;
begin
  Result.X := Self.X;
  Result.Y := Self.X;
  Result.Z := Self.X;
  Result.W := 1;
end;

function TGLZVector2fHelper.GetYYX : TGLZVector4f;
begin
  Result.X := Self.Y;
  Result.Y := Self.Y;
  Result.Z := Self.X;
  Result.W := 1;
end;

function TGLZVector2fHelper.GetXYY : TGLZVector4f;
begin
  Result.X := Self.X;
  Result.Y := Self.Y;
  Result.Z := Self.Y;
  Result.W := 1;
end;

function TGLZVector2fHelper.GetYXY : TGLZVector4f;
begin
  Result.X := Self.Y;
  Result.Y := Self.X;
  Result.Z := Self.Y;
  Result.W := 1;
end;

function TGLZVector2fHelper.GetXYX : TGLZVector4f;
begin
  Result.X := Self.X;
  Result.Y := Self.Y;
  Result.Z := Self.X;
  Result.W := 1;
end;

function TGLZVector2fHelper.GetYXX : TGLZVector4f;
begin
  Result.X := Self.Y;
  Result.Y := Self.X;
  Result.Z := Self.X;
  Result.W := 1;
end;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}



{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZVector2fHelper.Step(ConstRef B : TGLZVector2f):TGLZVector2f;
begin
  result := Self;
  if self.X <= B.X then result.X := 0;
  if self.Y <= B.Y then result.Y := 0;
end;

//function TGLZVector2fHelper.FaceForward(constref A, B: TGLZVector4f): TGLZVector4f;
//begin
//  if (B.DotProduct(A) < 0) then
//     Result := -Self
//   else
//     Result := Self;
//end;

function TGLZVector2fHelper.Saturate : TGLZVector2f;
begin
  Result := self;
  Result := Result.Max(NullVector2f);
  Result := Result.Min(OneVector2f);
end;

function TGLZVector2fHelper.SmoothStep(ConstRef A,B : TGLZVector2f): TGLZVector2f;
var
  t: TGLZVector2f;
begin
  t := (Self-a)/(b-a);
  t := t.Saturate;
  // t * t * (3.0 - (t * 2.0)); <--- no overload for single - vector
  result := t * t * -((t * 2.0) + -3);
end;

function TGLZVector2fHelper.Lerp(Constref B: TGLZVector2f; Constref T:Single): TGLZVector2f;
begin
  result := Self + (b-self)*t;
end;

{%endregion%}



{%endregion%}

{$ENDIF}
