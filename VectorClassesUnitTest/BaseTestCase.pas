unit BaseTestCase;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  native, GLZVectorMath;

type

  { TVectorNumericsTestCase }
  TVectorBaseTestCase = class(TTestCase)
    protected
      procedure Setup; override;
    public
     {$CODEALIGN RECORDMIN=16}
     vtt1,vtt2, vtt3 : TGLZVector2f;
     vt1,vt2, vt3 : TGLZVector4f;
     at1, at2, at3, at4, vorg: TGLZVector4f;
     ntt1,ntt2, ntt3 : TNativeGLZVector2f;
     nt1,nt2, nt3 : TNativeGLZVector4f;
     ant1,ant2, ant3, ant4, norg : TNativeGLZVector4f;
     {$CODEALIGN RECORDMIN=4}
     Fs1,Fs2 : Single;
     nb, vb: boolean;
    published
  end;

  TReportGroup = (rgVector2f, rgVector4f, rgMatrix4f, rgQuaterion);


const

  REPORT_GROUP_VECTOR2F = 'Vector2f';
  REPORT_GROUP_VECTOR4F = 'Vector4f';
  REPORT_GROUP_MATRIX4F = 'Matrix4f' ;
  REPORT_GROUP_QUATERION = 'Quaternion' ;

  rgArray: Array[TReportGroup] of string = (
              REPORT_GROUP_VECTOR2F,
              REPORT_GROUP_VECTOR4F,
              REPORT_GROUP_MATRIX4F,
              REPORT_GROUP_QUATERION
              );

implementation

procedure TVectorBaseTestCase.Setup;
begin
  vtt1.Create(5.850,4.525);
  vtt2.Create(1.558,6.512);
  ntt1.V := vtt1.V;
  ntt2.V := vtt2.V;

  vt1.Create(5.850,-15.480,8.512,1.5);
  vt2.Create(1.558,6.512,4.525,1.0);
  nt1.V := vt1.V;
  nt2.V := vt2.V;

  Fs1 := 1.5;
  Fs2 := 5.5;
end;

end.

