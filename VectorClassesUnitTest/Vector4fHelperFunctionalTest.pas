unit Vector4fHelperFunctionalTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;
type

  TVector4fHelperFunctionalTest = class(TVectorBaseTestCase)
    published
      procedure TestRotate;
      procedure TestRotateX;
      procedure TestRotateY;
      procedure TestRotateZ;
      procedure TestRotateWithMatrixAroundX;
      procedure TestRotateWithMatrixAroundY;
      procedure TestRotateWithMatrixAroundZ;
      procedure TestPointProject;
      procedure TestMoveAround;
      procedure TestShiftObjectFromCenter;
      procedure TestAverageNormal4;
      procedure TestExtendClipRect;
      procedure TestStep;
      procedure TestFaceForward;
      procedure TestSaturate;
      procedure TestSmoothStep;
      procedure TestReflect;
      //procedure Test;
      procedure TestPropertyXY;
      procedure TestPropertyYX;
      procedure TestPropertyXZ;
      procedure TestPropertyZX;
      procedure TestPropertyYZ;
      procedure TestPropertyZY;
      procedure TestPropertyXX;
      procedure TestPropertyYY;
      procedure TestPropertyZZ;
      procedure TestPropertyXYZ;
      procedure TestPropertyXZY;
      procedure TestPropertyYXZ;
      procedure TestPropertyYZX;
      procedure TestPropertyZXY;
      procedure TestPropertyZYX;
      procedure TestPropertyXXX;
      procedure TestPropertyYYY;
      procedure TestPropertyZZZ;
      procedure TestPropertyYYX;
      procedure TestPropertyXYY;
      procedure TestPropertyYXY;


  end;

implementation

// We are using right hand rule coordinate system
// positive rotations are anticlock wise.
// Axis orientation to view positives in Upper Right quadrant [as graph axes]
// with +Z pointing at you (as screen) positive X is to the right positive Y is Up
// with +Y pointing at you positive Z is to the right positive X is Up
// with +X pointing at you positive Y is to the left positive Z is up
procedure TVector4fHelperFunctionalTest.TestRotate;
begin
  vt1.Create(1,1,1,1);  // unit point
  // with +Z pointing at you (as screen) positive X is to the right positive Y is Up
  // positive rotation aroound z, X becomes negative
  vt4 := vt1.Rotate(ZHmgVector, pi/2);
  AssertEquals('Rotate:Sub1 X failed ', -1.0, vt4.X);
  AssertEquals('Rotate:Sub2 Y failed ',  1.0, vt4.Y);
  AssertEquals('Rotate:Sub3 Z failed ',  1.0, vt4.Z);
  AssertEquals('Rotate:Sub4 W failed ',  1.0, vt4.W);
  // negative rotation around z, y becomes negative
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
  // with +X pointing at you positive Y is to the left positive Z is up
  // positive rotation around x, Y becomes negative
  vt4 := vt1.Rotate(XHmgVector, pi/2);
  AssertEquals('Rotate:Sub17 X failed ',  1.0, vt4.X);
  AssertEquals('Rotate:Sub18 Y failed ', -1.0, vt4.Y);
  AssertEquals('Rotate:Sub19 Z failed ',  1.0, vt4.Z);
  AssertEquals('Rotate:Sub20 W failed ',  1.0, vt4.W);
  // negative rotation around x, Z becomes negative
  vt4 := vt1.Rotate(XHmgVector, -pi/2);
  AssertEquals('Rotate:Sub21 X failed ',  1.0, vt4.X);
  AssertEquals('Rotate:Sub22 Y failed ',  1.0, vt4.Y);
  AssertEquals('Rotate:Sub23 Z failed ', -1.0, vt4.Z);
  AssertEquals('Rotate:Sub24 W failed ',  1.0, vt4.W);
  // with +Y pointing at you positive Z is to the right positive X is Up
  // positive rotation around y, Z becomes negative
  vt4 := vt1.Rotate(YHmgVector, pi/2);
  AssertEquals('Rotate:Sub25 X failed ',  1.0, vt4.X);
  AssertEquals('Rotate:Sub26 Y failed ',  1.0, vt4.Y);
  AssertEquals('Rotate:Sub27 Z failed ', -1.0, vt4.Z);
  AssertEquals('Rotate:Sub28 W failed ',  1.0, vt4.W);
  // negative rotation around y, X becomes negative
  vt4 := vt1.Rotate(YHmgVector, -pi/2);
  AssertEquals('Rotate:Sub29 X failed ', -1.0, vt4.X);
  AssertEquals('Rotate:Sub30 Y failed ',  1.0, vt4.Y);
  AssertEquals('Rotate:Sub31 Z failed ',  1.0, vt4.Z);
  AssertEquals('Rotate:Sub32 W failed ',  1.0, vt4.W);
end;

procedure TVector4fHelperFunctionalTest.TestRotateX;
begin
  vt1.Create(1,1,1,1);  // unit point
  // with +X pointing at you positive Y is to the left positive Z is up
  // positive rotation around x, Y becomes negative
  vt4 := vt1.RotateAroundX(pi/2);
  AssertEquals('RotateX:Sub1 X failed ',  1.0, vt4.X);
  AssertEquals('RotateX:Sub2 Y failed ', -1.0, vt4.Y);
  AssertEquals('RotateX:Sub3 Z failed ',  1.0, vt4.Z);
  AssertEquals('RotateX:Sub4 W failed ',  1.0, vt4.W);
  // negative rotation around x, Z becomes negative
  vt4 := vt1.RotateAroundX(-pi/2);
  AssertEquals('RotateX:Sub5 X failed ',  1.0, vt4.X);
  AssertEquals('RotateX:Sub6 Y failed ',  1.0, vt4.Y);
  AssertEquals('RotateX:Sub7 Z failed ', -1.0, vt4.Z);
  AssertEquals('RotateX:Sub8 W failed ',  1.0, vt4.W);
end;

