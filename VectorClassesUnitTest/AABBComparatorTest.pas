unit AABBComparatorTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  { TAABBComparatorTest }

  TAABBComparatorTest = class(TBBoxBaseTestCase)
    published
      procedure TestCompare;
      procedure TestCompareFalse;
      procedure TestCreateVector;
      procedure TestCreateABB;
      procedure TestCreateSweep;
      procedure TestCreateBSphere;
      procedure TestOpAddAABB;
      procedure TestOpAddVector;
      procedure TestOpMulVector;
      procedure TestOpEquality;
      procedure TestTransform;
      procedure TestInclude;
      procedure TestIntersectionDegenerate;
      procedure TestIntersectionValid;
      procedure TestToBB;
      procedure TestToBBWithTransform;
      procedure TestToBSphere;
      procedure TestToClipRect;
      procedure TestIntersect;
      procedure TestIntersectAbsoluteXY;
      procedure TestIntersectAbsoluteXZ;
      procedure TestIntersectAbsolute;
      procedure TestFitsInAbsolute;
      procedure TestPointIn;
      procedure TestExtractCorners;
      procedure TestContainsAABB;
      procedure TestContainsBSphere;
      procedure TestClip;
      procedure TestRayCastIntersectNearFar;
      procedure TestRayCastIntersectPVector;


  end;

implementation

{ TAABBComparatorTest }

procedure TAABBComparatorTest.TestCompare;
begin
  AssertTrue('Test Values do not match', Compare(naabb1,aaabb1));
end;

procedure TAABBComparatorTest.TestCompareFalse;
begin
  AssertFalse('Test Values should not match', Compare(naabb2,aaabb1));
end;

