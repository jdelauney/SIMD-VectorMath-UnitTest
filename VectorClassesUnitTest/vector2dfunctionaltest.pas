unit vector2dfunctionaltest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

{$IFDEF USE_ASM_SSE_4}
  {$DEFINE USE_ASM_SSE_3}
{$ENDIF}

{$IFDEF USE_ASM_SSE_3}
  {$DEFINE USE_ASM}
{$ENDIF}

{$IFDEF USE_ASM_AVX}
  {$DEFINE USE_ASM}
{$ENDIF}

interface

uses
  Classes, SysUtils, math, fpcunit, testregistry, BaseTestCase,
  GLZVectorMath;

type

  { TVector2dFunctionalTest }

  TVector2dFunctionalTest = class(TVectorBaseTestCase)
    published
      procedure TestCreate;
      procedure TestOpAdd;
      procedure TestOpSub;
      procedure TestOpDiv;
      procedure TestOpMul;
      procedure TestOpAddDouble;
      procedure TestOpSubDouble;
      procedure TestOpDivDouble;
      procedure TestOpDiv2i;
      procedure TestOpMulDouble;
      procedure TestOpMul2i;
      procedure TestOpNegate;
      procedure TestEquals;
      procedure TestNotEquals;
      procedure TestMin;
      procedure TestMax;
      procedure TestMinDouble;
      procedure TestMaxDouble;
      procedure TestClamp;
      procedure TestClampDouble;
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
      procedure TestTrunc;
      procedure TestRound;
      procedure TestFloor;
      procedure TestCeil;
      procedure TestFract;
      procedure TestSqrt;
      procedure TestInvSqrt;
      procedure TestModF;
      procedure TestfMod;
  end;

implementation

{ TVector2dFunctionalTest }

procedure TVector2dFunctionalTest.TestCreate;
begin
  vttd1.Create(1.234,2.345);
  AssertEquals('Create:Sub1 X failed ', 1.234, vttd1.X);
  AssertEquals('Create:Sub2 Y failed ', 2.345, vttd1.Y);
end;