procedure TVector4fHelperFunctionalTest.TestRotateY;
begin
  vt1.Create(1,1,1,1);  // unit point
  // with +Y pointing at you positive Z is to the right positive X is Up
  // positive rotation around y, Z becomes negative
  vt4 := vt1.RotateAroundY(pi/2);
  AssertEquals('RotateY:Sub1 X failed ',  1.0, vt4.X);
  AssertEquals('RotateY:Sub2 Y failed ',  1.0, vt4.Y);
  AssertEquals('RotateY:Sub3 Z failed ', -1.0, vt4.Z);
  AssertEquals('RotateY:Sub4 W failed ',  1.0, vt4.W);
  // negative rotation around y, X becomes negative
  vt4 := vt1.RotateAroundY(-pi/2);
  AssertEquals('RotateY:Sub5 X failed ', -1.0, vt4.X);
  AssertEquals('RotateY:Sub6 Y failed ',  1.0, vt4.Y);
  AssertEquals('RotateY:Sub7 Z failed ',  1.0, vt4.Z);
  AssertEquals('RotateY:Sub8 W failed ',  1.0, vt4.W);
end;

procedure TVector4fHelperFunctionalTest.TestRotateZ;
begin
  vt1.Create(1,1,1,1);  // unit point
  // with +Z pointing at you (as screen) positive X is to the right positive Y is Up
  // positive rotation aroound z, X becomes negative
  vt4 := vt1.RotateAroundZ(pi/2);
  AssertEquals('RotateZ:Sub1 X failed ', -1.0, vt4.X);
  AssertEquals('RotateZ:Sub2 Y failed ',  1.0, vt4.Y);
  AssertEquals('RotateZ:Sub3 Z failed ',  1.0, vt4.Z);
  AssertEquals('RotateZ:Sub4 W failed ',  1.0, vt4.W);
  // negative rotation around z, y becomes negative
  vt4 := vt1.RotateAroundZ(-pi/2);
  AssertEquals('RotateZ:Sub5 X failed ',  1.0, vt4.X);
  AssertEquals('RotateZ:Sub6 Y failed ', -1.0, vt4.Y);
  AssertEquals('RotateZ:Sub7 Z failed ',  1.0, vt4.Z);
  AssertEquals('RotateZ:Sub8 W failed ',  1.0, vt4.W);
end;

procedure TVector4fHelperFunctionalTest.TestRotateWithMatrixAroundX;
begin
  vt1.Create(1,1,1,1);  // unit point
  // with +X pointing at you positive Y is to the left positive Z is up
  // positive rotation around x, Y becomes negative
  vt4 := vt1.RotateWithMatrixAroundX(pi/2);
  AssertEquals('RotateWithMatrixAroundX:Sub1 X failed ',  1.0, vt4.X);
  AssertEquals('RotateWithMatrixAroundX:Sub2 Y failed ', -1.0, vt4.Y);
  AssertEquals('RotateWithMatrixAroundX:Sub3 Z failed ',  1.0, vt4.Z);
  AssertEquals('RotateWithMatrixAroundX:Sub4 W failed ',  1.0, vt4.W);
  // negative rotation around x, Z becomes negative
  vt4 := vt1.RotateWithMatrixAroundX(-pi/2);
  AssertEquals('RotateWithMatrixAroundX:Sub5 X failed ',  1.0, vt4.X);
  AssertEquals('RotateWithMatrixAroundX:Sub6 Y failed ',  1.0, vt4.Y);
  AssertEquals('RotateWithMatrixAroundX:Sub7 Z failed ', -1.0, vt4.Z);
  AssertEquals('RotateWithMatrixAroundX:Sub8 W failed ',  1.0, vt4.W);
end;

procedure TVector4fHelperFunctionalTest.TestRotateWithMatrixAroundY;
begin
  vt1.Create(1,1,1,1);  // unit point
  // with +Y pointing at you positive Z is to the right positive X is Up
  // positive rotation around y, Z becomes negative
  vt4 := vt1.RotateWithMatrixAroundY(pi/2);
  AssertEquals('RotateWithMatrixAroundY:Sub1 X failed ',  1.0, vt4.X);
  AssertEquals('RotateWithMatrixAroundY:Sub2 Y failed ',  1.0, vt4.Y);
  AssertEquals('RotateWithMatrixAroundY:Sub3 Z failed ', -1.0, vt4.Z);
  AssertEquals('RotateWithMatrixAroundY:Sub4 W failed ',  1.0, vt4.W);
  // negative rotation around y, X becomes negative
  vt4 := vt1.RotateWithMatrixAroundY(-pi/2);
  AssertEquals('RotateWithMatrixAroundY:Sub5 X failed ', -1.0, vt4.X);
  AssertEquals('RotateWithMatrixAroundY:Sub6 Y failed ',  1.0, vt4.Y);
  AssertEquals('RotateWithMatrixAroundY:Sub7 Z failed ',  1.0, vt4.Z);
  AssertEquals('RotateWithMatrixAroundY:Sub8 W failed ',  1.0, vt4.W);
end;

procedure TVector4fHelperFunctionalTest.TestRotateWithMatrixAroundZ;
begin
  vt1.Create(1,1,1,1);  // unit point
  // with +Z pointing at you (as screen) positive X is to the right positive Y is Up
  // positive rotation aroound z, X becomes negative
  vt4 := vt1.RotateWithMatrixAroundZ(pi/2);
  AssertEquals('RotateWithMatrixAroundZ:Sub1 X failed ', -1.0, vt4.X);
  AssertEquals('RotateWithMatrixAroundZ:Sub2 Y failed ',  1.0, vt4.Y);
  AssertEquals('RotateWithMatrixAroundZ:Sub3 Z failed ',  1.0, vt4.Z);
  AssertEquals('RotateWithMatrixAroundZ:Sub4 W failed ',  1.0, vt4.W);
  // negative rotation around z, y bevome negative
  vt4 := vt1.RotateWithMatrixAroundZ(-pi/2);
  AssertEquals('RotateWithMatrixAroundZ:Sub5 X failed ',  1.0, vt4.X);
  AssertEquals('RotateWithMatrixAroundZ:Sub6 Y failed ', -1.0, vt4.Y);
  AssertEquals('RotateWithMatrixAroundZ:Sub7 Z failed ',  1.0, vt4.Z);
  AssertEquals('RotateWithMatrixAroundZ:Sub8 W failed ',  1.0, vt4.W);
