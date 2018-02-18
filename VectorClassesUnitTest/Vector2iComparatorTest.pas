unit Vector2iComparatorTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;


type
  TVector2iComparatorTest  = class(TVectorBaseTestCase)
    private
      nt2i1, nt2i2, nt2i3, nt2i4: TNativeGLZVector2i;
      at2i1, at2i2, at2i3, at2i4: TGLZVector2i;
    protected
      procedure Setup; override;
    published
      procedure TestCompare;
      procedure TestCompareFalse;
      procedure TestOpAdd;
      procedure TestOpSub;
      procedure TestOpDiv;
      procedure TestOpMul;
      procedure TestOpMulSingle;
      procedure TestOpAddInteger;
      procedure TestOpSubInteger;
      procedure TestOpDivInteger;
      procedure TestOpMulInteger;
      procedure TestOpDivideSingle;
      procedure TestOpNegate;
      procedure TestEquals;
      procedure TestNotEquals;
      procedure TestMod;
      procedure TestMin;
      procedure TestMax;
      procedure TestMinInteger;
      procedure TestMaxInteger;
      procedure TestClamp;
      procedure TestClampInteger;
      procedure TestMulAdd;
      procedure TestMulDiv;
      procedure TestLength;
      procedure TestLengthSquare;
      procedure TestDistance;
      procedure TestDistanceSquare;
      procedure TestNormalize;
      procedure TestDotProduct;
      procedure TestAngleBetween;
      procedure TestAngleCosine;
      procedure TestAbs;
  end;


implementation


procedure TVector2iComparatorTest.Setup;
begin
  inherited Setup;
  at2i1.Create(2,6);
  at2i2.Create(1,1);
  at2i4.Create(8,8);
  nt2i1.V := at2i1.V;
  nt2i2.V := at2i2.V;
  nt2i4.V := at2i4.V;
end;

procedure TVector2iComparatorTest.TestCompare;
begin
  AssertTrue('Test Values do not match'+nt2i1.ToString+' --> '+at2i1.ToString, Compare(nt2i1,at2i1));
end;

procedure TVector2iComparatorTest.TestCompareFalse;
begin
  AssertFalse('Test Values do not match'+nt2i1.ToString+' --> '+at2i2.ToString, Compare(nt2i1,at2i2));
end;

