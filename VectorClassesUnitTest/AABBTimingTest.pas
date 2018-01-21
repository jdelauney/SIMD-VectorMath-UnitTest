unit AABBTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest, BaseTestCase,
  native, GLZVectorMath, GLZProfiler;

type

  { TAABBTimingTest }

  TAABBTimingTest = class(TVectorBaseTimingTest)
    protected
      {$CODEALIGN RECORDMIN=16}
      nbb1,nbb2,nbb3: TNativeGLZBoundingBox;
      abb1,abb2,abb3: TGLZBoundingBox;
      nbs1,nbs2,nbs3: TNativeGLZBoundingSphere;
      abs1,abs2,abs3: TGLZBoundingSphere;
      naabb1,naabb2,naabb3: TNativeGLZAxisAlignedBoundingBox;
      aaabb1,aaabb2,aaabb3: TGLZAxisAlignedBoundingBox;
      {$CODEALIGN RECORDMIN=4}
      procedure Setup; override;
    published
      procedure TestTimeCreateVector;
      procedure TestTimeCreateABB;
      procedure TestTimeCreateSweep;
      procedure TestTimeCreateBSphere;
      procedure TestTimeOpAddAABB;
      procedure TestTimeOpAddVector;
      procedure TestTimeOpMulVector;
      procedure TestTimeOpEquality;
      procedure TestTimeTransform;
      procedure TestTimeInclude;
      procedure TestTimeIntersectionDegenerate;
      procedure TestTimeIntersectionValid;
      procedure TestTimeToBB;
      procedure TestTimeToBBWithTransform;
      procedure TestTimeToBSphere;
      procedure TestTimeToClipRect;
      procedure TestTimeIntersect;
      procedure TestTimeIntersectAbsoluteXY;
      procedure TestTimeIntersectAbsoluteXZ;
      procedure TestTimeIntersectAbsolute;
      procedure TestTimeFitsInAbsolute;
      procedure TestTimePointIn;
      procedure TestTimeExtractCorners;
      procedure TestTimeContainsAABB;
      procedure TestTimeContainsBSphere;
      procedure TestTimeClip;
      procedure TestTimeRayCastIntersectNearFar;
      procedure TestTimeRayCastIntersectPVector;
  end;

implementation


{ TAABBTimingTest }



procedure TAABBTimingTest.TestTimeCreateVector;
begin
  TestDispName := 'AABB CreateVector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb3.Create(nt1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aaabb3.Create(vt1) end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeCreateABB;