end;


procedure TVector4fHelperFunctionalTest.TestPointProject;
begin
  // basically a sign test with 0 origin put a point in each octant with a dir from
  // origin to point and should end up with the same ans.
  vt1.Create(1,1,1,1);  // unit point
  vt2.Create(1,1,1,0);  // one vector not normalised
  fs1 := vt1.PointProject(NullHmgPoint,vt2);
  AssertEquals('PointProject:Sub1 failed ', 3 ,fs1);
  vt1.Create(-1,1,1,1);  // unit point
  vt2.Create(-1,1,1,0);  // unit vector
  fs1 := vt1.PointProject(NullHmgPoint,vt2);
  AssertEquals('PointProject:Sub2 failed ', 3 ,fs1);
  vt1.Create(-1,-1,1,1);  // unit point
  vt2.Create(-1,-1,1,0);  // unit vector
  fs1 := vt1.PointProject(NullHmgPoint,vt2);
  AssertEquals('PointProject:Sub3 failed ', 3 ,fs1);
  vt1.Create(-1,-1,-1,1);  // unit point
  vt2.Create(-1,-1,-1,0);  // unit vector
  fs1 := vt1.PointProject(NullHmgPoint,vt2);
  AssertEquals('PointProject:Sub4 failed ', 3 ,fs1);
  vt1.Create(1,-1,-1,1);  // unit point
  vt2.Create(1,-1,-1,0);  // unit vector
  fs1 := vt1.PointProject(NullHmgPoint,vt2);
  AssertEquals('PointProject:Sub5 failed ', 3 ,fs1);
  vt1.Create(-1,-1,1,1);  // unit point
  vt2.Create(-1,-1,1,0);  // unit vector
  fs1 := vt1.PointProject(NullHmgPoint,vt2);
  AssertEquals('PointProject:Sub6 failed ', 3 ,fs1);
  vt1.Create(1,-1,1,1);  // unit point
  vt2.Create(1,-1,1,0);  // unit vector
  fs1 := vt1.PointProject(NullHmgPoint,vt2);
  AssertEquals('PointProject:Sub7 failed ', 3 ,fs1);
  vt1.Create(1,1,-1,1);  // unit point
  vt2.Create(1,1,-1,0);  // unit vector
  fs1 := vt1.PointProject(NullHmgPoint,vt2);
  AssertEquals('PointProject:Sub8 failed ', 3 ,fs1);
  vt1.Create(1,1,1,1);  // unit point
  vt2.Create(1,1,1,0);  // check using using normalised vector
  vt2 := vt2.Normalize;
  fs1 := vt1.PointProject(NullHmgPoint,vt2);
  AssertEquals('PointProject:Sub9 failed ', Sqrt(3) ,fs1);
end;

