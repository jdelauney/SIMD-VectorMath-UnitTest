unit Vector4bFunctionalTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  TVector4bFunctionalTest = class(TByteVectorBaseTestCase)
    published
      procedure TestCreateBytes;
      procedure TestCreatefrom3b;
      procedure TestOpAdd;
      procedure TestOpAddByte;
      procedure TestOpSub;
      procedure TestOpSubByte;
      procedure TestOpMul;
      procedure TestOpMulByte;
      procedure TestOpMulSingle;
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
      procedure TestMin;
      procedure TestMinByte;
      procedure TestMax;
      procedure TestMaxByte;
      procedure TestClamp;
      procedure TestClampByte;
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

procedure TVector4bFunctionalTest.TestCreateBytes;
begin
  abf1.Create(1,2,3);
  AssertEquals('Create:Sub1 X failed ', 1, abf1.X);
  AssertEquals('Create:Sub2 Y failed ', 2, abf1.Y);
  AssertEquals('Create:Sub3 Z failed ', 3, abf1.Z);
  AssertEquals('Create:Sub4 W failed ', 255, abf1.W);
  AssertEquals('Create:Sub5 X failed ', 1, abf1.Red);
  AssertEquals('Create:Sub6 Y failed ', 2, abf1.Green);
  AssertEquals('Create:Sub7 Z failed ', 3, abf1.Blue);
  AssertEquals('Create:Sub8 W failed ', 255, abf1.Alpha);
  abf1.Create(1,2,3,4);
  AssertEquals('Create:Sub9 X failed ', 1, abf1.X);
  AssertEquals('Create:Sub10 Y failed ', 2, abf1.Y);
  AssertEquals('Create:Sub11 Z failed ', 3, abf1.Z);
  AssertEquals('Create:Sub12 W failed ', 4, abf1.W);
  abt1 := abf1.AsVector3b;
  AssertEquals('Create:AsVector3b:Sub13 X failed ', 1, abt1.X);
  AssertEquals('Create:AsVector3b:Sub14 Y failed ', 2, abt1.Y);
  AssertEquals('Create:AsVector3b:Sub15 Z failed ', 3, abt1.Z);
  AssertEquals('Create:AsInterger:Sub16 failed ', $04030201, abf1.AsInteger);
end;

procedure TVector4bFunctionalTest.TestCreatefrom3b;
begin
  abt1.Create(1,2,3);
  abf1.Create(abt1);
  AssertEquals('CreateVec3b:Sub1 X failed ', 1, abf1.X);
  AssertEquals('CreateVec3b:Sub2 Y failed ', 2, abf1.Y);
  AssertEquals('CreateVec3b:Sub3 Z failed ', 3, abf1.Z);
  AssertEquals('CreateVec3b:Sub4 W failed ', 255, abf1.W);
  abf1.Create(abt1,4);
  AssertEquals('CreateVec3b:Sub5 X failed ', 1, abf1.X);
  AssertEquals('CreateVec3b:Sub6 Y failed ', 2, abf1.Y);
  AssertEquals('CreateVec3b:Sub7 Z failed ', 3, abf1.Z);
  AssertEquals('CreateVec3b:Sub8 W failed ', 4, abf1.W);
end;

