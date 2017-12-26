unit averagenormal_test_cases;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$ASMMODE Intel}
interface

uses
  Classes, SysUtils, fpcunit, testregistry,  native, GLZVectorMath,
  averagenormal_code, basetiming;

type

  { TAverageNormalTickTest }

  TAverageNormalTickTest = class(TTestCase)
    private
      procedure MinMax(AValue: QWord);
    protected
      procedure Setup; override;
      procedure TearDown; override;
    public
      TestDispName: string;
      minTicks, maxTicks: QWord;
      AvgTicks: single;
    published

      procedure TickNOPCallNoStackFrame;
      procedure TickNOPCall;
      procedure TickAverageNormal4;
  end;

  { TAverageNormalUnitTest }

  TAverageNormalUnitTest= class(TTestCase)
  published
    procedure TestAverageNormal4XY;
    procedure TestAverageNormal4NegXY;
    procedure TestAverageNormal4YZ;
    procedure TestAverageNormal4NegYZ;
    procedure TestAverageNormal4XZ;
    procedure TestAverageNormal4NegXZ;
    procedure TestLiftUp;
    procedure TestLiftDown;
    procedure TestLiftLeft;
    procedure TestLiftRight;

  end;

  { TAverageNormalCompareTest }

  TAverageNormalCompareTest = class(TTestCase)
    procedure TestAverageNormal4;
  end;

  { TAverageNormalTimingTest }

  TAverageNormalTimingTest = class(TBaseTimingTest)
    procedure TimeAverageNormal4;
  end;

implementation

// hacky we just take the low 32 bits of the cpu counter
// compiler protects regs no need to repilcate here.
// we are only interested in the min value really
// so a loop of 100 will always get us the min
function ASMTick: int64; assembler;
asm
{$ifdef CPU64}
  XOR rax, rax
//  CPUID
  RDTSC  //Get the CPU's time stamp counter.
  mov [Result], RAX
{$else}
  XOR eax, eax
//  CPUID
  RDTSC  //Get the CPU's time stamp counter.
  mov [Result], eax
{$endif}
end;


procedure NOPCall; assembler;
asm

end;

procedure NOPCallNoStackFrame; assembler; nostackframe;
asm

end;

const
  //  vector of 2 against 0.68 normalised
  liftMajor = 0.946772695;
  liftMinor = 0.321902722;

{ TAverageNormalTickTest }

procedure TAverageNormalTickTest.MinMax(AValue: QWord);
begin
  if AValue < minTicks then minTicks := AValue;
  if AValue > maxTicks then maxTicks := AValue;
end;

procedure TAverageNormalTickTest.Setup;
begin
  inherited Setup;
  maxTicks := 0;
  minTicks := not(maxTicks);
end;

procedure TAverageNormalTickTest.TearDown;
begin
  sl.Add(Format('%s:, %d, %d, %.2f', [TestDispName, minTicks,maxTicks, AvgTicks]));
  inherited TearDown;
end;

procedure TAverageNormalTickTest.TickAverageNormal4;
var
  vt1, cena, lefta, righta, upa, downa : TGLZVector4f;
  avg, sTick, eTick, dTick: qword;
  i: integer;

begin
  TestDispName:='Proc Tick AverageNormal4';
  cena.Create(1,1,0.34,0);
  lefta.Create(0,1,0,0);
  righta.Create(2,1,0.68,0);
  upa.create(1,2,-3,0);
  downa.Create(1,0,0.5,0);
  avg := 0;
  for i := 0 to 99 do
  begin
    sTick := ASMTick;
    vt1 := cena.AverageNormal4(upa,lefta,downa,righta);
    eTick := ASMTick;
    dTick := eTick-sTick;
    minMax(dTick);
    avg := avg + dTick;
  end;
  AvgTicks:= avg / 100;
end;

procedure TAverageNormalTickTest.TickNOPCall;
var
  avg, dummy, sTick, eTick, dTick: qword;
  i: integer;
begin
  avg := 0;
  for i := 0 to 99 do
  begin
    TestDispName:='Proc Tick NOPCall';
    sTick := ASMTick;
    NOPCall;
    eTick := ASMTick;
    dTick := eTick-sTick;
    minMax(dTick);
    avg := avg + dTick;
  end;
  AvgTicks:= avg / 100;

end;

procedure TAverageNormalTickTest.TickNOPCallNoStackFrame;
var
  avg, dummy, sTick, eTick, dTick: qword;
  i: integer;
begin
  avg := 0;
  for i := 0 to 99 do
  begin
    TestDispName:='Proc Tick NOPCallNoStackFrame';
    sTick := ASMTick;
    NOPCallNoStackFrame;
    eTick := ASMTick;
    dTick := eTick-sTick;
    minMax(dTick);
    avg := avg + dTick;
  end;
  AvgTicks:= avg / 100;

end;

{ TAverageNormalCompareTest }

