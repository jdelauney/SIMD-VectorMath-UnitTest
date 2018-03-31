unit Vector2dTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

{$I config.inc}

type
  { TVector2dOperatorsTimingTest }
  TVector2dOperatorsTimingTest = class(TVectorBaseTimingTest)
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
    //procedure TimefMod;
  end;

implementation

{%region%====[ TVector2dOperatorsTimingTest ]====================================}

procedure TVector2dOperatorsTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector2d;
end;

procedure TVector2dOperatorsTimingTest.TimeAdd;
begin
  TestDispName := 'Vector2d Op Add Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1 + nttd2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1 + vttd2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeSub;
begin
  TestDispName := 'Vector2d Op Subtract Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1 - nttd2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1 - vttd2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeMul;
begin
  TestDispName := 'Vector2d Op Multiply Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1 * nttd2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1 * vttd2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeDiv;
begin
  TestDispName := 'Vector2d Op Divide Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1 / nttd2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1 / vttd2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeAddSingle;
begin
  TestDispName := 'Vector2d Op Add Double';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1 + r1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1 + r1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeSubSingle;
begin
  TestDispName := 'Vector2d Op Subtract Double';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1 - r1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1 - r1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeMulSingle;
begin
  TestDispName := 'Vector2d Op Multiply Double';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1 * r1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1 * r1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeDivSingle;
begin
  TestDispName := 'Vector2d Op Divide Double';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1 / r1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1 / r1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeDiv2i;
var
  at2i: TGLZVector2i;
begin
  at2i.Create(2,2);
  nt2i.V := at2i.V;
  TestDispName := 'Vector2d Op Divide 2i';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1 / nt2i; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1 / at2i; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeNegative;
begin
  TestDispName := 'Vector2d Op Negative';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := -nttd1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := -vttd1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeOpEqual;
begin
  TestDispName := 'Vector2d Op Equal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin res := nttd1 = nttd2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin res := vttd1 = vttd2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeOpNotEqual;
begin
  TestDispName := 'Vector2d Op Not Equal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin res := nttd1 <> nttd2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin res := vttd1 <> vttd2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeAbs;
begin
  TestDispName := 'Vector2d Abs';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.Abs; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.Abs; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeMin;
begin
  TestDispName := 'Vector2d Min';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.Min(nttd2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.Min(vttd2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeMax;
begin
  TestDispName := 'Vector2d Max';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.Max(nttd2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.Max(vttd2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeMinSingle;
begin
  TestDispName := 'Vector2d Min Double';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.Min(fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.Min(fs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeMaxSingle;
begin
  TestDispName := 'Vector2d Max Double';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.Max(fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.Max(fs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeClamp;
begin
  TestDispName := 'Vector2d Clamp';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.Clamp(nttd2, nttd1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.Clamp(vttd2, vttd1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeClampSingle;
begin
  TestDispName := 'Vector2d Clamp Double';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.Clamp(fs1, fs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.Clamp(fs1, fs2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeMulAdd;
begin
  TestDispName := 'Vector2d MulAdd';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.MulAdd(nttd2, nttd1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.MulAdd(vttd2, vttd1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeMulDiv;
begin
  TestDispName := 'Vector2d MulDiv';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.MulDiv(nttd2, nttd1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.Muldiv(vttd2, vttd1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeLengthVector;
begin
  TestDispName := 'Vector2d Length';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nttd1.Length; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := vttd1.Length; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeLengthSquareVector;
begin
  TestDispName := 'Vector2d LengthSquare';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nttd1.LengthSquare; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := vttd1.LengthSquare; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeDistanceVector;
begin
  TestDispName := 'Vector2d Distance';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nttd1.Distance(nttd2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := vttd1.Distance(vttd2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeDistanceSquareVector;
begin
  TestDispName := 'Vector2d DistanceSquare';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nttd1.DistanceSquare(nttd2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := vttd1.DistanceSquare(vttd2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeNormalizeVector;
begin
  TestDispName := 'Vector2d Normalize';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.Normalize; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.Normalize; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeDotProduct;
begin
  TestDispName := 'Vector2d DotProduct';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nttd1.DotProduct(nttd2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := vttd1.DotProduct(vttd2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeAngleBetween;
begin
  TestDispName := 'Vector2d AngleBetween';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nttd1.AngleBetween(nttd2,NativeNullVector2d); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := vttd1.AngleBetween(vttd2,NullVector2d); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeAngleCosine;
begin
  TestDispName := 'Vector2d AngleCosine';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nttd1.AngleCosine(nttd2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := vttd1.AngleCosine(vttd2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeRound;
begin
  TestDispName := 'Vector2d Round';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i := nttd1.Round; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt2i := vttd1.Round; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeTrunc;
begin
  TestDispName := 'Vector2d Trunc';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i := nttd1.Trunc; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt2i := vttd1.Trunc; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeFloor;
begin
  TestDispName := 'Vector2d Floor';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i := nttd1.Floor; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt2i := vttd1.Floor; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeCeil;
begin
  TestDispName := 'Vector2d Ceil';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i := nttd1.Ceil; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt2i := vttd1.Ceil; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeFract;
begin
  TestDispName := 'Vector2d Fract';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd2 := nttd1.Fract; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd2 := vttd1.Fract; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeSqrt;
begin
  TestDispName := 'Vector2d Sqrt';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd2 := nttd1.Sqrt; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd2 := vttd1.Sqrt; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeInvSqrt;
begin
  TestDispName := 'Vector2d InvSqrt';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd2 := nttd1.InvSqrt; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd2 := vttd1.InvSqrt; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2dOperatorsTimingTest.TimeModF;
begin
  nttd2.Create(2,2);
  vttd2.Create(2,2);
  TestDispName := 'Vector2d ModF';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nttd3 := nttd1.ModF(nttd2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vttd3 := vttd1.ModF(vttd2); end;
  GlobalProfiler[1].Stop;
end;

//procedure TVector2dOperatorsTimingTest.TimefMod;
//begin
//  nttd2.Create(2,2);
//  vttd2.Create(2,2);
//  TestDispName := 'Vector2d fMod';
//  GlobalProfiler[0].Clear;
//  GlobalProfiler[0].Start;
//  for cnt := 1 to Iterations do begin nt2i := nttd1.fMod(nttd2); end;
//  GlobalProfiler[0].Stop;
//  GlobalProfiler[1].Clear;
//  GlobalProfiler[1].Start;
//  for cnt := 1 to Iterations do begin vt2i := vttd1.fMod(vttd2); end;
//  GlobalProfiler[1].Stop;
//end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR2D, TVector2dOperatorsTimingTest);
end.
