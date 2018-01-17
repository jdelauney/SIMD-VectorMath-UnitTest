unit HmgPlaneComparatorTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;


type

  { THmgPlaneComparatorTest }

  THmgPlaneComparatorTest = class(TVectorBaseTestCase)
    protected
      {$CODEALIGN RECORDMIN=16}
      vt5 : TGLZVector;
      nph1, nph2,nph3 : TNativeGLZHmgPlane;
      ph1,ph2,ph3     : TGLZHmgPlane;
      nt4: TNativeGLZVector;
      procedure Setup; override;
    published
      procedure TestCompare;
      procedure TestCompareFalse;
      procedure TestCreate3Vec;
      procedure TestCreatePointNorm;
      procedure TestNormalizeSelf;
      procedure TestNormalized;
      procedure TestDistanceToPoint;
      procedure TestAbsDistanceToPoint;
      procedure TestDistanceToSphere;
      procedure TestIsInHalfSpace;

      // helpers
      procedure TestContainsBSphere;
    end;

implementation

{ THmgPlaneComparatorTest }

procedure THmgPlaneComparatorTest.Setup;
begin
  inherited Setup;
  vt1.Create(10.350,16.470,4.482,1.0);    // decent hpoints paralel to xy plane
  vt2.Create(20.350,18.470,4.482,1.0);
  vt3.Create(10.350,10.470,2.482,1.0);
  vt4.Create(20.350,17.470,4.482,1.0);
  ph2.Create(vt1,vt2,vt4);                // plane @z 4.482 z- norm
  ph1.Create(vt1,vt4,vt2);                // plane @z 4.482 z+ norm
  nph1.V := ph1.V;
  nt1.V := vt1.V;
  nt2.V := vt2.V;
  nt3.V := vt3.V;
  nt4.V := vt4.V;
end;

procedure THmgPlaneComparatorTest.TestCompare;
begin
  AssertTrue('Test Values do not match', Compare(nph1,ph1));
end;

procedure THmgPlaneComparatorTest.TestCompareFalse;
begin
  AssertFalse('Test Values should not match', Compare(nph1,ph2));
end;

procedure THmgPlaneComparatorTest.TestCreate3Vec;
begin
  nph1.Create(nt1,nt4,nt2);
  ph1.Create(vt1,vt4,vt2);
  AssertTrue('THmgPlane Create3Vector does not match', Compare(nph1,ph1));
end;

procedure THmgPlaneComparatorTest.TestCreatePointNorm;
begin
  nph1.Create(nt1,NativeZHmgVector);
  ph1.Create(vt1,ZHmgVector);
  AssertTrue('THmgPlane PointNorm does not match', Compare(nph1,ph1));
end;

procedure THmgPlaneComparatorTest.TestNormalizeSelf;
begin
  nph1.Create(nt1,nt3);
  ph1.Create(vt1,vt3);
  nph1.Normalize;
  ph1.Normalize;
  AssertTrue('THmgPlane NormalizeSelf does not match ', Compare(nph1,ph1,1e-5));
end;

procedure THmgPlaneComparatorTest.TestNormalized;
begin
  nph1.Create(nt1,nt3);
  ph1.Create(vt1,vt3);
  nph2 := nph1.Normalized;
  ph2 := ph1.Normalized;
  AssertTrue('THmgPlane Normalized does not match', Compare(nph2,ph2,1e-5));
end;

procedure THmgPlaneComparatorTest.TestDistanceToPoint;
begin
  fs1 := nph1.Distance(nt3);
  fs2 := ph1.Distance(vt3);
  AssertTrue('THmgPlane DistanceToPoint does not match', IsEqual(fs1,fs2));
end;

procedure THmgPlaneComparatorTest.TestAbsDistanceToPoint;
begin
  fs1 := nph1.AbsDistance(nt3);
  fs2 := ph1.AbsDistance(vt3);
  AssertTrue('THmgPlane AbsDistanceToPoint does not match', IsEqual(fs1,fs2));
end;

procedure THmgPlaneComparatorTest.TestDistanceToSphere;
begin
  fs1 := nph1.Distance(NativeNullHmgVector,1.234);
  fs2 := ph1.Distance(NullHmgVector,1.234);
  AssertTrue('THmgPlane DistanceToSphere does not match', IsEqual(fs1,fs2));
end;

procedure THmgPlaneComparatorTest.TestIsInHalfSpace;
begin
  nb := nph1.IsInHalfSpace(nt3);
  ab := ph1.IsInHalfSpace(vt3);
  AssertTrue('THmgPlane IsInHalfSpace does not match', (nb = ab));
end;

procedure THmgPlaneComparatorTest.TestContainsBSphere;
var
  nsp: TNativeGLZBoundingSphere;
  asp: TGLZBoundingSphere;
  nct, act: TGLZSpaceContains;
begin
  nsp.Create(NativeNullHmgVector, 2);
  asp.Create(NullHmgVector, 2);
  nct := nph1.Contains(nsp);
  act := ph1.Contains(asp);
  AssertTrue('THmgPlane ContainsBSphere does not match', (nct=act));
end;

initialization
  RegisterTest(REPORT_GROUP_PLANE_HELP, THmgPlaneComparatorTest);
end.

