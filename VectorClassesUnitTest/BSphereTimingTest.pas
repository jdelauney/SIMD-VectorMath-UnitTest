unit BSphereTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest, BaseTestCase,
  native, GLZVectorMath, GLZVectorMathEx, GLZProfiler;

type

  { TBSphereTimingTest }

  TBSphereTimingTest = class(TVectorBaseTimingTest)
  protected
    {$CODEALIGN RECORDMIN=16}
    nbs1,nbs2,nbs3: TNativeGLZBoundingSphere;
    abs1,abs2,abs3: TGLZBoundingSphere;
    {$CODEALIGN RECORDMIN=4}
    procedure Setup; override;
  published
    procedure TestTimeContains;
    procedure TestTimeIntersect;
  end;

implementation


{ TBSphereTimingTest }

procedure TBSphereTimingTest.Setup;
begin
  inherited Setup;
  Group := rgBSphere;
  nbs1.Create(nt1, 1.356);
  abs1.Create(vt1, 1.356);
  nbs2.Create(nt2, 8.435);
  abs2.Create(vt2, 8.435);
end;

procedure TBSphereTimingTest.TestTimeContains;
var {%H-}nCont, {%H-}aCont: TGLZSpaceContains;
begin
  TestDispName := 'BSphere Contains';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nCont := nbs1.Contains(nbs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin aCont := abs1.Contains(abs2); end;
  GlobalProfiler[1].Stop;
end;

procedure TBSphereTimingTest.TestTimeIntersect;
begin
  TestDispName := 'BSphere Intersect';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := nbs1.Intersect(nbs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := abs1.Intersect(abs2); end;
  GlobalProfiler[1].Stop;

end;

initialization
  RegisterTest(REPORT_GROUP_BSPHERE, TBSphereTimingTest);
end.

