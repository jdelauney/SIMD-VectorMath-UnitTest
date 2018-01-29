unit QuaternionTestCase;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
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
    aqt1, aqt2, aqt3    : TGLZQuaternion;
    {$CODEALIGN RECORDMIN=4}
  published
    procedure TestCompare;
    procedure TestCompareFalse;
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

{ TQuaternionTestCase }

procedure TQuaternionTestCase.Setup;
begin
  inherited Setup;
  nqt1.Create(5.850,-15.480,8.512,1.5);
  nqt2.Create(1.558,6.512,4.525,1.0);
  aqt1.V := nqt1.V;
  aqt2.V := nqt2.V;
end;
                                              
{%region%====[ TQuaternionTestCase ]============================================}

procedure TQuaternionTestCase.TestCompare;
begin
  AssertTrue('Test Values do not match'+nqt1.ToString+' --> '+aqt1.ToString, Compare(nqt1,aqt1));
end;

procedure TQuaternionTestCase.TestCompareFalse;
begin
  AssertFalse('Test Values do not match'+nqt1.ToString+' --> '+aqt2.ToString, Compare(nqt1,aqt2));
end;


procedure TQuaternionTestCase.TestCreateSingles;
begin
  nqt3.Create(1,2,3,4);
  aqt3.Create(1,2,3,4);
  AssertTrue('Quaternion.CreateSingles no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3));
end;

procedure TQuaternionTestCase.TestCreateImagArrayWithReal;
begin
  nqt3.Create(3.0,nt1.AsVector3f);
  aqt3.Create(3.0,vt1.AsVector3f);
  AssertTrue('Quaternion.CreateImagArrayWithReal no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3,1e-8));
end;

procedure TQuaternionTestCase.TestCreateTwoUnitAffine;
begin
  nqt3.Create(nt1.AsVector3f,nt2.AsVector3f);
  aqt3.Create(vt1.AsVector3f,vt2.AsVector3f);
  AssertTrue('Quaternion.CreateTwoUnitAffine no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3,1e-6));
end;

procedure TQuaternionTestCase.TestCreateTwoUnitHmg;
begin
  nqt3.Create(nt1,nt2);
  aqt3.Create(vt1,vt2);
  AssertTrue('Quaternion.CreateTwoUnitHmg no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3,1e-6));
end;

procedure TQuaternionTestCase.TestCreateAngleAxis;
begin
  nqt3.Create(90, NativeZVector);
  aqt3.Create(90, ZVector);
  AssertTrue('Quaternion.CreateAngleAxis no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3));
end;

procedure TQuaternionTestCase.TestCreateEuler;
begin
  nqt3.Create(90, 0, 0);
  aqt3.Create(90, 0, 0);
  AssertTrue('Quaternion.CreateEuler no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3));
end;

procedure TQuaternionTestCase.TestCreateEulerOrder;
begin
  nqt3.Create(90, 45, -30, eulZXY);
  aqt3.Create(90, 45, -30, eulZXY);
  AssertTrue('Quaternion.CreateEulerOrder no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3));
end;

procedure TQuaternionTestCase.TestMulQuaternion;
begin
  nqt3 := nqt1 * nqt2;
  aqt3 := aqt1 * aqt2;
  AssertTrue('Quaternion * Quaternion no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3));
end;

procedure TQuaternionTestCase.TestConjugate;
begin
  nqt3 := nqt1.Conjugate;
  aqt3 := aqt1.Conjugate;
  AssertTrue('Quaternion.Conjugate no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3));
end;

procedure TQuaternionTestCase.TestOpEquals;
begin
  nb := nqt1 = nqt1;
  ab := aqt1 = aqt1;
  AssertTrue('Quaternion = does not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

procedure TQuaternionTestCase.TestOpNotEquals;
begin
  nb := nqt1 <> nqt1;
  ab := aqt1 <> aqt1;
  AssertTrue('Quaternion <> does not match '+nb.ToString+' --> '+ab.ToString, (nb = ab));
end;

procedure TQuaternionTestCase.TestMagnitude;
begin
  Fs1 := nqt1.Magnitude;
  Fs2 := aqt1.Magnitude;
  AssertTrue('Quaternion Magnitude do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TQuaternionTestCase.TestNormalize;
begin
  nqt1.Normalize;
  aqt1.Normalize;
  AssertTrue('Quaternion Normalize no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt1,aqt1,1e-2));
end;

procedure TQuaternionTestCase.TestMultiplyAsSecond;
begin
  nqt3 := nqt1.MultiplyAsSecond(nqt2);
  aqt3 := aqt1.MultiplyAsSecond(aqt2);
  AssertTrue('Quaternion MultiplyAsSecond no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3));
end;

procedure TQuaternionTestCase.TestSlerpSingle;
begin
  nqt2.Create(90,NativeZVector);
  aqt2.Create(90,ZVector);
  nqt3 := NativeIdentityQuaternion.Slerp(nqt1,0.5);
  aqt3 := IdentityQuaternion.Slerp(aqt1,0.5);
  AssertTrue('Quaternion SlerpSingle no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3,1e-6));
end;

procedure TQuaternionTestCase.TestSlerpSpin;
begin
  nqt1.Create(90,NativeZVector);
  aqt1.Create(90,ZVector);
  nqt3 := NativeIdentityQuaternion.Slerp(nqt1,3,0.5);
  aqt3 := IdentityQuaternion.Slerp(aqt1,3,0.5);
  AssertTrue('Quaternion SlerpSpin no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3,1e-6));
end;

procedure TQuaternionTestCase.TestConvertToMatrix;
var
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
begin
  nqt1.Create(90,NativeZVector);
  aqt1.Create(90,ZVector);
  nMat := nqt1.ConvertToMatrix;
  aMat := aqt1.ConvertToMatrix;
  AssertTrue('Quaternion ConvertToMatrix no match'+nmat.ToString+' --> '+amat.ToString, CompareMatrix(nMat,aMat));
end;

procedure TQuaternionTestCase.TestCreateMatrix;
var
  nMat: TNativeGLZMatrix;
  aMat: TGLZMatrix;
begin
  nMat.V[0].Create( 0.6479819,  0.7454178, -0.1564345, 0);
  nMat.V[1].Create( 0.7312050, -0.5513194,  0.4017290, 0);
  nMat.V[2].Create( 0.2132106, -0.3746988, -0.9022982, 0);
  nMat.V[3].Create(0,0,0,1);
  aMat.V[0].Create( 0.6479819,  0.7454178, -0.1564345, 0);
  aMat.V[1].Create( 0.7312050, -0.5513194,  0.4017290, 0);
  aMat.V[2].Create( 0.2132106, -0.3746988, -0.9022982, 0);
  aMat.V[3].Create(0,0,0,1);
  nqt3.Create(nMat);
  aqt3.Create(aMat);
  AssertTrue('Quaternion CreateMatrix no match'+nqt3.ToString+' --> '+aqt3.ToString, Compare(nqt3,aqt3));
end;

procedure TQuaternionTestCase.TestTransform;
begin
  nqt1.Create(90,NativeZVector);
  aqt1.Create(90,ZVector);
  nt3 := nqt1.Transform(nt1);
  vt3 := aqt1.Transform(vt1);
  AssertTrue('Quaternion Transform no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TQuaternionTestCase.TestScale;
begin
  nqt1.Create(90,NativeZVector); // create a normalised postive rotation in Z
  aqt1.Create(90,ZVector); // create a normalised postive rotation in Z
  nqt1.Scale(2);
  aqt1.Scale(2);
  nt3 := nqt1.Transform(nt1);
  vt3 := aqt1.Transform(vt1);
end;

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_QUATERION, TQuaternionTestCase);
end.


