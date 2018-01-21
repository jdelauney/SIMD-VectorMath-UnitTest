unit VectorNumericsTestCase;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVectorNumericsTestCase }
  TVectorNumericsTestCase = class(TVectorBaseTestCase)
  published
    procedure TestCompare;       // these two test ensure we have data to play
    procedure TestCompareFalse;  // with and tests the compare function.
    procedure TestAbsVector;
    procedure TestNegateVector;
    procedure TestDivideBy2Vector;
    procedure TestDistanceVector;
    procedure TestDistanceSquareVector;
    procedure TestLengthVector;
    procedure TestLengthSquareVector;
    procedure TestSpacingVector;
    procedure TestDotProductVector;
    procedure TestCrossProductVector;
    procedure TestNormalizeVector;
    procedure TestNormVector;
    procedure TestMulAdd;
    procedure TestMulDiv;
    procedure TestAngleCosine;
    procedure TestAngleBetweem;
    procedure TestRound;
    procedure TestTrunc;
  end;

implementation

{%region%====[ TVectorNumericsTestCase ]=======================================}

procedure TVectorNumericsTestCase.TestCompare;
begin
  AssertTrue('Test Values do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorNumericsTestCase.TestCompareFalse;
begin
  AssertFalse('Test Values should not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt2));
end;

procedure TVectorNumericsTestCase.TestAbsVector;
begin
  nt3 := nt1.Abs;
  vt3 := vt1.Abs;
  AssertTrue('Vector Abs do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorNumericsTestCase.TestNegateVector;
begin
  nt3 := nt1.Negate;
  vt3 := vt1.Negate;
  AssertTrue('Vector negates do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorNumericsTestCase.TestDivideBy2Vector;
begin
  nt3 := nt1.DivideBy2;
  vt3 := vt1.DivideBy2;
  AssertTrue('Vector divide by 2 do not match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorNumericsTestCase.TestDistanceVector;
begin
  Fs1 := nt1.Distance(nt2);
  Fs2 := vt1.Distance(vt2);
  AssertTrue('Vector distances do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorNumericsTestCase.TestDistanceSquareVector;
begin
  Fs1 := nt1.DistanceSquare(nt2);
  Fs2 := vt1.DistanceSquare(vt2);
  AssertTrue('Vector distancesquare do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorNumericsTestCase.TestLengthVector;
begin
  Fs1 := nt1.Length;
  Fs2 := vt1.Length;
  AssertTrue('Vector lengths do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-5));
end;

procedure TVectorNumericsTestCase.TestLengthSquareVector;
begin
  Fs1 := nt1.LengthSquare;
  Fs2 := vt1.LengthSquare;
  AssertTrue('Vector lengthSquared do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-4));
end;

procedure TVectorNumericsTestCase.TestSpacingVector;
begin
  Fs1 := nt1.Spacing(nt2);
  Fs2 := vt1.Spacing(vt2);
  AssertTrue('Vector spacing do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-5));
end;

procedure TVectorNumericsTestCase.TestDotProductVector;
begin
  Fs1 := nt1.DotProduct(nt2);
  Fs2 := vt1.DotProduct(vt2);
  AssertTrue('Vector DotProducts do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-5));
end;

procedure TVectorNumericsTestCase.TestCrossProductVector;
begin
  nt3 := nt1.CrossProduct(nt2);
  vt3 := vt1.CrossProduct(vt2);
  AssertTrue('Vector CrossProducts do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorNumericsTestCase.TestNormalizeVector;
begin
  nt3 := nt1.Normalize;
  vt3 := vt1.Normalize;
  AssertTrue('Vector Normalize do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3,1e-5));
end;

procedure TVectorNumericsTestCase.TestNormVector;
begin
  Fs1 := nt1.Norm;
  Fs2 := vt1.Norm;
  AssertTrue('Vector Norms do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-4));
end;

procedure TVectorNumericsTestCase.TestMulAdd;
begin
  nt3 := nt1.MulAdd(nt2, nt1);
  vt3 := vt1.MulAdd(vt2, vt1);
  AssertTrue('Vector MulAdds do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorNumericsTestCase.TestMulDiv;
begin
  nt3 := nt1.MulDiv(nt2, nt1);
  vt3 := vt1.MulDiv(vt2, vt1);
  AssertTrue('Vector pMulDivs do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorNumericsTestCase.TestAngleCosine;
begin
  Fs1 := nt1.AngleCosine(nt2);
  Fs2 := vt1.AngleCosine(vt2);
  AssertTrue('Vector AngleCosines do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorNumericsTestCase.TestAngleBetweem;
begin
  Fs1 := nt1.AngleBetween(nt2, norg);
  Fs2 := vt1.AngleBetween(vt2, vorg);
  AssertTrue('Vector AngleBetweens do not match'+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorNumericsTestCase.TestRound;
begin
  nt4i := nt1.Round;
  vt4i := vt1.Round;
  AssertTrue('Vector4f  Round do not match : '+nt4i.ToString+' --> '+vt4i.ToString, Compare(nt4i,vt4i));
end;

procedure TVectorNumericsTestCase.TestTrunc;
begin
  nt4i := nt1.Trunc;
  vt4i := vt1.Trunc;
  AssertTrue('Vector4f  Trunc do not match : '+nt4i.ToString+' --> '+vt4i.ToString, Compare(nt4i,vt4i));
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVectorNumericsTestCase);
end.