procedure TVector2iComparatorTest.TestOpAdd;
begin
  nt2i3 := nt2i1 + nt2i2;
  at2i3 := at2i1 + at2i2;
  AssertTrue('Vector2i: Op Add does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpSub;
begin
  nt2i3 := nt2i1 - nt2i2;
  at2i3 := at2i1 - at2i2;
  AssertTrue('Vector2i: Op Sub does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpDiv;
begin
  nt2i3 := nt2i1 div nt2i2;
  at2i3 := at2i1 div at2i2;
  AssertTrue('Vector2i: Op Div does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpMul;
begin
  nt2i3 := nt2i1 * nt2i2;
  at2i3 := at2i1 * at2i2;
  AssertTrue('Vector2i: Op Mul does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpMulSingle;
begin
  nt2i3 := nt2i1 * 2.3;
  at2i3 := at2i1 * 2.3;
  AssertTrue('Vector2i: Op Mul Single does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpAddInteger;
begin
  nt2i3 := nt2i1 + 2;
  at2i3 := at2i1 + 2;
  AssertTrue('Vector2i: Op Add Integer does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpSubInteger;
begin
  nt2i3 := nt2i1 - 2;
  at2i3 := at2i1 - 2;
  AssertTrue('Vector2i: Op Sub Integer does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpDivInteger;
begin
  nt2i3 := nt2i1 div 2;
  at2i3 := at2i1 div 2;
  AssertTrue('Vector2i: Op Div Integer does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpMulInteger;
begin
  nt2i3 := nt2i1 div 2;
  at2i3 := at2i1 div 2;
  AssertTrue('Vector2i: Op Mul Integer does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpDivideSingle;
begin
  nt2i3 := nt2i1 / 2.3;
  at2i3 := at2i1 / 2.3;
  AssertTrue('Vector2i: Op Divide Single does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestOpNegate;
begin
  nt2i3 := -nt2i1;
  at2i3 := -at2i1;
  AssertTrue('Vector2i: Op Divide Single does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestEquals;
begin
  nb := nt2i1 = nt2i1;
  ab := at2i1 = at2i1;
  AssertTrue('Vector2i = does not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
  nb := nt2i1 = nt2i2;
  ab := at2i1 = at2i2;
  AssertTrue('Vector2i = does not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

procedure TVector2iComparatorTest.TestNotEquals;
begin
  nb := nt2i1 <> nt2i1;
  ab := at2i1 <> at2i1;
  AssertTrue('Vector2i <> does not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
  nb := nt2i1 <> nt2i2;
  ab := at2i1 <> at2i2;
  AssertTrue('Vector2i <> does not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

procedure TVector2iComparatorTest.TestMod;
begin
  nt2i3 := nt2i1 mod nt2i2;
  at2i3 := at2i1 mod at2i2;
  AssertTrue('Vector2i: Mod does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestMin;
begin
  nt2i3 := nt2i1.Min(nt2i2);
  at2i3 := at2i1.Min(at2i2);
  AssertTrue('Vector2i: Min does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestMax;
begin
  nt2i3 := nt2i1.Max(nt2i2);
  at2i3 := at2i1.Max(at2i2);
  AssertTrue('Vector2i: Max does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestMinInteger;
begin
  nt2i3 := nt2i1.Min(2);
  at2i3 := at2i1.Min(2);
  AssertTrue('Vector2i: Min Integer does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestMaxInteger;
begin
  nt2i3 := nt2i1.Max(2);
  at2i3 := at2i1.Max(2);
  AssertTrue('Vector2i: Max Integer does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestClamp;
begin
  nt2i3 := nt2i1.Clamp(nt2i2,nt2i4);
  at2i3 := at2i1.Clamp(at2i2,at2i4);
  AssertTrue('Vector2i: Clamp does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestClampInteger;
begin
  nt2i3 := nt2i1.Clamp(1,5);
  at2i3 := at2i1.Clamp(1,5);
  AssertTrue('Vector2i: Clamp Integer does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestMulAdd;
begin
  nt2i3 := nt2i1.MulAdd(nt2i2,nt2i4);
  at2i3 := at2i1.MulAdd(at2i2,at2i4);
  AssertTrue('Vector2i: MulAdd does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestMulDiv;
begin
  nt2i3 := nt2i1.MulDiv(nt2i2,nt2i4);
  at2i3 := at2i1.MulDiv(at2i2,at2i4);
  AssertTrue('Vector2i: MulDiv does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

procedure TVector2iComparatorTest.TestLength;
begin
  fs1 :=  nt2i1.Length;
  fs2 :=  at2i1.Length;
  AssertTrue('Vector2i Lengths do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-4));
end;

procedure TVector2iComparatorTest.TestLengthSquare;
begin
  fs1 :=  nt2i1.LengthSquare;
  fs2 :=  at2i1.LengthSquare;
  AssertTrue('Vector2i Length Squared do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-4));
end;

procedure TVector2iComparatorTest.TestDistance;
begin
  fs1 :=  nt2i1.Distance(nt2i2);
  fs2 :=  at2i1.Distance(at2i2);
  AssertTrue('Vector2i Distances do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-4));
end;

procedure TVector2iComparatorTest.TestDistanceSquare;
begin
  fs1 :=  nt2i1.DistanceSquare(nt2i2);
  fs2 :=  at2i1.DistanceSquare(at2i2);
  AssertTrue('Vector2i Distance Squared do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-4));
end;

procedure TVector2iComparatorTest.TestNormalize;
begin
  ntt1 := nt2i1.Normalize;
  vtt1 := at2i1.Normalize;
  AssertTrue('Vector2iHelper Normalize do not match : '+ntt1.ToString+' --> '+vtt1.ToString, Compare(ntt1,vtt1));
end;

procedure TVector2iComparatorTest.TestDotProduct;
begin
  fs1 :=  nt2i1.DotProduct(nt2i2);
  fs2 :=  at2i1.DotProduct(at2i2);
  AssertTrue('Vector2i DotProducts do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-4));
end;

procedure TVector2iComparatorTest.TestAngleBetween;
begin
  fs1 :=  nt2i1.AngleBetween(nt2i2,nt2i4);
  fs2 :=  at2i1.AngleBetween(at2i2,at2i4);
  AssertTrue('Vector2i AngleBetweens do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-4));
end;

procedure TVector2iComparatorTest.TestAngleCosine;
begin
  fs1 :=  nt2i1.AngleCosine(nt2i2);
  fs2 :=  at2i1.AngleCosine(at2i2);
  AssertTrue('Vector2i AngleCosines do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2,1e-4));
end;

procedure TVector2iComparatorTest.TestAbs;
begin
  nt2i3 := nt2i1.Abs;
  at2i3 := at2i1.Abs;
  AssertTrue('Vector2i: Abs does not match'+nt2i3.ToString+' --> '+at2i3.ToString, Compare(nt2i3,at2i3));
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR2I, TVector2iComparatorTest);
end.

