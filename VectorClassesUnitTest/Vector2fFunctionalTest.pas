unit Vector2fFunctionalTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  { TVector2fFunctionalTest }

  TVector2fFunctionalTest = class(TVectorBaseTestCase)
    published
      procedure TestCreate;
      procedure TestOpAdd;
      procedure TestOpSub;
      procedure TestOpDiv;
      procedure TestOpMul;
      procedure TestOpAddSingle;
      procedure TestOpSubSingle;
      procedure TestOpDivSingle;
      procedure TestOpMulSingle;
      procedure TestOpNegate;
      procedure TestEquals;
      procedure TestNotEquals;
      procedure TestMin;
      procedure TestMax;
      procedure TestMinSingle;
      procedure TestMaxSingle;
      procedure TestClamp;
      procedure TestClampSingle;
      procedure TestMulAdd;
      procedure TestMulDiv;
      procedure TestLemgth;
      procedure TestLemgthSquare;
      procedure TestDistance;
      procedure TestDistanceSquare;
      procedure TestNormalize;
      procedure TestDotProduct;
      procedure TestAngleBetween;
      procedure TestAngleCosine;
      procedure TestTrunc;
      procedure TestRound;
  end;

implementation

{ TVector2fFunctionalTest }

procedure TVector2fFunctionalTest.TestCreate;
begin
  vtt1.Create(1.234,2.345);
  AssertEquals('Create:Sub1 X failed ', 1.234, vtt1.X);
  AssertEquals('Create:Sub2 Y failed ', 2.345, vtt1.Y);
end;

