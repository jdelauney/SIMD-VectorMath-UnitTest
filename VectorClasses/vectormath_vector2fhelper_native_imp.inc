{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX




{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}



{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZVector2DHelper.Step(ConstRef B : TGLZVector2f):TGLZVector2f;
begin
  result := Self;
  if self.X <= B.X then result.X := 0;
  if self.Y <= B.Y then result.Y := 0;
end;

//function TGLZVector2DHelper.FaceForward(constref A, B: TGLZVector4f): TGLZVector4f;
//begin
//  if (B.DotProduct(A) < 0) then
//     Result := -Self
//   else
//     Result := Self;
//end;

function TGLZVector2DHelper.Saturate : TGLZVector2f;
begin
  Result := self;
  Result := Result.Max(NullVector2f);
  Result := Result.Min(OneVector2f);
end;

function TGLZVector2DHelper.SmoothStep(ConstRef A,B : TGLZVector2f): TGLZVector2f;
var
  t: TGLZVector2f;
begin
  t := (Self-a)/(b-a);
  t := t.Saturate;
  // t * t * (3.0 - (t * 2.0)); <--- no overload for single - vector
  result := t * t * -((t * 2.0) + -3);
end;

function TGLZVector2DHelper.Lerp(Constref B: TGLZVector2f; Constref T:Single): TGLZVector2f;
begin
  result := Self + (b-self)*t;
end;

{%endregion%}

{%endregion%}

{$ENDIF}
