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

