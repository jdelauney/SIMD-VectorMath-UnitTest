unit Vector4iTimingTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest, BaseTestCase,
  native, GLZVectorMath, GLZProfiler;

type

  { TVector4iTimingTest }

  TVector4iTimingTest =  class(TVectorBaseTimingTest)
    protected
      n4it1, n4it2, n4it3, n4it4: TNativeGLZVector4i;
      a4it1, a4it2, a4it3, a4it4: TGLZVector4i;
      b1, b2, b3, b4, b5, b6, b7, b8: integer;
      procedure Setup; override;
    published
      procedure TestTimeOpAdd;
      procedure TestTimeOpAddInt;
      procedure TestTimeOpSub;
      procedure TestTimeOpSubInt;
      procedure TestTimeOpMul;
      procedure TestTimeOpMulInt;
      procedure TestTimeOpDiv;
      procedure TestTimeOpDivInt;
      procedure TestTimeOpEquality;
      procedure TestTimeOpNotEquals;
{*      procedure TestTimeOpAnd;
      procedure TestTimeOpAndInt;
      procedure TestTimeOpOr;
      procedure TestTimeOpOrInt;
      procedure TestTimeOpXor;
      procedure TestTimeOpXorInt;     *}
      procedure TestTimeDivideBy2;
      procedure TestTimeAbs;
      procedure TestTimeOpMin;
      procedure TestTimeOpMinInt;
      procedure TestTimeOpMax;
      procedure TestTimeOpMaxInt;
      procedure TestTimeOpClamp;
      procedure TestTimeOpClampInt;
      procedure TestTimeMulAdd;
      procedure TestTimeMulDiv;
      procedure TestTimeShuffle;
      procedure TestTimeSwizzle;
      procedure TestTimeCombine;
      procedure TestTimeCombine2;
      procedure TestTimeCombine3;
      procedure TestTimeMinXYZComponent;
      procedure TestTimeMaxXYZComponent;
    end;

implementation


{ TVector4iTimingTest }

procedure TVector4iTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector4i;
  n4it1.Create(12, 124, 253, 0);
  n4it2.Create(253, 124, 12, 255);
  a4it1.V := n4it1.V;
  a4it2.V := n4it2.V;
  b1 := 3;    // three small
  b2 := 4;
  b3 := 5;
  b4 := 0;
  b5 := 2345;  // three large
  b6 := 2248;
  b7 := 2255;
  b8 := 0;
end;

procedure TVector4iTimingTest.TestTimeOpAdd;
begin
  TestDispName := 'Vector Op Add';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 + n4it2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 + a4it2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpAddInt;
begin
  TestDispName := 'Vector Op Add Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 + b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 + b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpSub;
begin
  TestDispName := 'Vector Op Sub';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 - n4it2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 - a4it2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpSubInt;
begin
  TestDispName := 'Vector Op Sub Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 - b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 - b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpMul;
begin
  TestDispName := 'Vector Op Mul';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 * n4it2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 * a4it2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpMulInt;
begin
  TestDispName := 'Vector Op Mul Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 * b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 * b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpDiv;
begin
  TestDispName := 'Vector Op Div';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 div n4it2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 div a4it2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpDivInt;
begin
  TestDispName := 'Vector Op Div Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 div b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 div b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpEquality;
begin
  TestDispName := 'Vector Op Equals';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := n4it1 = n4it1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin ab := a4it1 = a4it1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpNotEquals;
begin
  TestDispName := 'Vector Op Not Equals';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := n4it1 <> n4it2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin ab := a4it1 <> a4it2; end;
  GlobalProfiler[1].Stop;
end;

{*

procedure TVector4iTimingTest.TestTimeOpAnd;
begin
  TestDispName := 'Vector Op And';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 and n4it2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 and a4it2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpAndInt;
begin
  TestDispName := 'Vector Op And Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 and b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 and b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpOr;
begin
  TestDispName := 'Vector Op Or';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 or n4it2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 or a4it2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpOrInt;
begin
  TestDispName := 'Vector Op Or Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 or b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 or b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpXor;
begin
  TestDispName := 'Vector Op Xor';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 xor n4it2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 xor a4it2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpXorInt;
begin
  TestDispName := 'Vector Op Xor Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1 xor b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1 xor b2; end;
  GlobalProfiler[1].Stop;
end;
*}

procedure TVector4iTimingTest.TestTimeDivideBy2;
begin
  TestDispName := 'Vector DivideBy2';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.DivideBy2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.DivideBy2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeAbs;
begin
  TestDispName := 'Vector DivideBy2';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.Abs; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.Abs; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpMin;
begin
  TestDispName := 'Vector Min';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.Min(n4it2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.Min(a4it2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpMinInt;
begin
  TestDispName := 'Vector Min Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.Min(b2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.Min(b2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpMax;
begin
  TestDispName := 'Vector Max';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.Max(n4it2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.Max(a4it2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpMaxInt;
begin
  TestDispName := 'Vector Max Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.Max(b2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.Max(b2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpClamp;
begin
  TestDispName := 'Vector Clamp';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.Clamp(n4it1,n4it2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.Clamp(a4it1,a4it2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeOpClampInt;
begin
  TestDispName := 'Vector Clamp Int';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.Clamp(b2, b5); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.Clamp(b2, b5); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeMulAdd;
begin
  TestDispName := 'Vector MulAdd';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.MulAdd(n4it1,n4it2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.MulAdd(a4it1,a4it2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeMulDiv;
begin
  TestDispName := 'Vector MulDiv';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin n4it3 := n4it1.MulDiv(n4it1,n4it2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsQuarter do begin a4it3 := a4it1.MulDiv(a4it1,a4it2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeShuffle;
begin
  TestDispName := 'Vector Shuffle';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.Shuffle(1,2,3,0); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.Shuffle(1,2,3,0); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeSwizzle;
begin
  TestDispName := 'Vector Swizzle';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin n4it3 := n4it1.Swizzle(swWYXZ); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin a4it3 := a4it1.Swizzle(swWYXZ); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeCombine;
begin
  TestDispName := 'Vector Combine';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin n4it3 := n4it1.Combine(n4it1,fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsQuarter do begin a4it3 := a4it1.Combine(a4it1,fs1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeCombine2;
begin
  TestDispName := 'Vector Combine2';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin n4it3 := n4it1.Combine2(n4it1,fs1,fs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsQuarter do begin a4it3 := a4it1.Combine2(a4it1,fs1,fs2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeCombine3;
begin
  n4it4 := n4it1.Swizzle(swAGRB);
  a4it4 := a4it1.Swizzle(swAGRB);
  TestDispName := 'Vector Combine3';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin n4it3 := n4it1.Combine3(n4it1,n4it4,fs1,fs2, fs2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsQuarter do begin a4it3 := a4it1.Combine3(a4it1,a4it4,fs1,fs2, fs2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeMinXYZComponent;
begin
  TestDispName := 'Vector MinXYZComponent';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin b4 := n4it1.MinXYZComponent; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin b8 := a4it1.MinXYZComponent; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4iTimingTest.TestTimeMaxXYZComponent;
begin
  TestDispName := 'Vector MaxXYZComponent';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin b4 := n4it1.MaxXYZComponent; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin b8 := a4it1.MaxXYZComponent; end;
  GlobalProfiler[1].Stop;
end;



initialization
  RegisterTest(REPORT_GROUP_VECTOR4I, TVector4iTimingTest);
end.

