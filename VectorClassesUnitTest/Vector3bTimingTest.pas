unit Vector3bTimingTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest, BaseTestCase,
  native, GLZVectorMath, GLZProfiler;

type

   TVector3bTimingTest = class(TVectorBaseTimingTest)
     protected
       {$CODEALIGN RECORDMIN=4}
       nbt1, nbt2, nbt3, nbt4: TNativeGLZVector3b;
       abt1, abt2, abt3, abt4: TGLZVector3b;
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
       procedure TestTimeSwizzle;
   end;

implementation

procedure TVector3bTimingTest.Setup;
begin
  inherited Setup;
  Group := rgVector3b;
  nbt1.Create(12, 124, 253);
  nbt2.Create(253, 124, 12);
  abt1.V := nbt1.V;
  abt2.V := nbt2.V;
  b1 := 3;    // three small bytes
  b2 := 4;
  b3 := 5;    // b4 can be used as a result
  b5 := 245;  // three large bytes
  b6 := 248;
  b7 := 255;  //b8 can be used as a result.
end;

procedure TVector3bTimingTest.TestTimeOpAdd;
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

procedure TVector3bTimingTest.TestTimeOpAddByte;
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

procedure TVector3bTimingTest.TestTimeOpSub;
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

procedure TVector3bTimingTest.TestTimeOpSubByte;
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

procedure TVector3bTimingTest.TestTimeOpMul;
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

procedure TVector3bTimingTest.TestTimeOpMulByte;
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

procedure TVector3bTimingTest.TestTimeOpDiv;
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

procedure TVector3bTimingTest.TestTimeOpDivByte;
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

procedure TVector3bTimingTest.TestTimeOpEquality;
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

procedure TVector3bTimingTest.TestTimeOpNotEquals;
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

procedure TVector3bTimingTest.TestTimeOpAnd;
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

procedure TVector3bTimingTest.TestTimeOpAndByte;
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

procedure TVector3bTimingTest.TestTimeOpOr;
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

procedure TVector3bTimingTest.TestTimeOpOrByte;
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

procedure TVector3bTimingTest.TestTimeOpXor;
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

procedure TVector3bTimingTest.TestTimeOpXorByte;
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


procedure TVector3bTimingTest.TestTimeSwizzle;
begin
  TestDispName := 'Vector Swizzle';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nbt3 := nbt1.Swizzle(swZYX); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin abt3 := abt1.Swizzle(swZYX); end;
  GlobalProfiler[1].Stop;

end;



initialization
  RegisterTest(REPORT_GROUP_VECTOR3B, TVector3bTimingTest);

end.