// self is the camera or similar
// AMovingObjectUp  is the const vector to determine the orientation of looked at
//    object. We can only go up to down in this up axis over a range of 0 to pi
// This could be any orientation wanted not just target or world.
// NOTE Should this be named AReferenceUp as the routine does not care what the orientation is.
// ATargetPosition: The point at which the camera is pointing and the sphere center for lookat angle.
// Assuming we are looking at a sphere....
// pitch delta is change in latitude around the center clamped from 0 N to pi S  (values in degrees)
// turnDelta is the change in longitude around the polar axis (AMovingAxisUp)
// the routine seems to calc the current lat, long as polar vector in up oriented coords
// add deltas and return the new point.
// good this conforms to postive east negative west polar convention used in longitude notation
// now conforms to North Positive South negative as per latitude convention 
// now the only anomily between this and spherical geometry is that equator is is pi/2 instead of 0
// this is the cheapest option.
procedure TVector4fHelperFunctionalTest.TestMoveAround;
begin
  // first test scenario looking at screen graph coords with camera start pos at eye
  vt1.Create(0,0,1,1); // camera in pos z
  vt2.Create(0,0,0,1); // origin as center point
  vt3.Create(0,1,0,0); // affine vector for Y as up
  vt4 :=  vt1.MoveAround(vt3,vt2,0,90);  // move camera east
  AssertEquals('MoveAround:Sub1 X failed ',  1.0, vt4.X);  // camera sits on +x axis
  AssertEquals('MoveAround:Sub2 Y failed ',  0.0, vt4.Y);
  AssertEquals('MoveAround:Sub3 Z failed ',  0.0, vt4.Z);
  AssertEquals('MoveAround:Sub4 W failed ',  1.0, vt4.W);  // still a point
  vt4 :=  vt1.MoveAround(vt3,vt2,0,-90);  // move camera west
  AssertEquals('MoveAround:Sub5 X failed ', -1.0, vt4.X);  // camera sits on -x axis
  AssertEquals('MoveAround:Sub6 Y failed ',  0.0, vt4.Y);
  AssertEquals('MoveAround:Sub7 Z failed ',  0.0, vt4.Z);
  AssertEquals('MoveAround:Sub8 W failed ',  1.0, vt4.W);  // still a point
  vt3.Create(0,-1,0,0); // affine vector for -Y as up
  vt4 :=  vt1.MoveAround(vt3,vt2,0,90);  // move camera east
  AssertEquals('MoveAround:Sub9 X failed ', -1.0, vt4.X);  // camera sits on -x axis
  AssertEquals('MoveAround:Sub10 Y failed ',  0.0, vt4.Y);
  AssertEquals('MoveAround:Sub11 Z failed ',  0.0, vt4.Z);
  AssertEquals('MoveAround:Sub12 W failed ',  1.0, vt4.W);  // still a point
  vt4 :=  vt1.MoveAround(vt3,vt2,0,-90);  // move camera west
  AssertEquals('MoveAround:Sub13 X failed ',  1.0, vt4.X);  // camera sits on +x axis
  AssertEquals('MoveAround:Sub14 Y failed ',  0.0, vt4.Y);
  AssertEquals('MoveAround:Sub15 Z failed ',  0.0, vt4.Z);
  AssertEquals('MoveAround:Sub16 W failed ',  1.0, vt4.W);  // still a point
  // now test up and down for pos neg should be pos to go north and neg to go south
  vt3.Create(0,1,0,0); // affine vector for Y as up
  vt4 :=  vt1.MoveAround(vt3,vt2,90,0);  // move camera north
  AssertEquals('MoveAround:Sub17 X failed ',  0.0, vt4.X);
  // fails using this test as lat is clamped by small delta so never hit true 90
  //  AssertEquals('MoveAround:Sub6 Y failed ',  1.0, vt4.Y);  // camera sits on +y axis
  AssertTrue('MoveAround:Sub18 Y failed 1.0 --> '+FLoattostrF(vt4.Y,fffixed,3,3),  IsEqual(1.0, vt4.Y, 1e-3));  // camera sits near +y axis
  AssertTrue('MoveAround:Sub19 Z failed 0.0 --> '+FLoattostrF(vt4.Z,fffixed,3,3),  IsEqual(0.0, vt4.Z, 0.03));
  AssertEquals('MoveAround:Sub20 W failed ',  1.0, vt4.W);  // still a point
  vt4 :=  vt1.MoveAround(vt3,vt2,-90,0);  // move camera south
  AssertEquals('MoveAround:Sub21 X failed ',  0.0, vt4.X);
  AssertTrue('MoveAround:Sub22 Y failed -1.0 --> '+FLoattostrF(vt4.Y,fffixed,3,3), IsEqual(-1.0, vt4.Y, 1e-3));  // camera sits near +y axis
  AssertTrue('MoveAround:Sub23 Z failed  0.0 --> '+FLoattostrF(vt4.Z,fffixed,3,3), IsEqual( 0.0, vt4.Z, 0.03));
  AssertEquals('MoveAround:Sub24 W failed ',  1.0, vt4.W);  // still a point
  // second scenario real world coordinates
  vt1.Create(1,0,0,1); // camera in pos x
  vt2.Create(0,0,0,1); // origin as center point
  vt3.Create(0,0,1,0); // affine vector for Z as up
  vt4 :=  vt1.MoveAround(vt3,vt2,0,90);  // move camera east
  AssertEquals('MoveAround:Sub25 X failed ',  0.0, vt4.X);
  AssertEquals('MoveAround:Sub26 Y failed ',  1.0, vt4.Y);  // camera sits on +y axis
  AssertEquals('MoveAround:Sub27 Z failed ',  0.0, vt4.Z);
  AssertEquals('MoveAround:Sub28 W failed ',  1.0, vt4.W);  // still a point
  vt4 :=  vt1.MoveAround(vt3,vt2,0,-90);  // move camera west
  AssertEquals('MoveAround:Sub25 X failed ',  0.0, vt4.X);
  AssertEquals('MoveAround:Sub26 Y failed ', -1.0, vt4.Y);  // camera sits on -y axis
  AssertEquals('MoveAround:Sub27 Z failed ',  0.0, vt4.Z);
  AssertEquals('MoveAround:Sub28 W failed ',  1.0, vt4.W);  // still a point
end;

// this should be hmg safe, test as such
procedure TVector4fHelperFunctionalTest.TestShiftObjectFromCenter;
begin
  vt1.Create(1,1,1,1);  // self is unit point in positive octant
  vt3.Create(1,1,1,0);
  vt3 := vt3.Normalize; // direction vec normalised so we can calc expect result
  vt2.Create(0,0,0,1);  // keep it simple use orgin point as ACenter
  fs1 := 4.0;           // distance to move
  fs2 := 4.0 * vt3.X + 1;
  vt4 := vt1.ShiftObjectFromCenter(vt2, fs1, False);   // dist from self
  AssertEquals('ShiftObjectFromCenter:Sub5 X failed ',  fs2, vt4.X);
  AssertEquals('ShiftObjectFromCenter:Sub6 Y failed ',  fs2, vt4.Y);
  AssertEquals('ShiftObjectFromCenter:Sub7 Z failed ',  fs2, vt4.Z);
  AssertEquals('ShiftObjectFromCenter:Sub8 W failed ',  1.0, vt4.W);
  fs2 := 4.0 * vt3.X;
  vt4 := vt1.ShiftObjectFromCenter(vt2, fs1, True);   // dist from cen
  AssertEquals('ShiftObjectFromCenter:Sub5 X failed ',  fs2, vt4.X);
  AssertEquals('ShiftObjectFromCenter:Sub6 Y failed ',  fs2, vt4.Y);
  AssertEquals('ShiftObjectFromCenter:Sub7 Z failed ',  fs2, vt4.Z);
  AssertEquals('ShiftObjectFromCenter:Sub8 W failed ',  1.0, vt4.W);
end;

procedure TVector4fHelperFunctionalTest.TestAverageNormal4;
var
  cen: TGLZVector4f;
  left, right, up, down: TGLZVector4f;
