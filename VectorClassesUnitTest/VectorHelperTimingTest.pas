unit VectorHelperTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

type

  { TVectorHelperTimingTest }

  TVectorHelperTimingTest = class(TVectorBaseTimingTest)
    protected
      {$CODEALIGN RECORDMIN=16}
      nt4,nt5 : TNativeGLZVector;
       vt5 : TGLZVector;
      {$CODEALIGN RECORDMIN=4}
      alpha: single;
      procedure Setup; override;
    published
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

{ TVectorHelperTimingTest }
procedure TVectorHelperTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector4f;
  nt3.Create(10.350,10.470,2.482,0.0);
  nt4.Create(20.350,18.470,8.482,0.0);
  vt3.V := nt3.V;
  vt4.V := nt4.V;
  alpha := pi / 6;
end;


procedure TVectorHelperTimingTest.TestTimeRotate;
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

procedure TVectorHelperTimingTest.TestTimeRotateAroundX;
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

procedure TVectorHelperTimingTest.TestTimeRotateAroundY;
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

procedure TVectorHelperTimingTest.TestTimeRotateAroundZ;
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

procedure TVectorHelperTimingTest.TestTimeAverageNormal4;
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

procedure TVectorHelperTimingTest.TestTimePointProject;
var j: byte;
begin
  TestDispName := 'VectorH Point Project';
  GlobalProfiler[0].Clear;
  cnt:=0;
  GlobalProfiler[0].Start;

  //for cnt := 1 to Iterations do begin Fs1 := nt1.PointProject(nt2,nt3); end;
  while cnt<Iterations do
  begin
    Fs1 := nt1.PointProject(nt2,nt3);
    inc(cnt);
  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  cnt:=0;
  GlobalProfiler[1].Start;

  while cnt<Iterations do
  begin
    Fs2 := vt1.PointProject(vt2,vt3);
    inc(cnt);
  end;
  //for cnt := 1 to Iterations do begin Fs2 := vt1.PointProject(vt2,vt3); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorHelperTimingTest.TestTimeIsColinear;
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

procedure TVectorHelperTimingTest.TestTimeMoveAround;
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

procedure TVectorHelperTimingTest.TestTimeShiftObjectFromCenter;
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

procedure TVectorHelperTimingTest.TestTimeExtendClipRect;
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
  RegisterTest(REPORT_GROUP_VECTOR4F, TVectorHelperTimingTest);
end.

