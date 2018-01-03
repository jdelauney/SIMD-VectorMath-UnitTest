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
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1 + ntt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1 + vtt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeSub;
begin
  TestDispName := 'Vector2f Op Subtract Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1 - ntt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1 - vtt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeMul;
begin
  TestDispName := 'Vector2f Op Multiply Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1 * ntt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1 * vtt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeDiv;
begin
  TestDispName := 'Vector2f Op Divide Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1 / ntt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1 / vtt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeAddSingle;
begin
  TestDispName := 'Vector2f Op Add Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1 + r1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1 + r1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeSubSingle;
begin
  TestDispName := 'Vector2f Op Subtract Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1 - r1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1 - r1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeMulSingle;
begin
  TestDispName := 'Vector2f Op Multiply Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1 * r1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1 * r1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeDivSingle;
begin
  TestDispName := 'Vector2f Op Divide Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1 / r1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1 / r1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeNegative;
begin
  TestDispName := 'Vector2f Op Negative';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := -ntt1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := -vtt1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeOpEqual;
begin
  TestDispName := 'Vector2f Op Equal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin res := ntt1 = ntt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin res := vtt1 = vtt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeOpNotEqual;
begin
  TestDispName := 'Vector2f Op Not Equal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin res := ntt1 <> ntt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin res := vtt1 <> vtt2; end;
  GlobalProfiler[1].Stop;
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR2F, TVector2OperatorsTimingTest);
end.
