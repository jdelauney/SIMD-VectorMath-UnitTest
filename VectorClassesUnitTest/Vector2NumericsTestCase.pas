unit Vector2NumericsTestCase;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

{$IFDEF USE_ASM_SSE_4}
  {$DEFINE USE_ASM_SSE_3}
{$ENDIF}

{$IFDEF USE_ASM_SSE_3}
  {$DEFINE USE_ASM}
{$ENDIF}

{$IFDEF USE_ASM_AVX}
  {$DEFINE USE_ASM}
{$ENDIF}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVector2NumericsTestCase }
  TVector2NumericsTestCase = class(TVectorBaseTestCase)
  published
    procedure TestCompare;       // these two test ensure we have data to play
    procedure TestCompareFalse;  // with and tests the compare function.
    procedure TestMin;
    procedure TestMax;
    procedure TestMinSingle;
    procedure TestMaxSingle;
    procedure TestClamp;
    procedure TestClampSingle;
    procedure TestMulAdd;
    procedure TestMulDiv;
    procedure TestLengthVector;
    procedure TestDistanceSquareVector;
    procedure TestDistanceVector;
    procedure TestLengthSquareVector;
    procedure TestNormalizeVector;
    procedure TestDotProduct;
    procedure TestAngleBetween;
    procedure TestAngleCosine;
    procedure TestRound;
    procedure TestTrunc;
    procedure TestFloor;
    procedure TestCeil;
    procedure TestFract;
    procedure TestSqrt;
    procedure TestInvSqrt;
    procedure TestModF;
    procedure TestfMod;
  end;

implementation

{%region%====[ TVector2NumericsTestCase ]=======================================}

procedure TVector2NumericsTestCase.TestCompare;
begin
  AssertTrue('Test Values do not match : '+ntt1.ToString+' --> '+vtt1.ToString, Compare(ntt1,vtt1));
end;

procedure TVector2NumericsTestCase.TestCompareFalse;
begin
  AssertFalse('Test Values should not match : '+ntt1.ToString+' --> '+vtt1.ToString, Compare(ntt1,vtt2));
end;

