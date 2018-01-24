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
      //procedure Test;

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
  vt4 := vt1.RotateAroundX(pi/2);
  AssertEquals('RotateWithMatrixAroundX:Sub1 X failed ',  1.0, vt4.X);
  AssertEquals('RotateWithMatrixAroundX:Sub2 Y failed ', -1.0, vt4.Y);
  AssertEquals('RotateWithMatrixAroundX:Sub3 Z failed ',  1.0, vt4.Z);
  AssertEquals('RotateWithMatrixAroundX:Sub4 W failed ',  1.0, vt4.W);
  // negative rotation around x, Z becomes negative
  vt4 := vt1.RotateAroundX(-pi/2);
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
  vt4 := vt1.RotateAroundY(pi/2);
  AssertEquals('RotateWithMatrixAroundY:Sub1 X failed ',  1.0, vt4.X);
  AssertEquals('RotateWithMatrixAroundY:Sub2 Y failed ',  1.0, vt4.Y);
  AssertEquals('RotateWithMatrixAroundY:Sub3 Z failed ', -1.0, vt4.Z);
  AssertEquals('RotateWithMatrixAroundY:Sub4 W failed ',  1.0, vt4.W);
  // negative rotation around y, X becomes negative
  vt4 := vt1.RotateAroundY(-pi/2);
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

procedure TVector4fHelperFunctionalTest.TestMoveAround;
begin

end;

procedure TVector4fHelperFunctionalTest.TestShiftObjectFromCenter;
begin

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
procedure TVector4fHelperFunctionalTest.TestFaceForward;
begin
  vt1.Create(1,1,1,0);  // test result vector, does not play a part in calcs
  vt2.Create(0,0,-1,0); // this is eye to screen +z out -z eye to screen
  vt3.create(0,0, 1,0); // pV is towards eye hidden face we want to show
  vt4 := vt1.FaceForward(vt2,vt3);
  AssertEquals('Step:Sub1 X failed ',  -1.0, vt4.X);
  AssertEquals('Step:Sub2 Y failed ',  -1.0, vt4.Y);
  AssertEquals('Step:Sub3 Z failed ',  -1.0, vt4.Z);
  AssertEquals('Step:Sub4 W failed ',   0.0, vt4.W);
  vt3.create(0,0,-1,0); // pV is away from eye remain hidden face
  vt4 :=  vt1.FaceForward(vt2,vt3);
  AssertEquals('Step:Sub5 X failed ',  1.0, vt4.X);
  AssertEquals('Step:Sub6 Y failed ',  1.0, vt4.Y);
  AssertEquals('Step:Sub7 Z failed ',  1.0, vt4.Z);
  AssertEquals('Step:Sub8 W failed ',  0.0, vt4.W);
  vt3.create(0,0,-1,0); // pV is away from eye remain hidden face
  vt4 :=  vt1.FaceForward(vt3,vt2);  // you can swap eyeV and pV same result.
  AssertEquals('Step:Sub9 X failed ',   1.0, vt4.X);
  AssertEquals('Step:Sub10 Y failed ',  1.0, vt4.Y);
  AssertEquals('Step:Sub11 Z failed ',  1.0, vt4.Z);
  AssertEquals('Step:Sub12 W failed ',  0.0, vt4.W);
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

procedure TVector4fHelperFunctionalTest.TestSmoothStep;
begin

end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVector4fHelperFunctionalTest);
end.
