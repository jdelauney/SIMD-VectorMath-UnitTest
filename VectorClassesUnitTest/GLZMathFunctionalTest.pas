unit GLZMathFunctionalTest;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
 GLZMath;

type

  TGLZMathFunctionalTest = class(TBaseTestCase)
    published
      procedure TestNormalizeDegAngle;
      procedure TestNormalizeRadAngle;
  end;

implementation

// clamps angle to between -180 t0 +180
// note +/- 180 is valid and required for quats.
procedure TGLZMathFunctionalTest.TestNormalizeDegAngle;
begin
  fs1 := NormalizeDegAngle(90);
  AssertEquals('NormalizeDegAngle:Sub1 failed ',   90, fs1);
  fs1 := NormalizeDegAngle(270);
  AssertEquals('NormalizeDegAngle:Sub2 failed ',  -90, fs1);
  fs1 := NormalizeDegAngle(450);
  AssertEquals('NormalizeDegAngle:Sub3 failed ',   90, fs1);
  fs1 := NormalizeDegAngle(630);
  AssertEquals('NormalizeDegAngle:Sub4 failed ',   -90, fs1);

  fs1 := NormalizeDegAngle(-90);
  AssertEquals('NormalizeDegAngle:Sub5 failed ',  -90, fs1);
  fs1 := NormalizeDegAngle(-270);
  AssertEquals('NormalizeDegAngle:Sub6 failed ',   90, fs1);
  fs1 := NormalizeDegAngle(-450);
  AssertEquals('NormalizeDegAngle:Sub7 failed ',  -90, fs1);
  fs1 := NormalizeDegAngle(-630);
  AssertEquals('NormalizeDegAngle:Sub8 failed ',   90, fs1);

  fs1 := NormalizeDegAngle(87.546);
  AssertEquals('NormalizeDegAngle:Sub9 failed ', 87.546, fs1);
  fs1 := NormalizeDegAngle(180);
  AssertEquals('NormalizeDegAngle:Sub10 failed ',  -180, fs1);
  fs1 := NormalizeDegAngle(-180);
  AssertEquals('NormalizeDegAngle:Sub11 failed ',  -180, fs1);

end;

procedure TGLZMathFunctionalTest.TestNormalizeRadAngle;
begin
  fs1 := NormalizeRadAngle(pi/2);
  AssertEquals('NormalizeRadAngle:Sub1 failed ',   pi/2, fs1);
  fs1 := NormalizeRadAngle(3*pi/2);
  AssertEquals('NormalizeRadAngle:Sub2 failed ',  -pi/2, fs1);
  fs1 := NormalizeRadAngle(-3*pi/2);
  AssertEquals('NormalizeRadAngle:Sub3 failed ',   pi/2, fs1);
end;


initialization
  RegisterTest(REPORT_GROUP_BASE, TGLZMathFunctionalTest);
end.

