unit MatrixFunctionalTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  TMatrixFunctionalTest = class(TVectorBaseTestCase)
  private
    {returns a matrix with the exception of the item Pos
    can be used for finding the sign/position bug in code
    Expand tests as needed with one of these it may lead to finding
    which sign / position is wrong in the code. And it improves tests in
    longer term Pos 1 - 16 any other value will default.}
    function OddPosition(Pos: Integer; AValue: single): TGLZMatrix4f;
    { similar to above but alters 2x2 portion of the matrix
     Pos 1 to 9 top left to bottom right in left -> right top -> bottom order}
    function OddTwoByTwo(Pos: Integer; AValue: single): TGLZMatrix4f;
  protected
    procedure Setup; override;
  public
    {$CODEALIGN RECORDMIN=16}
    mKnownDet, invKnown, ResMat: TGLZMatrix4f;       // has det of -50
    mtx1, mtx2, mtx3, mtx4 : TGLZMatrix4f;
    {$CODEALIGN RECORDMIN=4}
  published
    procedure TestOpAddMatrix;
    procedure TestOpAddSingle;
    procedure TestOpSubMatrix;
    procedure TestOpSubSingle;
    procedure TestDeterminant;
    procedure TestTranspose;
    procedure TestGetDeterminant;
    procedure TestInverse;
    procedure TestOpMultMatrix;
    procedure TestOpMulVector;
    procedure TestOpVectorMulMat;
    procedure TestOpDivSingle;
    procedure TestOpNegate;
    procedure TestCreateIdentity;
    procedure TestCreateScaleVector;
    procedure TestCreateScaleAffine;
    procedure TestCreateTransVector;
    procedure TestCreateTransAffine;
    procedure TestCreateScaleTransVector;
    procedure TestCreateRotationMatrixXAngle;
    procedure TestCreateRotationMatrixXSinCos;
    procedure TestCreateRotationMatrixYAngle;
    procedure TestCreateRotationMatrixYSinCos;
    procedure TestCreateRotationMatrixZAngle;
    procedure TestCreateRotationMatrixZSinCos;
    procedure TestCreateRotationMatrixAxisAngle;
    procedure TestCreateRotationMatrixAxisSinCos;

  end;
implementation

{%region%----[ Const]---------------------------------------------------------}
const
  // 1-9s are good matrices for testing look simple but have a nasty det of 0
  // which is good for breaking naive routines. Also tests the where 3x3
  // is used in an implementation
  M_LOWER_LEFT_1_9 : TGLZMatrix = (V:(
                                      (X:1; Y:1; Z:1; W:1),
                                      (X:1; Y:2; Z:3; W:1),
                                      (X:4; Y:5; Z:6; W:1),
                                      (X:7; Y:8; Z:9; W:1)
                                      ));
  M_UPPER_LEFT_1_9 : TGLZMatrix = (V:(
                                      (X:1; Y:2; Z:3; W:1),
                                      (X:4; Y:5; Z:6; W:1),
                                      (X:7; Y:8; Z:9; W:1),
                                      (X:1; Y:1; Z:1; W:1)
                                      ));
  M_LOWER_RIGHT_1_9 : TGLZMatrix = (V:(
                                      (X:1; Y:1; Z:1; W:1),
                                      (X:1; Y:1; Z:2; W:3),
                                      (X:1; Y:4; Z:5; W:6),
                                      (X:1; Y:7; Z:8; W:9)
                                      ));
  M_UPPER_RIGHT_1_9 : TGLZMatrix = (V:(
                                      (X:1; Y:1; Z:2; W:3),
                                      (X:1; Y:4; Z:5; W:6),
                                      (X:1; Y:7; Z:8; W:9),
                                      (X:1; Y:1; Z:1; W:1)
                                      ));
{%endregion%}

procedure TMatrixFunctionalTest.Setup;
begin
  inherited Setup;
  mKnownDet.V[0].Create(-2,2,-3,1);
  mKnownDet.V[1].Create(-1,1,3,1);
  mKnownDet.V[2].Create(2,0,-1,1);
  mKnownDet.V[3].Create(2,2,2,1);

  invKnown.V[0].Create(-0.1, -0.2, 0.1, 0.2 );
  invKnown.V[1].Create(0.18, -0.24, -0.38, 0.44);
  invKnown.V[2].Create(-0.12, 0.16, -0.08, 0.04);
  invKnown.V[3].Create(0.08, 0.56, 0.72, -0.36);
end;

procedure TMatrixFunctionalTest.TestOpAddMatrix;
begin
  mtx3 := M_LOWER_LEFT_1_9 + M_UPPER_RIGHT_1_9;
  AssertEquals('AddMatrix:Sub1 m11 ',   2, mtx3.m11);
  AssertEquals('AddMatrix:Sub2 m12 ',   2, mtx3.m12);
  AssertEquals('AddMatrix:Sub3 m13 ',   3, mtx3.m13);
  AssertEquals('AddMatrix:Sub4 m14 ',   4, mtx3.m14);
  AssertEquals('AddMatrix:Sub5 m21 ',   2, mtx3.m21);
  AssertEquals('AddMatrix:Sub6 m22 ',   6, mtx3.m22);
  AssertEquals('AddMatrix:Sub7 m23 ',   8, mtx3.m23);
  AssertEquals('AddMatrix:Sub8 m24 ',   7, mtx3.m24);
  AssertEquals('AddMatrix:Sub9 m31 ',   5, mtx3.m31);
  AssertEquals('AddMatrix:Sub10 m32 ', 12, mtx3.m32);
  AssertEquals('AddMatrix:Sub11 m33 ', 14, mtx3.m33);
  AssertEquals('AddMatrix:Sub12 m34 ', 10, mtx3.m34);
  AssertEquals('AddMatrix:Sub13 m41 ',  8, mtx3.m41);
  AssertEquals('AddMatrix:Sub14 m42 ',  9, mtx3.m42);
  AssertEquals('AddMatrix:Sub15 m43 ', 10, mtx3.m43);
  AssertEquals('AddMatrix:Sub16 m44 ',  2, mtx3.m44);
end;

