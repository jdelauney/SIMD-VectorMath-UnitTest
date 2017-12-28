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
  published
    procedure TestCreate;
    procedure TestNormalizePlane;
    procedure TestDistanceToPoint;
    procedure TestDistanceToSphere;
    procedure TestAverageNormal4;
    procedure TestPointProject;

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
end;

{%region%====[ THmgPlaneHelperTestCase ]========================================}

procedure TVectorAndHmgPlaneHelperTestCase.TestCreate;
begin
  nph1.CreatePlane(nt1,nt2,nt3);
  ph1.CreatePlane(vt1,vt2,vt3);
  AssertTrue('HmgPlaneHelper Create no match'+nph1.ToString+' --> '+ph1.ToString, Compare(nph1,ph1));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestNormalizePlane;
begin
  nph3:= nph1.NormalizePlane;
  ph3 := ph1.NormalizePlane;
  AssertTrue('HmgPlaneHelper NormalizePlane no match'+nph3.ToString+' --> '+ph3.ToString, Compare(nph3,ph3));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestDistanceToPoint;
begin
  Fs1 := nph1.DistancePlaneToPoint(nt3);
  Fs2 := ph1.DistancePlaneToPoint(vt3);
  AssertTrue('HmgPlaneHelper DistanceToPoint do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestDistanceToSphere;
begin
  nt3 := nt3 * 2.0;
  vt3 := vt3 * 2.0;
  Fs1 := nph1.DistancePlaneToSphere(nt3,0.5);
  Fs2 := ph1.DistancePlaneToSphere(vt3,0.5);
  AssertTrue('HmgPlaneHelper DistanceToSphere do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestAverageNormal4;
begin
  nt5 := nt1.AverageNormal4(nt1,nt2,nt3,nt4);
  vt5 := vt1.AverageNormal4(vt1,vt2,vt3,vt4);
  AssertTrue('VectorHelper AverageNormal4 no match'+nt5.ToString+' --> '+vt5.ToString, Compare(nt5,vt5));
end;

procedure TVectorAndHmgPlaneHelperTestCase.TestPointProject;
begin
  Fs1 := nt1.PointProject(nt2,nt3);
  Fs2 := vt1.PointProject(vt2,vt3);
  AssertTrue('VectorHelper PointProject do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

{%endregion%}


initialization
  RegisterTest(TVectorAndHmgPlaneHelperTestCase);
end.

