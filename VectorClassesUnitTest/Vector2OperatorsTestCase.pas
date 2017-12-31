unit Vector2OperatorsTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVector2OperatorsTestCase }
  TVector2OperatorsTestCase = class(TVectorBaseTestCase)
  published
    procedure TestCompare;       // these two test ensure we have data to play
    procedure TestCompareFalse;  // with and tests the compare function.
    procedure TestAddVector;
    procedure TestAddSingle;
    procedure TestSubVector;
    procedure TestSubSingle;
    procedure TestMulVector;
    procedure TestMulSingle;
    procedure TestDivVector;
    procedure TestDivSingle;
    procedure TestEqualVector;
    procedure TestUnEqualVector;
  end;

implementation

{%region%====[ TVector2OperatorsTestCase ]======================================}

{Test IsEqual and we have same values for each class ttpe}
procedure TVector2OperatorsTestCase.TestCompare;
begin
  AssertTrue('Test Values do not match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt1,vtt1));
end;

procedure TVector2OperatorsTestCase.TestCompareFalse;
begin
  AssertFalse('Test Values should not match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt1,vtt2));
end;

procedure TVector2OperatorsTestCase.TestAddVector;
begin
  ntt3 := ntt2 + ntt1;
  vtt3 := vtt1 + vtt2;
  AssertTrue('Vector + Vector no match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2OperatorsTestCase.TestAddSingle;
begin
  ntt3 := ntt1 + fs1;
  vtt3 := vtt1 + fs1;
  AssertTrue('Vector + Single no match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2OperatorsTestCase.TestSubVector;
begin
  ntt3 := ntt2 - ntt1;
  vtt3 := vtt2 - vtt1;
  AssertTrue('Vector - Vector no match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2OperatorsTestCase.TestSubSingle;
begin
  ntt3 := ntt1 - fs1;
  vtt3 := vtt1 - fs1;
  AssertTrue('Vector - Single no match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2OperatorsTestCase.TestMulVector;
begin
  ntt3 := ntt2 * ntt1;
  vtt3 := vtt2 * vtt1;
  AssertTrue('Vector x Vector no match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2OperatorsTestCase.TestMulSingle;
begin
  ntt3 := ntt1 * fs1;
  vtt3 := vtt1 * fs1;
  AssertTrue('Vector x Single no match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2OperatorsTestCase.TestDivVector;
begin
  ntt3 := ntt2 / ntt1;
  vtt3 := vtt2 / vtt1;
  AssertTrue('Vector / Vector no match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3));
end;

procedure TVector2OperatorsTestCase.TestDivSingle;
begin
  ntt3 := ntt1 / fs1;
  vtt3 := vtt1 / fs1;
  AssertTrue('Vector / Single no match'+ntt3.ToString+' --> '+vtt3.ToString, Compare(ntt3,vtt3,1e-5));
end;

procedure TVector2OperatorsTestCase.TestEqualVector;
begin
  nb := ntt1 = ntt1;
  vb := vtt1 = vtt1;
  AssertTrue('Vectors should be equal'+ntt1.ToString+' --> '+vtt1.ToString, not(nb xor vb));
end;


procedure TVector2OperatorsTestCase.TestUnEqualVector;
begin
  nb := ntt1 <> ntt2;
  vb := vtt1 <> vtt2;
  AssertTrue('Vectors should be equal'+vtt1.ToString+' --> '+vtt2.ToString, not(nb xor vb));
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR2F, TVector2OperatorsTestCase);
end.

