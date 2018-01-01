unit Vector4bTimingTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest, BaseTestCase,
  native, GLZVectorMath, GLZProfiler;

type

  { TVector4bTimingTest }

  TVector4bTimingTest = class(TVectorBaseTimingTest)
    protected
      {$CODEALIGN RECORDMIN=4}
      nbt1, nbt2, nbt3, nbt4: TNativeGLZVector4b;
      abt1, abt2, abt3, abt4: TGLZVector4b;
      {$CODEALIGN RECORDMIN=1}
      b1, b2, b3, b4, b5, b6, b7, b8: byte;
      {$CODEALIGN RECORDMIN=4}
      procedure Setup; override;
    published
      procedure TestTimeOpAdd;
      procedure TestTimeOpAddByte;
      procedure TestTimeOpSub;
      procedure TestTimeOpSubByte;
      procedure TestTimeOpMul;
      procedure TestTimeOpMulByte;
      procedure TestTimeOpDiv;
      procedure TestTimeOpDivByte;
      procedure TestTimeOpEquality;
      procedure TestTimeOpNotEquals;
      procedure TestTimeOpAnd;
      procedure TestTimeOpAndByte;
      procedure TestTimeOpOr;
      procedure TestTimeOpOrByte;
      procedure TestTimeOpXor;
      procedure TestTimeOpXorByte;
      procedure TestTimeDivideBy2;
      procedure TestTimeOpMin;
      procedure TestTimeOpMinByte;
      procedure TestTimeOpMax;
      procedure TestTimeOpMaxByte;
      procedure TestTimeOpClamp;
      procedure TestTimeOpClampByte;
      procedure TestTimeMulAdd;
      procedure TestTimeMulDiv;
      procedure TestTimeGetSwizzleMode;
      procedure TestTimeAsVector4f;
      procedure TestTimeShuffle;
      procedure TestTimeSwizzle;
      procedure TestTimeCombine;
      procedure TestTimeCombine2;
      procedure TestTimeCombine3;
      procedure TestTimeMinXYZComponent;
      procedure TestTimeMaxXYZComponent;
  end;

implementation



{ TVector4bTimingTest }

procedure TVector4bTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector4b;
  nbt1.Create(12, 124, 253, 128);
  nbt2.Create(253, 124, 12, 255);
  abt1.V := nbt1.V;
  abt2.V := nbt2.V;
  b1 := 3;    // three small bytes
  b2 := 4;
  b3 := 5;    // b4 can be used as a result
  b5 := 245;  // three large bytes
  b6 := 248;
  b7 := 255;  //b8 can be used as a result.
end;

procedure TVector4bTimingTest.TestTimeOpAdd;
begin
  TestDispName := 'Vector Op Add';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 + nbt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 + abt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpAddByte;
begin
  TestDispName := 'Vector Op Add Byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 + b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 + b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpSub;
begin
  TestDispName := 'Vector Op Sub';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 - nbt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 - abt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpSubByte;
begin
  TestDispName := 'Vector Op Sub Byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 - b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 - b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpMul;
begin
  TestDispName := 'Vector Op Mul';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 * nbt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 * abt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpMulByte;
begin
  TestDispName := 'Vector Op Mul Byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 * b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 * b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpDiv;
begin
  TestDispName := 'Vector Op Div';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 div nbt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 div abt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpDivByte;
begin
  TestDispName := 'Vector Op Mul Byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 div b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 div b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpEquality;
begin
  TestDispName := 'Vector Op Equals';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := nbt1 = nbt1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := abt1 = abt1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpNotEquals;
begin
  TestDispName := 'Vector Op Not Equals';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := nbt1 <> nbt1; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vb := abt1 <> abt1; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpAnd;
begin
  TestDispName := 'Vector Op And';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 and nbt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 and abt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpAndByte;
begin
  TestDispName := 'Vector Op And Byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 and b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 and b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpOr;
begin
  TestDispName := 'Vector Op Or';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 or nbt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 or abt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpOrByte;
