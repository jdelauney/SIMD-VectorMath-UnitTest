unit VectorOperatorsTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

{$I config.inc}

type
  { TVectorOperatorsTimingTest }
  TVectorOperatorsTimingTest = class(TVectorBaseTimingTest)
  protected
    procedure Setup; override;
  published
    procedure TimeAdd;
    procedure TimeSub;
    procedure TimeMul;
    procedure TimeDiv;
    procedure TimeAddSingle;
    procedure TimeSubSingle;
    procedure TimeMulSingle;
    procedure TimeDivSingle;
    procedure TimeNegative;
    procedure TimeOpEqual;
    procedure TimeOpGTEqual;
    procedure TimeOpLTEqual;
    procedure TimeOpGT;
    procedure TimeOpLT;
    procedure TimeOpNotEqual;
  end;

implementation

{%region%====[ TVector2OperatorsTimingTest ]====================================}

procedure TVectorOperatorsTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector4f;
end;

procedure TVectorOperatorsTimingTest.TimeAdd;
begin
  TestDispName := 'Vector Op Add Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    nt3 := nt1 + nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    vt3 := vt1 + vt2;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeSub;
begin
  TestDispName := 'Vector Op Subtract Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    nt3 := nt1 - nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    vt3 := vt1 - vt2;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeMul;
begin
  TestDispName := 'Vector Op Multiply Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    nt3 := nt1 * nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    vt3 := vt1 * vt2;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeDiv;
begin
  TestDispName := 'Vector Op Divide Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    nt3 := nt1 / nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    vt3 := vt1 / vt2;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeAddSingle;
begin
  TestDispName := 'Vector Op Add Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    nt3 := nt1 + r1;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    vt3 := vt1 + r1;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeSubSingle;
begin
  TestDispName := 'Vector Op Subtract Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    nt3 := nt1 - r1;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    vt3 := vt1 - r1;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeMulSingle;
begin
  TestDispName := 'Vector Op Multiply Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    nt3 := nt1 * r1;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    vt3 := vt1 * r1;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeDivSingle;
begin
  TestDispName := 'Vector Op Divide Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    nt3 := nt1 / r1;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    vt3 := vt1 / r1;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeNegative;
begin
  TestDispName := 'Vector Op Negative';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    nt3 := -nt1;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    vt3 := -vt1;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeOpEqual;
begin
  TestDispName := 'Vector Op Equal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    res := nt1 = nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    res := vt1 = vt2;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeOpGTEqual;
begin
  TestDispName := 'Vector Op GT or Equal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    res := nt1 >= nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    res := vt1 >= vt2;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeOpLTEqual;
begin
  TestDispName := 'Vector Op LT or Equal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    res := nt1 <= nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    res := vt1 <= vt2;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeOpGT;
begin
  TestDispName := 'Vector Op Greater';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    res := nt1 > nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    res := vt1 > vt2;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeOpLT;
begin
  TestDispName := 'Vector Op Less';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    res := nt1 < nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    res := vt1 < vt2;
  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsTimingTest.TimeOpNotEqual;
begin
  TestDispName := 'Vector Op Not Equal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    res := nt1 <> nt2;
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
    res := vt1 <> vt2;
  end;
  GlobalProfiler[1].Stop;
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR4F+'/Timimg', TVectorOperatorsTimingTest);
end.
