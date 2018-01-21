unit VectorOnSelfTestCase;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVectorOnSelfTestCase }
  TVectorOnSelfTestCase = class(TVectorBaseTestCase)
  published
    procedure TestCompare;       // these two test ensure we have data to play
    procedure TestCompareFalse;  // with and tests the compare function.

    procedure TestpAddVector;
    procedure TestpAddSingle;
    procedure TestpSubVector;
    procedure TestpSubSingle;
    procedure TestpMulVector;
    procedure TestpMulSingle;
    procedure TestpDivVector;
    procedure TestpDivSingle;
    procedure TestpInvert;
    procedure TestpNegate;
    procedure TestpAbs;
    procedure TestpDivideBy2;
    procedure TestpCrossProduct;
    procedure TestpNormalize;
    procedure TestpMulAdd;
    procedure TestpMulDiv;
    procedure TestpClampVector;
    procedure TestpClampSingle;
  end;

implementation

{%region%====[ TVectorOnSelfTestCase ]=========================================}

procedure TVectorOnSelfTestCase.TestCompare;
begin
  AssertTrue('Test Values do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestCompareFalse;
begin
  AssertFalse('Test Values should not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt2));
end;

procedure TVectorOnSelfTestCase.TestpAddVector;
begin
  nt1.pAdd(nt2);
  vt1.pAdd(vt2);
  AssertTrue('Vector pAdds Vectors do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpAddSingle;
begin
  nt1.pAdd(Fs1);
  vt1.pAdd(Fs1);
  AssertTrue('Vector pAdd Singles do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpSubVector;
begin
  nt1.pSub(nt2);
  vt1.pSub(vt2);
  AssertTrue('Vector pSub Vectors do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpSubSingle;
begin
  nt1.pSub(Fs1);
  vt1.pSub(Fs1);
  AssertTrue('Vector pSub singles do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpMulVector;
begin
  nt1.pMul(nt2);
  vt1.pMul(vt2);
  AssertTrue('Vector pMul Vectors do not match'+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpMulSingle;
begin
  nt1.pMul(Fs1);
  vt1.pMul(Fs1);
  AssertTrue('Vector pMul singles do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpDivVector;
begin
  nt1.pDiv(nt2);
  vt1.pDiv(vt2);
  AssertTrue('Vector pDiv Vectors do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpDivSingle;
begin
  nt1.pDiv(Fs1);
  vt1.pDiv(Fs1);
  AssertTrue('Vector pDiv singles do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpInvert;
begin
  nt1.pInvert;
  vt1.pInvert;
  AssertTrue('Vector pInverts do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpNegate;
begin
  nt1.pNegate;
  vt1.pNegate;
  AssertTrue('Vector pNegates do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpAbs;
begin
  nt1.pAbs;
  vt1.pAbs;
  AssertTrue('Vector pAbs do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpDivideBy2;
begin
  nt1.pDivideBy2;
  vt1.pDivideBy2;
  AssertTrue('Vector pAbs do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpCrossProduct;
begin
  nt1.pCrossProduct(nt2);
  vt1.pCrossProduct(vt2);
  AssertTrue('Vector pCrossProducts do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpNormalize;
begin
  nt1.pNormalize;
  vt1.pNormalize;
  AssertTrue('Vector pNormalizes do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1, 1e-5));
end;

procedure TVectorOnSelfTestCase.TestpMulAdd;
begin
  nt1.pMulAdd(nt2, nt1);
  vt1.pMulAdd(vt2, vt1);
  AssertTrue('Vector pMulAdds do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpMulDiv;
begin
  nt1.pMulDiv(nt2, nt1);
  vt1.pMulDiv(vt2, vt1);
  AssertTrue('Vector pMulDivs do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpClampVector;
begin
  nt3 := nt1.DivideBy2;
  vt3.V := nt3.V;
  nt1.pClamp(nt2,nt3);
  vt1.pClamp(vt2,vt3);
  AssertTrue('Vector pClamp vectors do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOnSelfTestCase.TestpClampSingle;
begin
  nt1.pClamp(fs2,fs1);
  vt1.pClamp(fs2,fs1);
  AssertTrue('Vector pClampSingle do not match : '+ nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVectorOnSelfTestCase);

end.