begin
  // test with all points on xy plane cen raised
  // should have unit z vector result
  cen.Create(1,1,0.34,1);
  left.Create(0,1,0,1);
  right.Create(2,1,0,1);
  up.create(1,2,0,1);
  down.Create(1,0,0,1);
  vt4 := cen.AverageNormal4(up,left,down,right);
  AssertEquals('AverageNormal4:Sub1 X failed ',  0.0, vt4.X);
  AssertEquals('AverageNormal4:Sub2 Y failed ',  0.0, vt4.Y);
  AssertEquals('AverageNormal4:Sub3 Z failed ',  1.0, vt4.Z);
  AssertEquals('AverageNormal4:Sub4 W failed ',  0.0, vt4.W);
  // rotate above test around x axis by flipping up and down values
  // should have negative unit z vector result
  up.create(1,0,0,0);
  down.Create(1,2,0,0);
  vt4 := cen.AverageNormal4(up,left,down,right);
  AssertEquals('AverageNormal4:Sub5 X failed ',  0.0, vt4.X);
  AssertEquals('AverageNormal4:Sub6 Y failed ',  0.0, vt4.Y);
  AssertEquals('AverageNormal4:Sub7 Z failed ', -1.0, vt4.Z);
  AssertEquals('AverageNormal4:Sub8 W failed ',  0.0, vt4.W);
  //same for yz plane
  cen.Create(1,1,0.34,0);
  left.Create(0,0,1,0);
  right.Create(0,2,1,0);
  up.create(0,1,2,0);
  down.Create(0,1,0,0);
  vt4 := cen.AverageNormal4(up,left,down,right);
  AssertEquals('AverageNormal4:Sub9 X failed ',  1.0, vt4.X);
  AssertEquals('AverageNormal4:Sub10 Y failed ',  0.0, vt4.Y);
  AssertEquals('AverageNormal4:Sub11 Z failed ',  0.0, vt4.Z);
  AssertEquals('AverageNormal4:Sub12 W failed ',  0.0, vt4.W);
  left.Create(0,2,1,0);
  right.Create(0,0,1,0);
  vt4 := cen.AverageNormal4(up,left,down,right);
  AssertEquals('AverageNormal4:Sub13 X failed ', -1.0, vt4.X);
  AssertEquals('AverageNormal4:Sub14 Y failed ',  0.0, vt4.Y);
  AssertEquals('AverageNormal4:Sub15 Z failed ',  0.0, vt4.Z);
  AssertEquals('AverageNormal4:Sub16 W failed ',  0.0, vt4.W);
  //same for xz plane
  cen.Create(1,0.34,1,0);
  left.Create(2,0,1,0);
  right.Create(0,0,1,0);
  up.create(1,0,2,0);
  down.Create(1,0,0,0);
  vt4 := cen.AverageNormal4(up,left,down,right);
  AssertEquals('AverageNormal4:Sub17 X failed ',  0.0, vt4.X);
  AssertEquals('AverageNormal4:Sub18 Y failed ',  1.0, vt4.Y);
  AssertEquals('AverageNormal4:Sub19 Z failed ',  0.0, vt4.Z);
  AssertEquals('AverageNormal4:Sub20 W failed ',  0.0, vt4.W);
  left.Create(0,0,1,0);
  right.Create(2,0,1,0);
  vt4 := cen.AverageNormal4(up,left,down,right);
  AssertEquals('AverageNormal4:Sub21 X failed ',  0.0, vt4.X);
  AssertEquals('AverageNormal4:Sub22 Y failed ', -1.0, vt4.Y);
  AssertEquals('AverageNormal4:Sub23 Z failed ',  0.0, vt4.Z);
  AssertEquals('AverageNormal4:Sub24 W failed ',  0.0, vt4.W);
end;


// TGLZClipRect is screen coord biased rect Top < Bottom, Left < Right
// (Left, Top, Right, Bottom: Single)
procedure TVector4fHelperFunctionalTest.TestExtendClipRect;
begin
   vt1.create(0,0,12,12);
   vt4 := vt1.ExtendClipRect(14,14);
   AssertEquals('ExtendClipRect:Sub1 X failed ',  0.0, vt4.X);
   AssertEquals('ExtendClipRect:Sub2 Y failed ',  0.0, vt4.Y);
   AssertEquals('ExtendClipRect:Sub3 Z failed ', 14.0, vt4.Z);
   AssertEquals('ExtendClipRect:Sub4 W failed ', 14.0, vt4.W);
   vt4 := vt4.ExtendClipRect(-2,-2);
   AssertEquals('ExtendClipRect:Sub5 X failed ', -2.0, vt4.X);
   AssertEquals('ExtendClipRect:Sub6 Y failed ', -2.0, vt4.Y);
   AssertEquals('ExtendClipRect:Sub7 Z failed ', 14.0, vt4.Z);
   AssertEquals('ExtendClipRect:Sub8 W failed ', 14.0, vt4.W);
   vt4 := vt4.ExtendClipRect(2,2);
   AssertEquals('ExtendClipRect:Sub9 X failed ', -2.0, vt4.X);
   AssertEquals('ExtendClipRect:Sub10 Y failed ', -2.0, vt4.Y);
   AssertEquals('ExtendClipRect:Sub11 Z failed ', 14.0, vt4.Z);
   AssertEquals('ExtendClipRect:Sub12 W failed ', 14.0, vt4.W);
   vt4 := vt4.ExtendClipRect(-3,16);
   AssertEquals('ExtendClipRect:Sub13 X failed ', -3.0, vt4.X);
   AssertEquals('ExtendClipRect:Sub14 Y failed ', -2.0, vt4.Y);
   AssertEquals('ExtendClipRect:Sub15 Z failed ', 14.0, vt4.Z);
   AssertEquals('ExtendClipRect:Sub16 W failed ', 16.0, vt4.W);
end;