begin
  TestDispName := 'AABB CreateABB';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb3.Create(nbb1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aaabb3.Create(abb1); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeCreateSweep;
begin
  TestDispName := 'AABB CreateFromSweep';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb3.CreateFromSweep(nt1, nt2, Fs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin  aaabb3.CreateFromSweep(vt1, vt2, Fs2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeCreateBSphere;
begin
  TestDispName := 'AABB CreateBSphere';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin naabb3.Create(nbs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin aaabb3.Create(abs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeOpAddAABB;
begin
  TestDispName := 'AABB Op Add AABB';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb3 := naabb1 + naabb2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aaabb3 := aaabb1 + aaabb2; end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeOpAddVector;
begin
  TestDispName := 'AABB Op Add Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb3 := naabb1 + nt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aaabb3 := aaabb1 + vt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeOpMulVector;
begin
  TestDispName := 'AABB Op Mul Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb3 := naabb1 * nt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aaabb3 := aaabb1 * vt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeOpEquality;
begin
  TestDispName := 'AABB Op Equals';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb3 := naabb1 * nt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aaabb3 := aaabb1 * vt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeTransform;
var
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
begin
  nMat.CreateTranslationMatrix(nt2);
  aMat.CreateTranslationMatrix(vt2);
  TestDispName := 'AABB Transform';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsTenth do begin naabb3.Transform(nMat); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsTenth do begin aaabb3.Transform(aMat); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeInclude;
begin
  TestDispName := 'AABB Include';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb1.Include(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aaabb1.Include(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeIntersectionDegenerate;
begin
  TestDispName := 'AABB Intersection Degenerate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb1.Intersection(naabb2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aaabb1.Intersection(aaabb2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeIntersectionValid;
begin
  // make a aabb with a boundary plane through center of bsphere2
  fs1 := nt1.Distance(nt2);
  nbs1.Create(nt1,fs1);
  abs1.Create(vt1,fs1);
  naabb1.Create(nbs1);
  aaabb1.Create(abs1);
  TestDispName := 'AABB Intersection Valid';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin naabb1.Intersection(naabb2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aaabb1.Intersection(aaabb2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeToBB;
begin
  TestDispName := 'AABB To BoundingBox';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbb3 := naabb1.ToBoundingBox; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abb3 := aaabb1.ToBoundingBox; end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeToBBWithTransform;
var
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
begin
  nMat.CreateTranslationMatrix(nt2);
  aMat.CreateTranslationMatrix(vt2);
  TestDispName := 'AABB To BoundingBox transform';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbb3 := naabb1.ToBoundingBox(nMat); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abb3 := aaabb1.ToBoundingBox(aMat); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeToBSphere;
begin
  TestDispName := 'AABB To Bounding Sphere';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbs3 := naabb1.ToBoundingSphere; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abs3 := aaabb1.ToBoundingSphere; end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeToClipRect;
var
  nCr: TNativeGLZClipRect;
  aCr: TGLZClipRect;
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
  nPlane: TNativeGLZHmgPlane;
  aPlane: TGLZHmgPlane;
begin
  nPlane.Create(nt1,NativeZHmgVector);
  aPlane.Create(vt1,ZHmgVector);
  nMat.CreateParallelProjectionMatrix(nPlane, NativeZHmgVector);
  aMat.CreateParallelProjectionMatrix(aPlane, ZHmgVector);
  TestDispName := 'AABB To Clip Rect';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsTenth do begin nCr := naabb1.ToClipRect(nMat,200,200); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsTenth do begin aCr := aaabb1.ToClipRect(aMat,200,200); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeIntersect;
var
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
begin
  nMat.CreateIdentityMatrix;
  aMat.CreateIdentityMatrix;
  TestDispName := 'AABB Intersect';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := naabb1.Intersect(naabb2,nMat,nMat); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := aaabb1.Intersect(aaabb2,aMat,aMat); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeIntersectAbsoluteXY;
begin
  TestDispName := 'AABB Intersect AbsoluteXY';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := naabb1.IntersectAbsoluteXY(naabb2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := aaabb1.IntersectAbsoluteXY(aaabb2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeIntersectAbsoluteXZ;
begin
  TestDispName := 'AABB Intersect AbsoluteXZ';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := naabb1.IntersectAbsoluteXZ(naabb2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := aaabb1.IntersectAbsoluteXZ(aaabb2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeIntersectAbsolute;
begin
  TestDispName := 'AABB Intersect Absolute';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := naabb1.IntersectAbsolute(naabb2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := aaabb1.IntersectAbsolute(aaabb2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeFitsInAbsolute;
begin
  TestDispName := 'AABB FitsIn Absolute';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := naabb1.FitsInAbsolute(naabb2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := aaabb1.FitsInAbsolute(aaabb2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimePointIn;
begin
  TestDispName := 'AABB Point In';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := naabb1.PointIn(nt1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := aaabb1.PointIn(vt1); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeExtractCorners;
var
  nRes: TNativeGLZAABBCorners;
  aRes: TGLZAABBCorners;
begin
  TestDispName := 'AABB Extract Corners';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nRes := naabb1.ExtractCorners; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aRes := aaabb1.ExtractCorners; end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeContainsAABB;
var nCont, aCont: TGLZSpaceContains;
begin
  TestDispName := 'AABB Conains AABB';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nCont := naabb1.Contains(naabb2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aCont := aaabb1.Contains(aaabb2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeContainsBSphere;
var nCont, aCont: TGLZSpaceContains;
begin
  TestDispName := 'AABB Conains BSphere';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nCont := naabb1.Contains(nbs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aCont := aaabb1.Contains(abs2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeClip;
begin
  TestDispName := 'AABB Clip AffineVector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3.AsVector3f := naabb1.Clip(nt2.AsVector3f); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3.AsVector3f := aaabb1.Clip(vt2.AsVector3f); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeRayCastIntersectNearFar;
begin
  TestDispName := 'AABB RayCastIntersectNearFar';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := naabb1.RayCastIntersect(nt1,NativeYHmgVector,fs1,fs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := aaabb1.RayCastIntersect(vt1,YHmgVector,fs1,fs2); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.TestTimeRayCastIntersectPVector;
begin
  TestDispName := 'AABB RayCastIntersectPVector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := naabb1.RayCastIntersect(nt1,NativeYHmgVector,@nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := aaabb1.RayCastIntersect(vt1,YHmgVector,@vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure TAABBTimingTest.Setup;
begin
  inherited Setup;
  Group := rgAABB;
  nbb1.Create(nt1);
  abb1.Create(vt1);
  nbb2.Create(nt2);
  abb2.Create(vt2);
  nbs1.Create(nt1, 1.356);
  abs1.Create(vt1, 1.356);
  nbs2.Create(nt2, 8.435);
  abs2.Create(vt2, 8.435);
  naabb1.Create(nbs1);
  aaabb1.Create(abs1);
  naabb2.Create(nbs2);
  aaabb2.Create(abs2);
end;

initialization
  RegisterTest(REPORT_GROUP_AABB, TAABBTimingTest);
end.

