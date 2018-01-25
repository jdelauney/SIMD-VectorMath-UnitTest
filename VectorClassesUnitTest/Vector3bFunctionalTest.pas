unit Vector3bFunctionalTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  GLZVectorMath;

type

  { TVector3bFunctionalTest }

  TVector3bFunctionalTest =  class(TByteVectorBaseTestCase)
    published
      procedure TestCreate3Byte;
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
      procedure TestSwizzle;
  end;

implementation

{ TVector3bFunctionalTest }

procedure TVector3bFunctionalTest.TestCreate3Byte;
begin
  abt1.Create(1,2,3);
  AssertEquals('Create:Sub1 X failed ', 1, abt1.X);
  AssertEquals('Create:Sub2 Red failed ', 1, abt1.Red);
  AssertEquals('Create:Sub3 Y failed ', 2, abt1.Y);
  AssertEquals('Create:Sub4 Green failed ', 2, abt1.Green);
  AssertEquals('Create:Sub5 Z failed ', 3, abt1.Z);
  AssertEquals('Create:Sub6 Blue failed ', 3, abt1.Blue);
end;

procedure TVector3bFunctionalTest.TestOpAdd;
begin
  abt1.Create(1,2,3);
  abt2.Create(1,2,3);
  abt3 := abt1 + abt2;
  AssertEquals('OpAdd:Sub1 X failed ', 2, abt3.X);
  AssertEquals('OpAdd:Sub2 Y failed ', 4, abt3.Y);
  AssertEquals('OpAdd:Sub3 Z failed ', 6, abt3.Z);
  abt3 := abt2 + abt1;
  AssertEquals('OpAdd:Sub4 X failed ', 2, abt3.X);
  AssertEquals('OpAdd:Sub5 Y failed ', 4, abt3.Y);
  AssertEquals('OpAdd:Sub6 Z failed ', 6, abt3.Z);
  abt1.Create(200,200,200);
  abt2.Create(100,60,80);
  abt3 := abt2 + abt1;
  AssertEquals('OpAdd:Sub7 X failed ', 255, abt3.X);
  AssertEquals('OpAdd:Sub8 Y failed ', 255, abt3.Y);
  AssertEquals('OpAdd:Sub9 Z failed ', 255, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpAddByte;
begin
  abt1.Create(100,60,80);
  abt3 := abt1 + 20;
  AssertEquals('OpAddByte:Sub1 X failed ', 120, abt3.X);
  AssertEquals('OpAddByte:Sub2 Y failed ', 80, abt3.Y);
  AssertEquals('OpAddByte:Sub3 Z failed ', 100, abt3.Z);
  abt3 := abt1 + 200;
  AssertEquals('OpAddByte:Sub4 X failed ', 255, abt3.X);
  AssertEquals('OpAddByte:Sub5 Y failed ', 255, abt3.Y);
  AssertEquals('OpAddByte:Sub6 Z failed ', 255, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpSub;
begin
  abt1.Create(1,2,3);
  abt2.Create(4,5,6);
  abt3 := abt1 - abt2;
  AssertEquals('OpSub:Sub1 X failed ', 0, abt3.X);
  AssertEquals('OpSub:Sub2 Y failed ', 0, abt3.Y);
  AssertEquals('OpSub:Sub3 Z failed ', 0, abt3.Z);
  abt3 := abt2 - abt1;
  AssertEquals('OpSub:Sub1 X failed ', 3, abt3.X);
  AssertEquals('OpSub:Sub2 Y failed ', 3, abt3.Y);
  AssertEquals('OpSub:Sub3 Z failed ', 3, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpSubByte;
begin
  abt1.Create(100,60,80);
  abt3 := abt1 - 20;
  AssertEquals('OpSubByte:Sub1 X failed ', 80, abt3.X);
  AssertEquals('OpSubByte:Sub2 Y failed ', 40, abt3.Y);
  AssertEquals('OpSubByte:Sub3 Z failed ', 60, abt3.Z);
  abt3 := abt1 - 200;
  AssertEquals('OpAddByte:Sub4 X failed ', 0, abt3.X);
  AssertEquals('OpAddByte:Sub5 Y failed ', 0, abt3.Y);
  AssertEquals('OpAddByte:Sub6 Z failed ', 0, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpMul;
begin
  abt1.Create(100,60,80);
  abt2.Create(1,2,3);
  abt3 := abt1 * abt2;
  AssertEquals('OpMul:Sub1 X failed ', 100, abt3.X);
  AssertEquals('OpMul:Sub2 Y failed ', 120, abt3.Y);
  AssertEquals('OpMul:Sub3 Z failed ', 240, abt3.Z);
  abt2.Create(3,5,4);
  abt3 := abt1 * abt2;
  AssertEquals('OpMul:Sub4 X failed ', 255, abt3.X);
  AssertEquals('OpMul:Sub5 Y failed ', 255, abt3.Y);
  AssertEquals('OpMul:Sub6 Z failed ', 255, abt3.Z);
  abt2.Create(3,2,4);
  abt3 := abt1 * abt2;
  AssertEquals('OpMul:Sub7 X failed ', 255, abt3.X);
  AssertEquals('OpMul:Sub8 Y failed ', 120, abt3.Y);
  AssertEquals('OpMul:Sub9 Z failed ', 255, abt3.Z);
end;

// with these overloads using a const number makes compiler barf as
// it cannot work out if 2 is single or byte so we have to use a typed var.
procedure TVector3bFunctionalTest.TestOpMulByte;
var
  a: byte;
begin
  abt1.Create(100,60,80);
  a := 2;
  abt3 := abt1 * a;
  AssertEquals('OpMulByte:Sub1 X failed ', 200, abt3.X);
  AssertEquals('OpMulByte:Sub2 Y failed ', 120, abt3.Y);
  AssertEquals('OpMulByte:Sub3 Z failed ', 160, abt3.Z);
  a := 3;
  abt3 := abt1 * a;
  AssertEquals('OpMulByte:Sub3 X failed ', 255, abt3.X);
  AssertEquals('OpMulByte:Sub4 Y failed ', 180, abt3.Y);
  AssertEquals('OpMulByte:Sub5 Z failed ', 240, abt3.Z);
  a := 4;
  abt3 := abt1 * a;
  AssertEquals('OpMulByte:Sub6 X failed ', 255, abt3.X);
  AssertEquals('OpMulByte:Sub7 Y failed ', 240, abt3.Y);
  AssertEquals('OpMulByte:Sub8 Z failed ', 255, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpMulSingle;
begin
  abt1.Create(100,60,80);
  abt3 := abt1 * 2.0;
  AssertEquals('OpMulSingle:Sub1 X failed ', 200, abt3.X);
  AssertEquals('OpMulSingle:Sub2 Y failed ', 120, abt3.Y);
  AssertEquals('OpMulSingle:Sub3 Z failed ', 160, abt3.Z);
  abt3 := abt1 * 3.0;
  AssertEquals('OpMulSingle:Sub3 X failed ', 255, abt3.X);
  AssertEquals('OpMulSingle:Sub4 Y failed ', 180, abt3.Y);
  AssertEquals('OpMulSingle:Sub5 Z failed ', 240, abt3.Z);
  abt3 := abt1 * 4.0;
  AssertEquals('OpMulSingle:Sub6 X failed ', 255, abt3.X);
  AssertEquals('OpMulSingle:Sub7 Y failed ', 240, abt3.Y);
  AssertEquals('OpMulSingle:Sub8 Z failed ', 255, abt3.Z);
end;

// div truncs
procedure TVector3bFunctionalTest.TestOpDiv;
begin
  abt1.Create(120,60,180);
  abt2.Create(1,2,3);
  abt3 := abt1 Div abt2;
  AssertEquals('OpDiv:Sub1 X failed ', 120, abt3.X);
  AssertEquals('OpDiv:Sub2 Y failed ',  30, abt3.Y);
  AssertEquals('OpDiv:Sub3 Z failed ',  60, abt3.Z);
  abt2.Create(4,5,6);
  abt3 := abt1 Div abt2;
  AssertEquals('OpDiv:Sub4 X failed ',  30, abt3.X);
  AssertEquals('OpDiv:Sub5 Y failed ',  12, abt3.Y);
  AssertEquals('OpDiv:Sub6 Z failed ',  30, abt3.Z);
  abt2.Create(11,9,17);  // these are all above 0.5
  abt3 := abt1 Div abt2;   // 10.909, 6.6666., 10.588235
  AssertEquals('OpDiv:Sub7 X failed ',  10, abt3.X);
  AssertEquals('OpDiv:Sub8 Y failed ',   6, abt3.Y);
  AssertEquals('OpDiv:Sub9 Z failed ',  10, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpDivByte;
begin
  abt1.Create(120,60,180);
  abt3 := abt1 Div 4;
  AssertEquals('OpDivByte:Sub1 X failed ',  30, abt3.X);
  AssertEquals('OpDivByte:Sub2 Y failed ',  15, abt3.Y);
  AssertEquals('OpDivByte:Sub3 Z failed ',  45, abt3.Z);
  abt3 := abt1 Div 7;
  AssertEquals('OpDivByte:Sub4 X failed ',  17, abt3.X);
  AssertEquals('OpDivByte:Sub5 Y failed ',   8, abt3.Y);
  AssertEquals('OpDivByte:Sub6 Z failed ',  25, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpEquality;
begin
  abt1.Create(120,60,180);
  abt2.Create(120,60,180);
  nb := abt1 = abt2;
  AssertEquals('OpEquality:Sub1 does not match ', True, nb);
  abt2.Create(120,60,181);
  nb := abt1 = abt2;
  AssertEquals('OpEquality:Sub2 should not match ', False, nb);
  abt2.Create(120,61,180);
  nb := abt1 = abt2;
  AssertEquals('OpEquality:Sub3 should not match ', False, nb);
  abt2.Create(119,60,180);
  nb := abt1 = abt2;
  AssertEquals('OpEquality:Sub4 should not match ', False, nb);
end;

procedure TVector3bFunctionalTest.TestOpNotEquals;
begin
  abt1.Create(120,60,180);
  abt2.Create(120,60,180);
  nb := abt1 <> abt2;
  AssertEquals('OpNotEquals:Sub1 should not match ', False, nb);
  abt2.Create(120,60,181);
  nb := abt1 <> abt2;
  AssertEquals('OpNotEquals:Sub2 does not match ', True, nb);
  abt2.Create(120,61,180);
  nb := abt1 <> abt2;
  AssertEquals('OpNotEquals:Sub3 does not match ', True, nb);
  abt2.Create(119,60,180);
  nb := abt1 <> abt2;
  AssertEquals('OpNotEquals:Sub4 does not match ', True, nb);
end;

procedure TVector3bFunctionalTest.TestOpAnd;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abt1.Create(b1,b2,b3);
  abt2.Create(b2,b2,b2);
  abt3 := abt1 and abt2;
  AssertEquals('OpAnd:Sub1 X failed ',  b4, abt3.X);
  AssertEquals('OpAnd:Sub2 Y failed ',  b2, abt3.Y);
  AssertEquals('OpAnd:Sub3 Z failed ',  b2, abt3.Z);
  abt2.Create(b1,b1,b1);
  abt3 := abt1 and abt2;
  AssertEquals('OpAnd:Sub4 X failed ',  b1, abt3.X);
  AssertEquals('OpAnd:Sub5 Y failed ',  b4, abt3.Y);
  AssertEquals('OpAnd:Sub6 Z failed ',  b1, abt3.Z);
  abt2.Create(b3,b3,b3);
  abt3 := abt1 and abt2;
  AssertEquals('OpAnd:Sub7 X failed ',  b1, abt3.X);
  AssertEquals('OpAnd:Sub8 Y failed ',  b2, abt3.Y);
  AssertEquals('OpAnd:Sub9 Z failed ',  b3, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpAndByte;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abt1.Create(b1,b2,b3);
  abt3 := abt1 and b2;
  AssertEquals('OpAnd:Sub1 X failed ',  b4, abt3.X);
  AssertEquals('OpAnd:Sub2 Y failed ',  b2, abt3.Y);
  AssertEquals('OpAnd:Sub3 Z failed ',  b2, abt3.Z);
  abt3 := abt1 and b1;
  AssertEquals('OpAnd:Sub4 X failed ',  b1, abt3.X);
  AssertEquals('OpAnd:Sub5 Y failed ',  b4, abt3.Y);
  AssertEquals('OpAnd:Sub6 Z failed ',  b1, abt3.Z);
  abt3 := abt1 and b3;
  AssertEquals('OpAnd:Sub7 X failed ',  b1, abt3.X);
  AssertEquals('OpAnd:Sub8 Y failed ',  b2, abt3.Y);
  AssertEquals('OpAnd:Sub9 Z failed ',  b3, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpOr;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abt1.Create(b1,b2,b4);
  abt2.Create(b2,b2,b2);
  abt3 := abt1 or abt2;
  AssertEquals('OpAnd:Sub1 X failed ',  b3, abt3.X);
  AssertEquals('OpAnd:Sub2 Y failed ',  b2, abt3.Y);
  AssertEquals('OpAnd:Sub3 Z failed ',  b2, abt3.Z);
  abt2.Create(b1,b1,b1);
  abt3 := abt1 or abt2;
  AssertEquals('OpAnd:Sub4 X failed ',  b1, abt3.X);
  AssertEquals('OpAnd:Sub5 Y failed ',  b3, abt3.Y);
  AssertEquals('OpAnd:Sub6 Z failed ',  b1, abt3.Z);
  abt2.Create(b4,b4,b4);
  abt3 := abt1 or abt2;
  AssertEquals('OpAnd:Sub7 X failed ',  b1, abt3.X);
  AssertEquals('OpAnd:Sub8 Y failed ',  b2, abt3.Y);
  AssertEquals('OpAnd:Sub9 Z failed ',  b4, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpOrByte;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abt1.Create(b1,b2,b4);
  abt3 := abt1 or b2;
  AssertEquals('OpAnd:Sub1 X failed ',  b3, abt3.X);
  AssertEquals('OpAnd:Sub2 Y failed ',  b2, abt3.Y);
  AssertEquals('OpAnd:Sub3 Z failed ',  b2, abt3.Z);
  abt3 := abt1 or b1;
  AssertEquals('OpAnd:Sub4 X failed ',  b1, abt3.X);
  AssertEquals('OpAnd:Sub5 Y failed ',  b3, abt3.Y);
  AssertEquals('OpAnd:Sub6 Z failed ',  b1, abt3.Z);
  abt3 := abt1 or b4;
  AssertEquals('OpAnd:Sub7 X failed ',  b1, abt3.X);
  AssertEquals('OpAnd:Sub8 Y failed ',  b2, abt3.Y);
  AssertEquals('OpAnd:Sub9 Z failed ',  b4, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpXor;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abt1.Create(b1,b2,b4);
  abt2.Create(b2,b2,b2);
  abt3 := abt1 xor abt2;
  AssertEquals('OpAnd:Sub1 X failed ',  b3, abt3.X);
  AssertEquals('OpAnd:Sub2 Y failed ',  b4, abt3.Y);
  AssertEquals('OpAnd:Sub3 Z failed ',  b2, abt3.Z);
  abt2.Create(b1,b1,b1);
  abt3 := abt1 xor abt2;
  AssertEquals('OpAnd:Sub4 X failed ',  b4, abt3.X);
  AssertEquals('OpAnd:Sub5 Y failed ',  b3, abt3.Y);
  AssertEquals('OpAnd:Sub6 Z failed ',  b1, abt3.Z);
  abt2.Create(b3,b3,b3);
  abt3 := abt1 xor abt2;
  AssertEquals('OpAnd:Sub7 X failed ',  b2, abt3.X);
  AssertEquals('OpAnd:Sub8 Y failed ',  b1, abt3.Y);
  AssertEquals('OpAnd:Sub9 Z failed ',  b3, abt3.Z);
end;

procedure TVector3bFunctionalTest.TestOpXorByte;
begin
  b1 := 170; //10101010
  b2 := 85;  //01010101
  b3 := 255; //11111111
  b4 := 0;   //00000000;
  abt1.Create(b1,b2,b4);
  abt3 := abt1 xor b2;
  AssertEquals('OpAnd:Sub1 X failed ',  b3, abt3.X);
  AssertEquals('OpAnd:Sub2 Y failed ',  b4, abt3.Y);
  AssertEquals('OpAnd:Sub3 Z failed ',  b2, abt3.Z);
  abt3 := abt1 xor b1;
  AssertEquals('OpAnd:Sub4 X failed ',  b4, abt3.X);
  AssertEquals('OpAnd:Sub5 Y failed ',  b3, abt3.Y);
  AssertEquals('OpAnd:Sub6 Z failed ',  b1, abt3.Z);
  abt3 := abt1 xor b3;
  AssertEquals('OpAnd:Sub7 X failed ',  b2, abt3.X);
  AssertEquals('OpAnd:Sub8 Y failed ',  b1, abt3.Y);
  AssertEquals('OpAnd:Sub9 Z failed ',  b3, abt3.Z);
end;


//swXXX, swYYY, swZZZ, swXYZ, swXZY, swZYX, swZXY, swYXZ, swYZX,
//swRRR, swGGG, swBBB, swRGB, swRBG, swBGR, swBRG, swGRB, swGBR
procedure TVector3bFunctionalTest.TestSwizzle;
Var R, G, B: byte;
begin
  R := 170; //10101010
  G := 85;  //01010101
  B := 255; //11111111
  abt1.Create(R,G,B);
  abt3 := abt1.Swizzle(swRRR);
  AssertEquals('Swizzle:Sub1 X failed ',  R, abt3.X);
  AssertEquals('Swizzle:Sub2 Y failed ',  R, abt3.Y);
  AssertEquals('Swizzle:Sub3 Z failed ',  R, abt3.Z);
  abt1.Create(R,G,B);
  abt3 := abt1.Swizzle(swGGG);
  AssertEquals('Swizzle:Sub4 X failed ',  G, abt3.X);
  AssertEquals('Swizzle:Sub5 Y failed ',  G, abt3.Y);
  AssertEquals('Swizzle:Sub6 Z failed ',  G, abt3.Z);
  abt1.Create(R,G,B);
  abt3 := abt1.Swizzle(swBBB);
  AssertEquals('Swizzle:Sub7 X failed ',  B, abt3.X);
  AssertEquals('Swizzle:Sub8 Y failed ',  B, abt3.Y);
  AssertEquals('Swizzle:Sub9 Z failed ',  B, abt3.Z);
  abt1.Create(R,G,B);
  abt3 := abt1.Swizzle(swRGB);
  AssertEquals('Swizzle:Sub10 X failed ',  R, abt3.X);
  AssertEquals('Swizzle:Sub11 Y failed ',  G, abt3.Y);
  AssertEquals('Swizzle:Sub12 Z failed ',  B, abt3.Z);
  abt1.Create(R,G,B);
  abt3 := abt1.Swizzle(swRBG);
  AssertEquals('Swizzle:Sub13 X failed ',  R, abt3.X);
  AssertEquals('Swizzle:Sub14 Y failed ',  B, abt3.Y);
  AssertEquals('Swizzle:Sub15 Z failed ',  G, abt3.Z);
  abt1.Create(R,G,B);
  abt3 := abt1.Swizzle(swBGR);
  AssertEquals('Swizzle:Sub16 X failed ',  B, abt3.X);
  AssertEquals('Swizzle:Sub17 Y failed ',  G, abt3.Y);
  AssertEquals('Swizzle:Sub18 Z failed ',  R, abt3.Z);
  abt1.Create(R,G,B);
  abt3 := abt1.Swizzle(swBRG);
  AssertEquals('Swizzle:Sub19 X failed ',  B, abt3.X);
  AssertEquals('Swizzle:Sub20 Y failed ',  R, abt3.Y);
  AssertEquals('Swizzle:Sub21 Z failed ',  G, abt3.Z);
  abt1.Create(R,G,B);
  abt3 := abt1.Swizzle(swGRB);
  AssertEquals('Swizzle:Sub22 X failed ',  G, abt3.X);
  AssertEquals('Swizzle:Sub23 Y failed ',  R, abt3.Y);
  AssertEquals('Swizzle:Sub24 Z failed ',  B, abt3.Z);
  abt1.Create(R,G,B);
  abt3 := abt1.Swizzle(swGBR);
  AssertEquals('Swizzle:Sub25 X failed ',  G, abt3.X);
  AssertEquals('Swizzle:Sub26 Y failed ',  B, abt3.Y);
  AssertEquals('Swizzle:Sub27 Z failed ',  R, abt3.Z);
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR3B, TVector3bFunctionalTest);
end.

