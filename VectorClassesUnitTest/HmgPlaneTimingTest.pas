unit HmgPlaneTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest, BaseTestCase,
  native, GLZVectorMath, GLZProfiler;

type

  { THmgPlaneTimingTest }

  THmgPlaneTimingTest  = class(TVectorBaseTimingTest)
    protected
      {$CODEALIGN RECORDMIN=16}
       vt5 : TGLZVector;
      nph1, nph2,nph3 : TNativeGLZHmgPlane;
      ph1,ph2,ph3     : TGLZHmgPlane;
      nt4: TNativeGLZVector;
      {$CODEALIGN RECORDMIN=4}
      procedure Setup; override;
    published
      procedure TestTimeCreate3Vec;
      procedure TestTimeCreatePointNorm;
      procedure TestTimeNormalizeSelf;
      procedure TestTimeNormalized;
      procedure TestTimeDistanceToPoint;
      procedure TestTimeAbsDistanceToPoint;
      procedure TestTimeDistanceToSphere;
      procedure TestTimeIsInHalfSpace;

      // helpers
      procedure TestTimeContainsBSphere;
  end;
implementation

{ THmgPlaneTimingTest }

procedure THmgPlaneTimingTest.Setup;
begin
  inherited Setup;
  Group := rgPlaneHelper;
end;

procedure THmgPlaneTimingTest.TestTimeCreate3Vec;
begin
  TestDispName := 'HmgPlane Create V3';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nph1.Create(nt1,nt4,nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin ph1.Create(vt1,vt4,vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure THmgPlaneTimingTest.TestTimeCreatePointNorm;
begin
  TestDispName := 'HmgPlane Create Point Normal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nph1.Create(nt1,NativeZHmgVector); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin ph1.Create(vt1,ZHmgVector); end;
  GlobalProfiler[1].Stop;
end;

procedure THmgPlaneTimingTest.TestTimeNormalizeSelf;
begin
  nph1.Create(nt1,nt3);
  ph1.Create(vt1,vt3);
  TestDispName := 'HmgPlane NormalizeSelf';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nph1.Normalize; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin ph1.Normalize; end;
  GlobalProfiler[1].Stop;
end;

procedure THmgPlaneTimingTest.TestTimeNormalized;
begin
  nph1.Create(nt1,nt3);
  ph1.Create(vt1,vt3);
  TestDispName := 'HmgPlane Normalized';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nph2 := nph1.Normalized; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin ph2 := ph1.Normalized; end;
  GlobalProfiler[1].Stop;
end;

procedure THmgPlaneTimingTest.TestTimeDistanceToPoint;
begin
  TestDispName := 'HmgPlane DistanceToPoint';
  GlobalProfiler[0].Clear;
  cnt := 0;
  GlobalProfiler[0].Start;
  while cnt < iterations do
  begin
    fs1 := nph1.Distance(nt3);
    inc(cnt);
  end;
  //for cnt := 1 to Iterations do begin fs1 := nph1.Distance(nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  cnt := 0;
  GlobalProfiler[1].Start;
  while cnt < iterations do
  begin
    fs2 := ph1.Distance(vt3);
    inc(cnt);
  end;
  //For cnt:= 1 to Iterations do begin fs2 := ph1.Distance(vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure THmgPlaneTimingTest.TestTimeAbsDistanceToPoint;
begin
  TestDispName := 'HmgPlane AbsDistanceToPoint';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nph1.AbsDistance(nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin fs2 := ph1.AbsDistance(vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure THmgPlaneTimingTest.TestTimeDistanceToSphere;
begin
  TestDispName := 'HmgPlane DistanceToSphere';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin fs1 := nph1.Distance(NativeNullHmgVector,1.234); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin fs2 := ph1.Distance(NullHmgVector,1.234); end;
  GlobalProfiler[1].Stop;
end;

procedure THmgPlaneTimingTest.TestTimeIsInHalfSpace;
begin
  TestDispName := 'HmgPlane IsInHalfSpace';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := nph1.IsInHalfSpace(nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin ab := ph1.IsInHalfSpace(vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure THmgPlaneTimingTest.TestTimeContainsBSphere;
var
  nsp: TNativeGLZBoundingSphere;
  asp: TGLZBoundingSphere;
  {%H-}nct, act: TGLZSpaceContains;
begin
  nsp.Create(NativeNullHmgVector, 2);
  asp.Create(NullHmgVector, 2);
  TestDispName := 'HmgPlaneHelp ContainsBSphere';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nct := nph1.Contains(nsp); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin act := ph1.Contains(asp); end;
  GlobalProfiler[1].Stop;
end;

initialization
  RegisterTest(REPORT_GROUP_PLANE_HELP, THmgPlaneTimingTest);
end.

