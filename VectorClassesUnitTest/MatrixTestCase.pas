unit MatrixTestCase;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  { TMatrix4TestCase }

  TMatrix4TestCase = class(TVectorBaseTestCase)
  protected
    procedure Setup; override;
  public
    {$CODEALIGN RECORDMIN=16}
    nmtx1,nmtx2, nmtx3 : TNativeGLZMatrix4f;
    mtx1, mtx2, mtx3  : TGLZMatrix4f;
    {$CODEALIGN RECORDMIN=4}
  published
    procedure TestAddMatrix;
    procedure TestAddSingle;
    procedure TestSubMatrix;
    procedure TestSubSingle;
    procedure TestMulMatrix;
    procedure TestMulSingle;
    procedure TestMulVector;
    procedure TestVectorMulMatrix;
    procedure TestDivSingle;
    procedure TestMinus;
    procedure TestMultiply;
    procedure TestTranspose;
    procedure TestGetDeterminant;
    procedure TestTranslate;
    procedure TestInvert;
    procedure TestCreateLookAtMatrix;
  end;

implementation

{ TMatrix4TestCase }

procedure TMatrix4TestCase.Setup;
begin
  inherited Setup;
  nmtx1.V[0].Create(-2,2,-3,1);
  nmtx1.V[1].Create(-1,1,3,1);
  nmtx1.V[2].Create(2,0,-1,1);
  nmtx1.V[3].Create(2,2,2,1);      // this should have det of -50

  mtx1.M := nmtx1.M;


  nmtx2.CreateScaleMatrix(nt1);
  mtx2.CreateScaleMatrix(vt1);
end;

{%region%====[ TMatrixTestCase ]===============================================}

procedure TMatrix4TestCase.TestAddMatrix;
begin
  nmtx3 := nmtx1 + nmtx2;
  mtx3  := mtx1 + mtx2;
  AssertTrue('Matrix + Matrix no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestAddSingle;
begin
  nmtx3 := nmtx1 + FS1;
  mtx3  := mtx1 + FS1;
  AssertTrue('Matrix + Single no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestSubMatrix;
begin
  nmtx3 := nmtx1 - nmtx2;
  mtx3  := mtx1 - mtx2;
  AssertTrue('Matrix - Matrix no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestSubSingle;
begin
  nmtx3 := nmtx1 - FS1;
  mtx3  := mtx1 - FS1;
  AssertTrue('Matrix + Single no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestMulMatrix;
begin
  nmtx3 := nmtx1 * nmtx2;
  mtx3  := mtx1 * mtx2;
  AssertTrue('Matrix * Matrix no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestMulSingle;
begin
  nmtx3 := nmtx1 * FS1;
  mtx3  := mtx1 * FS1;
  AssertTrue('Matrix * Single no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestMulVector;
begin
  nt3 := nmtx1 * nt1;
  vt3  := mtx1 * vt1;
  AssertTrue('Matrix * Vector no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TMatrix4TestCase.TestVectorMulMatrix;
begin
  nt3 := nt1 * nmtx1;
  vt3  := vt1 * mtx1;
  AssertTrue('Vector * Matrix no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TMatrix4TestCase.TestDivSingle;
begin
  nmtx3 := nmtx1 / FS1;
  mtx3  := mtx1 / FS1;
  AssertTrue('Matrix / Single no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestMinus;
begin
  nmtx3 := -nmtx1;
  mtx3  := -mtx1;
  AssertTrue('-Matrix no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestMultiply;
begin
  nmtx3 := nmtx1.Multiply(nmtx2);
  mtx3  := mtx1.Multiply(mtx2);
  AssertTrue('Matrix Multiply no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestTranspose;
begin
  nmtx3 := nmtx1.Transpose;
  mtx3  := mtx1.Transpose;
  AssertTrue('Matrix Transpose no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestGetDeterminant;
begin
  Fs1 := nmtx1.Determinant;
  Fs2 := mtx1.Determinant;
  AssertTrue('Matrix Determinat do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TMatrix4TestCase.TestTranslate;
begin
  nmtx3 := nmtx1.Translate(nt1);
  mtx3  := mtx1.Translate(vt1);
  AssertTrue('Matrix Translate no match'+nmtx3.ToString+' --> '+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestInvert;
begin
  nmtx3 := nmtx1.Invert;
  mtx3  := mtx1.Invert;
  AssertTrue('Matrix Invert no match'+#13+#10+nmtx3.ToString+#13+#10+' --> '+#13+#10+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

procedure TMatrix4TestCase.TestCreateLookAtMatrix;
begin

  vt1.Create(0,0,10,1);  // eye is a point; origin will be center up will be y
  nt1.V := vt1.V;
  nmtx3.CreateLookAtMatrix(nt1,NativeNullHmgPoint,NativeYHmgVector); // create look at matrix
  mtx3.CreateLookAtMatrix(vt1,NullHmgPoint,YHmgVector); // create look at matrix
  AssertTrue('Matrix CreateLookAtMatrix no match'+#13+#10+nmtx3.ToString+#13+#10+' --> '+#13+#10+mtx3.ToString, CompareMatrix(nmtx3,mtx3));
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_MATRIX4F, TMatrix4TestCase);
end.

