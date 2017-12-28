unit VectorOperatorsTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

{$I config.inc}

type
  { TVectorOperatorsTimingTest }
  TVectorOperatorsTimingTest = class(TVectorBaseTimingTest)
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

procedure TVectorOperatorsTimingTest.TimeAdd;
begin
  TestDispName := 'Vector Op Add Vector';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    //GlobalProfiler[0].Start;
    nt3 := nt1 + nt2;
    //GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //etNative := GlobalProfiler[0].TotalTicks;
  //etNativeMin := GlobalProfiler[0].MinTicks;
  //etNativeMax := GlobalProfiler[0].MaxTicks;
  //etNativeAvg := GlobalProfiler[0].AvgTicks;

  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    vt3 := vt1 + vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
  //etAsm := GlobalProfiler[1].TotalTicks;
  //etAsmMin := GlobalProfiler[1].MinTicks;
  //etAsmMax := GlobalProfiler[1].MaxTicks;
  //etAsmAvg := GlobalProfiler[1].AvgTicks;
end;

procedure TVectorOperatorsTimingTest.TimeSub;
begin
  TestDispName := 'Vector Op Subtract Vector';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    nt3 := nt1 - nt2;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    vt3 := vt1 - vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeMul;
begin
  TestDispName := 'Vector Op Multiply Vector';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    nt3 := nt1 * nt2;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    vt3 := vt1 * vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeDiv;
begin
  TestDispName := 'Vector Op Divide Vector';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    nt3 := nt1 / nt2;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    vt3 := vt1 / vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeAddSingle;
begin
  TestDispName := 'Vector Op Add Single';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    nt3 := nt1 + r1;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    vt3 := vt1 + r1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeSubSingle;
begin
  TestDispName := 'Vector Op Subtract Single';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    nt3 := nt1 - r1;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    vt3 := vt1 - r1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeMulSingle;
begin
  TestDispName := 'Vector Op Multiply Single';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    nt3 := nt1 * r1;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    vt3 := vt1 * r1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeDivSingle;
begin
  TestDispName := 'Vector Op Divide Single';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    nt3 := nt1 / r1;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    vt3 := vt1 / r1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeNegative;
begin
  TestDispName := 'Vector Op Negative';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    nt3 := -nt1;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    vt3 := -vt1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeOpEqual;
begin
  TestDispName := 'Vector Op Equal';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    res := nt1 = nt2;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    res := vt1 = vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeOpGTEqual;
begin
  TestDispName := 'Vector Op GT or Equal';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    res := nt1 >= nt2;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    res := vt1 >= vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeOpLTEqual;
begin
  TestDispName := 'Vector Op LT or Equal';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    res := nt1 <= nt2;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    res := vt1 <= vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeOpGT;
begin
  TestDispName := 'Vector Op Greater';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    res := nt1 > nt2;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    res := vt1 > vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeOpLT;
begin
  TestDispName := 'Vector Op Less';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    res := nt1 < nt2;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    res := vt1 < vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVectorOperatorsTimingTest.TimeOpNotEqual;
begin
  TestDispName := 'Vector Op Not Equal';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    res := nt1 <> nt2;
//    GlobalProfiler[0].Stop;
  end;
  GlobalProfiler[0].Stop;
  //StopTimer;
  //etNative := elapsedTime;
  //StartTimer;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[1].Start;
    res := vt1 <> vt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

{%endregion%}

initialization
  RegisterTest(TVectorOperatorsTimingTest);
end.
