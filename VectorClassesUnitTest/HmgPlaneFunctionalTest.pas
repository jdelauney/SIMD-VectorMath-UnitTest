unit HmgPlaneFunctionalTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  { THmgPlaneFunctionalTest }

  THmgPlaneFunctionalTest = class(TVectorBaseTestCase)
    protected
      {$CODEALIGN RECORDMIN=16}
      vt5 : TGLZVector;
      ph1,ph2,ph3     : TGLZHmgPlane; //TGLZHmgPlaneHelper;
      procedure Setup; override;
    published
      procedure TestCreate3Vec;
      procedure TestCreatePointNorm;
      procedure TestDefaultPlane;
      procedure TestNormalizeSelf;
      procedure TestNormalize;
      procedure TestDistanceToPoint;
      procedure TestAbsDistanceToPoint;
      procedure TestDistanceToSphere;
      procedure TestPerpendicular;
      procedure TestReflect;
      procedure TestIsInHalfSpace;

      // helpers
      procedure TestContainsBSphere;
  end;

implementation

{ THmgPlaneFunctionalTest }

procedure THmgPlaneFunctionalTest.Setup;
begin
  inherited Setup;
  vt1.Create(10.350,16.470,4.482,1.0);    // decent hpoints paralel to xy plane
  vt2.Create(20.350,18.470,4.482,1.0);
  vt3.Create(10.350,10.470,2.482,1.0);
  vt4.Create(20.350,17.470,4.482,1.0);
  ph1.Create(vt1,vt4,vt2);                // plane @z 4.482 z+ norm
end;

procedure THmgPlaneFunctionalTest.TestCreate3Vec;
begin
  // create from three points
  ph1.Create(vt1,vt2,vt3);
  // all points should satisfy
  // plane.A*Point.X + plane.B*Point.Y + plane.C*Point.Z + PlaneD = 0
  fs1 := ph1.A * vt1.X + ph1.B * vt1.Y + ph1.C * vt1.Z + ph1.D;
  AssertTrue('TGLZHmgPlane:Create3Vec:sub1 Point 1 does not lie on plane', IsEqual(fs1,0, 1e-5));
  fs1 := ph1.A * vt2.X + ph1.B * vt2.Y + ph1.C * vt2.Z + ph1.D;
  AssertTrue('TGLZHmgPlane:Create3Vec:sub2 Point 2 does not lie on plane', IsEqual(fs1,0, 1e-5));
  fs1 := ph1.A * vt3.X + ph1.B * vt3.Y + ph1.C * vt3.Z + ph1.D;
  AssertTrue('TGLZHmgPlane:Create3Vec:sub3 Point 3 does not lie on plane', IsEqual(fs1,0, 1e-5));
  fs1 := ph1.A * vt4.X + ph1.B * vt4.Y + ph1.C * vt4.Z + ph1.D;
  AssertFalse('TGLZHmgPlane:Create3Vec:sub4 Point 4 does should not lie on plane', IsEqual(fs1,0, 1e-5));
end;

procedure THmgPlaneFunctionalTest.TestCreatePointNorm;
var
  norm: TGLZVector;
begin
  // first off create a known working plane
  ph1.Create(vt1,vt2,vt3);
  norm.AsVector3f := ph1.AsNormal3;

  ph2.Create(vt3,norm);
  AssertTrue('TGLZHmgPlane:CreatePointNorm:Sub1 planes do not match', compare(ph1,ph2, 1e-5));

  fs1 := ph2.A * vt1.X + ph2.B * vt1.Y + ph2.C * vt1.Z + ph2.D;
  AssertTrue('TGLZHmgPlane:Create3Vec:sub2 Point 1 does not lie on plane', IsEqual(fs1,0, 1e-5));
  fs1 := ph2.A * vt2.X + ph2.B * vt2.Y + ph2.C * vt2.Z + ph2.D;
  AssertTrue('TGLZHmgPlane:Create3Vec:sub3 Point 2 does not lie on plane', IsEqual(fs1,0, 1e-5));

  // make a non normalized vector with the same direction
  // this plane is good for
  norm.pMul(3.56);
  ph2.Create(vt3,norm);
  fs1 := ph2.A * vt1.X + ph2.B * vt1.Y + ph2.C * vt1.Z + ph2.D;
  AssertTrue('TGLZHmgPlane:Create3Vec:sub4 Point 1 does not lie on plane', IsEqual(fs1,0, 1e-5));

end;