procedure TMatrixFunctionalTest.TestOpAddSingle;
begin
  mtx3 := M_LOWER_LEFT_1_9 + 2.0;
  AssertEquals('AddSingle:Sub1 m11 ',   3, mtx3.m11);
  AssertEquals('AddSingle:Sub2 m12 ',   3, mtx3.m12);
  AssertEquals('AddSingle:Sub3 m13 ',   3, mtx3.m13);
  AssertEquals('AddSingle:Sub4 m14 ',   3, mtx3.m14);
  AssertEquals('AddSingle:Sub5 m21 ',   3, mtx3.m21);
  AssertEquals('AddSingle:Sub6 m22 ',   4, mtx3.m22);
  AssertEquals('AddSingle:Sub7 m23 ',   5, mtx3.m23);
  AssertEquals('AddSingle:Sub8 m24 ',   3, mtx3.m24);
  AssertEquals('AddSingle:Sub9 m31 ',   6, mtx3.m31);
  AssertEquals('AddSingle:Sub10 m32 ',  7, mtx3.m32);
  AssertEquals('AddSingle:Sub11 m33 ',  8, mtx3.m33);
  AssertEquals('AddSingle:Sub12 m34 ',  3, mtx3.m34);
  AssertEquals('AddSingle:Sub13 m41 ',  9, mtx3.m41);
  AssertEquals('AddSingle:Sub14 m42 ', 10, mtx3.m42);
  AssertEquals('AddSingle:Sub15 m43 ', 11, mtx3.m43);
  AssertEquals('AddSingle:Sub16 m44 ',  3, mtx3.m44);
end;


//(X:1; Y:1; Z:2; W:3),
//(X:1; Y:4; Z:5; W:6),
//(X:1; Y:7; Z:8; W:9),
//(X:1; Y:1; Z:1; W:1)


procedure TMatrixFunctionalTest.TestOpSubMatrix;
begin
  mtx3 := M_LOWER_LEFT_1_9 - M_UPPER_RIGHT_1_9;
  AssertEquals('SubMatrix:Sub1 m11 ',   0, mtx3.m11);
  AssertEquals('SubMatrix:Sub2 m12 ',   0, mtx3.m12);
  AssertEquals('SubMatrix:Sub3 m13 ',  -1, mtx3.m13);
  AssertEquals('SubMatrix:Sub4 m14 ',  -2, mtx3.m14);
  AssertEquals('SubMatrix:Sub5 m21 ',   0, mtx3.m21);
  AssertEquals('SubMatrix:Sub6 m22 ',  -2, mtx3.m22);
  AssertEquals('SubMatrix:Sub7 m23 ',  -2, mtx3.m23);
  AssertEquals('SubMatrix:Sub8 m24 ',  -5, mtx3.m24);
  AssertEquals('SubMatrix:Sub9 m31 ',   3, mtx3.m31);
  AssertEquals('SubMatrix:Sub10 m32 ', -2, mtx3.m32);
  AssertEquals('SubMatrix:Sub11 m33 ', -2, mtx3.m33);
  AssertEquals('SubMatrix:Sub12 m34 ', -8, mtx3.m34);
  AssertEquals('SubMatrix:Sub13 m41 ',  6, mtx3.m41);
  AssertEquals('SubMatrix:Sub14 m42 ',  7, mtx3.m42);
  AssertEquals('SubMatrix:Sub15 m43 ',  8, mtx3.m43);
  AssertEquals('SubMatrix:Sub16 m44 ',  0, mtx3.m44);
end;

//(X:1; Y:1; Z:1; W:1),
//(X:1; Y:2; Z:3; W:1),
//(X:4; Y:5; Z:6; W:1),
//(X:7; Y:8; Z:9; W:1)


procedure TMatrixFunctionalTest.TestOpSubSingle;
begin
  mtx3 := M_LOWER_LEFT_1_9 - 2;
  AssertEquals('SubSingle:Sub1 m11 ',  -1, mtx3.m11);
  AssertEquals('SubSingle:Sub2 m12 ',  -1, mtx3.m12);
  AssertEquals('SubSingle:Sub3 m13 ',  -1, mtx3.m13);
  AssertEquals('SubSingle:Sub4 m14 ',  -1, mtx3.m14);
  AssertEquals('SubSingle:Sub5 m21 ',  -1, mtx3.m21);
  AssertEquals('SubSingle:Sub6 m22 ',   0, mtx3.m22);
  AssertEquals('SubSingle:Sub7 m23 ',   1, mtx3.m23);
  AssertEquals('SubSingle:Sub8 m24 ',  -1, mtx3.m24);
  AssertEquals('SubSingle:Sub9 m31 ',   2, mtx3.m31);
  AssertEquals('SubSingle:Sub10 m32 ',  3, mtx3.m32);
  AssertEquals('SubSingle:Sub11 m33 ',  4, mtx3.m33);
  AssertEquals('SubSingle:Sub12 m34 ', -1, mtx3.m34);
  AssertEquals('SubSingle:Sub13 m41 ',  5, mtx3.m41);
  AssertEquals('SubSingle:Sub14 m42 ',  6, mtx3.m42);
  AssertEquals('SubSingle:Sub15 m43 ',  7, mtx3.m43);
  AssertEquals('SubSingle:Sub16 m44 ', -1, mtx3.m44);
end;



procedure TMatrixFunctionalTest.TestDeterminant;
begin
  Fs1:=mKnownDet.Determinant;
  AssertEquals('Determinant:Sub1  ', -50, fs1);
  mtx1 := OddPosition(0,1); //default
  Fs1:=mtx1.Determinant;
  AssertEquals('Determinant:Sub1  ', 81, fs1);
  mtx1 := OddPosition(1,2); //default
  Fs1:=mtx1.Determinant;
  AssertEquals('Determinant:Sub1  ', 90, fs1);
  mtx1 := OddPosition(2,3); //default
  Fs1:=mtx1.Determinant;
  AssertEquals('Determinant:Sub1  ', 63, fs1);
  mtx1 := OddPosition(4,5); //default
  Fs1:=mtx1.Determinant;
  AssertEquals('Determinant:Sub1  ', 117, fs1);
end;