begin
  TestDispName := 'Vector Op Or Byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 or b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 or b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpXor;
begin
  TestDispName := 'Vector Op Xor';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 xor nbt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 xor abt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpXorByte;
begin
  TestDispName := 'Vector Op Xor Byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1 xor b2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1 xor b2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeDivideBy2;
begin
  TestDispName := 'Vector DivideBy2';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1.DivideBy2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1.DivideBy2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpMin;
begin
  TestDispName := 'Vector Op Min';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1.Min(nbt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1.Min(abt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpMinByte;
begin
  TestDispName := 'Vector Op Min Byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1.Min(b2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1.Min(b2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpMax;
begin
  TestDispName := 'Vector Op Max';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1.Max(nbt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1.Max(abt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpMaxByte;
begin
  TestDispName := 'Vector Op Max Byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1.Max(b2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1.Max(b2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpClamp;
begin
  nbt4 := nbt1.Swizzle(swAGRB);
  abt4 := abt1.Swizzle(swAGRB);
  TestDispName := 'Vector Clamp';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbt3 := nbt1.Clamp(nbt2, nbt4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abt3 := abt1.Clamp(abt2, abt4); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeOpClampByte;
begin
  TestDispName := 'Vector Clamp byte';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1.Clamp(b2, b1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1.Clamp(b2, b1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeMulAdd;
begin
  nbt4 := nbt1.Swizzle(swAGRB);
  abt4 := abt1.Swizzle(swAGRB);
  TestDispName := 'Vector MulAdd';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbt3 := nbt1.MulAdd(nbt2, nbt4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abt3 := abt1.MulAdd(abt2, abt4); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeMulDiv;
begin
  TestDispName := 'Vector MulDiv';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbt3 := nbt1.MulDiv(b2, b5); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abt3 := abt1.MulDiv(b2, b5); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeGetSwizzleMode;
var {%H-}asw: TGLZVector4SwizzleRef;
begin
  TestDispName := 'Vector GetSwizzleMode';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin asw := nbt1.GetSwizzleMode; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin asw := abt1.GetSwizzleMode; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeAsVector4f;
var
  {%H-}nres: TNativeGLZVector4f;
  {%H-}ares: TGLZVector4f;
begin
  TestDispName := 'Vector AsVector4f';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nres := nbt1.AsVector4f; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin ares := abt1.AsVector4f; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeShuffle;
begin
  TestDispName := 'Vector Shuffle';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1.Shuffle(1,2,3,0); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1.Shuffle(1,2,3,0); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeSwizzle;
begin
  TestDispName := 'Vector Swizzle';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1.Swizzle(swZYXW); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1.Swizzle(swZYXW); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeCombine;
begin
  TestDispName := 'Vector Combine';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbt3 := nbt1.Combine(nbt2, b1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abt3 := abt1.Combine(abt2, b1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeCombine2;
begin
  TestDispName := 'Vector Combine2';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbt3 := nbt1.Combine2(nbt2, b1, b2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abt3 := abt1.Combine2(abt2, b1, b2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeCombine3;
begin
  nbt4 := nbt1.Swizzle(swAGRB);
  abt4 := abt1.Swizzle(swAGRB);
  TestDispName := 'Vector Combine3';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nbt3 := nbt1.Combine3(nbt2, nbt4, b1, b2, b3); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to IterationsQuarter do begin abt3 := abt1.Combine3(abt2, abt4, b1, b2, b3); end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeMinXYZComponent;
begin
  TestDispName := 'Vector MinXYZComponent';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin b4 := nbt1.MinXYZComponent; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin b4 := abt1.MinXYZComponent; end;
  GlobalProfiler[1].Stop;
end;

procedure TVector4bTimingTest.TestTimeMaxXYZComponent;
begin
  TestDispName := 'Vector MaxXYZComponent';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin b4 := nbt1.MaxXYZComponent; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin b4 := abt1.MaxXYZComponent; end;
  GlobalProfiler[1].Stop;
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR4B, TVector4bTimingTest);

end.

