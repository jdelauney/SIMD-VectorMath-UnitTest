unit Vector4iFunctionalTest;

{$mode objfpc}{$H+}

{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  TVector4iFunctionalTest = class(TIntVectorBaseTestCase)
    published
      procedure TestCreateInt;
      procedure TestCreate3i;
      procedure TestCreate3b;
      procedure TestNegate;     // out of order as we use it in tests below
      procedure TestOpAdd;
      procedure TestOpAddInt;
      procedure TestOpSub;
      procedure TestOpSubInt;
      procedure TestOpMul;
      procedure TestOpMulInt;
      procedure TestOpMulSingle;
      procedure TestOpDiv;
      procedure TestOpDivInt;
      procedure TestEquals;
      procedure TestNotEquals;
      procedure TestDivide2;
      procedure TestAbs;
      procedure TestMin;
      procedure TestMinInt;
      procedure TestMax;
      procedure TestMaxInt;
      procedure TestClamp;
      procedure TestClampInt;
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

procedure TVector4iFunctionalTest.TestCreateInt;
begin
  a4it1.Create(-100, 100, 200);  //Check default.
  AssertEquals('CreateInt:Sub1 X failed ', -100, a4it1.X);
  AssertEquals('CreateInt:Sub2 Y failed ',  100, a4it1.Y);
  AssertEquals('CreateInt:Sub3 Z failed ',  200, a4it1.Z);
  AssertEquals('CreateInt:Sub4 W failed ',    0, a4it1.W);
  // Accessors
  AssertEquals('CreateInt:Sub5 V[0] failed ', -100, a4it1.V[0]);
  AssertEquals('CreateInt:Sub6 V[1] failed ',  100, a4it1.V[1]);
  AssertEquals('CreateInt:Sub7 V[2] failed ',  200, a4it1.V[2]);
  AssertEquals('CreateInt:Sub8 V[3] failed ',    0, a4it1.V[3]);
  AssertEquals('CreateInt:Sub9 Red   failed ', -100, a4it1.Red);
  AssertEquals('CreateInt:Sub10 Green failed ',  100, a4it1.Green);
  AssertEquals('CreateInt:Sub11 Blue  failed ',  200, a4it1.Blue);
  AssertEquals('CreateInt:Sub12 Alhpa failed ',    0, a4it1.Alpha);
  AssertEquals('CreateInt:Sub13 ST.X failed ', -100, a4it1.ST.X);
  AssertEquals('CreateInt:Sub14 ST.Y failed ',  100, a4it1.ST.Y);
  AssertEquals('CreateInt:Sub15 UV.X failed ',  200, a4it1.UV.X);
  AssertEquals('CreateInt:Sub16 UV.Y failed ',    0, a4it1.UV.Y);
  AssertEquals('CreateInt:Sub17 Left   failed ', -100, a4it1.Left);
  AssertEquals('CreateInt:Sub18 Top    failed ',  100, a4it1.Top);
  AssertEquals('CreateInt:Sub19 Right  failed ',  200, a4it1.Right);
  AssertEquals('CreateInt:Sub20 Bottom failed ',    0, a4it1.Bottom);
  AssertEquals('CreateInt:Sub21 TopLeft.X     failed ', -100, a4it1.TopLeft.X);
  AssertEquals('CreateInt:Sub22 TopLect.Y     failed ',  100, a4it1.TopLeft.Y);
  AssertEquals('CreateInt:Sub23 BottomRight.X failed ',  200, a4it1.BottomRight.X);
  AssertEquals('CreateInt:Sub24 BottomRight.Y failed ',    0, a4it1.BottomRight.Y);
  AssertEquals('CreateInt:Sub25 As3i.X failed ', -100, a4it1.AsVector3i.X);
  AssertEquals('CreateInt:Sub26 As3i.Y failed ',  100, a4it1.AsVector3i.Y);
  AssertEquals('CreateInt:Sub27 As3i.Z failed ',  200, a4it1.AsVector3i.Z);
   a4it1.Create(-100, 100, 200, 1);
  AssertEquals('CreateInt:Sub28 X failed ', -100, a4it1.X);
  AssertEquals('CreateInt:Sub29 Y failed ',  100, a4it1.Y);
  AssertEquals('CreateInt:Sub30 Z failed ',  200, a4it1.Z);
  AssertEquals('CreateInt:Sub31 W failed ',    1, a4it1.W);
end;

procedure TVector4iFunctionalTest.TestCreate3i;
begin
  a4it1.Create(-100, 100, 200);  //Check default.
  a3it1 := a4it1.AsVector3i;
  a4it1.Create(a3it1);
  AssertEquals('Create3i:Sub1 X failed ',   -100, a4it1.X);
  AssertEquals('Create3i:Sub2 Y failed ',    100, a4it1.Y);
  AssertEquals('Create3i:Sub3 Z failed ',    200, a4it1.Z);
  AssertEquals('Create3i:Sub4 W failed ',      0, a4it1.W);
  a4it1.Create(a3it1, 2000);
  AssertEquals('Create3i:Sub5 X failed ',   -100, a4it1.X);
  AssertEquals('Create3i:Sub6 Y failed ',    100, a4it1.Y);
  AssertEquals('Create3i:Sub7 Z failed ',    200, a4it1.Z);
  AssertEquals('Create3i:Sub8 W failed ',   2000, a4it1.W);
end;

procedure TVector4iFunctionalTest.TestCreate3b;
var abt1: TGLZVector3b;
begin
  abt1.Create(200,140,170);
  a4it1.Create(abt1);
  AssertEquals('Create3b:Sub1 X failed ',    200, a4it1.X);
  AssertEquals('Create3b:Sub2 Y failed ',    140, a4it1.Y);
  AssertEquals('Create3b:Sub3 Z failed ',    170, a4it1.Z);
  AssertEquals('Create3b:Sub4 W failed ',      0, a4it1.W);
  a4it1.Create(abt1, 2000);
  AssertEquals('Create3b:Sub5 X failed ',   200, a4it1.X);
  AssertEquals('Create3b:Sub6 Y failed ',   140, a4it1.Y);
  AssertEquals('Create3b:Sub7 Z failed ',   170, a4it1.Z);
  AssertEquals('Create3b:Sub8 W failed ',  2000, a4it1.W);
end;

procedure TVector4iFunctionalTest.TestNegate;
begin
  a4it1.Create(-100, 100, 200, 1);
  a4it4 := -a4it1;
  AssertEquals('Negate:Sub1 X failed ',  100, a4it4.X);
  AssertEquals('Negate:Sub2 Y failed ', -100, a4it4.Y);
  AssertEquals('Negate:Sub3 Z failed ', -200, a4it4.Z);
  AssertEquals('Negate:Sub4 W failed ',   -1, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestOpAdd;
begin
  a4it1.Create(-100, 100, 200, 1);
  a4it2.Create(1000, 400, 2000, 1);
  a4it4 := a4it1 + a4it2;
  AssertEquals('OpAdd:Sub1 X failed ',  900, a4it4.X);
  AssertEquals('OpAdd:Sub2 Y failed ',  500, a4it4.Y);
  AssertEquals('OpAdd:Sub3 Z failed ', 2200, a4it4.Z);
  AssertEquals('OpAdd:Sub4 W failed ',    2, a4it4.W);
  a4it4 := a4it1 + -a4it2;
  AssertEquals('OpAdd:Sub5 X failed ', -1100, a4it4.X);
  AssertEquals('OpAdd:Sub6 Y failed ',  -300, a4it4.Y);
  AssertEquals('OpAdd:Sub7 Z failed ', -1800, a4it4.Z);
  AssertEquals('OpAdd:Sub8 W failed ',     0, a4it4.W);
  a4it4 := -a4it1 + a4it2;
  AssertEquals('OpAdd:Sub9 X failed ',  1100, a4it4.X);
  AssertEquals('OpAdd:Sub10 Y failed ',   300, a4it4.Y);
  AssertEquals('OpAdd:Sub11 Z failed ',  1800, a4it4.Z);
  AssertEquals('OpAdd:Sub12 W failed ',     0, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestOpAddInt;
begin
  a4it1.Create(1000, 400, 2000, 1);
  a4it4 := a4it1 + 500;
  AssertEquals('OpAddInt:Sub1 X failed ', 1500, a4it4.X);
  AssertEquals('OpAddInt:Sub2 Y failed ',  900, a4it4.Y);
  AssertEquals('OpAddInt:Sub3 Z failed ', 2500, a4it4.Z);
  AssertEquals('OpAddInt:Sub4 W failed ',  501, a4it4.W);
  a4it4 := -a4it1 + 500;
  AssertEquals('OpAddInt:Sub5 X failed ',  -500, a4it4.X);
  AssertEquals('OpAddInt:Sub6 Y failed ',   100, a4it4.Y);
  AssertEquals('OpAddInt:Sub7 Z failed ', -1500, a4it4.Z);
  AssertEquals('OpAddInt:Sub8 W failed ',   499, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestOpSub;
begin
  a4it1.Create(-100, 100, 200, 1);
  a4it2.Create(1000, 400, 2000, 1);
  a4it4 := a4it1 - a4it2;
  AssertEquals('OpSub:Sub1 X failed ', -1100, a4it4.X);
  AssertEquals('OpSub:Sub2 Y failed ',  -300, a4it4.Y);
  AssertEquals('OpSub:Sub3 Z failed ', -1800, a4it4.Z);
  AssertEquals('OpSub:Sub4 W failed ',     0, a4it4.W);
  a4it4 := a4it1 - -a4it2;
  AssertEquals('OpSub:Sub5 X failed ',  900, a4it4.X);
  AssertEquals('OpSub:Sub6 Y failed ',  500, a4it4.Y);
  AssertEquals('OpSub:Sub7 Z failed ', 2200, a4it4.Z);
  AssertEquals('OpSub:Sub8 W failed ',    2, a4it4.W);
  a4it4 := -a4it1 - -a4it2;
  AssertEquals('OpSub:Sub9 X failed ',  1100, a4it4.X);
  AssertEquals('OpSub:Sub10 Y failed ',   300, a4it4.Y);
  AssertEquals('OpSub:Sub11 Z failed ',  1800, a4it4.Z);
  AssertEquals('OpSub:Sub12 W failed ',     0, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestOpSubInt;
begin
  a4it1.Create(1000, 400, 2000, 1);
  a4it4 := a4it1 - 500;
  AssertEquals('OpSubInt:Sub1 X failed ',  500, a4it4.X);
  AssertEquals('OpSubInt:Sub2 Y failed ', -100, a4it4.Y);
  AssertEquals('OpSubInt:Sub3 Z failed ', 1500, a4it4.Z);
  AssertEquals('OpSubInt:Sub4 W failed ', -499, a4it4.W);
  a4it4 := -a4it1 - 500;
  AssertEquals('OpSubInt:Sub5 X failed ', -1500, a4it4.X);
  AssertEquals('OpSubInt:Sub6 Y failed ',  -900, a4it4.Y);
  AssertEquals('OpSubInt:Sub7 Z failed ', -2500, a4it4.Z);
  AssertEquals('OpSubInt:Sub8 W failed ',  -501, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestOpMul;
begin
  a4it1.Create(-100, 100, 200, 1);
  a4it2.Create(10, 5, 100, 20);
  a4it4 := a4it1 * a4it2;
  AssertEquals('OpMul:Sub1 X failed ', -1000, a4it4.X);
  AssertEquals('OpMul:Sub2 Y failed ',   500, a4it4.Y);
  AssertEquals('OpMul:Sub3 Z failed ', 20000, a4it4.Z);
  AssertEquals('OpMul:Sub4 W failed ',    20, a4it4.W);
  a4it4 := -a4it1 * -a4it2;
  AssertEquals('OpMul:Sub5 X failed ', -1000, a4it4.X);
  AssertEquals('OpMul:Sub6 Y failed ',   500, a4it4.Y);
  AssertEquals('OpMul:Sub7 Z failed ', 20000, a4it4.Z);
  AssertEquals('OpMul:Sub8 W failed ',    20, a4it4.W);
  a4it4 := a4it1 * -a4it2;
  AssertEquals('OpMul:Sub9 X failed ',   1000, a4it4.X);
  AssertEquals('OpMul:Sub10 Y failed ',   -500, a4it4.Y);
  AssertEquals('OpMul:Sub11 Z failed ', -20000, a4it4.Z);
  AssertEquals('OpMul:Sub12 W failed ',    -20, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestOpMulInt;
begin
  a4it1.Create(-100, 100, 200, 1);
  a4it4 := a4it1 * 10;
  AssertEquals('OpMulInt:Sub1 X failed ', -1000, a4it4.X);
  AssertEquals('OpMulInt:Sub2 Y failed ',  1000, a4it4.Y);
  AssertEquals('OpMulInt:Sub3 Z failed ',  2000, a4it4.Z);
  AssertEquals('OpMulInt:Sub4 W failed ',    10, a4it4.W);
  a4it4 := -a4it1 * 10;
  AssertEquals('OpMulInt:Sub5 X failed ',   1000, a4it4.X);
  AssertEquals('OpMulInt:Sub6 Y failed ',  -1000, a4it4.Y);
  AssertEquals('OpMulInt:Sub7 Z failed ',  -2000, a4it4.Z);
  AssertEquals('OpMulInt:Sub8 W failed ',    -10, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestOpMulSingle;
begin
  a4it1.Create(-100, 100, 200, 1);
  a4it4 := a4it1 * 1.5;
  AssertEquals('OpMulSingle:Sub1 X failed ', -150, a4it4.X);
  AssertEquals('OpMulSingle:Sub2 Y failed ',  150, a4it4.Y);
  AssertEquals('OpMulSingle:Sub3 Z failed ',  300, a4it4.Z);
  AssertEquals('OpMulSingle:Sub4 W failed ',    2, a4it4.W);  // round to even
  a4it1.Create(2,3,4,5); // full test for round to even
  a4it4 := a4it1 * 0.5;
  AssertEquals('OpMulSingle:Sub5 X failed ',  1, a4it4.X);  // 1.0
  AssertEquals('OpMulSingle:Sub6 Y failed ',  2, a4it4.Y);  // 1.5
  AssertEquals('OpMulSingle:Sub7 Z failed ',  2, a4it4.Z);  // 2.0
  AssertEquals('OpMulSingle:Sub7 W failed ',  2, a4it4.W);  // 2.5
end;

procedure TVector4iFunctionalTest.TestOpDiv;
begin
  a4it1.Create(2,3,4,5); // test for trunc halves
  a4it2.Create(2,2,2,2);
  a4it4 := a4it1 div a4it2;
  AssertEquals('OpDiv:Sub1 X failed ',  1, a4it4.X);
  AssertEquals('OpDiv:Sub2 Y failed ',  1, a4it4.Y);
  AssertEquals('OpDiv:Sub3 Z failed ',  2, a4it4.Z);
  AssertEquals('OpDiv:Sub4 W failed ',  2, a4it4.W);
  a4it1.Create(14,26,34,46); // mult of 7 13 17 23
  a4it2.Create(8,14,18,24);
  a4it4 := a4it1 div a4it2;  // trunc of large partial
  AssertEquals('OpDiv:Sub5 X failed ',  1, a4it4.X);
  AssertEquals('OpDiv:Sub6 Y failed ',  1, a4it4.Y);
  AssertEquals('OpDiv:Sub7 Z failed ',  1, a4it4.Z);
  AssertEquals('OpDiv:Sub8 W failed ',  1, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestOpDivInt;
begin
  a4it1.Create(2,3,4,5); // test for trunc halves
  a4it4 := a4it1 div 2;
  AssertEquals('OpDivInt:Sub1 X failed ',  1, a4it4.X);
  AssertEquals('OpDivInt:Sub2 Y failed ',  1, a4it4.Y);
  AssertEquals('OpDivInt:Sub3 Z failed ',  2, a4it4.Z);
  AssertEquals('OpDivInt:Sub4 W failed ',  2, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestEquals;
begin
  a4it1.Create(120,60,180,240);
  a4it2.Create(120,60,180,240);
  nb := a4it1 = a4it2;
  AssertEquals('OpEquality:Sub1 does not match ', True, nb);
  a4it2.Create(120,60,181,240);
  nb := a4it1 = a4it2;
  AssertEquals('OpEquality:Sub2 should not match ', False, nb);
  a4it2.Create(120,61,180,240);
  nb := a4it1 = a4it2;
  AssertEquals('OpEquality:Sub3 should not match ', False, nb);
  a4it2.Create(119,60,180,240);
  nb := a4it1 = a4it2;
  AssertEquals('OpEquality:Sub4 should not match ', False, nb);
  a4it2.Create(120,60,180,241);
  nb := a4it1 = a4it2;
  AssertEquals('OpEquality:Sub5 should not match ', False, nb);
end;

procedure TVector4iFunctionalTest.TestNotEquals;
begin
  a4it1.Create(120,60,180,240);
  a4it2.Create(120,60,180,240);
  nb := a4it1 <> a4it2;
  AssertEquals('OpNotEquals:Sub1 should not match ', False, nb);
  a4it2.Create(120,60,181,240);
  nb := a4it1 <> a4it2;
  AssertEquals('OpNotEquals:Sub2 does not match ', True, nb);
  a4it2.Create(120,61,180,240);
  nb := a4it1 <> a4it2;
  AssertEquals('OpNotEquals:Sub3 does not match ', True, nb);
  a4it2.Create(119,60,180,240);
  nb := a4it1 <> a4it2;
  AssertEquals('OpNotEquals:Sub4 does not match ', True, nb);
  a4it2.Create(120,60,180,241);
  nb := a4it1 <> a4it2;
  AssertEquals('OpNotEquals:Sub5 does not match ', True, nb);
end;

procedure TVector4iFunctionalTest.TestDivide2;
begin
  a4it1.Create(2,3,4,5); // test for trunc halves
  a4it4 := a4it1.DivideBy2;
  AssertEquals('Divide2:Sub1 X failed ',  1, a4it4.X);
  AssertEquals('Divide2:Sub2 Y failed ',  1, a4it4.Y);
  AssertEquals('Divide2:Sub3 Z failed ',  2, a4it4.Z);
  AssertEquals('Divide2:Sub4 W failed ',  2, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestAbs;
begin
  a4it1.Create(-120,60,-180,240);
  a4it4 := a4it1.Abs;
  AssertEquals('Abs:Sub1 X failed ',  120, a4it4.X);
  AssertEquals('Abs:Sub2 Y failed ',   60, a4it4.Y);
  AssertEquals('Abs:Sub3 Z failed ',  180, a4it4.Z);
  AssertEquals('Abs:Sub4 W failed ',  240, a4it4.W);
  a4it1.Create(120,-60,180,-240);
  a4it4 := a4it1.Abs;
  AssertEquals('Abs:Sub5 X failed ',  120, a4it4.X);
  AssertEquals('Abs:Sub6 Y failed ',   60, a4it4.Y);
  AssertEquals('Abs:Sub7 Z failed ',  180, a4it4.Z);
  AssertEquals('Abs:Sub8 W failed ',  240, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestMin;
begin
  a4it1.Create(-120,60,-180,240);
  a4it2.Create(120,-60,180,-240);
  a4it4 := a4it1.Min(a4it2);
  AssertEquals('Min:Sub1 X failed ', -120, a4it4.X);
  AssertEquals('Min:Sub2 Y failed ',  -60, a4it4.Y);
  AssertEquals('Min:Sub3 Z failed ', -180, a4it4.Z);
  AssertEquals('Min:Sub4 W failed ', -240, a4it4.W);
  a4it4 := a4it2.Min(a4it1);
  AssertEquals('Min:Sub5 X failed ', -120, a4it4.X);
  AssertEquals('Min:Sub6 Y failed ',  -60, a4it4.Y);
  AssertEquals('Min:Sub7 Z failed ', -180, a4it4.Z);
  AssertEquals('Min:Sub8 W failed ', -240, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestMinInt;
begin
  a4it1.Create(-120,60,-180,240);
  a4it2.Create(120,-60,180,-240);
  a4it4 := a4it1.Min(0);
  AssertEquals('MinInt:Sub1 X failed ', -120, a4it4.X);
  AssertEquals('MinInt:Sub2 Y failed ',    0, a4it4.Y);
  AssertEquals('MinInt:Sub3 Z failed ', -180, a4it4.Z);
  AssertEquals('MinInt:Sub4 W failed ',    0, a4it4.W);
  a4it4 := a4it2.Min(0);
  AssertEquals('MinInt:Sub5 X failed ',    0, a4it4.X);
  AssertEquals('MinInt:Sub6 Y failed ',  -60, a4it4.Y);
  AssertEquals('MinInt:Sub7 Z failed ',    0, a4it4.Z);
  AssertEquals('MinInt:Sub8 W failed ', -240, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestMax;
begin
  a4it1.Create(-120,60,-180,240);
  a4it2.Create(120,-60,180,-240);
  a4it4 := a4it1.Max(a4it2);
  AssertEquals('Max:Sub1 X failed ', 120, a4it4.X);
  AssertEquals('Max:Sub2 Y failed ',  60, a4it4.Y);
  AssertEquals('Max:Sub3 Z failed ', 180, a4it4.Z);
  AssertEquals('Max:Sub4 W failed ', 240, a4it4.W);
  a4it4 := a4it2.Max(a4it1);
  AssertEquals('Max:Sub5 X failed ', 120, a4it4.X);
  AssertEquals('Max:Sub6 Y failed ',  60, a4it4.Y);
  AssertEquals('Max:Sub7 Z failed ', 180, a4it4.Z);
  AssertEquals('Max:Sub8 W failed ', 240, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestMaxInt;
begin
  a4it1.Create(-120,60,-180,240);
  a4it2.Create(120,-60,180,-240);
  a4it4 := a4it1.Max(0);
  AssertEquals('MaxInt:Sub1 X failed ',   0, a4it4.X);
  AssertEquals('MaxInt:Sub2 Y failed ',  60, a4it4.Y);
  AssertEquals('MaxInt:Sub3 Z failed ',   0, a4it4.Z);
  AssertEquals('MaxInt:Sub4 W failed ', 240, a4it4.W);
  a4it4 := a4it2.Max(0);
  AssertEquals('MaxInt:Sub5 X failed ', 120, a4it4.X);
  AssertEquals('MaxInt:Sub6 Y failed ',   0, a4it4.Y);
  AssertEquals('MaxInt:Sub7 Z failed ', 180, a4it4.Z);
  AssertEquals('MaxInt:Sub8 W failed ',   0, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestClamp;
begin
  a4it1.Create(-120,60,-180,240);
  a4it2.Create(0,0,0,0);
  a4it3.Create(500,500,500,500);
  a4it4 := a4it1.Clamp(a4it2,a4it3);
  AssertEquals('Clamp:Sub1 X failed ',   0, a4it4.X);
  AssertEquals('Clamp:Sub2 Y failed ',  60, a4it4.Y);
  AssertEquals('Clamp:Sub3 Z failed ',   0, a4it4.Z);
  AssertEquals('Clamp:Sub4 W failed ', 240, a4it4.W);
  a4it1.Create(120,-60,180,-240);
  a4it4 := a4it1.Clamp(a4it2,a4it3);
  AssertEquals('Clamp:Sub5 X failed ', 120, a4it4.X);
  AssertEquals('Clamp:Sub6 Y failed ',   0, a4it4.Y);
  AssertEquals('Clamp:Sub7 Z failed ', 180, a4it4.Z);
  AssertEquals('Clamp:Sub8 W failed ',   0, a4it4.W);
  a4it1.Create(620,60,780,240);
  a4it4 := a4it1.Clamp(a4it2,a4it3);
  AssertEquals('Clamp:Sub9 X failed ',  500, a4it4.X);
  AssertEquals('Clamp:Sub10 Y failed ',  60, a4it4.Y);
  AssertEquals('Clamp:Sub11 Z failed ', 500, a4it4.Z);
  AssertEquals('Clamp:Sub12 W failed ', 240, a4it4.W);
  a4it1.Create(120,600,180,740);
  a4it4 := a4it1.Clamp(a4it2,a4it3);
  AssertEquals('Clamp:Sub13 X failed ', 120, a4it4.X);
  AssertEquals('Clamp:Sub14 Y failed ', 500, a4it4.Y);
  AssertEquals('Clamp:Sub15 Z failed ', 180, a4it4.Z);
  AssertEquals('Clamp:Sub16 W failed ', 500, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestClampInt;
begin
  a4it1.Create(-120,60,-180,240);
  a4it4 := a4it1.Clamp(0,500);
  AssertEquals('Clamp:Sub1 X failed ',   0, a4it4.X);
  AssertEquals('Clamp:Sub2 Y failed ',  60, a4it4.Y);
  AssertEquals('Clamp:Sub3 Z failed ',   0, a4it4.Z);
  AssertEquals('Clamp:Sub4 W failed ', 240, a4it4.W);
  a4it1.Create(120,-60,180,-240);
  a4it4 := a4it1.Clamp(0,500);
  AssertEquals('Clamp:Sub5 X failed ', 120, a4it4.X);
  AssertEquals('Clamp:Sub6 Y failed ',   0, a4it4.Y);
  AssertEquals('Clamp:Sub7 Z failed ', 180, a4it4.Z);
  AssertEquals('Clamp:Sub8 W failed ',   0, a4it4.W);
  a4it1.Create(620,60,780,240);
  a4it4 := a4it1.Clamp(0,500);
  AssertEquals('Clamp:Sub9 X failed ',  500, a4it4.X);
  AssertEquals('Clamp:Sub10 Y failed ',  60, a4it4.Y);
  AssertEquals('Clamp:Sub11 Z failed ', 500, a4it4.Z);
  AssertEquals('Clamp:Sub12 W failed ', 240, a4it4.W);
  a4it1.Create(120,600,180,740);
  a4it4 := a4it1.Clamp(0,500);
  AssertEquals('Clamp:Sub13 X failed ', 120, a4it4.X);
  AssertEquals('Clamp:Sub14 Y failed ', 500, a4it4.Y);
  AssertEquals('Clamp:Sub15 Z failed ', 180, a4it4.Z);
  AssertEquals('Clamp:Sub16 W failed ', 500, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestMulAdd;
begin
  a4it1.Create(-120,60,-180,240);
  a4it2.Create(10,10,10,10);
  a4it3.Create(500,500,500,500);
  a4it4 := a4it1.MulAdd(a4it2,a4it3);
  AssertEquals('MulAdd:Sub1 X failed ',  -700, a4it4.X);
  AssertEquals('MulAdd:Sub2 Y failed ',  1100, a4it4.Y);
  AssertEquals('MulAdd:Sub3 Z failed ', -1300, a4it4.Z);
  AssertEquals('MulAdd:Sub4 W failed ',  2900, a4it4.W);
  a4it4 := a4it3.MulAdd(a4it2,a4it1);
  AssertEquals('MulAdd:Sub5 X failed ',  4880, a4it4.X);
  AssertEquals('MulAdd:Sub6 Y failed ',  5060, a4it4.Y);
  AssertEquals('MulAdd:Sub7 Z failed ',  4820, a4it4.Z);
  AssertEquals('MulAdd:Sub8 W failed ',  5240, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestMulDiv;
begin
  a4it1.Create(-120,60,-180,240);
  a4it2.Create(10,10,10,10);
  a4it3.Create(5,5,5,5);
  a4it4 := a4it1.MulDiv(a4it2,a4it3);
  AssertEquals('MulDiv:Sub1 X failed ', -240, a4it4.X);
  AssertEquals('MulDiv:Sub2 Y failed ',  120, a4it4.Y);
  AssertEquals('MulDiv:Sub3 Z failed ', -360, a4it4.Z);
  AssertEquals('MulDiv:Sub4 W failed ',  480, a4it4.W);
  a4it4 := a4it3.MulDiv(a4it2,a4it1);
  AssertEquals('MulDiv:Sub5 X failed ',  0, a4it4.X);
  AssertEquals('MulDiv:Sub6 Y failed ',  0, a4it4.Y);
  AssertEquals('MulDiv:Sub7 Z failed ',  0, a4it4.Z);
  AssertEquals('MulDiv:Sub8 W failed ',  0, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestShuffle;
begin
  a4it1.Create(-120,60,-180,240);
  a4it4 := a4it1.Shuffle(0,0,0,0);
  AssertEquals('Shuffle:Sub1 X failed ', -120, a4it4.X);
  AssertEquals('Shuffle:Sub2 Y failed ', -120, a4it4.Y);
  AssertEquals('Shuffle:Sub3 Z failed ', -120, a4it4.Z);
  AssertEquals('Shuffle:Sub4 W failed ', -120, a4it4.W);
  a4it4 := a4it1.Shuffle(0,0,1,1);
  AssertEquals('Shuffle:Sub1 X failed ', -120, a4it4.X);
  AssertEquals('Shuffle:Sub2 Y failed ', -120, a4it4.Y);
  AssertEquals('Shuffle:Sub3 Z failed ',   60, a4it4.Z);
  AssertEquals('Shuffle:Sub4 W failed ',   60, a4it4.W);
  a4it4 := a4it1.Shuffle(2,3,2,3);
  AssertEquals('Shuffle:Sub1 X failed ', -180, a4it4.X);
  AssertEquals('Shuffle:Sub2 Y failed ',  240, a4it4.Y);
  AssertEquals('Shuffle:Sub3 Z failed ', -180, a4it4.Z);
  AssertEquals('Shuffle:Sub4 W failed ',  240, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestSwizzle;
begin
  a4it1.Create(1,2,3,4);
  a4it4 := a4it1.Swizzle(swXXXX);
  AssertEquals('Swizzle:Sub1 X failed ', 1, a4it4.X);
  AssertEquals('Swizzle:Sub2 Y failed ', 1, a4it4.Y);
  AssertEquals('Swizzle:Sub3 Z failed ', 1, a4it4.Z);
  AssertEquals('Swizzle:Sub4 W failed ', 1, a4it4.W);
  a4it4 := a4it1.Swizzle(swYYYY);
  AssertEquals('Swizzle:Sub5 X failed ', 2, a4it4.X);
  AssertEquals('Swizzle:Sub6 Y failed ', 2, a4it4.Y);
  AssertEquals('Swizzle:Sub7 Z failed ', 2, a4it4.Z);
  AssertEquals('Swizzle:Sub8 W failed ', 2, a4it4.W);
  a4it4 := a4it1.Swizzle(swZZZZ);
  AssertEquals('Swizzle:Sub9 X failed ',  3, a4it4.X);
  AssertEquals('Swizzle:Sub10 Y failed ', 3, a4it4.Y);
  AssertEquals('Swizzle:Sub11 Z failed ', 3, a4it4.Z);
  AssertEquals('Swizzle:Sub12 W failed ', 3, a4it4.W);
  a4it4 := a4it1.Swizzle(swWWWW);
  AssertEquals('Swizzle:Sub13 X failed ', 4, a4it4.X);
  AssertEquals('Swizzle:Sub14 Y failed ', 4, a4it4.Y);
  AssertEquals('Swizzle:Sub15 Z failed ', 4, a4it4.Z);
  AssertEquals('Swizzle:Sub16 W failed ', 4, a4it4.W);
  a4it4 := a4it1.Swizzle(swXYZW);
  AssertEquals('Swizzle:Sub17 X failed ', 1, a4it4.X);
  AssertEquals('Swizzle:Sub18 Y failed ', 2, a4it4.Y);
  AssertEquals('Swizzle:Sub19 Z failed ', 3, a4it4.Z);
  AssertEquals('Swizzle:Sub20 W failed ', 4, a4it4.W);
  a4it4 := a4it1.Swizzle(swXZYW);
  AssertEquals('Swizzle:Sub21 X failed ', 1, a4it4.X);
  AssertEquals('Swizzle:Sub22 Y failed ', 3, a4it4.Y);
  AssertEquals('Swizzle:Sub23 Z failed ', 2, a4it4.Z);
  AssertEquals('Swizzle:Sub24 W failed ', 4, a4it4.W);
  a4it4 := a4it1.Swizzle(swZYXW);
  AssertEquals('Swizzle:Sub21 X failed ', 3, a4it4.X);
  AssertEquals('Swizzle:Sub22 Y failed ', 2, a4it4.Y);
  AssertEquals('Swizzle:Sub23 Z failed ', 1, a4it4.Z);
  AssertEquals('Swizzle:Sub24 W failed ', 4, a4it4.W);
  a4it4 := a4it1.Swizzle(swZXYW);
  AssertEquals('Swizzle:Sub25 X failed ', 3, a4it4.X);
  AssertEquals('Swizzle:Sub26 Y failed ', 1, a4it4.Y);
  AssertEquals('Swizzle:Sub27 Z failed ', 2, a4it4.Z);
  AssertEquals('Swizzle:Sub28 W failed ', 4, a4it4.W);
  a4it4 := a4it1.Swizzle(swYXZW);
  AssertEquals('Swizzle:Sub29 X failed ', 2, a4it4.X);
  AssertEquals('Swizzle:Sub30 Y failed ', 1, a4it4.Y);
  AssertEquals('Swizzle:Sub31 Z failed ', 3, a4it4.Z);
  AssertEquals('Swizzle:Sub32 W failed ', 4, a4it4.W);
  a4it4 := a4it1.Swizzle(swYZXW);
  AssertEquals('Swizzle:Sub33 X failed ', 2, a4it4.X);
  AssertEquals('Swizzle:Sub34 Y failed ', 3, a4it4.Y);
  AssertEquals('Swizzle:Sub35 Z failed ', 1, a4it4.Z);
  AssertEquals('Swizzle:Sub36 W failed ', 4, a4it4.W);
  a4it4 := a4it1.Swizzle(swWXYZ);
  AssertEquals('Swizzle:Sub37 X failed ', 4, a4it4.X);
  AssertEquals('Swizzle:Sub38 Y failed ', 1, a4it4.Y);
  AssertEquals('Swizzle:Sub39 Z failed ', 2, a4it4.Z);
  AssertEquals('Swizzle:Sub40 W failed ', 3, a4it4.W);
  a4it4 := a4it1.Swizzle(swWXZY);
  AssertEquals('Swizzle:Sub41 X failed ', 4, a4it4.X);
  AssertEquals('Swizzle:Sub42 Y failed ', 1, a4it4.Y);
  AssertEquals('Swizzle:Sub43 Z failed ', 3, a4it4.Z);
  AssertEquals('Swizzle:Sub44 W failed ', 2, a4it4.W);
  a4it4 := a4it1.Swizzle(swWZYX);
  AssertEquals('Swizzle:Sub45 X failed ', 4, a4it4.X);
  AssertEquals('Swizzle:Sub46 Y failed ', 3, a4it4.Y);
  AssertEquals('Swizzle:Sub47 Z failed ', 2, a4it4.Z);
  AssertEquals('Swizzle:Sub48 W failed ', 1, a4it4.W);
  a4it4 := a4it1.Swizzle(swWZYX);
  AssertEquals('Swizzle:Sub45 X failed ', 4, a4it4.X);
  AssertEquals('Swizzle:Sub46 Y failed ', 3, a4it4.Y);
  AssertEquals('Swizzle:Sub47 Z failed ', 2, a4it4.Z);
  AssertEquals('Swizzle:Sub48 W failed ', 1, a4it4.W);
  a4it4 := a4it1.Swizzle(swWZXY);
  AssertEquals('Swizzle:Sub49 X failed ', 4, a4it4.X);
  AssertEquals('Swizzle:Sub50 Y failed ', 3, a4it4.Y);
  AssertEquals('Swizzle:Sub51 Z failed ', 1, a4it4.Z);
  AssertEquals('Swizzle:Sub52 W failed ', 2, a4it4.W);
  a4it4 := a4it1.Swizzle(swWYXZ);
  AssertEquals('Swizzle:Sub53 X failed ', 4, a4it4.X);
  AssertEquals('Swizzle:Sub54 Y failed ', 2, a4it4.Y);
  AssertEquals('Swizzle:Sub55 Z failed ', 1, a4it4.Z);
  AssertEquals('Swizzle:Sub56 W failed ', 3, a4it4.W);
  a4it4 := a4it1.Swizzle(swWYZX);
  AssertEquals('Swizzle:Sub53 X failed ', 4, a4it4.X);
  AssertEquals('Swizzle:Sub54 Y failed ', 2, a4it4.Y);
  AssertEquals('Swizzle:Sub55 Z failed ', 3, a4it4.Z);
  AssertEquals('Swizzle:Sub56 W failed ', 1, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestCombine;
begin
  a4it1.Create(12,12,12,12);
  a4it2.Create(40,50,60,255);
  fs1 := 3;
  a4it4 := a4it1.Combine(a4it2,fs1);
  AssertEquals('Combine:Sub1 X failed ', 132, a4it4.X);
  AssertEquals('Combine:Sub2 Y failed ', 162, a4it4.Y);
  AssertEquals('Combine:Sub3 Z failed ', 192, a4it4.Z);
  AssertEquals('Combine:Sub4 W failed ',  12, a4it4.W);
  fs1 := 5;
  a4it4 := a4it1.Combine(a4it2,fs1);
  AssertEquals('Combine:Sub5 X failed ',  212, a4it4.X);
  AssertEquals('Combine:Sub6 Y failed ',  262, a4it4.Y);
  AssertEquals('Combine:Sub7 Z failed ',  312, a4it4.Z);
  AssertEquals('Combine:Sub8 W failed ',   12, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestCombine2;
begin
  a4it1.Create(12,12,12,12);
  a4it2.Create(40,50,60,255);
  a4it4 := a4it1.Combine2(a4it2, 0.5, 0.5);   // nice whole numbers
  AssertEquals('Combine2:Sub1 X failed ', 26, a4it4.X);
  AssertEquals('Combine2:Sub2 Y failed ', 31, a4it4.Y);
  AssertEquals('Combine2:Sub3 Z failed ', 36, a4it4.Z);
  AssertEquals('Combine2:Sub4 W failed ', 12, a4it4.W);
  a4it4 := a4it1.Combine2(a4it2, 0.4999, 0.4999);   // almost same as above
  AssertEquals('Combine2:Sub1 X failed ', 26, a4it4.X);
  AssertEquals('Combine2:Sub2 Y failed ', 31, a4it4.Y);
  AssertEquals('Combine2:Sub3 Z failed ', 36, a4it4.Z);
  AssertEquals('Combine2:Sub4 W failed ', 12, a4it4.W);
  a4it4 := a4it1.Combine2(a4it2, 0.50003, 0.50004);   // almost same as above
  AssertEquals('Combine2:Sub1 X failed ', 26, a4it4.X);
  AssertEquals('Combine2:Sub2 Y failed ', 31, a4it4.Y);
  AssertEquals('Combine2:Sub3 Z failed ', 36, a4it4.Z);
  AssertEquals('Combine2:Sub4 W failed ', 12, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestCombine3;
begin
  a4it1.Create(12,12,12,12);
  a4it2.Create(40,50,60,255);
  a4it4 := a4it1.Combine3(a4it2, a4it2, 0.5, 0.5, 0.5);
  AssertEquals('Combine3:Sub1 X failed ', 46, a4it4.X);
  AssertEquals('Combine3:Sub2 Y failed ', 56, a4it4.Y);
  AssertEquals('Combine3:Sub3 Z failed ', 66, a4it4.Z);
  AssertEquals('Combine3:Sub4 W failed ', 12, a4it4.W);
  a4it4 := a4it1.Combine3(a4it2, a4it2, 0.4999, 0.4999, 0.4999);   // almost same as above
  AssertEquals('Combine3:Sub1 X failed ', 46, a4it4.X);
  AssertEquals('Combine3:Sub2 Y failed ', 56, a4it4.Y);
  AssertEquals('Combine3:Sub3 Z failed ', 66, a4it4.Z);
  AssertEquals('Combine3:Sub4 W failed ', 12, a4it4.W);
  a4it4 := a4it1.Combine3(a4it2, a4it2, 0.50003, 0.50003, 0.50004);   // almost same as above
  AssertEquals('Combine3:Sub1 X failed ', 46, a4it4.X);
  AssertEquals('Combine3:Sub2 Y failed ', 56, a4it4.Y);
  AssertEquals('Combine3:Sub3 Z failed ', 66, a4it4.Z);
  AssertEquals('Combine3:Sub4 W failed ', 12, a4it4.W);
end;

procedure TVector4iFunctionalTest.TestMinXYZComponent;
begin
  a4it1.Create(1,2,3,1);
  b4 := a4it1.MinXYZComponent;
  AssertEquals('MinXYZComponent:Sub1 failed ',  1, b4);
  a4it1.Create(6,4,3,1);
  b4 := a4it1.MinXYZComponent;
  AssertEquals('MinXYZComponent:Sub2 failed ',  3, b4);
  a4it1.Create(5,4,6,1);
  b4 := a4it1.MinXYZComponent;
  AssertEquals('MinXYZComponent:Sub3 failed ',  4, b4);
end;

procedure TVector4iFunctionalTest.TestMaxXYZComponent;
begin
  a4it1.Create(1,2,3,4);
  b4 := a4it1.MaxXYZComponent;
  AssertEquals('MaxXYZComponent:Sub1 failed ',  3, b4);
  a4it1.Create(1,4,3,6);
  b4 := a4it1.MaxXYZComponent;
  AssertEquals('MaxXYZComponent:Sub2 failed ',  4, b4);
  a4it1.Create(5,4,3,6);
  b4 := a4it1.MaxXYZComponent;
  AssertEquals('MaxXYZComponent:Sub3 failed ',  5, b4);

end;




initialization
  RegisterTest(REPORT_GROUP_VECTOR4I, TVector4iFunctionalTest);
end.

