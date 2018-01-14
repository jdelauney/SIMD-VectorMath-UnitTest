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
  TBaseTestCase = class(TTestCase)
  //  protected
     // procedure Setup; override;
    public
     Fs1,Fs2 : Single;
     nb, vb, ab: boolean;
  end;


  TVectorBaseTestCase = class(TBaseTestCase)
  protected
    procedure Setup; override;
    public
     {$CODEALIGN RECORDMIN=16}
     vtt1,vtt2, vtt3, vtt4: TGLZVector2f;
     vt1,vt2, vt3 : TGLZVector4f;
     at1, at2, at3, at4, vorg: TGLZVector4f;
     ntt1,ntt2, ntt3 : TNativeGLZVector2f;
     vt2i  : TGLZVector2i;
     vt4i  : TGLZVector4i;
     nt2i  : TNativeGLZVector2i;
     nt4i  : TNativeGLZVector4i;
     nt1,nt2, nt3 : TNativeGLZVector4f;
     ant1,ant2, ant3, ant4, norg : TNativeGLZVector4f;
     {$CODEALIGN RECORDMIN=4}
    published
  end;

  { TByteVectorBaseTestCase }

  TByteVectorBaseTestCase = class(TBaseTestCase)
    protected
      procedure Setup; override;
    public
     {$CODEALIGN RECORDMIN=4}
     nbt1, nbt2, nbt3, nbt4: TNativeGLZVector3b;
     nbf1, nbf2, nbf3, nbf4: TNativeGLZVector4b;
     abt1, abt2, abt3, abt4: TGLZVector3b;
     abf1, abf2, abf3, abf4: TGLZVector4b;
     {$CODEALIGN RECORDMIN=1}
     b1, b2, b3, b4, b5, b6, b7, b8: byte;
     {$CODEALIGN RECORDMIN=4}

  end;

  { TIntVectorBaseTestCase }

  TIntVectorBaseTestCase = class(TBaseTestCase)
    protected
      procedure Setup; override;
    public
     {$CODEALIGN RECORDMIN=16}
     n3it1, n3it2, n3it3, n3it4: TNativeGLZVector3i;
     n4it1, n4it2, n4it3, n4it4: TNativeGLZVector4i;
     a3it1, a3it2, a3it3, a3it4: TGLZVector3i;
     a4it1, a4it2, a4it3, a4it4: TGLZVector4i;
     {$CODEALIGN RECORDMIN=4}
     b1, b2, b3, b4, b5, b6, b7, b8: integer;
  end;

  { TBBoxBaseTestCase }

  TBBoxBaseTestCase = class(TVectorBaseTestCase)
    protected
      procedure Setup; override;
    public
     {$CODEALIGN RECORDMIN=16}
      nbb1,nbb2,nbb3: TNativeGLZBoundingBox;
      abb1,abb2,abb3: TGLZBoundingBox;
      nbs1,nbs2,nbs3: TNativeGLZBoundingSphere;
      abs1,abs2,abs3: TGLZBoundingSphere;
      naabb1,naabb2,naabb3: TNativeGLZAxisAlignedBoundingBox;
      aaabb1,aaabb2,aaabb3: TGLZAxisAlignedBoundingBox;
      {$CODEALIGN RECORDMIN=4}
  end;


  TReportGroup = (rgVector2f, rgVector3b, rgVector4b, rgVector4i, rgVector4f, rgMatrix4f,
                  rgQuaterion, rgBBox, rgBSphere, rgAABB, rgPlaneHelper);

const

  REPORT_GROUP_VECTOR2F = 'Vector2f';
  REPORT_GROUP_VECTOR3B = 'Vector3b';
  REPORT_GROUP_VECTOR4B = 'Vector4b';
  REPORT_GROUP_VECTOR4I = 'Vector4i';
  REPORT_GROUP_VECTOR4F = 'Vector4f';
  REPORT_GROUP_MATRIX4F = 'Matrix4f' ;
  REPORT_GROUP_QUATERION = 'Quaternion' ;
  REPORT_GROUP_BBOX = 'BoundingBox' ;
  REPORT_GROUP_BSPHERE = 'BoundingSphere';
  REPORT_GROUP_AABB = 'AABoundingBox';
  REPORT_GROUP_PLANE_HELP = 'HmgPlane';

  rgArray: Array[TReportGroup] of string = (
              REPORT_GROUP_VECTOR2F,
              REPORT_GROUP_VECTOR3B,
              REPORT_GROUP_VECTOR4B,
              REPORT_GROUP_VECTOR4I,
              REPORT_GROUP_VECTOR4F,
              REPORT_GROUP_MATRIX4F,
              REPORT_GROUP_QUATERION,
              REPORT_GROUP_BBOX,
              REPORT_GROUP_BSPHERE,
              REPORT_GROUP_AABB,
              REPORT_GROUP_PLANE_HELP
              );

implementation

{ TIntVectorBaseTestCase }

procedure TIntVectorBaseTestCase.Setup;
begin
  inherited Setup;
//  n3it1.Create(12, 124, 253);  in advance of the code appearing
//  n3it2.Create(253, 124, 12);
//  a3it1.V := n3it1.V;
//  a3it2.V := n3it2.V;
  n4it1.Create(12, 124, 253, 0);
  n4it2.Create(253, 124, 12, 255);
  a4it1.V := n4it1.V;
  a4it2.V := n4it2.V;
  b1 := 3;    // three small
  b2 := 4;
  b3 := 5;
  b4 := 10;
  b5 := 2345;  // three large
  b6 := 2248;
  b7 := 2255;
  b8 := 10;
  Fs1 := 1.5;
  Fs2 := 5.5;
end;

{ TBBoxBaseTestCase }

procedure TBBoxBaseTestCase.Setup;
begin
  inherited Setup;
  nbb1.Create(nt1);
  abb1.Create(vt1);
  nbb2.Create(nt2);
  abb2.Create(vt2);
  nbs1.Create(nt1, 1.356);
  abs1.Create(vt1, 1.356);
  nbs2.Create(nt2, 8.435);
  abs2.Create(vt2, 8.435);
  naabb1.Create(nbs1);
  aaabb1.Create(abs1);
  naabb2.Create(nbs2);
  aaabb2.Create(abs2);
end;



procedure TByteVectorBaseTestCase.Setup;
begin
  inherited Setup;
  nbt1.Create(12, 124, 253);
  nbt2.Create(253, 124, 12);
  abt1.V := nbt1.V;
  abt2.V := nbt2.V;
  nbf1.Create(12, 124, 253, 0);
  nbf2.Create(253, 124, 12, 255);
  abf1.V := nbf1.V;
  abf2.V := nbf2.V;
  b1 := 3;    // three small bytes
  b2 := 4;
  b3 := 5;    // b4 can be used as a result
  b5 := 245;  // three large bytes
  b6 := 248;
  b7 := 255;  //b8 can be used as a result.

end;

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

