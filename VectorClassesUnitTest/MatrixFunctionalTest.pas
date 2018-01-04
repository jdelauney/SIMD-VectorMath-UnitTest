unit MatrixFunctionalTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  { TMatrixFunctionalTest }

  TMatrixFunctionalTest = class(TVectorBaseTestCase)
  protected
    procedure Setup; override;
  public
    {$CODEALIGN RECORDMIN=16}
    mKnownDet: TGLZMatrix4f;       // has det of -50
    mtx1, mtx2, mtx3  : TGLZMatrix4f;
    {$CODEALIGN RECORDMIN=4}
  published
    procedure TestDeterminant;
    procedure TestTranspose;
  end;
implementation


{ TMatrixFunctionalTest }

procedure TMatrixFunctionalTest.Setup;
begin
  inherited Setup;
  mKnownDet.V[0].Create(-2,2,-3,1);
  mKnownDet.V[1].Create(-1,1,3,1);
  mKnownDet.V[2].Create(2,0,-1,1);
  mKnownDet.V[3].Create(2,2,2,1);

end;

procedure TMatrixFunctionalTest.TestDeterminant;
begin
  Fs1:=mKnownDet.Determinant;
  AssertTrue('Matrix4f Determinant does not match expext -50 got '+FLoattostrF(fs1,fffixed,3,3), IsEqual(-50,fs1));
end;

procedure TMatrixFunctionalTest.TestTranspose;
begin
  // quick and dirty check for transpose, check the transposed determinant
  // which should show any out of order elements.
  fs1 := mKnownDet.Transpose.Determinant;
  AssertTrue('Matrix4f  Transposed Determinant does not match expext -50 got '+FLoattostrF(fs1,fffixed,3,3), IsEqual(-50,fs1));
end;

initialization
  RegisterTest(REPORT_GROUP_MATRIX4F, TMatrixFunctionalTest);
end.