// more of a CanStep and to where function where it compares two vector and decides
// if needs to step in one of the directions. Positive only step functionality.
// or if a colour change transform does this component need changing
procedure TVector4fHelperFunctionalTest.TestStep;
begin
  vt2.Create(2,2,2,2);
  vt1.Create(2,2,2,2);
  vt4 := vt1.step(vt2);
  AssertEquals('Step:Sub1 X failed ',  0.0, vt4.X);
  AssertEquals('Step:Sub2 Y failed ',  0.0, vt4.Y);
  AssertEquals('Step:Sub3 Z failed ',  0.0, vt4.Z);
  AssertEquals('Step:Sub4 W failed ',  0.0, vt4.W);
  vt1.Create(3,2,2,2);
  vt4 := vt1.step(vt2);
  AssertEquals('Step:Sub5 X failed ',  3.0, vt4.X);
  AssertEquals('Step:Sub6 Y failed ',  0.0, vt4.Y);
  AssertEquals('Step:Sub7 Z failed ',  0.0, vt4.Z);
  AssertEquals('Step:Sub8 W failed ',  0.0, vt4.W);
  vt1.Create(2,3,2,2);
  vt4 := vt1.step(vt2);
  AssertEquals('Step:Sub9 X failed ',  0.0, vt4.X);
  AssertEquals('Step:Sub10 Y failed ',  3.0, vt4.Y);
  AssertEquals('Step:Sub11 Z failed ',  0.0, vt4.Z);
  AssertEquals('Step:Sub12 W failed ',  0.0, vt4.W);
  vt1.Create(2,2,3,2);
  vt4 := vt1.step(vt2);
  AssertEquals('Step:Sub13 X failed ',  0.0, vt4.X);
  AssertEquals('Step:Sub14 Y failed ',  0.0, vt4.Y);
  AssertEquals('Step:Sub15 Z failed ',  3.0, vt4.Z);
  AssertEquals('Step:Sub16 W failed ',  0.0, vt4.W);
  vt1.Create(2,2,2,3);
  vt4 := vt1.step(vt2);
  AssertEquals('Step:Sub17 X failed ',  0.0, vt4.X);
  AssertEquals('Step:Sub18 Y failed ',  0.0, vt4.Y);
  AssertEquals('Step:Sub19 Z failed ',  0.0, vt4.Z);
  AssertEquals('Step:Sub20 W failed ',  3.0, vt4.W);
  vt1.Create(3,2,3,2);
  vt4 := vt1.step(vt2);
  AssertEquals('Step:Sub21 X failed ',  3.0, vt4.X);
  AssertEquals('Step:Sub22 Y failed ',  0.0, vt4.Y);
  AssertEquals('Step:Sub23 Z failed ',  3.0, vt4.Z);
  AssertEquals('Step:Sub24 W failed ',  0.0, vt4.W);
  vt1.Create(2,3,2,3);
  vt4 := vt1.step(vt2);
  AssertEquals('Step:Sub25 X failed ',  0.0, vt4.X);
  AssertEquals('Step:Sub26 Y failed ',  3.0, vt4.Y);
  AssertEquals('Step:Sub27 Z failed ',  0.0, vt4.Z);
  AssertEquals('Step:Sub28 W failed ',  3.0, vt4.W);
end;

// self is N = normal vector of face /texel
// A is view vector
// B is perturbed Vector
// Note for this to work self must be part of a list of backfaces to test.
// this function will hide visible faces.
procedure TVector4fHelperFunctionalTest.TestFaceForward;
begin
  vt1.Create(1,1,1,0);  // test result vector, does not play a part in calcs
  vt2.Create(0,0,-1,0); // this is eye to screen +z out -z eye to screen
  vt3.create(0,0, 1,0); // pV is towards eye hidden face we want to show
  vt4 := vt1.FaceForward(vt2,vt3);
  AssertEquals('FaceForward:Sub1 X failed ',  -1.0, vt4.X);
  AssertEquals('FaceForward:Sub2 Y failed ',  -1.0, vt4.Y);
  AssertEquals('FaceForward:Sub3 Z failed ',  -1.0, vt4.Z);
  AssertEquals('FaceForward:Sub4 W failed ',   0.0, vt4.W);
  vt3.create(0,0,-1,0); // pV is away from eye remain hidden face
  vt4 :=  vt1.FaceForward(vt2,vt3);
  AssertEquals('FaceForward:Sub5 X failed ',  1.0, vt4.X);
  AssertEquals('FaceForward:Sub6 Y failed ',  1.0, vt4.Y);
  AssertEquals('FaceForward:Sub7 Z failed ',  1.0, vt4.Z);
  AssertEquals('FaceForward:Sub8 W failed ',  0.0, vt4.W);
  vt3.create(0,0,-1,0); // pV is away from eye remain hidden face
  vt4 :=  vt1.FaceForward(vt3,vt2);  // you can swap eyeV and pV same result.
  AssertEquals('FaceForward:Sub9 X failed ',   1.0, vt4.X);
  AssertEquals('FaceForward:Sub10 Y failed ',  1.0, vt4.Y);
  AssertEquals('FaceForward:Sub11 Z failed ',  1.0, vt4.Z);
  AssertEquals('FaceForward:Sub12 W failed ',  0.0, vt4.W);
end;

