unit Vector2OperatorsTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

{$I config.inc}

type
  { TVector2OperatorsTimingTest }
  TVector2OperatorsTimingTest = class(TVectorBaseTimingTest)
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
    procedure TimeOpNotEqual;
  end;

implementation

{%region%====[ TVector2OperatorsTimingTest ]====================================}

procedure TVector2OperatorsTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector2f;
end;

procedure TVector2OperatorsTimingTest.TimeAdd;
begin
  TestDispName := 'Vector2f Op Add Vector';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
    //GlobalProfiler[0].Start;
    ntt3 := ntt1 + ntt2;
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
    vtt3 := vtt1 + vtt2;
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

procedure TVector2OperatorsTimingTest.TimeSub;
begin
  TestDispName := 'Vector2f Op Subtract Vector';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    ntt3 := ntt1 - ntt2;
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
    vtt3 := vtt1 - vtt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVector2OperatorsTimingTest.TimeMul;
begin
  TestDispName := 'Vector2f Op Multiply Vector';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    ntt3 := ntt1 * ntt2;
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
    vtt3 := vtt1 * vtt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVector2OperatorsTimingTest.TimeDiv;
begin
  TestDispName := 'Vector2f Op Divide Vector';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    ntt3 := ntt1 / ntt2;
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
    vtt3 := vtt1 / vtt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVector2OperatorsTimingTest.TimeAddSingle;
begin
  TestDispName := 'Vector2f Op Add Single';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    ntt3 := ntt1 + r1;
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
    vtt3 := vtt1 + r1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVector2OperatorsTimingTest.TimeSubSingle;
begin
  TestDispName := 'Vector2f Op Subtract Single';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    ntt3 := ntt1 - r1;
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
    vtt3 := vtt1 - r1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVector2OperatorsTimingTest.TimeMulSingle;
begin
  TestDispName := 'Vector2f Op Multiply Single';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    ntt3 := ntt1 * r1;
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
    vtt3 := vtt1 * r1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVector2OperatorsTimingTest.TimeDivSingle;
begin
  TestDispName := 'Vector2f Op Divide Single';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    ntt3 := ntt1 / r1;
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
    vtt3 := vtt1 / r1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVector2OperatorsTimingTest.TimeNegative;
begin
  TestDispName := 'Vector2f Op Negative';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    ntt3 := -ntt1;
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
    vtt3 := -vtt1;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVector2OperatorsTimingTest.TimeOpEqual;
begin
  TestDispName := 'Vector2f Op Equal';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    res := ntt1 = ntt2;
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
    res := vtt1 = vtt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

procedure TVector2OperatorsTimingTest.TimeOpNotEqual;
begin
  TestDispName := 'Vector2f Op Not Equal';
  //StartTimer;
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do
  begin
//    GlobalProfiler[0].Start;
    res := ntt1 <> ntt2;
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
    res := vtt1 <> vtt2;
//    GlobalProfiler[1].Stop;
  end;
  GlobalProfiler[1].Stop;
  //StopTimer;
  //etAsm := elapsedTime;
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR2F, TVector2OperatorsTimingTest);
end.
