unit Vector4iComparatorTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  { TVector4iComparatorTest }

  TVector4iComparatorTest = class(TIntVectorBaseTestCase)
    published
      procedure TestCompare;
      procedure TestCompareFalse;
      procedure TestOpAdd;
      procedure TestOpAddInt;
      procedure TestOpSub;
      procedure TestOpSubInt;
      procedure TestOpMul;
      procedure TestOpMulInt;
      procedure TestOpMulSingle;
      procedure TestOpDiv;
      procedure TestOpDivInt;
      procedure TestOpNegate;
      procedure TestOpEquality;
      procedure TestOpNotEquals;
{*      procedure TestOpAnd;
      procedure TestOpAndInt;
      procedure TestOpOr;
      procedure TestOpOrInt;
      procedure TestOpXor;
      procedure TestOpXorInt;  *}
      procedure TestDivideBy2;
      procedure TestAbs;
      procedure TestOpMin;
      procedure TestOpMinInt;
      procedure TestOpMax;
      procedure TestOpMaxInt;
      procedure TestOpClamp;
      procedure TestOpClampInt;
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


{ TVector4iComparatorTest }

procedure TVector4iComparatorTest.TestCompare;
begin
   AssertTrue('Test Values do not match'+n4it1.ToString+' --> '+a4it1.ToString, Compare(n4it1,a4it1));
end;

procedure TVector4iComparatorTest.TestCompareFalse;
begin
   AssertFalse('Test Values do not match'+n4it1.ToString+' --> '+a4it2.ToString, Compare(n4it1,a4it2));
end;

