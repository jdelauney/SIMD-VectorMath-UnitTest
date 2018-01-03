unit VectorAndHmgPlaneTimingTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

type

  { TVectorAndHmgPlaneTimingTest }

  TVectorAndHmgPlaneTimingTest = class(TVectorBaseTimingTest)
    protected
      {$CODEALIGN RECORDMIN=16}
      nph1, nph2,nph3 : TNativeGLZHmgPlane; //TNativeGLZHmgPlaneHelper;
      nt4,nt5 : TNativeGLZVector;
      vt4, vt5 : TGLZVector;
      ph1,ph2,ph3     : TGLZHmgPlane; //TGLZHmgPlaneHelper;
      {$CODEALIGN RECORDMIN=4}
      alpha: single;      procedure Setup; override;
    published
      procedure TestTimeCreatePlane3Vec;
      procedure TestTimeCreatePlanePointNorm;
      procedure TestTimeNormalizePlane;
      procedure TestTimeCalcPlaneNormal;
      procedure TestTimeDistancePlaneToPoint;
      procedure TestTimeDistancePlaneToSphere;
      procedure TestTimeRotate;
      procedure TestTimeRotateAroundX;
      procedure TestTimeRotateAroundY;
      procedure TestTimeRotateAroundZ;
      procedure TestTimeAverageNormal4;
      procedure TestTimePointProject;
      procedure TestTimeIsColinear;
      procedure TestTimeMoveAround;
      procedure TestTimeShiftObjectFromCenter;
      procedure TestTimeExtendClipRect;
  end;
implementation

{ TVectorAndHmgPlaneTimingTest }

procedure TVectorAndHmgPlaneTimingTest.Setup;
begin
  inherited Setup;
  Group := rgPlaneHelper;
  nt3.Create(10.350,10.470,2.482,0.0);
  nt4.Create(20.350,18.470,8.482,0.0);
  nph1.CreatePlane(nt1,nt2,nt3);
  ph1.V := nph1.V;
  vt3.V := nt3.V;
  vt4.V := nt4.V;
  alpha := pi / 6;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeCreatePlane3Vec;
begin
  TestDispName := 'HmgPlane CreatePlane 3Vec';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt4.CreatePlane(nt1, nt2, nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt4.CreatePlane(vt1, vt2, vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeCreatePlanePointNorm;
begin
  TestDispName := 'HmgPlane CreatePlane Point Norm';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3.CreatePlane(nt1,nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vt3.CreatePlane(vt1,vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeNormalizePlane;
begin
  TestDispName := 'HmgPlane Normalize Plane';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nph3:= nph1.NormalizePlane; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin ph3:= ph1.NormalizePlane; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeCalcPlaneNormal;
begin
  TestDispName := 'HmgPlane Calc Plane Normal';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt4.CalcPlaneNormal(nt1, nt2, nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt4.CalcPlaneNormal(vt1, vt2, vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeDistancePlaneToPoint;
begin
  TestDispName := 'HmgPlane Distance Plane To Point';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nph1.DistancePlaneToPoint(nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := ph1.DistancePlaneToSphere(vt3,0.5); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeDistancePlaneToSphere;
begin
  TestDispName := 'HmgPlane Distance Plane To Sphere';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nph1.DistancePlaneToSphere(nt3,0.5); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := ph1.DistancePlaneToSphere(vt3,0.5); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeRotate;
begin
  TestDispName := 'VectorH Rotate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.Rotate(NativeYHmgVector,alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.Rotate(YHmgVector,alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeRotateAroundX;
begin
  TestDispName := 'VectorH Rotate Around X';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.RotateAroundX(alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.RotateAroundX(alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeRotateAroundY;
begin
  TestDispName := 'VectorH Rotate Around Y';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.RotateAroundY(alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.RotateAroundY(alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeRotateAroundZ;
begin
  TestDispName := 'VectorH Rotate Around Z';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.RotateAroundZ(alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.RotateAroundZ(alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeAverageNormal4;
begin
  TestDispName := 'VectorH AverageNormal4';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt5 := nt1.AverageNormal4(nt1,nt2,nt3,nt4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt5 := vt1.AverageNormal4(vt1,vt2,vt3,vt4); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimePointProject;
begin
  TestDispName := 'VectorH Point Project';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nt1.PointProject(nt2,nt3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin Fs2 := vt1.PointProject(vt2,vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeIsColinear;
begin
  TestDispName := 'VectorH IsCoLinear';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := nt1.IsColinear(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin vb := vt1.IsColinear(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeMoveAround;
begin
  TestDispName := 'VectorH MoveAround';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.MoveAround(NativeYHmgVector,nt2, alpha, alpha); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.MoveAround(YHmgVector,vt2, alpha, alpha); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeShiftObjectFromCenter;
begin
  TestDispName := 'VectorH ShiftObjectFromCenter';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt3 := nt1.ShiftObjectFromCenter(nt2, Fs1, True); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to IterationsQuarter do begin vt3 := vt1.ShiftObjectFromCenter(vt2, Fs1, True); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorAndHmgPlaneTimingTest.TestTimeExtendClipRect;
var
  nCr: TNativeGLZClipRect;
  aCr: TGLZClipRect;
begin
  nCr.V := nt1.V;
  aCr.V := vt1.V;
  TestDispName := 'VectorH ExtendClipRect';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nCr.ExtendClipRect(Fs1,Fs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  for cnt := 1 to Iterations do begin aCr.ExtendClipRect(Fs1,Fs2); end;
  GlobalProfiler[1].Stop;
end;

initialization
  RegisterTest(REPORT_GROUP_PLANE_HELP, TVectorAndHmgPlaneTimingTest);
end.