procedure TVector2dFunctionalTest.TestOpAdd;
begin
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  vttd3 := vttd1 + vttd2;
  AssertEquals('OpAdd:Sub1 X failed ', 4.0, vttd3.X);
  AssertEquals('OpAdd:Sub2 Y failed ', 4.0, vttd3.Y);
  vttd3 := vttd2 + vttd1;
  AssertEquals('OpAdd:Sub3 X failed ', 4.0, vttd3.X);
  AssertEquals('OpAdd:Sub4 Y failed ', 4.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestOpSub;
begin
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  vttd3 := vttd1 - vttd2;
  AssertEquals('OpSub:Sub1 X failed ', -2.0, vttd3.X);
  AssertEquals('OpSub:Sub2 Y failed ', 0.0, vttd3.Y);
  vttd3 := vttd2 - vttd1;
  AssertEquals('OpSub:Sub3 X failed ', 2.0, vttd3.X);
  AssertEquals('OpSub:Sub4 Y failed ', 0.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestOpDiv;
begin
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  vttd3 := vttd1 / vttd2;
  AssertEquals('OpSub:Sub1 X failed ', 0.33333333333334, vttd3.X);
  AssertEquals('OpSub:Sub2 Y failed ', 1.0, vttd3.Y);
  vttd3 := vttd2 / vttd1;
  AssertEquals('OpSub:Sub3 X failed ', 3.0, vttd3.X);
  AssertEquals('OpSub:Sub4 Y failed ', 1.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestOpMul;
begin
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  vttd3 := vttd1 * vttd2;
  AssertEquals('OpMul:Sub1 X failed ', 3.0, vttd3.X);
  AssertEquals('OpMul:Sub2 Y failed ', 4.0, vttd3.Y);
  vttd3 := vttd2 * vttd1;
  AssertEquals('OpMul:Sub3 X failed ', 3.0, vttd3.X);
  AssertEquals('OpMul:Sub4 Y failed ', 4.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestOpAddDouble;
begin
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  vttd3 := vttd1 + 4.0;
  AssertEquals('OpAddDouble:Sub1 X failed ', 5.0, vttd3.X);
  AssertEquals('OpAddDouble:Sub2 Y failed ', 6.0, vttd3.Y);
  vttd3 := vttd2 + -5;
  AssertEquals('OpAddDouble:Sub3 X failed ', -2.0, vttd3.X);
  AssertEquals('OpAddDouble:Sub4 Y failed ', -3.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestOpSubDouble;
begin
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  vttd3 := vttd1 - 3.0;
  AssertEquals('OpSubDouble:Sub1 X failed ', -2.0, vttd3.X);
  AssertEquals('OpSubDouble:Sub2 Y failed ', -1.0, vttd3.Y);
  vttd3 := vttd2 - -5;
  AssertEquals('OpSubDouble:Sub3 X failed ', 8.0, vttd3.X);
  AssertEquals('OpSubDouble:Sub4 Y failed ', 7.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestOpDivDouble;
begin
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  vttd3 := vttd1 / -0.5;
  AssertEquals('OpDivDouble:Sub1 X failed ', -2.0, vttd3.X);
  AssertEquals('OpDivDouble:Sub2 Y failed ', -4.0, vttd3.Y);
  vttd3 := vttd2 / 0.25;
  AssertEquals('OpDivDouble:Sub3 X failed ', 12.0, vttd3.X);
  AssertEquals('OpDivDouble:Sub4 Y failed ', 8.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestOpDiv2i;
var
 at2i1: TGLZVector2i;
begin
  vttd1.Create(1.0,2.0);
  at2i1.Create(3,2);
  vttd3 := vttd1 / at2i1;
  AssertEquals('OpSub:Sub1 X failed ', 0.33333333333334, vttd3.X);
  AssertEquals('OpSub:Sub2 Y failed ', 1.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestOpMulDouble;
begin
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  vttd3 := vttd1 * -3;
  AssertEquals('OpMulDouble:Sub1 X failed ', -3.0, vttd3.X);
  AssertEquals('OpMulDouble:Sub2 Y failed ', -6.0, vttd3.Y);
  vttd3 := vttd2 * 3;
  AssertEquals('OpMulDouble:Sub3 X failed ', 9.0, vttd3.X);
  AssertEquals('OpMulDouble:Sub4 Y failed ', 6.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestOpMul2i;
begin
  vttd1.Create(1.234,2.345);
  vt2i.X := 2;
  vt2i.Y := 2;
  vttd2 := vttd1 * vt2i;
  AssertEquals('Mul2i:Sub1 X failed ',  2.468, vttd2.X);
  AssertEquals('Mul2i:Sub2 Y failed ',  4.69, vttd2.Y);
  vttd2 := -vttd1 * vt2i;
  AssertEquals('Mul2i:Sub3 X failed ', -2.468, vttd2.X);
  AssertEquals('Mul2i:Sub4 Y failed ', -4.69, vttd2.Y);
end;

procedure TVector2dFunctionalTest.TestOpNegate;
begin
  vttd1.Create(1.234,2.345);
  vttd2 := -vttd1;
  AssertEquals('Negate:Sub1 X failed ', -1.234, vttd2.X);
  AssertEquals('Negate:Sub2 Y failed ', -2.345, vttd2.Y);
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  vttd3 := -vttd1 + vttd2;
  AssertEquals('Negate:Sub3 X failed ', 2.0, vttd3.X);
  AssertEquals('Negate:Sub4 Y failed ', 0.0, vttd3.Y);
  vttd3 := -(vttd1 + vttd2);
  AssertEquals('Negate:Sub5 X failed ', -4.0, vttd3.X);
  AssertEquals('Negate:Sub6 Y failed ', -4.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestEquals;
begin
  vttd1.Create(1.234,2.345);
  vttd2.Create(1.234,2.345);
  nb := vttd1 = vttd2;
  AssertEquals('Equals:Sub1 failed ', True, nb);
  vttd2.Create(1.234,2.346);
  nb := vttd1 = vttd2;
  AssertEquals('Equals:Sub2 failed ', False, nb);
  vttd2.Create(1.235,2.345);
  nb := vttd1 = vttd2;
  AssertEquals('Equals:Sub3 failed ', False, nb);
end;

procedure TVector2dFunctionalTest.TestNotEquals;
begin
  vttd1.Create(1.234,2.345);
  vttd2.Create(1.234,2.345);
  nb := vttd1 <> vttd2;
  AssertEquals('NotEquals:Sub1 failed ', False, nb);
  vttd2.Create(1.234,2.346);
  nb := vttd1 <> vttd2;
  AssertEquals('NotEquals:Sub2 failed ', True, nb);
  vttd2.Create(1.235,2.345);
  nb := vttd1 <> vttd2;
  AssertEquals('NotEquals:Sub3 failed ', True, nb);
end;

procedure TVector2dFunctionalTest.TestMin;
begin
  vttd1.Create(-2.0,2.0);
  vttd2.Create(-1.0,1.0);
  vttd3 := vttd1.Min(vttd2);
  AssertEquals('Min:Sub1 X failed ', -2.0, vttd3.X);
  AssertEquals('Min:Sub2 Y failed ', 1.0, vttd3.Y);
  vttd3 := vttd2.Min(vttd1);
  AssertEquals('Min:Sub3 X failed ', -2.0, vttd3.X);
  AssertEquals('Min:Sub4 Y failed ', 1.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestMax;
begin
  vttd1.Create(-2.0,2.0);
  vttd2.Create(-1.0,1.0);
  vttd3 := vttd1.Max(vttd2);
  AssertEquals('Max:Sub1 X failed ', -1.0, vttd3.X);
  AssertEquals('Max:Sub2 Y failed ', 2.0, vttd3.Y);
  vttd3 := vttd2.Max(vttd1);
  AssertEquals('Max:Sub3 X failed ', -1.0, vttd3.X);
  AssertEquals('Max:Sub4 Y failed ', 2.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestMinDouble;
begin
  vttd1.Create(-2.0,2.0);
  vttd2.Create(-1.0,1.0);
  vttd3 := vttd1.Min(1.0);
  AssertEquals('MinDouble:Sub1 X failed ', -2.0, vttd3.X);
  AssertEquals('MinDouble:Sub2 Y failed ', 1.0, vttd3.Y);
  vttd3 := vttd2.Min(0.0);
  AssertEquals('MinDouble:Sub3 X failed ', -1.0, vttd3.X);
  AssertEquals('MinDouble:Sub4 Y failed ', 0.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestMaxDouble;
begin
  vttd1.Create(-2.0,2.0);
  vttd2.Create(-1.0,1.0);
  vttd3 := vttd1.Max(1.0);
  AssertEquals('MaxDouble:Sub1 X failed ', 1.0, vttd3.X);
  AssertEquals('MaxDouble:Sub2 Y failed ', 2.0, vttd3.Y);
  vttd3 := vttd2.Max(0.0);
  AssertEquals('MaxDouble:Sub3 X failed ', 0.0, vttd3.X);
  AssertEquals('MaxDouble:Sub4 Y failed ', 1.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestClamp;
begin
  vttd1.Create(6.0,5.0);
  vttd2.Create(3.0, 3.0);
  vttd4.Create(-1.0,-1.0);
  vttd3 := vttd1.Clamp(vttd4,vttd2);
  AssertEquals('Clamp:Sub1 X failed ', 3.0, vttd3.X);
  AssertEquals('Clamp:Sub2 Y failed ', 3.0, vttd3.Y);
  vttd1.Create(-6.0,-5.0);
  vttd3 := vttd1.Clamp(vttd4,vttd2);
  AssertEquals('Clamp:Sub3 X failed ', -1.0, vttd3.X);
  AssertEquals('Clamp:Sub4 Y failed ', -1.0, vttd3.Y);
  vttd1.Create(-6.0,2.0);
  vttd3 := vttd1.Clamp(vttd4,vttd2);
  AssertEquals('Clamp:Sub5 X failed ', -1.0, vttd3.X);
  AssertEquals('Clamp:Sub6 Y failed ',  2.0, vttd3.Y);
  vttd1.Create(2.0,-2.0);
  vttd3 := vttd1.Clamp(vttd4,vttd2);
  AssertEquals('Clamp:Sub7 X failed ',  2.0, vttd3.X);
  AssertEquals('Clamp:Sub8 Y failed ', -1.0, vttd3.Y);
  vttd1.Create(2.0,4.0);
  vttd3 := vttd1.Clamp(vttd4,vttd2);
  AssertEquals('Clamp:Sub9 X failed ',   2.0, vttd3.X);
  AssertEquals('Clamp:Sub10 Y failed ',  3.0, vttd3.Y);
  vttd1.Create(4.0,2.0);
  vttd3 := vttd1.Clamp(vttd4,vttd2);
  AssertEquals('Clamp:Sub11 X failed ',  3.0, vttd3.X);
  AssertEquals('Clamp:Sub12 Y failed ',  2.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestClampDouble;
begin
  vttd1.Create(6.0, 5.0);
  fs1 := -1.0;
  fs2 := 3.0;
  vttd3 := vttd1.Clamp(fs1,fs2);
  AssertEquals('ClampDouble:Sub1 X failed ', 3.0, vttd3.X);
  AssertEquals('ClampDouble:Sub2 Y failed ', 3.0, vttd3.Y);
  vttd1.Create(-6.0,-5.0);
  vttd3 := vttd1.Clamp(fs1,fs2);
  AssertEquals('ClampDouble:Sub3 X failed ', -1.0, vttd3.X);
  AssertEquals('ClampDouble:Sub4 Y failed ', -1.0, vttd3.Y);
  vttd1.Create(-6.0,2.0);
  vttd3 := vttd1.Clamp(fs1,fs2);
  AssertEquals('ClampDouble:Sub5 X failed ', -1.0, vttd3.X);
  AssertEquals('ClampDouble:Sub6 Y failed ',  2.0, vttd3.Y);
  vttd1.Create(2.0,-2.0);
  vttd3 := vttd1.Clamp(fs1,fs2);
  AssertEquals('ClampDouble:Sub7 X failed ',  2.0, vttd3.X);
  AssertEquals('ClampDouble:Sub8 Y failed ', -1.0, vttd3.Y);
  vttd1.Create(2.0,4.0);
  vttd3 := vttd1.Clamp(fs1,fs2);
  AssertEquals('ClampDouble:Sub9 X failed ',   2.0, vttd3.X);
  AssertEquals('ClampDouble:Sub10 Y failed ',  3.0, vttd3.Y);
  vttd1.Create(4.0,2.0);
  vttd3 := vttd1.Clamp(fs1,fs2);
  AssertEquals('ClampDouble:Sub11 X failed ',  3.0, vttd3.X);
  AssertEquals('ClampDouble:Sub12 Y failed ',  2.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestMulAdd;
begin
  vttd1.Create(6.0,5.0);
  vttd2.Create(3.0, 3.0);
  vttd4.Create(-1.0,-1.0);
  vttd3 := vttd1.MulAdd(vttd2,vttd4);
  AssertEquals('MulAdd:Sub1 X failed ', 17.0, vttd3.X);
  AssertEquals('MulAdd:Sub2 Y failed ', 14.0, vttd3.Y);
  vttd3 := vttd1.MulAdd(vttd4,vttd2);
  AssertEquals('MulAdd:Sub3 X failed ', -3.0, vttd3.X);
  AssertEquals('MulAdd:Sub4 Y failed ', -2.0, vttd3.Y);
  vttd3 := vttd2.MulAdd(vttd1,vttd4);
  AssertEquals('MulAdd:Sub5 X failed ', 17.0, vttd3.X);
  AssertEquals('MulAdd:Sub6 Y failed ', 14.0, vttd3.Y);
  vttd3 := vttd2.MulAdd(vttd1,-vttd4);
  AssertEquals('MulAdd:Sub7 X failed ', 19.0, vttd3.X);
  AssertEquals('MulAdd:Sub8 Y failed ', 16.0, vttd3.Y);
  vttd3 := vttd2.MulAdd(-vttd1,vttd4);
  AssertEquals('MulAdd:Sub9 X failed ', -19.0, vttd3.X);
  AssertEquals('MulAdd:Sub10 Y failed ', -16.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestMulDiv;
begin
  vttd1.Create(6.0,5.0);
  vttd2.Create(3.0, 3.0);
  vttd4.Create(-2.0,2.0);
  vttd3 := vttd1.MulDiv(vttd2,vttd4);
  AssertEquals('MulDiv:Sub1 X failed ', -9.0, vttd3.X);
  AssertEquals('MulDiv:Sub2 Y failed ',  7.5, vttd3.Y);
  vttd3 := vttd1.MulDiv(vttd4,vttd2);
  AssertEquals('MulDiv:Sub1 X failed ', -4.0, vttd3.X);
  AssertEquals('MulDiv:Sub2 Y failed ',  10 / 3, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestLength;
begin
  vttd1.Create(0.0,6.0);
  fs1 := vttd1.Length;
  AssertEquals('Length:Sub1 X failed ', 6.0, fs1);
  vttd1.Create(0.0,-6.0);
  fs1 := vttd1.Length;
  AssertEquals('Length:Sub2 X failed ', 6.0, fs1);
  vttd1.Create(6.0,0.0);
  fs1 := vttd1.Length;
  AssertEquals('Length:Sub3 X failed ', 6.0, fs1);
  vttd1.Create(-6.0,0.0);
  fs1 := vttd1.Length;
  AssertEquals('Length:Sub4 X failed ', 6.0, fs1);
  vttd1.Create(2.0,2.0);
  fs1 := vttd1.Length;
  AssertEquals('Length:Sub5 X failed ', sqrt(8.0), fs1);
  vttd1.Create(-2.0,-2.0);
  fs1 := vttd1.Length;
  AssertEquals('Length:Sub6 X failed ', sqrt(8.0), fs1);
end;

procedure TVector2dFunctionalTest.TestLengthSquare;
begin
  vttd1.Create(0.0,6.0);
  fs1 := vttd1.LengthSquare;
  AssertEquals('LengthSquare:Sub1 X failed ', 36.0, fs1);
  vttd1.Create(0.0,-6.0);
  fs1 := vttd1.LengthSquare;
  AssertEquals('LengthSquare:Sub2 X failed ', 36.0, fs1);
  vttd1.Create(6.0,0.0);
  fs1 := vttd1.LengthSquare;
  AssertEquals('LengthSquare:Sub3 X failed ', 36.0, fs1);
  vttd1.Create(-6.0,0.0);
  fs1 := vttd1.LengthSquare;
  AssertEquals('LengthSquare:Sub4 X failed ', 36.0, fs1);
  vttd1.Create(2.0,2.0);
  fs1 := vttd1.LengthSquare;
  AssertEquals('LengthSquare:Sub5 X failed ', 8.0, fs1);
  vttd1.Create(-2.0,-2.0);
  fs1 := vttd1.LengthSquare;
  AssertEquals('LengthSquare:Sub6 X failed ', 8.0, fs1);
end;

procedure TVector2dFunctionalTest.TestDistance;
begin
  vttd1.Create(0.0,6.0);
  vttd2.Create(0.0,9.0);
  fs1 := vttd1.Distance(vttd2);
  AssertEquals('Distance:Sub1 X failed ', 3.0, fs1);
  vttd1.Create(0.0,-6.0);
  fs1 := vttd1.Distance(vttd2);
  AssertEquals('Distance:Sub2 X failed ', 15.0, fs1);
  vttd1.Create(6.0,0.0);
  vttd2.Create(9.0,0.0);
  fs1 := vttd1.Distance(vttd2);
  AssertEquals('Distance:Sub3 X failed ', 3.0, fs1);
  vttd1.Create(-6.0,0.0);
  fs1 := vttd1.Distance(vttd2);
  AssertEquals('Distance:Sub4 X failed ', 15.0, fs1);
  vttd1.Create(2.0,2.0);
  vttd2.Create(4.0,4.0);
  fs1 := vttd1.Distance(vttd2);
  AssertEquals('Distance:Sub5 X failed ', sqrt(8.0), fs1);
  vttd1.Create(-2.0,-2.0);
  fs1 := vttd1.Distance(vttd2);
  AssertEquals('Distance:Sub6 X failed ', sqrt(72.0), fs1);
end;

procedure TVector2dFunctionalTest.TestDistanceSquare;
begin
  vttd1.Create(0.0,6.0);
  vttd2.Create(0.0,9.0);
  fs1 := vttd1.DistanceSquare(vttd2);
  AssertEquals('DistanceSquare:Sub1 X failed ', 9.0, fs1);
  vttd1.Create(0.0,-6.0);
  fs1 := vttd1.DistanceSquare(vttd2);
  AssertEquals('DistanceSquare:Sub2 X failed ', 225.0, fs1);
  vttd1.Create(6.0,0.0);
  vttd2.Create(9.0,0.0);
  fs1 := vttd1.DistanceSquare(vttd2);
  AssertEquals('DistanceSquare:Sub3 X failed ', 9.0, fs1);
  vttd1.Create(-6.0,0.0);
  fs1 := vttd1.DistanceSquare(vttd2);
  AssertEquals('DistanceSquare:Sub4 X failed ', 225.0, fs1);
  vttd1.Create(2.0,2.0);
  vttd2.Create(4.0,4.0);
  fs1 := vttd1.DistanceSquare(vttd2);
  AssertEquals('DistanceSquare:Sub5 X failed ', 8.0, fs1);
  vttd1.Create(-2.0,-2.0);
  fs1 := vttd1.DistanceSquare(vttd2);
  AssertEquals('DistanceSquare:Sub6 X failed ', 72.0, fs1);
end;

procedure TVector2dFunctionalTest.TestNormalize;
begin
  vttd1.Create(0.0,6.0);
  vttd3 := vttd1.Normalize;
  AssertEquals('Normalize:Sub1 X failed ', 0.0, vttd3.X);
  AssertEquals('Normalize:Sub2 Y failed ', 1.0, vttd3.Y);
  vttd1.Create(0.0,-6.0);
  vttd3 := vttd1.Normalize;
  AssertEquals('Normalize:Sub3 X failed ',  0.0, vttd3.X);
  AssertEquals('Normalize:Sub4 Y failed ', -1.0, vttd3.Y);
  vttd1.Create(60.0,0.0);
  vttd3 := vttd1.Normalize;
  AssertEquals('Normalize:Sub5 X failed ', 1.0, vttd3.X);
  AssertEquals('Normalize:Sub6 Y failed ', 0.0, vttd3.Y);
  vttd1.Create(-60.0,0.0);
  vttd3 := vttd1.Normalize;
  AssertEquals('Normalize:Sub7 X failed ', -1.0, vttd3.X);
  AssertEquals('Normalize:Sub8 Y failed ',  0.0, vttd3.Y);
  vttd1.Create(6.0,6.0);
  vttd3 := vttd1.Normalize;
  AssertEquals('Normalize:Sub9 X failed ',  1/(sqrt(2)), vttd3.X);
  AssertEquals('Normalize:Sub10 Y failed ', 1/(sqrt(2)), vttd3.Y);
  vttd1.Create(-6.0,6.0);
  vttd3 := vttd1.Normalize;
  AssertEquals('Normalize:Sub9 X failed ', -1/(sqrt(2)), vttd3.X);
  AssertEquals('Normalize:Sub10 Y failed ', 1/(sqrt(2)), vttd3.Y);
  vttd1.Create(6.0,-6.0);
  vttd3 := vttd1.Normalize;
  AssertEquals('Normalize:Sub11 X failed ',  1/(sqrt(2)), vttd3.X);
  AssertEquals('Normalize:Sub12 Y failed ', -1/(sqrt(2)), vttd3.Y);
  vttd1.Create(-6.0,-6.0);
  vttd3 := vttd1.Normalize;
  AssertEquals('Normalize:Sub13 X failed ', -1/(sqrt(2)), vttd3.X);
  AssertEquals('Normalize:Sub14 Y failed ', -1/(sqrt(2)), vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestDotProduct;
begin
  vttd1.Create(1.0,2.0);
  vttd2.Create(3.0,2.0);
  fs1 := vttd1.DotProduct(vttd2);
  AssertEquals('DotProduct:Sub1 failed ',  7.0, fs1);
  vttd1.Create(-1.0,2.0);
  fs1 := vttd1.DotProduct(vttd2);
  AssertEquals('DotProduct:Sub2 failed ',  1.0, fs1);
  vttd1.Create(1.0,-2.0);
  fs1 := vttd1.DotProduct(vttd2);
  AssertEquals('DotProduct:Sub3 failed ', -1.0, fs1);
  vttd1.Create(1.0,2.0);
  vttd2.Create(-3.0,2.0);
  fs1 := vttd1.DotProduct(vttd2);
  AssertEquals('DotProduct:Sub4 failed ',  1.0, fs1);
  vttd2.Create(3.0,-2.0);
  fs1 := vttd1.DotProduct(vttd2);
  AssertEquals('DotProduct:Sub5 failed ', -1.0, fs1);
  vttd2.Create(-3.0,-2.0);
  fs1 := vttd1.DotProduct(vttd2);
  AssertEquals('DotProduct:Sub6 failed ', -7.0, fs1);
  vttd1.Create(-1.0,-2.0);
  fs1 := vttd1.DotProduct(vttd2);
  AssertEquals('DotProduct:Sub7 failed ',  7.0, fs1);
end;

// note returns the smallest angle has no directionality.
procedure TVector2dFunctionalTest.TestAngleBetween;
begin
  vttd1.Create(1.0,0.0);
  vttd2.Create(0.0,1.0);
  fs1 := vttd1.AngleBetween(vttd2,NullVector2d);
  AssertEquals('AngleBetween:Sub1 failed ',  pi/2, fs1);
  vttd1.Create(1.0,1.0);
  fs1 := vttd1.AngleBetween(vttd2,NullVector2d);
  AssertEquals('AngleBetween:Sub2 failed ',  pi/4, fs1);
  vttd1.Create(-1.0,0.0);
  fs1 := vttd2.AngleBetween(vttd1,NullVector2d);
  AssertEquals('AngleBetween:Sub3 failed ',  pi/2, fs1);
  vttd1.Create(-1.0,-1.0);
  fs1 := vttd2.AngleBetween(vttd1,NullVector2d);
  AssertEquals('AngleBetween:Sub4 failed ',  3 * pi/4, fs1);
  vttd1.Create(1.0,-1.0);
  fs1 := vttd2.AngleBetween(vttd1,NullVector2d);
  AssertEquals('AngleBetween:Sub5 failed ',  3 * pi/4, fs1);
  vttd1.Create(0.0,-1.0);
  fs1 := vttd2.AngleBetween(vttd1,NullVector2d);
  AssertEquals('AngleBetween:Sub6 failed ',   pi, fs1);
end;

procedure TVector2dFunctionalTest.TestAngleCosine;
begin
  vttd1.Create(1.0, 1.0);  // ne
  vttd2.Create(1.0,0.0);  // ref east
  fs1 := vttd2.AngleCosine(vttd1);
  AssertEquals('AngleCosine:Sub1 failed ',  1/sqrt(2), fs1);
  vttd1.Create(0.0,1.0);  // n
  fs1 := vttd2.AngleCosine(vttd1);
  AssertEquals('AngleCosine:Sub2 failed ',  0, fs1);
  vttd1.Create(-1.0,1.0);   // nw
  fs1 := vttd2.AngleCosine(vttd1);
  AssertEquals('AngleCosine:Sub3 failed ',  -1/sqrt(2), fs1);
  vttd1.Create(-1.0,0.0);   // w
  fs1 := vttd2.AngleCosine(vttd1);
  AssertEquals('AngleCosine:Sub3 failed ',  -1, fs1);
  vttd1.Create(-1.0,-1.0);   // sw
  fs1 := vttd2.AngleCosine(vttd1);
  AssertEquals('AngleCosine:Sub3 failed ',  -1/sqrt(2), fs1);
  vttd1.Create(0.0,-1.0);   // s
  fs1 := vttd2.AngleCosine(vttd1);
  AssertEquals('AngleCosine:Sub3 failed ',  0, fs1);
  vttd1.Create(1.0,-1.0);   // se
  fs1 := vttd2.AngleCosine(vttd1);
  AssertEquals('AngleCosine:Sub3 failed ',  1/sqrt(2), fs1);
end;

procedure TVector2dFunctionalTest.TestAbs;
begin
  vttd1.Create(-5.69999,6.99998);
  vttd3 := vttd1.Abs;
  AssertEquals('Abs:Sub1 X failed ', 5.69999, vttd3.X);
  AssertEquals('Abs:Sub2 Y failed ', 6.99998, vttd3.Y);
  vttd1.Create(5.69999,-6.99998);
  vttd3 := vttd1.Abs;
  AssertEquals('Abs:Sub3 X failed ', 5.69999, vttd3.X);
  AssertEquals('Abs:Sub4 Y failed ', 6.99998, vttd3.Y);
  vttd1.Create(-5.69999,-6.99998);
  vttd3 := vttd1.Abs;
  AssertEquals('Abs:Sub5 X failed ', 5.69999, vttd3.X);
  AssertEquals('Abs:Sub6 Y failed ', 6.99998, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestTrunc;
begin
  vttd1.Create(5.69999,6.99998);
  vt2i :=  vttd1.Trunc;
  AssertEquals('Trunc:Sub1 X failed ', 5, vt2i.X);
  AssertEquals('Trunc:Sub2 Y failed ', 6, vt2i.Y);
  vttd1.Create(5.369999,6.39998);
  vt2i :=  vttd1.Trunc;
  AssertEquals('Trunc:Sub3 X failed ', 5, vt2i.X);
  AssertEquals('Trunc:Sub4 Y failed ', 6, vt2i.Y);
  vttd1.Create(1.5,2.5);
  vt2i :=  vttd1.Trunc;
  AssertEquals('Trunc:Sub5 X failed ', 1, vt2i.X);
  AssertEquals('Trunc:Sub6 Y failed ', 2, vt2i.Y);
end;

procedure TVector2dFunctionalTest.TestRound;
begin
  vttd1.Create(5.699999,6.699999);
  vt2i :=  vttd1.Round;
  AssertEquals('Round:Sub1 X failed ', 6, vt2i.X);
  AssertEquals('Round:Sub2 Y failed ', 7, vt2i.Y);
  vttd1.Create(5.399999,6.399999);
  vt2i :=  vttd1.Round;
  AssertEquals('Round:Sub3 X failed ', 5, vt2i.X);
  AssertEquals('Round:Sub4 Y failed ', 6, vt2i.Y);
  // rounding to even for 0.5
  vttd1.Create(1.5,2.5);
  vt2i :=  vttd1.Round;
  AssertEquals('Round:Sub3 X failed ', 2, vt2i.X);
  AssertEquals('Round:Sub4 Y failed ', 2, vt2i.Y);
end;

procedure TVector2dFunctionalTest.TestFloor;
begin
  vttd1.Create(5.699999,6.699999);
  vt2i :=  vttd1.Floor;
  AssertEquals('Floor:Sub1 X failed ', 5, vt2i.X);
  AssertEquals('Floor:Sub2 Y failed ', 6, vt2i.Y);
  vttd1.Create(-5.699999,-6.699999);
  vt2i :=  vttd1.Floor;
  AssertEquals('Floor:Sub3 X failed ', -6, vt2i.X);
  AssertEquals('Floor:Sub4 Y failed ', -7, vt2i.Y);
end;

procedure TVector2dFunctionalTest.TestCeil;
begin
  vttd1.Create(5.699999,6.699999);
  vt2i :=  vttd1.Ceil;
  fs1 := Math.Ceil(vttd1.X);
  fs2 := Math.Ceil(vttd1.y);
  AssertEquals('Ceil:Sub1 X failed ', fs1, vt2i.X);
  AssertEquals('Ceil:Sub2 Y failed ', fs2, vt2i.Y);
  vttd1.Create(-5.699999,-6.699999);
  vt2i :=  vttd1.Ceil;
  fs1 := Math.Ceil(vttd1.X);
  fs2 := Math.Ceil(vttd1.y);
  AssertEquals('Ceil:Sub3 X failed ', fs1, vt2i.X);
  AssertEquals('Ceil:Sub4 Y failed ', fs2, vt2i.Y);
end;

procedure TVector2dFunctionalTest.TestFract;
begin
  vttd1.Create(5.699999,6.699999);
  vttd2 :=  vttd1.Fract;
  fs1 := System.frac(vttd1.X);
  fs2 := System.frac(vttd1.y);
  AssertEquals('Fract:Sub1 X failed ', fs1, vttd2.X);
  AssertEquals('Fract:Sub2 Y failed ', fs2, vttd2.Y);
  vttd1.Create(-5.699999,-6.699999);
  vttd2 :=  vttd1.Fract;
  fs1 := System.frac(vttd1.X);
  fs2 := System.frac(vttd1.y);
  AssertEquals('Fract:Sub3 X failed ', fs1, vttd2.X);
  AssertEquals('Fract:Sub4 Y failed ', fs2, vttd2.Y);
end;

procedure TVector2dFunctionalTest.TestSqrt;
begin
  vttd1.Create(4.0,9.0);
  vttd2 :=  vttd1.Sqrt;
  AssertEquals('Sqrt:Sub1 X failed ', 2.0, vttd2.X);
  AssertEquals('Sqrt:Sub2 Y failed ', 3.0, vttd2.Y);
end;

procedure TVector2dFunctionalTest.TestInvSqrt;
begin
  vttd1.Create(4.0,9.0);
  vttd2 :=  vttd1.InvSqrt;
{$ifdef USE_ASM}
  AssertEquals('InvSqrt:Sub1 X failed ', 0.5, vttd2.X, 1e-3);
  AssertEquals('InvSqrt:Sub2 Y failed ', 1/3, vttd2.Y, 1e-3);
{$else}
  AssertEquals('InvSqrt:Sub1 X failed ', 0.5, vttd2.X);
  AssertEquals('InvSqrt:Sub2 Y failed ', 1/3, vttd2.Y);
{$endif}
end;

procedure TVector2dFunctionalTest.TestModF;
begin
  vttd1.Create(4.0,9.0);
  vttd2.Create(2,2);
  vttd3 := vttd1.Modf(vttd2);
  AssertEquals('Modf:Sub1 X failed ', 0.0, vttd3.X);
  AssertEquals('Modf:Sub2 Y failed ', 1.0, vttd3.Y);
end;

procedure TVector2dFunctionalTest.TestfMod;
begin
  vttd1.Create(4.0,9.0);
  vttd2.Create(2,2);
  vt2i := vttd1.fMod(vttd2);
  AssertEquals('fMod:Sub1 X failed : '+vttd1.ToString+'<==>'+vt2i.ToString, 0.0, vt2i.X);
  AssertEquals('fMod:Sub2 Y failed : '+vttd1.ToString+'<==>'+vt2i.ToString, 1.0, vt2i.Y);

  vttd1.Create(2.0,2.0);
  vt2i := vttd1.fMod(vttd2);
  AssertEquals('fMod:Sub3 X failed : '+vttd1.ToString+'<==>'+vt2i.ToString, 0.0, vt2i.X);
  AssertEquals('fMod:Sub4 Y failed : '+vttd1.ToString+'<==>'+vt2i.ToString, 0.0, vt2i.Y);
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR2D, TVector2dFunctionalTest);
end.

