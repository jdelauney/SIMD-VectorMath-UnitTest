unit Vector2NumericsTestCase;

{$mode objfpc}{$H+}

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
    //procedure TestAbsVector;
    procedure TestNegateVector;

    procedure TestDistanceVector;
    procedure TestLengthVector;
    procedure TestNormalizeVector;
    procedure TestMulAdd;
    procedure TestMulDiv;

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

(*procedure TVector2NumericsTestCase.TestAbsVector;
begin
  ntt3 := ntt1.Abs;
  vtt3 := vtt1.Abs;
  AssertTrue('Vector2f  Abs do not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end; *)

procedure TVector2NumericsTestCase.TestNegateVector;
begin
  //ntt3 := ntt1.Negate;
  //vtt3 := vtt1.Negate;
  AssertTrue('Vector2f  negates do not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;


procedure TVector2NumericsTestCase.TestDistanceVector;
begin
  Fs1 := ntt1.Distance(ntt2);
  Fs2 := vtt1.Distance(vtt2);
  AssertTrue('Vector2f  distances do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));//
end;

procedure TVector2NumericsTestCase.TestLengthVector;
begin
  Fs1 := ntt1.Length;
  Fs2 := vtt1.Length;
  AssertTrue('Vector2f  lengths do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-5));
end;


procedure TVector2NumericsTestCase.TestNormalizeVector;
begin
  ntt3 := ntt1.Normalize;
  vtt3 := vtt1.Normalize;
  AssertTrue('Vector2f  Normalize do not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3,1e-5));
end;

procedure TVector2NumericsTestCase.TestMulAdd;
begin
  ntt3 := ntt1.MulAdd(ntt2, ntt1);
  vtt3 := vtt1.MulAdd(vtt2, vtt1);
  AssertTrue('Vector2f  MulAdds do not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2NumericsTestCase.TestMulDiv;
begin
  ntt3 := ntt1.MulDiv(ntt2, ntt1);
  vtt3 := vtt1.MulDiv(vtt2, vtt1);
  AssertTrue('Vector2f  pMulDivs do not match : '+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;


{%endregion%}

initialization
  RegisterTest(TVector2NumericsTestCase);
end.