// Clamp anything to between 0 and 1 preserves hmg point
procedure TVector4fHelperFunctionalTest.TestSaturate;
begin
   vt1.Create(0.5,0.5,0.5,1);
   vt4 := vt1.Saturate;
   AssertEquals('Saturate:Sub1 X failed ',   0.5, vt4.X);
   AssertEquals('Saturate:Sub2 Y failed ',   0.5, vt4.Y);
   AssertEquals('Saturate:Sub3 Z failed ',   0.5, vt4.Z);
   AssertEquals('Saturate:Sub4 W failed ',   1.0, vt4.W);
   vt1.Create(1.5,0.5,0.5,0);
   vt4 := vt1.Saturate;
   AssertEquals('Saturate:Sub5 X failed ',   1.0, vt4.X);
   AssertEquals('Saturate:Sub6 Y failed ',   0.5, vt4.Y);
   AssertEquals('Saturate:Sub7 Z failed ',   0.5, vt4.Z);
   AssertEquals('Saturate:Sub8 W failed ',   0.0, vt4.W);
   vt1.Create(0.5,1.5,0.5,1);
   vt4 := vt1.Saturate;
   AssertEquals('Saturate:Sub9 X failed ',    0.5, vt4.X);
   AssertEquals('Saturate:Sub10 Y failed ',   1.0, vt4.Y);
   AssertEquals('Saturate:Sub11 Z failed ',   0.5, vt4.Z);
   AssertEquals('Saturate:Sub12 W failed ',   1.0, vt4.W);
   vt1.Create(0.5,0.5,1.5,0);
   vt4 := vt1.Saturate;
   AssertEquals('Saturate:Sub13 X failed ',   0.5, vt4.X);
   AssertEquals('Saturate:Sub14 Y failed ',   0.5, vt4.Y);
   AssertEquals('Saturate:Sub15 Z failed ',   1.0, vt4.Z);
   AssertEquals('Saturate:Sub16 W failed ',   0.0, vt4.W);
   vt1.Create(-0.5,0.5,0.5,1);
   vt4 := vt1.Saturate;
   AssertEquals('Saturate:Sub17 X failed ',   0.0, vt4.X);
   AssertEquals('Saturate:Sub18 Y failed ',   0.5, vt4.Y);
   AssertEquals('Saturate:Sub19 Z failed ',   0.5, vt4.Z);
   AssertEquals('Saturate:Sub20 W failed ',   1.0, vt4.W);
   vt1.Create(0.5,-0.5,0.5,0);
   vt4 := vt1.Saturate;
   AssertEquals('Saturate:Sub21 X failed ',   0.5, vt4.X);
   AssertEquals('Saturate:Sub22 Y failed ',   0.0, vt4.Y);
   AssertEquals('Saturate:Sub23 Z failed ',   0.5, vt4.Z);
   AssertEquals('Saturate:Sub24 W failed ',   0.0, vt4.W);
   vt1.Create(0.5,0.5,-0.5,1);
   vt4 := vt1.Saturate;
   AssertEquals('Saturate:Sub25 X failed ',   0.5, vt4.X);
   AssertEquals('Saturate:Sub26 Y failed ',   0.5, vt4.Y);
   AssertEquals('Saturate:Sub27 Z failed ',   0.0, vt4.Z);
   AssertEquals('Saturate:Sub28 W failed ',   1.0, vt4.W);
end;


// t := (Self - a) / (b - a);   <--- dangerous for point and vec, W will always be 0
// t := t.Saturate;             <--- saturate clamps -inf to 0, saved by this
// result := t * t * (3.0 - (t * 2.0));
// above function behaves like some form of a normal distribution
// if used as add this fraction of diff to A then we get a transition
// which has less mid and more of the ends.  (spotlight/highlight?)
procedure TVector4fHelperFunctionalTest.TestSmoothStep;
begin
   vt1.Create(1,1,1,1);  // self
   vt2.Create(0,0,0,0);  // A
   vt3.Create(2,2,2,2);  // B   lerp would return 0.5 for this
   vt4 := vt1.SmoothStep(vt2,vt3);
   AssertEquals('TestSmoothStep:Sub1 X failed ',   0.5, vt4.X);
   AssertEquals('TestSmoothStep:Sub2 Y failed ',   0.5, vt4.Y);
   AssertEquals('TestSmoothStep:Sub3 Z failed ',   0.5, vt4.Z);
   AssertEquals('TestSmoothStep:Sub4 W failed ',   0.5, vt4.W);
   vt1.Create(0.5,0.5,0.5,0.5);  // self
   vt4 := vt1.SmoothStep(vt2,vt3);   // lerp would return 0.25 for this
   AssertEquals('TestSmoothStep:Sub5 X failed ',   0.15625, vt4.X,1e-4);
   AssertEquals('TestSmoothStep:Sub6 Y failed ',   0.15625, vt4.Y,1e-4);
   AssertEquals('TestSmoothStep:Sub7 Z failed ',   0.15625, vt4.Z,1e-4);
   AssertEquals('TestSmoothStep:Sub8 W failed ',   0.15625, vt4.W,1e-4);
   vt1.Create(1.5,1.5,1.5,1.5);  // self
   vt4 := vt1.SmoothStep(vt2,vt3);   // lerp would return 0.75 for this
   AssertEquals('TestSmoothStep:Sub9 X failed ',    0.84375, vt4.X,1e-4);
   AssertEquals('TestSmoothStep:Sub10 Y failed ',   0.84375, vt4.Y,1e-4);
   AssertEquals('TestSmoothStep:Sub11 Z failed ',   0.84375, vt4.Z,1e-4);
   AssertEquals('TestSmoothStep:Sub12 W failed ',   0.84375, vt4.W,1e-4);
   vt2.Create(0,0,2,0);  // Make one item the same as upper
   vt4 := vt1.SmoothStep(vt2,vt3);   // lerp would return 0.75 for this
   AssertEquals('TestSmoothStep:Sub13 X failed ',    0.84375, vt4.X,1e-4);
   AssertEquals('TestSmoothStep:Sub14 Y failed ',   0.84375, vt4.Y,1e-4);
   AssertEquals('TestSmoothStep:Sub15 Z failed ',   0.0    , vt4.Z,1e-4);
   AssertEquals('TestSmoothStep:Sub16 W failed ',   0.84375, vt4.W,1e-4);
end;

procedure TVector4fHelperFunctionalTest.TestReflect;
begin

end;

procedure TVector4fHelperFunctionalTest.TestPropertyXY;
begin
  vtt1 := vt1.xy;
  AssertEquals('PropertyXY:Sub1 X failed ',   5.850, vtt1.X);
  AssertEquals('PropertyXY:Sub2 Y failed ', -15.480, vtt1.Y);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyYX;
begin
  vtt1 := vt1.yx;
  AssertEquals('PropertyYX:Sub1 X failed ', -15.480, vtt1.X);
  AssertEquals('PropertyYX:Sub2 Y failed ',   5.850, vtt1.Y);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyXZ;
