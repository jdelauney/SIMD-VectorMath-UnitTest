unit QuaternionTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

type
  { TQuaternionTimingTest }

  TQuaternionTimingTest = class(TVectorBaseTimingTest)
  protected
    procedure Setup; override;
  public
    {$CODEALIGN RECORDMIN=16}
    nqt1, nqt2,nqt3 : TNativeGLZQuaternion;
    aqt1,aqt2,aqt3     : TGLZQuaternion;
    {$CODEALIGN RECORDMIN=4}
  published
    procedure TestCreateSingles;
    procedure TestCreateImagArrayWithReal;
    procedure TestCreateTwoUnitAffine;
    procedure TestCreateTwoUnitHmg;
    procedure TestCreateAngleAxis;
    procedure TestCreateEuler;
    procedure TestCreateEulerOrder;
    procedure TestMulQuaternion;
    procedure TestConjugate;
    procedure TestOpEquals;
    procedure TestOpNotEquals;
    procedure TestMagnitude;
    procedure TestNormalize;
    procedure TestMultiplyAsSecond;
    procedure TestSlerpSingle;
    procedure TestSlerpSpin;
    procedure TestConvertToMatrix;
    procedure TestCreateMatrix;
    procedure TestTransform;
    procedure TestScale;
  end;

implementation

{ TQuaternionTimingTest }

procedure TQuaternionTimingTest.Setup;
begin
  inherited Setup;
  Group := rgQuaterion;
  nqt1.Create(5.850,-15.480,8.512,1.5);
  nqt2.Create(1.558,6.512,4.525,1.0);
  aqt1.V := nqt1.V;
  aqt2.V := nqt2.V;
end;

procedure TQuaternionTimingTest.TestCreateSingles;
begin
  TestDispName := 'Quaternion Create Singles';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt1.Create(1,2,3,4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin aqt1.Create(1,2,3,4); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestCreateImagArrayWithReal;
var arr: array [0..2] of single;
begin
  arr := aqt2.ImagePart.V;
  TestDispName := 'Quaternion Create Array';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt1.Create(arr,4); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin aqt1.Create(arr,4); end;
  GlobalProfiler[1].Stop;
end;

// have to be bit more careful with values for quats
procedure TQuaternionTimingTest.TestCreateTwoUnitAffine;
begin
  vt1.create(1,0,0,0);
  vt2.create(0,1,0,0); // positive 90deg on equator
  nt1.V := vt1.V;
  nt2.V := vt2.V;
  TestDispName := 'Quaternion Create TwoUnitAffine';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nqt1.Create(nt1.AsVector3f, nt2.AsVector3f); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsQuarter do begin aqt1.Create(vt1.AsVector3f, vt2.AsVector3f); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestCreateTwoUnitHmg;
begin
  vt1.create(1,0,0,0);
  vt2.create(0,1,0,0); // positive 90deg on equator
  nt1.V := vt1.V;
  nt2.V := vt2.V;
  TestDispName := 'Quaternion Create TwoUnitHmg';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nqt1.Create(nt1, nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsQuarter do begin aqt1.Create(vt1, vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestCreateAngleAxis;
begin
  TestDispName := 'Quaternion Create AngleAxis';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nqt1.Create(90, NativeZVector); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsQuarter do begin aqt1.Create(90, ZVector); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestCreateEuler;
begin
  TestDispName := 'Quaternion Create Euler';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsTenth do begin nqt1.Create(12,36,24); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsTenth do begin aqt1.Create(12,36,24); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestCreateEulerOrder;
begin
  TestDispName := 'Quaternion Create Euler Order';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsTenth do begin nqt1.Create(12,36,24, eulZXY); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsTenth do begin aqt1.Create(12,36,24, eulZXY); end;
  GlobalProfiler[1].Stop;
end;


{%region%====[ TQuaternionTimingTest ]============================================}

procedure TQuaternionTimingTest.TestMulQuaternion;
begin
  TestDispName := 'Quaternion Multiply Quaternion';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1 * nqt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin aqt3 := aqt1 * aqt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestConjugate;
begin
  TestDispName := 'Quaternion Conjugate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1.Conjugate; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin aqt3 := aqt1.Conjugate; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestOpEquals;
begin
  TestDispName := 'Quaternion Op Equals';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := nqt1 = nqt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin nb := aqt1 = aqt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestOpNotEquals;
begin
  TestDispName := 'Quaternion Op Not Equals';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nb := nqt1 <> nqt2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin nb := aqt1 <> aqt2; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestMagnitude;
begin
  TestDispName := 'Quaternion Magnitude';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin Fs1 := nqt1.Magnitude; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin Fs2 := aqt1.Magnitude;  end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestNormalize;
begin
  TestDispName := 'Quaternion Normalize';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt1.Normalize; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin aqt1.Normalize; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestMultiplyAsSecond;
begin
  TestDispName := 'Quaternion Multiply As Second';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt3 := nqt1.MultiplyAsSecond(nqt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin aqt3 := aqt1.MultiplyAsSecond(aqt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestSlerpSingle;
begin
  nqt1.AsVector4f := NativeWHmgVector;
  aqt1.AsVector4f := WHmgVector;  // null rotation as start point.
  nqt2.Create(90,NativeZVector);
  aqt2.Create(90,ZVector);
  TestDispName := 'Quaternion Slerp Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsTenth do begin nqt3 := nqt1.Slerp(nqt2, 0.5); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsTenth do begin aqt3 := aqt1.Slerp(aqt2, 0.5); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestSlerpSpin;
begin
  nqt1.AsVector4f := NativeWHmgVector;
  aqt1.AsVector4f := WHmgVector;  // null rotation as start point.
  nqt2.Create(90,NativeZVector);
  aqt2.Create(90,ZVector);
  TestDispName := 'Quaternion Slerp Spin';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsTenth do begin nqt3 := nqt1.Slerp(nqt2, 2, 0.5); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsTenth do begin aqt3 := aqt1.Slerp(aqt2, 2, 0.5); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestConvertToMatrix;
var
  nMat{%H-}: TNativeGLZMatrix;
  aMat{%H-}: TGLZMatrix;
begin
  nqt2.Create(90,NativeZVector);
  aqt2.Create(90,ZVector);
  TestDispName := 'Quaternion To Matrix';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nMat := nqt2.ConvertToMatrix; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin aMat := aqt1.ConvertToMatrix; end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestCreateMatrix;
var
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
begin
  nqt2.Create(90,NativeZVector);
  aqt2.Create(90,ZVector);
  nMat := nqt2.ConvertToMatrix;
  aMat := aqt1.ConvertToMatrix;
  TestDispName := 'Quaternion From Matrix';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt1.Create(nMat); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin aqt1.Create(aMat); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestTransform;
begin
  nqt1.Create(90,NativeZVector);
  aqt1.Create(90,ZVector);
  TestDispName := 'Quaternion Transform Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to IterationsQuarter do begin nt1 := nqt1.Transform(nt1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to IterationsQuarter do begin vt1 := aqt1.Transform(vt1); end;
  GlobalProfiler[1].Stop;
end;

procedure TQuaternionTimingTest.TestScale;
begin
  nqt1.Create(90,NativeZVector);
  aqt1.Create(90,ZVector);
  TestDispName := 'Quaternion Scale';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nqt1.Scale(2.0); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt := 1 to Iterations do begin aqt1.Scale(2.0); end;
  GlobalProfiler[1].Stop;
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_QUATERION, TQuaternionTimingTest);
end.

