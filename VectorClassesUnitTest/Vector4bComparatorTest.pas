unit Vector4bComparatorTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVector4bComparatorTest }

  TVector4bComparatorTest = class(TByteVectorBaseTestCase)
    published
      procedure TestCompare;
      procedure TestCompareFalse;
      procedure TestCreateBytes;
      procedure TestCreatefrom3b;
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
      procedure TestDivideBy2;
      procedure TestOpMin;
      procedure TestOpMinByte;
      procedure TestOpMax;
      procedure TestOpMaxByte;
      procedure TestOpClamp;
      procedure TestOpClampByte;
      procedure TestMulAdd;
      procedure TestMulDiv;
      procedure TestShuffle;
      procedure TestSwizzle;
      procedure TestCombine;
      procedure TestCombine2;
      procedure TestCombine3;
      procedure TestMinXYZComponent;
      procedure TestMaxXYZComponent;
  end;

implementation


{%region%----[ TVector4b Operators ]--------------------------------------------}
procedure TVector4bComparatorTest.TestCompare;
begin
   AssertTrue('Test Values do not match'+nbf1.ToString+' --> '+abf1.ToString, Compare(nbf1,abf1));
end;

procedure TVector4bComparatorTest.TestCompareFalse;
begin
   AssertFalse('Test Values should not match'+nbf1.ToString+' --> '+abf2.ToString, Compare(nbf1,abf2));
end;

