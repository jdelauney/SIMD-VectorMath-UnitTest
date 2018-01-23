unit VectorHelperTestCase;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVectorHelperTestCase }

  TVectorHelperTestCase = class(TVectorBaseTestCase)
  protected
    procedure Setup; override;
  public
    {$CODEALIGN RECORDMIN=16}
    nph1, nph2,nph3 : TNativeGLZHmgPlane;
    nt4,nt5 : TNativeGLZVector;
    vt5 : TGLZVector;
    ph1,ph2,ph3     : TGLZHmgPlane;
    {$CODEALIGN RECORDMIN=4}
    alpha: single;
  published
    procedure TestRotate;
    procedure TestRotateWithMatrixAroundX;
    procedure TestRotateWithMatrixAroundY;
    procedure TestRotateWithMatrixAroundZ;
    procedure TestRotateAroundX;
    procedure TestRotateAroundY;
    procedure TestRotateAroundZ;
    procedure TestAverageNormal4;
    procedure TestPointProject;
    procedure TestMoveAround;
    procedure TestShiftObjectFromCenter;
    procedure TestExtendClipRect;
    procedure TestStep;
    procedure TestFaceForward;
    procedure TestSaturate;
    procedure TestSmoothStep;

  end;

implementation

{ TVectorHelperTestCase }

procedure TVectorHelperTestCase.Setup;
begin
  inherited Setup;
  nt3.Create(10.350,10.470,2.482,0.0);
  nt4.Create(20.350,18.470,8.482,0.0);
  nph1.Create(nt1,nt2,nt3);
  ph1.V := nph1.V;
  vt3.V := nt3.V;
  vt4.V := nt4.V;
  alpha := pi / 6;
end;

{%region%====[ TVectorHelperTestCase ]========================================}


