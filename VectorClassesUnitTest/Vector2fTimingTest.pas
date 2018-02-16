unit Vector2fTimingTest;

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
    procedure TimeDiv2i;
    procedure TimeNegative;
    procedure TimeOpEqual;
    procedure TimeOpNotEqual;
    procedure TimeAbs;
    procedure TimeMin;
    procedure TimeMax;
    procedure TimeMinSingle;
    procedure TimeMaxSingle;
    procedure TimeClamp;
    procedure TimeClampSingle;
    procedure TimeMulAdd;
    procedure TimeMulDiv;
    procedure TimeLengthVector;
    procedure TimeDistanceSquareVector;
    procedure TimeDistanceVector;
    procedure TimeLengthSquareVector;
    procedure TimeNormalizeVector;
    procedure TimeDotProduct;
    procedure TimeAngleBetween;
    procedure TimeAngleCosine;
    procedure TimeRound;
    procedure TimeTrunc;
    procedure TimeFloor;
    procedure TimeCeil;
    procedure TimeFract;
    procedure TimeSqrt;
    procedure TimeInvSqrt;
    procedure TimeModF;
    procedure TimefMod;
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

procedure TVector2OperatorsTimingTest.TimeDiv2i;
var
  at2i: TGLZVector2i;
begin
  at2i.Create(2,2);
  nt2i.V := at2i.V;
  TestDispName := 'Vector2f Op Divide 2i';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1 / nt2i; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1 / at2i; end;
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

procedure TVector2OperatorsTimingTest.TimeAbs;
begin
  TestDispName := 'Vector2f Abs';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.Abs; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.Abs; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeMin;
begin
  TestDispName := 'Vector2f Min';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.Min(ntt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.Min(vtt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeMax;
begin
  TestDispName := 'Vector2f Max';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.Max(ntt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.Max(vtt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeMinSingle;
begin
  TestDispName := 'Vector2f Min Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.Min(fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.Min(fs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeMaxSingle;
begin
  TestDispName := 'Vector2f Max Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.Max(fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.Max(fs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeClamp;
begin
  TestDispName := 'Vector2f Clamp';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.Clamp(ntt2, ntt1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.Clamp(vtt2, vtt1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeClampSingle;
begin
  TestDispName := 'Vector2f Clamp Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.Clamp(fs1, fs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.Clamp(fs1, fs2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeMulAdd;
begin
  TestDispName := 'Vector2f MulAdd';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.MulAdd(ntt2, ntt1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.MulAdd(vtt2, vtt1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeMulDiv;
begin
  TestDispName := 'Vector2f MulDiv';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.MulDiv(ntt2, ntt1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.Muldiv(vtt2, vtt1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeLengthVector;
begin
  TestDispName := 'Vector2f Length';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := ntt1.Length; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := vtt1.Length; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeLengthSquareVector;
begin
  TestDispName := 'Vector2f LengthSquare';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := ntt1.LengthSquare; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := vtt1.LengthSquare; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeDistanceVector;
begin
  TestDispName := 'Vector2f Distance';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := ntt1.Distance(ntt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := vtt1.Distance(vtt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeDistanceSquareVector;
begin
  TestDispName := 'Vector2f DistanceSquare';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := ntt1.DistanceSquare(ntt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := vtt1.DistanceSquare(vtt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeNormalizeVector;
begin
  TestDispName := 'Vector2f Normalize';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.Normalize; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.Normalize; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeDotProduct;
begin
  TestDispName := 'Vector2f DotProduct';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := ntt1.DotProduct(ntt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := vtt1.DotProduct(vtt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeAngleBetween;
begin
  TestDispName := 'Vector2f AngleBetween';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := ntt1.AngleBetween(ntt2,NativeNullVector2f); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := vtt1.AngleBetween(vtt2,NullVector2f); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeAngleCosine;
begin
  TestDispName := 'Vector2f AngleCosine';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := ntt1.AngleCosine(ntt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := vtt1.AngleCosine(vtt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeRound;
begin
  TestDispName := 'Vector2f Round';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i := ntt1.Round; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt2i := vtt1.Round; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeTrunc;
begin
  TestDispName := 'Vector2f Trunc';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i := ntt1.Trunc; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt2i := vtt1.Trunc; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeFloor;
begin
  TestDispName := 'Vector2f Floor';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i := ntt1.Floor; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt2i := vtt1.Floor; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeCeil;
begin
  TestDispName := 'Vector2f Ceil';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i := ntt1.Ceil; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt2i := vtt1.Ceil; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeFract;
begin
  TestDispName := 'Vector2f Fract';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt2 := ntt1.Fract; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt2 := vtt1.Fract; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeSqrt;
begin
  TestDispName := 'Vector2f Sqrt';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt2 := ntt1.Sqrt; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt2 := vtt1.Sqrt; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeInvSqrt;
begin
  TestDispName := 'Vector2f InvSqrt';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt2 := ntt1.InvSqrt; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt2 := vtt1.InvSqrt; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimeModF;
begin
  ntt2.Create(2,2);
  vtt2.Create(2,2);
  TestDispName := 'Vector2f ModF';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt3 := ntt1.ModF(ntt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt3 := vtt1.ModF(vtt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2OperatorsTimingTest.TimefMod;
begin
  ntt2.Create(2,2);
  vtt2.Create(2,2);
  TestDispName := 'Vector2f fMod';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i := ntt1.fMod(ntt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt2i := vtt1.fMod(vtt2); end;
  GlobalProfiler[1].Stop;
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR2F, TVector2OperatorsTimingTest);
end.