begin
  vtt1 := vt1.xz;
  AssertEquals('PropertyXZ:Sub1 X failed ', 5.850, vtt1.X);
  AssertEquals('PropertyXZ:Sub2 Y failed ', 8.512, vtt1.Y);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyZX;
begin
  vtt1 := vt1.zx;
  AssertEquals('PropertyZX:Sub1 X failed ', 8.512, vtt1.X);
  AssertEquals('PropertyZX:Sub2 Y failed ', 5.850, vtt1.Y);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyYZ;
begin
  vtt1 := vt1.yz;
  AssertEquals('PropertyYZ:Sub1 X failed ', -15.480, vtt1.X);
  AssertEquals('PropertyYZ:Sub2 Y failed ',   8.512, vtt1.Y);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyZY;
begin
  vtt1 := vt1.zy;
  AssertEquals('PropertyZY:Sub1 X failed ',   8.512, vtt1.X);
  AssertEquals('PropertyZY:Sub2 Y failed ', -15.480, vtt1.Y);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyXX;
begin
  vtt1 := vt1.xx;
  AssertEquals('PropertyXX:Sub1 X failed ', 5.850, vtt1.X);
  AssertEquals('PropertyXX:Sub2 Y failed ', 5.850, vtt1.Y);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyYY;
begin
  vtt1 := vt1.YY;
  AssertEquals('PropertyYY:Sub1 X failed ', -15.480, vtt1.X);
  AssertEquals('PropertyYY:Sub2 Y failed ', -15.480, vtt1.Y);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyZZ;
begin
  vtt1 := vt1.ZZ;
  AssertEquals('PropertyZZ:Sub1 X failed ', 8.512, vtt1.X);
  AssertEquals('PropertyZZ:Sub2 Y failed ', 8.512, vtt1.Y);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyXYZ;
begin
  vt3 := vt1.XYZ;
  AssertEquals('PropertyXYZ:Sub1 X failed ',   5.850, vt3.X);
  AssertEquals('PropertyXYZ:Sub2 Y failed ', -15.480, vt3.Y);
  AssertEquals('PropertyXYZ:Sub3 Z failed ',   8.512, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyXZY;
begin
  vt3 := vt1.XZY;
  AssertEquals('PropertyXZY:Sub1 X failed ',   5.850, vt3.X);
  AssertEquals('PropertyXZY:Sub2 Y failed ',   8.512, vt3.Y);
  AssertEquals('PropertyXZY:Sub3 Z failed ', -15.480, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyYXZ;
begin
  vt3 := vt1.YXZ;
  AssertEquals('PropertyYXZ:Sub1 X failed ', -15.480, vt3.X);
  AssertEquals('PropertyYXZ:Sub2 Y failed ',   5.850, vt3.Y);
  AssertEquals('PropertyYXZ:Sub3 Z failed ',   8.512, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyYZX;
begin
  vt3 := vt1.YZX;
  AssertEquals('PropertyYZX:Sub1 X failed ', -15.480, vt3.X);
  AssertEquals('PropertyYZX:Sub2 Y failed ',   8.512, vt3.Y);
  AssertEquals('PropertyYZX:Sub3 Z failed ',   5.850, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyZXY;
begin
  vt3 := vt1.ZXY;
  AssertEquals('PropertyZXY:Sub1 X failed ',   8.512, vt3.X);
  AssertEquals('PropertyZXY:Sub2 Y failed ',   5.850, vt3.Y);
  AssertEquals('PropertyZXY:Sub3 Z failed ', -15.480, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyZYX;
begin
  vt3 := vt1.ZYX;
  AssertEquals('PropertyZYX:Sub1 X failed ',   8.512, vt3.X);
  AssertEquals('PropertyZYX:Sub2 Y failed ', -15.480, vt3.Y);
  AssertEquals('PropertyZYX:Sub3 Z failed ',   5.850, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyXXX;
begin
  vt3 := vt1.XXX;
  AssertEquals('PropertyXXX:Sub1 X failed ',   5.850, vt3.X);
  AssertEquals('PropertyXXX:Sub2 Y failed ',   5.850, vt3.Y);
  AssertEquals('PropertyXXX:Sub3 Z failed ',   5.850, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyYYY;
begin
  vt3 := vt1.YYY;
  AssertEquals('PropertyYYY:Sub1 X failed ', -15.480, vt3.X);
  AssertEquals('PropertyYYY:Sub2 Y failed ', -15.480, vt3.Y);
  AssertEquals('PropertyYYY:Sub3 Z failed ', -15.480, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyZZZ;
begin
  vt3 := vt1.ZZZ;
  AssertEquals('PropertyZZZ:Sub1 X failed ',   8.512, vt3.X);
  AssertEquals('PropertyZZZ:Sub2 Y failed ',   8.512, vt3.Y);
  AssertEquals('PropertyZZZ:Sub3 Z failed ',   8.512, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyYYX;
begin
  vt3 := vt1.YYX;
  AssertEquals('PropertyYYX:Sub1 X failed ', -15.480, vt3.X);
  AssertEquals('PropertyYYX:Sub2 Y failed ', -15.480, vt3.Y);
  AssertEquals('PropertyYYX:Sub3 Z failed ',   5.850, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyXYY;
begin
  vt3 := vt1.XYY;
  AssertEquals('PropertyXYY:Sub1 X failed ',   5.850, vt3.X);
  AssertEquals('PropertyXYY:Sub2 Y failed ', -15.480, vt3.Y);
  AssertEquals('PropertyXYY:Sub3 Z failed ', -15.480, vt3.Z);
end;

procedure TVector4fHelperFunctionalTest.TestPropertyYXY;
begin
  vt3 := vt1.YXY;
  AssertEquals('PropertyYXY:Sub1 X failed ', -15.480, vt3.X);
  AssertEquals('PropertyYXY:Sub2 Y failed ',   5.850, vt3.Y);
  AssertEquals('PropertyYXY:Sub3 Z failed ', -15.480, vt3.Z);
end;



initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVector4fHelperFunctionalTest);
end.

