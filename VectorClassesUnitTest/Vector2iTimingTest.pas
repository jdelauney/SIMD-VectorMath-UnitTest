unit Vector2iTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

{$I config.inc}

type
  TVector2iTimingTest = class(TVectorBaseTimingTest)
  private
    nt2i1, nt2i2, nt2i3, nt2i4: TNativeGLZVector2i;
    at2i1, at2i2, at2i3, at2i4: TGLZVector2i;
  protected
    procedure Setup; override;
  published
    procedure TimeOpAdd;
    procedure TimeOpSub;
    procedure TimeOpDiv;
    procedure TimeOpMul;
    procedure TimeOpMulSingle;
    procedure TimeOpAddInteger;
    procedure TimeOpSubInteger;
    procedure TimeOpDivInteger;
    procedure TimeOpMulInteger;
    procedure TimeOpDivideSingle;
    procedure TimeOpNegate;
    procedure TimeEquals;
    procedure TimeNotEquals;
    procedure TimeMod;
    procedure TimeMin;
    procedure TimeMax;
    procedure TimeMinInteger;
    procedure TimeMaxInteger;
    procedure TimeClamp;
    procedure TimeClampInteger;
    procedure TimeMulAdd;
    procedure TimeMulDiv;
    procedure TimeLength;
    procedure TimeLengthSquare;
    procedure TimeDistance;
    procedure TimeDistanceSquare;
    procedure TimeNormalize;
    procedure TimeDotProduct;
    procedure TimeAngleBetween;
    procedure TimeAngleCosine;
    procedure TimeAbs;
  end;

implementation

procedure TVector2iTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector2i;
  at2i1.Create(2,6);
  at2i2.Create(1,1);
  at2i4.Create(8,8);
  nt2i1.V := at2i1.V;
  nt2i2.V := at2i2.V;
  nt2i4.V := at2i4.V;
end;

procedure TVector2iTimingTest.TimeOpAdd;
begin
  TestDispName := 'Vector2i Op Add';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 + nt2i2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 + at2i2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpSub;
begin
  TestDispName := 'Vector2i Op Sub';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 - nt2i2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 - at2i2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpDiv;
begin
  TestDispName := 'Vector2i Op Div';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 div nt2i2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 div at2i2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpMul;
begin
  TestDispName := 'Vector2i Op Mul';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 * nt2i2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 * at2i2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpMulSingle;
begin
  TestDispName := 'Vector2i Op Mul Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 * 2.3; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 * 2.3; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpAddInteger;
begin
  TestDispName := 'Vector2i Op Add Integer';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 + 2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 + 2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpSubInteger;
begin
  TestDispName := 'Vector2i Op Sub Integer';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 - 2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 - 2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpDivInteger;
begin
  TestDispName := 'Vector2i Op Div Integer';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 div 2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 div 2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpMulInteger;
begin
  TestDispName := 'Vector2i Op Mul Integer';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 * 2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 * 2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpDivideSingle;
begin
  TestDispName := 'Vector2i Op Divide Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 / 2.3; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 / 2.3; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeOpNegate;
begin
  TestDispName := 'Vector2i Op Negate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := -nt2i1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := -at2i1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeEquals;
begin
  TestDispName := 'Vector2i Op Equals';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := nt2i1 = nt2i1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin nb := at2i1 = at2i1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeNotEquals;
begin
  TestDispName := 'Vector2i Op Not Equals';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := nt2i1 <> nt2i1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin nb := at2i1 <> at2i1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeMod;
begin
  TestDispName := 'Vector2i Mod';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1 mod nt2i2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1 mod at2i2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeMin;
begin
  TestDispName := 'Vector2i Min';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1.Min(nt2i2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1.Min(at2i2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeMax;
begin
  TestDispName := 'Vector2i Max';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1.Max(nt2i2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1.Max(at2i2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeMinInteger;
begin
  TestDispName := 'Vector2i Min Integer';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1.Min(2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1.Min(2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeMaxInteger;
begin
  TestDispName := 'Vector2i Max Integer';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1.Max(2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1.Max(2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeClamp;
begin
  TestDispName := 'Vector2i Clamp';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1.Clamp(nt2i2,nt2i4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1.Clamp(at2i2,at2i4); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeClampInteger;
begin
  TestDispName := 'Vector2i Clamp Integer';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1.Clamp(2,4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1.Clamp(2,4); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeMulAdd;
begin
  TestDispName := 'Vector2i MulAdd';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1.MulAdd(nt2i2,nt2i4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1.MulAdd(at2i2,at2i4); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeMulDiv;
begin
  TestDispName := 'Vector2i MulDiv';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1.MulDiv(nt2i2,nt2i4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1.MulDiv(at2i2,at2i4); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeLength;
begin
  TestDispName := 'Vector2i Length';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nt2i1.Length; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := at2i1.Length; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeLengthSquare;
begin
  TestDispName := 'Vector2i Length Squared';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nt2i1.LengthSquare; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := at2i1.LengthSquare; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeDistance;
begin
  TestDispName := 'Vector2i Distance';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nt2i1.Distance(nt2i2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := at2i1.Distance(at2i2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeDistanceSquare;
begin
  TestDispName := 'Vector2i Distance Squared';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nt2i1.DistanceSquare(nt2i2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := at2i1.DistanceSquare(at2i2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeNormalize;
begin
  TestDispName := 'Vector2i Normalize';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin ntt1 := nt2i1.Normalize; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vtt1 := at2i1.Normalize; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeDotProduct;
begin
  TestDispName := 'Vector2i DotProduct';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nt2i1.DotProduct(nt2i2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := at2i1.DotProduct(at2i2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeAngleBetween;
begin
  TestDispName := 'Vector2i AngleBetween';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nt2i1.AngleBetween(nt2i2,nt2i4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := at2i1.AngleBetween(at2i2,at2i4); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector2iTimingTest.TimeAngleCosine;
begin
  TestDispName := 'Vector2i AngleCosine';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nt2i1.AngleCosine(nt2i2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin fs1 := at2i1.AngleCosine(at2i2); end;
  GlobalProfiler[1].Stop;

end;

procedure TVector2iTimingTest.TimeAbs;
begin
  TestDispName := 'Vector2i Abs';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt2i3 := nt2i1.Abs; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin at2i3 := at2i1.Abs; end;
  GlobalProfiler[1].Stop;
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR2I, TVector2iTimingTest);
end.

