unit Vector2iFunctionalTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, math, fpcunit, testregistry, BaseTestCase,
  GLZVectorMath;

type

  { TVector2fFunctionalTest }

  TVector2iFunctionalTest = class(TVectorBaseTestCase)
    private
      at2i1, at2i2, at2i3, at2i4: TGLZVector2i;
    protected
      procedure Setup; override;
    published
      procedure TestCreate;
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

procedure TVector2iFunctionalTest.Setup;
begin
  inherited Setup;
end;

procedure TVector2iFunctionalTest.TestCreate;
begin
  at2i1.Create(23,56);
  AssertEquals('Create:Sub1 X failed ', 23, at2i1.X);
  AssertEquals('Create:Sub2 Y failed ', 56, at2i1.Y);
  AssertEquals('Create:Sub3 V[0] failed ', 23, at2i1.V[0]);
  AssertEquals('Create:Sub4 V[1] failed ', 56, at2i1.V[1]);
  AssertEquals('Create:Sub5 Width failed ', 23, at2i1.Width);
  AssertEquals('Create:Sub6 Height failed ', 56, at2i1.Height);
end;

procedure TVector2iFunctionalTest.TestOpAdd;
begin
  at2i1.Create(23,56);
  at2i2.Create(2,5);
  at2i3 := at2i1 + at2i2;
  AssertEquals('OpAdd:Sub1 failed ', 25, at2i3.X);
  AssertEquals('OpAdd:Sub2 failed ', 61, at2i3.Y);
  at2i3 := at2i1 + -at2i2;
  AssertEquals('OpAdd:Sub3 failed ', 21, at2i3.X);
  AssertEquals('OpAdd:Sub4 failed ', 51, at2i3.Y);
  at2i3 := -at2i1 + at2i2;
  AssertEquals('OpAdd:Sub5 failed ', -21, at2i3.X);
  AssertEquals('OpAdd:Sub6 failed ', -51, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpSub;
begin
  at2i1.Create(23,56);
  at2i2.Create(2,5);
  at2i3 := at2i1 - at2i2;
  AssertEquals('OpSub:Sub1 failed ', 21, at2i3.X);
  AssertEquals('OpSub:Sub2 failed ', 51, at2i3.Y);
  at2i3 := at2i1 - -at2i2;
  AssertEquals('OpSub:Sub3 failed ', 25, at2i3.X);
  AssertEquals('OpSub:Sub4 failed ', 61, at2i3.Y);
  at2i3 := -at2i1 - at2i2;
  AssertEquals('OpSub:Sub5 failed ', -25, at2i3.X);
  AssertEquals('OpSub:Sub6 failed ', -61, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpDiv;
begin
  at2i1.Create(2,3);                  // trunc halves
  at2i2.Create(2,2);
  at2i3 := at2i1 div at2i2;
  AssertEquals('OpDiv:Sub1 failed ', 1, at2i3.X);
  AssertEquals('OpDiv:Sub2 failed ', 1, at2i3.Y);
  at2i1.Create(4,5);                 // trunc halves
  at2i3 := at2i1 div at2i2;
  AssertEquals('OpDiv:Sub3 failed ', 2, at2i3.X);
  AssertEquals('OpDiv:Sub4 failed ', 2, at2i3.Y);
  at2i1.Create(22,32);                  // trunc large partial
  at2i2.Create(12,17);
  at2i3 := at2i1 div at2i2;
  AssertEquals('OpDiv:Sub5 failed ', 1, at2i3.X);
  AssertEquals('OpDiv:Sub6 failed ', 1, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpMul;
begin
  at2i1.Create(2,3);
  at2i2.Create(2,2);
  at2i3 := at2i1 * at2i2;
  AssertEquals('OpMul:Sub1 failed ', 4, at2i3.X);
  AssertEquals('OpMul:Sub2 failed ', 6, at2i3.Y);
  at2i3 := at2i2 * at2i1;
  AssertEquals('OpMul:Sub3 failed ', 4, at2i3.X);
  AssertEquals('OpMul:Sub4 failed ', 6, at2i3.Y);
  at2i3 := at2i1 * -at2i2;
  AssertEquals('OpMul:Sub5 failed ', -4, at2i3.X);
  AssertEquals('OpMul:Sub6 failed ', -6, at2i3.Y);
  at2i3 := -at2i1 * -at2i2;
  AssertEquals('OpMul:Sub7 failed ', 4, at2i3.X);
  AssertEquals('OpMul:Sub8 failed ', 6, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpMulSingle;
begin
  at2i1.Create(2,3);
  at2i3 := at2i1 * 2.0;
  AssertEquals('OpMulSingle:Sub1 failed ', 4, at2i3.X);
  AssertEquals('OpMulSingle:Sub2 failed ', 6, at2i3.Y);
  at2i3 := at2i1 * 0.5;            // rounds to even
  AssertEquals('OpMulSingle:Sub3 failed ', 1, at2i3.X);
  AssertEquals('OpMulSingle:Sub4 failed ', 2, at2i3.Y);
  at2i1.Create(4,5);
  at2i3 := at2i1 * 0.5;            // rounds to even
  AssertEquals('OpMulSingle:Sub5 failed ', 2, at2i3.X);
  AssertEquals('OpMulSingle:Sub6 failed ', 2, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpAddInteger;
begin
  at2i1.Create(2,3);
  at2i3 := at2i1 + 2;
  AssertEquals('OpAddInteger:Sub1 failed ', 4, at2i3.X);
  AssertEquals('OpAddInteger:Sub2 failed ', 5, at2i3.Y);
  at2i3 := at2i1 + -8;
  AssertEquals('OpAddInteger:Sub3 failed ', -6, at2i3.X);
  AssertEquals('OpAddInteger:Sub4 failed ', -5, at2i3.Y);
  at2i3 := -at2i1 + 8;
  AssertEquals('OpAddInteger:Sub5 failed ', 6, at2i3.X);
  AssertEquals('OpAddInteger:Sub6 failed ', 5, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpSubInteger;
begin
  at2i1.Create(2,3);
  at2i3 := at2i1 - 2;
  AssertEquals('OpSubInteger:Sub1 failed ', 0, at2i3.X);
  AssertEquals('OpSubInteger:Sub2 failed ', 1, at2i3.Y);
  at2i3 := at2i1 - -8;
  AssertEquals('OpSubInteger:Sub3 failed ', 10, at2i3.X);
  AssertEquals('OpSubInteger:Sub4 failed ', 11, at2i3.Y);
  at2i3 := -at2i1 - 8;
  AssertEquals('OpSubInteger:Sub5 failed ', -10, at2i3.X);
  AssertEquals('OpSubInteger:Sub6 failed ', -11, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpDivInteger;
begin
  at2i1.Create(2,3);                  // trunc halves
  at2i3 := at2i1 div 2;
  AssertEquals('OpDivInteger:Sub1 failed ', 1, at2i3.X);
  AssertEquals('OpDivInteger:Sub2 failed ', 1, at2i3.Y);
  at2i1.Create(4,5);                 // trunc halves
  at2i3 := at2i1 div 2;
  AssertEquals('OpDivInteger:Sub3 failed ', 2, at2i3.X);
  AssertEquals('OpDivInteger:Sub4 failed ', 2, at2i3.Y);
  at2i1.Create(22,32);                  // trunc large partial
  at2i3 := at2i1 div 12;
  AssertEquals('OpDivInteger:Sub5 failed ', 1, at2i3.X);
  AssertEquals('OpDivInteger:Sub6 failed ', 2, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpMulInteger;
begin
  at2i1.Create(2,3);
  at2i3 := at2i1 * 2;
  AssertEquals('OpMulInteger:Sub1 failed ', 4, at2i3.X);
  AssertEquals('OpMulInteger:Sub2 failed ', 6, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpDivideSingle;
begin
  at2i1.Create(2,3);
  at2i3 := at2i1 / 0.5;
  AssertEquals('OpDivideSingle:Sub1 failed ', 4, at2i3.X);
  AssertEquals('OpDivideSingle:Sub2 failed ', 6, at2i3.Y);
  at2i3 := at2i1 / 2.0;            // rounds to even
  AssertEquals('OpDivideSingle:Sub3 failed ', 1, at2i3.X);
  AssertEquals('OpDivideSingle:Sub4 failed ', 2, at2i3.Y);
  at2i1.Create(4,5);
  at2i3 := at2i1 / 2.0;            // rounds to even
  AssertEquals('OpDivideSingle:Sub5 failed ', 2, at2i3.X);
  AssertEquals('OpDivideSingle:Sub6 failed ', 2, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestOpNegate;
begin
  at2i1.Create(2,3);
  at2i3 := -at2i1;
  AssertEquals('OpNegate:Sub1 failed ', -2, at2i3.X);
  AssertEquals('OpNegate:Sub2 failed ', -3, at2i3.Y);
  at2i1.Create(-2,3);
  at2i3 := -at2i1;
  AssertEquals('OpNegate:Sub3 failed ',  2, at2i3.X);
  AssertEquals('OpNegate:Sub4 failed ', -3, at2i3.Y);
  at2i1.Create(2,-3);
  at2i3 := -at2i1;
  AssertEquals('OpNegate:Sub5 failed ', -2, at2i3.X);
  AssertEquals('OpNegate:Sub6 failed ',  3, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestEquals;
begin
  at2i1.Create(2,3);
  at2i2.Create(2,3);
  nb := at2i1 = at2i2;
  AssertEquals('OpEquality:Sub1 does not match ', True, nb);
  at2i2.Create(2,4);
  nb := at2i1 = at2i2;
  AssertEquals('OpEquality:Sub2 should not match ', False, nb);
  at2i2.Create(2,2);
  nb := at2i1 = at2i2;
  AssertEquals('OpEquality:Sub3 should not match ', False, nb);
  at2i2.Create(12,2);
  nb := at2i1 = at2i2;
  AssertEquals('OpEquality:Sub4 should not match ', False, nb);
end;

procedure TVector2iFunctionalTest.TestNotEquals;
begin
  at2i1.Create(2,3);
  at2i2.Create(2,3);
  nb := at2i1 <> at2i2;
  AssertEquals('NotEquals:Sub1 should not match ', False, nb);
  at2i2.Create(2,4);
  nb := at2i1 <> at2i2;
  AssertEquals('NotEquals:Sub2 does not match ', True, nb);
  at2i2.Create(2,2);
  nb := at2i1 <> at2i2;
  AssertEquals('NotEquals:Sub3 does not match ', True, nb);
  at2i2.Create(12,2);
  nb := at2i1 <> at2i2;
  AssertEquals('NotEquals:Sub4 does not match ', True, nb);
end;

procedure TVector2iFunctionalTest.TestMin;
begin
  at2i1.Create(2,3);
  at2i2.Create(3,7);
  at2i3 := at2i1.Min(at2i2);
  AssertEquals('Min:Sub1 failed ', 2, at2i3.X);
  AssertEquals('Min:Sub2 failed ', 3, at2i3.Y);
  at2i2.Create(-3,7);
  at2i3 := at2i1.Min(at2i2);
  AssertEquals('Min:Sub3 failed ', -3, at2i3.X);
  AssertEquals('Min:Sub4 failed ',  3, at2i3.Y);
  at2i2.Create(3,-7);
  at2i3 := at2i1.Min(at2i2);
  AssertEquals('Min:Sub5 failed ',  2, at2i3.X);
  AssertEquals('Min:Sub6 failed ', -7, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestMax;
begin
  at2i1.Create(2,3);
  at2i2.Create(3,7);
  at2i3 := at2i1.Max(at2i2);
  AssertEquals('Max:Sub1 failed ', 3, at2i3.X);
  AssertEquals('Max:Sub2 failed ', 7, at2i3.Y);
  at2i2.Create(-3,7);
  at2i3 := at2i1.Max(at2i2);
  AssertEquals('Max:Sub3 failed ',  2, at2i3.X);
  AssertEquals('Max:Sub4 failed ',  7, at2i3.Y);
  at2i2.Create(3,-7);
  at2i3 := at2i1.Max(at2i2);
  AssertEquals('Max:Sub5 failed ',  3, at2i3.X);
  AssertEquals('Max:Sub6 failed ',  3, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestMinInteger;
begin
  at2i1.Create(2,6);
  at2i3 := at2i1.Min(7);
  AssertEquals('MinInteger:Sub1 failed ', 2, at2i3.X);
  AssertEquals('MinInteger:Sub2 failed ', 6, at2i3.Y);
  at2i3 := at2i1.Min(4);
  AssertEquals('MinInteger:Sub3 failed ', 2, at2i3.X);
  AssertEquals('MinInteger:Sub4 failed ', 4, at2i3.Y);
  at2i3 := at2i1.Min(-6);
  AssertEquals('MinInteger:Sub5 failed ', -6, at2i3.X);
  AssertEquals('MinInteger:Sub6 failed ', -6, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestMaxInteger;
begin
  at2i1.Create(2,6);
  at2i3 := at2i1.Max(7);
  AssertEquals('MinInteger:Sub1 failed ', 7, at2i3.X);
  AssertEquals('MinInteger:Sub2 failed ', 7, at2i3.Y);
  at2i3 := at2i1.Max(4);
  AssertEquals('MinInteger:Sub3 failed ', 4, at2i3.X);
  AssertEquals('MinInteger:Sub4 failed ', 6, at2i3.Y);
  at2i3 := at2i1.Max(-6);
  AssertEquals('MinInteger:Sub5 failed ', 2, at2i3.X);
  AssertEquals('MinInteger:Sub6 failed ', 6, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestClamp;
begin
  at2i1.Create(2,6);
  at2i2.Create(0,0);
  at2i4.Create(8,8);
  at2i3 := at2i1.Clamp(at2i2,at2i4);
  AssertEquals('Clamp:Sub1 failed ', 2, at2i3.X);
  AssertEquals('Clamp:Sub2 failed ', 6, at2i3.Y);
  at2i1.Create(-3,10);
  at2i3 := at2i1.Clamp(at2i2,at2i4);
  AssertEquals('Clamp:Sub3 failed ', 0, at2i3.X);
  AssertEquals('Clamp:Sub4 failed ', 8, at2i3.Y);
  at2i1.Create(18,-8);
  at2i3 := at2i1.Clamp(at2i2,at2i4);
  AssertEquals('Clamp:Sub5 failed ',  8, at2i3.X);
  AssertEquals('Clamp:Sub6 failed ',  0, at2i3.Y);
  at2i1.Create(-18,-8);
  at2i3 := at2i1.Clamp(at2i2,at2i4);
  AssertEquals('Clamp:Sub7 failed ',  0, at2i3.X);
  AssertEquals('Clamp:Sub8 failed ',  0, at2i3.Y);
  at2i1.Create(18,12);
  at2i3 := at2i1.Clamp(at2i2,at2i4);
  AssertEquals('Clamp:Sub9 failed ',  8, at2i3.X);
  AssertEquals('Clamp:Sub10 failed ', 8, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestClampInteger;
begin
  at2i1.Create(2,6);
  at2i3 := at2i1.Clamp(0,8);
  AssertEquals('ClampInteger:Sub1 failed ', 2, at2i3.X);
  AssertEquals('ClampInteger:Sub2 failed ', 6, at2i3.Y);
  at2i1.Create(-3,10);
  at2i3 := at2i1.Clamp(0,8);
  AssertEquals('ClampInteger:Sub3 failed ', 0, at2i3.X);
  AssertEquals('ClampInteger:Sub4 failed ', 8, at2i3.Y);
  at2i1.Create(18,-8);
  at2i3 := at2i1.Clamp(0,8);
  AssertEquals('ClampInteger:Sub5 failed ',  8, at2i3.X);
  AssertEquals('ClampInteger:Sub6 failed ',  0, at2i3.Y);
  at2i1.Create(-18,-8);
  at2i3 := at2i1.Clamp(0,8);
  AssertEquals('ClampInteger:Sub7 failed ',  0, at2i3.X);
  AssertEquals('ClampInteger:Sub8 failed ',  0, at2i3.Y);
  at2i1.Create(18,12);
  at2i3 := at2i1.Clamp(0,8);
  AssertEquals('ClampInteger:Sub9 failed ',  8, at2i3.X);
  AssertEquals('ClampInteger:Sub10 failed ', 8, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestMulAdd;
begin
  at2i1.Create(2,6);
  at2i2.Create(2,2);
  at2i4.Create(8,8);
  at2i3 := at2i1.MulAdd(at2i2,at2i4);
  AssertEquals('MulAdd:Sub1 failed ', 12, at2i3.X);
  AssertEquals('MulAdd:Sub2 failed ', 20, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestMulDiv;
begin
  at2i1.Create(2,6);
  at2i2.Create(2,2);
  at2i4.Create(8,8);
  at2i3 := at2i1.MulDiv(at2i4,at2i2);
  AssertEquals('MulDiv:Sub1 failed ',  8, at2i3.X);
  AssertEquals('MulDiv:Sub2 failed ', 24, at2i3.Y);
end;

procedure TVector2iFunctionalTest.TestLength;
begin
  at2i1.Create(3,4);
  fs1 := at2i1.Length;
  AssertEquals('Length:Sub1 failed ', 5.0, fs1);
end;

procedure TVector2iFunctionalTest.TestLengthSquare;
begin
  at2i1.Create(3,4);
  fs1 := at2i1.LengthSquare;
  AssertEquals('LengthSquare:Sub1 failed ', 25.0, fs1);
end;

procedure TVector2iFunctionalTest.TestDistance;
begin
  at2i1.Create(3,4);
  at2i2.Create(0,0);
  fs1 := at2i1.Distance(at2i2);
  AssertEquals('Distance:Sub1 failed ', 5.0, fs1);
  fs1 := at2i2.Distance(at2i1);
  AssertEquals('Distance:Sub2 failed ', 5.0, fs1);
end;

procedure TVector2iFunctionalTest.TestDistanceSquare;
begin
  at2i1.Create(3,4);
  at2i2.Create(0,0);
  fs1 := at2i1.DistanceSquare(at2i2);
  AssertEquals('DistanceSquare:Sub1 failed ', 25.0, fs1);
  fs1 := at2i2.DistanceSquare(at2i1);
  AssertEquals('DistanceSquare:Sub2 failed ', 25.0, fs1);
end;

procedure TVector2iFunctionalTest.TestNormalize;
begin
  at2i1.Create(0,6);
  vtt3 := at2i1.Normalize;
  AssertEquals('Normalize:Sub1 X failed ', 0.0, vtt3.X);
  AssertEquals('Normalize:Sub2 Y failed ', 1.0, vtt3.Y);
  at2i1.Create(0,-6);
  vtt3 := at2i1.Normalize;
  AssertEquals('Normalize:Sub3 X failed ',  0.0, vtt3.X);
  AssertEquals('Normalize:Sub4 Y failed ', -1.0, vtt3.Y);
  at2i1.Create(60,0);
  vtt3 := at2i1.Normalize;
  AssertEquals('Normalize:Sub5 X failed ', 1.0, vtt3.X);
  AssertEquals('Normalize:Sub6 Y failed ', 0.0, vtt3.Y);
  at2i1.Create(-60,0);
  vtt3 := at2i1.Normalize;
  AssertEquals('Normalize:Sub7 X failed ', -1.0, vtt3.X);
  AssertEquals('Normalize:Sub8 Y failed ',  0.0, vtt3.Y);
  at2i1.Create(6,6);
  vtt3 := at2i1.Normalize;
  AssertEquals('Normalize:Sub9 X failed ',  1/(sqrt(2)), vtt3.X);
  AssertEquals('Normalize:Sub10 Y failed ', 1/(sqrt(2)), vtt3.Y);
  at2i1.Create(-6,6);
  vtt3 := at2i1.Normalize;
  AssertEquals('Normalize:Sub9 X failed ', -1/(sqrt(2)), vtt3.X);
  AssertEquals('Normalize:Sub10 Y failed ', 1/(sqrt(2)), vtt3.Y);
  at2i1.Create(6,-6);
  vtt3 := at2i1.Normalize;
  AssertEquals('Normalize:Sub11 X failed ',  1/(sqrt(2)), vtt3.X);
  AssertEquals('Normalize:Sub12 Y failed ', -1/(sqrt(2)), vtt3.Y);
  at2i1.Create(-6,-6);
  vtt3 := at2i1.Normalize;
  AssertEquals('Normalize:Sub13 X failed ', -1/(sqrt(2)), vtt3.X);
  AssertEquals('Normalize:Sub14 Y failed ', -1/(sqrt(2)), vtt3.Y);
end;

procedure TVector2iFunctionalTest.TestDotProduct;
begin
  at2i1.Create(1,2);
  at2i2.Create(3,2);
  fs1 := at2i1.DotProduct(at2i2);
  AssertEquals('DotProduct:Sub1 failed ',  7.0, fs1);
  at2i1.Create(-1,2);
  fs1 := at2i1.DotProduct(at2i2);
  AssertEquals('DotProduct:Sub2 failed ',  1.0, fs1);
  at2i1.Create(1,-2);
  fs1 := at2i1.DotProduct(at2i2);
  AssertEquals('DotProduct:Sub3 failed ', -1.0, fs1);
  at2i1.Create(1,2);
  at2i2.Create(-3,2);
  fs1 := at2i1.DotProduct(at2i2);
  AssertEquals('DotProduct:Sub4 failed ',  1.0, fs1);
  at2i2.Create(3,-2);
  fs1 := at2i1.DotProduct(at2i2);
  AssertEquals('DotProduct:Sub5 failed ', -1.0, fs1);
  at2i2.Create(-3,-2);
  fs1 := at2i1.DotProduct(at2i2);
  AssertEquals('DotProduct:Sub6 failed ', -7.0, fs1);
  at2i1.Create(-1,-2);
  fs1 := at2i1.DotProduct(at2i2);
  AssertEquals('DotProduct:Sub7 failed ',  7.0, fs1);
end;

procedure TVector2iFunctionalTest.TestAngleBetween;
begin
  at2i1.Create(1,0);
  at2i2.Create(0,1);
  fs1 := at2i1.AngleBetween(at2i2,NullVector2i);
  AssertEquals('AngleBetween:Sub1 failed ',  pi/2, fs1);
  at2i1.Create(1,1);
  fs1 := at2i1.AngleBetween(at2i2,NullVector2i);
  AssertEquals('AngleBetween:Sub2 failed ',  pi/4, fs1);
  at2i1.Create(-1,0);
  fs1 := at2i2.AngleBetween(at2i1,NullVector2i);
  AssertEquals('AngleBetween:Sub3 failed ',  pi/2, fs1);
  at2i1.Create(-1,-1);
  fs1 := at2i2.AngleBetween(at2i1,NullVector2i);
  AssertEquals('AngleBetween:Sub4 failed ',  3 * pi/4, fs1);
  at2i1.Create(1,-1);
  fs1 := at2i2.AngleBetween(at2i1,NullVector2i);
  AssertEquals('AngleBetween:Sub5 failed ',  3 * pi/4, fs1);
  at2i1.Create(0,-1);
  fs1 := at2i2.AngleBetween(at2i1,NullVector2i);
  AssertEquals('AngleBetween:Sub6 failed ',   pi, fs1);
end;

procedure TVector2iFunctionalTest.TestAngleCosine;
begin
  at2i1.Create(1, 1);  // ne
  at2i2.Create(1,0);  // ref east
  fs1 := at2i2.AngleCosine(at2i1);
  AssertEquals('AngleCosine:Sub1 failed ',  1/sqrt(2), fs1);
  at2i1.Create(0,1);  // n
  fs1 := at2i2.AngleCosine(at2i1);
  AssertEquals('AngleCosine:Sub2 failed ',  0, fs1);
  at2i1.Create(-1,1);   // nw
  fs1 := at2i2.AngleCosine(at2i1);
  AssertEquals('AngleCosine:Sub3 failed ',  -1/sqrt(2), fs1);
  at2i1.Create(-1,0);   // w
  fs1 := at2i2.AngleCosine(at2i1);
  AssertEquals('AngleCosine:Sub3 failed ',  -1, fs1);
  at2i1.Create(-1,-1);   // sw
  fs1 := at2i2.AngleCosine(at2i1);
  AssertEquals('AngleCosine:Sub3 failed ',  -1/sqrt(2), fs1);
  at2i1.Create(0,-1);   // s
  fs1 := at2i2.AngleCosine(at2i1);
  AssertEquals('AngleCosine:Sub3 failed ',  0, fs1);
  at2i1.Create(1,-1);   // se
  fs1 := at2i2.AngleCosine(at2i1);
  AssertEquals('AngleCosine:Sub3 failed ',  1/sqrt(2), fs1);
end;

procedure TVector2iFunctionalTest.TestAbs;
begin
  at2i1.Create(1, 1);
  at2i3 := at2i1.Abs;
  AssertEquals('Abs:Sub1 failed ', 1, at2i3.X);
  AssertEquals('Abs:Sub2 failed ', 1, at2i3.Y);
  at2i1.Create(-1, 1);
  at2i3 := at2i1.Abs;
  AssertEquals('Abs:Sub3 failed ', 1, at2i3.X);
  AssertEquals('Abs:Sub4 failed ', 1, at2i3.Y);
  at2i1.Create(1, -1);
  at2i3 := at2i1.Abs;
  AssertEquals('Abs:Sub5 failed ', 1, at2i3.X);
  AssertEquals('Abs:Sub6 failed ', 1, at2i3.Y);
  at2i1.Create(-1, -1);
  at2i3 := at2i1.Abs;
  AssertEquals('Abs:Sub7 failed ', 1, at2i3.X);
  AssertEquals('Abs:Sub8 failed ', 1, at2i3.Y);
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR2I, TVector2iFunctionalTest);
end.

