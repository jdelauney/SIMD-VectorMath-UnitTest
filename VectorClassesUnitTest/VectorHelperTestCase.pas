unit VectorHelperTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVectorHelperTestCase }

  TVectorHelperTestCase = class(TVectorBaseTestCase)
  protected
    procedure Setup; override;
  public
    {$CODEALIGN RECORDMIN=16}
    nph1, nph2,nph3 : TNativeGLZHmgPlane;
    nt4,nt5 : TNativeGLZVector;
    vt5 : TGLZVector;
    ph1,ph2,ph3     : TGLZHmgPlane;
    {$CODEALIGN RECORDMIN=4}
    alpha: single;
  published
    procedure TestRotate;
    procedure TestRotateAroundX;
    procedure TestRotateAroundY;
    procedure TestRotateAroundZ;
    procedure TestAverageNormal4;
    procedure TestPointProject;
    procedure TestIsColinear;
    procedure TestMoveAround;
    procedure TestShiftObjectFromCenter;
    procedure TestExtendClipRect;
    procedure TestStep;
    procedure TestFaceForward;
    procedure TestSaturate;
    procedure TestSmoothStep;

  end;

implementation

{ THmgPlaneHelperTestCase }

procedure TVectorHelperTestCase.Setup;
begin
  inherited Setup;
  nt3.Create(10.350,10.470,2.482,0.0);
  nt4.Create(20.350,18.470,8.482,0.0);
  nph1.Create(nt1,nt2,nt3);
  ph1.V := nph1.V;
  vt3.V := nt3.V;
  vt4.V := nt4.V;
  alpha := pi / 6;
end;

{%region%====[ THmgPlaneHelperTestCase ]========================================}


procedure TVectorHelperTestCase.TestRotate;
begin
  nt3 := nt1.Rotate(NativeYHmgVector,alpha);
  vt3 := vt1.Rotate(YHmgVector,alpha);
  AssertTrue('HmgPlaneHelper Rotate do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestRotateAroundX;
begin
  nt3 := nt1.RotateAroundX(alpha);
  vt3 := vt1.RotateAroundX(alpha);
  AssertTrue('HmgPlaneHelper Rotate Around X do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestRotateAroundY;
begin
  nt3 := nt1.RotateAroundY(alpha);
  vt3 := vt1.RotateAroundY(alpha);
  AssertTrue('HmgPlaneHelper Rotate Around Y do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestRotateAroundZ;
begin
  nt3 := nt1.RotateAroundZ(alpha);
  vt3 := vt1.RotateAroundZ(alpha);
  AssertTrue('HmgPlaneHelper Rotate Around Z do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestAverageNormal4;
begin
  nt5 := nt1.AverageNormal4(nt1,nt2,nt3,nt4);
  vt5 := vt1.AverageNormal4(vt1,vt2,vt3,vt4);
  AssertTrue('VectorHelper AverageNormal4 no match'+nt5.ToString+' --> '+vt5.ToString, Compare(nt5,vt5, 1e-5));
end;

procedure TVectorHelperTestCase.TestPointProject;
begin
  Fs1 := nt1.PointProject(nt2,nt3);
  Fs2 := vt1.PointProject(vt2,vt3);
  AssertTrue('VectorHelper PointProject do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorHelperTestCase.TestIsColinear;
begin
  nb := nt1.IsColinear(nt2);
  vb := vt1.IsColinear(vt2);
  AssertTrue('VectorHelper IsColinear does not match : ', (vb = nb));
end;

procedure TVectorHelperTestCase.TestMoveAround;
begin
  nt3 := nt1.MoveAround(NativeYHmgVector,nt2, alpha, alpha);
  vt3 := vt1.MoveAround(YHmgVector,vt2, alpha, alpha);
  AssertTrue('HmgPlaneHelper Move Z does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3,1e-5));
end;

procedure TVectorHelperTestCase.TestShiftObjectFromCenter;
begin
  nt3 := nt1.ShiftObjectFromCenter(nt2, Fs1, True);
  vt3 := vt1.ShiftObjectFromCenter(vt2, Fs1, True);
  AssertTrue('HmgPlaneHelper ShiftObjectFromCenter does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestExtendClipRect;
var
  nCr: TNativeGLZClipRect;
  aCr: TGLZClipRect;
begin
  nCr.V := nt1.V;
  aCr.V := vt1.V;
  nCr.ExtendClipRect(Fs1,Fs2);
  aCr.ExtendClipRect(Fs1,Fs2);
  AssertTrue('HmgPlaneHelper ExtendClipRect does not match : '+nCr.ToString+' --> '+nCr.ToString, Compare(nCr,aCr));
end;

procedure TVectorHelperTestCase.TestStep;
begin
  nt3 := nt1.Step(nt2);
  vt3 := vt1.Step(vt2);
  AssertTrue('VectorHelper Step does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestFaceForward;
begin
  //nt3 := nt1.Step(nt2);
  //vt3 := vt1.Step(vt2);
  //AssertTrue('VectorHelper Step does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestSaturate;
begin
  nt3 := nt1.Saturate;
  vt3 := vt1.Saturate;
  AssertTrue('VectorHelper Saturate does not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorHelperTestCase.TestSmoothStep;
begin

end;

{%endregion%}


initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVectorHelperTestCase);
end.