procedure TMatrixFunctionalTest.TestTranspose;
begin
  // quick and dirty check for transpose, check the transposed determinant
  // which should show any out of order elements.
  fs1 := mKnownDet.Transpose.Determinant;
  AssertTrue('Matrix4f  Transposed Determinant does not match expext -50 got '+FLoattostrF(fs1,fffixed,3,3), IsEqual(-50,fs1));
  mtx1 := OddTwoByTwo(3, 4); // top right
  mtx2 := OddTwoByTwo(7, 4); // bottom left
  mtx3 := mtx1.Transpose;
  AssertTrue('Invert:Sub1 ', compare(mtx3, mtx2));
  mtx3 := mtx2.Transpose;
  AssertTrue('Invert:Sub1 ', compare(mtx3, mtx1));
end;

// this function is called by a lot of the pascal routines
// basically it is just the determinant of a 3x3 matrix
// This function is private but we test using the following method
// Mat3 of ((123)(456)(789)) is a really nice matrix in that it has a det of 0
// we can test this inside a 4x4 by putting 1 in the other entries in a 4x4
// and it still has a det of 0. 4x4 det in pascal works by taking a value in the
// top row and multipying it with the 3x3 not in its col.
procedure TMatrixFunctionalTest.TestGetDeterminant;
begin
  fs1 := M_LOWER_LEFT_1_9.Determinant;
  AssertEquals('GetDeterminant:Sub1  ', 0, fs1);
  fs1 := M_UPPER_LEFT_1_9.Determinant;
  AssertEquals('GetDeterminant:Sub1  ', 0, fs1);
  fs1 := M_LOWER_RIGHT_1_9.Determinant;
  AssertEquals('GetDeterminant:Sub2 ', 0, fs1);
  fs1 := M_UPPER_RIGHT_1_9.Determinant;
  AssertEquals('GetDeterminant:Sub2 ', 0, fs1);
end;

procedure TMatrixFunctionalTest.TestInverse;
begin
  // has det of 0 should return IdentityHmgMatrix
  mtx1 := M_LOWER_LEFT_1_9;
  ResMat := mtx1.Invert;
  AssertTrue('Inverse:Sub1 ', compare(ResMat, IdentityHmgMatrix));
  mtx1 := OddPosition(0,1); //default
  mtx3 := mtx1.Invert;
  fs1 := 0.11111111111;
  AssertEquals('Inverse:Sub2 m11 ',  mtx3.m11, fs1);
  AssertEquals('Inverse:Sub3 m22 ',  mtx3.m22, fs1);
  AssertEquals('Inverse:Sub4 m33 ',  mtx3.m33, fs1);
  AssertEquals('Inverse:Sub5 m44 ',  mtx3.m44, fs1);
  fs1 := -0.2222222222;
  AssertEquals('Inverse:Sub6 m12 ',  mtx3.m12, fs1);
  AssertEquals('Inverse:Sub7 m13 ',  mtx3.m13, fs1);
  AssertEquals('Inverse:Sub8 m21 ',  mtx3.m21, fs1);
  AssertEquals('Inverse:Sub9 m24 ',  mtx3.m24, fs1);
  AssertEquals('Inverse:Sub10 m31 ', mtx3.m31, fs1);
  AssertEquals('Inverse:Sub11 m34 ', mtx3.m34, fs1);
  AssertEquals('Inverse:Sub12 m42 ', mtx3.m42, fs1);
  AssertEquals('Inverse:Sub13 m43 ', mtx3.m43, fs1);
  fs1 := 0.44444444444;
  AssertEquals('Inverse:Sub14 m14 ', mtx3.m14, fs1);
  AssertEquals('Inverse:Sub15 m23 ', mtx3.m23, fs1);
  AssertEquals('Inverse:Sub16 m32 ', mtx3.m32, fs1);
  AssertEquals('Inverse:Sub17 m41 ', mtx3.m41, fs1);
  mtx2 := mtx3.Invert;
  AssertTrue('Inverse:Sub18 double inverse failed ', compare(mtx2, mtx1, 1e-5));
  mtx1 := OddPosition(3,7);
  mtx3 := mtx1.Invert;
  mtx4 := mtx1 * mtx3; // inverse * matrix = Identity
  AssertTrue('Inverse:Sub19 Inverse * Matrix failed ', compare(IdentityHmgMatrix, mtx4, 1e-5));
  mtx2 := mtx3.Invert;
  AssertTrue('Inverse:Sub20 double inverse failed ', compare(mtx2, mtx1, 1e-4));
  mtx1 := OddTwoByTwo(3,7);
  mtx3 := mtx1.Invert;
  mtx4 := mtx1 * mtx3; // inverse * matrix = Identity
  AssertTrue('Inverse:Sub21 Inverse * Matrix failed ', compare(IdentityHmgMatrix, mtx4, 1e-5));
  mtx2 := mtx3.Invert;
  AssertTrue('Inverse:Sub22 double inverse failed ', compare(mtx2, mtx1, 1e-5));

end;

procedure TMatrixFunctionalTest.TestOpMultMatrix;
begin
   mtx1 := M_LOWER_LEFT_1_9;
   mtx3 := mtx1 * mtx1;
   AssertEquals('OpMultMatrix:Sub1 m11 ',  13, mtx3.m11);
   AssertEquals('OpMultMatrix:Sub2 m12 ',  16, mtx3.m12);
   AssertEquals('OpMultMatrix:Sub3 m13 ',  19, mtx3.m13);
   AssertEquals('OpMultMatrix:Sub4 m14 ',   4, mtx3.m14);
   AssertEquals('OpMultMatrix:Sub5 m21 ',  22, mtx3.m21);
   AssertEquals('OpMultMatrix:Sub6 m22 ',  28, mtx3.m22);
   AssertEquals('OpMultMatrix:Sub7 m23 ',  34, mtx3.m23);
   AssertEquals('OpMultMatrix:Sub8 m24 ',   7, mtx3.m24);
   AssertEquals('OpMultMatrix:Sub9 m31 ',  40, mtx3.m31);
   AssertEquals('OpMultMatrix:Sub10 m32 ', 52, mtx3.m32);
   AssertEquals('OpMultMatrix:Sub11 m33 ', 64, mtx3.m33);
   AssertEquals('OpMultMatrix:Sub12 m34 ', 16, mtx3.m34);
   AssertEquals('OpMultMatrix:Sub13 m41 ', 58, mtx3.m41);
   AssertEquals('OpMultMatrix:Sub14 m42 ', 76, mtx3.m42);
   AssertEquals('OpMultMatrix:Sub15 m43 ', 94, mtx3.m43);
   AssertEquals('OpMultMatrix:Sub16 m44 ', 25, mtx3.m44);