procedure TVectorHelperTestCase.TestRotate;
begin
  nt3 := nt1.Rotate(NativeYHmgVector,alpha);
  vt3 := vt1.Rotate(YHmgVector,alpha);
  AssertTrue('VectorHelper Rotate do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
  vt1.Create(1,1,1,1);  // unit point
   vt4 := vt1.Rotate(ZHmgVector, pi/2);
   AssertEquals('Rotate:Sub1 X failed ', -1.0, vt4.X);
   AssertEquals('Rotate:Sub2 Y failed ',  1.0, vt4.Y);
   AssertEquals('Rotate:Sub3 Z failed ',  1.0, vt4.Z);
   AssertEquals('Rotate:Sub4 W failed ',  1.0, vt4.W);
   vt4 := vt1.Rotate(ZHmgVector, -pi/2);
   AssertEquals('Rotate:Sub5 X failed ',  1.0, vt4.X);
   AssertEquals('Rotate:Sub6 Y failed ', -1.0, vt4.Y);
   AssertEquals('Rotate:Sub7 Z failed ',  1.0, vt4.Z);
   AssertEquals('Rotate:Sub8 W failed ',  1.0, vt4.W);
   // inverted axis vector result should be opposite from above
   vt4 := vt1.Rotate(-ZHmgVector, pi/2);
   AssertEquals('Rotate:Sub9 X failed ',   1.0, vt4.X);
   AssertEquals('Rotate:Sub10 Y failed ', -1.0, vt4.Y);
   AssertEquals('Rotate:Sub11 Z failed ',  1.0, vt4.Z);
   AssertEquals('Rotate:Sub12 W failed ',  1.0, vt4.W);
   vt4 := vt1.Rotate(-ZHmgVector, -pi/2);
   AssertEquals('Rotate:Sub13 X failed ', -1.0, vt4.X);
   AssertEquals('Rotate:Sub14 Y failed ',  1.0, vt4.Y);
   AssertEquals('Rotate:Sub15 Z failed ',  1.0, vt4.Z);
   AssertEquals('Rotate:Sub16 W failed ',  1.0, vt4.W);
end;

procedure TVectorHelperTestCase.TestRotateWithMatrixAroundX;
begin
  nt3 := nt1.RotateWithMatrixAroundX(alpha);
  vt3 := vt1.RotateWithMatrixAroundX(alpha);
  AssertTrue('VectorHelper Rotate WithMatrix Around X do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestRotateWithMatrixAroundY;
begin
  nt3 := nt1.RotateWithMatrixAroundY(alpha);
  vt3 := vt1.RotateWithMatrixAroundY(alpha);
  AssertTrue('VectorHelper Rotate WithMatrix Around Y do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestRotateWithMatrixAroundZ;
begin
  nt3 := nt1.RotateWithMatrixAroundZ(alpha);
  vt3 := vt1.RotateWithMatrixAroundZ(alpha);
  AssertTrue('VectorHelper Rotate WithMatrix Around Z do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestRotateAroundX;
begin
  nt3 := nt1.RotateAroundX(alpha);
  vt3 := vt1.RotateAroundX(alpha);
  AssertTrue('VectorHelper Rotate Around X do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestRotateAroundY;
begin
  nt3 := nt1.RotateAroundY(alpha);
  vt3 := vt1.RotateAroundY(alpha);
  AssertTrue('VectorHelper Rotate Around Y do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestRotateAroundZ;
begin
  nt3 := nt1.RotateAroundZ(alpha);
  vt3 := vt1.RotateAroundZ(alpha);
  AssertTrue('VectorHelper Rotate Around Z do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestAverageNormal4;
begin
  nt5 := nt1.AverageNormal4(nt1,nt2,nt3,nt4);
  vt5 := vt1.AverageNormal4(vt1,vt2,vt3,vt4);
  AssertTrue('VectorHelper AverageNormal4 no match'+nt5.ToString+' --> '+vt5.ToString, Compare(nt5,vt5, 1e-5));
end;

procedure TVectorHelperTestCase.TestPointProject;
begin
  Fs1 := nt1.PointProject(nt2,nt3);
  Fs2 := vt1.PointProject(vt2,vt3);
  AssertTrue('VectorHelper PointProject do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorHelperTestCase.TestMoveAround;
begin
  nt3 := nt1.MoveAround(NativeYHmgVector,nt2, alpha, alpha);
  vt3 := vt1.MoveAround(YHmgVector,vt2, alpha, alpha);
  AssertTrue('VectorHelper Move Z does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3,1e-5));
end;

procedure TVectorHelperTestCase.TestShiftObjectFromCenter;
begin
  nt3 := nt1.ShiftObjectFromCenter(nt2, Fs1, True);
  vt3 := vt1.ShiftObjectFromCenter(vt2, Fs1, True);
  AssertTrue('VectorHelper ShiftObjectFromCenter does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestExtendClipRect;
var
  nCr: TNativeGLZClipRect;
  aCr: TGLZClipRect;
begin
  nCr.V := nt1.V;
  aCr.V := vt1.V;
  nCr.ExtendClipRect(Fs1,Fs2);
  aCr.ExtendClipRect(Fs1,Fs2);
  AssertTrue('VectorHelper ExtendClipRect does not match : '+nCr.ToString+' --> '+nCr.ToString, Compare(nCr,aCr));
end;

procedure TVectorHelperTestCase.TestStep;
begin
  nt3 := nt1.Step(nt2);
  vt3 := vt1.Step(vt2);
  AssertTrue('VectorHelper Step does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestFaceForward;
begin
  //nt3 := nt1.Step(nt2);
  //vt3 := vt1.Step(vt2);
  //AssertTrue('VectorHelper Step does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestSaturate;
begin
  nt3 := nt1.Saturate;
  vt3 := vt1.Saturate;
  AssertTrue('VectorHelper Saturate does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestSmoothStep;
begin

end;

{%endregion%}


initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVectorHelperTestCase);
end.