procedure THmgPlaneFunctionalTest.TestDefaultPlane;
begin
  AssertTrue('TGLZHmgPlane:NormalizeSelf:Sub1 planes do not match', IsEqual(ph1.x,0));
  AssertTrue('TGLZHmgPlane:NormalizeSelf:Sub1 planes do not match', IsEqual(ph1.y,0));
  AssertTrue('TGLZHmgPlane:NormalizeSelf:Sub1 planes do not match', IsEqual(ph1.z,1));
  AssertTrue('TGLZHmgPlane:NormalizeSelf:Sub1 planes do not match', IsEqual(ph1.W,-4.482));
end;

procedure THmgPlaneFunctionalTest.TestNormalizeSelf;
var
  norm: TGLZVector;
begin
  norm.AsVector3f := ph1.AsNormal3;

  ph2.Create(vt4,norm);
  AssertTrue('TGLZHmgPlane:NormalizeSelf:Sub1 planes do not match', compare(ph1,ph2));
  norm.pMul(3.56);
  ph2.Create(vt4,norm);
  AssertFalse('TGLZHmgPlane:NormalizeSelf:Sub2 planes should not match', compare(ph1,ph2));
  ph2.Normalize;
  AssertTrue('TGLZHmgPlane:NormalizeSelf:Sub3 planes do not match', compare(ph1,ph2, 1e-5));
end;

procedure THmgPlaneFunctionalTest.TestNormalize;
var
  norm: TGLZVector;
begin
  ph1.Create(vt1,vt2,vt4);
  norm.AsVector3f := ph1.AsNormal3;
//  norm.Create(4,4,4);
  norm.pMul(3.56);
  ph2.Create(vt4,norm);
  AssertFalse('TGLZHmgPlane:Normalize:Sub1 planes should not match', compare(ph1,ph2));
  ph3 := ph2.Normalized;
  AssertTrue('TGLZHmgPlane:NormalizeSelf:Sub2 planes do not match', compare(ph1,ph3, 1e-5));

end;

procedure THmgPlaneFunctionalTest.TestDistanceToPoint;
begin
   vt5.Create(0,0,0,1);
         //
   // is this plane any use to this test.
   AssertTrue('TGLZHmgPlane:DistanceToPoint:Sub1 Plane not suitable for test', (Abs(ph1.W) > 1));

   fs1 := ph1.Distance(vt5);
   AssertTrue('TGLZHmgPlane:DistanceToPoint:Sub2 Lengths do not match', IsEqual(ph1.W, fs1, 1e-5));
   vt5 := ph1.AsVector * -ph1.W;
   vt5.W := 1;
   fs1 := ph1.Distance(vt5);
   AssertTrue('TGLZHmgPlane:DistanceToPoint:Sub3 Lengths do not match', IsEqual(0, fs1, 1e-5));
   vt5 := ph1.AsVector * -ph1.W * 2;
   vt5.W := 1;
   fs1 := ph1.Distance(vt5);
   AssertTrue('TGLZHmgPlane:DistanceToPoint:Sub4 Lengths do not match', IsEqual(-ph1.W, fs1, 1e-5));
end;

procedure THmgPlaneFunctionalTest.TestAbsDistanceToPoint;
begin
  vt5.Create(0,0,0,1);
  ph1.Create(vt1,vt2,vt4);
  // is this plane any use to this test.
  AssertTrue('TGLZHmgPlane:DistanceToPoint:Sub1 Plane not suitable for test', (Abs(ph1.W) > 1));

  fs1 := ph1.AbsDistance(vt5);
  AssertTrue('TGLZHmgPlane:DistanceToPoint:Sub2 Lengths do not match', IsEqual(Abs(ph1.W), fs1, 1e-5));
  vt5 := ph1.AsVector * -ph1.W;
  vt5.W := 1;
  fs1 := ph1.AbsDistance(vt5);
  AssertTrue('TGLZHmgPlane:DistanceToPoint:Sub3 Lengths do not match', IsEqual(0, fs1, 1e-5));
  vt5 := ph1.AsVector * -ph1.W * 2;
  vt5.W := 1;
  fs1 := ph1.AbsDistance(vt5);
  AssertTrue('TGLZHmgPlane:DistanceToPoint:Sub4 Lengths do not match', IsEqual(Abs(ph1.W), fs1, 1e-5));
end;

procedure THmgPlaneFunctionalTest.TestDistanceToSphere;
begin
   vt5.Create(0,0,0,1);
   fs1 := ph1.Distance(vt5, 2);
   // is this plane any use to this test.
   AssertTrue('TGLZHmgPlane:DistanceToSphere:Sub1 Plane not suitable for test', (Abs(ph1.W) > 1));

   AssertTrue('TGLZHmgPlane:DistanceToSphere:Sub2 Lengths do not match', IsEqual(ph1.W + 2, fs1, 1e-5));
   vt5 := ph1.AsVector * -ph1.W;
   vt5.W := 1;
   fs1 := ph1.Distance(vt5, 6);
   AssertTrue('TGLZHmgPlane:DistanceToSphere:Sub3 Lengths do not match', IsEqual(0, fs1, 1e-5));
   vt5 := ph1.AsVector * -ph1.W * 2;
   vt5.W := 1;
   fs1 := ph1.Distance(vt5,2);
   AssertTrue('TGLZHmgPlane:DistanceToSphere:Sub4 Lengths do not match', IsEqual(-ph1.W - 2, fs1, 1e-5));