procedure TVector2fFunctionalTest.TestOpAdd;
begin
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  vtt3 := vtt1 + vtt2;
  AssertEquals('OpAdd:Sub1 X failed ', 4.0, vtt3.X);
  AssertEquals('OpAdd:Sub2 Y failed ', 4.0, vtt3.Y);
  vtt3 := vtt2 + vtt1;
  AssertEquals('OpAdd:Sub3 X failed ', 4.0, vtt3.X);
  AssertEquals('OpAdd:Sub4 Y failed ', 4.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestOpSub;
begin
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  vtt3 := vtt1 - vtt2;
  AssertEquals('OpSub:Sub1 X failed ', -2.0, vtt3.X);
  AssertEquals('OpSub:Sub2 Y failed ', 0.0, vtt3.Y);
  vtt3 := vtt2 - vtt1;
  AssertEquals('OpSub:Sub3 X failed ', 2.0, vtt3.X);
  AssertEquals('OpSub:Sub4 Y failed ', 0.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestOpDiv;
begin
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  vtt3 := vtt1 / vtt2;
  AssertEquals('OpSub:Sub1 X failed ', 0.33333333333334, vtt3.X);
  AssertEquals('OpSub:Sub2 Y failed ', 1.0, vtt3.Y);
  vtt3 := vtt2 / vtt1;
  AssertEquals('OpSub:Sub3 X failed ', 3.0, vtt3.X);
  AssertEquals('OpSub:Sub4 Y failed ', 1.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestOpMul;
begin
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  vtt3 := vtt1 * vtt2;
  AssertEquals('OpMul:Sub1 X failed ', 3.0, vtt3.X);
  AssertEquals('OpMul:Sub2 Y failed ', 4.0, vtt3.Y);
  vtt3 := vtt2 * vtt1;
  AssertEquals('OpMul:Sub3 X failed ', 3.0, vtt3.X);
  AssertEquals('OpMul:Sub4 Y failed ', 4.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestOpAddSingle;
begin
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  vtt3 := vtt1 + 4.0;
  AssertEquals('OpAddSingle:Sub1 X failed ', 5.0, vtt3.X);
  AssertEquals('OpAddSingle:Sub2 Y failed ', 6.0, vtt3.Y);
  vtt3 := vtt2 + -5;
  AssertEquals('OpAddSingle:Sub3 X failed ', -2.0, vtt3.X);
  AssertEquals('OpAddSingle:Sub4 Y failed ', -3.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestOpSubSingle;
begin
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  vtt3 := vtt1 - 3.0;
  AssertEquals('OpSubSingle:Sub1 X failed ', -2.0, vtt3.X);
  AssertEquals('OpSubSingle:Sub2 Y failed ', -1.0, vtt3.Y);
  vtt3 := vtt2 - -5;
  AssertEquals('OpSubSingle:Sub3 X failed ', 8.0, vtt3.X);
  AssertEquals('OpSubSingle:Sub4 Y failed ', 7.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestOpDivSingle;
begin
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  vtt3 := vtt1 / -0.5;
  AssertEquals('OpDivSingle:Sub1 X failed ', -2.0, vtt3.X);
  AssertEquals('OpDivSingle:Sub2 Y failed ', -4.0, vtt3.Y);
  vtt3 := vtt2 / 0.25;
  AssertEquals('OpDivSingle:Sub3 X failed ', 12.0, vtt3.X);
  AssertEquals('OpDivSingle:Sub4 Y failed ', 8.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestOpMulSingle;
begin
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  vtt3 := vtt1 * -3;
  AssertEquals('OpMulSingle:Sub1 X failed ', -3.0, vtt3.X);
  AssertEquals('OpMulSingle:Sub2 Y failed ', -6.0, vtt3.Y);
  vtt3 := vtt2 * 3;
  AssertEquals('OpMulSingle:Sub3 X failed ', 9.0, vtt3.X);
  AssertEquals('OpMulSingle:Sub4 Y failed ', 6.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestOpNegate;
begin
  vtt1.Create(1.234,2.345);
  vtt2 := -vtt1;
  AssertEquals('Negate:Sub1 X failed ', -1.234, vtt2.X);
  AssertEquals('Negate:Sub2 Y failed ', -2.345, vtt2.Y);
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  vtt3 := -vtt1 + vtt2;
  AssertEquals('Negate:Sub3 X failed ', 2.0, vtt3.X);
  AssertEquals('Negate:Sub4 Y failed ', 0.0, vtt3.Y);
  vtt3 := -(vtt1 + vtt2);
  AssertEquals('Negate:Sub5 X failed ', -4.0, vtt3.X);
  AssertEquals('Negate:Sub6 Y failed ', -4.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestEquals;
begin
  vtt1.Create(1.234,2.345);
  vtt2.Create(1.234,2.345);
  nb := vtt1 = vtt2;
  AssertEquals('Equals:Sub1 failed ', True, nb);
  vtt2.Create(1.234,2.346);
  nb := vtt1 = vtt2;
  AssertEquals('Equals:Sub2 failed ', False, nb);
  vtt2.Create(1.235,2.345);
  nb := vtt1 = vtt2;
  AssertEquals('Equals:Sub3 failed ', False, nb);
end;

procedure TVector2fFunctionalTest.TestNotEquals;
begin
  vtt1.Create(1.234,2.345);
  vtt2.Create(1.234,2.345);
  nb := vtt1 <> vtt2;
  AssertEquals('NotEquals:Sub1 failed ', False, nb);
  vtt2.Create(1.234,2.346);
  nb := vtt1 <> vtt2;
  AssertEquals('NotEquals:Sub2 failed ', True, nb);
  vtt2.Create(1.235,2.345);
  nb := vtt1 <> vtt2;
  AssertEquals('NotEquals:Sub3 failed ', True, nb);
end;

procedure TVector2fFunctionalTest.TestMin;
begin
  vtt1.Create(-2.0,2.0);
  vtt2.Create(-1.0,1.0);
  vtt3 := vtt1.Min(vtt2);
  AssertEquals('Min:Sub1 X failed ', -2.0, vtt3.X);
  AssertEquals('Min:Sub2 Y failed ', 1.0, vtt3.Y);
  vtt3 := vtt2.Min(vtt1);
  AssertEquals('Min:Sub3 X failed ', -2.0, vtt3.X);
  AssertEquals('Min:Sub4 Y failed ', 1.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestMax;
begin
  vtt1.Create(-2.0,2.0);
  vtt2.Create(-1.0,1.0);
  vtt3 := vtt1.Max(vtt2);
  AssertEquals('Max:Sub1 X failed ', -1.0, vtt3.X);
  AssertEquals('Max:Sub2 Y failed ', 2.0, vtt3.Y);
  vtt3 := vtt2.Max(vtt1);
  AssertEquals('Max:Sub3 X failed ', -1.0, vtt3.X);
  AssertEquals('Max:Sub4 Y failed ', 2.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestMinSingle;
begin
  vtt1.Create(-2.0,2.0);
  vtt2.Create(-1.0,1.0);
  vtt3 := vtt1.Min(1.0);
  AssertEquals('MinSingle:Sub1 X failed ', -2.0, vtt3.X);
  AssertEquals('MinSingle:Sub2 Y failed ', 1.0, vtt3.Y);
  vtt3 := vtt2.Min(0.0);
  AssertEquals('MinSingle:Sub3 X failed ', -1.0, vtt3.X);
  AssertEquals('MinSingle:Sub4 Y failed ', 0.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestMaxSingle;
begin
  vtt1.Create(-2.0,2.0);
  vtt2.Create(-1.0,1.0);
  vtt3 := vtt1.Max(1.0);
  AssertEquals('MaxSingle:Sub1 X failed ', 1.0, vtt3.X);
  AssertEquals('MaxSingle:Sub2 Y failed ', 2.0, vtt3.Y);
  vtt3 := vtt2.Max(0.0);
  AssertEquals('MaxSingle:Sub3 X failed ', 0.0, vtt3.X);
  AssertEquals('MaxSingle:Sub4 Y failed ', 1.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestClamp;
begin
  vtt1.Create(6.0,5.0);
  vtt2.Create(3.0, 3.0);
  vtt4.Create(-1.0,-1.0);
  vtt3 := vtt1.Clamp(vtt4,vtt2);
  AssertEquals('Clamp:Sub1 X failed ', 3.0, vtt3.X);
  AssertEquals('Clamp:Sub2 Y failed ', 3.0, vtt3.Y);
  vtt1.Create(-6.0,-5.0);
  vtt3 := vtt1.Clamp(vtt4,vtt2);
  AssertEquals('Clamp:Sub3 X failed ', -1.0, vtt3.X);
  AssertEquals('Clamp:Sub4 Y failed ', -1.0, vtt3.Y);
  vtt1.Create(-6.0,2.0);
  vtt3 := vtt1.Clamp(vtt4,vtt2);
  AssertEquals('Clamp:Sub5 X failed ', -1.0, vtt3.X);
  AssertEquals('Clamp:Sub6 Y failed ',  2.0, vtt3.Y);
  vtt1.Create(2.0,-2.0);
  vtt3 := vtt1.Clamp(vtt4,vtt2);
  AssertEquals('Clamp:Sub7 X failed ',  2.0, vtt3.X);
  AssertEquals('Clamp:Sub8 Y failed ', -1.0, vtt3.Y);
  vtt1.Create(2.0,4.0);
  vtt3 := vtt1.Clamp(vtt4,vtt2);
  AssertEquals('Clamp:Sub9 X failed ',   2.0, vtt3.X);
  AssertEquals('Clamp:Sub10 Y failed ',  3.0, vtt3.Y);
  vtt1.Create(4.0,2.0);
  vtt3 := vtt1.Clamp(vtt4,vtt2);
  AssertEquals('Clamp:Sub11 X failed ',  3.0, vtt3.X);
  AssertEquals('Clamp:Sub12 Y failed ',  2.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestClampSingle;
begin
  vtt1.Create(6.0, 5.0);
  fs1 := -1.0;
  fs2 := 3.0;
  vtt3 := vtt1.Clamp(fs1,fs2);
  AssertEquals('ClampSingle:Sub1 X failed ', 3.0, vtt3.X);
  AssertEquals('ClampSingle:Sub2 Y failed ', 3.0, vtt3.Y);
  vtt1.Create(-6.0,-5.0);
  vtt3 := vtt1.Clamp(fs1,fs2);
  AssertEquals('ClampSingle:Sub3 X failed ', -1.0, vtt3.X);
  AssertEquals('ClampSingle:Sub4 Y failed ', -1.0, vtt3.Y);
  vtt1.Create(-6.0,2.0);
  vtt3 := vtt1.Clamp(fs1,fs2);
  AssertEquals('ClampSingle:Sub5 X failed ', -1.0, vtt3.X);
  AssertEquals('ClampSingle:Sub6 Y failed ',  2.0, vtt3.Y);
  vtt1.Create(2.0,-2.0);
  vtt3 := vtt1.Clamp(fs1,fs2);
  AssertEquals('ClampSingle:Sub7 X failed ',  2.0, vtt3.X);
  AssertEquals('ClampSingle:Sub8 Y failed ', -1.0, vtt3.Y);
  vtt1.Create(2.0,4.0);
  vtt3 := vtt1.Clamp(fs1,fs2);
  AssertEquals('ClampSingle:Sub9 X failed ',   2.0, vtt3.X);
  AssertEquals('ClampSingle:Sub10 Y failed ',  3.0, vtt3.Y);
  vtt1.Create(4.0,2.0);
  vtt3 := vtt1.Clamp(fs1,fs2);
  AssertEquals('ClampSingle:Sub11 X failed ',  3.0, vtt3.X);
  AssertEquals('ClampSingle:Sub12 Y failed ',  2.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestMulAdd;
begin
  vtt1.Create(6.0,5.0);
  vtt2.Create(3.0, 3.0);
  vtt4.Create(-1.0,-1.0);
  vtt3 := vtt1.MulAdd(vtt2,vtt4);
  AssertEquals('MulAdd:Sub1 X failed ', 17.0, vtt3.X);
  AssertEquals('MulAdd:Sub2 Y failed ', 14.0, vtt3.Y);
  vtt3 := vtt1.MulAdd(vtt4,vtt2);
  AssertEquals('MulAdd:Sub3 X failed ', -3.0, vtt3.X);
  AssertEquals('MulAdd:Sub4 Y failed ', -2.0, vtt3.Y);
  vtt3 := vtt2.MulAdd(vtt1,vtt4);
  AssertEquals('MulAdd:Sub5 X failed ', 17.0, vtt3.X);
  AssertEquals('MulAdd:Sub6 Y failed ', 14.0, vtt3.Y);
  vtt3 := vtt2.MulAdd(vtt1,-vtt4);
  AssertEquals('MulAdd:Sub7 X failed ', 19.0, vtt3.X);
  AssertEquals('MulAdd:Sub8 Y failed ', 16.0, vtt3.Y);
  vtt3 := vtt2.MulAdd(-vtt1,vtt4);
  AssertEquals('MulAdd:Sub9 X failed ', -19.0, vtt3.X);
  AssertEquals('MulAdd:Sub10 Y failed ', -16.0, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestMulDiv;
begin
  vtt1.Create(6.0,5.0);
  vtt2.Create(3.0, 3.0);
  vtt4.Create(-2.0,2.0);
  vtt3 := vtt1.MulDiv(vtt2,vtt4);
  AssertEquals('MulDiv:Sub1 X failed ', -9.0, vtt3.X);
  AssertEquals('MulDiv:Sub2 Y failed ',  7.5, vtt3.Y);
  vtt3 := vtt1.MulDiv(vtt4,vtt2);
  AssertEquals('MulDiv:Sub1 X failed ', -4.0, vtt3.X);
  AssertEquals('MulDiv:Sub2 Y failed ',  10 / 3, vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestLemgth;
begin
  vtt1.Create(0.0,6.0);
  fs1 := vtt1.Length;
  AssertEquals('Length:Sub1 X failed ', 6.0, fs1);
  vtt1.Create(0.0,-6.0);
  fs1 := vtt1.Length;
  AssertEquals('Length:Sub2 X failed ', 6.0, fs1);
  vtt1.Create(6.0,0.0);
  fs1 := vtt1.Length;
  AssertEquals('Length:Sub3 X failed ', 6.0, fs1);
  vtt1.Create(-6.0,0.0);
  fs1 := vtt1.Length;
  AssertEquals('Length:Sub4 X failed ', 6.0, fs1);
  vtt1.Create(2.0,2.0);
  fs1 := vtt1.Length;
  AssertEquals('Length:Sub5 X failed ', sqrt(8.0), fs1);
  vtt1.Create(-2.0,-2.0);
  fs1 := vtt1.Length;
  AssertEquals('Length:Sub6 X failed ', sqrt(8.0), fs1);
end;

procedure TVector2fFunctionalTest.TestLemgthSquare;
begin
  vtt1.Create(0.0,6.0);
  fs1 := vtt1.LengthSquare;
  AssertEquals('LengthSquare:Sub1 X failed ', 36.0, fs1);
  vtt1.Create(0.0,-6.0);
  fs1 := vtt1.LengthSquare;
  AssertEquals('LengthSquare:Sub2 X failed ', 36.0, fs1);
  vtt1.Create(6.0,0.0);
  fs1 := vtt1.LengthSquare;
  AssertEquals('LengthSquare:Sub3 X failed ', 36.0, fs1);
  vtt1.Create(-6.0,0.0);
  fs1 := vtt1.LengthSquare;
  AssertEquals('LengthSquare:Sub4 X failed ', 36.0, fs1);
  vtt1.Create(2.0,2.0);
  fs1 := vtt1.LengthSquare;
  AssertEquals('LengthSquare:Sub5 X failed ', 8.0, fs1);
  vtt1.Create(-2.0,-2.0);
  fs1 := vtt1.LengthSquare;
  AssertEquals('LengthSquare:Sub6 X failed ', 8.0, fs1);
end;

procedure TVector2fFunctionalTest.TestDistance;
begin
  vtt1.Create(0.0,6.0);
  vtt2.Create(0.0,9.0);
  fs1 := vtt1.Distance(vtt2);
  AssertEquals('Distance:Sub1 X failed ', 3.0, fs1);
  vtt1.Create(0.0,-6.0);
  fs1 := vtt1.Distance(vtt2);
  AssertEquals('Distance:Sub2 X failed ', 15.0, fs1);
  vtt1.Create(6.0,0.0);
  vtt2.Create(9.0,0.0);
  fs1 := vtt1.Distance(vtt2);
  AssertEquals('Distance:Sub3 X failed ', 3.0, fs1);
  vtt1.Create(-6.0,0.0);
  fs1 := vtt1.Distance(vtt2);
  AssertEquals('Distance:Sub4 X failed ', 15.0, fs1);
  vtt1.Create(2.0,2.0);
  vtt2.Create(4.0,4.0);
  fs1 := vtt1.Distance(vtt2);
  AssertEquals('Distance:Sub5 X failed ', sqrt(8.0), fs1);
  vtt1.Create(-2.0,-2.0);
  fs1 := vtt1.Distance(vtt2);
  AssertEquals('Distance:Sub6 X failed ', sqrt(72.0), fs1);
end;

procedure TVector2fFunctionalTest.TestDistanceSquare;
begin
  vtt1.Create(0.0,6.0);
  vtt2.Create(0.0,9.0);
  fs1 := vtt1.DistanceSquare(vtt2);
  AssertEquals('DistanceSquare:Sub1 X failed ', 9.0, fs1);
  vtt1.Create(0.0,-6.0);
  fs1 := vtt1.DistanceSquare(vtt2);
  AssertEquals('DistanceSquare:Sub2 X failed ', 225.0, fs1);
  vtt1.Create(6.0,0.0);
  vtt2.Create(9.0,0.0);
  fs1 := vtt1.DistanceSquare(vtt2);
  AssertEquals('DistanceSquare:Sub3 X failed ', 9.0, fs1);
  vtt1.Create(-6.0,0.0);
  fs1 := vtt1.DistanceSquare(vtt2);
  AssertEquals('DistanceSquare:Sub4 X failed ', 225.0, fs1);
  vtt1.Create(2.0,2.0);
  vtt2.Create(4.0,4.0);
  fs1 := vtt1.DistanceSquare(vtt2);
  AssertEquals('DistanceSquare:Sub5 X failed ', 8.0, fs1);
  vtt1.Create(-2.0,-2.0);
  fs1 := vtt1.DistanceSquare(vtt2);
  AssertEquals('DistanceSquare:Sub6 X failed ', 72.0, fs1);
end;

procedure TVector2fFunctionalTest.TestNormalize;
begin
  vtt1.Create(0.0,6.0);
  vtt3 := vtt1.Normalize;
  AssertEquals('Normalize:Sub1 X failed ', 0.0, vtt3.X);
  AssertEquals('Normalize:Sub2 Y failed ', 1.0, vtt3.Y);
  vtt1.Create(0.0,-6.0);
  vtt3 := vtt1.Normalize;
  AssertEquals('Normalize:Sub3 X failed ',  0.0, vtt3.X);
  AssertEquals('Normalize:Sub4 Y failed ', -1.0, vtt3.Y);
  vtt1.Create(60.0,0.0);
  vtt3 := vtt1.Normalize;
  AssertEquals('Normalize:Sub5 X failed ', 1.0, vtt3.X);
  AssertEquals('Normalize:Sub6 Y failed ', 0.0, vtt3.Y);
  vtt1.Create(-60.0,0.0);
  vtt3 := vtt1.Normalize;
  AssertEquals('Normalize:Sub7 X failed ', -1.0, vtt3.X);
  AssertEquals('Normalize:Sub8 Y failed ',  0.0, vtt3.Y);
  vtt1.Create(6.0,6.0);
  vtt3 := vtt1.Normalize;
  AssertEquals('Normalize:Sub9 X failed ',  1/(sqrt(2)), vtt3.X);
  AssertEquals('Normalize:Sub10 Y failed ', 1/(sqrt(2)), vtt3.Y);
  vtt1.Create(-6.0,6.0);
  vtt3 := vtt1.Normalize;
  AssertEquals('Normalize:Sub9 X failed ', -1/(sqrt(2)), vtt3.X);
  AssertEquals('Normalize:Sub10 Y failed ', 1/(sqrt(2)), vtt3.Y);
  vtt1.Create(6.0,-6.0);
  vtt3 := vtt1.Normalize;
  AssertEquals('Normalize:Sub11 X failed ',  1/(sqrt(2)), vtt3.X);
  AssertEquals('Normalize:Sub12 Y failed ', -1/(sqrt(2)), vtt3.Y);
  vtt1.Create(-6.0,-6.0);
  vtt3 := vtt1.Normalize;
  AssertEquals('Normalize:Sub13 X failed ', -1/(sqrt(2)), vtt3.X);
  AssertEquals('Normalize:Sub14 Y failed ', -1/(sqrt(2)), vtt3.Y);
end;

procedure TVector2fFunctionalTest.TestDotProduct;
begin
  vtt1.Create(1.0,2.0);
  vtt2.Create(3.0,2.0);
  fs1 := vtt1.DotProduct(vtt2);
  AssertEquals('DotProduct:Sub1 failed ',  7.0, fs1);
  vtt1.Create(-1.0,2.0);
  fs1 := vtt1.DotProduct(vtt2);
  AssertEquals('DotProduct:Sub2 failed ',  1.0, fs1);
  vtt1.Create(1.0,-2.0);
  fs1 := vtt1.DotProduct(vtt2);
  AssertEquals('DotProduct:Sub3 failed ', -1.0, fs1);
  vtt1.Create(1.0,2.0);
  vtt2.Create(-3.0,2.0);
  fs1 := vtt1.DotProduct(vtt2);
  AssertEquals('DotProduct:Sub4 failed ',  1.0, fs1);
  vtt2.Create(3.0,-2.0);
  fs1 := vtt1.DotProduct(vtt2);
  AssertEquals('DotProduct:Sub5 failed ', -1.0, fs1);
  vtt2.Create(-3.0,-2.0);
  fs1 := vtt1.DotProduct(vtt2);
  AssertEquals('DotProduct:Sub6 failed ', -7.0, fs1);
  vtt1.Create(-1.0,-2.0);
  fs1 := vtt1.DotProduct(vtt2);
  AssertEquals('DotProduct:Sub7 failed ',  7.0, fs1);
end;

// note returns the smallest angle has no directionality.
procedure TVector2fFunctionalTest.TestAngleBetween;
begin
  vtt1.Create(1.0,0.0);
  vtt2.Create(0.0,1.0);
  fs1 := vtt1.AngleBetween(vtt2,NullVector2f);
  AssertEquals('AngleBetween:Sub1 failed ',  pi/2, fs1);
  vtt1.Create(1.0,1.0);
  fs1 := vtt1.AngleBetween(vtt2,NullVector2f);
  AssertEquals('AngleBetween:Sub2 failed ',  pi/4, fs1);
  vtt1.Create(-1.0,0.0);
  fs1 := vtt2.AngleBetween(vtt1,NullVector2f);
  AssertEquals('AngleBetween:Sub3 failed ',  pi/2, fs1);
  vtt1.Create(-1.0,-1.0);
  fs1 := vtt2.AngleBetween(vtt1,NullVector2f);
  AssertEquals('AngleBetween:Sub4 failed ',  3 * pi/4, fs1);
  vtt1.Create(1.0,-1.0);
  fs1 := vtt2.AngleBetween(vtt1,NullVector2f);
  AssertEquals('AngleBetween:Sub5 failed ',  3 * pi/4, fs1);
  vtt1.Create(0.0,-1.0);
  fs1 := vtt2.AngleBetween(vtt1,NullVector2f);
  AssertEquals('AngleBetween:Sub6 failed ',   pi, fs1);
end;

procedure TVector2fFunctionalTest.TestAngleCosine;
begin
  vtt1.Create(1.0, 1.0);  // ne
  vtt2.Create(1.0,0.0);  // ref east
  fs1 := vtt2.AngleCosine(vtt1);
  AssertEquals('AngleCosine:Sub1 failed ',  1/sqrt(2), fs1);
  vtt1.Create(0.0,1.0);  // n
  fs1 := vtt2.AngleCosine(vtt1);
  AssertEquals('AngleCosine:Sub2 failed ',  0, fs1);
  vtt1.Create(-1.0,1.0);   // nw
  fs1 := vtt2.AngleCosine(vtt1);
  AssertEquals('AngleCosine:Sub3 failed ',  -1/sqrt(2), fs1);
  vtt1.Create(-1.0,0.0);   // w
  fs1 := vtt2.AngleCosine(vtt1);
  AssertEquals('AngleCosine:Sub3 failed ',  -1, fs1);
  vtt1.Create(-1.0,-1.0);   // sw
  fs1 := vtt2.AngleCosine(vtt1);
  AssertEquals('AngleCosine:Sub3 failed ',  -1/sqrt(2), fs1);
  vtt1.Create(0.0,-1.0);   // s
  fs1 := vtt2.AngleCosine(vtt1);
  AssertEquals('AngleCosine:Sub3 failed ',  0, fs1);
  vtt1.Create(1.0,-1.0);   // se
  fs1 := vtt2.AngleCosine(vtt1);
  AssertEquals('AngleCosine:Sub3 failed ',  1/sqrt(2), fs1);
end;

procedure TVector2fFunctionalTest.TestTrunc;
begin
  vtt1.Create(5.69999,6.99998);
  vt2i :=  vtt1.Trunc;
  AssertEquals('Trunc:Sub1 X failed ', 5, vt2i.X);
  AssertEquals('Trunc:Sub2 Y failed ', 6, vt2i.Y);
  vtt1.Create(5.369999,6.39998);
  vt2i :=  vtt1.Trunc;
  AssertEquals('Trunc:Sub3 X failed ', 5, vt2i.X);
  AssertEquals('Trunc:Sub4 Y failed ', 6, vt2i.Y);
  vtt1.Create(1.5,2.5);
  vt2i :=  vtt1.Trunc;
  AssertEquals('Trunc:Sub5 X failed ', 1, vt2i.X);
  AssertEquals('Trunc:Sub6 Y failed ', 2, vt2i.Y);
end;

procedure TVector2fFunctionalTest.TestRound;
begin
  vtt1.Create(5.699999,6.699999);
  vt2i :=  vtt1.Round;
  AssertEquals('Round:Sub1 X failed ', 6, vt2i.X);
  AssertEquals('Round:Sub2 Y failed ', 7, vt2i.Y);
  vtt1.Create(5.399999,6.399999);
  vt2i :=  vtt1.Round;
  AssertEquals('Round:Sub3 X failed ', 5, vt2i.X);
  AssertEquals('Round:Sub4 Y failed ', 6, vt2i.Y);
  // rounding to even for 0.5
  vtt1.Create(1.5,2.5);
  vt2i :=  vtt1.Round;
  AssertEquals('Round:Sub3 X failed ', 2, vt2i.X);
  AssertEquals('Round:Sub4 Y failed ', 2, vt2i.Y);
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR2F, TVector2fFunctionalTest);
end.

