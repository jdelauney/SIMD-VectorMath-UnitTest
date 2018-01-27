unit QuaternionTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, BaseTimingTest,
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
    procedure TestMulQuaternion;
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
  Group := rgQuaterion;
  nqt1.Create(5.850,-15.480,8.512,1.5);
  nqt2.Create(1.558,6.512,4.525,1.0);
  qt1.V := nqt1.V;
  qt2.V := nqt2.V;
end;


{%region%====[ TQuaternionTimingTest ]============================================}

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
  for cnt := 1 to Iterations do begin nqt1.Normalize; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin qt1.Normalize; end;
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
  RegisterTest(REPORT_GROUP_QUATERION, TQuaternionTimingTest);
end.

