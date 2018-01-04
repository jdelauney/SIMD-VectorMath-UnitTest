unit VectorAndHmgPlaneHelperTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVectorAndHmgPlaneHelperTestCase }

  TVectorAndHmgPlaneHelperTestCase = class(TVectorBaseTestCase)
  protected
    procedure Setup; override;
  public
    {$CODEALIGN RECORDMIN=16}
    nph1, nph2,nph3 : TNativeGLZHmgPlane; //TNativeGLZHmgPlaneHelper;
    nt4,nt5 : TNativeGLZVector;
    vt4, vt5 : TGLZVector;
    ph1,ph2,ph3     : TGLZHmgPlane; //TGLZHmgPlaneHelper;
    {$CODEALIGN RECORDMIN=4}
    alpha: single;
  published
    procedure TestCreatePlane3Vec;
    procedure TestCreatePlanePointNorm;
    procedure TestNormalizePlane;
    procedure TestCalcPlaneNormal;
    procedure TestDistancePlaneToPoint;
    procedure TestDistancePlaneToSphere;
    procedure TestRotate;
    procedure TestRotateAroundX;
    procedure TestRotateAroundY;
    procedure TestRotateAroundZ;
    procedure TestAverageNormal4;
    procedure TestPointProject;
    procedure TestIsColinear;
    procedure TestMoveAround;
    procedure TestShiftObjectFromCenter;
    procedure TestExtendClipRect;

  end;

implementation

{ THmgPlaneHelperTestCase }

procedure TVectorAndHmgPlaneHelperTestCase.Setup;
begin
  inherited Setup;
  nt3.Create(10.350,10.470,2.482,0.0);
  nt4.Create(20.350,18.470,8.482,0.0);
  nph1.CreatePlane(nt1,nt2,nt3);
  ph1.V := nph1.V;
  vt3.V := nt3.V;
  vt4.V := nt4.V;
  alpha := pi / 6;
end;

{%region%====[ THmgPlaneHelperTestCase ]========================================}

procedure TVectorAndHmgPlaneHelperTestCase.TestCreatePlane3Vec;
begin
  nph1.CreatePlane(nt1,nt2,nt3);
  ph1.CreatePlane(vt1,vt2,vt3);
  AssertTrue('HmgPlaneHelper CreatePlane 3Vec  no match'+nph1.ToString+' --> '+ph1.ToString, Compare(nph1,ph1, 1e-5));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestCreatePlanePointNorm;
begin
  nph1.CreatePlane(nt1,nt2);
  ph1.CreatePlane(vt1,vt2);
  AssertTrue('HmgPlaneHelper CreatePlane Point Norm  no match'+nph1.ToString+' --> '+ph1.ToString, Compare(nph1,ph1, 1e-5));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestNormalizePlane;
begin
  nph3:= nph1.NormalizePlane;
  ph3 := ph1.NormalizePlane;
  AssertTrue('HmgPlaneHelper NormalizePlane no match'+nph3.ToString+' --> '+ph3.ToString, Compare(nph3,ph3));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestCalcPlaneNormal;
begin
  nph1.CalcPlaneNormal(nt1,nt2,nt3);
  ph1.CalcPlaneNormal(vt1,vt2,vt3);
  AssertTrue('HmgPlaneHelper CreatePlane 3Vec  no match'+nph1.ToString+' --> '+ph1.ToString, Compare(nph1,ph1, 1e-5));

end;

procedure TVectorAndHmgPlaneHelperTestCase.TestDistancePlaneToPoint;
begin
  Fs1 := nph1.DistancePlaneToPoint(nt3);
  Fs2 := ph1.DistancePlaneToPoint(vt3);
  AssertTrue('HmgPlaneHelper DistanceToPoint do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestDistancePlaneToSphere;
begin
  nt3 := nt3 * 2.0;
  vt3 := vt3 * 2.0;
  Fs1 := nph1.DistancePlaneToSphere(nt3,0.5);
  Fs2 := ph1.DistancePlaneToSphere(vt3,0.5);
  AssertTrue('HmgPlaneHelper DistanceToSphere do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestRotate;
begin
  nt3 := nt1.Rotate(NativeYHmgVector,alpha);
  vt3 := vt1.Rotate(YHmgVector,alpha);
  AssertTrue('HmgPlaneHelper Rotate do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestRotateAroundX;
begin
  nt3 := nt1.RotateAroundX(alpha);
  vt3 := vt1.RotateAroundX(alpha);
  AssertTrue('HmgPlaneHelper Rotate Around X do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestRotateAroundY;
begin
  nt3 := nt1.RotateAroundY(alpha);
  vt3 := vt1.RotateAroundY(alpha);
  AssertTrue('HmgPlaneHelper Rotate Around Y do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestRotateAroundZ;
begin
  nt3 := nt1.RotateAroundZ(alpha);
  vt3 := vt1.RotateAroundZ(alpha);
  AssertTrue('HmgPlaneHelper Rotate Around Z do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestAverageNormal4;
begin
  nt5 := nt1.AverageNormal4(nt1,nt2,nt3,nt4);
  vt5 := vt1.AverageNormal4(vt1,vt2,vt3,vt4);
  AssertTrue('VectorHelper AverageNormal4 no match'+nt5.ToString+' --> '+vt5.ToString, Compare(nt5,vt5, 1e-7));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestPointProject;
begin
  Fs1 := nt1.PointProject(nt2,nt3);
  Fs2 := vt1.PointProject(vt2,vt3);
  AssertTrue('VectorHelper PointProject do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestIsColinear;
begin
  nb := nt1.IsColinear(nt2);
  vb := vt1.IsColinear(vt2);
  AssertTrue('VectorHelper IsColinear does not match : ', (vb = nb));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestMoveAround;
begin
  nt3 := nt1.MoveAround(NativeYHmgVector,nt2, alpha, alpha);
  vt3 := vt1.MoveAround(YHmgVector,vt2, alpha, alpha);
  AssertTrue('HmgPlaneHelper Move Z does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3,1e-5));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestShiftObjectFromCenter;
begin
  nt3 := nt1.ShiftObjectFromCenter(nt2, Fs1, True);
  vt3 := vt1.ShiftObjectFromCenter(vt2, Fs1, True);
  AssertTrue('HmgPlaneHelper ShiftObjectFromCenter does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestExtendClipRect;
var
  nCr: TNativeGLZClipRect;
  aCr: TGLZClipRect;
begin
  nCr.V := nt1.V;
  aCr.V := vt1.V;
  nCr.ExtendClipRect(Fs1,Fs2);
  aCr.ExtendClipRect(Fs1,Fs2);
  AssertTrue('HmgPlaneHelper ExtendClipRect does not match : '+nCr.ToString+' --> '+nCr.ToString, Compare(nCr,aCr));
end;

{%endregion%}


initialization
  RegisterTest(REPORT_GROUP_PLANE_HELP, TVectorAndHmgPlaneHelperTestCase);
end.

