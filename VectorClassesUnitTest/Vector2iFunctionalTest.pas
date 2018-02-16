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

end;

procedure TVector2iFunctionalTest.TestOpMulSingle;
begin

end;

procedure TVector2iFunctionalTest.TestOpAddInteger;
begin

end;

procedure TVector2iFunctionalTest.TestOpSubInteger;
begin

end;

procedure TVector2iFunctionalTest.TestOpDivInteger;
begin

end;

procedure TVector2iFunctionalTest.TestOpMulInteger;
begin

end;

procedure TVector2iFunctionalTest.TestOpDivideSingle;
begin

end;

procedure TVector2iFunctionalTest.TestOpNegate;
begin

end;

procedure TVector2iFunctionalTest.TestEquals;
begin

end;

procedure TVector2iFunctionalTest.TestNotEquals;
begin

end;

procedure TVector2iFunctionalTest.TestMod;
begin

end;

procedure TVector2iFunctionalTest.TestMin;
begin

end;

procedure TVector2iFunctionalTest.TestMax;
begin

end;

procedure TVector2iFunctionalTest.TestMinInteger;
begin

end;

procedure TVector2iFunctionalTest.TestMaxInteger;
begin

end;

procedure TVector2iFunctionalTest.TestClamp;
begin

end;

procedure TVector2iFunctionalTest.TestClampInteger;
begin

end;

procedure TVector2iFunctionalTest.TestMulAdd;
begin

end;

procedure TVector2iFunctionalTest.TestMulDiv;
begin

end;

procedure TVector2iFunctionalTest.TestLength;
begin

end;

procedure TVector2iFunctionalTest.TestLengthSquare;
begin

end;

procedure TVector2iFunctionalTest.TestDistance;
begin

end;

procedure TVector2iFunctionalTest.TestDistanceSquare;
begin

end;

procedure TVector2iFunctionalTest.TestNormalize;
begin

end;

procedure TVector2iFunctionalTest.TestDotProduct;
begin

end;

procedure TVector2iFunctionalTest.TestAngleBetween;
begin

end;

procedure TVector2iFunctionalTest.TestAngleCosine;
begin

end;

procedure TVector2iFunctionalTest.TestAbs;
begin

end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR2I, TVector2iFunctionalTest);
end.