end;

procedure TMatrixFunctionalTest.TestOpMulVector;
begin
  mtx1 := M_LOWER_LEFT_1_9;
  vt1.Create(1,3,1,2);
  vt3 := mtx1 * vt1;
  AssertEquals('OpMulVector:Sub1 X ',   7, vt3.X);
  AssertEquals('OpMulVector:Sub2 Y ',  12, vt3.Y);
  AssertEquals('OpMulVector:Sub3 Z ',  27, vt3.Z);
  AssertEquals('OpMulVector:Sub4 W ',  42, vt3.W);
end;

procedure TMatrixFunctionalTest.TestOpVectorMulMat;
begin
  mtx1 := M_LOWER_LEFT_1_9;
  vt1.Create(1,3,1,2);
  vt3 :=  vt1 * mtx1;
  AssertEquals('OpMulVector:Sub1 X ',  22, vt3.X);
  AssertEquals('OpMulVector:Sub2 Y ',  28, vt3.Y);
  AssertEquals('OpMulVector:Sub3 Z ',  34, vt3.Z);
  AssertEquals('OpMulVector:Sub4 W ',   7, vt3.W);
end;

//(X:1; Y:1; Z:1; W:1),
//(X:1; Y:2; Z:3; W:1),
//(X:4; Y:5; Z:6; W:1),
//(X:7; Y:8; Z:9; W:1)


procedure TMatrixFunctionalTest.TestOpDivSingle;
begin
  mtx1 := M_LOWER_LEFT_1_9;
  mtx3 := mtx1 / 2;
  AssertEquals('OpDivSingle:Sub1 m11 ',  0.5, mtx3.m11);
  AssertEquals('OpDivSingle:Sub2 m12 ',  0.5, mtx3.m12);
  AssertEquals('OpDivSingle:Sub3 m13 ',  0.5, mtx3.m13);
  AssertEquals('OpDivSingle:Sub4 m14 ',  0.5, mtx3.m14);
  AssertEquals('OpDivSingle:Sub5 m21 ',  0.5, mtx3.m21);
  AssertEquals('OpDivSingle:Sub6 m22 ',  1.0, mtx3.m22);
  AssertEquals('OpDivSingle:Sub7 m23 ',  1.5, mtx3.m23);
  AssertEquals('OpDivSingle:Sub8 m24 ',  0.5, mtx3.m24);
  AssertEquals('OpDivSingle:Sub9 m31 ',  2.0, mtx3.m31);
  AssertEquals('OpDivSingle:Sub10 m32 ', 2.5, mtx3.m32);
  AssertEquals('OpDivSingle:Sub11 m33 ', 3.0, mtx3.m33);
  AssertEquals('OpDivSingle:Sub12 m34 ', 0.5, mtx3.m34);
  AssertEquals('OpDivSingle:Sub13 m41 ', 3.5, mtx3.m41);
  AssertEquals('OpDivSingle:Sub14 m42 ', 4.0, mtx3.m42);
  AssertEquals('OpDivSingle:Sub15 m43 ', 4.5, mtx3.m43);
  AssertEquals('OpDivSingle:Sub16 m44 ', 0.5, mtx3.m44);

end;

procedure TMatrixFunctionalTest.TestOpNegate;
begin
  mtx1 := M_LOWER_LEFT_1_9;
  mtx3 := -mtx1;
  AssertEquals('OpDivSingle:Sub1 m11 ',  -1, mtx3.m11);
  AssertEquals('OpDivSingle:Sub2 m12 ',  -1, mtx3.m12);
  AssertEquals('OpDivSingle:Sub3 m13 ',  -1, mtx3.m13);
  AssertEquals('OpDivSingle:Sub4 m14 ',  -1, mtx3.m14);
  AssertEquals('OpDivSingle:Sub5 m21 ',  -1, mtx3.m21);
  AssertEquals('OpDivSingle:Sub6 m22 ',  -2, mtx3.m22);
  AssertEquals('OpDivSingle:Sub7 m23 ',  -3, mtx3.m23);
  AssertEquals('OpDivSingle:Sub8 m24 ',  -1, mtx3.m24);
  AssertEquals('OpDivSingle:Sub9 m31 ',  -4, mtx3.m31);
  AssertEquals('OpDivSingle:Sub10 m32 ', -5, mtx3.m32);
  AssertEquals('OpDivSingle:Sub11 m33 ', -6, mtx3.m33);
  AssertEquals('OpDivSingle:Sub12 m34 ', -1, mtx3.m34);
  AssertEquals('OpDivSingle:Sub13 m41 ', -7, mtx3.m41);
  AssertEquals('OpDivSingle:Sub14 m42 ', -8, mtx3.m42);
  AssertEquals('OpDivSingle:Sub15 m43 ', -9, mtx3.m43);
  AssertEquals('OpDivSingle:Sub16 m44 ', -1, mtx3.m44);
end;

procedure TMatrixFunctionalTest.TestCreateIdentity;
begin
  mtx3.CreateIdentityMatrix;
  AssertTrue('CreateIdentity:Sub1 failed ', compare(IdentityHmgMatrix, mtx3));
end;

