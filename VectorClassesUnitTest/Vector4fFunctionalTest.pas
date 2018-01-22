unit Vector4fFunctionalTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;


const
  // some standard ortho and diagonal Vectors in anticlockwise order from east
  c0DegVec :   TGLZVector4f = (X:1; Y:0; Z:0; W:0);       // cos 1                      0
  c45DegVec :  TGLZVector4f = (X:1; Y:1; Z:0; W:0);       //  0.707106781187            0.7853981634
  c90DegVec :  TGLZVector4f = (X:0; Y:1; Z:0; W:0);       //  0                         1.570796
  c135DegVec : TGLZVector4f = (X:-1; Y:1; Z:0; W:0);      // -0.707106781187            2.3561945
  c180DegVec : TGLZVector4f = (X:-1; Y:0; Z:0; W:0);      // -1                         3.14159265
  c225DegVec : TGLZVector4f = (X:-1; Y:-1; Z:0; W:0);     // -0.707106781187            3.92699
  c270DegVec : TGLZVector4f = (X:0; Y:-1; Z:0; W:0);      // -0  //this can happen      4.71238898
  c315DegVec : TGLZVector4f = (X:1; Y:-1; Z:0; W:0);      //  0.707106781187            5.497787

type

  TVector4fFunctionalTest = class(TVectorBaseTestCase)
    published
      procedure TestCreateSingle;
      procedure TestCreate3f;
      procedure TestOpNegate;     // out of order as we use it in tests below
      procedure TestOpAdd;
      procedure TestOpAddSingle;
      procedure TestOpSub;
      procedure TestOpSubSingle;
      procedure TestOpMul;
      procedure TestOpMulSingle;
      procedure TestOpDiv;
      procedure TestOpDivSingle;
      procedure TestOpEquals;
      procedure TestOpNotEquals;
      procedure TestOpGTE;
      procedure TestOpLTE;
      procedure TestOpGT;
      procedure TestOpLT;
      procedure TestShuffle;
      procedure TestSwizzle;
      procedure TestMinXYZ;
      procedure TestMaxXYZ;
      procedure TestAbs;
      procedure TestNegate;
      procedure TestDivide2;
      procedure TestLength;
      procedure TestLengthSquare;
      procedure TestDistance;
      procedure TestDistanceSquare;
      procedure TestSpacing;
      procedure TestDotProduct;
      procedure TestCrossProduct;
      procedure TestNormalize;
      procedure TestNorm;
      procedure TestMin;
      procedure TestMinSingle;
      procedure TestMax;
      procedure TestMaxSingle;
      procedure TestClamp;
      procedure TestClampSingle;
      procedure TestMulAdd;
      procedure TestMulDiv;
      procedure TestLerp;
      procedure TestAngleCosine;
      procedure TestAngleBetween;
      procedure TestCombine;
      procedure TestCombine2;
      procedure TestCombine3;
      procedure TestRound;
      procedure TestTrunc;
  end;

implementation

procedure TVector4fFunctionalTest.TestCreateSingle;
begin
  vt1.Create(10.0,20.0,30.0);
  AssertEquals('CreateSingle:Sub1 X failed ', 10.0, vt1.X);
  AssertEquals('CreateSingle:Sub2 Y failed ', 20.0, vt1.Y);
  AssertEquals('CreateSingle:Sub3 Z failed ', 30.0, vt1.Z);
  AssertEquals('CreateSingle:Sub4 W failed ',  0.0, vt1.W);
  // Accessors
  AssertEquals('CreateSingle:Sub5 V[0] failed ',  10.0, vt1.V[0]);
  AssertEquals('CreateSingle:Sub6 V[1] failed ',  20.0, vt1.V[1]);
  AssertEquals('CreateSingle:Sub7 V[2] failed ',  30.0, vt1.V[2]);
  AssertEquals('CreateSingle:Sub8 V[3] failed ',   0.0, vt1.V[3]);
  AssertEquals('CreateSingle:Sub9 Red   failed ', 10.0, vt1.Red);
  AssertEquals('CreateSingle:Sub10 Green failed ',  20.0, vt1.Green);
  AssertEquals('CreateSingle:Sub11 Blue  failed ',  30.0, vt1.Blue);
  AssertEquals('CreateSingle:Sub12 Alhpa failed ',   0.0, vt1.Alpha);
  AssertEquals('CreateSingle:Sub13 ST.X failed ', 10.0, vt1.ST.X);
  AssertEquals('CreateSingle:Sub14 ST.Y failed ', 20.0, vt1.ST.Y);
  AssertEquals('CreateSingle:Sub15 UV.X failed ', 30.0, vt1.UV.X);
  AssertEquals('CreateSingle:Sub16 UV.Y failed ',  0.0, vt1.UV.Y);
  AssertEquals('CreateSingle:Sub17 Left   failed ', 10.0, vt1.Left);
  AssertEquals('CreateSingle:Sub18 Top    failed ', 20.0, vt1.Top);
  AssertEquals('CreateSingle:Sub19 Right  failed ', 30.0, vt1.Right);
  AssertEquals('CreateSingle:Sub20 Bottom failed ',  0.0, vt1.Bottom);
  AssertEquals('CreateSingle:Sub21 TopLeft.X     failed ', 10.0, vt1.TopLeft.X);
  AssertEquals('CreateSingle:Sub22 TopLect.Y     failed ', 20.0, vt1.TopLeft.Y);
  AssertEquals('CreateSingle:Sub23 BottomRight.X failed ', 30.0, vt1.BottomRight.X);
  AssertEquals('CreateSingle:Sub24 BottomRight.Y failed ',  0.0, vt1.BottomRight.Y);
  AssertEquals('CreateSingle:Sub25 As3f.X failed ', 10.0, vt1.AsVector3f.X);
  AssertEquals('CreateSingle:Sub26 As3f.Y failed ', 20.0, vt1.AsVector3f.Y);
  AssertEquals('CreateSingle:Sub27 As3f.Z failed ', 30.0, vt1.AsVector3f.Z);
  vt1.Create(10.0, 20.0, 30.0, 1);
  AssertEquals('CreateInt:Sub28 X failed ', 10.0, vt1.X);
  AssertEquals('CreateInt:Sub29 Y failed ', 20.0, vt1.Y);
  AssertEquals('CreateInt:Sub30 Z failed ', 30.0, vt1.Z);
  AssertEquals('CreateInt:Sub31 W failed ',  1.0, vt1.W);
end;

