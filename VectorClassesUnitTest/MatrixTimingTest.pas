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
    apl1 : TGLZHmgPlane;
    npl1 : TNativeGLZHmgPlane;
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
    procedure TestTranposeVectorMulMatrix;
    procedure TestDivSingle;
    procedure TestMinus;
    procedure TestMultiply;
    procedure TestTranspose;
    procedure TestGetDeterminant;
    procedure TestTranslate;
    procedure TestInvert;
    procedure TestCreateLookAtMatrix;
    procedure TestCreateRotationMatrixXAngle;
    procedure TestCreateRotationMatrixXSinCos;
    procedure TestCreateRotationMatrixYAngle;
    procedure TestCreateRotationMatrixYSinCos;
    procedure TestCreateRotationMatrixZAngle;
    procedure TestCreateRotationMatrixZSinCos;
    procedure TestCreateRotationMatrixAxisAngle;
    procedure TestCreateParallelProjectionMatrix;
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

procedure TMatrixTimingTest.TestTranposeVectorMulMatrix;
begin
  TestDispName := 'Transpose Vector Multiply Matrix';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  nmtx1 := nmtx1.Transpose;
  for cnt := 1 to Iterations do begin nt3 := nt1 * nmtx1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  mtx1 := mtx1.Transpose;
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

procedure TMatrixTimingTest.TestCreateLookAtMatrix;
begin
  vt1.Create(0,0,10,1);
  nt1.V := vt1.V;
  TestDispName := 'Matrix CreateLookAtMatrix;';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nmtx3.CreateLookAtMatrix(nt1,NativeNullHmgPoint,NativeYHmgVector);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin mtx3.CreateLookAtMatrix(vt1,NullHmgPoint,YHmgVector);   end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestCreateRotationMatrixXAngle;
begin
  TestDispName := 'Matrix CreateRotationMatrixXAngle;';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nmtx3.CreateRotationMatrixX(pi/2);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin mtx3.CreateRotationMatrixX(pi/2);  end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestCreateRotationMatrixXSinCos;
begin
  TestDispName := 'Matrix CreateRotationMatrixXSinCos';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nmtx3.CreateRotationMatrixX(1,0);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin mtx3.CreateRotationMatrixX(1,0);  end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestCreateRotationMatrixYAngle;
begin
  TestDispName := 'Matrix CreateRotationMatrixYAngle;';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nmtx3.CreateRotationMatrixY(pi/2);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin mtx3.CreateRotationMatrixY(pi/2);  end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestCreateRotationMatrixYSinCos;
begin
  TestDispName := 'Matrix CreateRotationMatrixYSinCos';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nmtx3.CreateRotationMatrixY(1,0);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin mtx3.CreateRotationMatrixY(1,0);  end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestCreateRotationMatrixZAngle;
begin
  TestDispName := 'Matrix CreateRotationMatrixZAngle;';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nmtx3.CreateRotationMatrixZ(pi/2);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin mtx3.CreateRotationMatrixZ(pi/2);  end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestCreateRotationMatrixZSinCos;
begin
  TestDispName := 'Matrix CreateRotationMatrixZSinCos';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nmtx3.CreateRotationMatrixZ(1,0);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin mtx3.CreateRotationMatrixZ(1,0);  end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestCreateRotationMatrixAxisAngle;
begin
  TestDispName := 'Matrix CreateRotationMatrixAxisAngle';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nmtx3.CreateRotationMatrix(NativeZVector,pi/2);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin mtx3.CreateRotationMatrix(ZVector,pi/2);  end;
  GlobalProfiler[1].Stop;
end;

procedure TMatrixTimingTest.TestCreateParallelProjectionMatrix;
begin
  nt1.Create(1,1,0,1);
  vt1.Create(1,1,0,1);
  apl1.Create(vt1, ZHmgVector); // create a xy plane at 0
  npl1.Create(nt1, NativeZHmgVector); // create a xy plane at 0
  TestDispName := 'Matrix CreateParallelProjectionMatrix';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nmtx3.CreateParallelProjectionMatrix(npl1, nt1);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin mtx3.CreateParallelProjectionMatrix(apl1, vt1);  end;
  GlobalProfiler[1].Stop;
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_MATRIX4F, TMatrixTimingTest);
end.