end;

procedure THmgPlaneFunctionalTest.TestIsInHalfSpace;
begin
   vt5.Create(0,0,0,1);
   nb := ph1.IsInHalfSpace(vt5);

   // is this plane any use to this test.
   AssertTrue('TGLZHmgPlane:IsInHalfSpace:Sub1 Plane not suitable for test', (Abs(ph1.W) > 1));

   if ph1.W > 0 then // origin should be in half space
     AssertTrue('TGLZHmgPlane:InHalfSpace:Sub2 half space failed', nb)
   else
     AssertFalse('TGLZHmgPlane:InHalfSpace:Sub2 half space failed', nb);

   vt5 := ph1.AsVector * (abs(ph1.W) * 2);
   vt5.W := 1;
   nb := ph1.IsInHalfSpace(vt5);
   if ph1.W > 0 then // origin should be in half space
     AssertFalse('TGLZHmgPlane:InHalfSpace:Sub3 half space failed', nb)
   else
     AssertTrue('TGLZHmgPlane:InHalfSpace:Sub3 half space failed', nb);
end;

procedure THmgPlaneFunctionalTest.TestPerpendicular;
begin
  //vt1.Create(1,1,1,1);
  //vt2 := vt1.Normalize;
  //vt4 := ph1.Perpendicular(YHmgPoint);
  //AssertEquals('Perpendicular:Sub1 X failed ',  0, vt4.X);
  //AssertEquals('Perpendicular:Sub2 Y failed ',  0, vt4.Y);
  //AssertEquals('Perpendicular:Sub3 Z failed ',  1, vt4.Z);
  //AssertEquals('Perpendicular:Sub4 W failed ',  0, vt4.W);
  //vt4 := ph1.Perpendicular(ZHmgVector);
  //AssertEquals('Perpendicular:Sub4 X failed ',  0, vt4.X);
  //AssertEquals('Perpendicular:Sub5 Y failed ',  0, vt4.Y);
  //AssertEquals('Perpendicular:Sub6 Z failed ',  1, vt4.Z);
  //AssertEquals('Perpendicular:Sub7 W failed ',  0, vt4.W);
end;

// Result := Self - (N*(2 * N.Dotproduct(Self)));

procedure THmgPlaneFunctionalTest.TestReflect;
begin

end;


procedure THmgPlaneFunctionalTest.TestContainsBSphere;
var
  sp: TGLZBoundingSphere;
  ct: TGLZSpaceContains;
begin

  vt5.Create(0,0,0,1);
  // is this plane any use to this test.
  AssertTrue('TGLZHmgPlane:ContainsBSphere:Sub1 Plane not suitable for test', (Abs(ph1.W) > 2));
  // sphere should not be touching plane
  sp.Create(vt5,1);
  ct := ph1.Contains(sp);
  AssertTrue('TGLZHmgPlane:ContainsBSphere:Sub2 Plane should not contain BSphere', (ScNoOverlap = ct));
  // grow sphere so it does touch the plane
  sp.Radius:= abs(ph1.W * 1.1);
  ct := ph1.Contains(sp);
  AssertTrue('TGLZHmgPlane:ContainsBSphere:Sub3 Plane should partially contain BSphere', (ScContainsPartially = ct));

  // is vt5 instance still center instance
  // shrink sphere
  sp.Radius := 1;
  vt5 := ph1.AsVector * abs(ph1.W);  // set vt5 to sit on plane
  AssertFalse('TGLZHmgPlane:ContainsBSphere:Sub4 Points are the same instance something changed', Compare(vt5,sp.Center));

  // small shpere center now sits on plane
  sp.Center := vt5;
  ct := ph1.Contains(sp);
  AssertTrue('TGLZHmgPlane:ContainsBSphere:Sub5 Plane should contain BSphere', (ScContainsPartially = ct));

  vt5 := ph1.AsVector * (abs(ph1.W) * 2);  // set sphere to sit in other side of plane
  vt5.W := 1;
  sp.Center := vt5;
  ct := ph1.Contains(sp);
  AssertTrue('TGLZHmgPlane:ContainsBSphere:Sub6 Plane should fully contain BSphere', (ScContainsFully = ct));


end;

initialization
  RegisterTest(REPORT_GROUP_PLANE_HELP, THmgPlaneFunctionalTest);
end.

