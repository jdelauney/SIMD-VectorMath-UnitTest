unit VectorOtherTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest, BaseTestCase,
  native, GLZVectorMath, GLZProfiler;

type

  { TVectorOtherTimingTest }

  TVectorOtherTimingTest = class(TVectorBaseTimingTest)
    protected
      procedure Setup; override;
    published
      procedure TestTimeMinXYZComponent;
      procedure TestTimeMaxXYZComponent;
      procedure TestTimeShuffle;
      procedure TestTimeSwizzle;
      procedure TestTimeMinVector;
      procedure TestTimeMaxVector;
      procedure TestTimeMinSingle;
      procedure TestTimeMaxSingle;
      procedure TestTimeClampVector;
      procedure TestTimeClampSingle;
      procedure TestTimeLerp;
<<<<<<< HEAD
=======
      //procedure TestTimePerp;
      //procedure TestTimeReflect;
>>>>>>> 402483f68f170a4c97302c2212f6e903db26e8e5
  //      procedure TestMoveAround;
      procedure TestTimeCombine;
      procedure TestTimeCombine2;
      procedure TestTimeCombine3;
 end;

implementation

{ TVectorOtherTimingTest }

procedure TVectorOtherTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector4f;
end;

procedure TVectorOtherTimingTest.TestTimeMinXYZComponent;
begin
  TestDispName := 'Vector4f MinXYZComponent';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nt1.MinXYZComponent; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin Fs2 := vt1.MinXYZComponent; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeMaxXYZComponent;
begin
  TestDispName := 'Vector4f MaxXYZComponent';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nt1.MaxXYZComponent; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin Fs2 := vt1.MaxXYZComponent; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeShuffle;
begin
  TestDispName := 'Vector4f  Shuffle';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Shuffle(1,2,3,0); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Shuffle(1,2,3,0); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeSwizzle;
begin
  TestDispName := 'Vector4f  Swizzle';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Swizzle(swWZYX); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Swizzle(swWZYX); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeMinVector;
begin
  TestDispName := 'Vector4f Min Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Min(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Min(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeMaxVector;
begin
  TestDispName := 'Vector4f Max Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Max(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Max(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeMinSingle;
begin
  TestDispName := 'Vector4f Min Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Min(Fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Min(Fs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeMaxSingle;
begin
  TestDispName := 'Vector4f Max Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Max(Fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Max(Fs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeClampVector;
begin
  TestDispName := 'Vector4f Clamp Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Clamp(nt2,nt1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Clamp(vt2,vt1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeClampSingle;
begin
  TestDispName := 'Vector4f Clamp Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Clamp(fs2,fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Clamp(fs2,fs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeLerp;
begin
  TestDispName := 'Vector4f Lerp';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Lerp(nt1,0.8); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Lerp(vt1,0.8); end;
  GlobalProfiler[1].Stop;
end;

<<<<<<< HEAD

=======
//procedure TVectorOtherTimingTest.TestTimePerp;
//begin
//  TestDispName := 'Vector4f Perp';
//  GlobalProfiler[0].Clear;
//  GlobalProfiler[0].Start;
//  for cnt := 1 to Iterations do begin nt3 := nt1.Perpendicular(nt2); end;
//  GlobalProfiler[0].Stop;
//  GlobalProfiler[1].Clear;
//  GlobalProfiler[1].Start;
//  For cnt := 1 to Iterations do begin vt3 := vt1.Perpendicular(vt2); end;
//  GlobalProfiler[1].Stop;
//end;
//
//procedure TVectorOtherTimingTest.TestTimeReflect;
//begin
//  TestDispName := 'Vector4f Reflect';
//  GlobalProfiler[0].Clear;
//  GlobalProfiler[0].Start;
//  for cnt := 1 to Iterations do begin nt3 := nt1.Reflect(nt2); end;
//  GlobalProfiler[0].Stop;
//  GlobalProfiler[1].Clear;
//  GlobalProfiler[1].Start;
//  For cnt := 1 to Iterations do begin vt3 := vt1.Reflect(vt2); end;
//  GlobalProfiler[1].Stop;
//end;
>>>>>>> 402483f68f170a4c97302c2212f6e903db26e8e5

procedure TVectorOtherTimingTest.TestTimeCombine;
begin
  TestDispName := 'Vector4f Combine';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Combine(nt2, fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Combine(vt2, fs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeCombine2;
begin
  TestDispName := 'Vector4f Combine2';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Combine2(nt2, fs1, fs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Combine2(vt2, fs1, fs2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOtherTimingTest.TestTimeCombine3;
begin
  TestDispName := 'Vector4f Combine3';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Combine3(nt2, nt1, fs1, fs2, fs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin vt3 := vt1.Combine3(vt2, vt1, fs1, fs2, fs2); end;
  GlobalProfiler[1].Stop;
end;


initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVectorOtherTimingTest);
end.

