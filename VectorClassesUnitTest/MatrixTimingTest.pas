unit MatrixTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest, BaseTestCase,
  native, GLZVectorMath, GLZProfiler;

type

  { TMatrixTimingTest }
  TMatrixTimingTest = class(TVectorBaseTimingTest)
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
  end;

implementation

{ TMatrixTimingTest }

procedure TMatrixTimingTest.Setup;
begin
  inherited Setup;
  Group := rgMatrix4f;
  nmtx1.CreateIdentityMatrix;
  nmtx2.CreateScaleMatrix(nt1);
  mtx1.CreateIdentityMatrix;
  mtx2.CreateScaleMatrix(vt1);
end;

{%region%====[ TMatrixTestCase ]===============================================}

procedure TMatrixTimingTest.TestAddMatrix;
begin
  TestDispName := 'Matrix Add Matrix';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1 + nmtx2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1 + mtx2; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestAddSingle;
begin
  TestDispName := 'Matrix Add Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1 + FS1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1 + FS1; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestSubMatrix;
begin
  TestDispName := 'Matrix Sub Matrix';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1 - nmtx2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1 - mtx2; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestSubSingle;
begin
  TestDispName := 'Matrix Sub Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1 - FS1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1 - FS1; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestMulMatrix;
begin
  TestDispName := 'Matrix Multiply Matrix';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1 * nmtx2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1 * mtx2; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestMulSingle;
begin
  TestDispName := 'Matrix Multiply Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1 * FS1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1 * FS1; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestMulVector;
begin
  TestDispName := 'Matrix Multiply Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nmtx1 * nt1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3  := mtx1 * vt1; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestVectorMulMatrix;
begin
  TestDispName := 'Vector Multiply Matrix';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1 * nmtx1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3  := vt1 * mtx1; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestDivSingle;
begin
  TestDispName := 'Matrix Divide Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1 / FS1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1 / FS1; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestMinus;
begin
  TestDispName := 'Matrix Negate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := -nmtx1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := -mtx1; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestMultiply;
begin
  TestDispName := 'Matrix Component-wise multiplication';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1.Multiply(nmtx2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1.Multiply(mtx2);  end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestTranspose;
begin
  TestDispName := 'Matrix Transpose';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1.Transpose; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1.Transpose; end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestGetDeterminant;
begin
  TestDispName := 'Matrix Determinant';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nmtx1.Determinant; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin Fs2 := mtx1.Determinant;  end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestTranslate;
begin
  TestDispName := 'Matrix Translate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx1.Translate(nt1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx1.Translate(vt1); end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestInvert;
begin
  TestDispName := 'Matrix Invert';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nmtx3 := nmtx2.Invert; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin mtx3  := mtx2.Invert;  end;
  GlobalProfiler[1].Stop;
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_MATRIX4F, TMatrixTimingTest);
end.