procedure TVector2NumericsTestCase.TestMin;
begin
  ntt3 := ntt1.Min(ntt2);
  vtt3 := vtt1.Min(vtt2);
  AssertTrue('Vector2f Min does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestMax;
begin
  ntt3 := ntt1.Max(ntt2);
  vtt3 := vtt1.Max(vtt2);
  AssertTrue('Vector2f Max does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestMinSingle;
begin
  ntt3 := ntt1.Min(fs1);
  vtt3 := vtt1.Min(fs1);
  AssertTrue('Vector2f MinSingle does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestMaxSingle;
begin
  ntt3 := ntt1.Max(fs1);
  vtt3 := vtt1.Max(fs1);
  AssertTrue('Vector2f MaxSingle does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestClamp;
begin
  ntt3 := ntt1.Clamp(ntt2, ntt1);
  vtt3 := vtt1.Clamp(vtt2, vtt1);
  AssertTrue('Vector2f Clamp does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestClampSingle;
begin
  ntt3 := ntt1.Clamp(fs1, fs2);
  vtt3 := vtt1.Clamp(fs1, fs2);
  AssertTrue('Vector2f ClampSingle does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestMulAdd;
begin
  ntt3 := ntt1.MulAdd(ntt2, ntt1);
  vtt3 := vtt1.MulAdd(vtt2, vtt1);
  AssertTrue('Vector2f  MulAdds does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestMulDiv;
begin
  ntt3 := ntt1.MulDiv(ntt2, ntt1);
  vtt3 := vtt1.MulDiv(vtt2, vtt1);
  AssertTrue('Vector2f  pMulDivs does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestLengthVector;
begin
  Fs1 := ntt1.Length;
  Fs2 := vtt1.Length;
  AssertTrue('Vector2f  lengths does not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-5));
end;

procedure TVector2NumericsTestCase.TestLengthSquareVector;
begin
  Fs1 := ntt1.LengthSquare;
  Fs2 := vtt1.LengthSquare;
  AssertTrue('Vector2f  lengths does not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-5));
end;

procedure TVector2NumericsTestCase.TestDistanceVector;
begin
  Fs1 := ntt1.Distance(ntt2);
  Fs2 := vtt1.Distance(vtt2);
  AssertTrue('Vector2f  distances does not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVector2NumericsTestCase.TestDistanceSquareVector;
begin
  Fs1 := ntt1.DistanceSquare(ntt2);
  Fs2 := vtt1.DistanceSquare(vtt2);
  AssertTrue('Vector2f  distances does not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVector2NumericsTestCase.TestNormalizeVector;
begin
  ntt3 := ntt1.Normalize;
  vtt3 := vtt1.Normalize;
  AssertTrue('Vector2f  Normalize does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3,1e-5));
end;

procedure TVector2NumericsTestCase.TestDotProduct;
begin
  Fs1 := ntt1.DotProduct(ntt2);
  Fs2 := vtt1.DotProduct(vtt2);
  AssertTrue('Vector2f DotProduct does not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVector2NumericsTestCase.TestAngleBetween;
begin
  Fs1 := ntt1.AngleBetween(ntt2, NativeNullVector2f);
  Fs2 := vtt1.AngleBetween(vtt2, NullVector2f);
  AssertTrue('Vector2f AngleBetween does not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVector2NumericsTestCase.TestAngleCosine;
begin
  Fs1 := ntt1.AngleCosine(ntt2);
  Fs2 := vtt1.AngleCosine(vtt2);
  AssertTrue('Vector2f AngleBetween does not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVector2NumericsTestCase.TestRound;
begin
  nt2i := ntt1.Round;
  vt2i := vtt1.Round;
  AssertTrue('Vector2f  Round do not match : '+nt2i.ToString+' --> '+vt2i.ToString, Compare(nt2i,vt2i));
end;

procedure TVector2NumericsTestCase.TestTrunc;
begin
  nt2i := ntt1.Trunc;
  vt2i := vtt1.Trunc;
  AssertTrue('Vector2f  Trunc do not match : '+nt2i.ToString+' --> '+vt2i.ToString, Compare(nt2i,vt2i));
end;

procedure TVector2NumericsTestCase.TestFloor;
begin
  nt2i := ntt1.Floor;
  vt2i := vtt1.Floor;
  AssertTrue('Vector2f  Floor do not match : '+nt2i.ToString+' --> '+vt2i.ToString, Compare(nt2i,vt2i));
end;

procedure TVector2NumericsTestCase.TestCeil;
begin
  nt2i := ntt1.Ceil;
  vt2i := vtt1.Ceil;
  AssertTrue('Vector2f  Ceil do not match : '+nt2i.ToString+' --> '+vt2i.ToString, Compare(nt2i,vt2i));
end;

procedure TVector2NumericsTestCase.TestFract;
begin
  ntt3 := ntt1.Fract;
  vtt3 := vtt1.Fract;
  AssertTrue('Vector2f  Fract does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestSqrt;
begin
  ntt3 := ntt1.Sqrt;
  vtt3 := vtt1.Sqrt;
  AssertTrue('Vector2f  Sqrt does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestInvSqrt;
begin
  ntt3 := ntt1.InvSqrt;
  vtt3 := vtt1.InvSqrt;
{$ifdef USE_ASM}
  AssertTrue('Vector2f  InvSqrt does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3,1e-4));
{$else}
  AssertTrue('Vector2f  InvSqrt does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3,1e-6));
{$endif}
end;

procedure TVector2NumericsTestCase.TestModF;
begin
  ntt2.Create(2,2);
  vtt2.Create(2,2);
  ntt3 := ntt1.Modf(ntt2);
  vtt3 := vtt1.Modf(vtt2);
  AssertTrue('Vector2f  ModF does not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3,1e-8));
end;

procedure TVector2NumericsTestCase.TestfMod;
begin
  ntt2.Create(2,2);
  vtt2.Create(2,2);
  nt2i := ntt1.fMod(ntt2);
  vt2i := vtt1.fMod(vtt2);
  AssertTrue('Vector2f  fMod do not match : '+#13+#10+ntt1.ToString+' --> '+vtt1.ToString+#13+#10+
                                                      ntt2.ToString+' --> '+vtt2.ToString+#13+#10+
                                                      nt2i.ToString+' --> '+vt2i.ToString,
                                                      Compare(nt2i,vt2i));
end;


{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR2F, TVector2NumericsTestCase);
end.