procedure TVector4bComparatorTest.TestCreateBytes;
begin
   nbf3.Create(b1,b2,b3,b7);
   abf3.Create(b1,b2,b3,b7);
   AssertTrue('Vector Create no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestCreatefrom3b;
begin
   nbf3.Create(nbt1,b7);
   abf3.Create(abt1,b7);
   AssertTrue('Vector Create no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpAdd;
begin
   nbf3 := nbf1 + nbf2;
   abf3 := abf1 + abf2;
   AssertTrue('Vector + Vector no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpAddByte;
begin
   nbf3 := nbf1 + b1;
   abf3 := abf1 + b1;
   AssertTrue('Vector + Byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpSub;
begin
   nbf3 := nbf1 - nbf2;
   abf3 := abf1 - abf2;
   AssertTrue('Vector - Vector no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpSubByte;
begin
   nbf3 := nbf1 - b1;
   abf3 := abf1 - b1;
   AssertTrue('Vector - Byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpMul;
begin
   nbf3 := nbf1 * nbf2;
   abf3 := abf1 * abf2;
   AssertTrue('Vector * Vector no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpMulByte;
begin
   nbf3 := nbf1 * b1;
   abf3 := abf1 * b1;
   AssertTrue('Vector * Byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpDiv;
begin
   nbf3 := nbf1 Div nbf2;
   abf3 := abf1 Div abf2;
   AssertTrue('Vector Div Vector no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpDivByte;
begin
   nbf3 := nbf1 Div b1;
   abf3 := abf1 Div b1;
   AssertTrue('Vector Div Byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpEquality;
begin
  nb := nbf1 = nbf1;
  ab := abf1 = abf1;
  AssertTrue('Vector = do not match'+nb.ToString+' --> '+ab.ToString, (nb = ab));
  nb := nbf1 = nbf2;
  ab := abf1 = abf2;
  AssertTrue('Vector = should not match'+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

procedure TVector4bComparatorTest.TestOpNotEquals;
begin
  nb := nbf1 = nbf1;
  ab := abf1 = abf1;
  AssertTrue('Vector <> do not match'+nb.ToString+' --> '+ab.ToString, (nb = ab));
  nb := nbf1 = nbf2;
  ab := abf1 = abf2;
  AssertTrue('Vector <> should not match'+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

procedure TVector4bComparatorTest.TestOpAnd;
begin
   nbf3 := nbf1 and nbf2;
   abf3 := abf1 and abf2;
   AssertTrue('Vector And Vector no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpAndByte;
begin
   nbf3 := nbf1 and b5;
   abf3 := abf1 and b5;
   AssertTrue('Vector And Byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpOr;
begin
   nbf3 := nbf1 or nbf2;
   abf3 := abf1 or abf2;
   AssertTrue('Vector Or Vector no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpOrByte;
begin
   nbf3 := nbf1 or b1;
   abf3 := abf1 or b1;
   AssertTrue('Vector Or Byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpXor;
begin
   nbf3 := nbf1 xor nbf2;
   abf3 := abf1 xor abf2;
   AssertTrue('Vector Xor Vector no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpXorByte;
begin
   nbf3 := nbf1 xor b1;
   abf3 := abf1 xor b1;
   AssertTrue('Vector Xor Byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;


{%endregion%}

{%region%----[ TVector4b Functions ]--------------------------------------------}


procedure TVector4bComparatorTest.TestDivideBy2;
begin
   nbf3 := nbf1.DivideBy2;
   abf3 := abf1.DivideBy2;
   AssertTrue('Vector DivideBy2 no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpMin;
begin
   nbf3 := nbf1.Min(nbf2);
   abf3 := abf1.Min(abf2);
   AssertTrue('Vector Min no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpMinByte;
begin
   nbf3 := nbf1.Min(b2);
   abf3 := abf1.Min(b2);
   AssertTrue('Vector Min byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;


procedure TVector4bComparatorTest.TestOpMax;
begin
   nbf3 := nbf1.Max(nbf2);
   abf3 := abf1.Max(abf2);
   AssertTrue('Vector Max no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpMaxByte;
begin
   nbf3 := nbf1.Max(b2);
   abf3 := abf1.Max(b2);
   AssertTrue('Vector Max byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpClamp;
begin
   nbf4 := nbf1.Swizzle(swAGRB);
   abf4 := abf1.Swizzle(swAGRB);
   nbf3 := nbf1.Clamp(nbf2, nbf4);
   abf3 := abf1.Clamp(abf2, abf4);
   AssertTrue('Vector Clamp no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestOpClampByte;
begin
   nbf3 := nbf1.Clamp(b2, b5);
   abf3 := abf1.Clamp(b2, b5);
   AssertTrue('Vector Clamp byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestMulAdd;
begin
   nbf4 := nbf1.Swizzle(swAGRB);
   abf4 := abf1.Swizzle(swAGRB);
   nbf3 := nbf1.MulAdd(nbf2, nbf4);
   abf3 := abf1.MulAdd(abf2, abf4);
   AssertTrue('Vector MulAdd no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestMulDiv;
begin
   nbf3 := nbf1.MulDiv(b2, b5);
   abf3 := abf1.MulDiv(b2, b5);
   AssertTrue('Vector MulDiv byte no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;


procedure TVector4bComparatorTest.TestShuffle;
begin
   nbf3 := nbf1.Shuffle(1,2,3,0);
   abf3 := abf1.Shuffle(1,2,3,0);
   AssertTrue('Vector Shuffle no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestSwizzle;
begin
   nbf3 := nbf1.Swizzle(swAGRB);
   abf3 := abf1.Swizzle(swAGRB);
   AssertTrue('Vector Swizzle no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestCombine;
begin
   nbf3 := nbf1.Combine(nbf2, b1);
   abf3 := abf1.Combine(abf2, b1);
   AssertTrue('Vector Combine no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestCombine2;
begin
   nbf3 := nbf1.Combine2(nbf2, b1, b2);
   abf3 := abf1.Combine2(abf2, b1, b2);
   AssertTrue('Vector Combine2 no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));
end;

procedure TVector4bComparatorTest.TestCombine3;
begin
   nbf4 := nbf1.Swizzle(swAGRB);
   abf4 := abf1.Swizzle(swAGRB);
   nbf3 := nbf1.Combine3(nbf2, nbf4, b1, b2, b3);
   abf3 := abf1.Combine3(abf2, abf4, b1, b2, b3);
   AssertTrue('Vector Combine3 no match'+nbf3.ToString+' --> '+abf3.ToString, Compare(nbf3,abf3));

end;

procedure TVector4bComparatorTest.TestMinXYZComponent;
begin
  b4 := nbf1.MinXYZComponent;
  b8 := abf1.MinXYZComponent;
  AssertEquals('Vector MinXYZComponent no match', b4, b8);
end;

procedure TVector4bComparatorTest.TestMaxXYZComponent;
begin
  b4 := nbf1.MaxXYZComponent;
  b8 := abf1.MaxXYZComponent;
  AssertEquals('Vector MaxXYZComponent no match', b4, b8);
end;


{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR4B, TVector4bComparatorTest);
end.