procedure TAverageNormalCompareTest.TestAverageNormal4;
var
  vt1, cena, lefta, righta, upa, downa : TGLZVector4f;
  nt1, cen, left, right, up, down : TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,1,0,0);
  right.Create(2,1,0.68,0);
  up.create(1,2,-3,0);
  down.Create(1,0,0.5,0);
  cena.V := cen.V;
  lefta.V := left.V;
  righta.V := right.V;
  upa.V := up.V;
  downa.V := down.V;
  nt1 := cen.AverageNormal4(up,left,down,right);
  vt1 := cena.AverageNormal4(upa,lefta,downa,righta);
  AssertTrue('Test Values do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1, 1e-7));
end;

{ TAverageNormalTimingTest }

procedure TAverageNormalTimingTest.TimeAverageNormal4;
var
  cena, lefta, righta, upa, downa : TGLZVector4f;
  cen, left, right, up, down : TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,1,0,0);
  right.Create(2,1,0,0);
  up.create(1,2,0,0);
  down.Create(1,0,0,0);
  cena.V := cen.V;
  lefta.V := left.V;
  righta.V := right.V;
  upa.V := up.V;
  downa.V := down.V;
  TestDispName := 'AverageNormal4';
  StartTimer;
  for cnt := 1 to IterationsQuarter do begin nt3 := cen.AverageNormal4(up,left,down,right); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to IterationsQuarter do begin vt3 := cena.AverageNormal4(upa,lefta,downa,righta); end;
  StopTimer;
  etAsm := elapsedTime;
end;

{ TAverageNormalUnitTest }

// test with all points on xy plane cen raised
// should have unit z vector result
procedure TAverageNormalUnitTest.TestAverageNormal4XY;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,1,0,0);
  right.Create(2,1,0,0);
  up.create(1,2,0,0);
  down.Create(1,0,0,0);
  expect.Create(0,0,1,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4XY : '+res.ToString+' --> '+expect.ToString, Compare(res,expect));
end;

// rotate above test around x axis by flipping up and down values
// should have negative unit z vector result
procedure TAverageNormalUnitTest.TestAverageNormal4NegXY;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,1,0,0);
  right.Create(2,1,0,0);
  up.create(1,0,0,0);
  down.Create(1,2,0,0);
  expect.Create(0,0,-1,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4NegXY : '+res.ToString+' --> '+expect.ToString, Compare(res,expect));
end;

//same for yz plane
procedure TAverageNormalUnitTest.TestAverageNormal4YZ;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,0,1,0);
  right.Create(0,2,1,0);
  up.create(0,1,2,0);
  down.Create(0,1,0,0);
  expect.Create(1,0,0,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4YZ : '+res.ToString+' --> '+expect.ToString, Compare(res,expect));
end;

procedure TAverageNormalUnitTest.TestAverageNormal4NegYZ;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,2,1,0);
  right.Create(0,0,1,0);
  up.create(0,1,2,0);
  down.Create(0,1,0,0);
  expect.Create(-1,0,0,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4YZ : '+res.ToString+' --> '+expect.ToString, Compare(res,expect));
end;

procedure TAverageNormalUnitTest.TestAverageNormal4XZ;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,0.34,1,0);
  left.Create(2,0,1,0);
  right.Create(0,0,1,0);
  up.create(1,0,2,0);
  down.Create(1,0,0,0);
  expect.Create(0,1,0,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4YZ : '+res.ToString+' --> '+expect.ToString, Compare(res,expect));
end;

procedure TAverageNormalUnitTest.TestAverageNormal4NegXZ;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,0.34,1,0);
  left.Create(0,0,1,0);
  right.Create(2,0,1,0);
  up.create(1,0,2,0);
  down.Create(1,0,0,0);
  expect.Create(0,-1,0,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4YZ : '+res.ToString+' --> '+expect.ToString, Compare(res,expect));
end;

// on XY test lift up to double cen
// should have negative y positive z 0 x
procedure TAverageNormalUnitTest.TestLiftUp;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,1,0,0);
  right.Create(2,1,0,0);
  up.create(1,2,0.68,0);
  down.Create(1,0,0,0);
  expect.Create(0,-liftMinor,LiftMajor,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4XY : '+res.ToString+' --> '+expect.ToString, Compare(res, expect, 1e-7));
end;

// should have positive y positive z 0 x
procedure TAverageNormalUnitTest.TestLiftDown;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,1,0,0);
  right.Create(2,1,0,0);
  up.create(1,2,0,0);
  down.Create(1,0,0.68,0);
  expect.Create(0,liftMinor,LiftMajor,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4XY : '+res.ToString+' --> '+expect.ToString, Compare(res, expect, 1e-7));
end;

// should have zero y positive z positive x
procedure TAverageNormalUnitTest.TestLiftLeft;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,1,0.68,0);
  right.Create(2,1,0,0);
  up.create(1,2,0,0);
  down.Create(1,0,0,0);
  expect.Create(liftMinor,0,LiftMajor,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4XY : '+res.ToString+' --> '+expect.ToString, Compare(res, expect, 1e-7));
end;

// should have zero y positive z negative x
procedure TAverageNormalUnitTest.TestLiftRight;
var
  cen: TNativeGLZVector4f;
  left, right, up, down, res, expect: TNativeGLZVector4f;
begin
  cen.Create(1,1,0.34,0);
  left.Create(0,1,0,0);
  right.Create(2,1,0.68,0);
  up.create(1,2,0,0);
  down.Create(1,0,0,0);
  expect.Create(-liftMinor,0,LiftMajor,0);
  res := cen.AverageNormal4(up,left,down,right);
  AssertTrue('Vector AverageNormal4XY : '+res.ToString+' --> '+expect.ToString, Compare(res, expect, 1e-7));
end;

initialization

  RegisterTest(TAverageNormalUnitTest);
  RegisterTest(TAverageNormalCompareTest);
  RegisterTest(TAverageNormalTickTest);
  RegisterTest(TAverageNormalTimingTest);

end.