procedure TAABBComparatorTest.TestCreateVector;
begin
  naabb3.Create(nt1);
  aaabb3.Create(vt1);
  AssertTrue('AABB CreateVector does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestCreateABB;
begin
  naabb3.Create(nbb1);
  aaabb3.Create(abb1);
  AssertTrue('AABB CreateABB does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestCreateSweep;
begin
  naabb3.CreateFromSweep(nt1, nt2, Fs2);
  aaabb3.CreateFromSweep(vt1, vt2, Fs2);
  AssertTrue('AABB CreateFromSweep does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestCreateBSphere;
begin
  naabb3.Create(nbs1);
  aaabb3.Create(abs1);
  AssertTrue('AABB CreateBSphere does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestOpAddAABB;
begin
  naabb3 := naabb1 + naabb2;
  aaabb3 := aaabb1 + aaabb2;
  AssertTrue('AABB Op Add AABB does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestOpAddVector;
begin
  naabb3 := naabb1 + nt2;
  aaabb3 := aaabb1 + vt2;
  AssertTrue('AABB Op Add Vector does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestOpMulVector;
begin
  naabb3 := naabb1 * nt2;
  aaabb3 := aaabb1 * vt2;
  AssertTrue('AABB Op Mul Vector does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestOpEquality;
begin
  nb := naabb1 = naabb1;
  vb := aaabb1 = aaabb1;
  AssertTrue('AABB Op Equals does not match', (nb = vb));
end;

procedure TAABBComparatorTest.TestTransform;
var
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
begin
  nMat.CreateTranslationMatrix(nt2);
  aMat.CreateTranslationMatrix(vt2);
  naabb3.Transform(nMat);
  aaabb3.Transform(aMat);
  AssertTrue('AABB Transform does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestInclude;
begin
  naabb1.Include(nt2);
  aaabb1.Include(vt2);
  AssertTrue('AABB Include does not match', Compare(naabb1,aaabb1));
end;

procedure TAABBComparatorTest.TestIntersectionDegenerate;
begin
  naabb3 := naabb1.Intersection(naabb2);
  aaabb3 := aaabb1.Intersection(aaabb2);
  AssertTrue('AABB Intersection Degenerate does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestIntersectionValid;
begin
  // make a aabb with a boundary plane through center of bsphere2
  fs1 := nt1.Distance(nt2);
  nbs1.Create(nt1,fs1);
  abs1.Create(vt1,fs1);
  naabb1.Create(nbs1);
  aaabb1.Create(abs1);
  naabb3 := naabb1.Intersection(naabb2);
  aaabb3 := aaabb1.Intersection(aaabb2);
  AssertTrue('AABB Intersection Valid does not match', Compare(naabb3,aaabb3));
end;

procedure TAABBComparatorTest.TestToBB;
begin
  nbb3 := naabb1.ToBoundingBox;
  abb3 := aaabb1.ToBoundingBox;
  AssertTrue('AABB To BoundingBox does not match', Compare(nbb3,abb3));
end;

procedure TAABBComparatorTest.TestToBBWithTransform;
var
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
begin
  nMat.CreateTranslationMatrix(nt2);
  aMat.CreateTranslationMatrix(vt2);
  nbb3 := naabb1.ToBoundingBox(nMat);
  abb3 := aaabb1.ToBoundingBox(aMat);
  AssertTrue('AABB To BoundingBox transform does not match', Compare(nbb3,abb3));
end;

procedure TAABBComparatorTest.TestToBSphere;
begin
  nbs3 := naabb1.ToBoundingSphere;
  abs3 := aaabb1.ToBoundingSphere;
  AssertTrue('AABB To Bounding Sphere does not match', Compare(nbs3,abs3));
end;

procedure TAABBComparatorTest.TestToClipRect;
var
  nCr: TNativeGLZClipRect;
  aCr: TGLZClipRect;
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
  nPlane: TNativeGLZHmgPlane;
  aPlane: TGLZHmgPlane;
begin
  nPlane.CreatePlane(nt1,NativeZHmgVector);
  aPlane.CreatePlane(vt1,ZHmgVector);
  nMat.CreateParallelProjectionMatrix(nPlane, NativeZHmgVector);
  aMat.CreateParallelProjectionMatrix(aPlane, ZHmgVector);
  nCr := naabb1.ToClipRect(nMat,200,200);
  aCr := aaabb1.ToClipRect(aMat,200,200);
  AssertTrue('AABB To ClipRect does not match', Compare(nCr,aCr));
end;

procedure TAABBComparatorTest.TestIntersect;
var
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
begin
  nMat.CreateIdentityMatrix;
  aMat.CreateIdentityMatrix;
  nb := naabb1.Intersect(naabb2, nMat, nMat);
  vb := aaabb1.Intersect(aaabb2, aMat, aMat);
  AssertTrue('AABB IntersectAbsoluteXY does not match', (nb = vb));
end;

procedure TAABBComparatorTest.TestIntersectAbsoluteXY;
begin
  nb := naabb1.IntersectAbsoluteXY(naabb2);
  vb := aaabb1.IntersectAbsoluteXY(aaabb2);
  AssertTrue('AABB IntersectAbsoluteXY does not match', (nb = vb));
end;

procedure TAABBComparatorTest.TestIntersectAbsoluteXZ;
begin
  nb := naabb1.IntersectAbsoluteXZ(naabb2);
  vb := aaabb1.IntersectAbsoluteXZ(aaabb2);
  AssertTrue('AABB IntersectAbsoluteXZ does not match', (nb = vb));
end;

procedure TAABBComparatorTest.TestIntersectAbsolute;
begin
  nb := naabb1.IntersectAbsolute(naabb2);
  vb := aaabb1.IntersectAbsolute(aaabb2);
  AssertTrue('AABB IntersectAbsolute does not match', (nb = vb));
end;

procedure TAABBComparatorTest.TestFitsInAbsolute;
begin
  nb := naabb1.FitsInAbsolute(naabb2);
  vb := aaabb1.FitsInAbsolute(aaabb2);
  AssertTrue('AABB FitsInAbsolute does not match', (nb = vb));
end;

procedure TAABBComparatorTest.TestPointIn;
begin
  nb := naabb1.PointIn(nt1);
  vb := aaabb1.PointIn(vt1);
  AssertTrue('AABB PointIn does not match', (nb = vb));
end;

procedure TAABBComparatorTest.TestExtractCorners;
var
  nRes: TNativeGLZAABBCorners;
  aRes: TGLZAABBCorners;
begin
  nRes := naabb1.ExtractCorners;
  aRes := aaabb1.ExtractCorners;
  AssertTrue('AABB ExtractCorners does not match', Compare(nRes,aRes));
end;

procedure TAABBComparatorTest.TestContainsAABB;
var nCont, aCont: TGLZSpaceContains;
begin
  nCont := naabb1.Contains(naabb2);
  aCont := aaabb1.Contains(aaabb2);
  AssertTrue('AABB Contains AABB does not match', (nCont = aCont));
end;

procedure TAABBComparatorTest.TestContainsBSphere;
var nCont, aCont: TGLZSpaceContains;
begin
  nCont := naabb1.Contains(nbs2);
  aCont := aaabb1.Contains(abs2);
  AssertTrue('AABB Contains AABB does not match', (nCont = aCont));
end;

procedure TAABBComparatorTest.TestClip;
begin
  nt3.AsVector3f := naabb1.Clip(nt2.AsVector3f);
  vt3.AsVector3f := aaabb1.Clip(vt2.AsVector3f);
  AssertTrue('AABB ExtractCorners does not match', Compare(nt3,vt3));
end;

procedure TAABBComparatorTest.TestRayCastIntersectNearFar;
begin
  nb := naabb1.RayCastIntersect(nt1,NativeYHmgVector,fs1,fs2);
  vb := aaabb1.RayCastIntersect(vt1,YHmgVector,fs1,fs2);
  AssertTrue('AABB RayCastIntersectNearFar does not match', (nb = vb));
end;

procedure TAABBComparatorTest.TestRayCastIntersectPVector;
begin
  nb := naabb1.RayCastIntersect(nt1,NativeYHmgVector,@nt3);
  vb := aaabb1.RayCastIntersect(vt1,YHmgVector,@vt3);
  AssertTrue('AABB RayCastIntersectPVector does not match', (nb = vb));
end;

initialization
  RegisterTest(REPORT_GROUP_AABB, TAABBComparatorTest);
end.

