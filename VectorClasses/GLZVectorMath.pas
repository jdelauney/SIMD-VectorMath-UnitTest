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
{.$COPERATORS ON}
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
  Classes, Sysutils, GLZTypes;

Const
  cColorFloatRatio : Single = 1/255;


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
  TGLZVector3bType = packed Array[0..2] of Byte;

  TGLZVector4fType = packed array[0..3] of Single;
  TGLZVector4iType = packed array[0..3] of Longint;
  TGLZVector4bType = packed Array[0..3] of Byte;

  TGLZVector3SwizzleRef = (swDefaultSwizzle3,
    swXXX, swYYY, swZZZ, swXYZ, swXZY, swZYX, swZXY, swYXZ, swYZX,
    swRRR, swGGG, swBBB, swRGB, swRBG, swBGR, swBRG, swGRB, swGBR);

  TGLZVector4SwizzleRef = (swDefaultSwizzle4,
    swXXXX, swYYYY, swZZZZ, swWWWW,
    swXYZW, swXZYW, swZYXW, swZXYW, swYXZW, swYZXW,
    swWXYZ, swWXZY, swWZYX, swWZXY, swWYXZ, swWYZX,
    swRRRR, swGGGG, swBBBB, swAAAA,
    swRGBA, swRBGA, swBGRA, swBRGA, swGRBA, swGBRA,
    swARGB, swARBG, swABGR, swABRG, swAGRB, swAGBR);


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
      2: (Red, Green, Blue: Single);
  End;

  TGLZAffineVector = TGLZVector3f;
  PGLZAffineVector = ^TGLZAffineVector;

  TGLZVector4f =  record  // With packed record the performance decrease a little
  private
    //FSwizzleMode :  TGLZVector4SwizzleRef;
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
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TGLZVector4f;

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
    function AngleBetween(Constref A, ACenterPoint : TGLZVector4f): Single;

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
      2: (Red, Green, Blue, Alpha: Single);
      3: (Left, Top, Right, Bottom: Single);
      4: (ST,UV : TGLZVector2f);
      5: (AsVector3f : TGLZVector3f);
  end;

  TGLZVector = TGLZVector4f;
  PGLZVector = ^TGLZVector;
  PGLZVectorArray = ^TGLZVectorArray;
  TGLZVectorArray = array[0..MAXINT shr 5] of TGLZVector4f;

  TGLZColorVector = TGLZVector;
  PGLZColorVector = ^TGLZColorVector;

  TGLZClipRect = TGLZVector;


  TGLZVector4i = Record
  public
    case Integer of
      0 : (V: TGLZVector4iType);
      1 : (X,Y,Z,W: longint);
  end;

  TGLZVector3b = Record
  private
    //FSwizzleMode : TGLZVector3SwizzleRef;
  public
    procedure Create(Const aX,aY,aZ: Byte); overload;

    function ToString : String;

    class operator +(constref A, B: TGLZVector3b): TGLZVector3b; overload;
    class operator -(constref A, B: TGLZVector3b): TGLZVector3b; overload;
    class operator *(constref A, B: TGLZVector3b): TGLZVector3b; overload;
    class operator Div(constref A, B: TGLZVector3b): TGLZVector3b; overload;

    class operator +(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
    class operator -(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
    class operator *(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
    class operator *(constref A: TGLZVector3b; constref B:Single): TGLZVector3b; overload;
    class operator Div(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;

    class operator =(constref A, B: TGLZVector3b): Boolean;
    class operator <>(constref A, B: TGLZVector3b): Boolean;

    class operator And(constref A, B: TGLZVector3b): TGLZVector3b; overload;
    class operator Or(constref A, B: TGLZVector3b): TGLZVector3b; overload;
    class operator Xor(constref A, B: TGLZVector3b): TGLZVector3b; overload;
    class operator And(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
    class operator or(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
    class operator Xor(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;

    function AsVector3f : TGLZVector3f;

    function Swizzle(Const ASwizzle : TGLZVector3SwizzleRef): TGLZVector3b;

    Case Integer of
      0 : (V:TGLZVector3bType);
      1 : (x,y,z:Byte);
      2 : (Red,Green,Blue:Byte);
  end;

  TGLZVector4b = Record
  private
    //FSwizzleMode : TGLZVector4SwizzleRef;
  public
    procedure Create(Const aX,aY,aZ: Byte; const aW : Byte = 255); overload;
    procedure Create(Const aValue : TGLZVector3b; const aW : Byte = 255); overload;

    function ToString : String;

    class operator +(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    class operator -(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    class operator *(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    class operator Div(constref A, B: TGLZVector4b): TGLZVector4b; overload;

    class operator +(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    class operator -(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    class operator *(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    class operator *(constref A: TGLZVector4b; constref B:Single): TGLZVector4b; overload;
    class operator Div(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;

    class operator =(constref A, B: TGLZVector4b): Boolean;
    class operator <>(constref A, B: TGLZVector4b): Boolean;

    class operator And(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    class operator Or(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    class operator Xor(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    class operator And(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    class operator or(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    class operator Xor(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;

    function DivideBy2 : TGLZVector4b;

    function Min(Constref B : TGLZVector4b):TGLZVector4b; overload;
    function Min(Constref B : Byte):TGLZVector4b; overload;
    function Max(Constref B : TGLZVector4b):TGLZVector4b; overload;
    function Max(Constref B : Byte):TGLZVector4b; overload;
    function Clamp(Constref AMin, AMax : TGLZVector4b):TGLZVector4b; overload;
    function Clamp(Constref AMin, AMax : Byte):TGLZVector4b; overload;

    function MulAdd(Constref B, C : TGLZVector4b):TGLZVector4b;
    function MulDiv(Constref B, C : Byte):TGLZVector4b;

    function GetSwizzleMode : TGLZVector4SwizzleRef;

    function AsVector4f : TGLZVector4f;


    function Shuffle(const x,y,z,w : Byte):TGLZVector4b;
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TGLZVector4b;

    function Combine(constref V2: TGLZVector4b; constref F1: Single): TGLZVector4b;
    function Combine2(constref V2: TGLZVector4b; const F1, F2: Single): TGLZVector4b;
    function Combine3(constref V2, V3: TGLZVector4b; const F1, F2, F3: Single): TGLZVector4b;

    function MinXYZComponent : Byte;
    function MaxXYZComponent : Byte;

    Case Integer of
     0 : (V:TGLZVector4bType);
     1 : (x,y,z,w:Byte);
     2 : (Red,Green,Blue, Alpha:Byte);
     3 : (AsVector3b : TGLZVector3b);
     4 : (AsInteger : Integer);
  end;

{%endregion%}

  { A plane equation.
   Defined by its equation A.x+B.y+C.z+D, a plane can be mapped to the
   homogeneous space coordinates, and this is what we are doing here.
   The typename is just here for easing up data manipulation. }
   TGLZHmgPlane = TGLZVector;
   TGLZFrustum =  record
      pLeft, pTop, pRight, pBottom, pNear, pFar : TGLZHmgPlane;
   end;

{%region%----[ Matrix ]---------------------------------------------------------}

  TGLZMatrixTransType = (ttScaleX, ttScaleY, ttScaleZ,
                ttShearXY, ttShearXZ, ttShearYZ,
                ttRotateX, ttRotateY, ttRotateZ,
                ttTranslateX, ttTranslateY, ttTranslateZ,
                ttPerspectiveX, ttPerspectiveY, ttPerspectiveZ, ttPerspectiveW);

  // used to describe a sequence of transformations in following order:
  // [Sx][Sy][Sz][ShearXY][ShearXZ][ShearZY][Rx][Ry][Rz][Tx][Ty][Tz][P(x,y,z,w)]
  // constants are declared for easier access (see MatrixDecompose below)
  TGLZMatrixTransformations  = array [TGLZMAtrixTransType] of Single;

  TGLZMatrix4f = record
  private
    function GetComponent(const ARow, AColumn: Integer): Single; inline;
    procedure SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
    function GetRow(const AIndex: Integer): TGLZVector; inline;
    procedure SetRow(const AIndex: Integer; const Value: TGLZVector); inline;

    function GetDeterminant: Single;

    function MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
    procedure Transpose_Scale_M33(constref src : TGLZMatrix4f; Constref ascale : Single);
  public
    class operator +(constref A, B: TGLZMatrix4f): TGLZMatrix4f; overload;
    class operator +(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; overload;
    class operator -(constref A, B: TGLZMatrix4f): TGLZMatrix4f; overload;
    class operator -(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; overload;
    class operator *(constref A, B: TGLZMatrix4f): TGLZMatrix4f; overload;
    class operator *(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; overload;
    class operator *(constref A: TGLZMatrix4f; constref B: TGLZVector): TGLZVector; overload;
    class operator /(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; overload;

    class operator -(constref A: TGLZMatrix4f): TGLZMatrix4f; overload;

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

    function Transpose: TGLZMatrix4f;
    //procedure Transpose;
    function Invert : TGLZMatrix4f;
    //procedure Invert;
    function Normalize : TGLZMatrix4f;
    //procedure Normalize;
    procedure Adjoint;
    procedure AnglePreservingMatrixInvert(constref mat : TGLZMatrix4f);

    function Decompose(var Tran: TGLZMatrixTransformations): Boolean;

    function Translate( constref v : TGLZVector):TGLZMatrix4f;
    function Multiply(constref M2: TGLZMatrix4f):TGLZMatrix4f;  //Component-wise multiplication

    //function Lerp(constref m2: TGLZMatrix4f; const Delta: Single): TGLZMatrix4f;

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

  TGLZMatrix = TGLZMatrix4f;
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

{%region%----[ BoundingBox ]----------------------------------------------------}

  TGLZBoundingBox = record
  private
  public
    procedure Create(Const AValue : TGLZVector);

    class operator +(ConstRef A, B : TGLZBoundingBox):TGLZBoundingBox;overload;
    class operator +(ConstRef A: TGLZBoundingBox; ConstRef B : TGLZVector):TGLZBoundingBox;overload;
    class operator =(ConstRef A, B : TGLZBoundingBox):Boolean;overload;

    function Transform(ConstRef M:TGLZMAtrix):TGLZBoundingBox;
    function MinX : Single;
    function MaxX : Single;
    function MinY : Single;
    function MaxY : Single;
    function MinZ : Single;
    function MaxZ : Single;

    Case Integer of
     0 : (Points : Array[0..7] of TGLZVector);
     1 : (pt1, pt2, pt3, pt4 :TGLZVector;
          pt5, pt6, pt7, pt8 :TGLZVector);
  end;

{%endregion%}

  { : Result type for space intersection tests, like AABBContainsAABB or BSphereContainsAABB }
  TGLZSpaceContains = (ScNoOverlap, ScContainsFully, ScContainsPartially);

{%region%----[ BoundingSphere ]-------------------------------------------------}

  TGLZBoundingSphere = record
  public

    procedure Create(Const x,y,z: Single;Const r: single = 1.0); overload;
    procedure Create(Const AValue : TGLZAffineVector;Const r: single = 1.0); overload;
    procedure Create(Const AValue : TGLZVector;Const r: single = 1.0); overload;

    function Contains(const TestBSphere: TGLZBoundingSphere) : TGLZSpaceContains;
    { : Determines if one BSphere intersects another BSphere }
    function Intersect(const TestBSphere: TGLZBoundingSphere): Boolean;

    Case Integer of
          { : Center of Bounding Sphere }
      0 : (Center: TGLZVector;
          { : Radius of Bounding Sphere }
          Radius: Single);
  end;

{%endregion%}

{%region%----[ Axis Aligned BoundingBox ]---------------------------------------}

{ : Structure for storing the corners of an AABB, used with ExtractAABBCorners }
  TGLZAABBCorners = array [0 .. 7] of TGLZVector;

  TGLZAxisAlignedBoundingBox =  record
  public
    procedure Create(const AValue: TGLZVector);
    { : Extract the AABB information from a BB. }
    procedure Create(const ABB: TGLZBoundingBox);

    { : Make the AABB that is formed by sweeping a sphere (or AABB) from Start to Dest }
    procedure CreateFromSweep(const Start, Dest: TGLZVector;const Radius: Single);

    { : Convert a BSphere to the AABB }
    procedure Create(const BSphere: TGLZBoundingSphere); overload;
    procedure Create(const Center: TGLZVector; Radius: Single); overload;


    class operator +(ConstRef A, B : TGLZAxisAlignedBoundingBox):TGLZAxisAlignedBoundingBox;overload;
    class operator +(ConstRef A: TGLZAxisAlignedBoundingBox; ConstRef B : TGLZVector):TGLZAxisAlignedBoundingBox;overload;
    class operator *(ConstRef A: TGLZAxisAlignedBoundingBox; ConstRef B : TGLZVector):TGLZAxisAlignedBoundingBox;overload;
    class operator =(ConstRef A, B : TGLZAxisAlignedBoundingBox):Boolean;overload;

    function Transform(Constref M:TGLZMatrix):TGLZAxisAlignedBoundingBox;
    function Include(Constref P:TGLZVector):TGLZAxisAlignedBoundingBox;
    { : Returns the intersection of the AABB with second AABBs.
      If the AABBs don't intersect, will return a degenerated AABB (plane, line or point). }
    function Intersection(const B: TGLZAxisAlignedBoundingBox): TGLZAxisAlignedBoundingBox;

    { : Converts the AABB to its canonical BB. }
    function ToBoundingBox: TGLZBoundingBox; overload;
    { : Transforms the AABB to a BB. }
    function ToBoundingBox(const M: TGLZMatrix) : TGLZBoundingBox; overload;
    { : Convert the AABB to a BSphere }
    function ToBoundingSphere: TGLZBoundingSphere;

    function ToClipRect(ModelViewProjection: TGLZMatrix; ViewportSizeX, ViewportSizeY: Integer): TGLZClipRect;
    { : Determines if two AxisAlignedBoundingBoxes intersect.
      The matrices are the ones that convert one point to the other's AABB system }
    function Intersect(const B: TGLZAxisAlignedBoundingBox;const M1, M2: TGLZMatrix):Boolean;
    { : Checks whether two Bounding boxes aligned with the world axes collide in the XY plane. }
    function IntersectAbsoluteXY(const B: TGLZAxisAlignedBoundingBox): Boolean;
    { : Checks whether two Bounding boxes aligned with the world axes collide in the XZ plane. }
    function IntersectAbsoluteXZ(const B: TGLZAxisAlignedBoundingBox): Boolean;
    { : Checks whether two Bounding boxes aligned with the world axes collide. }
    function IntersectAbsolute(const B: TGLZAxisAlignedBoundingBox): Boolean;
    { : Checks whether one Bounding box aligned with the world axes fits within
      another Bounding box. }
    function FitsInAbsolute(const B: TGLZAxisAlignedBoundingBox): Boolean;

    { : Checks if a point "p" is inside the AABB }
    function PointIn(const P: TGLZVector): Boolean;

    { : Extract the corners from the AABB }
    function ExtractCorners: TGLZAABBCorners;

    { : Determines to which extent the AABB contains another AABB }
    function Contains(const TestAABB: TGLZAxisAlignedBoundingBox): TGLZSpaceContains; overload;
    { : Determines to which extent the AABB contains a BSphere }
    function Contains(const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains; overload;

    { : Clips a position to the AABB }
    function Clip(const V: TGLZAffineVector): TGLZAffineVector;

    { : Finds the intersection between a ray and an axis aligned bounding box. }
    function RayCastIntersect(const RayOrigin, RayDirection: TGLZVector; out TNear, TFar: Single): Boolean; overload;
    function RayCastIntersect(const RayOrigin, RayDirection: TGLZVector; IntersectPoint: PGLZVector = nil): Boolean; overload;

    Case Integer of
      0 : (Min, Max : TGLZVector);
  end;

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
    //function IsPerpendicular(constref v2: TGLZVector) : Boolean;
    //function IsParallel(constref v2: TGLZVector) : Boolean;

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

    function ExtendClipRect(vX, vY: Single) : TGLZClipRect;
  end;


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

{%region%----[ TGLZBoundingBoxHelper ]------------------------------------------}
{%endregion%}

{%region%----[ TGLZAxisAlignedBoundingBoxHelper ]-------------------------------}
{%endregion%}

{%region%----[ TGLZPlaneHelper AddOns ]-----------------------------------------}
{%endregion%}

{%region%----[ TGLZFrustrumHelper ]---------------------------------------------}
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
  NullVector : TGLZAffineVector = (X:0; Y:0; Z:0);
  // standard homogeneous vectors
  XHmgVector : TGLZVector = (X:1; Y:0; Z:0; W:0);
  YHmgVector : TGLZVector = (X:0; Y:1; Z:0; W:0);
  ZHmgVector : TGLZVector = (X:0; Y:0; Z:1; W:0);
  WHmgVector : TGLZVector = (X:0; Y:0; Z:0; W:1);
  NullHmgVector : TGLZVector = (X:0; Y:0; Z:0; W:0);
  XYHmgVector: TGLZVector = (X: 1; Y: 1; Z: 0; W: 0);
  YZHmgVector: TGLZVector = (X: 0; Y: 1; Z: 1; W: 0);
  XZHmgVector: TGLZVector = (X: 1; Y: 0; Z: 1; W: 0);
  XYZHmgVector: TGLZVector = (X: 1; Y: 1; Z: 1; W: 0);
  XYZWHmgVector: TGLZVector = (X: 1; Y: 1; Z: 1; W: 1);

  // standard homogeneous points
  XHmgPoint :  TGLZVector = (X:1; Y:0; Z:0; W:1);
  YHmgPoint :  TGLZVector = (X:0; Y:1; Z:0; W:1);
  ZHmgPoint :  TGLZVector = (X:0; Y:0; Z:1; W:1);
  WHmgPoint :  TGLZVector = (X:0; Y:0; Z:0; W:1);
  NullHmgPoint : TGLZVector = (X:0; Y:0; Z:0; W:1);

  NegativeUnitVector : TGLZVector = (X:-1; Y:-1; Z:-1; W:-1);



  { @groupend }

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

{%region%----[ Others Const ]---------------------------------------------------}

const
   NullBoundingBox: TGLZBoundingBox =
   (Points:((X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1)));

{%endregion%}

{%region%----[ Misc Vector Helpers functions ]----------------------------------}

function AffineVectorMake(const x, y, z : Single) : TGLZAffineVector;overload;
function AffineVectorMake(const v : TGLZVector) : TGLZAffineVector;overload;


//procedure VectorArrayAdd(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
//procedure VectorArraySub(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
//procedure VectorArrayMul(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
//procedure VectorArrayDiv(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
//procedure VectorArrayLerp(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);
//procedure VectorArrayNormalize(const src : PGLZVectorArray; const delta : TGLZVector4f; const nb : Integer; dest : PGLZVectorArray);


{%endregion%}

{%region%----[ SSE Register States and utils funcs ]----------------------------}

function get_mxcsr:dword;
procedure set_mxcsr(flags:dword);

function sse_GetRoundMode: sse_Rounding_Mode;
procedure sse_SetRoundMode(Round_Mode: sse_Rounding_Mode);

{%endregion%}

Implementation

Uses Math, GLZMath, GLZUtils;

{%region%----[ Internal Types and Const ]---------------------------------------}
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


// ---- Used by Bounding box functions -----------------------------------------

type
  TPlanIndices = array [0 .. 3] of Integer;
  TPlanBB = array [0 .. 5] of TPlanIndices;
  TDirPlan = array [0 .. 5] of Integer;

const
  CBBFront: TPlanIndices = (0, 1, 2, 3);
  CBBBack: TPlanIndices = (4, 5, 6, 7);
  CBBLeft: TPlanIndices = (0, 4, 7, 3);
  CBBRight: TPlanIndices = (1, 5, 6, 2);
  CBBTop: TPlanIndices = (0, 1, 5, 4);
  CBBBottom: TPlanIndices = (2, 3, 7, 6);
  CBBPlans: TPlanBB = ((0, 1, 2, 3), (4, 5, 6, 7), (0, 4, 7, 3), (1, 5, 6, 2),
    (0, 1, 5, 4), (2, 3, 7, 6));
  CDirPlan: TDirPlan = (0, 0, 1, 1, 2, 2);


procedure SetPlanBB(Var A:TGLZBoundingBox;const NumPlan: Integer; const Valeur: Double);
var
  I: Integer;
begin
  for I := 0 to 3 do
  begin
    A.Points[CBBPlans[NumPlan][I]].V[CDirPlan[NumPlan]] := Valeur;
    A.Points[CBBPlans[NumPlan][I]].V[3] := 1;
  end;
end;


//------------------------------------------------------------------------------

{%endregion%}


//-----[ INCLUDE IMPLEMENTATION ]-----------------------------------------------

{$ifdef USE_ASM}
  {$ifdef UNIX}
    {$ifdef CPU64}
      {$IFDEF USE_ASM_AVX}
         {.$I vectormath_vector2f_unix64_avx_imp.inc}
         {.$I vectormath_vector4f_unix64_avx_imp.inc}

         {$I vectormath_vector3b_native_imp.inc}
         {$I vectormath_vector4b_native_imp.inc}

         {$I vectormath_quaternion_unix64_avx_imp.inc}
         {.$I vectormath_matrix_unix64_avx_imp.inc}
         {.$I vectormath_planehelper_unix64_avx_imp.inc}
         {.$I vectormath_vectorhelper_unix64_avx_imp.inc}
      {$ELSE}
         {.$I vectormath_vector2f_unix64_sse_imp.inc}
         {.$I vectormath_vector4f_unix64_sse_imp.inc}
         {$I vectormath_quaternion_unix64_sse_imp.inc}
         {.$I vectormath_matrix_unix64_sse_imp.inc}
         {.$I vectormath_planehelper_unix64_sse_imp.inc}
         {.$I vectormath_vectorhelper_unix64_sse_imp.inc}
      {$ENDIF}
    {$else}
      {$IFDEF USE_ASM_AVX}
         {.$I vectormath_vector2f_unix32_avx_imp.inc}
         {.$I vectormath_vector4f_unix32_avx_imp.inc}
         {$I vectormath_quaternion_unix32_avx_imp.inc}
         {.$I vectormath_matrix_unix32_avx_imp.inc}
         {.$I vectormath_planehelper_unix32_avx_imp.inc}
         {.$I vectormath_vectorhelper_unix32_avx_imp.inc}
      {$ELSE}
         {.$I vectormath_vector2f_unix32_sse_imp.inc}
         {.$I vectormath_vector4f_unix32_sse_imp.inc}
         {$I vectormath_quaternion_unix32_sse_imp.inc}
         {.$I vectormath_matrix_unix32_sse_imp.inc}
         {.$I vectormath_planehelper_unix32_sse_imp.inc}
         {.$I vectormath_vectorhelper_unix32_sse_imp.inc}
      {$ENDIF}
    {$endif}
  {$else}
    {$ifdef CPU64}
       {$IFDEF USE_ASM_AVX}
           {$I vectormath_vector2f_win64_avx_imp.inc}
           {$I vectormath_vector4f_win64_avx_imp.inc}

           {$I vectormath_vector3b_native_imp.inc}
           {$I vectormath_vector4b_native_imp.inc}

           {$I vectormath_quaternion_win64_avx_imp.inc}
           {$I vectormath_matrix_win64_avx_imp.inc}
           {$I vectormath_planehelper_win64_avx_imp.inc}
           {$I vectormath_vectorhelper_win64_avx_imp.inc}
        {$ELSE}
           {$I vectormath_vector2f_native_imp.inc}
           {$I vectormath_vector2f_win64_sse_imp.inc}

           {$I vectormath_vector4f_native_imp.inc}
           {$I vectormath_vector4f_win64_sse_imp.inc}

           {$I vectormath_vector3b_native_imp.inc}
           {$I vectormath_vector4b_native_imp.inc}

           {$I vectormath_quaternion_native_imp.inc}
           {$I vectormath_quaternion_win64_sse_imp.inc}

           {$I vectormath_matrix4f_native_imp.inc}
           {$I vectormath_matrix4f_win64_sse_imp.inc}

           {$I vectormath_boundingbox_native_imp.inc}
           {.$I vectormath_boundingbox_win64_sse_imp.inc}

           {$I vectormath_boundingsphere_native_imp.inc}
           {.$I vectormath_boundingsphere_win64_sse_imp.inc}

           {$I vectormath_axisaligned_boundingbox_native_imp.inc}
           {.$I vectormath_axisaligned_boundingbox_win64_sse_imp.inc}

           {$I vectormath_planehelper_native_imp.inc}
           {$I vectormath_planehelper_win64_sse_imp.inc}

           {$I vectormath_vectorhelper_native_imp.inc}
           {$I vectormath_vectorhelper_win64_sse_imp.inc}

           {$I vectormath_matrixhelper_native_imp.inc}
           {.$I vectormath_matrixhelper_win64_sse_imp.inc}

        {$ENDIF}
    {$else}
       {$IFDEF USE_ASM_AVX}
          {.$I vectormath_vector2f_win32_avx_imp.inc}
          {.$I vectormath_vector4f_win32_avx_imp.inc}
          {$I vectormath_quaternion_win32_avx_imp.inc}
          {.$I vectormath_matrix_win32_avx_imp.inc}
          {.$I vectormath_planehelper_win32_avx_imp.inc}
          {.$I vectormath_vectorhelper_win32_avx_imp.inc}
       {$ELSE}
          {.$I vectormath_vector4f_win32_sse_imp.inc}
          {.$I vectormath_vector4f_win32_sse_imp.inc}
          {$I vectormath_quaternion_win32_sse_imp.inc}
          {.$I vectormath_matrix_win32_sse_imp.inc}
          {.$I vectormath_planehelper_win32_sse_imp.inc}
          {.$I vectormath_vectorhelper_win32_sse_imp.inc}
       {$ENDIF}
    {$endif}
  {$endif}
{$else}
  {$I vectormath_vector2f_native_imp.inc}
  {$I vectormath_vector4f_native_imp.inc}
  {$I vectormath_vector2b_native_imp.inc}
  {$I vectormath_vector4b_native_imp.inc}

  {$I vectormath_quaternion_native_imp.inc}
  {$I vectormath_boundingbox_native_imp.inc}
  {$I vectormath_boundingsphere_native_imp.inc}
  {$I vectormath_axisaligned_boundingbox_native_imp.inc}

  {$I vectormath_matrix_native_imp.inc}

  {$I vectormath_planehelper_native_imp.inc}
  {$I vectormath_vectorhelper_native_imp.inc}
  {$I vectormath_boundingboxhelper_native_imp.inc}
  {$I vectormath_axisaligned_boundingBoxhelper_native_imp.inc}
  {$I vectormath_frustrumhelper_native_imp.inc}
{$endif}


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
 set_mxcsr ((get_mxcsr and sse_no_round_bits_mask) {%H-}or sse_Rounding_Flags[Round_Mode] );
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

