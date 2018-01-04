unit Vector3bComparatorTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  { TVector3bComparatorTest }

  TVector3bComparatorTest = class(TByteVectorBaseTestCase)
    published
      procedure TestCompare;
      procedure TestCompareFalse;
      procedure TestOpAdd;
      procedure TestOpAddByte;
      procedure TestOpSub;
      procedure TestOpSubByte;
      procedure TestOpMul;
      procedure TestOpMulByte;
      procedure TestOpDiv;
      procedure TestOpDivByte;
      procedure TestOpEquality;
      procedure TestOpNotEquals;
      procedure TestOpAnd;
      procedure TestOpAndByte;
      procedure TestOpOr;
      procedure TestOpOrByte;
      procedure TestOpXor;
      procedure TestOpXorByte;
      procedure TestSwizzle;

  end;

implementation

procedure TVector3bComparatorTest.TestCompare;
begin
   AssertTrue('Test Values do not match'+nbt1.ToString+' --> '+abt1.ToString, Compare(nbt1,abt1));
end;

procedure TVector3bComparatorTest.TestCompareFalse;
begin
   AssertFalse('Test Values should not match'+nbt1.ToString+' --> '+abt2.ToString, Compare(nbt1,abt2));
end;

procedure TVector3bComparatorTest.TestOpAdd;
begin
   nbt3 := nbt1 + nbt2;
   abt3 := abt1 + abt2;
   AssertTrue('Vector + Vector no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpAddByte;
begin
   nbt3 := nbt1 + b1;
   abt3 := abt1 + b1;
   AssertTrue('Vector + Byte no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpSub;
begin
   nbt3 := nbt1 - nbt2;
   abt3 := abt1 - abt2;
   AssertTrue('Vector - Vector no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpSubByte;
begin
   nbt3 := nbt1 - b1;
   abt3 := abt1 - b1;
   AssertTrue('Vector - Byte no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpMul;
begin
   nbt3 := nbt1 * nbt2;
   abt3 := abt1 * abt2;
   AssertTrue('Vector * Vector no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpMulByte;
begin
   nbt3 := nbt1 * b1;
   abt3 := abt1 * b1;
   AssertTrue('Vector * Byte no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpDiv;
begin
   nbt3 := nbt1 Div nbt2;
   abt3 := abt1 Div abt2;
   AssertTrue('Vector Div Vector no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpDivByte;
begin
   nbt3 := nbt1 Div b1;
   abt3 := abt1 Div b1;
   AssertTrue('Vector Div Byte no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpEquality;
begin
  nb := nbt1 = nbt1;
  ab := abt1 = abt1;
  AssertTrue('Vector = do not match'+nb.ToString+' --> '+ab.ToString, (nb = ab));
  nb := nbt1 = nbt2;
  ab := abt1 = abt2;
  AssertTrue('Vector = should not match'+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

procedure TVector3bComparatorTest.TestOpNotEquals;
begin
  nb := nbt1 = nbt1;
  ab := abt1 = abt1;
  AssertTrue('Vector <> do not match'+nb.ToString+' --> '+ab.ToString, (nb = ab));
  nb := nbt1 = nbt2;
  ab := abt1 = abt2;
  AssertTrue('Vector <> should not match'+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

procedure TVector3bComparatorTest.TestOpAnd;
begin
   nbt3 := nbt1 and nbt2;
   abt3 := abt1 and abt2;
   AssertTrue('Vector And Vector no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpAndByte;
begin
   nbt3 := nbt1 and b5;
   abt3 := abt1 and b5;
   AssertTrue('Vector And Byte no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpOr;
begin
   nbt3 := nbt1 or nbt2;
   abt3 := abt1 or abt2;
   AssertTrue('Vector Or Vector no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpOrByte;
begin
   nbt3 := nbt1 or b1;
   abt3 := abt1 or b1;
   AssertTrue('Vector Or Byte no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpXor;
begin
   nbt3 := nbt1 xor nbt2;
   abt3 := abt1 xor abt2;
   AssertTrue('Vector Xor Vector no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;

procedure TVector3bComparatorTest.TestOpXorByte;
begin
   nbt3 := nbt1 xor b1;
   abt3 := abt1 xor b1;
   AssertTrue('Vector Xor Byte no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;



procedure TVector3bComparatorTest.TestSwizzle;
begin
   nbt3 := nbt1.Swizzle(swBRG);
   abt3 := abt1.Swizzle(swBRG);
   AssertTrue('Vector Swizzle no match'+nbt3.ToString+' --> '+abt3.ToString, Compare(nbt3,abt3));
end;




initialization
  RegisterTest(REPORT_GROUP_VECTOR3B, TVector3bComparatorTest);
end.

