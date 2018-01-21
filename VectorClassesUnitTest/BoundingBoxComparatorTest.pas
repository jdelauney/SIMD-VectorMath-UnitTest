unit BoundingBoxComparatorTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  { TBoundingBoxComparatorTest }

  TBoundingBoxComparatorTest = class(TBBoxBaseTestCase)

    published
      procedure TestCompare;
      procedure TestCompareFalse;
      procedure TestOpAdd;
      procedure TestOpAddVector;
      procedure TestOpEquality;
      procedure TestTransform;
      procedure TestMinX;
      procedure TestMaxX;
      procedure TestMinY;
      procedure TestMaxY;
      procedure TestMinZ;
      procedure TestMaxZ;
  end;

implementation



{ TBoundingBoxComparatorTest }

procedure TBoundingBoxComparatorTest.TestCompare;
begin
  AssertTrue('Test Values do not match', Compare(nbb1,abb1));
end;

procedure TBoundingBoxComparatorTest.TestCompareFalse;
begin
  AssertFalse('Test Values should not match', Compare(nbb2,abb1));
end;

procedure TBoundingBoxComparatorTest.TestOpAdd;
begin
  nbb3 := nbb1 + nbb2;
  abb3 := abb1 + abb2;
  AssertTrue('Test Op Add BBox does not match', Compare(nbb3,abb3));
end;

procedure TBoundingBoxComparatorTest.TestOpAddVector;
begin
  nbb3 := nbb1 + nt2;
  abb3 := abb1 + vt2;
  AssertTrue('Test Op Add Vector does not match', Compare(nbb3,abb3));
end;

procedure TBoundingBoxComparatorTest.TestOpEquality;
begin
  nb := nbb1 = nbb1;
  vb := abb1 = abb1;
  AssertTrue('Test bounding box = do not match', (nb = vb));
  nb := nbb1 = nbb2;
  vb := abb1 = abb2;
  AssertTrue(' Test bounding box = should not match', (nb = vb));
end;

procedure TBoundingBoxComparatorTest.TestTransform;
var
  nmat: TNativeGLZMatrix;
  amat: TGLZMatrix;
begin
  nmat.CreateTranslationMatrix(nt2);
  amat.CreateTranslationMatrix(vt2);
  nbb3 := nbb1.Transform(nmat);
  abb3 := abb1.Transform(amat);
  AssertTrue('Test BBox Transform does not match', Compare(nbb3, abb3));
end;

procedure TBoundingBoxComparatorTest.TestMinX;
begin
  nbb3 := nbb1 + nbb2;
  abb3 := abb1 + abb2;
  fs1 := nbb3.MinX;
  fs2 := abb3.MinX;
  AssertTrue('BBox MinX do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TBoundingBoxComparatorTest.TestMaxX;
begin
  nbb3 := nbb1 + nbb2;
  abb3 := abb1 + abb2;
  fs1 := nbb3.MaxX;
  fs2 := abb3.MaxX;
  AssertTrue('BBox MaxX do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TBoundingBoxComparatorTest.TestMinY;
begin
  nbb3 := nbb1 + nbb2;
  abb3 := abb1 + abb2;
  fs1 := nbb3.MinY;
  fs2 := abb3.MinY;
  AssertTrue('BBox MinY do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TBoundingBoxComparatorTest.TestMaxY;
begin
  nbb3 := nbb1 + nbb2;
  abb3 := abb1 + abb2;
  fs1 := nbb3.MaxY;
  fs2 := abb3.MaxY;
  AssertTrue('BBox MaxY do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TBoundingBoxComparatorTest.TestMinZ;
begin
  nbb3 := nbb1 + nbb2;
  abb3 := abb1 + abb2;
  fs1 := nbb3.MinZ;
  fs2 := abb3.MinZ;
  AssertTrue('BBox MinZ do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TBoundingBoxComparatorTest.TestMaxZ;
begin
  nbb3 := nbb1 + nbb2;
  abb3 := abb1 + abb2;
  fs1 := nbb3.MaxZ;
  fs2 := abb3.MaxZ;
  AssertTrue('BBox MaxZ do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

initialization
  RegisterTest(REPORT_GROUP_BBOX, TBoundingBoxComparatorTest);
end.

