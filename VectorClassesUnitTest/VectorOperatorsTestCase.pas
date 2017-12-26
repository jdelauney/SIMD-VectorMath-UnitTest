unit VectorOperatorsTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVectorOperatorsTestCase }
  TVectorOperatorsTestCase = class(TVectorBaseTestCase)
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
    procedure TestSomeEqualVector;
    procedure TestUnEqualVector;
    procedure TestLTorEqualVector;
    procedure TestLTorEqualOneGreaterVector;
    procedure TestGTorEqualVector;
    procedure TestGTorEqualOneLessVector;
    procedure TestLTVector;
    procedure TestLTOneGreaterVector;
    procedure TestGTVector;
    procedure TestGTOneLessVector;
  end;

implementation

{%region%====[ TVectorOperatorsTestCase ]======================================}

{Test IsEqual and we have same values for each class ttpe}
procedure TVectorOperatorsTestCase.TestCompare;
begin
  AssertTrue('Test Values do not match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt1,vt1));
end;

procedure TVectorOperatorsTestCase.TestCompareFalse;
begin
  AssertFalse('Test Values should not match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt1,vt2));
end;

procedure TVectorOperatorsTestCase.TestAddVector;
begin
  nt3 := nt2 + nt1;
  vt3 := vt1 + vt2;
  AssertTrue('Vector + Vector no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOperatorsTestCase.TestAddSingle;
begin
  nt3 := nt1 + fs1;
  vt3 := vt1 + fs1;
  AssertTrue('Vector + Single no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOperatorsTestCase.TestSubVector;
begin
  nt3 := nt2 - nt1;
  vt3 := vt2 - vt1;
  AssertTrue('Vector - Vector no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOperatorsTestCase.TestSubSingle;
begin
  nt3 := nt1 - fs1;
  vt3 := vt1 - fs1;
  AssertTrue('Vector - Single no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOperatorsTestCase.TestMulVector;
begin
  nt3 := nt2 * nt1;
  vt3 := vt2 * vt1;
  AssertTrue('Vector x Vector no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOperatorsTestCase.TestMulSingle;
begin
  nt3 := nt1 * fs1;
  vt3 := vt1 * fs1;
  AssertTrue('Vector x Single no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOperatorsTestCase.TestDivVector;
begin
  nt3 := nt2 / nt1;
  vt3 := vt2 / vt1;
  AssertTrue('Vector / Vector no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOperatorsTestCase.TestDivSingle;
begin
  nt3 := nt1 / fs1;
  vt3 := vt1 / fs1;
  AssertTrue('Vector / Single no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOperatorsTestCase.TestEqualVector;
begin
  nb := nt1 = nt1;
  vb := vt1 = vt1;
  AssertTrue('Vectors should be equal'+nt1.ToString+' --> '+vt1.ToString, not(nb xor vb));
end;

procedure TVectorOperatorsTestCase.TestSomeEqualVector;
begin
  at1.V := vt1.V;
  at1.X := at1.X +1;
  at1.Z := at1.Z - 1;
  ant1.V := at1.V;
  nb := nt1 = ant1;
  vb := vt1 = at1;
  AssertTrue('Vectors should not be equal'+vt1.ToString+' --> '+at1.ToString, not(nb xor vb));
end;

procedure TVectorOperatorsTestCase.TestUnEqualVector;
begin
  nb := nt1 = nt2;
  vb := vt1 = vt2;
  AssertTrue('Vectors should be equal'+vt1.ToString+' --> '+vt2.ToString, not(nb xor vb));
end;

procedure TVectorOperatorsTestCase.TestLTorEqualVector;
begin
  at1 := vt1 - 1;
  ant1.V := at1.V;
  nb := at1 <= vt1;
  vb := ant1 <= nt1;
  AssertTrue('Vectors should be equal'+at1.ToString+' --> '+vt1.ToString, not(nb xor vb));

end;

procedure TVectorOperatorsTestCase.TestLTorEqualOneGreaterVector;
begin
  at1 := vt1 - 1;
  at1.Y := vt1.Y + 1;
  ant1.V := at1.V;
  nb := at1 <= vt1;
  vb := ant1 <= nt1;
  AssertTrue('Vectors should be equal'+at1.ToString+' --> '+vt1.ToString, not(nb xor vb));
end;

procedure TVectorOperatorsTestCase.TestGTorEqualVector;
begin
  at1 := vt1 + 1;
  ant1.V := at1.V;
  nb := at1 >= vt1;
  vb := ant1 >= nt1;
  AssertTrue('Vectors should be gt equal'+at1.ToString+' --> '+vt1.ToString, not(nb xor vb));
end;

procedure TVectorOperatorsTestCase.TestGTorEqualOneLessVector;
begin
  at1 := vt1 + 1;
  at1.Y := vt1.Y - 1;
  ant1.V := at1.V;
  nb := at1 >= vt1;
  vb := ant1 >= nt1;
  AssertTrue('Vectors should be equal'+at1.ToString+' --> '+vt1.ToString, not(nb xor vb));
end;

procedure TVectorOperatorsTestCase.TestLTVector;
begin
  at1 := vt1 - 1;
  ant1.V := at1.V;
  nb := at1 <= vt1;
  vb := ant1 <= nt1;
  AssertTrue('Vectors should be equal'+at1.ToString+' --> '+vt1.ToString, not(nb xor vb));
end;

procedure TVectorOperatorsTestCase.TestLTOneGreaterVector;
begin
  at1 := vt1 - 1;
  at1.Y := vt1.Y + 1;
  ant1.V := at1.V;
  nb := at1 <= vt1;
  vb := ant1 <= nt1;
  AssertTrue('Vectors should be equal'+at1.ToString+' --> '+vt1.ToString, not(nb xor vb));
end;

procedure TVectorOperatorsTestCase.TestGTVector;
begin
  at1 := vt1 + 1;
  ant1.V := at1.V;
  nb := at1 >= vt1;
  vb := ant1 >= nt1;
  AssertTrue('Vectors should be gt equal'+at1.ToString+' --> '+vt1.ToString, not(nb xor vb));
end;

procedure TVectorOperatorsTestCase.TestGTOneLessVector;
begin
  at1 := vt1 + 1;
  at1.Y := vt1.Y - 1;
  ant1.V := at1.V;
  nb := at1 >= vt1;
  vb := ant1 >= nt1;
  AssertTrue('Vectors should be equal'+at1.ToString+' --> '+vt1.ToString, not(nb xor vb));
end;

{%endregion%}

initialization
  RegisterTest(TVectorOperatorsTestCase);
end.