procedure TMatrixFunctionalTest.TestCreateScaleVector;
begin
  vt1.Create(2,2,2,1);  // should a scale vector set the W?
  mtx1.CreateScaleMatrix(vt1);
  vt3 := mtx1 * vt1;   // use the scale vector to scale itself
  AssertEquals('ScaleVector:Sub1 X ',  4, vt3.X);
  AssertEquals('ScaleVector:Sub2 Y ',  4, vt3.Y);
  AssertEquals('ScaleVector:Sub3 Z ',  4, vt3.Z);
  AssertEquals('ScaleVector:Sub4 W ',  1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(2,2,2,0);  // should a scale vector set the W?
  mtx1.CreateScaleMatrix(vt1);
  vt3 := mtx1 * vt1;   // use the scale vector to scale itself
  AssertEquals('ScaleVector:Sub5 X ',  4, vt3.X);
  AssertEquals('ScaleVector:Sub6 Y ',  4, vt3.Y);
  AssertEquals('ScaleVector:Sub7 Z ',  4, vt3.Z);
  AssertEquals('ScaleVector:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vector back
end;

procedure TMatrixFunctionalTest.TestCreateScaleAffine;
begin
  vt1.Create(2,2,2,1);  // should a scale vector set the W?
  mtx1.CreateScaleMatrix(vt1.AsVector3f);
  vt3 := mtx1 * vt1;   // use the scale vector to scale itself
  AssertEquals('ScaleAffine:Sub1 X ',  4, vt3.X);
  AssertEquals('ScaleAffine:Sub2 Y ',  4, vt3.Y);
  AssertEquals('ScaleAffine:Sub3 Z ',  4, vt3.Z);
  AssertEquals('ScaleAffine:Sub4 W ',  1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(2,2,2,0);  // should a scale vector set the W?
  mtx1.CreateScaleMatrix(vt1.AsVector3f);
  vt3 := mtx1 * vt1;   // use the scale vector to scale itself
  AssertEquals('ScaleAffine:Sub5 X ',  4, vt3.X);
  AssertEquals('ScaleAffine:Sub6 Y ',  4, vt3.Y);
  AssertEquals('ScaleAffine:Sub7 Z ',  4, vt3.Z);
  AssertEquals('ScaleAffine:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vector back
end;

procedure TMatrixFunctionalTest.TestCreateTransVector;
begin
  vt1.Create(3,4,5,1);  // should a scale vector set the W?
  mtx1.CreateTranslationMatrix(vt1);
  vt3 := mtx1 * vt1;   // use the transform on vector to transform itself
  AssertEquals('TransVector:Sub1 X ',  6, vt3.X);
  AssertEquals('TransVector:Sub2 Y ',  8, vt3.Y);
  AssertEquals('TransVector:Sub3 Z ', 10, vt3.Z);
  AssertEquals('TransVector:Sub4 W ',  1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(5,4,3,0);  // should a scale vector set the W?
  mtx1.CreateTranslationMatrix(vt1);
  vt3 := mtx1 * vt1;   // use the transform on a vector to transform  itself
  // vt1 was a vec should get vector back but vectors should not transform
  AssertEquals('TransVector:Sub5 X ',  5, vt3.X);
  AssertEquals('TransVector:Sub6 Y ',  4, vt3.Y);
  AssertEquals('TransVector:Sub7 Z ',  3, vt3.Z);
  AssertEquals('TransVector:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vector back
end;

procedure TMatrixFunctionalTest.TestCreateTransAffine;
begin
  vt1.Create(3,4,5,1);  // should a scale vector set the W?
  mtx1.CreateTranslationMatrix(vt1.AsVector3f);
  vt3 := mtx1 * vt1;   // use the transform on vector to transform itself
  AssertEquals('TransAffine:Sub1 X ',  6, vt3.X);
  AssertEquals('TransAffine:Sub2 Y ',  8, vt3.Y);
  AssertEquals('TransVector:Sub3 Z ', 10, vt3.Z);
  AssertEquals('TransAffine:Sub4 W ',  1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(5,4,3,0);  // should a scale vector set the W?
  mtx1.CreateTranslationMatrix(vt1.AsVector3f);
  vt3 := mtx1 * vt1;   // use the transform on a vector to transform  itself
  // vt1 was a vec should get vector back but vectors should not transform
  AssertEquals('TransAffine:Sub5 X ',  5, vt3.X);
  AssertEquals('TransAffine:Sub6 Y ',  4, vt3.Y);
  AssertEquals('TransAffine:Sub7 Z ',  3, vt3.Z);
  AssertEquals('TransAffine:Sub8 W ',  0, vt3.W);
end;

procedure TMatrixFunctionalTest.TestCreateScaleTransVector;
begin
  vt1.Create(2,2,2,1);  // should a scale vector set the W?
  vt2.Create(10,10,10,1);
  mtx1.CreateScaleAndTranslationMatrix(vt1,vt2);
  vt3 := mtx1 * vt1;   // use the scale vector to scale itself
  AssertEquals('ScaleTransVector:Sub1 X ',  14, vt3.X);
  AssertEquals('ScaleTransVector:Sub2 Y ',  14, vt3.Y);
  AssertEquals('ScaleTransVector:Sub3 Z ',  14, vt3.Z);
  AssertEquals('ScaleTransVector:Sub4 W ',  1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(2,2,2,0);  // should a scale vector set the W?
  mtx1.CreateScaleAndTranslationMatrix(vt1,vt2);
  vt3 := mtx1 * vt1;   // use the scale vector to scale itself mo transform as it is a vector
  AssertEquals('ScaleTransVector:Sub5 X ',  4, vt3.X);
  AssertEquals('ScaleTransVector:Sub6 Y ',  4, vt3.Y);
  AssertEquals('ScaleTransVector:Sub7 Z ',  4, vt3.Z);
  AssertEquals('ScaleTransVector:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vector back
end;

// rotations around X axis RightHandRule
// looking down positive X towards origin y is right and z is up
// from this view a positive rotation imparts a CCV rotation of Z and Y
// pos zy quadrant is upper right.
procedure TMatrixFunctionalTest.TestCreateRotationMatrixXAngle;
var aqt1: TGLZQuaternion;
begin
  aqt1.Create(90,XVector);
  mtx2 := aqt1.ConvertToMatrix;
  mtx1.CreateRotationMatrixX(pi/2);
  AssertTrue('RotationMatrixXAngle:Sub0 Quat v Mat do not match ', compare(mtx1,mtx2, 1e-6));
  vt1.Create(0,1,1,1); // point in the pos quad
  vt3 := mtx1 * vt1; // z remains pos y goes neg
  AssertEquals('RotationMatrixXAngle:Sub1 X ',   0, vt3.X);
  AssertEquals('RotationMatrixXAngle:Sub2 Y ',  -1, vt3.Y);
  AssertEquals('RotationMatrixXAngle:Sub3 Z ',   1, vt3.Z);
  AssertEquals('RotationMatrixXAngle:Sub4 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(0,1,1,0); // point in the pos quad
  vt3 := mtx1 * vt1; // z remains pos y goes neg
  AssertEquals('RotationMatrixXAngle:Sub5 X ',  0, vt3.X);
  AssertEquals('RotationMatrixXAngle:Sub6 Y ', -1, vt3.Y);
  AssertEquals('RotationMatrixXAngle:Sub7 Z ',  1, vt3.Z);
  AssertEquals('RotationMatrixXAngle:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vec back
  mtx1.CreateRotationMatrixX(-pi/2);
  vt1.Create(0,1,1,1); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos z goes neg
  AssertEquals('RotationMatrixXAngle:Sub9 X ',   0, vt3.X);
  AssertEquals('RotationMatrixXAngle:Sub10 Y ',   1, vt3.Y);
  AssertEquals('RotationMatrixXAngle:Sub11 Z ',  -1, vt3.Z);
  AssertEquals('RotationMatrixXAngle:Sub12 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(0,1,1,0); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos z goes neg
  AssertEquals('RotationMatrixXAngle:Sub13 X ',  0, vt3.X);
  AssertEquals('RotationMatrixXAngle:Sub14 Y ',  1, vt3.Y);
  AssertEquals('RotationMatrixXAngle:Sub15 Z ', -1, vt3.Z);
  AssertEquals('RotationMatrixXAngle:Sub16 W ',  0, vt3.W);  // vt1 was a vec should get vec back
end;

procedure TMatrixFunctionalTest.TestCreateRotationMatrixXSinCos;
begin
  mtx1.CreateRotationMatrixX(1,0);
  vt1.Create(0,1,1,1); // point in the pos quad
  vt3 := mtx1 * vt1; // z remains pos y goes neg
  AssertEquals('RotationMatrixXSinCos:Sub1 X ',   0, vt3.X);
  AssertEquals('RotationMatrixXSinCos:Sub2 Y ',  -1, vt3.Y);
  AssertEquals('RotationMatrixXSinCos:Sub3 Z ',   1, vt3.Z);
  AssertEquals('RotationMatrixXSinCos:Sub4 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(0,1,1,0); // point in the pos quad
  vt3 := mtx1 * vt1; // z remains pos y goes neg
  AssertEquals('RotationMatrixXSinCos:Sub5 X ',  0, vt3.X);
  AssertEquals('RotationMatrixXSinCos:Sub6 Y ', -1, vt3.Y);
  AssertEquals('RotationMatrixXSinCos:Sub7 Z ',  1, vt3.Z);
  AssertEquals('RotationMatrixXSinCos:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vec back
  mtx1.CreateRotationMatrixX(-1,0);
  vt1.Create(0,1,1,1); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos z goes neg
  AssertEquals('RotationMatrixXSinCos:Sub9 X ',   0, vt3.X);
  AssertEquals('RotationMatrixXSinCos:Sub10 Y ',   1, vt3.Y);
  AssertEquals('RotationMatrixXSinCos:Sub11 Z ',  -1, vt3.Z);
  AssertEquals('RotationMatrixXSinCos:Sub12 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(0,1,1,0); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos z goes neg
  AssertEquals('RotationMatrixXSinCos:Sub13 X ',  0, vt3.X);
  AssertEquals('RotationMatrixXSinCos:Sub14 Y ',  1, vt3.Y);
  AssertEquals('RotationMatrixXSinCos:Sub15 Z ', -1, vt3.Z);
  AssertEquals('RotationMatrixXSinCos:Sub16 W ',  0, vt3.W);  // vt1 was a vec should get vec back
end;

// rotations around Y axis RightHandRule
// looking down positive Y towards origin Z is right and X is up
// from this view a positive rotation imparts a CCV rotation of Z and Y
// pos zx quadrant is upper right.

procedure TMatrixFunctionalTest.TestCreateRotationMatrixYAngle;
var aqt1: TGLZQuaternion;
begin
  mtx1.CreateRotationMatrixY(pi/2);
  aqt1.Create(90,YVector);
  mtx2 := aqt1.ConvertToMatrix;
  AssertTrue('RotationMatrixYAngle:Sub0 Quat v Mat do not match ', compare(mtx1,mtx2, 1e-6));
  vt1.Create(1,0,1,1); // point in the pos quad
  vt3 := mtx1 * vt1; // x remains pos z goes neg
  AssertEquals('RotationMatrixYAngle:Sub1 X ',   1, vt3.X);
  AssertEquals('RotationMatrixYAngle:Sub2 Y ',   0, vt3.Y);
  AssertEquals('RotationMatrixYAngle:Sub3 Z ',  -1, vt3.Z);
  AssertEquals('RotationMatrixYAngle:Sub4 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(1,0,1,0); // point in the pos quad
  vt3 := mtx1 * vt1; // x remains pos z goes neg
  AssertEquals('RotationMatrixYAngle:Sub5 X ',  1, vt3.X);
  AssertEquals('RotationMatrixYAngle:Sub6 Y ',  0, vt3.Y);
  AssertEquals('RotationMatrixYAngle:Sub7 Z ', -1, vt3.Z);
  AssertEquals('RotationMatrixYAngle:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vec back
  mtx1.CreateRotationMatrixY(-pi/2);
  vt1.Create(1,0,1,1); // point in the pos quad
  vt3 := mtx1 * vt1; // z remains pos x goes neg
  AssertEquals('RotationMatrixYAngle:Sub9 X ',   -1, vt3.X);
  AssertEquals('RotationMatrixYAngle:Sub10 Y ',   0, vt3.Y);
  AssertEquals('RotationMatrixYAngle:Sub11 Z ',   1, vt3.Z);
  AssertEquals('RotationMatrixYAngle:Sub12 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(1,0,1,0); // point in the pos quad
  vt3 := mtx1 * vt1; // z remains pos x goes neg
  AssertEquals('RotationMatrixYAngle:Sub13 X ', -1, vt3.X);
  AssertEquals('RotationMatrixYAngle:Sub14 Y ',  0, vt3.Y);
  AssertEquals('RotationMatrixYAngle:Sub15 Z ',  1, vt3.Z);
  AssertEquals('RotationMatrixYAngle:Sub16 W ',  0, vt3.W);  // vt1 was a vec should get vec back
end;

procedure TMatrixFunctionalTest.TestCreateRotationMatrixYSinCos;
begin
  mtx1.CreateRotationMatrixY(1,0);
  vt1.Create(1,0,1,1); // point in the pos quad
  vt3 := mtx1 * vt1; // x remains pos z goes neg
  AssertEquals('RotationMatrixYSinCos:Sub1 X ',   1, vt3.X);
  AssertEquals('RotationMatrixYSinCos:Sub2 Y ',   0, vt3.Y);
  AssertEquals('RotationMatrixYSinCos:Sub3 Z ',  -1, vt3.Z);
  AssertEquals('RotationMatrixYSinCos:Sub4 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(1,0,1,0); // point in the pos quad
  vt3 := mtx1 * vt1; // x remains pos z goes neg
  AssertEquals('RotationMatrixYSinCos:Sub5 X ',  1, vt3.X);
  AssertEquals('RotationMatrixYSinCos:Sub6 Y ',  0, vt3.Y);
  AssertEquals('RotationMatrixYSinCos:Sub7 Z ', -1, vt3.Z);
  AssertEquals('RotationMatrixYSinCos:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vec back
  mtx1.CreateRotationMatrixY(-1,0);
  vt1.Create(1,0,1,1); // point in the pos quad
  vt3 := mtx1 * vt1; // z remains pos x goes neg
  AssertEquals('RotationMatrixYSinCos:Sub9 X ',   -1, vt3.X);
  AssertEquals('RotationMatrixYSinCos:Sub10 Y ',   0, vt3.Y);
  AssertEquals('RotationMatrixYSinCos:Sub11 Z ',   1, vt3.Z);
  AssertEquals('RotationMatrixYSinCos:Sub12 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(1,0,1,0); // point in the pos quad
  vt3 := mtx1 * vt1; // z remains pos x goes neg
  AssertEquals('RotationMatrixYSinCos:Sub13 X ', -1, vt3.X);
  AssertEquals('RotationMatrixYSinCos:Sub14 Y ',  0, vt3.Y);
  AssertEquals('RotationMatrixYSinCos:Sub15 Z ',  1, vt3.Z);
  AssertEquals('RotationMatrixYSinCos:Sub16 W ',  0, vt3.W);  // vt1 was a vec should get vec back

end;

// rotations around Z axis RightHandRule
// looking down positive Z towards origin X is right and Y is up
// from this view a positive rotation imparts a CCV rotation of x and Y
// pos xy quadrant is upper right.
procedure TMatrixFunctionalTest.TestCreateRotationMatrixZAngle;
var aqt1: TGLZQuaternion;
begin
  aqt1.Create(90,ZVector);
  mtx2 := aqt1.ConvertToMatrix;
  mtx1.CreateRotationMatrixZ(pi/2);
  AssertTrue('RotationMatrixZAngle:Sub0 Quat v Mat do not match ', compare(mtx1,mtx2, 1e-6));

  vt1.Create(1,1,0,1); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos x goes neg
  AssertEquals('RotationMatrixZAngle:Sub1 X ',  -1, vt3.X);
  AssertEquals('RotationMatrixZAngle:Sub2 Y ',   1, vt3.Y);
  AssertEquals('RotationMatrixZAngle:Sub3 Z ',   0, vt3.Z);
  AssertEquals('RotationMatrixZAngle:Sub4 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(1,1,0,0); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos x goes neg
  AssertEquals('RotationMatrixZAngle:Sub5 X ', -1, vt3.X);
  AssertEquals('RotationMatrixZAngle:Sub6 Y ',  1, vt3.Y);
  AssertEquals('RotationMatrixZAngle:Sub7 Z ',  0, vt3.Z);
  AssertEquals('RotationMatrixZAngle:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vec back
  mtx1.CreateRotationMatrixZ(-pi/2);
  vt1.Create(1,1,0,1); // point in the pos quad
  vt3 := mtx1 * vt1; // x remains pos y goes neg
  AssertEquals('RotationMatrixZAngle:Sub9 X ',    1, vt3.X);
  AssertEquals('RotationMatrixZAngle:Sub10 Y ',  -1, vt3.Y);
  AssertEquals('RotationMatrixZAngle:Sub11 Z ',   0, vt3.Z);
  AssertEquals('RotationMatrixZAngle:Sub12 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(1,1,0,0); // point in the pos quad
  vt3 := mtx1 * vt1; // x remains pos y goes neg
  AssertEquals('RotationMatrixZAngle:Sub13 X ',  1, vt3.X);
  AssertEquals('RotationMatrixZAngle:Sub14 Y ', -1, vt3.Y);
  AssertEquals('RotationMatrixZAngle:Sub15 Z ',  0, vt3.Z);
  AssertEquals('RotationMatrixZAngle:Sub16 W ',  0, vt3.W);  // vt1 was a vec should get vec back
end;

procedure TMatrixFunctionalTest.TestCreateRotationMatrixZSinCos;
begin
  mtx1.CreateRotationMatrixZ(1,0);
  vt1.Create(1,1,0,1); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos x goes neg
  AssertEquals('RotationMatrixZAngle:Sub1 X ',  -1, vt3.X);
  AssertEquals('RotationMatrixZAngle:Sub2 Y ',   1, vt3.Y);
  AssertEquals('RotationMatrixZAngle:Sub3 Z ',   0, vt3.Z);
  AssertEquals('RotationMatrixZAngle:Sub4 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(1,1,0,0); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos x goes neg
  AssertEquals('RotationMatrixZAngle:Sub5 X ', -1, vt3.X);
  AssertEquals('RotationMatrixZAngle:Sub6 Y ',  1, vt3.Y);
  AssertEquals('RotationMatrixZAngle:Sub7 Z ',  0, vt3.Z);
  AssertEquals('RotationMatrixZAngle:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vec back
  mtx1.CreateRotationMatrixZ(-1,0);
  vt1.Create(1,1,0,1); // point in the pos quad
  vt3 := mtx1 * vt1; // x remains pos y goes neg
  AssertEquals('RotationMatrixZAngle:Sub9 X ',    1, vt3.X);
  AssertEquals('RotationMatrixZAngle:Sub10 Y ',  -1, vt3.Y);
  AssertEquals('RotationMatrixZAngle:Sub11 Z ',   0, vt3.Z);
  AssertEquals('RotationMatrixZAngle:Sub12 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(1,1,0,0); // point in the pos quad
  vt3 := mtx1 * vt1; // x remains pos y goes neg
  AssertEquals('RotationMatrixZAngle:Sub13 X ',  1, vt3.X);
  AssertEquals('RotationMatrixZAngle:Sub14 Y ', -1, vt3.Y);
  AssertEquals('RotationMatrixZAngle:Sub15 Z ',  0, vt3.Z);
  AssertEquals('RotationMatrixZAngle:Sub16 W ',  0, vt3.W);  // vt1 was a vec should get vec back
end;

// angle in radians
procedure TMatrixFunctionalTest.TestCreateRotationMatrixAxisAngle;
begin
  mtx1.CreateRotationMatrix(ZVector,pi/2);
  mtx2.CreateRotationMatrix(ZHmgVector,pi/2);
  AssertTrue('RotationMatrixAxisAngle:Sub0 Affinve v Hmg do not match ', compare(mtx1,mtx2));
  vt1.Create(1,1,0,1); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos x goes neg
  AssertEquals('RotationMatrixAxisAngle:Sub1 X ',  -1, vt3.X);
  AssertEquals('RotationMatrixAxisAngle:Sub2 Y ',   1, vt3.Y);
  AssertEquals('RotationMatrixAxisAngle:Sub3 Z ',   0, vt3.Z);
  AssertEquals('RotationMatrixAxisAngle:Sub4 W ',   1, vt3.W);  // vt1 was a point should get point back
  vt1.Create(1,1,0,0); // point in the pos quad
  vt3 := mtx1 * vt1; // y remains pos x goes neg
  AssertEquals('RotationMatrixAxisAngle:Sub5 X ', -1, vt3.X);
  AssertEquals('RotationMatrixAxisAngle:Sub6 Y ',  1, vt3.Y);
  AssertEquals('RotationMatrixAxisAngle:Sub7 Z ',  0, vt3.Z);
  AssertEquals('RotationMatrixAxisAngle:Sub8 W ',  0, vt3.W);  // vt1 was a vec should get vec back


end;

procedure TMatrixFunctionalTest.TestCreateRotationMatrixAxisSinCos;
begin

end;




function TMatrixFunctionalTest.OddPosition(Pos: Integer; AValue: single): TGLZMatrix4f;
begin
  Result.V[0].Create(1, 2, 2, 4);  // interesting matrix this, inverse
  Result.V[1].Create(2, 1, 4, 2);  // is 0 point value reoccuring
  Result.V[2].Create(2, 4, 1, 2);
  Result.V[3].Create(4, 2, 2, 1);
  case Pos of
  1:  Result.m11 := AValue ;
  2:  Result.m12 := AValue ;
  3:  Result.m13 := AValue ;
  4:  Result.m14 := AValue ;
  5:  Result.m21 := AValue ;
  6:  Result.m22 := AValue ;
  7:  Result.m23 := AValue ;
  8:  Result.m24 := AValue ;
  9:  Result.m31 := AValue ;
  10: Result.m32 := AValue ;
  11: Result.m33 := AValue ;
  12: Result.m34 := AValue ;
  13: Result.m41 := AValue ;
  14: Result.m42 := AValue ;
  15: Result.m43 := AValue ;
  16: Result.m44 := AValue ;
  end;
end;

function TMatrixFunctionalTest.OddTwoByTwo(Pos: Integer; AValue: single): TGLZMatrix4f;
begin
  Result.V[0].Create(1, 2, 2, 4);  // interesting matrix this, inverse
  Result.V[1].Create(2, 1, 4, 2);  // is 0 point value reoccuring
  Result.V[2].Create(2, 4, 1, 2);
  Result.V[3].Create(4, 2, 2, 1);
  case Pos of
  1: begin // top left
      Result.m11 := AValue ;
      Result.m12 := AValue ;
      Result.m21 := AValue ;
      Result.m22 := AValue ;
     end;
  2:   begin // top mid
      Result.m12 := AValue ;
      Result.m13 := AValue ;
      Result.m22 := AValue ;
      Result.m23 := AValue ;
     end;
  3:   begin // top right
      Result.m13 := AValue ;
      Result.m14 := AValue ;
      Result.m23 := AValue ;
      Result.m24 := AValue ;
     end;
  4:  begin // mid left
      Result.m21 := AValue ;
      Result.m22 := AValue ;
      Result.m31 := AValue ;
      Result.m32 := AValue ;
     end;
  5: begin // mid mid
      Result.m22 := AValue ;
      Result.m23 := AValue ;
      Result.m32 := AValue ;
      Result.m33 := AValue ;
     end;
  6: begin // mid right
      Result.m23 := AValue ;
      Result.m24 := AValue ;
      Result.m33 := AValue ;
      Result.m34 := AValue ;
     end;
  7: begin // bottom left
      Result.m31 := AValue ;
      Result.m32 := AValue ;
      Result.m41 := AValue ;
      Result.m42 := AValue ;
     end;
  8: begin // bottom mid
      Result.m32 := AValue ;
      Result.m33 := AValue ;
      Result.m42 := AValue ;
      Result.m43 := AValue ;
     end;
  9: begin // bottom right
      Result.m33 := AValue ;
      Result.m34 := AValue ;
      Result.m43 := AValue ;
      Result.m44 := AValue ;
     end;

  end;
end;


initialization
  RegisterTest(REPORT_GROUP_MATRIX4F, TMatrixFunctionalTest);
end.

