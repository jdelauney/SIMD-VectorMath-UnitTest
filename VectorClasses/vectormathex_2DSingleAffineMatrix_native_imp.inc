{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

// Internal for pascal only

function TGLZ2DSingleAffineMatrix.GetComponent(const ARow, AColumn: Integer): Single; inline;
begin
  Result := Self.M[ARow, AColumn];
End;

procedure TGLZ2DSingleAffineMatrix.SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
begin
  Self.M[ARow, AColumn] := Value;
End;

function TGLZ2DSingleAffineMatrix.GetRow(const AIndex: Integer): TGLZVector3f; inline;
begin
  Result := V[AIndex];
End;

procedure TGLZ2DSingleAffineMatrix.SetRow(const AIndex: Integer; const Value: TGLZVector3f); inline;
begin
  Self.V[AIndex] := Value;
End;

procedure TGLZ2DSingleAffineMatrix.CreateIdentityMatrix;
begin
  m11 := 1.0;
  m12 := 0.0;
  m13 := 0.0;

  m21 := 0.0;
  m22 := 1.0;
  m23 := 0.0;

  m31 := 0.0;
  m32 := 0.0;
  m33 := 1.0;
End;

procedure TGLZ2DSingleAffineMatrix.CreateNullMatrix;
begin
  m11 := 0.0;
  m12 := 0.0;
  m13 := 0.0;

  m21 := 0.0;
  m22 := 0.0;
  m23 := 0.0;

  m31 := 0.0;
  m32 := 0.0;
  m33 := 0.0;
End;

procedure TGLZ2DSingleAffineMatrix.CreateTranslationMatrix(Const OffsetX, OffsetY : Single);
begin
  CreateIdentityMatrix;
  m13 := OffsetX;
  m23 := OffsetY;
End;

procedure TGLZ2DSingleAffineMatrix.CreateTranslationMatrix(Constref Offset : TGLZVector2f);
begin
  CreateTranslationMatrix(Offset.X, Offset.Y);
End;

procedure TGLZ2DSingleAffineMatrix.CreateScaleMatrix(Const ScaleX, ScaleY : Single);
begin
  CreateIdentityMatrix;
  m11 := ScaleX;
  m22 := ScaleY;
End;

procedure TGLZ2DSingleAffineMatrix.CreateScaleMatrix(Constref Scale : TGLZVector2f);
begin
  CreateTranslationMatrix(Scale.X, Scale.Y);
End;

procedure TGLZ2DSingleAffineMatrix.CreateRotationMatrix(Const anAngle : Single);
Var s,c : Single;
begin
  SinCos(anAngle,S,C);
  CreateIdentityMatrix;
  m11 := c;
  m12 := -s; //s

  m21 := s; //-s
  m22 := c;
End;

procedure TGLZ2DSingleAffineMatrix.CreateShearMatrix(const ShearX, ShearY : Single);
begin
  CreateIdentityMatrix;
  m12 := ShearX;
  m21 := ShearY;
End;

procedure TGLZ2DSingleAffineMatrix.CreateShearMatrix(constref Shear : TGLZVector2f);
begin
  CreateShearMatrix(Shear.X,Shear.Y);
End;

procedure TGLZ2DSingleAffineMatrix.Create(Const ScaleX, ScaleY, ShearX, ShearY, anAngle, OffsetX, OffsetY  : Single); overload;
var
  mScale, mShear, mRotate, mTrans : TGLZ2DSingleAffineMatrix;
begin

 mScale.CreateScaleMatrix(ScaleX,ScaleY);
 mShear.CreateShearMatrix(Tan(ShearX),Tan(ShearY));
 mRotate.CreateRotationMatrix(anAngle);
 mTrans.CreateTranslationMatrix(OffsetX, OffsetY);

 Self := mScale * mShear;
 Self := Self * mRotate;
 Self := Self * mTrans;
End;

procedure TGLZ2DSingleAffineMatrix.Create(Constref Scale, Shear, Offset : TGLZVector2f; Const anAngle : Single);
begin
  Create(Scale.X,Scale.Y, Shear.X, Shear.Y, anAngle, Offset.X, Offset.Y);
End;

procedure TGLZ2DSingleAffineMatrix.CreateReflectXMatrix;
begin
  CreateIdentityMatrix;
  //m11 := 1.0;
  m22 := -1.0;
End;

procedure TGLZ2DSingleAffineMatrix.CreateReflectYMatrix;
begin
  CreateIdentityMatrix;
  m11 := -1.0;
  //m22 := 1.0;
End;

procedure TGLZ2DSingleAffineMatrix.CreateReflectMatrix;
begin
  CreateIdentityMatrix;
  m11 := -1.0;
  m22 := -1.0;
End;

function TGLZ2DSingleAffineMatrix.ToString : String;
begin
  Result :=#13+#10
          +'|'+V[0].ToString+'|'+#13+#10
          +'|'+V[1].ToString+'|'+#13+#10
          +'|'+V[2].ToString+'|'+#13+#10;
End;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

function TGLZ2DSingleAffineMatrix.GetDeterminant: Single;
begin
  Result := m11 * m22 * m33 -
            m13 * m22 * m31 +
            m21 * m32 * m13 -
            m23 * m32 * m11 +
            m31 * m12 * m23 -
            m33 * m12 * m21;
End;

class operator TGLZ2DSingleAffineMatrix.*(constref A, B: TGLZ2DSingleAffineMatrix): TGLZ2DSingleAffineMatrix;
begin
  Result.m11 := A.m11 * B.m11 + A.m12 * B.m21 + A.m13 * B.m31;
  Result.m12 := A.m11 * B.m12 + A.m12 * B.m22 + A.m13 * B.m32;
  Result.m13 := A.m11 * B.m13 + A.m12 * B.m23 + A.m13 * B.m33;
  Result.m21 := A.m21 * B.m11 + A.m22 * B.m21 + A.m23 * B.m31;
  Result.m22 := A.m21 * B.m12 + A.m22 * B.m22 + A.m23 * B.m32;
  Result.m23 := A.m21 * B.m13 + A.m22 * B.m23 + A.m23 * B.m33;
  Result.m31 := A.m31 * B.m11 + A.m32 * B.m21 + A.m33 * B.m31;
  Result.m32 := A.m31 * B.m12 + A.m32 * B.m22 + A.m33 * B.m32;
  Result.m33 := A.m31 * B.m13 + A.m32 * B.m23 + A.m33 * B.m33;
End;

class operator TGLZ2DSingleAffineMatrix.*(constref A: TGLZ2DSingleAffineMatrix; constref B: TGLZVector2f): TGLZVector2f;
begin
  Result.x := A.m11 * B.x + A.m12 * B.y + A.m13;
  Result.y := A.m21 * B.x + A.m22 * B.y + A.m23;
End;

class operator TGLZ2DSingleAffineMatrix.*(constref A: TGLZVector2f; constref B: TGLZ2DSingleAffineMatrix): TGLZVector2f;
begin
   Result.x := B.m11 * A.x + B.m12 * A.y + B.m13 ;// * A.W = 1.0;
   Result.y := B.m21 * A.x + B.m22 * A.y + B.m23 ;// * A.W = 1.0
   //Result.w := B.m20 * A.x + B.m21 * A.y + B.m22 ;// * A.W = 1.0
End;

function TGLZ2DSingleAffineMatrix.Transpose: TGLZ2DSingleAffineMatrix;
var
  tmp : Single;
begin
  Result := Self;
  tmp := m12;
  Result.m12 := m21;
  Result.m21 := tmp;

  tmp := m13;
  Result.m13 := m31;
  Result.m31 := tmp;

  tmp := m32;
  Result.m32 := m23;
  Result.m23 := tmp;
End;

function TGLZ2DSingleAffineMatrix.Invert : TGLZ2DSingleAffineMatrix;
var
  det : Single;
begin
  Result.CreateNullMatrix;
  det := getDeterminant;
  if det=0 then exit;
  det := 1 / det;
  Result.m11 := (m22 * m33 - m23 * m32) * det;
  Result.m12 := (m13 * m32 - m12 * m33) * det;
  Result.m13 := (m12 * m23 - m13 * m22) * det;
  Result.m21 := (m23 * m31 - m21 * m33) * det;
  Result.m22 := (m11 * m33 - m13 * m31) * det;
  Result.m23 := (m13 * m21 - m11 * m23) * det;
  Result.m31 := (m21 * m32 - m22 * m31) * det;
  Result.m32 := (m12 * m31 - m11 * m32) * det;
  Result.m33 := (m11 * m22 - m12 * m21) * det;
End;

{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}


{%endregion%}

{$ENDIF}
