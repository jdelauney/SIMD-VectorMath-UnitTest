unit QuaternionFunctionalTestCase;


{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  TQuaternionFunctionalTestCase = class(TVectorBaseTestCase)
    protected
      procedure Setup; override;
    public
      {$CODEALIGN RECORDMIN=16}
      nqt1, nqt2, nqt3, nqt4 : TNativeGLZQuaternion;
      aqt1, aqt2, aqt3, aqt4 : TGLZQuaternion;
      {$CODEALIGN RECORDMIN=4}
    published
      procedure TestCreateSingles;
      procedure TestCreateImagArrayWithReal;
      procedure TestCreateTwoUnitAffine;
      procedure TestCreateTwoUnitHmg;
      procedure TestCreateAngleAxis;
      procedure TestCreateEuler;
      procedure TestCreateEulerOrder;
      procedure TestConjugate;
      procedure TestOpMul;
      procedure TestOpEquals;
      procedure TestOpNotEquals;
      procedure TestMagnitude;
      procedure TestNormalize;
      procedure TestMultiplyAsSecond;
      procedure TestSlerpSingle;
      procedure TestSlerpSpin;
      procedure TestConvertToMatrix;
      //procedure Test;
      //procedure Test;
  end;

implementation


procedure TQuaternionFunctionalTestCase.Setup;
begin
  inherited Setup;
end;

// arbitary values ok for this test
procedure TQuaternionFunctionalTestCase.TestCreateSingles;
var a3ft1: TGLZVector3f;
begin
  aqt1.Create(1,2,3,4);
  AssertEquals('CreateSingle:Sub1 X failed ', 1.0, aqt1.X);
  AssertEquals('CreateSingle:Sub2 Y failed ', 2.0, aqt1.Y);
  AssertEquals('CreateSingle:Sub3 Z failed ', 3.0, aqt1.Z);
  AssertEquals('CreateSingle:Sub4 W failed ', 4.0, aqt1.W);
  // Accessors
  AssertEquals('CreateSingle:Sub5 X failed ', 1.0, aqt1.V[0]);
  AssertEquals('CreateSingle:Sub6 Y failed ', 2.0, aqt1.V[1]);
  AssertEquals('CreateSingle:Sub7 Z failed ', 3.0, aqt1.V[2]);
  AssertEquals('CreateSingle:Sub8 W failed ', 4.0, aqt1.V[3]);
  vt4 := aqt1.AsVector4f;
  AssertEquals('CreateSingle:Sub9 X failed ', 1.0, vt4.X);
  AssertEquals('CreateSingle:Sub10 Y failed ', 2.0, vt4.Y);
  AssertEquals('CreateSingle:Sub11 Z failed ', 3.0, vt4.Z);
  AssertEquals('CreateSingle:Sub12 W failed ', 4.0, vt4.W);
  a3ft1 := aqt1.ImagePart;
  AssertEquals('CreateSingle:Sub13 X failed ', 1.0, a3ft1.X);
  AssertEquals('CreateSingle:Sub14 Y failed ', 2.0, a3ft1.Y);
  AssertEquals('CreateSingle:Sub15 Z failed ', 3.0, a3ft1.Z);
end;

// arbitary values ok for this test
procedure TQuaternionFunctionalTestCase.TestCreateImagArrayWithReal;
var arr: array [0..2] of single;  // try general type over our defined type
begin
  vt1.Create(1,2,3,4);
  arr := vt1.AsVector3f.V;
  aqt1.Create(arr,6.0);
  AssertEquals('CreateImagArrayWithReal:Sub1 X failed ', 1.0, aqt1.X);
  AssertEquals('CreateImagArrayWithReal:Sub2 Y failed ', 2.0, aqt1.Y);
  AssertEquals('CreateImagArrayWithReal:Sub3 Z failed ', 3.0, aqt1.Z);
  AssertEquals('CreateImagArrayWithReal:Sub4 W failed ', 6.0, aqt1.W);
end;

procedure TQuaternionFunctionalTestCase.TestCreateTwoUnitAffine;
begin
  vt1.create(1,0,0,0);
  vt2.create(0,1,0,0); // positive 90deg on equator
  // equivalent of Z is up
  aqt1.Create(vt1.AsVector3f, vt2.AsVector3f);
  // should be a positive rotation in Z
  AssertEquals('CreateTwoUnitAffine:Sub1 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateTwoUnitAffine:Sub2 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateTwoUnitAffine:Sub3 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateTwoUnitAffine:Sub4 W failed ', 0.707106781187, aqt1.W);
  vt2.create(0,-1,0,0); // negative 90deg on equator
  aqt1.Create(vt1.AsVector3f, vt2.AsVector3f);
  // should be a negative rotation in Z
  AssertEquals('CreateTwoUnitAffine:Sub5 X failed ',  0.0, aqt1.X);
  AssertEquals('CreateTwoUnitAffine:Sub6 Y failed ',  0.0, aqt1.Y);
  AssertEquals('CreateTwoUnitAffine:Sub7 Z failed ', -0.707106781187, aqt1.Z);
  AssertEquals('CreateTwoUnitAffine:Sub8 W failed ',  0.707106781187, aqt1.W);
  vt2.create(1,1,0,0); // positive 45deg on equator
  vt2 := vt2.Normalize;
  aqt1.Create(vt1.AsVector3f, vt2.AsVector3f);
  // should be a positive rotation in Z
  AssertEquals('CreateTwoUnitAffine:Sub9 X failed ',   0.0, aqt1.X);
  AssertEquals('CreateTwoUnitAffine:Sub10 Y failed ',  0.0, aqt1.Y);
  AssertEquals('CreateTwoUnitAffine:Sub11 Z failed ',  0.3826834, aqt1.Z);
  AssertEquals('CreateTwoUnitAffine:Sub12 W failed ',  0.9238795, aqt1.W);
  // x out y up  then +z is left
  vt2.create(0,0,1,0); // left 90deg on equator
  aqt1.Create(vt1.AsVector3f, vt2.AsVector3f);
  // should be a negative rotation in Y
  AssertEquals('CreateTwoUnitAffine:Sub13 X failed ',  0.0, aqt1.X);
  AssertEquals('CreateTwoUnitAffine:Sub14 Y failed ', -0.707106781187, aqt1.Y);
  AssertEquals('CreateTwoUnitAffine:Sub15 Z failed ',  0.0, aqt1.Z);
  AssertEquals('CreateTwoUnitAffine:Sub16 W failed ',  0.707106781187, aqt1.W);
  vt2.create(0,0,-1,0); // right 90deg on equator
  // x out y up  then +z is left
  aqt1.Create(vt1.AsVector3f, vt2.AsVector3f);
  // should be a positive rotation in Y
  AssertEquals('CreateTwoUnitAffine:Sub17 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateTwoUnitAffine:Sub18 Y failed ', 0.707106781187, aqt1.Y);
  AssertEquals('CreateTwoUnitAffine:Sub19 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateTwoUnitAffine:Sub20 W failed ', 0.707106781187, aqt1.W);
  // and now y out with Z up  +x is left
  vt1.create(0,1,0,0); // +y 0deg on equator
  vt2.create(1,0,0,0); // left 90deg on equator
  aqt1.Create(vt1.AsVector3f, vt2.AsVector3f);
  // should be a negative rotation in Z
  AssertEquals('CreateTwoUnitAffine:Sub21 X failed ',  0.0, aqt1.X);
  AssertEquals('CreateTwoUnitAffine:Sub22 Y failed ',  0.0, aqt1.Y);
  AssertEquals('CreateTwoUnitAffine:Sub23 Z failed ', -0.707106781187, aqt1.Z);
  AssertEquals('CreateTwoUnitAffine:Sub24 W failed ',  0.707106781187, aqt1.W);
  vt2.create(-1,0,0,0); // right 90deg on equator
  aqt1.Create(vt1.AsVector3f, vt2.AsVector3f);
  // should be a positive rotation in Z
  AssertEquals('CreateTwoUnitAffine:Sub25 X failed ',  0.0, aqt1.X);
  AssertEquals('CreateTwoUnitAffine:Sub26 Y failed ',  0.0, aqt1.Y);
  AssertEquals('CreateTwoUnitAffine:Sub27 Z failed ',  0.707106781187, aqt1.Z);
  AssertEquals('CreateTwoUnitAffine:Sub28 W failed ',  0.707106781187, aqt1.W);
end;


// basically same as above but test for points as well
// pascal is forgiving about hmgPoints and mixed.
procedure TQuaternionFunctionalTestCase.TestCreateTwoUnitHmg;
begin
  vt1.create(1,0,0,0);
  vt2.create(0,1,0,0); // positive 90deg on equator
  // equivalent of Z is up
  aqt1.Create(vt1, vt2);  // hmgVector equiv to above
  // should be a positive rotation in Z
  AssertEquals('CreateTwoUnitHmg:Sub1 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateTwoUnitHmg:Sub2 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateTwoUnitHmg:Sub3 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateTwoUnitHmg:Sub4 W failed ', 0.707106781187, aqt1.W);
  vt1.create(1,0,0,1);
  vt2.create(0,1,0,1); // positive 90deg on equator
  // equivalent of Z is up
  aqt1.Create(vt1, vt2);  // hmgPoint equiv to above
  // should be a positive rotation in Z
  AssertEquals('CreateTwoUnitHmg:Sub1 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateTwoUnitHmg:Sub2 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateTwoUnitHmg:Sub3 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateTwoUnitHmg:Sub4 W failed ', 0.707106781187, aqt1.W);
  vt1.create(1,0,0,0);
  vt2.create(0,1,0,1); // positive 90deg on equator
  // equivalent of Z is up
  aqt1.Create(vt1, vt2);  //hmgVector v hmgPoint equiv to above
  // should be a positive rotation in Z
  AssertEquals('CreateTwoUnitHmg:Sub1 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateTwoUnitHmg:Sub2 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateTwoUnitHmg:Sub3 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateTwoUnitHmg:Sub4 W failed ', 0.707106781187, aqt1.W);
  vt2.create(1,1,0,1); // positive 45deg on equator
  vt2 := vt2.Normalize;
  aqt1.Create(vt1, vt2);
  // should be a positive rotation in Z
  AssertEquals('CreateTwoUnitHmg:Sub1 X failed ',  0.0, aqt1.X);
  AssertEquals('CreateTwoUnitHmg:Sub2 Y failed ',  0.0, aqt1.Y);
  AssertEquals('CreateTwoUnitHmg:Sub3 Z failed ',  0.3826834, aqt1.Z);
  AssertEquals('CreateTwoUnitHmg:Sub4 W failed ',  0.9238795, aqt1.W);
end;

procedure TQuaternionFunctionalTestCase.TestCreateAngleAxis;
var a3ft1: TGLZVector3f;
begin
  aqt1.Create(90, ZVector);
  // should be a positive rotation in Z
  AssertEquals('CreateAngleAxis:Sub1 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateAngleAxis:Sub2 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateAngleAxis:Sub3 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateAngleAxis:Sub4 W failed ', 0.707106781187, aqt1.W);
  vt1.Create(ZVector);
  a3ft1 := (-vt1).AsVector3f;
  aqt1.Create(90, a3ft1);
  // should be a negative rotation in Z
  AssertEquals('CreateAngleAxis:Sub5 X failed ',  0.0, aqt1.X);
  AssertEquals('CreateAngleAxis:Sub6 Y failed ',  0.0, aqt1.Y);
  AssertEquals('CreateAngleAxis:Sub7 Z failed ', -0.707106781187, aqt1.Z);
  AssertEquals('CreateAngleAxis:Sub8 W failed ',  0.707106781187, aqt1.W);
  aqt1.Create(90, YVector);
  // should be a positive rotation in Y
  AssertEquals('CreateAngleAxis:Sub9 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateAngleAxis:Sub10 Y failed ', 0.707106781187, aqt1.Y);
  AssertEquals('CreateAngleAxis:Sub11 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateAngleAxis:Sub12 W failed ', 0.707106781187, aqt1.W);
  vt1.Create(YVector);
  a3ft1 := (-vt1).AsVector3f;
  aqt1.Create(90, a3ft1);
  // should be a negative rotation in Y
  AssertEquals('CreateAngleAxis:Sub13 X failed ',  0.0, aqt1.X);
  AssertEquals('CreateAngleAxis:Sub14 Y failed ', -0.707106781187, aqt1.Y);
  AssertEquals('CreateAngleAxis:Sub15 Z failed ',  0.0, aqt1.Z);
  AssertEquals('CreateAngleAxis:Sub16 W failed ',  0.707106781187, aqt1.W);
  aqt1.Create(90, XVector);
  // should be a positive rotation in X
  AssertEquals('CreateAngleAxis:Sub17 X failed ', 0.707106781187, aqt1.X);
  AssertEquals('CreateAngleAxis:Sub18 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateAngleAxis:Sub19 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateAngleAxis:Sub20 W failed ', 0.707106781187, aqt1.W);
  vt1.Create(XVector);
  a3ft1 := (-vt1).AsVector3f;
  aqt1.Create(90, a3ft1);
  // should be a negative rotation in X
  AssertEquals('CreateAngleAxis:Sub21 X failed ', -0.707106781187, aqt1.X);
  AssertEquals('CreateAngleAxis:Sub22 Y failed ',  0.0, aqt1.Y);
  AssertEquals('CreateAngleAxis:Sub23 Z failed ',  0.0, aqt1.Z);
  AssertEquals('CreateAngleAxis:Sub24 W failed ',  0.707106781187, aqt1.W);
end;


// this will only test the correctness of the order
// multiplication of all will come later.
// r, p, y   roll pitch yaw  eulZXY
// you can create eulers outside of range -pi to pi, shall we say not
// recommended but allowed. You do lose the ease of interpreting the direction
// when debugging however.
procedure TQuaternionFunctionalTestCase.TestCreateEuler;
begin
  aqt1.Create(90,0,0);
  // should be a positive rotation in Z
  AssertEquals('CreateEuler:Sub1 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEuler:Sub2 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEuler:Sub3 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateEuler:Sub4 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,90,0);
  // should be a positive rotation in X
  AssertEquals('CreateEuler:Sub5 X failed ', 0.707106781187, aqt1.X);
  AssertEquals('CreateEuler:Sub6 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEuler:Sub7 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEuler:Sub8 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,0,90);
  // should be a positive rotation in Y
  AssertEquals('CreateEuler:Sub9 X failed ',  0.0, aqt1.X);
  AssertEquals('CreateEuler:Sub10 Y failed ', 0.707106781187, aqt1.Y);
  AssertEquals('CreateEuler:Sub11 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEuler:Sub12 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0, 270, 0);
  // should be a negative rotation in X but has gone over the pi interval
  // so neg shows on real component. This is equivalent to -90 in x
  // with negations swapped on none zero values.
  AssertEquals('CreateEuler:Sub13 X failed ',  0.707106781187, aqt1.X);
  AssertEquals('CreateEuler:Sub14 Y failed ',  0.0, aqt1.Y);
  AssertEquals('CreateEuler:Sub15 Z failed ',  0.0, aqt1.Z);
  AssertEquals('CreateEuler:Sub16 W failed ', -0.707106781187, aqt1.W);
  aqt1.Create(0, 450, 0);
  // should be a positive rotation in X two negs make a pos
  AssertEquals('CreateEuler:Sub17 X failed ', -0.707106781187, aqt1.X);
  AssertEquals('CreateEuler:Sub18 Y failed ',  0.0, aqt1.Y);
  AssertEquals('CreateEuler:Sub19 Z failed ',  0.0, aqt1.Z);
  AssertEquals('CreateEuler:Sub20 W failed ', -0.707106781187, aqt1.W);
end;

// TGLZEulerOrder = (eulXYZ, eulXZY, eulYXZ, eulYZX, eulZXY, eulZYX);
// this routine clamps to -pi to pi
// is this efficient????
procedure TQuaternionFunctionalTestCase.TestCreateEulerOrder;
begin
  aqt1.Create(90,0,0,eulXYZ);
  // should be a positive rotation in X
  AssertEquals('CreateEulerOrder:Sub1 X failed ', 0.707106781187, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub2 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub3 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub4 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(90,0,0,eulXZY);
  // should be a positive rotation in X
  AssertEquals('CreateEulerOrder:Sub5 X failed ', 0.707106781187, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub6 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub7 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub8 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(90,0,0,eulYXZ);
  // should be a positive rotation in X
  AssertEquals('CreateEulerOrder:Sub9 X failed ', 0.707106781187, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub10 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub11 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub12 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(90,0,0,eulZXY);
  // should be a positive rotation in X
  AssertEquals('CreateEulerOrder:Sub13 X failed ', 0.707106781187, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub14 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub15 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub16 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(90,0,0,eulYZX);
  // should be a positive rotation in X
  AssertEquals('CreateEulerOrder:Sub17 X failed ', 0.707106781187, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub18 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub19 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub20 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(90,0,0,eulZYX);
  // should be a positive rotation in X
  AssertEquals('CreateEulerOrder:Sub21 X failed ', 0.707106781187, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub22 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub23 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub24 W failed ', 0.707106781187, aqt1.W);

  aqt1.Create(0,90,0,eulXYZ);
  // should be a positive rotation in Y
  AssertEquals('CreateEulerOrder:Sub25 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub26 Y failed ', 0.707106781187, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub27 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub28 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,90,0,eulXZY);
  // should be a positive rotation in Y
  AssertEquals('CreateEulerOrder:Sub29 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub30 Y failed ', 0.707106781187, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub31 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub32 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,90,0,eulYXZ);
  // should be a positive rotation in Y
  AssertEquals('CreateEulerOrder:Sub33 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub34 Y failed ', 0.707106781187, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub35 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub36 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,90,0,eulZXY);
  // should be a positive rotation in Y
  AssertEquals('CreateEulerOrder:Sub37 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub38 Y failed ', 0.707106781187, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub39 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub40 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,90,0,eulYZX);
  // should be a positive rotation in Y
  AssertEquals('CreateEulerOrder:Sub41 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub42 Y failed ', 0.707106781187, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub43 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub44 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,90,0,eulZYX);
  // should be a positive rotation in Y
  AssertEquals('CreateEulerOrder:Sub45 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub46 Y failed ', 0.707106781187, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub47 Z failed ', 0.0, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub48 W failed ', 0.707106781187, aqt1.W);

  aqt1.Create(0,0,90,eulXYZ);
  // should be a positive rotation in Z
  AssertEquals('CreateEulerOrder:Sub49 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub50 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub51 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub52 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,0,90,eulXZY);
  // should be a positive rotation in Z
  AssertEquals('CreateEulerOrder:Sub53 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub54 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub55 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub56 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,0,90,eulYXZ);
  // should be a positive rotation in Z
  AssertEquals('CreateEulerOrder:Sub57 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub58 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub59 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub60 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,0,90,eulZXY);
  // should be a positive rotation in Z
  AssertEquals('CreateEulerOrder:Sub61 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub62 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub63 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub64 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,0,90,eulYZX);
  // should be a positive rotation in Z
  AssertEquals('CreateEulerOrder:Sub65 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub66 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub67 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub68 W failed ', 0.707106781187, aqt1.W);
  aqt1.Create(0,0,90,eulZYX);
  // should be a positive rotation in Z
  AssertEquals('CreateEulerOrder:Sub69 X failed ', 0.0, aqt1.X);
  AssertEquals('CreateEulerOrder:Sub70 Y failed ', 0.0, aqt1.Y);
  AssertEquals('CreateEulerOrder:Sub71 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('CreateEulerOrder:Sub72 W failed ', 0.707106781187, aqt1.W);
end;


{*==============================================================================
 At this point in the test we know that we can create quat consistantly in
 a single axis, and can create from two points. The next operation is
 conj and quat product. This being the most important.

 First we have to identify which verion of product is being used.
 Fixed Axis or moving frame.

================================================================================*}


procedure TQuaternionFunctionalTestCase.TestConjugate;
begin
   aqt1.Create(0.5,0.5,0.5,0.5);
   aqt4 := aqt1.Conjugate;
   AssertEquals('Conjugate:Sub1 X failed ', -0.5, aqt4.X);
   AssertEquals('Conjugate:Sub2 Y failed ', -0.5, aqt4.Y);
   AssertEquals('Conjugate:Sub3 Z failed ', -0.5, aqt4.Z);
   AssertEquals('Conjugate:Sub4 W failed ',  0.5, aqt4.W);
   aqt1.Create(0.5,-0.5,0.5,-0.5);
   aqt4 := aqt1.Conjugate;
   AssertEquals('Conjugate:Sub5 X failed ', -0.5, aqt4.X);
   AssertEquals('Conjugate:Sub6 Y failed ',  0.5, aqt4.Y);
   AssertEquals('Conjugate:Sub7 Z failed ', -0.5, aqt4.Z);
   AssertEquals('Conjugate:Sub8 W failed ', -0.5, aqt4.W);
   aqt1.Create(-0.5,0.5,-0.5,-0.5);
   aqt4 := aqt1.Conjugate;
   AssertEquals('Conjugate:Sub9 X failed ',   0.5, aqt4.X);
   AssertEquals('Conjugate:Sub10 Y failed ', -0.5, aqt4.Y);
   AssertEquals('Conjugate:Sub11 Z failed ',  0.5, aqt4.Z);
   AssertEquals('Conjugate:Sub12 W failed ', -0.5, aqt4.W);
end;

procedure TQuaternionFunctionalTestCase.TestOpMul;
begin
   // Euler order ZYX as multiply
   aqt1.Create(90,ZVector);   //[ 0, 0, 0.7071068, 0.7071068 ]
   AssertEquals('TestOpMul:Sub1 X failed ',  0.0, aqt1.X);   // same as vec and matrix rotate
   AssertEquals('TestOpMul:Sub2 Y failed ',  0.0, aqt1.Y);
   AssertEquals('TestOpMul:Sub3 Z failed ',  0.7071068, aqt1.Z);
   AssertEquals('TestOpMul:Sub4 W failed ',  0.7071068, aqt1.W);
   aqt2.Create(90,YVector);
   aqt3 := aqt1 * aqt2;       //[ -0.5, 0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub5 X failed ', -0.5, aqt3.X);
   AssertEquals('TestOpMul:Sub6 Y failed ',  0.5, aqt3.Y);
   AssertEquals('TestOpMul:Sub7 Z failed ',  0.5, aqt3.Z);
   AssertEquals('TestOpMul:Sub8 W failed ',  0.5, aqt3.W);
   aqt2.Create(90,XVector);
   aqt1 := aqt3 * aqt2;  // [ 0, 0.7071068, 0, 0.7071068 ]
   AssertEquals('TestOpMul:Sub9 X failed ',  0.0, aqt1.X);
   AssertEquals('TestOpMul:Sub10 Y failed ',  0.7071068, aqt1.Y);
   AssertEquals('TestOpMul:Sub11 Z failed ',  0.0, aqt1.Z);
   AssertEquals('TestOpMul:Sub12 W failed ',  0.7071068, aqt1.W);
   // Euler Order ZYX as create
   aqt2.Create(0,90,90,eulZYX);  //[ -0.5, 0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub13 X failed ', -0.5, aqt2.X);
   AssertEquals('TestOpMul:Sub14 Y failed ',  0.5, aqt2.Y);
   AssertEquals('TestOpMul:Sub15 Z failed ',  0.5, aqt2.Z);
   AssertEquals('TestOpMul:Sub16 W failed ',  0.5, aqt2.W);
   aqt2.Create(90,90,90,eulZYX); // [ 0, 0.7071068, 0, 0.7071068 ]
   AssertEquals('TestOpMul:Sub17 X failed ',  0.0, aqt2.X);
   AssertEquals('TestOpMul:Sub18 Y failed ',  0.7071068, aqt2.Y);
   AssertEquals('TestOpMul:Sub19 Z failed ',  0.0, aqt2.Z);
   AssertEquals('TestOpMul:Sub20 W failed ',  0.7071068, aqt2.W);

   // Euler order XYZ as multiply
   aqt1.Create(90,XVector);   //[ 0.7071068, 0, 0, 0.7071068 ]
   AssertEquals('TestOpMul:Sub21 X failed ',  0.7071068, aqt1.X);
   AssertEquals('TestOpMul:Sub22 Y failed ',  0.0, aqt1.Y);
   AssertEquals('TestOpMul:Sub23 Z failed ',  0.0, aqt1.Z);
   AssertEquals('TestOpMul:Sub24 W failed ',  0.7071068, aqt1.W);
   aqt2.Create(90,YVector);
   aqt3 := aqt1 * aqt2;       //[ 0.5, 0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub25 X failed ',  0.5, aqt3.X);
   AssertEquals('TestOpMul:Sub26 Y failed ',  0.5, aqt3.Y);
   AssertEquals('TestOpMul:Sub27 Z failed ',  0.5, aqt3.Z);
   AssertEquals('TestOpMul:Sub28 W failed ',  0.5, aqt3.W);
   aqt2.Create(90,ZVector);
   aqt1 := aqt3 * aqt2;  // [ 0.7071068, 0, 0.7071068, 0 ]
   AssertEquals('TestOpMul:Sub29 X failed ',   0.7071068, aqt1.X);
   AssertEquals('TestOpMul:Sub30 Y failed ',  0.0, aqt1.Y);
   AssertEquals('TestOpMul:Sub31 Z failed ',  0.7071068, aqt1.Z);
   AssertEquals('TestOpMul:Sub32 W failed ',  0.0, aqt1.W);
   // Euler order XYZ as create
   aqt2.Create(90,90,0,eulXYZ);  //[ 0.5, 0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub33 X failed ',  0.5, aqt2.X);
   AssertEquals('TestOpMul:Sub34 Y failed ',  0.5, aqt2.Y);
   AssertEquals('TestOpMul:Sub35 Z failed ',  0.5, aqt2.Z);
   AssertEquals('TestOpMul:Sub36 W failed ',  0.5, aqt2.W);
   aqt2.Create(90,90,90,eulXYZ); // [ 0.7071068, 0, 0.7071068, 0 ]
   AssertEquals('TestOpMul:Sub37 X failed ',   0.7071068, aqt2.X);
   AssertEquals('TestOpMul:Sub38 Y failed ',  0.0, aqt2.Y);
   AssertEquals('TestOpMul:Sub39 Z failed ',  0.7071068, aqt2.Z);
   AssertEquals('TestOpMul:Sub40 W failed ',  0.0, aqt2.W);

   // Euler order eulXZY  as multiply
   aqt1.Create(90,XVector);   //[ 0.7071068, 0, 0, 0.7071068 ]
   AssertEquals('TestOpMul:Sub41 X failed ',  0.7071068, aqt1.X);
   AssertEquals('TestOpMul:Sub42 Y failed ',  0.0, aqt1.Y);
   AssertEquals('TestOpMul:Sub43 Z failed ',  0.0, aqt1.Z);
   AssertEquals('TestOpMul:Sub44 W failed ',  0.7071068, aqt1.W);
   aqt2.Create(90,ZVector);
   aqt3 := aqt1 * aqt2;       //[ 0.5, -0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub45 X failed ',  0.5, aqt3.X);
   AssertEquals('TestOpMul:Sub46 Y failed ', -0.5, aqt3.Y);
   AssertEquals('TestOpMul:Sub47 Z failed ',  0.5, aqt3.Z);
   AssertEquals('TestOpMul:Sub48 W failed ',  0.5, aqt3.W);
   aqt2.Create(90,YVector);
   aqt1 := aqt3 * aqt2;  // [ 0, 0, 0.7071068, 0.7071068 ]
   AssertEquals('TestOpMul:Sub49 X failed ',  0.0, aqt1.X);
   AssertEquals('TestOpMul:Sub50 Y failed ',  0.0, aqt1.Y);
   AssertEquals('TestOpMul:Sub51 Z failed ',  0.7071068, aqt1.Z);
   AssertEquals('TestOpMul:Sub52 W failed ',  0.7071068, aqt1.W);
   // Euler order XZY as create
   aqt2.Create(90,0,90,eulXZY);  //[ 0.5, -0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub53 X failed ',  0.5, aqt2.X);
   AssertEquals('TestOpMul:Sub54 Y failed ', -0.5, aqt2.Y);
   AssertEquals('TestOpMul:Sub55 Z failed ',  0.5, aqt2.Z);
   AssertEquals('TestOpMul:Sub56 W failed ',  0.5, aqt2.W);
   aqt2.Create(90,90,90,eulXZY); // [ 0, 0, 0.7071068, 0.7071068 ]
   AssertEquals('TestOpMul:Sub57 X failed ',  0.0, aqt2.X);
   AssertEquals('TestOpMul:Sub58 Y failed ',  0.0, aqt2.Y);
   AssertEquals('TestOpMul:Sub59 Z failed ',  0.7071068, aqt2.Z);
   AssertEquals('TestOpMul:Sub60 W failed ',  0.7071068, aqt2.W);

   // Euler order eulYXZ  as multiply
   aqt1.Create(90,YVector);   //[ 0, 0.7071068, 0, 0.7071068 ]
   AssertEquals('TestOpMul:Sub61 X failed ',  0.0, aqt1.X);
   AssertEquals('TestOpMul:Sub62 Y failed ',  0.7071068, aqt1.Y);
   AssertEquals('TestOpMul:Sub63 Z failed ',  0.0, aqt1.Z);
   AssertEquals('TestOpMul:Sub64 W failed ',  0.7071068, aqt1.W);
   aqt2.Create(90,XVector);
   aqt3 := aqt1 * aqt2;       //[ 0.5, 0.5, -0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub65 X failed ',  0.5, aqt3.X);
   AssertEquals('TestOpMul:Sub66 Y failed ',  0.5, aqt3.Y);
   AssertEquals('TestOpMul:Sub67 Z failed ', -0.5, aqt3.Z);
   AssertEquals('TestOpMul:Sub68 W failed ',  0.5, aqt3.W);
   aqt2.Create(90,ZVector);
   aqt1 := aqt3 * aqt2;  // [ 0.7071068, 0, 0, 0.7071068 ]
   AssertEquals('TestOpMul:Sub69 X failed ',  0.7071068, aqt1.X);
   AssertEquals('TestOpMul:Sub70 Y failed ',  0.0, aqt1.Y);
   AssertEquals('TestOpMul:Sub71 Z failed ',  0.0, aqt1.Z);
   AssertEquals('TestOpMul:Sub72 W failed ',  0.7071068, aqt1.W);
   // Euler order YXZ as create
   aqt2.Create(90,90,0,eulYXZ);  //[ 0.5, 0.5, -0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub73 X failed ',  0.5, aqt2.X);
   AssertEquals('TestOpMul:Sub74 Y failed ',  0.5, aqt2.Y);
   AssertEquals('TestOpMul:Sub75 Z failed ', -0.5, aqt2.Z);
   AssertEquals('TestOpMul:Sub76 W failed ',  0.5, aqt2.W);
   aqt2.Create(90,90,90,eulYXZ); // [ 0.7071068, 0, 0, 0.7071068 ]
   AssertEquals('TestOpMul:Sub77 X failed ',  0.7071068, aqt2.X);
   AssertEquals('TestOpMul:Sub78 Y failed ',  0.0, aqt2.Y);
   AssertEquals('TestOpMul:Sub79 Z failed ',  0.0, aqt2.Z);
   AssertEquals('TestOpMul:Sub80 W failed ',  0.7071068, aqt2.W);

   // Euler order eulYZX  as multiply
   aqt1.Create(90,YVector);   //[ 0, 0.7071068, 0, 0.7071068 ]
   AssertEquals('TestOpMul:Sub81 X failed ',  0.0, aqt1.X);
   AssertEquals('TestOpMul:Sub82 Y failed ',  0.7071068, aqt1.Y);
   AssertEquals('TestOpMul:Sub83 Z failed ',  0.0, aqt1.Z);
   AssertEquals('TestOpMul:Sub84 W failed ',  0.7071068, aqt1.W);
   aqt2.Create(90,ZVector);
   aqt3 := aqt1 * aqt2;       //[ 0.5, 0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub85 X failed ',  0.5, aqt3.X);
   AssertEquals('TestOpMul:Sub86 Y failed ',  0.5, aqt3.Y);
   AssertEquals('TestOpMul:Sub87 Z failed ',  0.5, aqt3.Z);
   AssertEquals('TestOpMul:Sub88 W failed ',  0.5, aqt3.W);
   aqt2.Create(90,XVector);
   aqt1 := aqt3 * aqt2;  // [ 0.7071068, 0.7071068, 0, 0 ]
   AssertEquals('TestOpMul:Sub89 X failed ',  0.7071068, aqt1.X);
   AssertEquals('TestOpMul:Sub90 Y failed ',  0.7071068, aqt1.Y);
   AssertEquals('TestOpMul:Sub91 Z failed ',  0.0, aqt1.Z);
   AssertEquals('TestOpMul:Sub92 W failed ',  0.0, aqt1.W);
   // Euler order YZX as create
   aqt2.Create(90,0,90,eulYZX);  //[ 0.5, 0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub93 X failed ',  0.5, aqt2.X);
   AssertEquals('TestOpMul:Sub94 Y failed ',  0.5, aqt2.Y);
   AssertEquals('TestOpMul:Sub95 Z failed ',  0.5, aqt2.Z);
   AssertEquals('TestOpMul:Sub96 W failed ',  0.5, aqt2.W);
   aqt2.Create(90,90,90,eulYZX); // [ 0.7071068, 0.7071068, 0, 0 ]
   AssertEquals('TestOpMul:Sub97 X failed ',  0.7071068, aqt2.X);
   AssertEquals('TestOpMul:Sub98 Y failed ',  0.7071068, aqt2.Y);
   AssertEquals('TestOpMul:Sub99 Z failed ',  0.0, aqt2.Z);
   AssertEquals('TestOpMul:Sub100 W failed ',  0.0, aqt2.W);

   // Euler order eulZXY  as multiply
   aqt1.Create(90,ZVector);   //[ 0, 0, 0.7071068, 0.7071068 ]
   AssertEquals('TestOpMul:Sub101 X failed ',  0.0, aqt1.X);
   AssertEquals('TestOpMul:Sub102 Y failed ',  0.0, aqt1.Y);
   AssertEquals('TestOpMul:Sub103 Z failed ',  0.7071068, aqt1.Z);
   AssertEquals('TestOpMul:Sub104 W failed ',  0.7071068, aqt1.W);
   aqt2.Create(90,XVector);
   aqt3 := aqt1 * aqt2;       //[ 0.5, 0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub105 X failed ',  0.5, aqt3.X);
   AssertEquals('TestOpMul:Sub106 Y failed ',  0.5, aqt3.Y);
   AssertEquals('TestOpMul:Sub107 Z failed ',  0.5, aqt3.Z);
   AssertEquals('TestOpMul:Sub108 W failed ',  0.5, aqt3.W);
   aqt2.Create(90,YVector);
   aqt1 := aqt3 * aqt2;  // [ 0, 0.7071068, 0.7071068, 0 ]
   AssertEquals('TestOpMul:Sub109 X failed ',  0.0, aqt1.X);
   AssertEquals('TestOpMul:Sub100 Y failed ',  0.7071068, aqt1.Y);
   AssertEquals('TestOpMul:Sub111 Z failed ',  0.7071068, aqt1.Z);
   AssertEquals('TestOpMul:Sub112 W failed ',  0.0, aqt1.W);
   // Euler order ZXY as create
   aqt2.Create(90,0,90,eulZXY);  //[ 0.5, 0.5, 0.5, 0.5 ]
   AssertEquals('TestOpMul:Sub113 X failed ',  0.5, aqt2.X);
   AssertEquals('TestOpMul:Sub114 Y failed ',  0.5, aqt2.Y);
   AssertEquals('TestOpMul:Sub115 Z failed ',  0.5, aqt2.Z);
   AssertEquals('TestOpMul:Sub116 W failed ',  0.5, aqt2.W);
   aqt2.Create(90,90,90,eulZXY); // [ 0, 0.7071068, 0.7071068, 0 ]
   AssertEquals('TestOpMul:Sub117 X failed ',  0.0, aqt2.X);
   AssertEquals('TestOpMul:Sub118 Y failed ',  0.7071068, aqt2.Y);
   AssertEquals('TestOpMul:Sub119 Z failed ',  0.7071068, aqt2.Z);
   AssertEquals('TestOpMul:Sub120 W failed ',  0.0, aqt2.W);

end;

procedure TQuaternionFunctionalTestCase.TestOpEquals;
begin
   aqt1.Create(120,60,180,240);
   aqt2.Create(120,60,180,240);
   nb := aqt1 = aqt2;
   AssertEquals('OpEquality:Sub1 does not match ', True, nb);
   aqt2.Create(120,60,179,240);
   nb := aqt1 = aqt2;
   AssertEquals('OpEquality:Sub2 should not match ', False, nb);
   aqt2.Create(120,61,180,240);
   nb := aqt1 = aqt2;
   AssertEquals('OpEquality:Sub3 should not match ', False, nb);
   aqt2.Create(119,60,180,240);
   nb := aqt1 = aqt2;
   AssertEquals('OpEquality:Sub4 should not match ', False, nb);
   aqt2.Create(120,60,180,241);
   nb := aqt1 = aqt2;
   AssertEquals('OpEquality:Sub5 should not match ', False, nb);
end;

procedure TQuaternionFunctionalTestCase.TestOpNotEquals;
begin
   aqt1.Create(120,60,180,240);
   aqt2.Create(120,60,180,240);
   nb := aqt1 <> aqt2;
   AssertEquals('OpNotEquals:Sub1 should not match ', False, nb);
   aqt2.Create(120,60,123,240);
   nb := aqt1 <> aqt2;
   AssertEquals('OpNotEquals:Sub2 does not match ', True, nb);
   aqt2.Create(120,61,180,240);
   nb := aqt1 <> aqt2;
   AssertEquals('OpNotEquals:Sub3 does not match ', True, nb);
   aqt2.Create(119,60,180,240);
   nb := aqt1 <> aqt2;
   AssertEquals('OpNotEquals:Sub4 does not match ', True, nb);
   aqt2.Create(120,60,180,241);
   nb := aqt1 <> aqt2;
   AssertEquals('OpNotEquals:Sub5 does not match ', True, nb);
   aqt2.Create(121,61,181,241);
   nb := aqt1 <> aqt2;
   AssertEquals('OpNotEquals:Sub6 does not match ', True, nb);
end;

procedure TQuaternionFunctionalTestCase.TestMagnitude;
begin
   // Sqrt(4 * 4 ) = 4
  aqt1.Create(2,2,2,2);
  fs1 := aqt1.Magnitude;
  AssertEquals('Magnitude:Sub1 X failed ',  4, fs1);
end;

procedure TQuaternionFunctionalTestCase.TestNormalize;
begin
  aqt1.Create(2,2,2,2);
  aqt1.Normalize;
  AssertEquals('Normalize:Sub1 X failed ',  0.5, aqt1.X);
  AssertEquals('Normalize:Sub2 Y failed ',  0.5, aqt1.Y);
  AssertEquals('Normalize:Sub3 Z failed ',  0.5, aqt1.Z);
  AssertEquals('Normalize:Sub4 W failed ',  0.5, aqt1.W);
  aqt1.Create(-2,2,-2,2);
  aqt1.Normalize;
  AssertEquals('Normalize:Sub5 X failed ', -0.5, aqt1.X);
  AssertEquals('Normalize:Sub6 Y failed ',  0.5, aqt1.Y);
  AssertEquals('Normalize:Sub7 Z failed ', -0.5, aqt1.Z);
  AssertEquals('Normalize:Sub8 W failed ',  0.5, aqt1.W);
  aqt1.Create(2,-2,2,-2);
  aqt1.Normalize;
  AssertEquals('Normalize:Sub9 X failed ',   0.5, aqt1.X);
  AssertEquals('Normalize:Sub10 Y failed ', -0.5, aqt1.Y);
  AssertEquals('Normalize:Sub11 Z failed ',  0.5, aqt1.Z);
  AssertEquals('Normalize:Sub12 W failed ', -0.5, aqt1.W);
end;

procedure TQuaternionFunctionalTestCase.TestMultiplyAsSecond;
begin
   aqt1.Create(90, ZVector);
  // should be a positive rotation in Z
  AssertEquals('MultiplyAsSecond:Sub1 X failed ', 0.0, aqt1.X);
  AssertEquals('MultiplyAsSecond:Sub2 Y failed ', 0.0, aqt1.Y);
  AssertEquals('MultiplyAsSecond:Sub3 Z failed ', 0.707106781187, aqt1.Z);
  AssertEquals('MultiplyAsSecond:Sub4 W failed ', 0.707106781187, aqt1.W);
    aqt2.Create(90, XVector);
  // should be a positive rotation in
  AssertEquals('MultiplyAsSecond:Sub5 X failed ', 0.707106781187, aqt2.X);
  AssertEquals('MultiplyAsSecond:Sub6 Y failed ', 0.0, aqt2.Y);
  AssertEquals('MultiplyAsSecond:Sub7 Z failed ', 0.0, aqt2.Z);
  AssertEquals('MultiplyAsSecond:Sub8 W failed ', 0.707106781187, aqt2.W);
  aqt4 := aqt1 * aqt2;
  AssertEquals('MultiplyAsSecond:Sub9 X failed ',  0.5, aqt4.X);
  AssertEquals('MultiplyAsSecond:Sub10 Y failed ',  0.5, aqt4.Y);
  AssertEquals('MultiplyAsSecond:Sub11 Z failed ',  0.5, aqt4.Z);
  AssertEquals('MultiplyAsSecond:Sub12 W failed ',  0.5, aqt4.W);
  aqt4 :=  aqt2.MultiplyAsSecond(aqt1);   // equiv to aqt1 * aqt2;
  AssertEquals('MultiplyAsSecond:Sub13 X failed ',  0.5, aqt4.X);
  AssertEquals('MultiplyAsSecond:Sub14 Y failed ',  0.5, aqt4.Y);
  AssertEquals('MultiplyAsSecond:Sub15 Z failed ',  0.5, aqt4.Z);
  AssertEquals('MultiplyAsSecond:Sub16 W failed ',  0.5, aqt4.W);
end;

procedure TQuaternionFunctionalTestCase.TestSlerpSingle;
begin
   aqt1.AsVector4f := WHmgVector;  // null rotation as start point.
   aqt2.Create(90,ZVector);
   aqt4 := aqt1.Slerp(aqt2,0.5); // [ 0, 0, 0.3826834, 0.9238795 ]
   AssertEquals('SlerpSingle:Sub1 X failed ', 0.0, aqt4.X);
   AssertEquals('SlerpSingle:Sub2 Y failed ', 0.0, aqt4.Y);
   AssertEquals('SlerpSingle:Sub3 Z failed ', 0.3826834, aqt4.Z);
   AssertEquals('SlerpSingle:Sub4 W failed ', 0.9238795, aqt4.W);
   aqt4 := aqt1.Slerp(aqt2,1/3); // [ 0, 0, 0.258819, 0.9659258 ]
   AssertEquals('SlerpSingle:Sub5 X failed ', 0.0, aqt4.X);
   AssertEquals('SlerpSingle:Sub6 Y failed ', 0.0, aqt4.Y);
   AssertEquals('SlerpSingle:Sub7 Z failed ', 0.258819, aqt4.Z);
   AssertEquals('SlerpSingle:Sub8 W failed ', 0.9659258, aqt4.W);
   aqt4 := aqt1.Slerp(aqt2,2/3); // [ 0, 0, 0.5, 0.8660254 ]
   AssertEquals('SlerpSingle:Sub9 X failed ', 0.0, aqt4.X);
   AssertEquals('SlerpSingle:Sub10 Y failed ', 0.0, aqt4.Y);
   AssertEquals('SlerpSingle:Sub11 Z failed ', 0.5, aqt4.Z);
   AssertEquals('SlerpSingle:Sub12 W failed ', 0.8660254, aqt4.W);
end;

procedure TQuaternionFunctionalTestCase.TestSlerpSpin;
begin
//   aqt1.AsVector4f := WHmgVector;  // null rotation as start point.
   aqt1.create(1e-14,ZVector);  // null rotation as start point.
   aqt2.Create(90,ZVector); // 90 + 360 = 450
   aqt4 := aqt1.Slerp(aqt2, 2, 0.5); //  225  [ 0, 0, 0.9238795, -0.3826834 ]
   AssertEquals('SlerpSpin:Sub1 X failed ', 0.0, aqt4.X);
   AssertEquals('SlerpSpin:Sub2 Y failed ', 0.0, aqt4.Y);
   AssertEquals('SlerpSpin:Sub3 Z failed ', 0.9238795, aqt4.Z);
   AssertEquals('SlerpSpin:Sub4 W failed ', -0.3826834, aqt4.W);
   aqt4 := aqt1.Slerp(aqt2,2,2/9); // 100  [ 0, 0, 0.7660444, 0.6427876 ]
   AssertEquals('SlerpSpin:Sub5 X failed ', 0.0, aqt4.X);
   AssertEquals('SlerpSpin:Sub6 Y failed ', 0.0, aqt4.Y);
   AssertEquals('SlerpSpin:Sub7 Z failed ', 0.7660444, aqt4.Z);
   AssertEquals('SlerpSpin:Sub8 W failed ', 0.6427876, aqt4.W);
   aqt4 := aqt1.Slerp(aqt2,2,8/9); // 400  [ 0, 0, -0.3420201, -0.9396926 ]
   AssertEquals('SlerpSpin:Sub9 X failed ',   0.0, aqt4.X);
   AssertEquals('SlerpSpin:Sub10 Y failed ',  0.0, aqt4.Y);
   AssertEquals('SlerpSpin:Sub11 Z failed ', -0.3420201, aqt4.Z);
   AssertEquals('SlerpSpin:Sub12 W failed ', -0.9396926, aqt4.W);

end;

procedure TQuaternionFunctionalTestCase.TestConvertToMatrix;
var Mat: TGLZMatrix;
begin
   aqt1.Create(12,24,36,eulXYZ);
   AssertEquals('ConvertToMatrix:Sub1 X failed ', 0.1611364, aqt1.X);
   AssertEquals('ConvertToMatrix:Sub2 Y failed ', 0.1650573, aqt1.Y);
   AssertEquals('ConvertToMatrix:Sub3 Z failed ', 0.3212774, aqt1.Z);
   AssertEquals('ConvertToMatrix:Sub4 W failed ', 0.9184617, aqt1.W);
   mat := aqt1.ConvertToMatrix;
  // [  0.7390738, -0.5369685,  0.4067366;
  //    0.6433555,  0.7416318, -0.1899368;
  //   -0.1996588,  0.4020536,  0.8935823 ] as 3f
  AssertEquals('ConvertToMatrix:Sub1 m11 failed ',  0.7390738, Mat.m11);
  AssertEquals('ConvertToMatrix:Sub1 m12 failed ', -0.5369685, Mat.m12);
  AssertEquals('ConvertToMatrix:Sub1 m13 failed ',  0.4067366, Mat.m13);
  AssertEquals('ConvertToMatrix:Sub1 m14 failed ',  0.0, Mat.m14);
  AssertEquals('ConvertToMatrix:Sub1 m21 failed ',  0.6433555, Mat.m21);
  AssertEquals('ConvertToMatrix:Sub1 m22 failed ',  0.7416318, Mat.m22);
  AssertEquals('ConvertToMatrix:Sub1 m23 failed ', -0.1899368, Mat.m23);
  AssertEquals('ConvertToMatrix:Sub1 m24 failed ',  0.0, Mat.m24);
  AssertEquals('ConvertToMatrix:Sub1 m31 failed ', -0.1996588, Mat.m31);
  AssertEquals('ConvertToMatrix:Sub1 m32 failed ',  0.4020536, Mat.m32);
  AssertEquals('ConvertToMatrix:Sub1 m33 failed ',  0.8935823, Mat.m33);
  AssertEquals('ConvertToMatrix:Sub1 m34 failed ',  0.0, Mat.m34);
  AssertEquals('ConvertToMatrix:Sub1 m41 failed ',  0.0, Mat.m41);
  AssertEquals('ConvertToMatrix:Sub1 m42 failed ',  0.0, Mat.m42);
  AssertEquals('ConvertToMatrix:Sub1 m43 failed ',  0.0, Mat.m43);
  AssertEquals('ConvertToMatrix:Sub1 m44 failed ',  1.0, Mat.m44);
  aqt1.Create(12,24,36,eulZYX);  // [ 0.0333438, 0.2282478, 0.2799394, 0.9318933 ]
  AssertEquals('ConvertToMatrix:Sub1 X failed ', 0.0333438, aqt1.X);
  AssertEquals('ConvertToMatrix:Sub2 Y failed ', 0.2282478, aqt1.Y);
  AssertEquals('ConvertToMatrix:Sub3 Z failed ', 0.2799394, aqt1.Z);
  AssertEquals('ConvertToMatrix:Sub4 W failed ', 0.9318933, aqt1.W);
  mat := aqt1.ConvertToMatrix;
  //[  0.7390738, -0.5065260,  0.4440736;
  //   0.5369685,  0.8410442,  0.0656454;
  //  -0.4067366,  0.1899368,  0.8935823 ]
  AssertEquals('ConvertToMatrix:Sub1 m11 failed ',  0.7390738, Mat.m11);
  AssertEquals('ConvertToMatrix:Sub1 m12 failed ', -0.5065260, Mat.m12);
  AssertEquals('ConvertToMatrix:Sub1 m13 failed ',  0.4440736, Mat.m13);
  AssertEquals('ConvertToMatrix:Sub1 m14 failed ',  0.0, Mat.m14);
  AssertEquals('ConvertToMatrix:Sub1 m21 failed ',  0.5369685, Mat.m21);
  AssertEquals('ConvertToMatrix:Sub1 m22 failed ',  0.8410442, Mat.m22);
  AssertEquals('ConvertToMatrix:Sub1 m23 failed ',  0.0656454, Mat.m23);
  AssertEquals('ConvertToMatrix:Sub1 m24 failed ',  0.0, Mat.m24);
  AssertEquals('ConvertToMatrix:Sub1 m31 failed ', -0.4067366, Mat.m31);
  AssertEquals('ConvertToMatrix:Sub1 m32 failed ',  0.1899368, Mat.m32);
  AssertEquals('ConvertToMatrix:Sub1 m33 failed ',  0.8935823, Mat.m33);
  AssertEquals('ConvertToMatrix:Sub1 m34 failed ',  0.0, Mat.m34);
  AssertEquals('ConvertToMatrix:Sub1 m41 failed ',  0.0, Mat.m41);
  AssertEquals('ConvertToMatrix:Sub1 m42 failed ',  0.0, Mat.m42);
  AssertEquals('ConvertToMatrix:Sub1 m43 failed ',  0.0, Mat.m43);
  AssertEquals('ConvertToMatrix:Sub1 m44 failed ',  1.0, Mat.m44);
end;





// 2 V -> Q algorithm in pseudocode:
//
// quaternion q;
// vector3 c = cross(v1,v2);
// q.v = c;
// if ( vectors are known to be unit length ) {
//    q.w = 1 + dot(v1,v2);
// } else {
//    q.w = sqrt(v1.length_squared() * v2.length_squared()) + dot(v1,v2);
// }
// q.normalize();
// return q;
//


initialization
  RegisterTest(REPORT_GROUP_QUATERION, TQuaternionFunctionalTestCase);
end.

