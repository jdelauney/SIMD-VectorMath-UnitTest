unit BoundingBoxTimingTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest, BaseTestCase,
  native, GLZVectorMath, GLZProfiler;

type

  { TBoundingBoxTimingTest }

  TBoundingBoxTimingTest = class(TVectorBaseTimingTest)
     protected
       {$CODEALIGN RECORDMIN=16}
       nbb1,nbb2,nbb3: TNativeGLZBoundingBox;
       abb1,abb2,abb3: TGLZBoundingBox;
       procedure Setup; override;
     published
       procedure TestTimeOpAdd;
       procedure TestTimeOpAddVector;
       procedure TestTimeOpEquality;
       procedure TestTimeTransform;
       procedure TestTimeMinX;
       procedure TestTimeMaxX;
       procedure TestTimeMinY;
       procedure TestTimeMaxY;
       procedure TestTimeMinZ;
       procedure TestTimeMaxZ;
   end;

implementation

{ TBoundingBoxTimingTest }

procedure TBoundingBoxTimingTest.Setup;
begin
  inherited Setup;
  Group := rgBBox;
  nbb1.Create(nt1);
  abb1.Create(vt1);
  nbb2.Create(nt2);
  abb2.Create(vt2);
end;

procedure TBoundingBoxTimingTest.TestTimeOpAdd;
begin
  TestDispName := 'BBox Op Add';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbb3 := nbb1 + nbb2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abb3 := abb1 + abb2; end;
  GlobalProfiler[1].Stop;
end;

procedure TBoundingBoxTimingTest.TestTimeOpAddVector;
begin
  TestDispName := 'BBox Op Add Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbb3 := nbb1 + nt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abb3 := abb1 + vt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TBoundingBoxTimingTest.TestTimeOpEquality;
begin
  TestDispName := 'BBox Op Equality';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nb := nbb1 = nbb1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin nb := abb1 = abb1; end;
  GlobalProfiler[1].Stop;
end;

procedure TBoundingBoxTimingTest.TestTimeTransform;
var
  nmat: TNativeGLZMatrix;
  amat: TGLZMatrix;
begin
  nmat.CreateTranslationMatrix(nt2);
  amat.CreateTranslationMatrix(vt2);
  TestDispName := 'BBox Trandform';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbb3 := nbb1.Transform(nmat); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abb3 := abb1.Transform(amat); end;
  GlobalProfiler[1].Stop;
end;

procedure TBoundingBoxTimingTest.TestTimeMinX;
begin
  TestDispName := 'BBox MinX';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nbb1.MinX; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin fs2 := abb1.MinX; end;
  GlobalProfiler[1].Stop;
end;

procedure TBoundingBoxTimingTest.TestTimeMaxX;
begin
  TestDispName := 'BBox MaxX';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nbb1.MaxX; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin fs2 := abb1.MaxX; end;
  GlobalProfiler[1].Stop;
end;

procedure TBoundingBoxTimingTest.TestTimeMinY;
begin
  TestDispName := 'BBox MinY';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nbb1.MinY; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin fs2 := abb1.MinY; end;
  GlobalProfiler[1].Stop;
end;

procedure TBoundingBoxTimingTest.TestTimeMaxY;
begin
  TestDispName := 'BBox MaxY';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nbb1.MaxY; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin fs2 := abb1.MaxY; end;
  GlobalProfiler[1].Stop;
end;

procedure TBoundingBoxTimingTest.TestTimeMinZ;
begin
  TestDispName := 'BBox MinZ';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nbb1.MinZ; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin fs2 := abb1.MinZ; end;
  GlobalProfiler[1].Stop;
end;

procedure TBoundingBoxTimingTest.TestTimeMaxZ;
begin
  TestDispName := 'BBox MaxZ';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nbb1.MaxZ; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin fs2 := abb1.MaxZ; end;
  GlobalProfiler[1].Stop;
end;

initialization
  RegisterTest(REPORT_GROUP_BBOX, TBoundingBoxTimingTest);
end.

