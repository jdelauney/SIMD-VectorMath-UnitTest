unit QuaternionTimingTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

type
  { TQuaternionTimingTest }

  TQuaternionTimingTest = class(TVectorBaseTimingTest)
  protected
    procedure Setup; override;
  public
    {$CODEALIGN RECORDMIN=16}
    nqt1, nqt2,nqt3 : TNativeGLZQuaternion;
    qt1,qt2,qt3     : TGLZQuaternion;
    {$CODEALIGN RECORDMIN=4}
  published
    procedure TestAddQuaternion;
    procedure TestAddSingle;
    procedure TestSubQuaternion;
    procedure TestSubSingle;
    procedure TestMulQuaternion;
    procedure TestMulSingle;
    procedure TestNegate;
    procedure TestConjugate;
    procedure TestMagnitude;
    procedure TestNormalize;
    procedure TestMultiplyAsSecond;
  end;

implementation

{ TQuaternionTimingTest }

procedure TQuaternionTimingTest.Setup;
begin
  inherited Setup;
  nqt1.Create(5.850,-15.480,8.512,1.5);
  nqt2.Create(1.558,6.512,4.525,1.0);
  qt1.V := nqt1.V;
  qt2.V := nqt2.V;
end;


{%region%====[ TQuaternionTimingTest ]============================================}

procedure TQuaternionTimingTest.TestAddQuaternion;
begin
  TestDispName := 'Quaternion Add Quaternion';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1 + nqt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := qt1 + qt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestAddSingle;
begin
  TestDispName := 'Quaternion Add Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1 + FS1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := qt1 + FS1; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestSubQuaternion;
begin
  TestDispName := 'Quaternion Sub Quaternion';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1 - nqt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := qt1 - qt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestSubSingle;
begin
  TestDispName := 'Quaternion Sub Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1 - FS1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := qt1 - FS1; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestMulQuaternion;
begin
  TestDispName := 'Quaternion Multiply Quaternion';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1 * nqt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := qt1 * qt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestMulSingle;
begin
  TestDispName := 'Quaternion Multiply Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1 * FS1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := qt1 * FS1; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestNegate;
begin
  TestDispName := 'Quaternion Negate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := -nqt1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := -qt1; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestConjugate;
begin
  TestDispName := 'Quaternion Conjugate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1.Conjugate; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := qt1.Conjugate; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestMagnitude;
begin
  TestDispName := 'Quaternion Magnitude';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nqt1.Magnitude; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin Fs2 := qt1.Magnitude;  end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestNormalize;
begin
  TestDispName := 'Quaternion Normalize';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1.Normalize; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := qt1.Normalize; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestMultiplyAsSecond;
begin
  TestDispName := 'Quaternion Multiply As Second';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1.MultiplyAsSecond(nqt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt3 := qt1.MultiplyAsSecond(qt2); end;
  GlobalProfiler[1].Stop;
end;

{%endregion%}

initialization
  RegisterTest(TQuaternionTimingTest);
end.