procedure TVector4iComparatorTest.TestOpAdd;
begin
   n4it3 := n4it1 + n4it2;
   a4it3 := a4it1 + a4it2;
   AssertTrue('Vector4i: Op Add does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpAddInt;
begin
   n4it3 := n4it1 + b2;
   a4it3 := a4it1 + b2;
   AssertTrue('Vector4i: Op Add Int does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpSub;
begin
   n4it3 := n4it1 - n4it2;
   a4it3 := a4it1 - a4it2;
   AssertTrue('Vector4i: Op Sub does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpSubInt;
begin
   n4it3 := n4it1 - b2;
   a4it3 := a4it1 - b2;
   AssertTrue('Vector4i: Op Sub Int does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpMul;
begin
   n4it3 := n4it1 * n4it2;
   a4it3 := a4it1 * a4it2;
   AssertTrue('Vector4i: Op Mul does not match '+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpMulInt;
begin
   n4it3 := n4it1 * b2;
   a4it3 := a4it1 * b2;
   AssertTrue('Vector4i: Op Mul Int does not match '+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpMulSingle;
begin
   n4it3 := n4it1 * fs1;
   a4it3 := a4it1 * fs1;
   AssertTrue('Vector4i: Op Mul Single does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpDiv;
begin
   n4it3 := n4it1 div n4it2;
   a4it3 := a4it1 div a4it2;
   AssertTrue('Vector4i: Op Div does not match '+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpDivInt;
begin
   n4it3 := n4it1 div b2;
   a4it3 := a4it1 div b2;
   AssertTrue('Vector4i: Op Div Int does not match '+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpNegate;
begin
   n4it3 := -n4it1;
   a4it3 := -a4it1;
   AssertTrue('Vector4i: Op negate does not match '+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpEquality;
begin
   nb := n4it1 = n4it1;
   ab := a4it1 = a4it1;
   AssertTrue('Vector = does not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
   nb := n4it1 = n4it2;
   ab := a4it1 = a4it2;
   AssertTrue('Vector = does not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

procedure TVector4iComparatorTest.TestOpNotEquals;
begin
   nb := n4it1 <> n4it1;
   ab := a4it1 <> a4it1;
   AssertTrue('Vector <> does not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
   nb := n4it1 <> n4it2;
   ab := a4it1 <> a4it2;
   AssertTrue('Vector <> doos not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

{*

procedure TVector4iComparatorTest.TestOpAnd;
begin
   n4it3 := n4it1 and n4it2;
   a4it3 := a4it1 and a4it2;
   AssertTrue('Vector4i: And does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpAndInt;
begin
   n4it3 := n4it1 and b2;
   a4it3 := a4it1 and b2;
   AssertTrue('Vector4i: And Int does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpOr;
begin
   n4it3 := n4it1 or n4it2;
   a4it3 := a4it1 or a4it2;
   AssertTrue('Vector4i: Or does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpOrInt;
begin
   n4it3 := n4it1 or b2;
   a4it3 := a4it1 or b2;
   AssertTrue('Vector4i: Or Int does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpXor;
begin
   n4it3 := n4it1 xor n4it2;
   a4it3 := a4it1 xor a4it2;
   AssertTrue('Vector4i: Xor does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpXorInt;
begin
   n4it3 := n4it1 xor b2;
   a4it3 := a4it1 xor b2;
   AssertTrue('Vector4i: Xor Int does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

*}
procedure TVector4iComparatorTest.TestDivideBy2;
begin
   n4it3 := n4it1.DivideBy2;
   a4it3 := a4it1.DivideBy2;
   AssertTrue('Vector4i: DivideBy2 does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestAbs;
begin
   n4it3 := n4it1.abs;
   a4it3 := a4it1.abs;
   AssertTrue('Vector4i: Abs does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpMin;
begin
   n4it3 := n4it1.Min(n4it2);
   a4it3 := a4it1.Min(a4it2);
   AssertTrue('Vector4i: Min does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpMinInt;
begin
   n4it3 := n4it1.Min(b2);
   a4it3 := a4it1.Min(b2);
   AssertTrue('Vector4i: Min Int does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpMax;
begin
   n4it3 := n4it1.Max(n4it2);
   a4it3 := a4it1.Max(a4it2);
   AssertTrue('Vector4i: Max does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpMaxInt;
begin
   n4it3 := n4it1.Max(b2);
   a4it3 := a4it1.Max(b2);
   AssertTrue('Vector4i: Max Int does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpClamp;
begin
   n4it3 := n4it1.Clamp(n4it1,n4it2);
   a4it3 := a4it1.Clamp(a4it1,a4it2);
   AssertTrue('Vector4i: Clamp does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestOpClampInt;
begin
   n4it3 := n4it1.Clamp(b2, b5);
   a4it3 := a4it1.Clamp(b2, b5);
   AssertTrue('Vector4i: Clamp Int does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestMulAdd;
begin
   n4it3 := n4it1.MulAdd(n4it1,n4it2);
   a4it3 := a4it1.MulAdd(a4it1,a4it2);
   AssertTrue('Vector4i: MulAdd does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestMulDiv;
begin
   n4it3 := n4it1.MulDiv(n4it1,n4it2);
   a4it3 := a4it1.MulDiv(a4it1,a4it2);
   AssertTrue('Vector4i: MulDiv does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestShuffle;
begin
   n4it3 := n4it1.Shuffle(1,2,3,0);
   a4it3 := a4it1.Shuffle(1,2,3,0);
   AssertTrue('Vector4i: Shuffle no match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestSwizzle;
begin
   n4it3 := n4it1.Swizzle(swWYXZ);
   a4it3 := a4it1.Swizzle(swWYXZ);
   AssertTrue('Vector4i: Swizzle no match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestCombine;
begin
   n4it3 := n4it1.Combine(n4it1,fs1);
   a4it3 := a4it1.Combine(a4it1,fs1);
   AssertTrue('Vector4i: Combine does not match'+n4it3.ToString+' --> '+a4it3.ToString, Compare(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestCombine2;
begin
   n4it3 := n4it1.Combine2(n4it1,fs1,fs2);
   a4it3 := a4it1.Combine2(a4it1,fs1,fs2);
   AssertTrue('Vector4i: Combine2 does not match'+n4it3.ToString+' --> '+a4it3.ToString, CompareWithRound(n4it3, a4it3));
end;

procedure TVector4iComparatorTest.TestCombine3;
begin
   n4it4 := n4it1.Swizzle(swAGRB);
   a4it4 := a4it1.Swizzle(swAGRB);
   n4it3 := n4it1.Combine3(n4it1,n4it4,fs1,fs2, fs2);
   a4it3 := a4it1.Combine3(a4it1,a4it4,fs1,fs2, fs2);
   AssertTrue('Vector4i: Combine2 does not match'+n4it3.ToString+' --> '+a4it3.ToString, CompareWithRound(n4it3,a4it3));
end;

procedure TVector4iComparatorTest.TestMinXYZComponent;
begin
   b4 := n4it1.MinXYZComponent;
   b8 := a4it1.MinXYZComponent;
   AssertEquals('Vector4i: MinXYZComponent no match', b4, b8);
end;

procedure TVector4iComparatorTest.TestMaxXYZComponent;
begin
   b4 := n4it1.MaxXYZComponent;
   b8 := a4it1.MaxXYZComponent;
   AssertEquals('Vector4i: MaxXYZComponent no match', b4, b8);
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR4I, TVector4iComparatorTest);
end.