procedure TVector4fFunctionalTest.TestCreate3f;
var temp: TGLZVector3f;
begin
  vt1.Create(10.0,20.0,30.0);
  temp := vt1.AsVector3f;
  vt4.Create(temp);
  AssertEquals('Create3f:Sub1 X failed ', 10.0, vt4.X);
  AssertEquals('Create3f:Sub2 Y failed ', 20.0, vt4.Y);
  AssertEquals('Create3f:Sub3 Z failed ', 30.0, vt4.Z);
  AssertEquals('Create3f:Sub4 W failed ',  1.0, vt4.W);
  vt4.Create(vt1.AsVector3f);
  AssertEquals('Create3f:Sub5 X failed ', 10.0, vt4.X);
  AssertEquals('Create3f:Sub6 Y failed ', 20.0, vt4.Y);
  AssertEquals('Create3f:Sub7 Z failed ', 30.0, vt4.Z);
  AssertEquals('Create3f:Sub8 W failed ',  1.0, vt4.W);
  vt4.Create(vt1.AsVector3f, 0);
  AssertEquals('Create3f:Sub9 X failed ',  10.0, vt4.X);
  AssertEquals('Create3f:Sub10 Y failed ', 20.0, vt4.Y);
  AssertEquals('Create3f:Sub11 Z failed ', 30.0, vt4.Z);
  AssertEquals('Create3f:Sub12 W failed ',  0.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestOpNegate;
var a: TGLZVector4f;
begin
  vt1.Create(10.0, 20.0, 30.0, 1);
  vt4 := -vt1;
  AssertEquals('Negate:Sub1 X failed ', -10.0, vt4.X);
  AssertEquals('Negate:Sub2 Y failed ', -20.0, vt4.Y);
  AssertEquals('Negate:Sub3 Z failed ', -30.0, vt4.Z);
  AssertEquals('Negate:Sub4 W failed ',  -1.0, vt4.W);
  a.Create(10.0, 20.0, 30.0, 1);
  vt4 := -a;
  AssertEquals('Negate:Sub1 X failed ', -10.0, vt4.X);
  AssertEquals('Negate:Sub2 Y failed ', -20.0, vt4.Y);
  AssertEquals('Negate:Sub3 Z failed ', -30.0, vt4.Z);
  AssertEquals('Negate:Sub4 W failed ',  -1.0, vt4.W);

end;

procedure TVector4fFunctionalTest.TestOpAdd;
begin
  vt1.Create(10.0, 20.0, 30.0, 1);
  vt2.Create(10.0, 20.0, 30.0, 0);
  vt4 := vt1 + vt2;
  AssertEquals('OpAdd:Sub1 X failed ', 20.0, vt4.X);
  AssertEquals('OpAdd:Sub2 Y failed ', 40.0, vt4.Y);
  AssertEquals('OpAdd:Sub3 Z failed ', 60.0, vt4.Z);
  AssertEquals('OpAdd:Sub4 W failed ',  1.0, vt4.W);
  vt4 := vt1 + vt1;
  AssertEquals('OpAdd:Sub5 X failed ', 20.0, vt4.X);
  AssertEquals('OpAdd:Sub6 Y failed ', 40.0, vt4.Y);
  AssertEquals('OpAdd:Sub7 Z failed ', 60.0, vt4.Z);
  AssertEquals('OpAdd:Sub8 W failed ',  2.0, vt4.W);
  vt4 := vt2 + vt2;
  AssertEquals('OpAdd:Sub9 X failed ',  20.0, vt4.X);
  AssertEquals('OpAdd:Sub10 Y failed ', 40.0, vt4.Y);
  AssertEquals('OpAdd:Sub11 Z failed ', 60.0, vt4.Z);
  AssertEquals('OpAdd:Sub12 W failed ',  0.0, vt4.W);
  vt4 := -vt1 + vt2;
  AssertEquals('OpAdd:Sub13 X failed ',  0.0, vt4.X);
  AssertEquals('OpAdd:Sub14 Y failed ',  0.0, vt4.Y);
  AssertEquals('OpAdd:Sub15 Z failed ',  0.0, vt4.Z);
  AssertEquals('OpAdd:Sub16 W failed ', -1.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestOpAddSingle;
begin
  vt1.Create(10.0, 20.0, 30.0, 1);
  vt4 := vt1 + 5.0;
  AssertEquals('OpAddSingle:Sub1 X failed ', 15.0, vt4.X);
  AssertEquals('OpAddSingle:Sub2 Y failed ', 25.0, vt4.Y);
  AssertEquals('OpAddSingle:Sub3 Z failed ', 35.0, vt4.Z);
  AssertEquals('OpAddSingle:Sub4 W failed ',  6.0, vt4.W);
  vt4 := -vt1 + 5.0;
  AssertEquals('OpAddSingle:Sub1 X failed ',  -5.0, vt4.X);
  AssertEquals('OpAddSingle:Sub2 Y failed ', -15.0, vt4.Y);
  AssertEquals('OpAddSingle:Sub3 Z failed ', -25.0, vt4.Z);
  AssertEquals('OpAddSingle:Sub4 W failed ',   4.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestOpSub;
begin
  vt1.Create(100.0, 200.0, 300.0, 1);
  vt2.Create(10.0, 20.0, 30.0, 0);
  vt4 := vt1 - vt2;
  AssertEquals('OpSub:Sub1 X failed ',  90.0, vt4.X);
  AssertEquals('OpSub:Sub2 Y failed ', 180.0, vt4.Y);
  AssertEquals('OpSub:Sub3 Z failed ', 270.0, vt4.Z);
  AssertEquals('OpSub:Sub4 W failed ',   1.0, vt4.W);
  vt4 := vt2 - vt1;
  AssertEquals('OpSub:Sub5 X failed ',  -90.0, vt4.X);
  AssertEquals('OpSub:Sub6 Y failed ', -180.0, vt4.Y);
  AssertEquals('OpSub:Sub7 Z failed ', -270.0, vt4.Z);
  AssertEquals('OpSub:Sub8 W failed ',   -1.0, vt4.W);
  vt4 := -vt1 - vt2;
  AssertEquals('OpSub:Sub9 X failed ',  -110.0, vt4.X);
  AssertEquals('OpSub:Sub10 Y failed ', -220.0, vt4.Y);
  AssertEquals('OpSub:Sub11 Z failed ', -330.0, vt4.Z);
  AssertEquals('OpSub:Sub12 W failed ',   -1.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestOpSubSingle;
begin
  vt1.Create(100.0, 200.0, 300.0, 1);
  vt4 := vt1 - 30.0;
  AssertEquals('OpSubSingle:Sub1 X failed ',  70.0, vt4.X);
  AssertEquals('OpSubSingle:Sub2 Y failed ', 170.0, vt4.Y);
  AssertEquals('OpSubSingle:Sub3 Z failed ', 270.0, vt4.Z);
  AssertEquals('OpSubSingle:Sub4 W failed ', -29.0, vt4.W);
  vt4 := -vt1 - 30.0;
  AssertEquals('OpSubSingle:Sub5 X failed ', -130.0, vt4.X);
  AssertEquals('OpSubSingle:Sub6 Y failed ', -230.0, vt4.Y);
  AssertEquals('OpSubSingle:Sub7 Z failed ', -330.0, vt4.Z);
  AssertEquals('OpSubSingle:Sub8 W failed ',  -31.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestOpMul;
begin
  vt1.Create(100.0, 200.0, 300.0, 1);
  vt2.Create(0.8, 0.6, 0.3, 1);
  vt4 := vt1 * vt2;
  AssertEquals('OpMul:Sub1 X failed ',  80.0, vt4.X);
  AssertEquals('OpMul:Sub2 Y failed ', 120.0, vt4.Y);
  AssertEquals('OpMul:Sub3 Z failed ',  90.0, vt4.Z);
  AssertEquals('OpMul:Sub4 W failed ',   1.0, vt4.W);
  vt4 := -vt1 * vt2;
  AssertEquals('OpMul:Sub5 X failed ',  -80.0, vt4.X);
  AssertEquals('OpMul:Sub6 Y failed ', -120.0, vt4.Y);
  AssertEquals('OpMul:Sub7 Z failed ',  -90.0, vt4.Z);
  AssertEquals('OpMul:Sub8 W failed ',   -1.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestOpMulSingle;
begin
  vt1.Create(100.0, 200.0, 300.0, 1);
  vt4 := vt1 * 1.5;
  AssertEquals('OpMulSingle:Sub1 X failed ', 150.0, vt4.X);
  AssertEquals('OpMulSingle:Sub2 Y failed ', 300.0, vt4.Y);
  AssertEquals('OpMulSingle:Sub3 Z failed ', 450.0, vt4.Z);
  AssertEquals('OpMulSingle:Sub4 W failed ',   1.5, vt4.W);
end;

procedure TVector4fFunctionalTest.TestOpDiv;
begin
  vt1.Create(2.0, 3.0, 4.0, 5.0);
  vt2.Create(2.0, 2.0, 2.0, 2.0);
  vt4 := vt1 / vt2;
  AssertEquals('OpDiv:Sub1 X failed ', 1.0, vt4.X);
  AssertEquals('OpDiv:Sub2 Y failed ', 1.5, vt4.Y);
  AssertEquals('OpDiv:Sub3 Z failed ', 2.0, vt4.Z);
  AssertEquals('OpDiv:Sub4 W failed ', 2.5, vt4.W);
  vt4 := vt2 / vt1;
  AssertEquals('OpDiv:Sub1 X failed ', 1.0, vt4.X);
  AssertEquals('OpDiv:Sub2 Y failed ', 2/3, vt4.Y);
  AssertEquals('OpDiv:Sub3 Z failed ', 0.5, vt4.Z);
  AssertEquals('OpDiv:Sub4 W failed ', 0.4, vt4.W);

end;

procedure TVector4fFunctionalTest.TestOpDivSingle;
begin
  vt1.Create(2.0, 3.0, 4.0, 5.0);
  vt4 := vt1 / 2;
  AssertEquals('OpDivSingle:Sub1 X failed ', 1.0, vt4.X);
  AssertEquals('OpDivSingle:Sub2 Y failed ', 1.5, vt4.Y);
  AssertEquals('OpDivSingle:Sub3 Z failed ', 2.0, vt4.Z);
  AssertEquals('OpDivSingle:Sub4 W failed ', 2.5, vt4.W);
end;

procedure TVector4fFunctionalTest.TestOpEquals;
begin
  vt1.Create(120,60,180,240);
  vt2.Create(120,60,180,240);
  nb := vt1 = vt2;
  AssertEquals('OpEquality:Sub1 does not match ', True, nb);
  vt2.Create(120,60,181,240);
  nb := vt1 = vt2;
  AssertEquals('OpEquality:Sub2 should not match ', False, nb);
  vt2.Create(120,61,180,240);
  nb := vt1 = vt2;
  AssertEquals('OpEquality:Sub3 should not match ', False, nb);
  vt2.Create(119,60,180,240);
  nb := vt1 = vt2;
  AssertEquals('OpEquality:Sub4 should not match ', False, nb);
  vt2.Create(120,60,180,241);
  nb := vt1 = vt2;
  AssertEquals('OpEquality:Sub5 should not match ', False, nb);
end;

procedure TVector4fFunctionalTest.TestOpNotEquals;
begin
  vt1.Create(120,60,180,240);
  vt2.Create(120,60,180,240);
  nb := vt1 <> vt2;
  AssertEquals('OpNotEquals:Sub1 should not match ', False, nb);
  vt2.Create(120,60,181,240);
  nb := vt1 <> vt2;
  AssertEquals('OpNotEquals:Sub2 does not match ', True, nb);
  vt2.Create(120,61,180,240);
  nb := vt1 <> vt2;
  AssertEquals('OpNotEquals:Sub3 does not match ', True, nb);
  vt2.Create(119,60,180,240);
  nb := vt1 <> vt2;
  AssertEquals('OpNotEquals:Sub4 does not match ', True, nb);
  vt2.Create(120,60,180,241);
  nb := vt1 <> vt2;
  AssertEquals('OpNotEquals:Sub5 does not match ', True, nb);
  vt2.Create(121,61,181,241);
  nb := vt1 <> vt2;
  AssertEquals('OpNotEquals:Sub6 does not match ', True, nb);
end;

procedure TVector4fFunctionalTest.TestOpGTE;
begin
  vt1.Create(120,60,180,240);
  vt2.Create(120,60,180,240);
  nb := vt2 >= vt1;
  AssertEquals('OpGTE:Sub1 is not GTE ', True, nb);
  vt2.Create(120,60,181,240);
  nb := vt2 >= vt1;
  AssertEquals('OpGTE:Sub2  is not GTE ', True, nb);
  vt2.Create(120,61,180,240);
  nb := vt2 >= vt1;
  AssertEquals('OpGTE:Sub3  is not GTE ', True, nb);
  vt2.Create(121,60,180,240);
  nb := vt2 >= vt1;
  AssertEquals('OpGTE:Sub4  is not GTE ', True, nb);
  vt2.Create(120,60,180,241);
  nb := vt2 >= vt1;
  AssertEquals('OpGTE:Sub5  is not GTE ', True, nb);
  vt2.Create(120,60,179,240);
  nb := vt2 >= vt1;
  AssertEquals('OpGTE:Sub6 should not be GTE ', False, nb);
  vt2.Create(120,59,180,240);
  nb := vt2 >= vt1;
  AssertEquals('OpGTE:Sub7 should not be GTE ', False, nb);
  vt2.Create(119,60,180,240);
  nb := vt2 >= vt1;
  AssertEquals('OpGTE:Sub8 should not be GTE ', False, nb);
  vt2.Create(120,60,180,239);
  nb := vt2 >= vt1;
  AssertEquals('OpGTE:Sub9 should not be GTE ', False, nb);
end;

procedure TVector4fFunctionalTest.TestOpLTE;
begin
  vt1.Create(120,60,180,240);
  vt2.Create(120,60,180,240);
  nb := vt1 <= vt2;
  AssertEquals('OpLTE:Sub1 is not LTE ', True, nb);
  vt2.Create(120,60,181,240);
  nb := vt1 <= vt2;
  AssertEquals('OpLTE:Sub2  is not LTE ', True, nb);
  vt2.Create(120,61,180,240);
  nb := vt1 <= vt2;
  AssertEquals('OpLTE:Sub3  is not LTE ', True, nb);
  vt2.Create(121,60,180,240);
  nb := vt1 <= vt2;
  AssertEquals('OpLTE:Sub4  is not LTE ', True, nb);
  vt2.Create(120,60,180,241);
  nb := vt1 <= vt2;
  AssertEquals('OpLTE:Sub5  is not LTE ', True, nb);
  vt2.Create(120,60,179,240);
  nb := vt1 <= vt2;
  AssertEquals('OpLTE:Sub6 should not be LTE ', False, nb);
  vt2.Create(120,59,180,240);
  nb := vt1 <= vt2;
  AssertEquals('OpLTE:Sub7 should not be LTE ', False, nb);
  vt2.Create(119,60,180,240);
  nb := vt1 <= vt2;
  AssertEquals('OpLTE:Sub8 should not be LTE ', False, nb);
  vt2.Create(120,60,180,239);
  nb := vt1 <= vt2;
  AssertEquals('OpLTE:Sub9 should not be LTE ', False, nb);
end;

procedure TVector4fFunctionalTest.TestOpGT;
begin
  vt1.Create(120,60,180,240);
  vt2.Create(120,60,180,240);
  nb := vt2 > vt1;
  AssertEquals('OpGT:Sub1 should not be GT ', False, nb);
  vt2.Create(121,61,181,241);
  nb := vt2 > vt1;
  AssertEquals('OpGT:Sub2  is not GT ', True, nb);
  vt2.Create(121,61,179,241);
  nb := vt2 > vt1;
  AssertEquals('OpGT:Sub3 should not be GT ', False, nb);
  vt2.Create(121,59,181,241);
  nb := vt2 > vt1;
  AssertEquals('OpGT:Sub4 should not be GT ', False, nb);
  vt2.Create(119,61,181,241);
  nb := vt2 > vt1;
  AssertEquals('OpGT:Sub5 should not be GT ', False, nb);
  vt2.Create(121,61,181,239);
  nb := vt2 > vt1;
  AssertEquals('OpGT:Sub6 should not be GT ', False, nb);
end;

procedure TVector4fFunctionalTest.TestOpLT;
begin
  vt1.Create(120,60,180,240);
  vt2.Create(120,60,180,240);
  nb := vt1 < vt2;
  AssertEquals('OpLT:Sub1 should not be LT ', False, nb);
  vt1.Create(119,59,179,239);
  nb := vt1 < vt2;
  AssertEquals('OpLT:Sub2  is not LT ', True, nb);
  vt1.Create(119,59,179,240);
  nb := vt1 < vt2;
  AssertEquals('OpLT:Sub6 should not be LT ', False, nb);
  vt1.Create(119,59,180,239);
  nb := vt1 < vt2;
  AssertEquals('OpLT:Sub7 should not be LT ', False, nb);
  vt1.Create(119,60,179,239);
  nb := vt1 < vt2;
  AssertEquals('OpLT:Sub8 should not be LT ', False, nb);
  vt1.Create(120,59,179,239);
  nb := vt1 < vt2;
  AssertEquals('OpLT:Sub9 should not be LT ', False, nb);
end;

procedure TVector4fFunctionalTest.TestShuffle;
begin
  vt1.Create(-120,60,-180,240);
  vt4 := vt1.Shuffle(0,0,0,0);
  AssertEquals('Shuffle:Sub1 X failed ', -120, vt4.X);
  AssertEquals('Shuffle:Sub2 Y failed ', -120, vt4.Y);
  AssertEquals('Shuffle:Sub3 Z failed ', -120, vt4.Z);
  AssertEquals('Shuffle:Sub4 W failed ', -120, vt4.W);
  vt4 := vt1.Shuffle(0,0,1,1);
  AssertEquals('Shuffle:Sub1 X failed ', -120, vt4.X);
  AssertEquals('Shuffle:Sub2 Y failed ', -120, vt4.Y);
  AssertEquals('Shuffle:Sub3 Z failed ',   60, vt4.Z);
  AssertEquals('Shuffle:Sub4 W failed ',   60, vt4.W);
  vt4 := vt1.Shuffle(2,3,2,3);
  AssertEquals('Shuffle:Sub1 X failed ', -180, vt4.X);
  AssertEquals('Shuffle:Sub2 Y failed ',  240, vt4.Y);
  AssertEquals('Shuffle:Sub3 Z failed ', -180, vt4.Z);
  AssertEquals('Shuffle:Sub4 W failed ',  240, vt4.W);
end;

procedure TVector4fFunctionalTest.TestSwizzle;
begin
  vt1.Create(1,2,3,4);
  vt4 := vt1.Swizzle(swXXXX);
  AssertEquals('Swizzle:Sub1 X failed ', 1, vt4.X);
  AssertEquals('Swizzle:Sub2 Y failed ', 1, vt4.Y);
  AssertEquals('Swizzle:Sub3 Z failed ', 1, vt4.Z);
  AssertEquals('Swizzle:Sub4 W failed ', 1, vt4.W);
  vt4 := vt1.Swizzle(swYYYY);
  AssertEquals('Swizzle:Sub5 X failed ', 2, vt4.X);
  AssertEquals('Swizzle:Sub6 Y failed ', 2, vt4.Y);
  AssertEquals('Swizzle:Sub7 Z failed ', 2, vt4.Z);
  AssertEquals('Swizzle:Sub8 W failed ', 2, vt4.W);
  vt4 := vt1.Swizzle(swZZZZ);
  AssertEquals('Swizzle:Sub9 X failed ',  3, vt4.X);
  AssertEquals('Swizzle:Sub10 Y failed ', 3, vt4.Y);
  AssertEquals('Swizzle:Sub11 Z failed ', 3, vt4.Z);
  AssertEquals('Swizzle:Sub12 W failed ', 3, vt4.W);
  vt4 := vt1.Swizzle(swWWWW);
  AssertEquals('Swizzle:Sub13 X failed ', 4, vt4.X);
  AssertEquals('Swizzle:Sub14 Y failed ', 4, vt4.Y);
  AssertEquals('Swizzle:Sub15 Z failed ', 4, vt4.Z);
  AssertEquals('Swizzle:Sub16 W failed ', 4, vt4.W);
  vt4 := vt1.Swizzle(swXYZW);
  AssertEquals('Swizzle:Sub17 X failed ', 1, vt4.X);
  AssertEquals('Swizzle:Sub18 Y failed ', 2, vt4.Y);
  AssertEquals('Swizzle:Sub19 Z failed ', 3, vt4.Z);
  AssertEquals('Swizzle:Sub20 W failed ', 4, vt4.W);
  vt4 := vt1.Swizzle(swXZYW);
  AssertEquals('Swizzle:Sub21 X failed ', 1, vt4.X);
  AssertEquals('Swizzle:Sub22 Y failed ', 3, vt4.Y);
  AssertEquals('Swizzle:Sub23 Z failed ', 2, vt4.Z);
  AssertEquals('Swizzle:Sub24 W failed ', 4, vt4.W);
  vt4 := vt1.Swizzle(swZYXW);
  AssertEquals('Swizzle:Sub21 X failed ', 3, vt4.X);
  AssertEquals('Swizzle:Sub22 Y failed ', 2, vt4.Y);
  AssertEquals('Swizzle:Sub23 Z failed ', 1, vt4.Z);
  AssertEquals('Swizzle:Sub24 W failed ', 4, vt4.W);
  vt4 := vt1.Swizzle(swZXYW);
  AssertEquals('Swizzle:Sub25 X failed ', 3, vt4.X);
  AssertEquals('Swizzle:Sub26 Y failed ', 1, vt4.Y);
  AssertEquals('Swizzle:Sub27 Z failed ', 2, vt4.Z);
  AssertEquals('Swizzle:Sub28 W failed ', 4, vt4.W);
  vt4 := vt1.Swizzle(swYXZW);
  AssertEquals('Swizzle:Sub29 X failed ', 2, vt4.X);
  AssertEquals('Swizzle:Sub30 Y failed ', 1, vt4.Y);
  AssertEquals('Swizzle:Sub31 Z failed ', 3, vt4.Z);
  AssertEquals('Swizzle:Sub32 W failed ', 4, vt4.W);
  vt4 := vt1.Swizzle(swYZXW);
  AssertEquals('Swizzle:Sub33 X failed ', 2, vt4.X);
  AssertEquals('Swizzle:Sub34 Y failed ', 3, vt4.Y);
  AssertEquals('Swizzle:Sub35 Z failed ', 1, vt4.Z);
  AssertEquals('Swizzle:Sub36 W failed ', 4, vt4.W);
  vt4 := vt1.Swizzle(swWXYZ);
  AssertEquals('Swizzle:Sub37 X failed ', 4, vt4.X);
  AssertEquals('Swizzle:Sub38 Y failed ', 1, vt4.Y);
  AssertEquals('Swizzle:Sub39 Z failed ', 2, vt4.Z);
  AssertEquals('Swizzle:Sub40 W failed ', 3, vt4.W);
  vt4 := vt1.Swizzle(swWXZY);
  AssertEquals('Swizzle:Sub41 X failed ', 4, vt4.X);
  AssertEquals('Swizzle:Sub42 Y failed ', 1, vt4.Y);
  AssertEquals('Swizzle:Sub43 Z failed ', 3, vt4.Z);
  AssertEquals('Swizzle:Sub44 W failed ', 2, vt4.W);
  vt4 := vt1.Swizzle(swWZYX);
  AssertEquals('Swizzle:Sub45 X failed ', 4, vt4.X);
  AssertEquals('Swizzle:Sub46 Y failed ', 3, vt4.Y);
  AssertEquals('Swizzle:Sub47 Z failed ', 2, vt4.Z);
  AssertEquals('Swizzle:Sub48 W failed ', 1, vt4.W);
  vt4 := vt1.Swizzle(swWZYX);
  AssertEquals('Swizzle:Sub45 X failed ', 4, vt4.X);
  AssertEquals('Swizzle:Sub46 Y failed ', 3, vt4.Y);
  AssertEquals('Swizzle:Sub47 Z failed ', 2, vt4.Z);
  AssertEquals('Swizzle:Sub48 W failed ', 1, vt4.W);
  vt4 := vt1.Swizzle(swWZXY);
  AssertEquals('Swizzle:Sub49 X failed ', 4, vt4.X);
  AssertEquals('Swizzle:Sub50 Y failed ', 3, vt4.Y);
  AssertEquals('Swizzle:Sub51 Z failed ', 1, vt4.Z);
  AssertEquals('Swizzle:Sub52 W failed ', 2, vt4.W);
  vt4 := vt1.Swizzle(swWYXZ);
  AssertEquals('Swizzle:Sub53 X failed ', 4, vt4.X);
  AssertEquals('Swizzle:Sub54 Y failed ', 2, vt4.Y);
  AssertEquals('Swizzle:Sub55 Z failed ', 1, vt4.Z);
  AssertEquals('Swizzle:Sub56 W failed ', 3, vt4.W);
  vt4 := vt1.Swizzle(swWYZX);
  AssertEquals('Swizzle:Sub53 X failed ', 4, vt4.X);
  AssertEquals('Swizzle:Sub54 Y failed ', 2, vt4.Y);
  AssertEquals('Swizzle:Sub55 Z failed ', 3, vt4.Z);
  AssertEquals('Swizzle:Sub56 W failed ', 1, vt4.W);
end;

procedure TVector4fFunctionalTest.TestMinXYZ;
begin
  vt1.Create(1,2,3,1);
  fs1 := vt1.MinXYZComponent;
  AssertEquals('MinXYZComponent:Sub1 failed ',  1, fs1);
  vt1.Create(6,4,3,1);
  fs1 := vt1.MinXYZComponent;
  AssertEquals('MinXYZComponent:Sub2 failed ',  3, fs1);
  vt1.Create(5,4,6,1);
  fs1 := vt1.MinXYZComponent;
  AssertEquals('MinXYZComponent:Sub3 failed ',  4, fs1);
end;

procedure TVector4fFunctionalTest.TestMaxXYZ;
begin
  vt1.Create(1,2,3,4);
  fs1 := vt1.MaxXYZComponent;
  AssertEquals('MaxXYZComponent:Sub1 failed ',  3, fs1);
  vt1.Create(1,4,3,6);
  fs1 := vt1.MaxXYZComponent;
  AssertEquals('MaxXYZComponent:Sub2 failed ',  4, fs1);
  vt1.Create(5,4,3,6);
  fs1 := vt1.MaxXYZComponent;
  AssertEquals('MaxXYZComponent:Sub3 failed ',  5, fs1);
end;

procedure TVector4fFunctionalTest.TestAbs;
begin
  vt1.Create(-120,60,-180,240);
  vt4 := vt1.Abs;
  AssertEquals('Abs:Sub1 X failed ',  120, vt4.X);
  AssertEquals('Abs:Sub2 Y failed ',   60, vt4.Y);
  AssertEquals('Abs:Sub3 Z failed ',  180, vt4.Z);
  AssertEquals('Abs:Sub4 W failed ',  240, vt4.W);
  vt1.Create(120,-60,180,-240);
  vt4 := vt1.Abs;
  AssertEquals('Abs:Sub5 X failed ',  120, vt4.X);
  AssertEquals('Abs:Sub6 Y failed ',   60, vt4.Y);
  AssertEquals('Abs:Sub7 Z failed ',  180, vt4.Z);
  AssertEquals('Abs:Sub8 W failed ',  240, vt4.W);
end;

procedure TVector4fFunctionalTest.TestNegate;
var a: TGLZVector4f;
begin
  vt1.Create(10.0, 20.0, 30.0, 1);
  vt4 := vt1.Negate;
  AssertEquals('Negate:Sub1 X failed ', -10.0, vt4.X);
  AssertEquals('Negate:Sub2 Y failed ', -20.0, vt4.Y);
  AssertEquals('Negate:Sub3 Z failed ', -30.0, vt4.Z);
  AssertEquals('Negate:Sub4 W failed ',  -1.0, vt4.W);
  a.Create(10.0, 20.0, 30.0, 1);
  vt4 := a.Negate;
  AssertEquals('Negate:Sub1 X failed ', -10.0, vt4.X);
  AssertEquals('Negate:Sub2 Y failed ', -20.0, vt4.Y);
  AssertEquals('Negate:Sub3 Z failed ', -30.0, vt4.Z);
  AssertEquals('Negate:Sub4 W failed ',  -1.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestDivide2;
begin
  vt1.Create(2,3,4,5);
  vt4 := vt1.DivideBy2;
  AssertEquals('Divide2:Sub1 X failed ',  1.0, vt4.X);
  AssertEquals('Divide2:Sub2 Y failed ',  1.5, vt4.Y);
  AssertEquals('Divide2:Sub3 Z failed ',  2.0, vt4.Z);
  AssertEquals('Divide2:Sub4 W failed ',  2.5, vt4.W);
end;

procedure TVector4fFunctionalTest.TestLength;
begin
  vt1.Create(6.0,0.0,0.0,40);  // ensure W plays no part by setting to large
  fs1 := vt1.Length;
  AssertEquals('Length:Sub1 X failed ',  6.0, fs1);
  vt1.Create(-6.0,0.0,0.0,40);
  fs1 := vt1.Length;
  AssertEquals('Length:Sub2 -X failed ', 6.0, fs1);
  vt1.Create(0.0,6.0,0.0,40);
  fs1 := vt1.Length;
  AssertEquals('Length:Sub3 Y failed ',  6.0, fs1);
  vt1.Create(0.0,-6.0,0.0,40);
  fs1 := vt1.Length;
  AssertEquals('Length:Sub4 -Y failed ', 6.0, fs1);
  vt1.Create(0.0,0.0,6.0,40);
  fs1 := vt1.Length;
  AssertEquals('Length:Sub5 Z failed ',  6.0, fs1);
  vt1.Create(0.0,0.0,-6.0,40);
  fs1 := vt1.Length;
  AssertEquals('Length:Sub5 -Z failed ', 6.0, fs1);
  vt1.Create(2.0,2.0,2.0,40);
  fs1 := vt1.Length;
  AssertEquals('Length:Sub6 Q1 failed ', sqrt(12.0), fs1);
end;

procedure TVector4fFunctionalTest.TestLengthSquare;
begin
  vt1.Create(6.0,0.0,0.0,40);  // ensure W plays no part by setting to large
  fs1 := vt1.LengthSquare;
  AssertEquals('LengthSquare:Sub1 X failed ',  36.0, fs1);
  vt1.Create(-6.0,0.0,0.0,40);
  fs1 := vt1.LengthSquare;
  AssertEquals('LengthSquare:Sub2 -X failed ', 36.0, fs1);
  vt1.Create(0.0,6.0,0.0,40);
  fs1 := vt1.LengthSquare;
  AssertEquals('LengthSquare:Sub3 Y failed ',  36.0, fs1);
  vt1.Create(0.0,-6.0,0.0,40);
  fs1 := vt1.LengthSquare;
  AssertEquals('LengthSquare:Sub4 -Y failed ', 36.0, fs1);
  vt1.Create(0.0,0.0,6.0,40);
  fs1 := vt1.LengthSquare;
  AssertEquals('LengthSquare:Sub5 Z failed ',  36.0, fs1);
  vt1.Create(0.0,0.0,-6.0,40);
  fs1 := vt1.LengthSquare;
  AssertEquals('LengthSquare:Sub5 -Z failed ', 36.0, fs1);
  vt1.Create(2.0,2.0,2.0,40);
  fs1 := vt1.LengthSquare;
  AssertEquals('LengthSquare:Sub6 Q1 failed ', 12, fs1);
end;

procedure TVector4fFunctionalTest.TestDistance;
begin
  vt1.Create(6.0,0.0,0.0,40);  // ensure W plays no part by setting to large
  fs1 := vt1.Distance(NullHmgPoint);
  AssertEquals('Distance:Sub1 X failed ',  6.0, fs1);
  vt1.Create(-6.0,0.0,0.0,40);
  fs1 := vt1.Distance(NullHmgPoint);
  AssertEquals('Distance:Sub2 -X failed ', 6.0, fs1);
  vt1.Create(0.0,6.0,0.0,40);
  fs1 := vt1.Distance(NullHmgPoint);
  AssertEquals('Distance:Sub3 Y failed ',  6.0, fs1);
  vt1.Create(0.0,-6.0,0.0,40);
  fs1 := vt1.Distance(NullHmgPoint);
  AssertEquals('Distance:Sub4 -Y failed ', 6.0, fs1);
  vt1.Create(0.0,0.0,6.0,40);
  fs1 := vt1.Distance(NullHmgPoint);
  AssertEquals('Distance:Sub5 Z failed ',  6.0, fs1);
  vt1.Create(0.0,0.0,-6.0,40);
  fs1 := vt1.Distance(NullHmgPoint);
  AssertEquals('Distance:Sub5 -Z failed ', 6.0, fs1);
  vt1.Create(2.0,2.0,2.0,40);
  fs1 := vt1.Distance(NullHmgPoint);
  AssertEquals('Distance:Sub6 Q1 failed ', sqrt(12.0), fs1);
end;

procedure TVector4fFunctionalTest.TestDistanceSquare;
begin
  vt1.Create(6.0,0.0,0.0,40);  // ensure W plays no part by setting to large
  fs1 := vt1.DistanceSquare(NullHmgPoint);
  AssertEquals('DistanceSquare:Sub1 X failed ',  36.0, fs1);
  vt1.Create(-6.0,0.0,0.0,40);
  fs1 := vt1.DistanceSquare(NullHmgPoint);
  AssertEquals('DistanceSquare:Sub2 -X failed ', 36.0, fs1);
  vt1.Create(0.0,6.0,0.0,40);
  fs1 := vt1.DistanceSquare(NullHmgPoint);
  AssertEquals('DistanceSquare:Sub3 Y failed ',  36.0, fs1);
  vt1.Create(0.0,-6.0,0.0,40);
  fs1 := vt1.DistanceSquare(NullHmgPoint);
  AssertEquals('DistanceSquare:Sub4 -Y failed ', 36.0, fs1);
  vt1.Create(0.0,0.0,6.0,40);
  fs1 := vt1.DistanceSquare(NullHmgPoint);
  AssertEquals('DistanceSquare:Sub5 Z failed ',  36.0, fs1);
  vt1.Create(0.0,0.0,-6.0,40);
  fs1 := vt1.DistanceSquare(NullHmgPoint);
  AssertEquals('DistanceSquare:Sub5 -Z failed ', 36.0, fs1);
  vt1.Create(2.0,2.0,2.0,40);
  fs1 := vt1.DistanceSquare(NullHmgPoint);
  AssertEquals('DistanceSquare:Sub6 Q1 failed ', 12, fs1);
end;

procedure TVector4fFunctionalTest.TestSpacing;
begin
  vt1.Create(-120,60,-180,1);
  vt2.Create(120,-60,180, 1);
  fs1 := vt1.spacing(vt2);
  AssertEquals('Spacing:Sub1 failed ', 720.0, fs1);
  fs1 := vt2.spacing(vt1);
  AssertEquals('Spacing:Sub1 failed ', 720.0, fs1);
end;

procedure TVector4fFunctionalTest.TestDotProduct;
begin
  vt1.Create(-1 ,6,-8,1);     // dot is -8 + 36  -8 = -52
  vt2.Create(8, -6, 1, 1);
  fs1 := vt1.DotProduct(vt2);
  AssertEquals('DotProduct:Sub1 failed ', -52.0, fs1);
  fs1 := vt2.DotProduct(vt1);
  AssertEquals('DotProduct:Sub2 failed ', -52.0, fs1);
  vt2.Create(8, 6, 1, 1);
  fs1 := vt1.DotProduct(vt2);
  AssertEquals('DotProduct:Sub3 failed ', 20.0, fs1);
  fs1 := vt2.DotProduct(vt1);
  AssertEquals('DotProduct:Sub4 failed ', 20.0, fs1);
end;

procedure TVector4fFunctionalTest.TestCrossProduct;
begin
  vt1.Create(-1 ,6,-8,1);     // dot is -8 + 36  -8 = -52
  vt2.Create(8, -6, 1, 1);
  vt4 := vt1.CrossProduct(vt2);
  AssertEquals('CrossProduct:Sub1 X failed ', -42.0, vt4.X);  // 6 - 48
  AssertEquals('CrossProduct:Sub2 Y failed ', -63.0, vt4.Y);  // -64 - -1
  AssertEquals('CrossProduct:Sub3 Z failed ', -42.0, vt4.Z);  // 6 - 48
  AssertEquals('CrossProduct:Sub4 W failed ',   1.0, vt4.W);
  vt4 := vt2.CrossProduct(vt1);
  AssertEquals('CrossProduct:Sub5 X failed ',  42.0, vt4.X);  // 48 - 6
  AssertEquals('CrossProduct:Sub6 Y failed ',  63.0, vt4.Y);  // -1 - -64
  AssertEquals('CrossProduct:Sub7 Z failed ',  42.0, vt4.Z);  // 48 - 6
  AssertEquals('CrossProduct:Sub8 W failed ',   1.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestNormalize;
begin
  vt1.Create(0.0,0.0,0.0,1.0);   // try to normalise the origin.
  vt4 := vt1.Normalize;
  AssertEquals('Normalize:Sub1 X failed ',  0.0, vt4.X);
  AssertEquals('Normalize:Sub2 Y failed ',  0.0, vt4.Y);
  AssertEquals('Normalize:Sub3 Z failed ',  0.0, vt4.Z);
  AssertEquals('Normalize:Sub4 W failed ',  1.0, vt4.W);
  vt1.Create(6.0,0.0,0.0,1.0);
  vt4 := vt1.Normalize;
  AssertEquals('Normalize:Sub5 X failed ',  1.0, vt4.X);
  AssertEquals('Normalize:Sub6 Y failed ',  0.0, vt4.Y);
  AssertEquals('Normalize:Sub7 Z failed ',  0.0, vt4.Z);
  AssertEquals('Normalize:Sub8 W failed ',  1.0, vt4.W);
  vt1.Create(-6.0,0.0,0.0,1.0);
  vt4 := vt1.Normalize;
  AssertEquals('Normalize:Sub9 X failed ', -1.0, vt4.X);
  AssertEquals('Normalize:Sub10 Y failed ',  0.0, vt4.Y);
  AssertEquals('Normalize:Sub11 Z failed ',  0.0, vt4.Z);
  AssertEquals('Normalize:Sub12 W failed ',  1.0, vt4.W);
  vt1.Create(0.0,0.6,0.0,1.0);
  vt4 := vt1.Normalize;
  AssertEquals('Normalize:Sub13 X failed ',  0.0, vt4.X);
  AssertEquals('Normalize:Sub14 Y failed ',  1.0, vt4.Y);
  AssertEquals('Normalize:Sub15 Z failed ',  0.0, vt4.Z);
  AssertEquals('Normalize:Sub16 W failed ',  1.0, vt4.W);
  vt1.Create(0.0,-6.0,0.0,1.0);
  vt4 := vt1.Normalize;
  AssertEquals('Normalize:Sub17 X failed ',  0.0, vt4.X);
  AssertEquals('Normalize:Sub18 Y failed ', -1.0, vt4.Y);
  AssertEquals('Normalize:Sub19 Z failed ',  0.0, vt4.Z);
  AssertEquals('Normalize:Sub20 W failed ',  1.0, vt4.W);
  vt1.Create(0.0,0.0,13.0,1.0);
  vt4 := vt1.Normalize;
  AssertEquals('Normalize:Sub21 X failed ',  0.0, vt4.X);
  AssertEquals('Normalize:Sub22 Y failed ',  0.0, vt4.Y);
  AssertEquals('Normalize:Sub23 Z failed ',  1.0, vt4.Z);
  AssertEquals('Normalize:Sub24 W failed ',  1.0, vt4.W);
  vt1.Create(0.0,0.0,-0.13,1.0);
  vt4 := vt1.Normalize;
  AssertEquals('Normalize:Sub25 X failed ',  0.0, vt4.X);
  AssertEquals('Normalize:Sub26 Y failed ',  0.0, vt4.Y);
  AssertEquals('Normalize:Sub27 Z failed ', -1.0, vt4.Z);
  AssertEquals('Normalize:Sub28 W failed ',  1.0, vt4.W);
  vt1.Create(6.0,6.0,6.0,1.0);
  vt4 := vt1.Normalize;
  AssertEquals('Normalize:Sub29 X failed ',  1/sqrt(3), vt4.X);
  AssertEquals('Normalize:Sub30 Y failed ',  1/sqrt(3), vt4.Y);
  AssertEquals('Normalize:Sub31 Z failed ',  1/sqrt(3), vt4.Z);
  AssertEquals('Normalize:Sub32 W failed ',        1.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestNorm;
begin
  vt1.Create(6.0,0.0,0.0,40);  // ensure W plays no part by setting to large
  fs1 := vt1.Norm;
  AssertEquals('Norm:Sub1 X failed ',  36.0, fs1);
  vt1.Create(-6.0,0.0,0.0,40);
  fs1 := vt1.Norm;
  AssertEquals('Norm:Sub2 -X failed ', 36.0, fs1);
  vt1.Create(0.0,6.0,0.0,40);
  fs1 := vt1.Norm;
  AssertEquals('Norm:Sub3 Y failed ',  36.0, fs1);
  vt1.Create(0.0,-6.0,0.0,40);
  fs1 := vt1.Norm;
  AssertEquals('Norm:Sub4 -Y failed ', 36.0, fs1);
  vt1.Create(0.0,0.0,6.0,40);
  fs1 := vt1.Norm;
  AssertEquals('Norm:Sub5 Z failed ',  36.0, fs1);
  vt1.Create(0.0,0.0,-6.0,40);
  fs1 := vt1.Norm;
  AssertEquals('Norm:Sub5 -Z failed ', 36.0, fs1);
  vt1.Create(2.0,2.0,2.0,40);
  fs1 := vt1.Norm;
  AssertEquals('Norm:Sub6 Q1 failed ', 12, fs1);
end;

procedure TVector4fFunctionalTest.TestMin;
begin
  vt1.Create(-120,60,-180,240);
  vt2.Create(120,-60,180,-240);
  vt4 := vt1.Min(vt2);
  AssertEquals('Min:Sub1 X failed ',  -120.0, vt4.X);
  AssertEquals('Min:Sub2 Y failed ',   -60.0, vt4.Y);
  AssertEquals('Min:Sub3 Z failed ',  -180.0, vt4.Z);
  AssertEquals('Min:Sub4 W failed ',  -240.0, vt4.W);
  vt4 := vt2.Min(vt1);
  AssertEquals('Min:Sub5 X failed ',  -120.0, vt4.X);
  AssertEquals('Min:Sub6 Y failed ',   -60.0, vt4.Y);
  AssertEquals('Min:Sub7 Z failed ',  -180.0, vt4.Z);
  AssertEquals('Min:Sub8 W failed ',  -240.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestMinSingle;
begin
  vt1.Create(-120,60,-180,240);
  vt2.Create(120,-60,180,-240);
  vt4 := vt1.Min(0);
  AssertEquals('MinSingle:Sub1 X failed ',  -120.0, vt4.X);
  AssertEquals('MinSingle:Sub2 Y failed ',     0.0, vt4.Y);
  AssertEquals('MinSingle:Sub3 Z failed ',  -180.0, vt4.Z);
  AssertEquals('MinSingle:Sub4 W failed ',    0.0, vt4.W);
  vt4 := vt2.Min(0);
  AssertEquals('MinSingle:Sub5 X failed ',     0.0, vt4.X);
  AssertEquals('MinSingle:Sub6 Y failed ',   -60.0, vt4.Y);
  AssertEquals('MinSingle:Sub7 Z failed ',     0.0, vt4.Z);
  AssertEquals('MinSingle:Sub8 W failed ',  -240.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestMax;
begin
  vt1.Create(-120,60,-180,240);
  vt2.Create(120,-60,180,-240);
  vt4 := vt1.Max(vt2);
  AssertEquals('Max:Sub1 X failed ',  120.0, vt4.X);
  AssertEquals('Max:Sub2 Y failed ',   60.0, vt4.Y);
  AssertEquals('Max:Sub3 Z failed ',  180.0, vt4.Z);
  AssertEquals('Max:Sub4 W failed ',  240.0, vt4.W);
  vt4 := vt2.Max(vt1);
  AssertEquals('Max:Sub5 X failed ',  120.0, vt4.X);
  AssertEquals('Max:Sub6 Y failed ',   60.0, vt4.Y);
  AssertEquals('Max:Sub7 Z failed ',  180.0, vt4.Z);
  AssertEquals('Max:Sub8 W failed ',  240.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestMaxSingle;
begin
  vt1.Create(-120,60,-180,240);
  vt2.Create(120,-60,180,-240);
  vt4 := vt2.Max(0);
  AssertEquals('MaxSingle:Sub1 X failed ',  120.0, vt4.X);
  AssertEquals('MaxSingle:Sub2 Y failed ',    0.0, vt4.Y);
  AssertEquals('MaxSingle:Sub3 Z failed ',  180.0, vt4.Z);
  AssertEquals('MaxSingle:Sub4 W failed ',    0.0, vt4.W);
  vt4 := vt1.Max(0);
  AssertEquals('MaxSingle:Sub5 X failed ',    0.0, vt4.X);
  AssertEquals('MaxSingle:Sub6 Y failed ',   60.0, vt4.Y);
  AssertEquals('MaxSingle:Sub7 Z failed ',    0.0, vt4.Z);
  AssertEquals('MaxSingle:Sub8 W failed ',  240.0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestClamp;
begin
  vt1.Create(-120,60,-180,240);
  vt2.Create(0,0,0,0);
  vt3.Create(500,500,500,500);
  vt4 := vt1.Clamp(vt2,vt3);
  AssertEquals('Clamp:Sub1 X failed ',   0, vt4.X);
  AssertEquals('Clamp:Sub2 Y failed ',  60, vt4.Y);
  AssertEquals('Clamp:Sub3 Z failed ',   0, vt4.Z);
  AssertEquals('Clamp:Sub4 W failed ', 240, vt4.W);
  vt1.Create(120,-60,180,-240);
  vt4 := vt1.Clamp(vt2,vt3);
  AssertEquals('Clamp:Sub5 X failed ', 120, vt4.X);
  AssertEquals('Clamp:Sub6 Y failed ',   0, vt4.Y);
  AssertEquals('Clamp:Sub7 Z failed ', 180, vt4.Z);
  AssertEquals('Clamp:Sub8 W failed ',   0, vt4.W);
  vt1.Create(620,60,780,240);
  vt4 := vt1.Clamp(vt2,vt3);
  AssertEquals('Clamp:Sub9 X failed ',  500, vt4.X);
  AssertEquals('Clamp:Sub10 Y failed ',  60, vt4.Y);
  AssertEquals('Clamp:Sub11 Z failed ', 500, vt4.Z);
  AssertEquals('Clamp:Sub12 W failed ', 240, vt4.W);
  vt1.Create(120,600,180,740);
  vt4 := vt1.Clamp(vt2,vt3);
  AssertEquals('Clamp:Sub13 X failed ', 120, vt4.X);
  AssertEquals('Clamp:Sub14 Y failed ', 500, vt4.Y);
  AssertEquals('Clamp:Sub15 Z failed ', 180, vt4.Z);
  AssertEquals('Clamp:Sub16 W failed ', 500, vt4.W);
end;

procedure TVector4fFunctionalTest.TestClampSingle;
begin
  vt1.Create(-120,60,-180,240);
  vt4 := vt1.Clamp(0,500);
  AssertEquals('ClampSingle:Sub1 X failed ',   0, vt4.X);
  AssertEquals('ClampSingle:Sub2 Y failed ',  60, vt4.Y);
  AssertEquals('ClampSingle:Sub3 Z failed ',   0, vt4.Z);
  AssertEquals('ClampSingle:Sub4 W failed ', 240, vt4.W);
  vt1.Create(120,-60,180,-240);
  vt4 := vt1.Clamp(0,500);
  AssertEquals('ClampSingle:Sub5 X failed ', 120, vt4.X);
  AssertEquals('ClampSingle:Sub6 Y failed ',   0, vt4.Y);
  AssertEquals('ClampSingle:Sub7 Z failed ', 180, vt4.Z);
  AssertEquals('ClampSingle:Sub8 W failed ',   0, vt4.W);
  vt1.Create(620,60,780,240);
  vt4 := vt1.Clamp(0,500);
  AssertEquals('ClampSingle:Sub9 X failed ',  500, vt4.X);
  AssertEquals('ClampSingle:Sub10 Y failed ',  60, vt4.Y);
  AssertEquals('ClampSingle:Sub11 Z failed ', 500, vt4.Z);
  AssertEquals('ClampSingle:Sub12 W failed ', 240, vt4.W);
  vt1.Create(120,600,180,740);
  vt4 := vt1.Clamp(0,500);
  AssertEquals('ClampSingle:Sub13 X failed ', 120, vt4.X);
  AssertEquals('ClampSingle:Sub14 Y failed ', 500, vt4.Y);
  AssertEquals('ClampSingle:Sub15 Z failed ', 180, vt4.Z);
  AssertEquals('ClampSingle:Sub16 W failed ', 500, vt4.W);
end;

procedure TVector4fFunctionalTest.TestMulAdd;
begin
  vt1.Create(-120,60,-180,240);
  vt2.Create(10,10,10,10);
  vt3.Create(500,500,500,500);
  vt4 := vt1.MulAdd(vt2,vt3);
  AssertEquals('MulAdd:Sub1 X failed ',  -700, vt4.X);
  AssertEquals('MulAdd:Sub2 Y failed ',  1100, vt4.Y);
  AssertEquals('MulAdd:Sub3 Z failed ', -1300, vt4.Z);
  AssertEquals('MulAdd:Sub4 W failed ',  2900, vt4.W);
  vt4 := vt3.MulAdd(vt2,vt1);
  AssertEquals('MulAdd:Sub5 X failed ',  4880, vt4.X);
  AssertEquals('MulAdd:Sub6 Y failed ',  5060, vt4.Y);
  AssertEquals('MulAdd:Sub7 Z failed ',  4820, vt4.Z);
  AssertEquals('MulAdd:Sub8 W failed ',  5240, vt4.W);
end;

procedure TVector4fFunctionalTest.TestMulDiv;
begin
  vt1.Create(-120,60,-180,240);
  vt2.Create(10,10,10,10);
  vt3.Create(5,5,5,5);
  vt4 := vt1.MulDiv(vt2,vt3);
  AssertEquals('MulDiv:Sub1 X failed ', -240, vt4.X);
  AssertEquals('MulDiv:Sub2 Y failed ',  120, vt4.Y);
  AssertEquals('MulDiv:Sub3 Z failed ', -360, vt4.Z);
  AssertEquals('MulDiv:Sub4 W failed ',  480, vt4.W);
  vt4 := vt3.MulDiv(vt2,vt1);
  AssertEquals('MulDiv:Sub5 X failed ',  -5/12, vt4.X);
  AssertEquals('MulDiv:Sub6 Y failed ',    5/6, vt4.Y);
  AssertEquals('MulDiv:Sub7 Z failed ',  -5/18, vt4.Z);
  AssertEquals('MulDiv:Sub8 W failed ',   5/24, vt4.W);
end;

procedure TVector4fFunctionalTest.TestLerp;
begin
  vt1.Create(60,60,60,1);
  vt4 := vt1.Lerp(NullHmgPoint, 0.5);
  AssertEquals('Lerp:Sub1 X failed ', 30, vt4.X);
  AssertEquals('Lerp:Sub2 Y failed ', 30, vt4.Y);
  AssertEquals('Lerp:Sub3 Z failed ', 30, vt4.Z);
  AssertEquals('Lerp:Sub4 W failed ',  1, vt4.W);
  vt4 := vt1.Lerp(NullHmgPoint, 0.25);
  AssertEquals('Lerp:Sub5 X failed ', 45, vt4.X);
  AssertEquals('Lerp:Sub6 Y failed ', 45, vt4.Y);
  AssertEquals('Lerp:Sub7 Z failed ', 45, vt4.Z);
  AssertEquals('Lerp:Sub8 W failed ',  1, vt4.W);
  vt4 := vt1.Lerp(NullHmgPoint, 0.75);
  AssertEquals('Lerp:Sub9 X failed ',  15, vt4.X);
  AssertEquals('Lerp:Sub10 Y failed ', 15, vt4.Y);
  AssertEquals('Lerp:Sub11 Z failed ', 15, vt4.Z);
  AssertEquals('Lerp:Sub12 W failed ',  1, vt4.W);
  vt4 := NullHmgPoint.Lerp(vt1, 0.75);
  AssertEquals('Lerp:Sub13 X failed ', 45, vt4.X);
  AssertEquals('Lerp:Sub14 Y failed ', 45, vt4.Y);
  AssertEquals('Lerp:Sub15 Z failed ', 45, vt4.Z);
  AssertEquals('Lerp:Sub16 W failed ',  1, vt4.W);
  vt4 := NullHmgPoint.Lerp(vt1, 0.25);
  AssertEquals('Lerp:Sub17 X failed ', 15, vt4.X);
  AssertEquals('Lerp:Sub18 Y failed ', 15, vt4.Y);
  AssertEquals('Lerp:Sub19 Z failed ', 15, vt4.Z);
  AssertEquals('Lerp:Sub20 W failed ',  1, vt4.W);
end;

procedure TVector4fFunctionalTest.TestAngleCosine;
begin
  fs1 := XHmgVector.AngleCosine(YHmgVector);
  AssertEquals('AngleCosine:Sub1 X->Y failed ',  Cos(pi/2), fs1);
  fs1 := YHmgVector.AngleCosine(XHmgVector);
  AssertEquals('AngleCosine:Sub2 Y->X failed ',  Cos(pi/2), fs1);
  fs1 := XHmgVector.AngleCosine(-YHmgVector);
  AssertEquals('AngleCosine:Sub3 X->-Y failed ', Cos(pi/2), fs1);
  fs1 := YHmgVector.AngleCosine(-XHmgVector);
  AssertEquals('AngleCosine:Sub4 Y->-X failed ', Cos(pi/2), fs1);
  fs1 := ZHmgVector.AngleCosine(YHmgVector);
  AssertEquals('AngleCosine:Sub5 Z->Y failed ',  Cos(pi/2), fs1);
  fs1 := YHmgVector.AngleCosine(ZHmgVector);
  AssertEquals('AngleCosine:Sub6 Y->Z failed ',  Cos(pi/2), fs1);
  fs1 := ZHmgVector.AngleCosine(-YHmgVector);
  AssertEquals('AngleCosine:Sub7 Z->-Y failed ', Cos(pi/2), fs1);
  fs1 := YHmgVector.AngleCosine(-ZHmgVector);
  AssertEquals('AngleCosine:Sub8 Y->-Z failed ', Cos(pi/2), fs1);
  fs1 := XHmgVector.AngleCosine(ZHmgVector);
  AssertEquals('AngleCosine:Sub9 X->Z failed ',  Cos(pi/2), fs1);
  fs1 := ZHmgVector.AngleCosine(XHmgVector);
  AssertEquals('AngleCosine:Sub10 Z->X failed ', Cos(pi/2), fs1);
  fs1 := XHmgVector.AngleCosine(-ZHmgVector);
  AssertEquals('AngleCosine:Sub11 X->Z failed ', Cos(pi/2), fs1);
  fs1 := ZHmgVector.AngleCosine(-XHmgVector);
  AssertEquals('AngleCosine:Sub12 Z->X failed ', Cos(pi/2), fs1);
  fs1 := XHmgVector.AngleCosine(XYHmgVector);
  AssertEquals('AngleCosine:Sub13 X->XY failed ', Cos(pi/4), fs1);
  fs1 := -XHmgVector.AngleCosine(XYHmgVector);
  AssertEquals('AngleCosine:Sub14 X->XY failed ', Cos(3*pi/4), fs1);
  fs1 := -XHmgVector.AngleCosine(XHmgVector);
  AssertEquals('AngleCosine:Sub15 X->XY failed ', Cos(pi), fs1);
  fs1 := -YHmgVector.AngleCosine(YHmgVector);
  AssertEquals('AngleCosine:Sub16 X->XY failed ', Cos(pi), fs1);
  fs1 := -ZHmgVector.AngleCosine(ZHmgVector);
  AssertEquals('AngleCosine:Sub17 X->XY failed ', Cos(pi), fs1);
end;

procedure TVector4fFunctionalTest.TestAngleBetween;
begin
  fs1 := XHmgVector.AngleBetween(YHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub1 X->Y failed ',  pi/2, fs1);
  fs1 := YHmgVector.AngleBetween(XHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub2 Y->X failed ',  (pi/2), fs1);
  fs1 := XHmgVector.AngleBetween(-YHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub3 X->-Y failed ', (pi/2), fs1);
  fs1 := YHmgVector.AngleBetween(-XHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub4 Y->-X failed ', (pi/2), fs1);
  fs1 := ZHmgVector.AngleBetween(YHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub5 Z->Y failed ',  (pi/2), fs1);
  fs1 := YHmgVector.AngleBetween(ZHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub6 Y->Z failed ',  (pi/2), fs1);
  fs1 := ZHmgVector.AngleBetween(-YHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub7 Z->-Y failed ', (pi/2), fs1);
  fs1 := YHmgVector.AngleBetween(-ZHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub8 Y->-Z failed ', (pi/2), fs1);
  fs1 := XHmgVector.AngleBetween(ZHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub9 X->Z failed ',  (pi/2), fs1);
  fs1 := ZHmgVector.AngleBetween(XHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub10 Z->X failed ', (pi/2), fs1);
  fs1 := XHmgVector.AngleBetween(-ZHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub11 X->Z failed ', (pi/2), fs1);
  fs1 := ZHmgVector.AngleBetween(-XHmgVector,NullHmgPoint);
  AssertEquals('AngleBetween:Sub12 Z->X failed ', (pi/2), fs1);
  // cycle around in 45 deg inc in AntiClockWise order
  fs1 := c0DegVec.AngleBetween(c45DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub13 Z->X failed ', (pi/4), fs1);
  fs1 := c0DegVec.AngleBetween(c90DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub14 Z->X failed ', (pi/2), fs1);
  fs1 := c0DegVec.AngleBetween(c135DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub15 Z->X failed ', (3*pi/4), fs1);
  fs1 := c0DegVec.AngleBetween(c180DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub16 Z->X failed ', (pi), fs1);
  fs1 := c0DegVec.AngleBetween(c225DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub17 Z->X failed ', (3*pi/4), fs1);
  fs1 := c0DegVec.AngleBetween(c270DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub18 Z->X failed ', (pi/2), fs1);
  fs1 := c0DegVec.AngleBetween(c315DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub19 Z->X failed ', (pi/4), fs1);
  // cycle around in 45 deg inc in AntiClockWise order  from -x
  fs1 := c180DegVec.AngleBetween(c225DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub20 Z->X failed ', (pi/4), fs1);
  fs1 := c180DegVec.AngleBetween(c270DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub21 Z->X failed ', (pi/2), fs1);
  fs1 := c180DegVec.AngleBetween(c315DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub22 Z->X failed ', (3*pi/4), fs1);
  fs1 := c180DegVec.AngleBetween(c0DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub23 Z->X failed ', (pi), fs1);
  fs1 := c180DegVec.AngleBetween(c45DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub24 Z->X failed ', (3*pi/4), fs1);
  fs1 := c180DegVec.AngleBetween(c90DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub25 Z->X failed ', (pi/2), fs1);
  fs1 := c180DegVec.AngleBetween(c135DegVec, NullHmgPoint);
  AssertEquals('AngleBetween:Sub26 Z->X failed ', (pi/4), fs1);
end;

procedure TVector4fFunctionalTest.TestCombine;
begin
  vt1.Create(12,12,12,12);
  vt2.Create(40,50,60,255);
  fs1 := 3;
  vt4 := vt1.Combine(vt2,fs1);
  AssertEquals('Combine:Sub1 X failed ', 132, vt4.X);
  AssertEquals('Combine:Sub2 Y failed ', 162, vt4.Y);
  AssertEquals('Combine:Sub3 Z failed ', 192, vt4.Z);
  AssertEquals('Combine:Sub4 W failed ',   0, vt4.W);
  fs1 := 5;
  vt4 := vt1.Combine(vt2,fs1);
  AssertEquals('Combine:Sub5 X failed ',  212, vt4.X);
  AssertEquals('Combine:Sub6 Y failed ',  262, vt4.Y);
  AssertEquals('Combine:Sub7 Z failed ',  312, vt4.Z);
  AssertEquals('Combine:Sub8 W failed ',    0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestCombine2;
begin
  vt1.Create(12,12,12,12);
  vt2.Create(40,50,60,255);
  vt4 := vt1.Combine2(vt2, 0.5, 0.5);   // nice whole numbers
  AssertEquals('Combine2:Sub1 X failed ', 26, vt4.X);
  AssertEquals('Combine2:Sub2 Y failed ', 31, vt4.Y);
  AssertEquals('Combine2:Sub3 Z failed ', 36, vt4.Z);
  AssertEquals('Combine2:Sub4 W failed ',  0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestCombine3;
begin
  vt1.Create(12,12,12,12);
  vt2.Create(40,50,60,255);
  vt4 := vt1.Combine3(vt2, vt2, 0.5, 0.5, 0.5);
  AssertEquals('Combine3:Sub1 X failed ', 46, vt4.X);
  AssertEquals('Combine3:Sub2 Y failed ', 56, vt4.Y);
  AssertEquals('Combine3:Sub3 Z failed ', 66, vt4.Z);
  AssertEquals('Combine3:Sub4 W failed ',  0, vt4.W);
end;

procedure TVector4fFunctionalTest.TestRound;
var a4it4: TGLZVector4i;
begin
  vt1.Create(1.5,2.5,3.5,4.5);  // round to even test
  a4it4 := vt1.Round;
  AssertEquals('Round:Sub1 X failed ', 2, a4it4.X);
  AssertEquals('Round:Sub2 Y failed ', 2, a4it4.Y);
  AssertEquals('Round:Sub3 Z failed ', 4, a4it4.Z);
  AssertEquals('Round:Sub4 W failed ', 4, a4it4.W);
  vt1.Create(1.75,2.75,3.75,4.75);
  a4it4 := vt1.Round;
  AssertEquals('Round:Sub5 X failed ', 2, a4it4.X);
  AssertEquals('Round:Sub6 Y failed ', 3, a4it4.Y);
  AssertEquals('Round:Sub7 Z failed ', 4, a4it4.Z);
  AssertEquals('Round:Sub8 W failed ', 5, a4it4.W);
  vt1.Create(1.25,2.25,3.25,4.25);
  a4it4 := vt1.Round;
  AssertEquals('Round:Sub9 X failed ',  1, a4it4.X);
  AssertEquals('Round:Sub10 Y failed ', 2, a4it4.Y);
  AssertEquals('Round:Sub11 Z failed ', 3, a4it4.Z);
  AssertEquals('Round:Sub12 W failed ', 4, a4it4.W);
end;

procedure TVector4fFunctionalTest.TestTrunc;
var a4it4: TGLZVector4i;
begin
  vt1.Create(1.5,2.5,3.5,4.5);
  a4it4 := vt1.Trunc;
  AssertEquals('Trunc:Sub1 X failed ', 1, a4it4.X);
  AssertEquals('Trunc:Sub2 Y failed ', 2, a4it4.Y);
  AssertEquals('Trunc:Sub3 Z failed ', 3, a4it4.Z);
  AssertEquals('Trunc:Sub4 W failed ', 4, a4it4.W);
  vt1.Create(1.75,2.75,3.75,4.75);
  a4it4 := vt1.Trunc;
  AssertEquals('Trunc:Sub5 X failed ', 1, a4it4.X);
  AssertEquals('Trunc:Sub6 Y failed ', 2, a4it4.Y);
  AssertEquals('Trunc:Sub7 Z failed ', 3, a4it4.Z);
  AssertEquals('Trunc:Sub8 W failed ', 4, a4it4.W);
  vt1.Create(1.25,2.25,3.25,4.25);
  a4it4 := vt1.Round;
  AssertEquals('Trunc:Sub9 X failed ',  1, a4it4.X);
  AssertEquals('Trunc:Sub10 Y failed ', 2, a4it4.Y);
  AssertEquals('Trunc:Sub11 Z failed ', 3, a4it4.Z);
  AssertEquals('Trunc:Sub12 W failed ', 4, a4it4.W);
end;


initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVector4fFunctionalTest);
end.

