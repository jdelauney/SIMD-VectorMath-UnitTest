unit BSphereComparatorTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath, GLZVectorMathEx;

type

   { TBSphereFunctionalTest }
   // may split this out later to group/enable functional tests.
   // but for now it can stay here
   TBSphereFunctionalTest = class(TBBoxBaseTestCase)
     published
       procedure TestCreateSingles;
       procedure TestCreateAffineVector;
       procedure TestCreateVector;
       procedure TestContains;
       procedure TestIntersect;
   end;

  { TBSphereComparatorTest }

  TBSphereComparatorTest = class(TBBoxBaseTestCase)
    published
      procedure TestCompare;
      procedure TestCompareFalse;
      procedure TestContains;
      procedure TestIntersect;
  end;

implementation

{ TBSphereFunctionalTest }

// Our default values are.
// vt1.Create(5.850,-15.480,8.512,1.5);
// abs1.Create(vt1, 1.356);

procedure TBSphereFunctionalTest.TestCreateSingles;
begin
   abs3.Create(5.850,-15.480,8.512,1.356);
   AssertTrue('BoundingSphere CreateSingles do not match' + abs3.ToString+' --> '+abs1.ToString, Compare(abs3,abs1));
end;

procedure TBSphereFunctionalTest.TestCreateAffineVector;
var vec: TGLZAffineVector;
begin
   vec := vt1.AsVector3f;
   abs3.Create(vec,1.356);
   AssertTrue('BoundingSphere CreateAffine do not match' + abs3.ToString+' --> '+abs1.ToString, Compare(abs3,abs1));
end;

procedure TBSphereFunctionalTest.TestCreateVector;
begin
  abs3.Create(vt1,1.356);
  AssertTrue('BoundingSphere CreateAffine do not match' + abs3.ToString+' --> '+abs1.ToString, Compare(abs3,abs1));
  AssertTrue('BoundingSphere Center W is not 1.0', IsEqual(abs3.Center.W,1.0));
end;

procedure TBSphereFunctionalTest.TestContains;
var
  aCont: TGLZSpaceContains;
begin
  // default spheres do not overlap
  fs1 := abs1.Center.Distance(abs2.Center);
  AssertTrue('BoundingSphere: Someone changed the base values and broke the tests', (fs1 - abs1.Radius) > abs2.Radius);
  aCont := abs1.Contains(abs2);
  AssertTrue('BoundingSphere: spheres should be isolated',  aCont = ScNoOverlap);

  // make the radius the same as the distance between centers so we have
  // a partial containment
  abs1.Radius:=fs1;
  aCont := abs1.Contains(abs2);
  AssertTrue('BoundingSphere: spheres should partially contained',  aCont = ScContainsPartially);

  // fully enclose abs2
  abs1.Radius:=fs1 + abs2.Radius + 1.0;
  aCont := abs1.Contains(abs2);
  AssertTrue('BoundingSphere: spheres should fully contained',  aCont = ScContainsFully);

end;

procedure TBSphereFunctionalTest.TestIntersect;
begin
  fs1 := abs1.Center.Distance(abs2.Center);
  AssertTrue('BoundingSphere: Someone changed the base values and broke the tests', (fs1 - abs1.Radius) > abs2.Radius);
  vb := abs1.Intersect(abs2);
  AssertFalse( 'BoundingSphere: spheres should not intersect', vb);

  // slight overlap
  abs1.Radius:= fs1 - abs2.Radius + 1.0;
  vb := abs1.Intersect(abs2);
  AssertTrue( 'BoundingSphere: spheres should intersect', vb);

  // fully enclose abs2
  abs1.Radius:=fs1 + abs2.Radius + 1.0;
  vb := abs1.Intersect(abs2);
  AssertTrue( 'BoundingSphere: spheres should intersect', vb);

end;

{ TBSphereComparatorTest }

procedure TBSphereComparatorTest.TestCompare;
begin
  AssertTrue('Test Values do not match', Compare(nbs1,abs1));
end;

procedure TBSphereComparatorTest.TestCompareFalse;
begin
  AssertFalse('Test Values should not match', Compare(nbs2,abs1));
end;

procedure TBSphereComparatorTest.TestContains;
var nCont, aCont: TGLZSpaceContains;
begin
  nCont := nbs1.Contains(nbs2);
  aCont := abs1.Contains(abs2);
  AssertEquals('BoundingSphere Contains do not match',ord(nCont),ord(aCont));
end;

procedure TBSphereComparatorTest.TestIntersect;
begin
  nb := nbs1.Intersect(nbs2);
  vb := abs1.Intersect(abs2);
  AssertEquals('BoundingSphere Intersect do not match', nb, vb);
end;

initialization
RegisterTest(REPORT_GROUP_BSPHERE, TBSphereFunctionalTest);
RegisterTest(REPORT_GROUP_BSPHERE, TBSphereComparatorTest);
end.

