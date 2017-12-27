(*====< GLZVectorMath.pas >=====================================================@br
@created(2017-11-25)
@author(J.Delauney (BeanzMaster) - Peter (Dicepd)
Historique : @br
@unorderedList(
  @item(25/11/2017 : Creation  )
)
--------------------------------------------------------------------------------@br
  ------------------------------------------------------------------------------
  Description :
  L'unité GLZVectorMath regroupe des fonctions mathematiques, optimisées en assembleur
  SSE/SSE2/SSE3/SSE4 et AVX pour les vecteurs, matrices, quaternion et autres fonctions
  utiles en 3D
  ------------------------------------------------------------------------------
  @bold(Notes :)

  Quelques liens :
   @unorderedList(
       @item(http://forum.lazarus.freepascal.org/index.php/topic,32741.0.html)
       @item()
       @MatLab
       @WolFram
     )
  ------------------------------------------------------------------------------@br

  @bold(Credits :)
    @unorderedList(
      @item(FPC/Lazarus)
    )

  ------------------------------------------------------------------------------@br
  LICENCE : GPL/MPL
  @br
  ------------------------------------------------------------------------------
*==============================================================================*)
Unit GLZVectorMath;

{.$i glzscene_options.inc}

{$mode objfpc}{$H+}

//-----------------------------
{$ASMMODE INTEL}
{$COPERATORS ON}
{$INLINE ON}

{$MODESWITCH ADVANCEDRECORDS}

//-----------------------

// ALIGNEMENT
{$ALIGN 16}

{$CODEALIGN CONSTMIN=16}
{$CODEALIGN VARMIN=16}

// with Those the performance decrease a little with SSE but increase a little with AVX
// Depend of the compiler options with AVX<x> speed is increase with SSE<x> speed decrease
{.$CODEALIGN LOCALMIN=16}
{.$CODEALIGN RECORDMIN=4}

// Those options are set in compiler options with the -d command
{.$DEFINE USE_ASM} // use SIMD SSE/SSE2 by default
{.$DEFINE USE_ASM_AVX}
{.$DEFINE USE_ASM_SSE_4}
{.$DEFINE USE_ASM_SSE_3}

// Some function don't have SSE4 instruction, so enable SSE3
{$IFDEF USE_ASM_SSE_4}
  {$DEFINE USE_ASM_SSE_3}
{$ENDIF}
// In case of
{$IFDEF USE_ASM_SSE_3}
  {$DEFINE USE_ASM}
{$ENDIF}

{$IFDEF USE_ASM_AVX}
  {$DEFINE USE_ASM}
{$ENDIF}

{$DEFINE USE_ASM_SIMD_HIGHPRECISION}

//-----------------------

Interface

Uses
  Classes, Sysutils;

{%region%----[ SSE States Flags Const ]-----------------------------------------}
Type
  sse_Rounding_Mode = (rmNearest, rmFloor, rmCeil, rmDefault);

Const
  //mxcsr register bits
  sse_FlagInvalidOp = %0000000000000001;
  sse_FlagDenorm    = %0000000000000010;
  sse_FlagDivZero   = %0000000000000100;
  sse_FlagOverflow  = %0000000000001000;
  sse_FlagUnderflow = %0000000000010000;
  sse_FlagPrecision = %0000000000100000;
  sse_FlagDenormZero= %0000000001000000;
  sse_MaskInvalidOp = %0000000010000000;
  sse_MaskDenorm    = %0000000100000000;
  sse_MaskDivZero   = %0000001000000000;
  sse_MaskOverflow  = %0000010000000000;
  sse_MaskUnderflow = %0000100000000000;
  sse_MaskPrecision = %0001000000000000;
  sse_MaskNegRound  = %0010000000000000;
  sse_MaskPosRound  = %0100000000000000;
  sse_MaskZeroFlush = %1000000000000000;
  //mask for removing old rounding bits to set new bits
  sse_no_round_bits_mask= $ffffffff-sse_MaskNegRound-sse_MaskPosRound;
  //default value of the mxcsr after booting the PC
  mxcsr_default : dword =sse_MaskInvalidOp or sse_MaskDenorm  or sse_MaskDivZero or sse_MaskOverflow or sse_MaskUnderflow or sse_MaskPrecision;// default setting of the mxscr register ; disable all exception's
  //conversion table from rounding mode name to rounding bits
  sse_Rounding_Flags: array [sse_Rounding_Mode] of longint = (0,sse_MaskNegRound,sse_MaskPosRound,0);

  sse_align=16;
  sse_align_mask=sse_align-1;

{%endregion%}

{%region%----[ Vectors ]--------------------------------------------------------}

type
  TGLZVector2fType = packed array[0..1] of Single;
  TGLZVector3fType = packed array[0..2] of Single;
  TGLZVector4fType = packed array[0..3] of Single;
  TGLZVector4iType = packed array[0..3] of Longint;

  TGLZVector4i =  record
    case Integer of
      0 : (V: TGLZVector4iType);
      1 : (X,Y,Z,W: longint);
  end;

  TGLZVector2f =  record
    procedure Create(aX,aY: single);

    function ToString : String;

    class operator +(constref A, B: TGLZVector2f): TGLZVector2f; overload;
    class operator -(constref A, B: TGLZVector2f): TGLZVector2f; overload;
    class operator *(constref A, B: TGLZVector2f): TGLZVector2f; overload;
    class operator /(constref A, B: TGLZVector2f): TGLZVector2f; overload;

    class operator +(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;
    class operator -(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;
    class operator *(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;
    class operator /(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;

    class operator -(constref A: TGLZVector2f): TGLZVector2f; overload;

    class operator =(constref A, B: TGLZVector2f): Boolean;
    (*class operator >=(constref A, B: TGLZVector2f): Boolean;
    class operator <=(constref A, B: TGLZVector2f): Boolean;
    class operator >(constref A, B: TGLZVector2f): Boolean;
    class operator <(constref A, B: TGLZVector2f): Boolean;*)
    class operator <>(constref A, B: TGLZVector2f): Boolean;

    function Min(constref B: TGLZVector2f): TGLZVector2f; overload;
    function Min(constref B: Single): TGLZVector2f; overload;
    function Max(constref B: TGLZVector2f): TGLZVector2f; overload;
    function Max(constref B: Single): TGLZVector2f; overload;

    function Clamp(constref AMin, AMax: TGLZVector2f): TGLZVector2f;overload;
    function Clamp(constref AMin, AMax: Single): TGLZVector2f;overload;
    function MulAdd(constref A,B:TGLZVector2f): TGLZVector2f;
    function MulDiv(constref A,B:TGLZVector2f): TGLZVector2f;
    function Length:Single;
    function LengthSquare:Single;
    function Distance(constref A:TGLZVector2f):Single;
    function DistanceSquare(constref A:TGLZVector2f):Single;
    function Normalize : TGLZVector2f;
    // function DotProduct(A:TVector2f):TVector2f;
    // function Reflect(I, NRef : TVector2f):TVector2f
    //function Round: TVector2I;
    //function Trunc: TVector2I;


    case Byte of
      0: (V: TGLZVector2fType);
      1: (X, Y : Single);
  End;

  TGLZVector3f =  record
    case Byte of
      0: (V: TGLZVector3fType);
      1: (X, Y, Z: Single);
  End;
  TGLZAffineVector = TGLZVector3f;
  PGLZAffineVector = ^TGLZAffineVector;

  //=====[ Vectors Functions ]===========================================
  TGLZVector4f =  record  // With packed record the performance decrease a little
  public
    procedure Create(Const aX,aY,aZ: single; const aW : Single = 0); overload;
    procedure Create(Const anAffineVector: TGLZVector3f; const aW : Single = 0); overload;

    function ToString : String;

    class operator +(constref A, B: TGLZVector4f): TGLZVector4f; overload;
    class operator -(constref A, B: TGLZVector4f): TGLZVector4f; overload;
    class operator *(constref A, B: TGLZVector4f): TGLZVector4f; overload;
    class operator /(constref A, B: TGLZVector4f): TGLZVector4f; overload;

    class operator +(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;
    class operator -(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;
    class operator *(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;
    class operator /(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;

    class operator -(constref A: TGLZVector4f): TGLZVector4f; overload;

    class operator =(constref A, B: TGLZVector4f): Boolean;
    class operator >=(constref A, B: TGLZVector4f): Boolean;
    class operator <=(constref A, B: TGLZVector4f): Boolean;
    class operator >(constref A, B: TGLZVector4f): Boolean;
    class operator <(constref A, B: TGLZVector4f): Boolean;
    class operator <>(constref A, B: TGLZVector4f): Boolean;

    function Shuffle(const x,y,z,w : Byte):TGLZVector4f;
    function MinXYZComponent : Single;
    function MaxXYZComponent : Single;

    function Abs:TGLZVector4f;overload;
    function Negate:TGLZVector4f;
    function DivideBy2:TGLZVector4f;
    function Distance(constref A: TGLZVector4f):Single;
    function Length:Single;
    function DistanceSquare(constref A: TGLZVector4f):Single;
    function LengthSquare:Single;
    function spacing(constref A: TGLZVector4f):Single;
    function DotProduct(constref A: TGLZVector4f):Single;
    function CrossProduct(constref A: TGLZVector4f): TGLZVector4f;
    function Normalize: TGLZVector4f;
    function Norm:Single;
    function Min(constref B: TGLZVector4f): TGLZVector4f; overload;
    function Min(constref B: Single): TGLZVector4f; overload;
    function Max(constref B: TGLZVector4f): TGLZVector4f; overload;
    function Max(constref B: Single): TGLZVector4f; overload;
    function Clamp(Constref AMin, AMax: TGLZVector4f): TGLZVector4f; overload;
    function Clamp(constref AMin, AMax: Single): TGLZVector4f; overload;
    function MulAdd(Constref B, C: TGLZVector4f): TGLZVector4f;
    function MulDiv(Constref B, C: TGLZVector4f): TGLZVector4f;


    function Lerp(Constref B: TGLZVector4f; Constref T:Single): TGLZVector4f;
    function AngleCosine(constref A : TGLZVector4f): Single;
    {.$ifndef USE_ASM_AVX}
    function AngleBetween(Constref A, ACenterPoint : TGLZVector4f): Single;
    {.$endif}
    function Combine(constref V2: TGLZVector4f; constref F1: Single): TGLZVector4f;
    function Combine2(constref V2: TGLZVector4f; const F1, F2: Single): TGLZVector4f;
    function Combine3(constref V2, V3: TGLZVector4f; const F1, F2, F3: Single): TGLZVector4f;

    function Perpendicular(constref N : TGLZVector4f) : TGLZVector4f;

    function Reflect(constref N: TGLZVector4f): TGLZVector4f;

 //   function MoveAround(constRef AMovingUp, ATargetPosition: TGLZVector4f; pitchDelta, turnDelta: Single): TGLZVector4f;

    procedure pAdd(constref A: TGLZVector4f);overload;
    procedure pSub(constref A: TGLZVector4f);overload;
    procedure pMul(constref A: TGLZVector4f);overload;
    procedure pDiv(constref A: TGLZVector4f);overload;
    procedure pAdd(constref A: Single);overload;
    procedure pSub(constref A: Single);overload;
    procedure pMul(constref A: Single);overload;
    procedure pDiv(constref A: Single);overload;
    procedure pInvert;
    procedure pNegate;
    procedure pAbs;
    procedure pDivideBy2;
    procedure pCrossProduct(constref A: TGLZVector4f);
    procedure pNormalize;
    procedure pMin(constref B: TGLZVector4f); overload;
    procedure pMin(constref B: Single);overload;
    procedure pMax(constref B: TGLZVector4f); overload;
    procedure pMax(constref B: Single); overload;
    procedure pClamp(Constref AMin, AMax: TGLZVector4f); overload;
    procedure pClamp(constref AMin, AMax: Single); overload;
    procedure pMulAdd(Constref B, C: TGLZVector4f); // (Self*B)+c
    procedure pMulDiv(Constref B, C: TGLZVector4f); // (Self*B)-c
    //procedure Lerp(Constref B: TGLZVector4f; Constref T:Single): TGLZVector4f;

    case Byte of
      0: (V: TGLZVector4fType);
      1: (X, Y, Z, W: Single);
      2: (AsVector3f : TGLZVector3f);
  end;

  TGLZVector = TGLZVector4f;
  PGLZVector = ^TGLZVector;
  PGLZVectorArray = ^TGLZVectorArray;
  TGLZVectorArray = array[0..MAXINT shr 5] of TGLZVector4f;

  //procedure VectorArrayAdd(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
  //procedure VectorArraySub(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
  //procedure VectorArrayMul(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
  //procedure VectorArrayDiv(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
//  procedure VectorArrayLerp(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
//  procedure VectorArrayNormalize(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);

{%endregion%}

{%region%----[ Matrix ]---------------------------------------------------------}
  { A plane equation.
   Defined by its equation A.x+B.y+C.z+D, a plane can be mapped to the
   homogeneous space coordinates, and this is what we are doing here.
   The typename is just here for easing up data manipulation. }
   TGLZHmgPlane = TGLZVector;
   TGLZFrustum = packed record
      pLeft, pTop, pRight, pBottom, pNear, pFar : TGLZHmgPlane;
   end;

  TGLZMatrixTransType = (ttScaleX, ttScaleY, ttScaleZ,
                ttShearXY, ttShearXZ, ttShearYZ,
                ttRotateX, ttRotateY, ttRotateZ,
                ttTranslateX, ttTranslateY, ttTranslateZ,
                ttPerspectiveX, ttPerspectiveY, ttPerspectiveZ, ttPerspectiveW);

  // used to describe a sequence of transformations in following order:
  // [Sx][Sy][Sz][ShearXY][ShearXZ][ShearZY][Rx][Ry][Rz][Tx][Ty][Tz][P(x,y,z,w)]
  // constants are declared for easier access (see MatrixDecompose below)
  TGLZMatrixTransformations  = array [TGLZMAtrixTransType] of Single;


  //=====[ Matrix Functions ]===================================================
  TGLZMatrix4 = record
  private
    function GetComponent(const ARow, AColumn: Integer): Single; inline;
    procedure SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
    function GetRow(const AIndex: Integer): TGLZVector; inline;
    procedure SetRow(const AIndex: Integer; const Value: TGLZVector); inline;

    function GetDeterminant: Single;

    function MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
    procedure Transpose_Scale_M33(constref src : TGLZMatrix4; Constref ascale : Single);
  public
    class operator +(constref A, B: TGLZMatrix4): TGLZMatrix4; overload;
    class operator +(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; overload;
    class operator -(constref A, B: TGLZMatrix4): TGLZMatrix4; overload;
    class operator -(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; overload;
    class operator *(constref A, B: TGLZMatrix4): TGLZMatrix4; overload;
    class operator *(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; overload;
    class operator *(constref A: TGLZMatrix4; constref B: TGLZVector): TGLZVector; overload;
    class operator /(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; overload;

    class operator -(constref A: TGLZMatrix4): TGLZMatrix4; overload;

    //class operator =(constref A, B: TGLZMatrix4): Boolean;overload;
    //class operator <>(constref A, B: TGLZMatrix4): Boolean;overload;

    procedure CreateIdentityMatrix;
    // Creates scale matrix
    procedure CreateScaleMatrix(const v : TGLZAffineVector); overload;
    // Creates scale matrix
    procedure CreateScaleMatrix(const v : TGLZVector); overload;
    // Creates translation matrix
    procedure CreateTranslationMatrix(const V : TGLZAffineVector); overload;
    // Creates translation matrix
    procedure CreateTranslationMatrix(const V : TGLZVector); overload;
    { Creates a scale+translation matrix.
       Scale is applied BEFORE applying offset }
    procedure CreateScaleAndTranslationMatrix(const ascale, offset : TGLZVector); overload;
    // Creates matrix for rotation about x-axis (angle in rad)
    procedure CreateRotationMatrixX(const sine, cosine: Single); overload;
    procedure CreateRotationMatrixX(const angle: Single); overload;
    // Creates matrix for rotation about y-axis (angle in rad)
    procedure CreateRotationMatrixY(const sine, cosine: Single); overload;
    procedure CreateRotationMatrixY(const angle: Single); overload;
    // Creates matrix for rotation about z-axis (angle in rad)
    procedure CreateRotationMatrixZ(const sine, cosine: Single); overload;
    procedure CreateRotationMatrixZ(const angle: Single); overload;
    // Creates a rotation matrix along the given Axis by the given Angle in radians.
    procedure CreateRotationMatrix(const anAxis : TGLZAffineVector; angle : Single); overload;
    procedure CreateRotationMatrix(const anAxis : TGLZVector; angle : Single); overload;

    procedure CreateLookAtMatrix(const eye, center, normUp: TGLZVector);
    procedure CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);
    procedure CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);
    procedure CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);
    procedure CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i);

    { Creates a parallel projection matrix.
       Transformed points will projected on the plane along the specified direction. }
    procedure CreateParallelProjectionMatrix(const plane : TGLZHmgPlane; const dir : TGLZVector);

    { Creates a shadow projection matrix.
       Shadows will be projected onto the plane defined by planePoint and planeNormal,
       from lightPos. }
    procedure CreateShadowMatrix(const planePoint, planeNormal, lightPos : TGLZVector);

    { Builds a reflection matrix for the given plane.
       Reflection matrix allow implementing planar reflectors in OpenGL (mirrors). }
    procedure CreateReflectionMatrix(const planePoint, planeNormal : TGLZVector);

    function ToString : String;

    function Transpose: TGLZMatrix4;
    //procedure Transpose;
    function Invert : TGLZMatrix4;
    //procedure Invert;
    function Normalize : TGLZMatrix4;
    //procedure Normalize;
    procedure Adjoint;
    procedure AnglePreservingMatrixInvert(constref mat : TGLZMatrix4);

    function Decompose(var Tran: TGLZMatrixTransformations): Boolean;

    function Translate( constref v : TGLZVector):TGLZMatrix4;
    function Multiply(constref M2: TGLZMatrix4):TGLZMatrix4;  //Component-wise multiplication

    //function Lerp(constref m2: TGLZMatrix4; const Delta: Single): TGLZMatrix4;

    property Rows[const AIndex: Integer]: TGLZVector read GetRow write SetRow;
    property Components[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;
    property Determinant: Single read GetDeterminant;

    case Byte of
    { The elements of the matrix in row-major order }
      0: (M: array [0..3, 0..3] of Single);
      1: (V: array [0..3] of TGLZVector);
      2: (VX : Array[0..1] of array[0..7] of Single); //AVX Access
      3: (X,Y,Z,W : TGLZVector);
      4: (m11, m12, m13, m14: Single;
          m21, m22, m23, m24: Single;
          m31, m32, m33, m34: Single;
          m41, m42, m43, m44: Single);
  End;

  TGLZMatrix = TGLZMatrix4;
  PGLZMatrix = ^TGLZMatrix;
  TGLZMatrixArray = array [0..MaxInt shr 7] of TGLZMatrix;
  PGLZMatrixArray = ^TGLZMatrixArray;

{%endregion%}

{%region%----[ Quaternion ]-----------------------------------------------------}

  //=====[ Quaternion Functions ]===============================================
  TGLZEulerOrder = (eulXYZ, eulXZY, eulYXZ, eulYZX, eulZXY, eulZYX);
  TGLZQuaternion = record
  private
  public
    class operator +(constref A, B: TGLZQuaternion): TGLZQuaternion; overload;
    class operator -(constref A, B: TGLZQuaternion): TGLZQuaternion; overload;
    class operator -(constref A: TGLZQuaternion): TGLZQuaternion; overload;
    { Returns quaternion product qL * qR.
       Note: order is important!
       To combine rotations, use the product Muliply(qSecond, qFirst),
       which gives the effect of rotating by qFirst then qSecond.
    }
    class operator *(constref A, B: TGLZQuaternion): TGLZQuaternion;  overload;
    //class operator /(constref A, B: TGLZQuaternion): TGLZQuaternion;overload;

    class operator +(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; overload;
    class operator -(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; overload;
    class operator *(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; overload;
    class operator /(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; overload;

    class operator =(constref A, B: TGLZQuaternion): Boolean;
    class operator <>(constref A, B: TGLZQuaternion): Boolean;

    function ToString : String;

    procedure Create(x,y,z: Single; Real : Single);overload;
    // Creates a quaternion from the given values
    procedure Create(const Imag: array of Single; Real : Single); overload;

    // Constructs a unit quaternion from two points on unit sphere
    procedure Create(const V1, V2: TGLZAffineVector); overload;
    //procedure Create(const V1, V2: TGLZVector); overload;

    // Constructs a unit quaternion from a rotation matrix
    //procedure Create(const mat : TGLZMatrix); overload;

    // Constructs quaternion from angle (in deg) and axis
    procedure Create(const angle  : Single; const axis : TGLZAffineVector); overload;
    //procedure Create(const angle  : Single; const axis : TGLZVector); overload;

    // Constructs quaternion from Euler angles
    procedure Create(const r, p, y : Single); overload;

    // Constructs quaternion from Euler angles in arbitrary order (angles in degrees)
    procedure Create(const x, y, z: Single; eulerOrder : TGLZEulerOrder); overload;

    // Converts a unit quaternion into two points on a unit sphere
    procedure ConvertToPoints(var ArcFrom, ArcTo: TGLZAffineVector); //overload;
    //procedure ConvertToPoints(var ArcFrom, ArcTo: TGLZVector); //overload;

    { Constructs a rotation matrix from (possibly non-unit) quaternion.
       Assumes matrix is used to multiply column vector on the left:
       vnew = mat vold.
       Works correctly for right-handed coordinate system and right-handed rotations. }
    //function ConvertToMatrix : TGLZMatrix;

    { Constructs an affine rotation matrix from (possibly non-unit) quaternion. }
    //function ConvertToAffineMatrix : TGLZAffineMatrix;

    // Returns the conjugate of a quaternion
    function Conjugate : TGLZQuaternion;
    //procedure pConjugate;

    // Returns the magnitude of the quaternion
    function Magnitude : Single;

    // Normalizes the given quaternion
    function Normalize : TGLZQuaternion;
    //procedure pNormalize;

    { Returns quaternion product qL * qR.
       Note: order is important!
       To combine rotations, use the product Muliply(qSecond, qFirst),
       which gives the effect of rotating by qFirst then qSecond.
      }
    //function MultiplyAsFirst(const qSecond : TGLZQuaternion): TGLZQuaternion;
    function MultiplyAsSecond(const qFirst : TGLZQuaternion): TGLZQuaternion;

    { Spherical linear interpolation of unit quaternions with spins.
       QStart, QEnd - start and end unit quaternions
       t            - interpolation parameter (0 to 1)
       Spin         - number of extra spin rotations to involve  }
    function Slerp(const QEnd: TGLZQuaternion; Spin: Integer; t: Single): TGLZQuaternion; overload;
    function Slerp(const QEnd: TGLZQuaternion; const t : Single) : TGLZQuaternion; overload;

    case Byte of
      0: (V: TGLZVector4fType);
      1: (X, Y, Z, W: Single);
      2: (AsVector4f : TGLZVector4f);
      3: (ImagePart : TGLZVector3f; RealPart : Single);
  End;
  PGLZQuaternionArray = ^TGLZQuaternionArray;
  TGLZQuaternionArray = array[0..MAXINT shr 5] of TGLZQuaternion;

{%endregion%}

{%region%----[ TGLZVectorHelper ]-----------------------------------------------}

  TGLZVectorHelper = record helper for TGLZVector
  public
    procedure CreatePlane(constref p1, p2, p3 : TGLZVector);overload;
    // Computes the parameters of a plane defined by a point and a normal.
    procedure CreatePlane(constref point, normal : TGLZVector); overload;

    //function Normalize : TGLZHmgPlane; overload;
    function NormalizePlane : TGLZHmgPlane;

    procedure CalcPlaneNormal(constref p1, p2, p3 : TGLZVector);

    //function PointIsInHalfSpace(constref point: TGLZVector) : Boolean;
    //function PlaneEvaluatePoint(constref point : TGLZVector) : Single;
    function DistancePlaneToPoint(constref point : TGLZVector) : Single;
    function DistancePlaneToSphere(constref Center : TGLZVector; constref Radius:Single) : Single;
    { Compute the intersection point "res" of a line with a plane.
      Return value:
       0 : no intersection, line parallel to plane
       1 : res is valid
       -1 : line is inside plane
      Adapted from:
      E.Hartmann, Computeruntersttzte Darstellende Geometrie, B.G. Teubner Stuttgart 1988 }
    //function IntersectLinePlane(const point, direction : TGLZVector; intersectPoint : PGLZVector = nil) : Integer;

    function Rotate(constref axis : TGLZVector; angle : Single):TGLZVector;
    // Returns given vector rotated around the X axis (alpha is in rad)
    function RotateAroundX(alpha : Single) : TGLZVector;
    // Returns given vector rotated around the Y axis (alpha is in rad)
    function RotateAroundY(alpha : Single) : TGLZVector;
    // Returns given vector rotated around the Z axis (alpha is in rad)
    function RotateAroundZ(alpha : Single) : TGLZVector;
    // Self is the point
    function PointProject(constref origin, direction : TGLZVector) : Single;
    // Returns true if both vector are colinear
    function IsColinear(constref v2: TGLZVector) : Boolean;
    // Returns true if line intersect ABCD quad. Quad have to be flat and convex
    //function IsLineIntersectQuad(const direction, ptA, ptB, ptC, ptD : TGLZVector) : Boolean;
    // Computes closest point on a segment (a segment is a limited line).
    //function PointSegmentClosestPoint(segmentStart, segmentStop : TGLZVector) : TGLZVector;
    { Computes algebraic distance between segment and line (a segment is a limited line).}
    //function PointSegmentDistance(const point, segmentStart, segmentStop : TAffineVector) : single;
    { Computes closest point on a line.}
    //function PointLineClosestPoint(const linePoint, lineDirection : TGLZVector) : TGLZVector;
    { Computes algebraic distance between point and line.}
    //function PointLineDistance(const linePoint, lineDirection : TGLZVector) : Single;
    { Extracted from Camera.MoveAroundTarget(pitch, turn). }
    function MoveAround(constref AMovingObjectUp, ATargetPosition: TGLZVector; pitchDelta, turnDelta: Single): TGLZVector;
    { AOriginalPosition - Object initial position.
       ACenter - some point, from which is should be distanced.

       ADistance + AFromCenterSpot - distance, which object should keep from ACenter
       or
       ADistance + not AFromCenterSpot - distance, which object should shift from his current position away from center.
    }
    function ShiftObjectFromCenter(Constref ACenter: TGLZVector; const ADistance: Single; const AFromCenterSpot: Boolean): TGLZVector;

    function AverageNormal4(constref up, left, down, right: TGLZVector): TGLZVector;
  end;

{%endregion%}

{%region%----[ TGLZHmgPlane ]---------------------------------------------------}

{ ARF IT'S IMPOSSIBLE TO CREATE MORE THAN 1 HELPER PER RECORD
  SO BECAREFULL THE LAST DECLARED HELPER IS THE ONLY AVAILABLE, snif :( , so moved in TGLZVectorHelper }

(*  TGLZHmgPlaneHelper = record helper for TGLZHmgPlane
  public
    procedure CreatePlane(constref p1, p2, p3 : TGLZVector);overload;
    // Computes the parameters of a plane defined by a point and a normal.
    procedure CreatePlane(constref point, normal : TGLZVector); overload;

    //function Normalize : TGLZHmgPlane; overload;
    function NormalizePlane : TGLZHmgPlane;

    procedure CalcPlaneNormal(constref p1, p2, p3 : TGLZVector);

    //function PointIsInHalfSpace(constref point: TGLZVector) : Boolean;
    //function PlaneEvaluatePoint(constref point : TGLZVector) : Single;
    function DistancePlaneToPoint(constref point : TGLZVector) : Single;
    function DistancePlaneToSphere(constref Center : TGLZVector; constref Radius:Single) : Single;
    { Compute the intersection point "res" of a line with a plane.
      Return value:
       0 : no intersection, line parallel to plane
       1 : res is valid
       -1 : line is inside plane
      Adapted from:
      E.Hartmann, Computeruntersttzte Darstellende Geometrie, B.G. Teubner Stuttgart 1988 }
    //function IntersectLinePlane(const point, direction : TGLZVector; intersectPoint : PGLZVector = nil) : Integer;
  end;  *)

{%endregion%}

{%region%----[ TGLZMatrixHelper ]-----------------------------------------------}

  TGLZMatrixHelper = record helper for TGLZMatrix
  public
    // Self is ViewProjMatrix
    //function Project(Const objectVector: TGLZVector; const viewport: TVector4i; out WindowVector: TGLZVector): Boolean;
    //function UnProject(Const WindowVector: TGLZVector; const viewport: TVector4i; out objectVector: TGLZVector): Boolean;
    // coordinate system manipulation functions
    // Rotates the given coordinate system (represented by the matrix) around its Y-axis
    function Turn(angle : Single) : TGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around MasterUp
    function Turn(constref MasterUp : TGLZVector; Angle : Single) : TGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around its X-axis
    function Pitch(Angle: Single): TGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around MasterRight
    function Pitch(constref MasterRight: TGLZVector; Angle: Single): TGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around its Z-axis
    function Roll(Angle: Single): TGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around MasterDirection
    function Roll(constref MasterDirection: TGLZVector; Angle: Single): TGLZMatrix; overload;
  end;

{%endregion%}

{%region%----[ Vectors Const ]--------------------------------------------------}

Const
  // standard affine vectors
  XVector :    TGLZAffineVector = (X:1; Y:0; Z:0);
  YVector :    TGLZAffineVector = (X:0; Y:1; Z:0);
  ZVector :    TGLZAffineVector = (X:0; Y:0; Z:1);
  XYVector :   TGLZAffineVector = (X:1; Y:1; Z:0);
  XZVector :   TGLZAffineVector = (X:1; Y:0; Z:1);
  YZVector :   TGLZAffineVector = (X:0; Y:1; Z:1);
  XYZVector :  TGLZAffineVector = (X:1; Y:1; Z:1);
  // standard homogeneous vectors
  XHmgVector : TGLZVector = (X:1; Y:0; Z:0; W:0);
  YHmgVector : TGLZVector = (X:0; Y:1; Z:0; W:0);
  ZHmgVector : TGLZVector = (X:0; Y:0; Z:1; W:0);
  WHmgVector : TGLZVector = (X:0; Y:0; Z:0; W:1);
  NullHmgVector : TGLZVector = (X:0; Y:0; Z:0; W:0);
  // standard homogeneous points
  XHmgPoint :  TGLZVector = (X:1; Y:0; Z:0; W:1);
  YHmgPoint :  TGLZVector = (X:0; Y:1; Z:0; W:1);
  ZHmgPoint :  TGLZVector = (X:0; Y:0; Z:1; W:1);
  WHmgPoint :  TGLZVector = (X:0; Y:0; Z:0; W:1);
  NullHmgPoint : TGLZVector = (X:0; Y:0; Z:0; W:1);

  NegativeUnitVector : TGLZVector = (X:-1; Y:-1; Z:-1; W:-1);

{%endregion%}

{%region%----[ Matrix Const ]---------------------------------------------------}

Const
  IdentityHmgMatrix : TGLZMatrix = (V:((X:1; Y:0; Z:0; W:0),
                                       (X:0; Y:1; Z:0; W:0),
                                       (X:0; Y:0; Z:1; W:0),
                                       (X:0; Y:0; Z:0; W:1)));

  EmptyHmgMatrix : TGLZMatrix = (V:((X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0)));
{%endregion%}

{%region%----[ Quaternion Const ]-----------------------------------------------}

Const
 IdentityQuaternion: TGLZQuaternion = (ImagePart:(X:0; Y:0; Z:0); RealPart: 1);

{%endregion%}

{%region%----[ Misc Vector Helpers functions ]----------------------------------}

function AffineVectorMake(const x, y, z : Single) : TGLZAffineVector;overload;
function AffineVectorMake(const v : TGLZVector) : TGLZAffineVector;overload;

{%endregion%}

{%region%----[ SSE Register States and utils funcs ]----------------------------}

function get_mxcsr:dword;
procedure set_mxcsr(flags:dword);

function sse_GetRoundMode: sse_Rounding_Mode;
procedure sse_SetRoundMode(Round_Mode: sse_Rounding_Mode);

{%endregion%}

Implementation

Uses Math, GLZMath, GLZUtils;

Const
  cNullVector4f   : TGLZVector = (x:0;y:0;z:0;w:0);
  cOneVector4f    : TGLZVector = (x:1;y:1;z:1;w:1);
  cNegateVector4f_PNPN    : TGLZVector = (x:1;y:-1;z:1;w:-1);
  cWOneVector4f   : TGLZVector = (x:0;y:0;z:0;w:1);
  cWOneSSEVector4f : TGLZVector = (X:0; Y:0; Z:0; W:1);

  cHalfOneVector4f    : TGLZVector  = (X:0.5; Y:0.5; Z:0.5; W:0.5); //  00800000h,00800000h,00800000h,00800000h

{$IFDEF USE_ASM}
  cSSE_MASK_ABS    : array [0..3] of UInt32 = ($7FFFFFFF, $7FFFFFFF, $7FFFFFFF, $7FFFFFFF);
  cSSE_MASK_NEGATE : array [0..3] of UInt32 = ($80000000, $80000000, $80000000, $80000000);
  cSSE_SIGN_MASK_NPPP   : array [0..3] of UInt32 = ($80000000, $00000000, $00000000, $00000000);
  cSSE_SIGN_MASK_PPPN   : array [0..3] of UInt32 = ($00000000, $00000000, $00000000, $80000000);
  cSSE_SIGN_MASK_NPNP   : array [0..3] of UInt32 = ($80000000, $00000000, $80000000, $00000000);
  cSSE_SIGN_MASK_PNPN   : array [0..3] of UInt32 = ($00000000, $80000000, $00000000, $80000000);
  cSSE_SIGN_MASK_PNNP   : array [0..3] of UInt32 = ($00000000, $80000000, $80000000, $00000000);
  cSSE_MASK_NO_W   : array [0..3] of UInt32 = ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $00000000);
  cSSE_MASK_ONLY_W : array [0..3] of UInt32 = ($00000000, $00000000, $00000000, $FFFFFFFF);
  //cSSE_MASK_NO_XYZ : array [0..3] of UInt32 = ($00000000, $00000000, $00000000, $FFFFFFFF);


  cSSE_OPERATOR_EQUAL             = 0;
  cSSE_OPERATOR_LESS              = 1;
  cSSE_OPERATOR_LESS_OR_EQUAL     = 2;
  cSSE_OPERATOR_ORDERED           = 3;
  cSSE_OPERATOR_NOT_EQUAL         = 4;
  cSSE_OPERATOR_NOT_LESS          = 5;
  cSSE_OPERATOR_NOT_LESS_OR_EQUAL = 6;
  cSSE_OPERATOR_NOT_ORDERED       = 7;
{$ENDIF}

{%region%----[ Vectors ]--------------------------------------------------------}

{%region%----[ Vector2f ]-------------------------------------------------------}

procedure TGLZVector2f.Create(aX,aY: single);
begin
  Self.X := aX;
  Self.Y := aY;
end;

function TGLZVector2f.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+')';
End;

class operator TGLZVector2f.-(constref A: TGLZVector2f): TGLZVector2f;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

class operator TGLZVector2f.=(constref A, B: TGLZVector2f): Boolean;
begin
 result := ((A.X = B.X) And (A.Y = B.Y));
end;
(*class operator >=(constref A, B: TVector4f): Boolean;
class operator <=(constref A, B: TVector4f): Boolean;
class operator >(constref A, B: TVector4f): Boolean;
class operator <(constref A, B: TVector4f): Boolean; *)
class operator TGLZVector2f.<>(constref A, B: TGLZVector2f): Boolean;
begin
  result := ((A.X <> B.X) or (A.Y <> B.Y));
end;

(* function TGLZVector2f.Abs(const A: TVector2f): TVector2f;
begin
  Result.X := System.Abs(A.X);
  Result.Y := System.Abs(A.Y);
end;  *)

{$ifdef USE_ASM}
{$ifdef UNIX}
  {$ifdef CPU64}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_vector_unix64_avx_imp.inc}
    {$ELSE}
       {$I vectormath_vector_unix64_sse_imp.inc}
    {$ENDIF}
  {$else}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_vector_unix32_avx_imp.inc}
    {$ELSE}
       {$I vectormath_vector_unix32_sse_imp.inc}
    {$ENDIF}
  {$endif}
{$else}
  {$ifdef CPU64}
     {$IFDEF USE_ASM_AVX}
         {$I vectormath_vector_win64_avx_imp.inc}
      {$ELSE}
         {$I vectormath_vector2f_win64_sse_imp.inc}
      {$ENDIF}
  {$else}
     {$IFDEF USE_ASM_AVX}
        {$I vectormath_vector_win32_avx_imp.inc}
     {$ELSE}
        {$I vectormath_vector_win32_sse_imp.inc}
     {$ENDIF}
  {$endif}
{$endif}
{$else}
  {$I vectormath_vector2f_native_imp.inc}
{$endif}


{%endregion%}

{%region%----[ Vector4f ]-------------------------------------------------------}

{%region%====[ Commons functions ]==============================================}

procedure TGLZVector4f.Create(Const aX,aY,aZ: single; const aW : Single = 0);
begin
   Self.X := AX;
   Self.Y := AY;
   Self.Z := AZ;
   Self.W := AW;
end;

procedure TGLZVector4f.Create(Const anAffineVector: TGLZVector3f; const aW : Single = 0);
begin
   Self.X := anAffineVector.X;
   Self.Y := anAffineVector.Y;
   Self.Z := anAffineVector.Z;
   Self.W := AW;
end;

function TGLZVector4f.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+
            ' ,Z: '+FloattoStrF(Self.Z,fffixed,5,5)+
            ' ,W: '+FloattoStrF(Self.W,fffixed,5,5)+')';
End;

function TGLZVector4f.Shuffle(const x,y,z,w : Byte):TGLZVector4f;
begin
  Result.V[x]:=Self.X;
  Result.V[y]:=Self.Y;
  Result.V[z]:=Self.Z;
  Result.V[w]:=Self.W;
End;

function TGLZVector4f.MinXYZComponent : Single;
begin
   Result:=Min3s(Self.X, Self.Y, Self.Z);
end;

function TGLZVector4f.MaxXYZComponent : Single;
begin
   Result:=Max3s(Self.X, Self.Y, Self.Z);
end;

{%endregion%}

{$ifdef USE_ASM}
{$ifdef UNIX}
  {$ifdef CPU64}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_vector_unix64_avx_imp.inc}
    {$ELSE}
       {$I vectormath_vector_unix64_sse_imp.inc}
    {$ENDIF}
  {$else}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_vector_unix32_avx_imp.inc}
    {$ELSE}
       {$I vectormath_vector_unix32_sse_imp.inc}
    {$ENDIF}
  {$endif}
{$else}
  {$ifdef CPU64}
     {$IFDEF USE_ASM_AVX}
         {$I vectormath_vector_win64_avx_imp.inc}
      {$ELSE}
         {$I vectormath_vector4f_win64_sse_imp.inc}
      {$ENDIF}
  {$else}
     {$IFDEF USE_ASM_AVX}
        {$I vectormath_vector_win32_avx_imp.inc}
     {$ELSE}
        {$I vectormath_vector_win32_sse_imp.inc}
     {$ENDIF}
  {$endif}
{$endif}
{$else}
  {$I vectormath_vector4f_native_imp.inc}
{$endif}


{%endregion%}

{%endregion%}

{%region%----[ Misc Vector Helpers functions ]----------------------------------}

function AffineVectorMake(const x, y, z : Single) : TGLZAffineVector;
begin
   Result.X:=x;
   Result.Y:=y;
   Result.Z:=z;
end;

function AffineVectorMake(const v : TGLZVector) : TGLZAffineVector;
begin
   Result.X:=v.X;
   Result.Y:=v.Y;
   Result.Z:=v.Z;
end;

{%endregion%}

{%region%----[ Matrix ]---------------------------------------------------------}

function TGLZMatrix4.GetComponent(const ARow, AColumn: Integer): Single;
begin
  Result := Self.M[ARow, AColumn];
end;

procedure TGLZMatrix4.SetComponent(const ARow, AColumn: Integer; const Value: Single);
begin
  Self.M[ARow, AColumn] := Value;
end;

procedure TGLZMatrix4.SetRow(const AIndex: Integer; const Value: TGLZVector);
begin
  Self.V[AIndex] := Value;
end;

function TGLZMatrix4.GetRow(const AIndex: Integer): TGLZVector;
begin
  Result := V[AIndex];
end;

function TGLZMatrix4.ToString : String;
begin
  Result :='|'+V[0].ToString+'|'+#13+#10
          +'|'+V[1].ToString+'|'+#13+#10
          +'|'+V[2].ToString+'|'+#13+#10
          +'|'+V[3].ToString+'|'+#13+#10
End;

procedure TGLZMatrix4.CreateIdentityMatrix;
begin
  Self:=IdentityHmgMatrix;
End;

procedure TGLZMatrix4.CreateScaleMatrix(const v : TGLZAffineVector);
begin
   Self:=IdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TGLZMatrix4.CreateScaleMatrix(const v : TGLZVector);
begin
   Self:=IdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TGLZMatrix4.CreateTranslationMatrix(const V: TGLZAffineVector);
begin
   Self:=IdentityHmgMatrix;
   Self.W.X:=V.X;
   Self.W.Y:=V.Y;
   Self.W.Z:=V.Z;
end;

procedure TGLZMatrix4.CreateTranslationMatrix(const V: TGLZVector);
begin
   Self:=IdentityHmgMatrix;
   Self.W.X:=V.X;
   Self.W.Y:=V.Y;
   Self.W.Z:=V.Z;
end;

procedure TGLZMatrix4.CreateScaleAndTranslationMatrix(const ascale, offset : TGLZVector);
begin
   Self:=IdentityHmgMatrix;
   Self.X.X:=ascale.X;   Self.W.X:=offset.X;
   Self.Y.Y:=ascale.Y;   Self.W.Y:=offset.Y;
   Self.Z.Z:=ascale.Z;   Self.W.Z:=offset.Z;
end;

procedure TGLZMatrix4.CreateRotationMatrixX(const sine, cosine: Single);
begin
   Self:=EmptyHmgMatrix;
   Self.X.X:=1;
   Self.Y.Y:=cosine;
   Self.Y.Z:=sine;
   Self.Z.Y:=-sine;
   Self.Z.Z:=cosine;
   Self.W.W:=1;
end;

procedure TGLZMatrix4.CreateRotationMatrixX(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixX(s, c);
end;

procedure TGLZMatrix4.CreateRotationMatrixY(const sine, cosine: Single);
begin
   Self:=EmptyHmgMatrix;
   Self.X.X:=cosine;
   Self.X.Z:=-sine;
   Self.Y.Y:=1;
   Self.Z.X:=sine;
   Self.Z.Z:=cosine;
   Self.W.W:=1;
end;

procedure TGLZMatrix4.CreateRotationMatrixY(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixY(s, c);
end;

procedure TGLZMatrix4.CreateRotationMatrixZ(const sine, cosine: Single);
begin
   Self:=EmptyHmgMatrix;
   Self.X.X:=cosine;
   Self.X.Y:=sine;
   Self.Y.X:=-sine;
   Self.Y.Y:=cosine;
   Self.Z.Z:=1;
   Self.W.W:=1;
end;

procedure TGLZMatrix4.CreateRotationMatrixZ(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixZ(s, c);
end;

procedure TGLZMatrix4.CreateRotationMatrix(const anAxis : TGLZAffineVector; angle : Single);
var
   axis : TGLZVector;
   cosine, sine, one_minus_cosine : Single;
begin
   axis.AsVector3f := anAxis;
   //GLZMath.
   SinCos(angle, sine, cosine);
   one_minus_cosine:=1-cosine;
   axis.Normalize;

   Self.X.X:=(one_minus_cosine * axis.V[0] * axis.V[0]) + cosine;
   Self.X.Y:=(one_minus_cosine * axis.V[0] * axis.V[1]) - (axis.V[2] * sine);
   Self.X.Z:=(one_minus_cosine * axis.V[2] * axis.V[0]) + (axis.V[1] * sine);
   Self.X.W:=0;

   Self.Y.X:=(one_minus_cosine * axis.V[0] * axis.V[1]) + (axis.V[2] * sine);
   Self.Y.Y:=(one_minus_cosine * axis.V[1] * axis.V[1]) + cosine;
   Self.Y.Z:=(one_minus_cosine * axis.V[1] * axis.V[2]) - (axis.V[0] * sine);
   Self.Y.W:=0;

   Self.Z.X:=(one_minus_cosine * axis.V[2] * axis.V[0]) - (axis.V[1] * sine);
   Self.Z.Y:=(one_minus_cosine * axis.V[1] * axis.V[2]) + (axis.V[0] * sine);
   Self.Z.Z:=(one_minus_cosine * axis.V[2] * axis.V[2]) + cosine;
   Self.Z.W:=0;

   Self.W.X:=0;
   Self.W.Y:=0;
   Self.W.Z:=0;
   Self.W.W:=1;
end;

procedure TGLZMatrix4.CreateRotationMatrix(const anAxis : TGLZVector; angle : Single);
begin
   CreateRotationMatrix(anAxis.AsVector3f, angle);
end;


(* function TGLZMatrix4.Invert:TGLZMatrix4;
var
   det : Single;
begin
   det:=GetDeterminant;
   if Abs(Det)<cEPSILON then  result:=IdentityHmgMatrix
   else
   begin
      Self.Adjoint;
      result := Self * (1/det);
   end;
end; *)

function TGLZMatrix4.MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
// internal version for the determinant of a 3x3 matrix
begin
  Result:=  a1 * (b2 * c3 - b3 * c2)
          - b1 * (a2 * c3 - a3 * c2)
          + c1 * (a2 * b3 - a3 * b2);
end;

{ TODO 1 -oTMatrix4 -cASM : Adjoint : Add SSE/AVX Version }
procedure TGLZMatrix4.Adjoint;
var
   a1, a2, a3, a4,
   b1, b2, b3, b4,
   c1, c2, c3, c4,
   d1, d2, d3, d4: Single;
begin
    a1:= Self.X.X; b1:= Self.X.Y;
    c1:= Self.X.Z; d1:= Self.X.W;
    a2:= Self.Y.X; b2:= Self.Y.Y;
    c2:= Self.Y.Z; d2:= Self.Y.W;
    a3:= Self.Z.X; b3:= Self.Z.Y;
    c3:= Self.Z.Z; d3:= Self.Z.W;
    a4:= Self.W.X; b4:= Self.W.Y;
    c4:= Self.W.Z; d4:= Self.W.W;

    // row column labeling reversed since we transpose rows & columns
    Self.X.X:= MatrixDetInternal(b2, b3, b4, c2, c3, c4, d2, d3, d4);
    Self.X.Y:=-MatrixDetInternal(b1, b3, b4, c1, c3, c4, d1, d3, d4);
    Self.X.Z:= MatrixDetInternal(b1, b2, b4, c1, c2, c4, d1, d2, d4);
    Self.X.W:=-MatrixDetInternal(b1, b2, b3, c1, c2, c3, d1, d2, d3);

    Self.Y.X:=-MatrixDetInternal(a2, a3, a4, c2, c3, c4, d2, d3, d4);
    Self.Z.X:= MatrixDetInternal(a2, a3, a4, b2, b3, b4, d2, d3, d4);
    Self.W.X:=-MatrixDetInternal(a2, a3, a4, b2, b3, b4, c2, c3, c4);


    Self.Y.Y:= MatrixDetInternal(a1, a3, a4, c1, c3, c4, d1, d3, d4);
    Self.Z.Y:=-MatrixDetInternal(a1, a3, a4, b1, b3, b4, d1, d3, d4);
    Self.W.Y:= MatrixDetInternal(a1, a3, a4, b1, b3, b4, c1, c3, c4);


    Self.Y.Z:=-MatrixDetInternal(a1, a2, a4, c1, c2, c4, d1, d2, d4);
    Self.Z.Z:= MatrixDetInternal(a1, a2, a4, b1, b2, b4, d1, d2, d4);
    Self.W.Z:=-MatrixDetInternal(a1, a2, a4, b1, b2, b4, c1, c2, c4);


    Self.Y.W:= MatrixDetInternal(a1, a2, a3, c1, c2, c3, d1, d2, d3);
    Self.Z.W:=-MatrixDetInternal(a1, a2, a3, b1, b2, b3, d1, d2, d3);
    Self.W.W:= MatrixDetInternal(a1, a2, a3, b1, b2, b3, c1, c2, c3);
end;


{ TODO 1 -oTMatrix4 -cASM : Add SSE/AVX Version }
procedure TGLZMatrix4.Transpose_Scale_M33(constref src : TGLZMatrix4; Constref ascale : Single);
// EAX src
// EDX dest
// ECX scale
begin
   Self.V[0].V[0]:=ascale*src.V[0].V[0];
   Self.V[1].V[0]:=ascale*src.V[0].V[1];
   Self.V[2].V[0]:=ascale*src.V[0].V[2];

   Self.V[0].V[1]:=ascale*src.V[1].V[0];
   Self.V[1].V[1]:=ascale*src.V[1].V[1];
   Self.V[2].V[1]:=ascale*src.V[1].V[2];

   Self.V[0].V[2]:=ascale*src.V[2].V[0];
   Self.V[1].V[2]:=ascale*src.V[2].V[1];
   Self.V[2].V[2]:=ascale*src.V[2].V[2];
end;

{ TODO 1 -oTMatrix4 -cASM : Add SSE/AVX Version }
procedure TGLZMatrix4.AnglePreservingMatrixInvert(constref mat : TGLZMatrix4);
var
   ascale : Single;
begin
   ascale:=mat.V[0].Norm;

   // Is the submatrix A singular?
   if Abs(ascale)<cEPSILON then
   begin
      // Matrix M has no inverse
      Self:=IdentityHmgMatrix;
      Exit;
   end
   else
   begin
      // Calculate the inverse of the square of the isotropic scale factor
      ascale:=1.0/ascale;
   end;

   // Fill in last row while CPU is busy with the division
   Self.V[0].V[3]:=0.0;
   Self.V[1].V[3]:=0.0;
   Self.V[2].V[3]:=0.0;
   Self.V[3].V[3]:=1.0;

   // Transpose and scale the 3 by 3 upper-left submatrix
   Self.transpose_scale_m33(mat,ascale);

   // Calculate -(transpose(A) / s*s) C
   Self.V[3].V[0]:=-(Self.V[0].V[0]*mat.V[3].V[0]
                    +Self.V[1].V[0]*mat.V[3].V[1]
                    +Self.V[2].V[0]*mat.V[3].V[2]);
   Self.V[3].V[1]:=-(Self.V[0].V[1]*mat.V[3].V[0]
                    +Self.V[1].V[1]*mat.V[3].V[1]
                    +Self.V[2].V[1]*mat.V[3].V[2]);
   Self.V[3].V[2]:=-(Self.V[0].V[2]*mat.V[3].V[0]
                    +Self.V[1].V[2]*mat.V[3].V[1]
                    +Self.V[2].V[2]*mat.V[3].V[2]);
end;

function TGLZMatrix4.Decompose(var Tran: TGLZMatrixTransformations): Boolean;
var
   I, J: Integer;
   LocMat, pmat, invpmat : TGLZMatrix;
   prhs, psol: TGLZVector;
   row0, row1, row2 : TGLZVector;
   f : Single;
begin
  Result:=False;
  locmat:=Self;
  // normalize the matrix
  if LocMat.W.W = 0 then Exit;
  for I:=0 to 3 do
    for J:=0 to 3 do
      Locmat.V[I].V[J]:=locmat.V[I].V[J] / locmat.W.W;

  // pmat is used to solve for perspective, but it also provides
  // an easy way to test for singularity of the upper 3x3 component.

  pmat:=locmat;
  for I:=0 to 2 do pmat.V[I].W:=0;
  pmat.W.W:=1;

  if pmat.Determinant = 0 then Exit;

  // First, isolate perspective.  This is the messiest.
  if (locmat.X.W <> 0) or (locmat.Y.W <> 0) or (locmat.Z.W <> 0) then
  begin
    // prhs is the right hand side of the equation.
    prhs.X:=locmat.X.W;
    prhs.Y:=locmat.Y.W;
    prhs.Z:=locmat.Z.W;
    prhs.W:=locmat.W.W;

    // Solve the equation by inverting pmat and multiplying
    // prhs by the inverse.  (This is the easiest way, not
    // necessarily the best.)

    invpmat:=pmat;
    invpmat.Invert;
    invpmat.Transpose;
    psol:=  invpmat * prhs; //VectorTransform(prhs, invpmat);

    // stuff the answer away
    Tran[ttPerspectiveX]:=psol.X;
    Tran[ttPerspectiveY]:=psol.Y;
    Tran[ttPerspectiveZ]:=psol.Z;
    Tran[ttPerspectiveW]:=psol.W;

    // clear the perspective partition
    locmat.X.W:=0;
    locmat.Y.W:=0;
    locmat.Z.W:=0;
    locmat.W.W:=1;
  end
  else
  begin
    // no perspective
    Tran[ttPerspectiveX]:=0;
    Tran[ttPerspectiveY]:=0;
    Tran[ttPerspectiveZ]:=0;
    Tran[ttPerspectiveW]:=0;
  end;

  // next take care of translation (easy)
  for I:=0 to 2 do
  begin
    Tran[TGLZMAtrixTransType(Ord(ttTranslateX) + I)]:=locmat.V[3].V[I];
    locmat.V[3].V[I]:=0;
  end;

  // now get scale and shear
  row0 := locmat.X;
  row1 := locmat.Y;
  row2 := locmat.Z;

  // compute X scale factor and normalize first row
  Tran[ttScaleX]:=Row0.Norm;
  Row0 := Row0 * RSqrt(Tran[ttScaleX]); //VectorScale(row0, RSqrt(Tran[ttScaleX]));

  // compute XY shear factor and make 2nd row orthogonal to 1st
  Tran[ttShearXY]:=row0.DotProduct(row1);
  f:=-Tran[ttShearXY];
  Row1.Combine(row0, f);

  // now, compute Y scale and normalize 2nd row
  Tran[ttScaleY]:=Row1.Norm;
  Row1 := Row1 * RSqrt(Tran[ttScaleY]); //VectorScale(row1, RSqrt(Tran[ttScaleY]));
  Tran[ttShearXY]:=Tran[ttShearXY]/Tran[ttScaleY];

  // compute XZ and YZ shears, orthogonalize 3rd row
  Tran[ttShearXZ]:=row0.DotProduct(row2);
  f:=-Tran[ttShearXZ];
  row2.Combine(row0, f);
  Tran[ttShearYZ]:=Row1.DotProduct(row2);
  f:=-Tran[ttShearYZ];
  Row2.Combine(row1, f);

  // next, get Z scale and normalize 3rd row
  Tran[ttScaleZ]:=Row2.Norm;
  Row2:=row2* RSqrt(Tran[ttScaleZ]);
  Tran[ttShearXZ]:=Tran[ttShearXZ] / tran[ttScaleZ];
  Tran[ttShearYZ]:=Tran[ttShearYZ] / Tran[ttScaleZ];

  // At this point, the matrix (in rows[]) is orthonormal.
  // Check for a coordinate system flip.  If the determinant
  // is -1, then negate the matrix and the scaling factors.
  if row0.DotProduct(row1.CrossProduct(row2)) < 0 then
  begin
    for I:=0 to 2 do
      Tran[TGLZMatrixTransType(Ord(ttScaleX) + I)]:=-Tran[TGLZMatrixTransType(Ord(ttScaleX) + I)];
    row0.pNegate;
    row1.pNegate;
    row2.pNegate;
  end;

  // now, get the rotations out, as described in the gem
  Tran[ttRotateY]:=GLZMath.ArcSine(-row0.Z);
  if cos(Tran[ttRotateY]) <> 0 then
  begin
    Tran[ttRotateX]:=GLZMath.ArcTan2(row1.Z, row2.Z);
    Tran[ttRotateZ]:=GLZMath.ArcTan2(row0.Y, row0.X);
  end else
  begin
    tran[ttRotateX]:=GLZMath.ArcTan2(row1.X, row1.Y);
    tran[ttRotateZ]:=0;
  end;
  // All done!
  Result:=True;
end;

{ TODO 1 -oTMatrix4 -cASM : Add SSE/AVX Version }
procedure TGLZMatrix4.CreateLookAtMatrix(const eye, center, normUp: TGLZVector);
var
  XAxis, YAxis, ZAxis, negEye: TGLZVector;
begin
  ZAxis := center - eye;
  ZAxis.Normalize;
  XAxis := ZAxis.CrossProduct(normUp);
  XAxis.Normalize;
  YAxis := XAxis.CrossProduct(ZAxis);
  Self.V[0] := XAxis;
  Self.V[1] := YAxis;
  Self.V[2] := ZAxis;
  Self.V[2].pNegate;
  Self.V[3] := NullHmgPoint;
  Self.Transpose;
  negEye := eye;
  negEye.pNegate;
  negEye.V[3] := 1;
  negEye :=  Self * negEye ; //VectorTransform(negEye, Self);
  Self.V[3] := negEye;
end;

procedure TGLZMatrix4.CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);
begin
  Self.X.X := 2 * ZNear / (Right - Left);
  Self.X.Y := 0;
  Self.X.Z := 0;
  Self.X.W := 0;

  Self.Y.X := 0;
  Self.Y.Y := 2 * ZNear / (Top - Bottom);
  Self.Y.Z := 0;
  Self.Y.W := 0;

  Self.Z.X := (Right + Left) / (Right - Left);
  Self.Z.Y := (Top + Bottom) / (Top - Bottom);
  Self.Z.Z := -(ZFar + ZNear) / (ZFar - ZNear);
  Self.Z.W := -1;

  Self.W.X := 0;
  Self.W.Y := 0;
  Self.W.Z := -2 * ZFar * ZNear / (ZFar - ZNear);
  Self.W.W := 0;
end;

procedure TGLZMatrix4.CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);
var
  xx, yy: Single;
begin
  FOV := Min2s(179.9, Max2s(0, FOV));
  yy:= ZNear * GLZMath.Tan(GLZMath.DegToRadian(FOV) * 0.5);
  xx:= yy * Aspect;
  CreateMatrixFromFrustum(-xx, xx, -yy, yy, ZNear, ZFar);
end;

procedure TGLZMatrix4.CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);
begin
  Self.V[0].V[0] := 2 / (Right - Left);
  Self.V[0].V[1] := 0;
  Self.V[0].V[2] := 0;
  Self.V[0].V[3] := 0;

  Self.V[1].V[0] := 0;
  Self.V[1].V[1] := 2 / (Top - Bottom);
  Self.V[1].V[2] := 0;
  Self.V[1].V[3] := 0;

  Self.V[2].V[0] := 0;
  Self.V[2].V[1] := 0;
  Self.V[2].V[2] := -2 / (ZFar - ZNear);
  Self.V[2].V[3] := 0;

  Self.V[3].V[0] := (Left + Right) / (Left - Right);
  Self.V[3].V[1] := (Bottom + Top) / (Bottom - Top);
  Self.V[3].V[2] := (ZNear + ZFar) / (ZNear - ZFar);
  Self.V[3].V[3] := 1;
end;

procedure TGLZMatrix4.CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i);
begin
  if (deltax <= 0) or (deltay <= 0) then
  begin
    Self := IdentityHmgMatrix;
    exit;
  end;
  // Translate and scale the picked region to the entire window
  CreateTranslationMatrix(AffineVectorMake( (viewport.V[2] - 2 * (x - viewport.V[0])) / deltax,
	                                    (viewport.V[3] - 2 * (y - viewport.V[1])) / deltay,
                                            0.0));
  Self.V[0].V[0] := viewport.V[2] / deltax;
  Self.V[1].V[1] := viewport.V[3] / deltay;
end;


procedure TGLZMatrix4.CreateParallelProjectionMatrix(const plane : TGLZHmgPlane;const dir : TGLZVector);
// Based on material from a course by William D. Shoaff (www.cs.fit.edu)
var
   dot, invDot : Single;
begin
   dot:=plane.V[0]*dir.V[0]+plane.V[1]*dir.V[1]+plane.V[2]*dir.V[2];
   if Abs(dot)<1e-5 then
   begin
      Self:=IdentityHmgMatrix;
      Exit;
   end;
   invDot:=1/dot;

   Self.V[0].V[0]:=(plane.V[1]*dir.V[1]+plane.V[2]*dir.V[2])*invDot;
   Self.V[1].V[0]:=(-plane.V[1]*dir.V[0])*invDot;
   Self.V[2].V[0]:=(-plane.V[2]*dir.V[0])*invDot;
   Self.V[3].V[0]:=(-plane.V[3]*dir.V[0])*invDot;

   Self.V[0].V[1]:=(-plane.V[0]*dir.V[1])*invDot;
   Self.V[1].V[1]:=(plane.V[0]*dir.V[0]+plane.V[2]*dir.V[2])*invDot;
   Self.V[2].V[1]:=(-plane.V[2]*dir.V[1])*invDot;
   Self.V[3].V[1]:=(-plane.V[3]*dir.V[1])*invDot;

   Self.V[0].V[2]:=(-plane.V[0]*dir.V[2])*invDot;
   Self.V[1].V[2]:=(-plane.V[1]*dir.V[2])*invDot;
   Self.V[2].V[2]:=(plane.V[0]*dir.V[0]+plane.V[1]*dir.V[1])*invDot;
   Self.V[3].V[2]:=(-plane.V[3]*dir.V[2])*invDot;

   Self.V[0].V[3]:=0;
   Self.V[1].V[3]:=0;
   Self.V[2].V[3]:=0;
   Self.V[3].V[3]:=1;
end;

procedure TGLZMatrix4.CreateShadowMatrix(const planePoint, planeNormal, lightPos : TGLZVector);
var
   planeNormal3, dot : Single;
begin
	// Find the last coefficient by back substitutions
	planeNormal3:=-( planeNormal.V[0]*planePoint.V[0]
                   +planeNormal.V[1]*planePoint.V[1]
                   +planeNormal.V[2]*planePoint.V[2]);
	// Dot product of plane and light position
	dot:= planeNormal.V[0]*lightPos.V[0]
        +planeNormal.V[1]*lightPos.V[1]
        +planeNormal.V[2]*lightPos.V[2]
        +planeNormal3  *lightPos.V[3];
	// Now do the projection
	// First column
        Self.V[0].V[0]:= dot - lightPos.V[0] * planeNormal.V[0];
        Self.V[1].V[0]:=     - lightPos.V[0] * planeNormal.V[1];
        Self.V[2].V[0]:=     - lightPos.V[0] * planeNormal.V[2];
        Self.V[3].V[0]:=     - lightPos.V[0] * planeNormal3;
	// Second column
	Self.V[0].V[1]:=     - lightPos.V[1] * planeNormal.V[0];
	Self.V[1].V[1]:= dot - lightPos.V[1] * planeNormal.V[1];
	Self.V[2].V[1]:=     - lightPos.V[1] * planeNormal.V[2];
	Self.V[3].V[1]:=     - lightPos.V[1] * planeNormal3;
	// Third Column
	Self.V[0].V[2]:=     - lightPos.V[2] * planeNormal.V[0];
	Self.V[1].V[2]:=     - lightPos.V[2] * planeNormal.V[1];
	Self.V[2].V[2]:= dot - lightPos.V[2] * planeNormal.V[2];
	Self.V[3].V[2]:=     - lightPos.V[2] * planeNormal3;
	// Fourth Column
	Self.V[0].V[3]:=     - lightPos.V[3] * planeNormal.V[0];
	Self.V[1].V[3]:=     - lightPos.V[3] * planeNormal.V[1];
	Self.V[2].V[3]:=     - lightPos.V[3] * planeNormal.V[2];
	Self.V[3].V[3]:= dot - lightPos.V[3] * planeNormal3;
end;

procedure TGLZMatrix4.CreateReflectionMatrix(const planePoint, planeNormal : TGLZVector);
var
   pv2 : Single;
begin
   // Precalcs
   pv2:=2*planepoint.DotProduct(planeNormal);
   // 1st column
   Self.V[0].V[0]:=1-2*Sqr(planeNormal.V[0]);
   Self.V[0].V[1]:=-2*planeNormal.V[0]*planeNormal.V[1];
   Self.V[0].V[2]:=-2*planeNormal.V[0]*planeNormal.V[2];
   Self.V[0].V[3]:=0;
   // 2nd column
   Self.V[1].V[0]:=-2*planeNormal.V[1]*planeNormal.V[0];
   Self.V[1].V[1]:=1-2*Sqr(planeNormal.V[1]);
   Self.V[1].V[2]:=-2*planeNormal.V[1]*planeNormal.V[2];
   Self.V[1].V[3]:=0;
   // 3rd column
   Self.V[2].V[0]:=-2*planeNormal.V[2]*planeNormal.V[0];
   Self.V[2].V[1]:=-2*planeNormal.V[2]*planeNormal.V[1];
   Self.V[2].V[2]:=1-2*Sqr(planeNormal.V[2]);
   Self.V[2].V[3]:=0;
   // 4th column
   Self.V[3].V[0]:=pv2*planeNormal.V[0];
   Self.V[3].V[1]:=pv2*planeNormal.V[1];
   Self.V[3].V[2]:=pv2*planeNormal.V[2];
   Self.V[3].V[3]:=1;
end;

{$ifdef USE_ASM}
{$ifdef UNIX}
  {$ifdef CPU64}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_matrix_unix64_avx_imp.inc}
    {$ELSE}
       {$I vectormath_matrix_unix64_sse_imp.inc}
    {$ENDIF}
  {$else}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_matrix_unix32_avx_imp.inc}
    {$ELSE}
       {$I vectormath_matrix_unix32_sse_imp.inc}
    {$ENDIF}
  {$endif}
{$else}
  {$ifdef CPU64}
     {$IFDEF USE_ASM_AVX}
         {$I vectormath_matrix_win64_avx_imp.inc}
      {$ELSE}
         {$I vectormath_matrix_win64_sse_imp.inc}
      {$ENDIF}
  {$else}
     {$IFDEF USE_ASM_AVX}
        {$I vectormath_matrix_win32_avx_imp.inc}
     {$ELSE}
        {$I vectormath_matrix_win32_sse_imp.inc}
     {$ENDIF}
  {$endif}
{$endif}
{$else}
  {$I vectormath_matrix_native_imp.inc}
{$endif}

{%endregion%}

{%region%----[ Quaternion ]-----------------------------------------------------}

{%region%====[ Commons functions ]==============================================}


{%region%====[ Qaternion ]======================================================}
function TGLZQuaternion.ToString : String;
begin
   Result := '(ImagePart.X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,ImagePart.Y: '+FloattoStrF(Self.Y,fffixed,5,5)+
            ' ,ImagePart.Z: '+FloattoStrF(Self.Z,fffixed,5,5)+
            ' , RealPart.W: '+FloattoStrF(Self.W,fffixed,5,5)+')';
End;

procedure TGLZQuaternion.Create(const Imag: array of Single; Real : Single);
var
   n : Integer;
begin
   n:=Length(Imag);
   if n>=1 then Self.ImagePart.X:=Imag[0];
   if n>=2 then Self.ImagePart.Y:=Imag[1];
   if n>=3 then Self.ImagePart.Z:=Imag[2];
   Self.RealPart:=real;
end;

procedure TGLZQuaternion.Create(x,y,z: Single; Real : Single);
begin
  Self.ImagePart.X:=X;
  Self.ImagePart.Y:=Y;
  Self.ImagePart.Z:=Z;
  Self.RealPart:=real;
end;

procedure TGLZQuaternion.Create(const V1, V2: TGLZAffineVector);
Var
 //av : TGLZAffineVector;
 vv, vv1,vv2 : TGLZVector;
begin
   vv1.AsVector3f := V1;
   vv2.AsVector3f := V2;
   vv:=vv1.CrossProduct(vv2);
   Self.ImagePart:= vv.AsVector3f;
   Self.RealPart:= Sqrt((vv1.DotProduct(vv2) + 1)/2);
end;
//procedure TGLZQuaternion.Create(const V1, V2: TGLZVector);

//procedure TGLZQuaternion.Create(const mat : TGLZMatrix);
{// the matrix must be a rotation matrix!
var
   traceMat, s, invS : Double;
begin
   traceMat := 1 + mat.V[0].V[0] + mat.V[1].V[1] + mat.V[2].V[2];
   if traceMat>EPSILON2 then begin
      s:=Sqrt(traceMat)*2;
      invS:=1/s;
      Result.ImagPart.V[0]:=(mat.V[1].V[2]-mat.V[2].V[1])*invS;
      Result.ImagPart.V[1]:=(mat.V[2].V[0]-mat.V[0].V[2])*invS;
      Result.ImagPart.V[2]:=(mat.V[0].V[1]-mat.V[1].V[0])*invS;
      Result.RealPart         :=0.25*s;
   end else if (mat.V[0].V[0]>mat.V[1].V[1]) and (mat.V[0].V[0]>mat.V[2].V[2]) then begin  // Row 0:
      s:=Sqrt(MaxFloat(EPSILON2, cOne+mat.V[0].V[0]-mat.V[1].V[1]-mat.V[2].V[2]))*2;
      invS:=1/s;
      Result.ImagPart.V[0]:=0.25*s;
      Result.ImagPart.V[1]:=(mat.V[0].V[1]+mat.V[1].V[0])*invS;
      Result.ImagPart.V[2]:=(mat.V[2].V[0]+mat.V[0].V[2])*invS;
      Result.RealPart         :=(mat.V[1].V[2]-mat.V[2].V[1])*invS;
   end else if (mat.V[1].V[1]>mat.V[2].V[2]) then begin  // Row 1:
      s:=Sqrt(MaxFloat(EPSILON2, cOne+mat.V[1].V[1]-mat.V[0].V[0]-mat.V[2].V[2]))*2;
      invS:=1/s;
      Result.ImagPart.V[0]:=(mat.V[0].V[1]+mat.V[1].V[0])*invS;
      Result.ImagPart.V[1]:=0.25*s;
      Result.ImagPart.V[2]:=(mat.V[1].V[2]+mat.V[2].V[1])*invS;
      Result.RealPart         :=(mat.V[2].V[0]-mat.V[0].V[2])*invS;
   end else begin  // Row 2:
      s:=Sqrt(MaxFloat(EPSILON2, cOne+mat.V[2].V[2]-mat.V[0].V[0]-mat.V[1].V[1]))*2;
      invS:=1/s;
      Result.ImagPart.V[0]:=(mat.V[2].V[0]+mat.V[0].V[2])*invS;
      Result.ImagPart.V[1]:=(mat.V[1].V[2]+mat.V[2].V[1])*invS;
      Result.ImagPart.V[2]:=0.25*s;
      Result.RealPart         :=(mat.V[0].V[1]-mat.V[1].V[0])*invS;
   end;
   NormalizeQuaternion(Result);
end; }

procedure TGLZQuaternion.Create(const angle  : Single; const axis : TGLZAffineVector);
//procedure TGLZQuaternion.Create(const angle  : Single; const axis : TGLZVector);
var
   f, s, c : Single;
   vaxis : TGLZVector;
begin
   GLZMath.SinCos(DegToRadian(angle*cOneDotFive), s, c);
   Self.RealPart:=c;
   vaxis.AsVector3f := axis;
   f:=s/vAxis.Length;
   Self.ImagePart.V[0]:=axis.V[0]*f;
   Self.ImagePart.V[1]:=axis.V[1]*f;
   Self.ImagePart.V[2]:=axis.V[2]*f;
end;

procedure TGLZQuaternion.Create(const r, p, y : Single); //Roll Pitch Yaw
var
   qp, qy : TGLZQuaternion;
begin
   Self.Create(r, ZVector); // Create From Angle Axis
   qp.Create(p, XVector);
   qy.Create(y, YVector);

   Self:=qp * Self;
   Self:=qy * Self;
end;

procedure TGLZQuaternion.Create(const x, y, z: Single; eulerOrder : TGLZEulerOrder);
// input angles in degrees
var
   gimbalLock: Boolean;
   quat1, quat2: TGLZQuaternion;

   function EulerToQuat(const X, Y, Z: Single; eulerOrder: TGLZEulerOrder) : TGLZQuaternion;
   const
      cOrder : array [Low(TGLZEulerOrder)..High(TGLZEulerOrder)] of array [1..3] of Byte =
         ( (1, 2, 3), (1, 3, 2), (2, 1, 3),     // eulXYZ, eulXZY, eulYXZ,
           (3, 1, 2), (2, 3, 1), (3, 2, 1) );   // eulYZX, eulZXY, eulZYX
   var
      q : array [1..3] of TGLZQuaternion;
   begin
      q[cOrder[eulerOrder][1]].Create(X, XVector); // Create From Angle Axis
      q[cOrder[eulerOrder][2]].Create(Y, YVector);
      q[cOrder[eulerOrder][3]].Create(Z, ZVector);
      result:=(q[2] * q[3]);
      result:=(q[1] * Self);
   end;

const
   SMALL_ANGLE = 0.001;
begin
   NormalizeDegAngle(x);
   NormalizeDegAngle(y);
   NormalizeDegAngle(z);
   case EulerOrder of
      eulXYZ, eulZYX: GimbalLock := Abs(Abs(y) - 90.0) <= cEpsilon30; // cos(Y) = 0;
      eulYXZ, eulZXY: GimbalLock := Abs(Abs(x) - 90.0) <= cEpsilon30; // cos(X) = 0;
      eulXZY, eulYZX: GimbalLock := Abs(Abs(z) - 90.0) <= cEpsilon30; // cos(Z) = 0;
   else
      Assert(False);
      gimbalLock:=False;
   end;
   if gimbalLock then
   begin
      case EulerOrder of
        eulXYZ, eulZYX: quat1 := EulerToQuat(x, y - SMALL_ANGLE, z, EulerOrder);
        eulYXZ, eulZXY: quat1 := EulerToQuat(x - SMALL_ANGLE, y, z, EulerOrder);
        eulXZY, eulYZX: quat1 := EulerToQuat(x, y, z - SMALL_ANGLE, EulerOrder);
      end;
      case EulerOrder of
        eulXYZ, eulZYX: quat2 := EulerToQuat(x, y + SMALL_ANGLE, z, EulerOrder);
        eulYXZ, eulZXY: quat2 := EulerToQuat(x + SMALL_ANGLE, y, z, EulerOrder);
        eulXZY, eulYZX: quat2 := EulerToQuat(x, y, z + SMALL_ANGLE, EulerOrder);
      end;
      Self := Quat1.Slerp(quat2{%H-}, 0.5);
   end
   else
   begin
      Self := EulerToQuat(x, y, z, EulerOrder);
   end;
end;

procedure TGLZQuaternion.ConvertToPoints(var ArcFrom, ArcTo: TGLZAffineVector);
//procedure ConvertToPoints(var ArcFrom, ArcTo: TGLZVector); //overload;
var
   s, invS : Single;
begin
   s:=Self.ImagePart.X*Self.ImagePart.X+Self.ImagePart.Y*Self.ImagePart.Y;
   if s=0 then ArcFrom := AffineVectorMake( 0, 1, 0)
   else
   begin
      invS:=RSqrt(s);
      ArcFrom := AffineVectorMake( -Self.ImagePart.Y*invS, Self.ImagePart.X*invS, 0);
   end;
   ArcTo.X:=Self.RealPart*ArcFrom.X-Self.ImagePart.Z*ArcFrom.Y;
   ArcTo.Y:=Self.RealPart*ArcFrom.Y+Self.ImagePart.Z*ArcFrom.X;
   ArcTo.Z:=Self.ImagePart.X*ArcFrom.Y-Self.ImagePart.Y*ArcFrom.X;
   if Self.RealPart<0 then ArcFrom := AffineVectorMake( -ArcFrom.X, -ArcFrom.Y, 0);
end;


{ Constructs a rotation matrix from (possibly non-unit) quaternion.
   Assumes matrix is used to multiply column vector on the left:
   vnew = mat vold.
   Works correctly for right-handed coordinate system and right-handed rotations. }
//function TGLZQuaternion.ConvertToMatrix : TGLZMatrix;
{ var
   w, x, y, z, xx, xy, xz, xw, yy, yz, yw, zz, zw: Single;
begin
   NormalizeQuaternion(quat);
   w := quat.RealPart;
   x := quat.ImagPart.V[0];
   y := quat.ImagPart.V[1];
   z := quat.ImagPart.V[2];
   xx := x * x;
   xy := x * y;
   xz := x * z;
   xw := x * w;
   yy := y * y;
   yz := y * z;
   yw := y * w;
   zz := z * z;
   zw := z * w;
   Result.V[0].V[0] := 1 - 2 * ( yy + zz );
   Result.V[1].V[0] :=     2 * ( xy - zw );
   Result.V[2].V[0] :=     2 * ( xz + yw );
   Result.V[3].V[0] := 0;
   Result.V[0].V[1] :=     2 * ( xy + zw );
   Result.V[1].V[1] := 1 - 2 * ( xx + zz );
   Result.V[2].V[1] :=     2 * ( yz - xw );
   Result.V[3].V[1] := 0;
   Result.V[0].V[2] :=     2 * ( xz - yw );
   Result.V[1].V[2] :=     2 * ( yz + xw );
   Result.V[2].V[2] := 1 - 2 * ( xx + yy );
   Result.V[3].V[2] := 0;
   Result.V[0].V[3] := 0;
   Result.V[1].V[3] := 0;
   Result.V[2].V[3] := 0;
   Result.V[3].V[3] := 1;
end; }

//function TGLZQuaternion.ConvertToAffineMatrix : TGLZAffineMatrix;
{ var
   w, x, y, z, xx, xy, xz, xw, yy, yz, yw, zz, zw: Single;
begin
   NormalizeQuaternion(quat);
   w := quat.RealPart;
   x := quat.ImagPart.V[0];
   y := quat.ImagPart.V[1];
   z := quat.ImagPart.V[2];
   xx := x * x;
   xy := x * y;
   xz := x * z;
   xw := x * w;
   yy := y * y;
   yz := y * z;
   yw := y * w;
   zz := z * z;
   zw := z * w;
   Result.V[0].V[0] := 1 - 2 * ( yy + zz );
   Result.V[1].V[0] :=     2 * ( xy - zw );
   Result.V[2].V[0] :=     2 * ( xz + yw );
   Result.V[0].V[1] :=     2 * ( xy + zw );
   Result.V[1].V[1] := 1 - 2 * ( xx + zz );
   Result.V[2].V[1] :=     2 * ( yz - xw );
   Result.V[0].V[2] :=     2 * ( xz - yw );
   Result.V[1].V[2] :=     2 * ( yz + xw );
   Result.V[2].V[2] := 1 - 2 * ( xx + yy );
end; }



{$ifdef USE_ASM}
{$ifdef UNIX}
  {$ifdef CPU64}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_quaternion_unix64_avx_imp.inc}
    {$ELSE}
       {$I vectormath_quaternion_unix64_sse_imp.inc}
    {$ENDIF}
  {$else}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_quaternion_unix32_avx_imp.inc}
    {$ELSE}
       {$I vectormath_quaternion_unix32_sse_imp.inc}
    {$ENDIF}
  {$endif}
{$else}
  {$ifdef CPU64}
     {$IFDEF USE_ASM_AVX}
         {$I vectormath_quaternion_win64_avx_imp.inc}
      {$ELSE}
         {$I vectormath_quaternion_win64_sse_imp.inc}
      {$ENDIF}
  {$else}
     {$IFDEF USE_ASM_AVX}
        {$I vectormath_quaternion_win32_avx_imp.inc}
     {$ELSE}
        {$I vectormath_quaternion_win32_sse_imp.inc}
     {$ENDIF}
  {$endif}
{$endif}
{$else}
  {$I vectormath_quaternion_native_imp.inc}
{$endif}

{%endregion%}

{%region%----[ TGLZHmgPlane Helper ]--------------------------------------------}

{ TODO 1 -oASM -cTHmgPlane : Create(point, normal) Add ASM Version }
procedure TGLZVectorHelper.CreatePlane(constref point, normal : TGLZVector);
begin
   Self:=normal;
   Self.W:=-Point.DotProduct(normal);
end;

{ TODO 1 -oASM -cTHmgPlane : CalcPlaneNormal(p1, p2, p3)  Add ASM Version }
procedure TGLZVectorHelper.CalcPlaneNormal(constref p1, p2, p3 : TGLZVector);
var
   v1, v2 : TGLZVector;
begin
   v1:=p2-p1;
   v2:=p3-p1;
   Self:=v1.CrossProduct(v2);
   Self:=Self.Normalize;
end;

{$ifdef USE_ASM}
{$ifdef UNIX}
  {$ifdef CPU64}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_planehelper_unix64_avx_imp.inc}
    {$ELSE}
       {$I vectormath_planehelper_unix64_sse_imp.inc}
    {$ENDIF}
  {$else}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_planehelper_unix32_avx_imp.inc}
    {$ELSE}
       {$I vectormath_planehelper_unix32_sse_imp.inc}
    {$ENDIF}
  {$endif}
{$else}
  {$ifdef CPU64}
     {$IFDEF USE_ASM_AVX}
         {$I vectormath_planehelper_win64_avx_imp.inc}
      {$ELSE}
         {$I vectormath_planehelper_win64_sse_imp.inc}
      {$ENDIF}
  {$else}
     {$IFDEF USE_ASM_AVX}
        {$I vectormath_planehelper_win32_avx_imp.inc}
     {$ELSE}
        {$I vectormath_planehelper_win32_sse_imp.inc}
     {$ENDIF}
  {$endif}
{$endif}
{$else}
 // {$I vectormath_planehelper_native_imp.inc}
{$endif}

{%endregion%}

{%region%----[ TGLZVectorHelper ]-----------------------------------------------}

function TGLZVectorHelper.Rotate(constref axis : TGLZVector; angle : Single):TGLZVector;
var
   rotMatrix : TGLZMatrix;
begin
   rotMatrix.CreateRotationMatrix(axis, Angle);
   Result:=rotMatrix*Self;
end;

function TGLZVectorHelper.RotateAroundX( alpha : Single) : TGLZVector;
var
   c, s : Single;
begin
   SinCos(alpha, s, c);
   Result.X:=Self.X;
   Result.Y:=c*Self.Y+s*Self.Z;
   Result.Z:=c*Self.Z-s*Self.Y;
end;

function TGLZVectorHelper.RotateAroundY(alpha : Single) : TGLZVector;
var
   c, s : Single;
begin
   SinCos(alpha, s, c);
   Result.Y:=Self.Y;
   Result.X:=c*Self.X+s*Self.Z;
   Result.Z:=c*Self.Z-s*Self.X;
end;

function TGLZVectorHelper.RotateAroundZ(alpha : Single) : TGLZVector;
var
   c, s : Single;
begin
   SinCos(alpha, s, c);
   Result.X:=c*Self.X+s*Self.Y;
   Result.Y:=c*Self.Y-s*Self.X;
   Result.Z:=Self.Z;
end;

{ TODO 1 -oASM -cVectorHelper : IsColinear(v2) Add ASM version }
function TGLZVectorHelper.IsColinear(constref v2: TGLZVector) : Boolean;
var
  a, b, c : Single;
begin
  a := Self.DotProduct(Self);
  b := Self.DotProduct(v2);
  c := v2.DotProduct(v2);
  Result :=  (a*c - b*b) < cColinearBias;
end;

function TGLZVectorHelper.MoveAround(constref AMovingObjectUp, ATargetPosition: TGLZVector;pitchDelta, turnDelta: Single): TGLZVector;
var
  originalT2C, normalT2C, normalCameraRight: TGLZVector;
  pitchNow, dist: Single;
begin
    // normalT2C points away from the direction the camera is looking
    originalT2C := Self - ATargetPosition;
    normalT2C := originalT2C;
    dist := normalT2C.Length;
    normalT2C := normalT2C.Normalize;
    // normalRight points to the camera's right
    // the camera is pitching around this axis.
    normalCameraRight := AMovingObjectUp.CrossProduct(normalT2C);
    if normalCameraRight.Length < 0.001 then
      normalCameraRight:= XHmgVector // arbitrary vector
    else
      normalCameraRight := normalCameraRight.Normalize;
    // calculate the current pitch.
    // 0 is looking down and PI is looking up
    pitchNow := ArcCos(AMovingObjectUp.DotProduct(normalT2C));
    pitchNow := GLZUtils.Clamp(pitchNow + DegToRadian(pitchDelta), 0 + 0.025, cPI - 0.025);
    // create a new vector pointing up and then rotate it down
    // into the new position
    normalT2C := AMovingObjectUp;
    normalT2C := normalT2C.Rotate(normalCameraRight, -pitchNow);
    normalT2C := normalT2C.Rotate(AMovingObjectUp, -DegToRadian(turnDelta));
    normalT2C := normalT2C * dist;
    Result := Self + (normalT2C - originalT2C);
end;

{$ifdef USE_ASM}
{$ifdef UNIX}
  {$ifdef CPU64}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_vectorhelper_unix64_avx_imp.inc}
    {$ELSE}
       {$I vectormath_vectorhelper_unix64_sse_imp.inc}
    {$ENDIF}
  {$else}
    {$IFDEF USE_ASM_AVX}
       {$I vectormath_vectorhelper_unix32_avx_imp.inc}
    {$ELSE}
       {$I vectormath_vectorhelper_unix32_sse_imp.inc}
    {$ENDIF}
  {$endif}
{$else}
  {$ifdef CPU64}
     {$IFDEF USE_ASM_AVX}
         {$I vectormath_vectorhelper_win64_avx_imp.inc}
      {$ELSE}
         {$I vectormath_vectorhelper_win64_sse_imp.inc}
      {$ENDIF}
  {$else}
     {$IFDEF USE_ASM_AVX}
        {$I vectormath_vectorhelper_win32_avx_imp.inc}
     {$ELSE}
        {$I vectormath_vectorhelper_win32_sse_imp.inc}
     {$ENDIF}
  {$endif}
{$endif}
{$else}
  {$I vectormath_vectorhelper_native_imp.inc}
{$endif}

function TGLZVectorHelper.ShiftObjectFromCenter(constref ACenter: TGLZVector; const ADistance: Single;const AFromCenterSpot: Boolean):TGLZVector;
var
  lDirection: TGLZVector;
begin
  lDirection := Self - ACenter;
  lDirection := lDirection.Normalize;
  if AFromCenterSpot then Result := ACenter + (lDirection * ADistance)
  else Result := Self + (lDirection * ADistance)
end;

{%endregion%}

{%region%----[ TGLZMatrixHelper ]-----------------------------------------------}

// Turn (Y axis)
function TGLZMatrixHelper.Turn( Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(AffineVectorMake(Self.V[1].V[0], Self.V[1].V[1], Self.V[1].V[2]), Angle);
  Result:=Self * m;
end;

// Turn (direction)
function TGLZMatrixHelper.Turn(constref MasterUp: TGLZVector; Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(MasterUp, Angle);
  Result:=Self * m;
end;

// Pitch (X axis)
function TGLZMatrixHelper.Pitch(Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(AffineVectorMake(Self.V[0].V[0], Self.V[0].V[1], Self.V[0].V[2]), Angle);
  Result:=Self * m;
end;

// Pitch (direction)
function TGLZMatrixHelper.Pitch(constref MasterRight: TGLZVector; Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(MasterRight, Angle);
  Result := Self * m;
end;

// Roll (Z axis)
function TGLZMatrixHelper.Roll(Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(AffineVectorMake(Self.V[2].V[0], Self.V[2].V[1], Self.V[2].V[2]), Angle);
  Result := Self * m;
end;

// Roll (direction)
function TGLZMatrixHelper.Roll(constref MasterDirection: TGLZVector; Angle: Single): TGLZMatrix;
var
  m : TGLZMatrix;
begin
  m.CreateRotationMatrix(MasterDirection, Angle);
  Result := Self * m;
end;

{%endregion%}

{%region%----[ Misc functions ]-------------------------------------------------}

{%endregion%}

{%region%----[ SSE Register States and utils Funcs ]----------------------------}

function get_mxcsr:dword;
var _flags:dword;
begin
     asm    stmxcsr _flags end;
     get_mxcsr:=_flags;
end;

procedure set_mxcsr(flags:dword);
var _flags:dword;
begin
     _flags:=flags;
     asm    ldmxcsr _flags end;
end;

function sse_GetRoundMode: sse_Rounding_Mode;
begin
    Result := sse_Rounding_Mode((get_MXCSR and (sse_MaskNegRound or sse_MaskPosRound)) shr 13);
end;

procedure sse_SetRoundMode(Round_Mode: sse_Rounding_Mode);
begin
 set_mxcsr ((get_mxcsr and sse_no_round_bits_mask) or sse_Rounding_Flags[Round_Mode] );
end;

{%endregion%}

//==============================================================================
var
  oldmxcsr : dword; // FLAGS SSE

initialization
  oldmxcsr:=get_mxcsr;
  set_mxcsr (mxcsr_default);

finalization
  set_mxcsr(oldmxcsr);
End.