procedure TVector4bFunctionalTest.TestOpAdd;
begin
  abf1.Create(1,2,3,4);
  abf2.Create(4,3,2,1);
  abf3 := abf1 + abf2;
  AssertEquals('OpAdd:Sub1 X failed ', 5, abf3.X);
  AssertEquals('OpAdd:Sub2 Y failed ', 5, abf3.Y);
  AssertEquals('OpAdd:Sub3 Z failed ', 5, abf3.Z);
  AssertEquals('OpAdd:Sub4 W failed ', 5, abf3.W);
  abf3 := abf2 + abf1;
  AssertEquals('OpAdd:Sub5 X failed ', 5, abf3.X);
  AssertEquals('OpAdd:Sub6 Y failed ', 5, abf3.Y);
  AssertEquals('OpAdd:Sub7 Z failed ', 5, abf3.Z);
  AssertEquals('OpAdd:Sub8 W failed ', 5, abf3.W);
  abf1.Create(210,222,233,244);
  abf2.Create(4,50,15,60);
  abf3 := abf1 + abf2;
  AssertEquals('OpAdd:Sub9 X failed ', 214, abf3.X);
  AssertEquals('OpAdd:Sub10 Y failed ', 255, abf3.Y);
  AssertEquals('OpAdd:Sub11 Z failed ', 248, abf3.Z);
  AssertEquals('OpAdd:Sub12 W failed ', 255, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpAddByte;
begin
  abf1.Create(210,222,233,244);
  abf3 := abf1 + 6;
  AssertEquals('OpAddByte:Sub1 X failed ', 216, abf3.X);
  AssertEquals('OpAddByte:Sub2 Y failed ', 228, abf3.Y);
  AssertEquals('OpAddByte:Sub3 Z failed ', 239, abf3.Z);
  AssertEquals('OpAddByte:Sub4 W failed ', 250, abf3.W);
  abf3 := abf1 + 30;
  AssertEquals('OpAddByte:Sub5 X failed ', 240, abf3.X);
  AssertEquals('OpAddByte:Sub6 Y failed ', 252, abf3.Y);
  AssertEquals('OpAddByte:Sub7 Z failed ', 255, abf3.Z);
  AssertEquals('OpAddByte:Sub8 W failed ', 255, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpSub;
begin
  abf1.Create(210,222,233,244);
  abf2.Create(10,22,33,44);
  abf3 := abf1 - abf2;
  AssertEquals('OpSub:Sub1 X failed ', 200, abf3.X);
  AssertEquals('OpSub:Sub2 Y failed ', 200, abf3.Y);
  AssertEquals('OpSub:Sub3 Z failed ', 200, abf3.Z);
  AssertEquals('OpSub:Sub4 W failed ', 200, abf3.W);
  abf3 := abf2 - abf1;
  AssertEquals('OpSub:Sub5 X failed ', 0, abf3.X);
  AssertEquals('OpSub:Sub6 Y failed ', 0, abf3.Y);
  AssertEquals('OpSub:Sub7 Z failed ', 0, abf3.Z);
  AssertEquals('OpSub:Sub8 W failed ', 0, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpSubByte;
begin
  abf1.Create(10,22,33,44);
  abf3 := abf1 - 5;
  AssertEquals('OpSubByte:Sub1 X failed ',  5, abf3.X);
  AssertEquals('OpSubByte:Sub2 Y failed ', 17, abf3.Y);
  AssertEquals('OpSubByte:Sub3 Z failed ', 28, abf3.Z);
  AssertEquals('OpSubByte:Sub4 W failed ', 39, abf3.W);
  abf3 := abf1 - 50;
  AssertEquals('OpSubByte:Sub5 X failed ',  0, abf3.X);
  AssertEquals('OpSubByte:Sub6 Y failed ',  0, abf3.Y);
  AssertEquals('OpSubByte:Sub7 Z failed ',  0, abf3.Z);
  AssertEquals('OpSubByte:Sub8 W failed ',  0, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpMul;
begin
  b4 := 10;
  abf1.Create(10,20,30,40);
  abf2.Create(4,3,2,1);
  abf3 := abf1 * abf2;
  AssertEquals('OpMul:Sub1 X failed ', 40, abf3.X);
  AssertEquals('OpMul:Sub2 Y failed ', 60, abf3.Y);
  AssertEquals('OpMul:Sub3 Z failed ', 60, abf3.Z);
  AssertEquals('OpMul:Sub4 W failed ', 40, abf3.W);
  abf2 := abf2 * b4;
  abf3 := abf1 * abf2;
  AssertEquals('OpMul:Sub5 X failed ', 255, abf3.X);
  AssertEquals('OpMul:Sub6 Y failed ', 255, abf3.Y);
  AssertEquals('OpMul:Sub7 Z failed ', 255, abf3.Z);
  AssertEquals('OpMul:Sub8 W failed ', 255, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpMulByte;
begin
  b4 := 5;
  abf1.Create(10,20,30,40);
  abf3 := abf1 * b4;
  AssertEquals('OpMulByte:Sub1 X failed ',  50, abf3.X);
  AssertEquals('OpMulByte:Sub2 Y failed ', 100, abf3.Y);
  AssertEquals('OpMulByte:Sub3 Z failed ', 150, abf3.Z);
  AssertEquals('OpMulByte:Sub4 W failed ', 200, abf3.W);
  b4 := 30;
  abf3 := abf1 * b4;
  AssertEquals('OpMulByte:Sub5 X failed ', 255, abf3.X);
  AssertEquals('OpMulByte:Sub6 Y failed ', 255, abf3.Y);
  AssertEquals('OpMulByte:Sub7 Z failed ', 255, abf3.Z);
  AssertEquals('OpMulByte:Sub8 W failed ', 255, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpMulSingle;
begin
  abf1.Create(10,20,30,40);
  abf3 := abf1 * 5.0;
  AssertEquals('OpMulSingle:Sub1 X failed ',  50, abf3.X);
  AssertEquals('OpMulSingle:Sub2 Y failed ', 100, abf3.Y);
  AssertEquals('OpMulSingle:Sub3 Z failed ', 150, abf3.Z);
  AssertEquals('OpMulSingle:Sub4 W failed ', 200, abf3.W);
  abf3 := abf1 * 30.0;
  AssertEquals('OpMulSingle:Sub5 X failed ', 255, abf3.X);
  AssertEquals('OpMulSingle:Sub6 Y failed ', 255, abf3.Y);
  AssertEquals('OpMulSingle:Sub7 Z failed ', 255, abf3.Z);
  AssertEquals('OpMulSingle:Sub8 W failed ', 255, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpDiv;
begin
  abf1.Create(180,120,60,240);
  abf2.Create(6,5,4,3);  // will produce whole divisors
  abf3 := abf1 div abf2;
  AssertEquals('OpDiv:Sub1 X failed ',  30, abf3.X);
  AssertEquals('OpDiv:Sub2 Y failed ',  24, abf3.Y);
  AssertEquals('OpDiv:Sub3 Z failed ',  15, abf3.Z);
  AssertEquals('OpDiv:Sub4 W failed ',  80, abf3.W);
  abf2.Create(17,11,9,23);  // will produce result > 0.5
  abf3 := abf1 div abf2;    //  10.5882,10.90909,6.6666,26.8919
  AssertEquals('OpDiv:Sub5 X failed ',  10, abf3.X);
  AssertEquals('OpDiv:Sub6 Y failed ',  10, abf3.Y);
  AssertEquals('OpDiv:Sub7 Z failed ',   6, abf3.Z);
  AssertEquals('OpDiv:Sub8 W failed ',  10, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpDivByte;
begin
  abf1.Create(180,120,60,240);
  b4 := 6;
  abf3 := abf1 div b4;
  AssertEquals('OpDivByte:Sub1 X failed ',  30, abf3.X);
  AssertEquals('OpDivByte:Sub2 Y failed ',  20, abf3.Y);
  AssertEquals('OpDivByte:Sub3 Z failed ',  10, abf3.Z);
  AssertEquals('OpDivByte:Sub4 W failed ',  40, abf3.W);
  b4 := 17;
  abf3 := abf1 div b4;
  AssertEquals('OpDivByte:Sub1 X failed ',  10, abf3.X);
  AssertEquals('OpDivByte:Sub2 Y failed ',   7, abf3.Y);
  AssertEquals('OpDivByte:Sub3 Z failed ',   3, abf3.Z);
  AssertEquals('OpDivByte:Sub4 W failed ',  14, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpEquality;
begin
  abf1.Create(180,120,60,240);
  abf2.Create(180,120,60,240);
  ab := abf1 = abf2;
  AssertEquals('OpEquality:Sub1 does not match ',   True, ab);
  abf2.Create(180,120,60,241);
  ab := abf1 = abf2;
  AssertEquals('OpEquality:Sub2 should not match ', False, ab);
  abf2.Create(180,120,61,240);
  ab := abf1 = abf2;
  AssertEquals('OpEquality:Sub3 should not match ', False, ab);
  abf2.Create(180,121,60,240);
  ab := abf1 = abf2;
  AssertEquals('OpEquality:Sub4 should not match ', False, ab);
  abf2.Create(181,120,60,240);
  ab := abf1 = abf2;
  AssertEquals('OpEquality:Sub5 should not match ', False, ab);
end;

procedure TVector4bFunctionalTest.TestOpNotEquals;
begin
  abf1.Create(180,120,60,240);
  abf2.Create(180,120,60,240);
  ab := abf1 <> abf2;
  AssertEquals('OpNotEquals:Sub1 should not match ', False, ab);
  abf2.Create(180,120,60,241);
  ab := abf1 <> abf2;
  AssertEquals('OpNotEquals:Sub2 does not match ',   True, ab);
  abf2.Create(180,120,61,240);
  ab := abf1 <> abf2;
  AssertEquals('OpNotEquals:Sub3 does not match ',   True, ab);
  abf2.Create(180,121,60,240);
  ab := abf1 <> abf2;
  AssertEquals('OpNotEquals:Sub4 does not match ',   True, ab);
  abf2.Create(181,120,60,240);
  ab := abf1 <> abf2;
  AssertEquals('OpNotEquals:Sub5 does not match ',   True, ab);
end;

procedure TVector4bFunctionalTest.TestOpAnd;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abf1.Create(b1,b2,b3,b4);
  abf2.Create(b1,b1,b1,b1);
  abf3 := abf1 and abf2;
  AssertEquals('OpAnd:Sub1 X failed ',  b1, abf3.X);
  AssertEquals('OpAnd:Sub2 Y failed ',  b4, abf3.Y);
  AssertEquals('OpAnd:Sub3 Z failed ',  b1, abf3.Z);
  AssertEquals('OpAnd:Sub4 W failed ',  b4, abf3.W);
  abf2.Create(b2,b2,b2,b2);
  abf3 := abf1 and abf2;
  AssertEquals('OpAnd:Sub5 X failed ',  b4, abf3.X);
  AssertEquals('OpAnd:Sub6 Y failed ',  b2, abf3.Y);
  AssertEquals('OpAnd:Sub7 Z failed ',  b2, abf3.Z);
  AssertEquals('OpAnd:Sub8 W failed ',  b4, abf3.W);
  abf2.Create(b3,b3,b3,b3);
  abf3 := abf1 and abf2;
  AssertEquals('OpAnd:Sub9 X failed ',   b1, abf3.X);
  AssertEquals('OpAnd:Sub10 Y failed ',  b2, abf3.Y);
  AssertEquals('OpAnd:Sub11 Z failed ',  b3, abf3.Z);
  AssertEquals('OpAnd:Sub12 W failed ',  b4, abf3.W);
  abf2.Create(b4,b4,b4,b4);
  abf3 := abf1 and abf2;
  AssertEquals('OpAnd:Sub13 X failed ',  b4, abf3.X);
  AssertEquals('OpAnd:Sub14 Y failed ',  b4, abf3.Y);
  AssertEquals('OpAnd:Sub15 Z failed ',  b4, abf3.Z);
  AssertEquals('OpAnd:Sub16 W failed ',  b4, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpAndByte;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abf1.Create(b1,b2,b3,b4);
  abf3 := abf1 and b1;
  AssertEquals('OpAndByte:Sub1 X failed ',  b1, abf3.X);
  AssertEquals('OpAndByte:Sub2 Y failed ',  b4, abf3.Y);
  AssertEquals('OpAndByte:Sub3 Z failed ',  b1, abf3.Z);
  AssertEquals('OpAndByte:Sub4 W failed ',  b4, abf3.W);
  abf3 := abf1 and b2;
  AssertEquals('OpAndByte:Sub5 X failed ',  b4, abf3.X);
  AssertEquals('OpAndByte:Sub6 Y failed ',  b2, abf3.Y);
  AssertEquals('OpAndByte:Sub7 Z failed ',  b2, abf3.Z);
  AssertEquals('OpAndByte:Sub8 W failed ',  b4, abf3.W);
  abf3 := abf1 and b3;
  AssertEquals('OpAndByte:Sub9 X failed ',   b1, abf3.X);
  AssertEquals('OpAndByte:Sub10 Y failed ',  b2, abf3.Y);
  AssertEquals('OpAndByte:Sub11 Z failed ',  b3, abf3.Z);
  AssertEquals('OpAndByte:Sub12 W failed ',  b4, abf3.W);
  abf3 := abf1 and b4;
  AssertEquals('OpAndByte:Sub13 X failed ',  b4, abf3.X);
  AssertEquals('OpAndByte:Sub14 Y failed ',  b4, abf3.Y);
  AssertEquals('OpAndByte:Sub15 Z failed ',  b4, abf3.Z);
  AssertEquals('OpAndByte:Sub16 W failed ',  b4, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpOr;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abf1.Create(b1,b2,b3,b4);
  abf2.Create(b1,b1,b1,b1);
  abf3 := abf1 or abf2;
  AssertEquals('OpOr:Sub1 X failed ',  b1, abf3.X);
  AssertEquals('OpOr:Sub2 Y failed ',  b3, abf3.Y);
  AssertEquals('OpOr:Sub3 Z failed ',  b3, abf3.Z);
  AssertEquals('OpOr:Sub4 W failed ',  b1, abf3.W);
  abf2.Create(b2,b2,b2,b2);
  abf3 := abf1 or abf2;
  AssertEquals('OpOr:Sub5 X failed ',  b3, abf3.X);
  AssertEquals('OpOr:Sub6 Y failed ',  b2, abf3.Y);
  AssertEquals('OpOr:Sub7 Z failed ',  b3, abf3.Z);
  AssertEquals('OpOr:Sub8 W failed ',  b2, abf3.W);
  abf2.Create(b3,b3,b3,b3);
  abf3 := abf1 or abf2;
  AssertEquals('OpOr:Sub9 X failed ',   b3, abf3.X);
  AssertEquals('OpOr:Sub10 Y failed ',  b3, abf3.Y);
  AssertEquals('OpOr:Sub11 Z failed ',  b3, abf3.Z);
  AssertEquals('OpOr:Sub12 W failed ',  b3, abf3.W);
  abf2.Create(b4,b4,b4,b4);
  abf3 := abf1 or abf2;
  AssertEquals('OpOr:Sub13 X failed ',  b1, abf3.X);
  AssertEquals('OpOr:Sub14 Y failed ',  b2, abf3.Y);
  AssertEquals('OpOr:Sub15 Z failed ',  b3, abf3.Z);
  AssertEquals('OpOr:Sub16 W failed ',  b4, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpOrByte;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abf1.Create(b1,b2,b3,b4);
  abf3 := abf1 or b1;
  AssertEquals('OpOrByte:Sub1 X failed ',  b1, abf3.X);
  AssertEquals('OpOrByte:Sub2 Y failed ',  b3, abf3.Y);
  AssertEquals('OpOrByte:Sub3 Z failed ',  b3, abf3.Z);
  AssertEquals('OpOrByte:Sub4 W failed ',  b1, abf3.W);
  abf3 := abf1 or b2;
  AssertEquals('OpOrByte:Sub5 X failed ',  b3, abf3.X);
  AssertEquals('OpOrByte:Sub6 Y failed ',  b2, abf3.Y);
  AssertEquals('OpOrByte:Sub7 Z failed ',  b3, abf3.Z);
  AssertEquals('OpOrByte:Sub8 W failed ',  b2, abf3.W);
  abf3 := abf1 or b3;
  AssertEquals('OpOrByte:Sub9 X failed ',   b3, abf3.X);
  AssertEquals('OpOrByte:Sub10 Y failed ',  b3, abf3.Y);
  AssertEquals('OpOrByte:Sub11 Z failed ',  b3, abf3.Z);
  AssertEquals('OpOrByte:Sub12 W failed ',  b3, abf3.W);
  abf3 := abf1 or b4;
  AssertEquals('OpOrByte:Sub13 X failed ',  b1, abf3.X);
  AssertEquals('OpOrByte:Sub14 Y failed ',  b2, abf3.Y);
  AssertEquals('OpOrByte:Sub15 Z failed ',  b3, abf3.Z);
  AssertEquals('OpOrByte:Sub16 W failed ',  b4, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpXor;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abf1.Create(b1,b2,b3,b4);
  abf2.Create(b1,b1,b1,b1);
  abf3 := abf1 xor abf2;
  AssertEquals('OpXor:Sub1 X failed ',  b4, abf3.X);
  AssertEquals('OpXor:Sub2 Y failed ',  b3, abf3.Y);
  AssertEquals('OpXor:Sub3 Z failed ',  b2, abf3.Z);
  AssertEquals('OpXor:Sub4 W failed ',  b1, abf3.W);
  abf2.Create(b2,b2,b2,b2);
  abf3 := abf1 xor abf2;
  AssertEquals('OpXor:Sub5 X failed ',  b3, abf3.X);
  AssertEquals('OpXor:Sub6 Y failed ',  b4, abf3.Y);
  AssertEquals('OpXor:Sub7 Z failed ',  b1, abf3.Z);
  AssertEquals('OpXor:Sub8 W failed ',  b2, abf3.W);
  abf2.Create(b3,b3,b3,b3);
  abf3 := abf1 xor abf2;
  AssertEquals('OpXor:Sub9 X failed ',   b2, abf3.X);
  AssertEquals('OpXor:Sub10 Y failed ',  b1, abf3.Y);
  AssertEquals('OpXor:Sub11 Z failed ',  b4, abf3.Z);
  AssertEquals('OpXor:Sub12 W failed ',  b3, abf3.W);
  abf2.Create(b4,b4,b4,b4);
  abf3 := abf1 xor abf2;
  AssertEquals('OpXor:Sub13 X failed ',  b1, abf3.X);
  AssertEquals('OpXor:Sub14 Y failed ',  b2, abf3.Y);
  AssertEquals('OpXor:Sub15 Z failed ',  b3, abf3.Z);
  AssertEquals('OpXor:Sub16 W failed ',  b4, abf3.W);
end;

procedure TVector4bFunctionalTest.TestOpXorByte;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abf1.Create(b1,b2,b3,b4);
  abf3 := abf1 xor b1;
  AssertEquals('OpXorByte:Sub1 X failed ',  b4, abf3.X);
  AssertEquals('OpXorByte:Sub2 Y failed ',  b3, abf3.Y);
  AssertEquals('OpXorByte:Sub3 Z failed ',  b2, abf3.Z);
  AssertEquals('OpXorByte:Sub4 W failed ',  b1, abf3.W);
  abf3 := abf1 xor b2;
  AssertEquals('OpXorByte:Sub5 X failed ',  b3, abf3.X);
  AssertEquals('OpXorByte:Sub6 Y failed ',  b4, abf3.Y);
  AssertEquals('OpXorByte:Sub7 Z failed ',  b1, abf3.Z);
  AssertEquals('OpXorByte:Sub8 W failed ',  b2, abf3.W);
  abf3 := abf1 xor b3;
  AssertEquals('OpXorByte:Sub9 X failed ',   b2, abf3.X);
  AssertEquals('OpXorByte:Sub10 Y failed ',  b1, abf3.Y);
  AssertEquals('OpXorByte:Sub11 Z failed ',  b4, abf3.Z);
  AssertEquals('OpXorByte:Sub12 W failed ',  b3, abf3.W);
  abf3 := abf1 xor b4;
  AssertEquals('OpXorByte:Sub13 X failed ',  b1, abf3.X);
  AssertEquals('OpXorByte:Sub14 Y failed ',  b2, abf3.Y);
  AssertEquals('OpXorByte:Sub15 Z failed ',  b3, abf3.Z);
  AssertEquals('OpXorByte:Sub16 W failed ',  b4, abf3.W);
end;

procedure TVector4bFunctionalTest.TestDivideBy2;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abf1.Create(b1,b2,b3,b4);
  abf3 := abf1.DivideBy2;
  AssertEquals('OpXorByte:Sub1 X failed ',  b2,       abf3.X);
  AssertEquals('OpXorByte:Sub2 Y failed ',  b2 shr 1, abf3.Y);
  AssertEquals('OpXorByte:Sub3 Z failed ',  127,      abf3.Z);
  AssertEquals('OpXorByte:Sub4 W failed ',  b4,       abf3.W);
end;

procedure TVector4bFunctionalTest.TestMin;
begin
  abf1.Create(80,80,80,80);
  abf2.Create(90,70,90,70);
  abf3 := abf1.Min(abf2);
  AssertEquals('Min:Sub1 X failed ',  80, abf3.X);
  AssertEquals('Min:Sub2 Y failed ',  70, abf3.Y);
  AssertEquals('Min:Sub3 Z failed ',  80, abf3.Z);
  AssertEquals('Min:Sub4 W failed ',  70, abf3.W);
  abf2.Create(70,90,70,90);
  abf3 := abf1.Min(abf2);
  AssertEquals('Min:Sub5 X failed ',  70, abf3.X);
  AssertEquals('Min:Sub6 Y failed ',  80, abf3.Y);
  AssertEquals('Min:Sub7 Z failed ',  70, abf3.Z);
  AssertEquals('Min:Sub8 W failed ',  80, abf3.W);
end;

procedure TVector4bFunctionalTest.TestMinByte;
begin
  abf1.Create(90,70,90,70);
  abf3 := abf1.Min(80);
  AssertEquals('MinByte:Sub1 X failed ',  80, abf3.X);
  AssertEquals('MinByte:Sub2 Y failed ',  70, abf3.Y);
  AssertEquals('MinByte:Sub3 Z failed ',  80, abf3.Z);
  AssertEquals('MinByte:Sub4 W failed ',  70, abf3.W);
  abf1.Create(70,90,70,90);
  abf3 := abf1.Min(80);
  AssertEquals('MinByte:Sub5 X failed ',  70, abf3.X);
  AssertEquals('MinByte:Sub6 Y failed ',  80, abf3.Y);
  AssertEquals('MinByte:Sub7 Z failed ',  70, abf3.Z);
  AssertEquals('MinByte:Sub8 W failed ',  80, abf3.W);
end;

procedure TVector4bFunctionalTest.TestMax;
begin
  abf1.Create(80,80,80,80);
  abf2.Create(90,70,90,70);
  abf3 := abf1.Max(abf2);
  AssertEquals('Max:Sub1 X failed ',  90, abf3.X);
  AssertEquals('Max:Sub2 Y failed ',  80, abf3.Y);
  AssertEquals('Max:Sub3 Z failed ',  90, abf3.Z);
  AssertEquals('Max:Sub4 W failed ',  80, abf3.W);
  abf2.Create(70,90,70,90);
  abf3 := abf1.Max(abf2);
  AssertEquals('Max:Sub5 X failed ',  80, abf3.X);
  AssertEquals('Max:Sub6 Y failed ',  90, abf3.Y);
  AssertEquals('Max:Sub7 Z failed ',  80, abf3.Z);
  AssertEquals('Max:Sub8 W failed ',  90, abf3.W);
end;

procedure TVector4bFunctionalTest.TestMaxByte;
begin
  abf1.Create(90,70,90,70);
  abf3 := abf1.Max(80);
  AssertEquals('Max:Sub1 X failed ',  90, abf3.X);
  AssertEquals('Max:Sub2 Y failed ',  80, abf3.Y);
  AssertEquals('Max:Sub3 Z failed ',  90, abf3.Z);
  AssertEquals('Max:Sub4 W failed ',  80, abf3.W);
  abf1.Create(70,90,70,90);
  abf3 := abf1.Max(80);
  AssertEquals('Max:Sub5 X failed ',  80, abf3.X);
  AssertEquals('Max:Sub6 Y failed ',  90, abf3.Y);
  AssertEquals('Max:Sub7 Z failed ',  80, abf3.Z);
  AssertEquals('Max:Sub8 W failed ',  90, abf3.W);
end;

procedure TVector4bFunctionalTest.TestClamp;
begin
  abf2.Create(50,50,50,50);
  abf4.Create(150,150,150,150);
  abf1.Create(100,200,100,200);
  abf3 := abf1.Clamp(abf2,abf4);
  AssertEquals('Clamp:Sub1 X failed ', 100, abf3.X);
  AssertEquals('Clamp:Sub2 Y failed ', 150, abf3.Y);
  AssertEquals('Clamp:Sub3 Z failed ', 100, abf3.Z);
  AssertEquals('Clamp:Sub4 W failed ', 150, abf3.W);
  abf1.Create(200,100,200,100);
  abf3 := abf1.Clamp(abf2,abf4);
  AssertEquals('Clamp:Sub5 X failed ', 150, abf3.X);
  AssertEquals('Clamp:Sub6 Y failed ', 100, abf3.Y);
  AssertEquals('Clamp:Sub7 Z failed ', 150, abf3.Z);
  AssertEquals('Clamp:Sub8 W failed ', 100, abf3.W);
  abf1.Create(20,100,20,100);
  abf3 := abf1.Clamp(abf2,abf4);
  AssertEquals('Clamp:Sub9 X failed ',  50, abf3.X);
  AssertEquals('Clamp:Sub10 Y failed ', 100, abf3.Y);
  AssertEquals('Clamp:Sub11 Z failed ',  50, abf3.Z);
  AssertEquals('Clamp:Sub12 W failed ', 100, abf3.W);
  abf1.Create(100,20,100,20);
  abf3 := abf1.Clamp(abf2,abf4);
  AssertEquals('Clamp:Sub13 X failed ', 100, abf3.X);
  AssertEquals('Clamp:Sub14 Y failed ',  50, abf3.Y);
  AssertEquals('Clamp:Sub15 Z failed ', 100, abf3.Z);
  AssertEquals('Clamp:Sub16 W failed ',  50, abf3.W);
end;

procedure TVector4bFunctionalTest.TestClampByte;
begin
  b2 :=50;
  b4 := 150;
  abf1.Create(100,200,100,200);
  abf3 := abf1.Clamp(b2,b4);
  AssertEquals('ClampByte:Sub1 X failed ', 100, abf3.X);
  AssertEquals('ClampByte:Sub2 Y failed ', 150, abf3.Y);
  AssertEquals('ClampByte:Sub3 Z failed ', 100, abf3.Z);
  AssertEquals('ClampByte:Sub4 W failed ', 150, abf3.W);
  abf1.Create(200,100,200,100);
  abf3 := abf1.Clamp(b2,b4);
  AssertEquals('ClampByte:Sub5 X failed ', 150, abf3.X);
  AssertEquals('ClampByte:Sub6 Y failed ', 100, abf3.Y);
  AssertEquals('ClampByte:Sub7 Z failed ', 150, abf3.Z);
  AssertEquals('ClampByte:Sub8 W failed ', 100, abf3.W);
  abf1.Create(20,100,20,100);
  abf3 := abf1.Clamp(b2,b4);
  AssertEquals('ClampByte:Sub9 X failed ',  50, abf3.X);
  AssertEquals('ClampByte:Sub10 Y failed ', 100, abf3.Y);
  AssertEquals('ClampByte:Sub11 Z failed ',  50, abf3.Z);
  AssertEquals('ClampByte:Sub12 W failed ', 100, abf3.W);
  abf1.Create(100,20,100,20);
  abf3 := abf1.Clamp(b2,b4);
  AssertEquals('ClampByte:Sub13 X failed ', 100, abf3.X);
  AssertEquals('ClampByte:Sub14 Y failed ',  50, abf3.Y);
  AssertEquals('ClampByte:Sub15 Z failed ', 100, abf3.Z);
  AssertEquals('ClampByte:Sub16 W failed ',  50, abf3.W);
end;

procedure TVector4bFunctionalTest.TestMulAdd;
begin
  abf1.Create(1,2,3,4);
  abf2.Create(4,3,2,1);
  abf4.Create(90,70,90,70);
  abf3 := abf1.MulAdd(abf2,abf4);
  AssertEquals('MulAdd:Sub1 X failed ', 94, abf3.X);
  AssertEquals('MulAdd:Sub2 Y failed ', 76, abf3.Y);
  AssertEquals('MulAdd:Sub3 Z failed ', 96, abf3.Z);
  AssertEquals('MulAdd:Sub4 W failed ', 74, abf3.W);
  abf3 := abf1.MulAdd(abf4,abf2);
  AssertEquals('MulAdd:Sub5 X failed ',  94, abf3.X);
  AssertEquals('MulAdd:Sub6 Y failed ', 143, abf3.Y);
  AssertEquals('MulAdd:Sub7 Z failed ', 255, abf3.Z);
  AssertEquals('MulAdd:Sub8 W failed ', 255, abf3.W);
  abf3 := abf2.MulAdd(abf4,abf1);
  AssertEquals('MulAdd:Sub9 X failed ',  255, abf3.X);
  AssertEquals('MulAdd:Sub10 Y failed ', 212, abf3.Y);
  AssertEquals('MulAdd:Sub11 Z failed ', 183, abf3.Z);
  AssertEquals('MulAdd:Sub12 W failed ',  74, abf3.W);
end;

procedure TVector4bFunctionalTest.TestMulDiv;
begin
  abf1.Create(90,80,70,60);
  abf2.Create(10,10,10,10);
  abf4.Create(9,9,9,9);
  abf3 := abf1.MulDiv(abf2,abf4);
  AssertEquals('MulDiv:Sub1 X failed ', 100, abf3.X);
  AssertEquals('MulDiv:Sub2 Y failed ',  88, abf3.Y);
  AssertEquals('MulDiv:Sub3 Z failed ',  77, abf3.Z);
  AssertEquals('MulDiv:Sub4 W failed ',  66, abf3.W);
  abf4.Create(2,2,2,2);
  abf3 := abf1.MulDiv(abf2,abf4);
  AssertEquals('MulDiv:Sub1 X failed ', 255, abf3.X);
  AssertEquals('MulDiv:Sub2 Y failed ', 255, abf3.Y);
  AssertEquals('MulDiv:Sub3 Z failed ', 255, abf3.Z);
  AssertEquals('MulDiv:Sub4 W failed ', 255, abf3.W);
end;

procedure TVector4bFunctionalTest.TestShuffle;
begin
  abf1.Create(1,2,3,4);
  abf3 := abf1.Shuffle(0,0,0,0); //|X|X|X|X|
  AssertEquals('Shuffle:Sub1 X failed ', 1, abf3.X);
  AssertEquals('Shuffle:Sub2 Y failed ', 1, abf3.Y);
  AssertEquals('Shuffle:Sub3 Z failed ', 1, abf3.Z);
  AssertEquals('Shuffle:Sub4 W failed ', 1, abf3.W);
  abf3 := abf1.Shuffle(0,0,3,3); //|X|X|W|W|
  AssertEquals('Shuffle:Sub5 X failed ', 1, abf3.X);
  AssertEquals('Shuffle:Sub6 Y failed ', 1, abf3.Y);
  AssertEquals('Shuffle:Sub7 Z failed ', 4, abf3.Z);
  AssertEquals('Shuffle:Sub8 W failed ', 4, abf3.W);
  abf3 := abf1.Shuffle(1,1,1,3); //|Y|Y|Y|W|
  AssertEquals('Shuffle:Sub9 X failed ', 2, abf3.X);
  AssertEquals('Shuffle:Sub10 Y failed ', 2, abf3.Y);
  AssertEquals('Shuffle:Sub11 Z failed ', 2, abf3.Z);
  AssertEquals('Shuffle:Sub12 W failed ', 4, abf3.W);
end;

procedure TVector4bFunctionalTest.TestSwizzle;
begin
  abf1.Create(1,2,3,4);
  abf3 := abf1.Swizzle(swXXXX);
  AssertEquals('Swizzle:Sub1 X failed ', 1, abf3.X);
  AssertEquals('Swizzle:Sub2 Y failed ', 1, abf3.Y);
  AssertEquals('Swizzle:Sub3 Z failed ', 1, abf3.Z);
  AssertEquals('Swizzle:Sub4 W failed ', 1, abf3.W);
  abf3 := abf1.Swizzle(swYYYY);
  AssertEquals('Swizzle:Sub5 X failed ', 2, abf3.X);
  AssertEquals('Swizzle:Sub6 Y failed ', 2, abf3.Y);
  AssertEquals('Swizzle:Sub7 Z failed ', 2, abf3.Z);
  AssertEquals('Swizzle:Sub8 W failed ', 2, abf3.W);
  abf3 := abf1.Swizzle(swZZZZ);
  AssertEquals('Swizzle:Sub9 X failed ',  3, abf3.X);
  AssertEquals('Swizzle:Sub10 Y failed ', 3, abf3.Y);
  AssertEquals('Swizzle:Sub11 Z failed ', 3, abf3.Z);
  AssertEquals('Swizzle:Sub12 W failed ', 3, abf3.W);
  abf3 := abf1.Swizzle(swWWWW);
  AssertEquals('Swizzle:Sub13 X failed ', 4, abf3.X);
  AssertEquals('Swizzle:Sub14 Y failed ', 4, abf3.Y);
  AssertEquals('Swizzle:Sub15 Z failed ', 4, abf3.Z);
  AssertEquals('Swizzle:Sub16 W failed ', 4, abf3.W);
  abf3 := abf1.Swizzle(swXYZW);
  AssertEquals('Swizzle:Sub17 X failed ', 1, abf3.X);
  AssertEquals('Swizzle:Sub18 Y failed ', 2, abf3.Y);
  AssertEquals('Swizzle:Sub19 Z failed ', 3, abf3.Z);
  AssertEquals('Swizzle:Sub20 W failed ', 4, abf3.W);
  abf3 := abf1.Swizzle(swXZYW);
  AssertEquals('Swizzle:Sub21 X failed ', 1, abf3.X);
  AssertEquals('Swizzle:Sub22 Y failed ', 3, abf3.Y);
  AssertEquals('Swizzle:Sub23 Z failed ', 2, abf3.Z);
  AssertEquals('Swizzle:Sub24 W failed ', 4, abf3.W);
  abf3 := abf1.Swizzle(swZYXW);
  AssertEquals('Swizzle:Sub21 X failed ', 3, abf3.X);
  AssertEquals('Swizzle:Sub22 Y failed ', 2, abf3.Y);
  AssertEquals('Swizzle:Sub23 Z failed ', 1, abf3.Z);
  AssertEquals('Swizzle:Sub24 W failed ', 4, abf3.W);
  abf3 := abf1.Swizzle(swZXYW);
  AssertEquals('Swizzle:Sub25 X failed ', 3, abf3.X);
  AssertEquals('Swizzle:Sub26 Y failed ', 1, abf3.Y);
  AssertEquals('Swizzle:Sub27 Z failed ', 2, abf3.Z);
  AssertEquals('Swizzle:Sub28 W failed ', 4, abf3.W);
  abf3 := abf1.Swizzle(swYXZW);
  AssertEquals('Swizzle:Sub29 X failed ', 2, abf3.X);
  AssertEquals('Swizzle:Sub30 Y failed ', 1, abf3.Y);
  AssertEquals('Swizzle:Sub31 Z failed ', 3, abf3.Z);
  AssertEquals('Swizzle:Sub32 W failed ', 4, abf3.W);
  abf3 := abf1.Swizzle(swYZXW);
  AssertEquals('Swizzle:Sub33 X failed ', 2, abf3.X);
  AssertEquals('Swizzle:Sub34 Y failed ', 3, abf3.Y);
  AssertEquals('Swizzle:Sub35 Z failed ', 1, abf3.Z);
  AssertEquals('Swizzle:Sub36 W failed ', 4, abf3.W);
  abf3 := abf1.Swizzle(swWXYZ);
  AssertEquals('Swizzle:Sub37 X failed ', 4, abf3.X);
  AssertEquals('Swizzle:Sub38 Y failed ', 1, abf3.Y);
  AssertEquals('Swizzle:Sub39 Z failed ', 2, abf3.Z);
  AssertEquals('Swizzle:Sub40 W failed ', 3, abf3.W);
  abf3 := abf1.Swizzle(swWXZY);
  AssertEquals('Swizzle:Sub41 X failed ', 4, abf3.X);
  AssertEquals('Swizzle:Sub42 Y failed ', 1, abf3.Y);
  AssertEquals('Swizzle:Sub43 Z failed ', 3, abf3.Z);
  AssertEquals('Swizzle:Sub44 W failed ', 2, abf3.W);
  abf3 := abf1.Swizzle(swWZYX);
  AssertEquals('Swizzle:Sub45 X failed ', 4, abf3.X);
  AssertEquals('Swizzle:Sub46 Y failed ', 3, abf3.Y);
  AssertEquals('Swizzle:Sub47 Z failed ', 2, abf3.Z);
  AssertEquals('Swizzle:Sub48 W failed ', 1, abf3.W);
  abf3 := abf1.Swizzle(swWZYX);
  AssertEquals('Swizzle:Sub45 X failed ', 4, abf3.X);
  AssertEquals('Swizzle:Sub46 Y failed ', 3, abf3.Y);
  AssertEquals('Swizzle:Sub47 Z failed ', 2, abf3.Z);
  AssertEquals('Swizzle:Sub48 W failed ', 1, abf3.W);
  abf3 := abf1.Swizzle(swWZXY);
  AssertEquals('Swizzle:Sub49 X failed ', 4, abf3.X);
  AssertEquals('Swizzle:Sub50 Y failed ', 3, abf3.Y);
  AssertEquals('Swizzle:Sub51 Z failed ', 1, abf3.Z);
  AssertEquals('Swizzle:Sub52 W failed ', 2, abf3.W);
  abf3 := abf1.Swizzle(swWYXZ);
  AssertEquals('Swizzle:Sub53 X failed ', 4, abf3.X);
  AssertEquals('Swizzle:Sub54 Y failed ', 2, abf3.Y);
  AssertEquals('Swizzle:Sub55 Z failed ', 1, abf3.Z);
  AssertEquals('Swizzle:Sub56 W failed ', 3, abf3.W);
  abf3 := abf1.Swizzle(swWYZX);
  AssertEquals('Swizzle:Sub53 X failed ', 4, abf3.X);
  AssertEquals('Swizzle:Sub54 Y failed ', 2, abf3.Y);
  AssertEquals('Swizzle:Sub55 Z failed ', 3, abf3.Z);
  AssertEquals('Swizzle:Sub56 W failed ', 1, abf3.W);
end;

procedure TVector4bFunctionalTest.TestCombine;
begin
  abf1.Create(12,12,12,12);
  abf2.Create(40,50,60,255);
  fs1 := 3;
  abf3 := abf1.Combine(abf2,fs1);
  AssertEquals('Combine:Sub1 X failed ', 132, abf3.X);
  AssertEquals('Combine:Sub2 Y failed ', 162, abf3.Y);
  AssertEquals('Combine:Sub3 Z failed ', 192, abf3.Z);
  AssertEquals('Combine:Sub4 W failed ',  12, abf3.W);
  fs1 := 5;
  abf3 := abf1.Combine(abf2,fs1);
  AssertEquals('Combine:Sub5 X failed ', 212, abf3.X);
  AssertEquals('Combine:Sub6 Y failed ', 255, abf3.Y);
  AssertEquals('Combine:Sub7 Z failed ', 255, abf3.Z);
  AssertEquals('Combine:Sub8 W failed ',  12, abf3.W);
end;

procedure TVector4bFunctionalTest.TestCombine2;
begin
  abf1.Create(12,12,12,12);
  abf2.Create(40,50,60,255);
  abf3 := abf1.Combine2(abf2, 0.5, 0.5);   // nice whole numbers
  AssertEquals('Combine2:Sub1 X failed ', 26, abf3.X);
  AssertEquals('Combine2:Sub2 Y failed ', 31, abf3.Y);
  AssertEquals('Combine2:Sub3 Z failed ', 36, abf3.Z);
  AssertEquals('Combine2:Sub4 W failed ', 12, abf3.W);
  abf3 := abf1.Combine2(abf2, 0.4999, 0.4999);   // almost same as above
  AssertEquals('Combine2:Sub1 X failed ', 26, abf3.X);
  AssertEquals('Combine2:Sub2 Y failed ', 31, abf3.Y);
  AssertEquals('Combine2:Sub3 Z failed ', 36, abf3.Z);
  AssertEquals('Combine2:Sub4 W failed ', 12, abf3.W);
  abf3 := abf1.Combine2(abf2, 0.50003, 0.50004);   // almost same as above
  AssertEquals('Combine2:Sub1 X failed ', 26, abf3.X);
  AssertEquals('Combine2:Sub2 Y failed ', 31, abf3.Y);
  AssertEquals('Combine2:Sub3 Z failed ', 36, abf3.Z);
  AssertEquals('Combine2:Sub4 W failed ', 12, abf3.W);
end;

procedure TVector4bFunctionalTest.TestCombine3;
begin
  abf1.Create(12,12,12,12);
  abf2.Create(40,50,60,255);
  abf3 := abf1.Combine3(abf2, abf2, 0.5, 0.5, 0.5);
  AssertEquals('Combine3:Sub1 X failed ', 46, abf3.X);
  AssertEquals('Combine3:Sub2 Y failed ', 56, abf3.Y);
  AssertEquals('Combine3:Sub3 Z failed ', 66, abf3.Z);
  AssertEquals('Combine3:Sub4 W failed ', 12, abf3.W);
  abf3 := abf1.Combine3(abf2, abf2, 0.4999, 0.4999, 0.4999);   // almost same as above
  AssertEquals('Combine3:Sub1 X failed ', 46, abf3.X);
  AssertEquals('Combine3:Sub2 Y failed ', 56, abf3.Y);
  AssertEquals('Combine3:Sub3 Z failed ', 66, abf3.Z);
  AssertEquals('Combine3:Sub4 W failed ', 12, abf3.W);
  abf3 := abf1.Combine3(abf2, abf2, 0.50003, 0.50003, 0.50004);   // almost same as above
  AssertEquals('Combine3:Sub1 X failed ', 46, abf3.X);
  AssertEquals('Combine3:Sub2 Y failed ', 56, abf3.Y);
  AssertEquals('Combine3:Sub3 Z failed ', 66, abf3.Z);
  AssertEquals('Combine3:Sub4 W failed ', 12, abf3.W);
end;

procedure TVector4bFunctionalTest.TestMinXYZComponent;
begin
  abf1.Create(1,2,3,1);
  b4 := abf1.MinXYZComponent;
  AssertEquals('MinXYZComponent:Sub1 failed ',  1, b4);
  abf1.Create(6,4,3,1);
  b4 := abf1.MinXYZComponent;
  AssertEquals('MinXYZComponent:Sub2 failed ',  3, b4);
  abf1.Create(5,4,6,1);
  b4 := abf1.MinXYZComponent;
  AssertEquals('MinXYZComponent:Sub3 failed ',  4, b4);
end;

procedure TVector4bFunctionalTest.TestMaxXYZComponent;
begin
  abf1.Create(1,2,3,4);
  b4 := abf1.MaxXYZComponent;
  AssertEquals('MaxXYZComponent:Sub1 failed ',  3, b4);
  abf1.Create(1,4,3,6);
  b4 := abf1.MaxXYZComponent;
  AssertEquals('MaxXYZComponent:Sub2 failed ',  4, b4);
  abf1.Create(5,4,3,6);
  b4 := abf1.MaxXYZComponent;
  AssertEquals('MaxXYZComponent:Sub3 failed ',  5, b4);

end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR4B, TVector4bFunctionalTest);
end.

