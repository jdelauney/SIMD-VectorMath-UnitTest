unit QuaternionTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TQuaternionTestCase }

  TQuaternionTestCase = class(TVectorBaseTestCase)
  protected
    procedure Setup; override;
  public
    {$CODEALIGN RECORDMIN=16}
    nqt1, nqt2, nqt3 : TNativeGLZQuaternion;
    qt1, qt2, qt3    : TGLZQuaternion;
    {$CODEALIGN RECORDMIN=4}
  published
    procedure TestAddQuaternion;
    procedure TestAddSingle;
    procedure TestSubQuaternion;
    procedure TestSubSingle;
    procedure TestMulQuaternion;
    procedure TestMulSingle;
    procedure TestDivSingle;
    procedure TestNegate;
    procedure TestConjugate;
    procedure TestMagnitude;
    procedure TestNormalize;
    procedure TestMultiplyAsSecond;
  end;

implementation

{ TQuaternionTestCase }

procedure TQuaternionTestCase.Setup;
begin
  inherited Setup;
  nqt1.Create(5.850,-15.480,8.512,1.5);
  nqt2.Create(1.558,6.512,4.525,1.0);
  qt1.V := nqt1.V;
  qt2.V := nqt2.V;
end;


{%region%====[ TQuaternionTestCase ]============================================}

procedure TQuaternionTestCase.TestAddQuaternion;
begin
  nqt3 := nqt1 + nqt2;
  qt3 := qt1 + qt2;
  AssertTrue('Quaternion + Quaternion no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

procedure TQuaternionTestCase.TestAddSingle;
begin
  nqt3 := nqt1 + FS1;
  qt3 := qt1 + FS1;
  AssertTrue('Quaternion + Single no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

procedure TQuaternionTestCase.TestSubQuaternion;
begin
  nqt3 := nqt1 - nqt2;
  qt3 := qt1 - qt2;
  AssertTrue('Quaternion - Quaternion no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

procedure TQuaternionTestCase.TestSubSingle;
begin
  nqt3 := nqt1 - FS1;
  qt3 := qt1 - FS1;
  AssertTrue('Quaternion - Single no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

procedure TQuaternionTestCase.TestMulQuaternion;
begin
  nqt3 := nqt1 * nqt2;
  qt3 := qt1 * qt2;
  AssertTrue('Quaternion * Quaternion no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

procedure TQuaternionTestCase.TestMulSingle;
begin
  nqt3 := nqt1 * FS1;
  qt3 := qt1 * FS1;
  AssertTrue('Quaternion * Single no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

procedure TQuaternionTestCase.TestDivSingle;
begin
  nqt3 := nqt1 / FS1;
  qt3 := qt1 / FS1;
  AssertTrue('Quaternion / Single no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

procedure TQuaternionTestCase.TestNegate;
begin
  nqt3 := -nqt1;
  qt3 := -qt1;
  AssertTrue('-Quaternion no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

procedure TQuaternionTestCase.TestConjugate;
begin
  nqt3 := nqt1.Conjugate;
  qt3 := qt1.Conjugate;
  AssertTrue('Quaternion.Conjugate no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

procedure TQuaternionTestCase.TestMagnitude;
begin
  Fs1 := nqt1.Magnitude;
  Fs2 := qt1.Magnitude;
  AssertTrue('Quaternion Magnitude do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TQuaternionTestCase.TestNormalize;
begin
  nqt3 := nqt1.Normalize;
  qt3 := qt1.Normalize;
  AssertTrue('Quaternion Normalize no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3,1e-2));
end;

procedure TQuaternionTestCase.TestMultiplyAsSecond;
begin
  nqt3 := nqt1.MultiplyAsSecond(nqt2);
  qt3 := qt1.MultiplyAsSecond(qt2);
  AssertTrue('Quaternion MultiplyAsSecond no match'+nqt3.ToString+' --> '+qt3.ToString, CompareQuaternion(nqt3,qt3));
end;

{%endregion%}

initialization
  RegisterTest(TQuaternionTestCase);
end.


