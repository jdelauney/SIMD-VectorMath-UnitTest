(*====< GLZVectorMath.pas >=====================================================@br
@created(2017-11-25)
@author(J.Delauney (BeanzMaster) - Peter Dyson (Dicepd)
Historique : @br
@unorderedList(
  @item(25/11/2017 : Creation  )
)
--------------------------------------------------------------------------------@br
  ------------------------------------------------------------------------------
  Description :
  GLZVectorMath is an optimized vector classes math library for FreePascal and Lazarus
  using SIMD (SSE, SSE3, SS4, AVX, AVX2) acceleration
  It can be used in 2D/3D graphics, computing apps.

  Include :
    Vectors 2,3 and 4 (Byte, Integer, Float), Matrix4f, Quaternion,
    Homogenous Plane, BoundBox,....

  ------------------------------------------------------------------------------
  @bold(Notes :)

  Some links :
   @unorderedList(
       @item(http://forum.lazarus.freepascal.org/index.php/topic,32741.0.html)
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

{$mode objfpc}{$H+}

//-----------------------------
{$ASMMODE INTEL}
{$INLINE ON}
{$MODESWITCH ADVANCEDRECORDS}
//-----------------------------

//----------------------- DATA ALIGNMENT ---------------------------------------
{$ALIGN 16}

{$CODEALIGN CONSTMIN=16}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN VARMIN=16}
//------------------------------------------------------------------------------

// Those options are set in compiler options with the -d command
{.$DEFINE USE_ASM} // use SIMD SSE/SSE2 by default
{.$DEFINE USE_ASM_AVX}
{.$DEFINE USE_ASM_SSE_4}
{.$DEFINE USE_ASM_SSE_3}

// Some function don't have SSE4 instruction, so enable SSE3
{$IFDEF USE_ASM_SSE_4}
  {$DEFINE USE_ASM_SSE_3}
{$ENDIF}

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
  sse_Rounding_Mode = (rmNearestSSE, rmFloorSSE, rmCeilSSE, rmDefaultSSE);

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
  //default setting of the mxscr register ; disable all exception's
  mxcsr_default : dword =sse_MaskInvalidOp or sse_MaskDenorm  or sse_MaskDivZero or sse_MaskOverflow
                      or sse_MaskUnderflow or sse_MaskPrecision or $00000000; //sse_MaskPosRound;
  mxcsr_default_TEST : dword =sse_MaskInvalidOp and sse_MaskDenorm  or sse_MaskDivZero or sse_MaskOverflow
                      or sse_MaskUnderflow or sse_MaskPrecision or $00000000 and sse_MaskZeroFlush; //sse_MaskPosRound;
  //conversion table from rounding mode name to rounding bits
  sse_Rounding_Flags: array [sse_Rounding_Mode] of longint = (0,sse_MaskNegRound,sse_MaskPosRound,0);

  sse_align=16;
  sse_align_mask=sse_align-1;

{%endregion%}

{%region%----[ Vectors ]--------------------------------------------------------}

type
  {$PACKRECORD 16}

  { Aligned array for vector @groupbegin  }
  TGLZVector2fType = packed array[0..1] of Single;
  TGLZVector2iType = packed array[0..1] of Integer;

  TGLZVector3fType = packed array[0..2] of Single;
  TGLZVector3iType = packed Array[0..2] of Longint;
  TGLZVector3bType = packed Array[0..2] of Byte;

  TGLZVector4fType = packed array[0..3] of Single;
  TGLZVector4iType = packed array[0..3] of Longint;
  TGLZVector4bType = packed Array[0..3] of Byte;
  {@groupend}

  { Reference for swizzle (shuffle) vector @groupbegin  }
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
  {@groupend}

  { TGLZVector2i : Simple 2D Integer vector }
  TGLZVector2i = record
  case Byte of
    0: (V: TGLZVector2iType);
    1: (X, Y : Integer);
  end;

  { TGLZVector2f : Advanced 2D Float vector }
  TGLZVector2f =  record
    { Self Create TGLZVector2f }
    procedure Create(aX,aY: single);
    { Return vector as string }
    function ToString : String;

    { Add 2 TGLZVector2f }
    class operator +(constref A, B: TGLZVector2f): TGLZVector2f; overload;
    { Sub 2 TGLZVector2f }
    class operator -(constref A, B: TGLZVector2f): TGLZVector2f; overload;
    { Multiply 2 TGLZVector2f }
    class operator *(constref A, B: TGLZVector2f): TGLZVector2f; overload;
    { Divide 2 TGLZVector2f }
    class operator /(constref A, B: TGLZVector2f): TGLZVector2f; overload;
    { Add one float to one TGLZVector2f }
    class operator +(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;
    { Sub one float to one TGLZVector2f }
    class operator -(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;
    { Mul one float to one TGLZVector2f }
    class operator *(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;
    { Divide one float to one TGLZVector2f }
    class operator /(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;
    { Negate self }
    class operator -(constref A: TGLZVector2f): TGLZVector2f; overload;

    { Compare if two TGLZVector2f are equal }
    class operator =(constref A, B: TGLZVector2f): Boolean;

    { TODO -oGLZVectorMath -cTGLZVector2f : Add comparator operators <=,<=,>,< }
    (*
    class operator >=(constref A, B: TGLZVector2f): Boolean;
    class operator <=(constref A, B: TGLZVector2f): Boolean;
    class operator >(constref A, B: TGLZVector2f): Boolean;
    class operator <(constref A, B: TGLZVector2f): Boolean;
    *)

    { Compare if two TGLZVector are not equal }
    class operator <>(constref A, B: TGLZVector2f): Boolean;

    {Return the minimum of each component in TGLZVector2f between self and another TGLZVector2f }
    function Min(constref B: TGLZVector2f): TGLZVector2f; overload;
    {Return the minimum of each component in TGLZVector2f between self and a float }
    function Min(constref B: Single): TGLZVector2f; overload;
    {Return the maximum of each component in TGLZVector2f between self and another TGLZVector2f }
    function Max(constref B: TGLZVector2f): TGLZVector2f; overload;
    {Return the minimum of each component in TGLZVector2f between self and a float }
    function Max(constref B: Single): TGLZVector2f; overload;

    { Clamp Self beetween a min and a max TGLZVector2f }
    function Clamp(constref AMin, AMax: TGLZVector2f): TGLZVector2f;overload;
    { Clamp each component of Self beatween a min and a max float }
    function Clamp(constref AMin, AMax: Single): TGLZVector2f;overload;
    { Multiply Self by a TGLZVector2f and add an another TGLZVector2f }
    function MulAdd(constref A,B:TGLZVector2f): TGLZVector2f;
    { Multiply Self by a TGLZVector2f and div with an another TGLZVector2f }
    function MulDiv(constref A,B:TGLZVector2f): TGLZVector2f;
    { Return self length }
    function Length:Single;
    { Return self length squared }
    function LengthSquare:Single;
    { Return distance from self to an another TGLZVector2f }
    function Distance(constref A:TGLZVector2f):Single;
    { Return Self distance squared }
    function DistanceSquare(constref A:TGLZVector2f):Single;
    { Return self normalized TGLZVector2f }
    function Normalize : TGLZVector2f;
    { Return the dot product of self and an another TGLZVector2f}
    function DotProduct(A:TGLZVector2f):Single;
    { Return angle between Self and an another TGLZVector2f, relative to a TGLZVector2f as a Center Point }
    function AngleBetween(Constref A, ACenterPoint : TGLZVector2f): Single;
    { Return the angle cosine between Self and an another TGLZVector2f}
    function AngleCosine(constref A: TGLZVector2f): Single;

    // function Reflect(I, NRef : TVector2f):TVector2f

 //   function Edge(ConstRef A, B : TGLZVector2f):Single; // @TODO : a passer dans TGLZVector2fHelper ???

    { Round Self to an TGLZVector2i }
    function Round: TGLZVector2i;
    { Round Truc to an TGLZVector2i }
    function Trunc: TGLZVector2i;

    { Access modes }
    case Byte of
      0: (V: TGLZVector2fType);
      1: (X, Y : Single);
      2: (Width, Height : Single);
  End;

  { TGLZVector3b : Advanced 3D Byte vector }
  TGLZVector3b = Record
    private
    public
      { Self Create TGLZVector3b }
      procedure Create(const aX, aY, aZ: Byte);
      { Return vector as string }
      function ToString : String;

      { Add 2 TGLZVector3b }
      class operator +(constref A, B: TGLZVector3b): TGLZVector3b; overload;
      { Sub 2 TGLZVector3b }
      class operator -(constref A, B: TGLZVector3b): TGLZVector3b; overload;
      { Multiply 2 TGLZVector3b }
      class operator *(constref A, B: TGLZVector3b): TGLZVector3b; overload;
      { Divide 2 TGLZVector3b }
      class operator Div(constref A, B: TGLZVector3b): TGLZVector3b; overload;
      { Add one Byte in each component of a TGLZVector3b }
      class operator +(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
      { Sub one Byte in each component of a TGLZVector3b }
      class operator -(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
      { Multiply one Byte in each component of a TGLZVector3b }
      class operator *(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
      { Multiply one Float in each component of a TGLZVector3b }
      class operator *(constref A: TGLZVector3b; constref B:Single): TGLZVector3b; overload;
      { Divide one Byte in each component of a TGLZVector3b }
      class operator Div(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
      { Compare if two TGLZVector3b are equal }
      class operator =(constref A, B: TGLZVector3b): Boolean;
      { Compare if two TGLZVector3b are not equal }
      class operator <>(constref A, B: TGLZVector3b): Boolean;
      { Operator and two TGLZVector3b }
      class operator And(constref A, B: TGLZVector3b): TGLZVector3b; overload;
      { Operator or two TGLZVector3b }
      class operator Or(constref A, B: TGLZVector3b): TGLZVector3b; overload;
      { Operator xor two TGLZVector3b }
      class operator Xor(constref A, B: TGLZVector3b): TGLZVector3b; overload;
      { Operator and one TGLZVector3b and one Byte }
      class operator And(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
      { Operator or one TGLZVector3b and one Byte }
      class operator or(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
      { Operator xor one TGLZVector3b and one Byte }
      class operator Xor(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;

      { Return swizzle (shuffle) components of self }
      function Swizzle(Const ASwizzle : TGLZVector3SwizzleRef): TGLZVector3b;

      { Access modes }
      Case Byte of
        0 : (V:TGLZVector3bType);
        1 : (X, Y, Z:Byte);
        2 : (Red, Green, Blue:Byte);
    end;

  { TGLZVector3i : Simple 3D Integer vector }
  TGLZVector3i = record
  case Byte of
    0: (V: TGLZVector3iType);
    1: (X, Y, Z : Integer);
    2: (Red, Green, Blue : Integer);
  end;

  { TGLZVector3f : Simple 3D Float vector }
  TGLZVector3f =  record
    case Byte of
      0: (V: TGLZVector3fType);
      1: (X, Y, Z: Single);
      2: (Red, Green, Blue: Single);
  End;

  { Just for convenience }
  TGLZAffineVector = TGLZVector3f;
  PGLZAffineVector = ^TGLZAffineVector;

  { TGLZVector4b : Advanced 4D Byte vector }
  TGLZVector4b = Record
  private

  public
    { Self Create TGLZVector4b from x,y,z,w value }
    procedure Create(Const aX,aY,aZ: Byte; const aW : Byte = 255); overload;
    { Self Create TGLZVector4b from a TGLZVector3b and w value }
    procedure Create(Const aValue : TGLZVector3b; const aW : Byte = 255); overload;
    { Return vector as string }
    function ToString : String;

    { Add 2 TGLZVector4b }
    class operator +(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    { Sub 2 TGLZVector4b }
    class operator -(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    { Multiply 2 TGLZVector4b }
    class operator *(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    { Divide 2 TGLZVector4b }
    class operator Div(constref A, B: TGLZVector4b): TGLZVector4b; overload;

    { Add one Byte to each component of a TGLZVector4b }
    class operator +(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    { Sub one Byte to each component of a TGLZVector4b }
    class operator -(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    { Multiply each component of a TGLZVector4b by one Byte }
    class operator *(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    { Multiply each componentof a TGLZVector4b by one Float}
    class operator *(constref A: TGLZVector4b; constref B:Single): TGLZVector4b; overload;
    { Divide each component of a TGLZVector4bby one Byte }
    class operator Div(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;

    { Compare if two TGLZVector4b are equal }
    class operator =(constref A, B: TGLZVector4b): Boolean;
    { Compare if two TGLZVector4b are not equal }
    class operator <>(constref A, B: TGLZVector4b): Boolean;

    { Operator and two TGLZVector4b }
    class operator And(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    { Operator Or two TGLZVector4b }
    class operator Or(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    { Operator Xor two TGLZVector4b }
    class operator Xor(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    { Operator and one TGLZVector4b and one Byte }
    class operator And(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    { Operator or one TGLZVector4b and one Byte }
    class operator or(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    { Operator xor one TGLZVector4b and one Byte }
    class operator Xor(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;

    { Fast self divide by 2 }
    function DivideBy2 : TGLZVector4b;
    { Return the minimum of each component in TGLZVector4b between self and another TGLZVector4b }
    function Min(Constref B : TGLZVector4b):TGLZVector4b; overload;
    { Return the minimum of each component in TGLZVector4b between self and a float }
    function Min(Constref B : Byte):TGLZVector4b; overload;
    { Return the maximum of each component in TGLZVector4b between self and another TGLZVector4b }
    function Max(Constref B : TGLZVector4b):TGLZVector4b; overload;
    { Return the maximum of each component in TGLZVector4b between self and a float }
    function Max(Constref B : Byte):TGLZVector4b; overload;
    { Clamp Self between a min and a max TGLZVector4b }
    function Clamp(Constref AMin, AMax : TGLZVector4b):TGLZVector4b; overload;
    { Clamp each component of Self between a min and a max float }
    function Clamp(Constref AMin, AMax : Byte):TGLZVector4b; overload;
    { Multiply Self by a TGLZVector4b and add an another TGLZVector4b }
    function MulAdd(Constref B, C : TGLZVector4b):TGLZVector4b;
    { Multiply Self by a TGLZVector4b and div by an another TGLZVector4b }
    function MulDiv(Constref B, C : TGLZVector4b):TGLZVector4b;

    { Return shuffle components of self following params orders }
    function Shuffle(const x,y,z,w : Byte):TGLZVector4b;
    { Return swizzle (shuffle) components of self from  TGLZVector4SwizzleRef mask }
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TGLZVector4b;

    { Return Combine = Self + (V2 * F1) }
    function Combine(constref V2: TGLZVector4b; constref F1: Single): TGLZVector4b;
    { Return Combine2 = (Self * F1) + (V2 * F2) }
    function Combine2(constref V2: TGLZVector4b; const F1, F2: Single): TGLZVector4b;
    { Return Combine3 = (Self * F1) + (V2 * F2) + (V3 * F3) }
    function Combine3(constref V2, V3: TGLZVector4b; const F1, F2, F3: Single): TGLZVector4b;

    { Return the minimum component value in XYZ }
    function MinXYZComponent : Byte;
    { Return the maximum component value in XYZ }
    function MaxXYZComponent : Byte;

    { Access modes }
    Case Integer of
     0 : (V:TGLZVector4bType);
     1 : (X, Y, Z, W:Byte);
     2 : (Red, Green, Blue,  Alpha:Byte);
     3 : (AsVector3b : TGLZVector3b);
     4 : (AsInteger : Integer);
  end;

  { TGLZVector4i : Advanced 4D Integer vector }
  TGLZVector4i = Record
  public
    { Self Create TGLZVector4i from x,y,z,w value }
    procedure Create(Const aX,aY,aZ: Longint; const aW : Longint = 0); overload;
    { Self Create TGLZVector4i from a TGLZVector3i and w value }
    procedure Create(Const aValue : TGLZVector3i; const aW : Longint = 0); overload;
    { Self Create TGLZVector4i from a TGLZVector3b and w value }
    procedure Create(Const aValue : TGLZVector3b; const aW : Longint = 0); overload;

    //procedure Create(Const aX,aY,aZ: Longint); overload; @TODO ADD as Affine creation
    //procedure Create(Const aValue : TGLZVector3i); overload;
    //procedure Create(Const aValue : TGLZVector3b); overload;

    { Return vector as string }
    function ToString : String;

    { Add 2 TGLZVector4i }
    class operator +(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    { Sub 2 TGLZVector4i }
    class operator -(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    { Multiply 2 TGLZVector4i }
    class operator *(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    { Divide 2 TGLZVector4i }
    class operator Div(constref A, B: TGLZVector4i): TGLZVector4i; overload;

    { Add one Int to each component of a TGLZVector4i }
    class operator +(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; overload;
    { Sub one Int to each component of a TGLZVector4i }
    class operator -(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; overload;
    { Multiply one Int to each component of a TGLZVector4i }
    class operator *(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; overload;
    { Multiply one Float to each component of a TGLZVector4i }
    class operator *(constref A: TGLZVector4i; constref B:Single): TGLZVector4i; overload;
    { Divide each component of a TGLZVector4i by one Int}
    class operator Div(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; overload;

    { Negate Self}
    class operator -(constref A: TGLZVector4i): TGLZVector4i; overload;

    { Compare if two TGLZVector4i are equal }
    class operator =(constref A, B: TGLZVector4i): Boolean;
    { Compare if two TGLZVector4i are not equal }
    class operator <>(constref A, B: TGLZVector4i): Boolean;

    (* class operator And(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    class operator Or(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    class operator Xor(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    class operator And(constref A: TGLZVector4i; constref B:LongInt): TGLZVector4i; overload;
    class operator or(constref A: TGLZVector4i; constref B:LongInt): TGLZVector4i; overload;
    class operator Xor(constref A: TGLZVector4i; constref B:LongInt): TGLZVector4i; overload; *)

    { Fast self divide by 2 }
    function DivideBy2 : TGLZVector4i;
    { Return absolute value of self }
    function Abs: TGLZVector4i;
    { Return the minimum of each component in TGLZVector4i between self and another TGLZVector4i }
    function Min(Constref B : TGLZVector4i):TGLZVector4i; overload;
    { Return the minimum of each component in TGLZVector4i between self and a float }
    function Min(Constref B : LongInt):TGLZVector4i; overload;
    { Return the maximum of each component in TGLZVector4i between self and another TGLZVector4i }
    function Max(Constref B : TGLZVector4i):TGLZVector4i; overload;
    { Return the maximum of each component in TGLZVector4i between self and a float }
    function Max(Constref B : LongInt):TGLZVector4i; overload;
    { Clamp Self between a min and a max TGLZVector4i }
    function Clamp(Constref AMin, AMax : TGLZVector4i):TGLZVector4i; overload;
    { Clamp each component of Self between a min and a max float }
    function Clamp(Constref AMin, AMax : LongInt):TGLZVector4i; overload;

    { Multiply Self by a TGLZVector4i and Add an another TGLZVector4i }
    function MulAdd(Constref B, C : TGLZVector4i):TGLZVector4i;
    { Multiply Self by a TGLZVector4b and Divide by an another TGLZVector4b }
    function MulDiv(Constref B, C : TGLZVector4i):TGLZVector4i;

    { Return shuffle components of self following params orders }
    function Shuffle(const x,y,z,w : Byte):TGLZVector4i;
    //function Shuffle(Constref A : TGLZVector4i; const x,y,z,w : Byte):TGLZVector4i; overload; ????

    { Return swizzle (shuffle) components of self from  TGLZVector4SwizzleRef mask }
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TGLZVector4i;

    { Return Combine = Self  + (V2 * F2) }
    function Combine(constref V2: TGLZVector4i; constref F1: Single): TGLZVector4i;
    { Return Combine2 = (Self * F1) + (V2 * F2) }
    function Combine2(constref V2: TGLZVector4i; const F1, F2: Single): TGLZVector4i;
    { Return Combine3 = (Self * F1) + (V2 * F2) + (V3 * F3) }
    function Combine3(constref V2, V3: TGLZVector4i; const F1, F2, F3: Single): TGLZVector4i;

    { Return the minimum component value in XYZ }
    function MinXYZComponent : LongInt;
    { Return the maximum component value in XYZ }
    function MaxXYZComponent : LongInt;

    { Access Modes }
    case Byte of
      0 : (V: TGLZVector4iType);
      1 : (X,Y,Z,W: longint);
      2 : (Red, Green, Blue, Alpha : Longint);
      3 : (AsVector3i : TGLZVector3i);   //change name for AsAffine ?????
      4 : (ST,UV : TGLZVector2i);
      5 : (Left, Top, Right, Bottom: Longint);
      6 : (TopLeft,BottomRight : TGLZVector2i);
  end;

  { TGLZVector4f : Advanced 4D Float vector }
  TGLZVector4f =  record
  public
    { Self Create TGLZVector4f from x,y,z and w value set by default to 0.0}
    procedure Create(Const aX,aY,aZ: single; const aW : Single = 0); overload;
    { Self Create TGLZVector4f from a TGLZVector3f and w value set by default to 1.0 }
    procedure Create(Const anAffineVector: TGLZVector3f; const aW : Single = 1); overload;

    { Return vector as string }
    function ToString : String;

    { Add 2 TGLZVector4f }
    class operator +(constref A, B: TGLZVector4f): TGLZVector4f; overload;
    { Sub 2 TGLZVector4f }
    class operator -(constref A, B: TGLZVector4f): TGLZVector4f; overload;
    { Multiply 2 TGLZVector4f }
    class operator *(constref A, B: TGLZVector4f): TGLZVector4f; overload;
    { Divide 2 TGLZVector4f }
    class operator /(constref A, B: TGLZVector4f): TGLZVector4f; overload;

    { Add one Float to each component of a TGLZVector4f }
    class operator +(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;
    { Sub one Float to each component of a TGLZVector4f }
    class operator -(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;
    { Multiply one Float to each component of a TGLZVector4f }
    class operator *(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;
    { Divide each component of a TGLZVector4f by one Float}
    class operator /(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;

    { Negate Self }
    class operator -(constref A: TGLZVector4f): TGLZVector4f; overload;

    { Compare if two TGLZVector4f are equal }
    class operator =(constref A, B: TGLZVector4f): Boolean;
    { Compare if two TGLZVector4f are greater or equal }
    class operator >=(constref A, B: TGLZVector4f): Boolean;
    { Compare if two TGLZVector4f are less or equal }
    class operator <=(constref A, B: TGLZVector4f): Boolean;
    { Compare if two TGLZVector4f are greater }
    class operator >(constref A, B: TGLZVector4f): Boolean;
    { Compare if two TGLZVector4f are less }
    class operator <(constref A, B: TGLZVector4f): Boolean;
    { Compare if two TGLZVector4f are not equal }
    class operator <>(constref A, B: TGLZVector4f): Boolean;

    (* class operator And(constref A, B: TGLZVector4f.): TGLZVector4f.; overload;
    class operator Or(constref A, B: TGLZVector4f.): TGLZVector4f.; overload;
    class operator Xor(constref A, B: TGLZVector4f.): TGLZVector4f.; overload;
    class operator And(constref A: TGLZVector4f.; constref B:Single): TGLZVector4f.; overload;
    class operator or(constref A: TGLZVector4f.; constref B:Single): TGLZVector4f.; overload;
    class operator Xor(constref A: TGLZVector4f.; constref B:Single): TGLZVector4f.; overload; *)

    { Return shuffle components of self following params orders }
    function Shuffle(const x,y,z,w : Byte):TGLZVector4f;
    { Return swizzle (shuffle) components of self from  TGLZVector4SwizzleRef mask }
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TGLZVector4f;

    { Return the minimum component value in XYZ }
    function MinXYZComponent : Single;
    { Return the maximum component value in XYZ }
    function MaxXYZComponent : Single;

    { Return absolute value of self }
    function Abs:TGLZVector4f;overload;

    { Negate }
    function Negate:TGLZVector4f;

    { Fast Self Divide by 2 }
    function DivideBy2:TGLZVector4f;

    { Return self length }
    function Length:Single;
    { Return self length squared }
    function LengthSquare:Single;
    { Return Distance from self to A }
    function Distance(constref A: TGLZVector4f):Single;
    { Return Distance squared from self to A }
    function DistanceSquare(constref A: TGLZVector4f):Single;
    { Calculates Abs(v1[x]-v2[x])+Abs(v1[y]-v2[y])+..., also know as "Norm1". }
    function Spacing(constref A: TGLZVector4f):Single;
    { Return the Dot product of self and an another TGLZVector4f}
    function DotProduct(constref A: TGLZVector4f):Single;
    { Return the Cross product of self and an another TGLZVector2f}
    function CrossProduct(constref A: TGLZVector4f): TGLZVector4f;
    { Return self normalized TGLZVector4f }
    function Normalize: TGLZVector4f;
    { Return normal }
    function Norm:Single;

    { Return the minimum of each component in TGLZVector4f between self and another TGLZVector4f }
    function Min(constref B: TGLZVector4f): TGLZVector4f; overload;
    { Return the minimum of each component in TGLZVector4f between self and a float }
    function Min(constref B: Single): TGLZVector4f; overload;
    { Return the maximum of each component in TGLZVector4f between self and another TGLZVector4f }
    function Max(constref B: TGLZVector4f): TGLZVector4f; overload;
    { Return the maximum of each component in TGLZVector4f between self and a float }
    function Max(constref B: Single): TGLZVector4f; overload;
    { Clamp Self beetween a min and a max TGLZVector4f }
    function Clamp(Constref AMin, AMax: TGLZVector4f): TGLZVector4f; overload;
    { Clamp each component of Self beatween a min and a max float }
    function Clamp(constref AMin, AMax: Single): TGLZVector4f; overload;

    { Multiply Self by a TGLZVector4f and Add an another TGLZVector4f }
    function MulAdd(Constref B, C: TGLZVector4f): TGLZVector4f;
    { Multiply Self by a TGLZVector4f and Divide by an another TGLZVector4f }
    function MulDiv(Constref B, C: TGLZVector4f): TGLZVector4f;

    { Return linear interpolate value at T between self and B }
    function Lerp(Constref B: TGLZVector4f; Constref T:Single): TGLZVector4f;

    { Return the angle cosine between Self and an another TGLZVector4f}
    function AngleCosine(constref A : TGLZVector4f): Single;
    { Return angle between Self and an another TGLZVector4f, relative to a TGLZVector4f as a Center Point }
    function AngleBetween(Constref A, ACenterPoint : TGLZVector4f): Single;

    { Return Combine3 = Self + (V2 * F2)}
    function Combine(constref V2: TGLZVector4f; constref F1: Single): TGLZVector4f;
    { Return Combine2 = (Self * F1) + (V2 * F2) }
    function Combine2(constref V2: TGLZVector4f; const F1, F2: Single): TGLZVector4f;
    { Return Combine3 = (Self * F1) + (V2 * F2) + (V3 * F3) }
    function Combine3(constref V2, V3: TGLZVector4f; const F1, F2, F3: Single): TGLZVector4f;

    { Round Self to an TGLZVector4i }
    function Round: TGLZVector4i;
    { Trunc Self to an TGLZVector4i }
    function Trunc: TGLZVector4i;

    { ALL PROCEDURE ABOVE WILL BE ERASED }
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


    { Access modes }
    case Byte of
      0: (V: TGLZVector4fType);
      1: (X, Y, Z, W: Single);
      2: (Red, Green, Blue, Alpha: Single);
      3: (AsVector3f : TGLZVector3f);   //change name for AsAffine ?????
      4: (ST,UV : TGLZVector2f);
      5: (Left, Top, Right, Bottom: Single);
      6: (TopLeft,BottomRight : TGLZVector2f);

  end;

  { Spelling convenience for vector4f }
  TGLZVector = TGLZVector4f;
  PGLZVector = ^TGLZVector;
  PGLZVectorArray = ^TGLZVectorArray;
  TGLZVectorArray = array[0..MAXINT shr 5] of TGLZVector4f;

  TGLZColorVector = TGLZVector;
  PGLZColorVector = ^TGLZColorVector; // Make Independant like TGLZHmgPlane ?????

  TGLZClipRect = TGLZVector;

{%endregion%}

{%region%----[ Plane ]----------------------------------------------------------}

 { A plane equation.
   Defined by its equation A.x+B.y+C.z+D, a plane can be mapped to the
   homogeneous space coordinates, and this is what we are doing here.
   The plane is normalized so in effect contains unit normal in ABC (XYZ)
   and distance from origin to plane.
   Create(Point, Normal) will allow non unit vectors but basically don't
   do it. A non unit vector WILL calculate the wrong distance to the plane.
   It is a fast way to create a plane when we have a point and a
   normal without yet another sqrt call.
   }

  TGLZHmgPlane = record
  private
    procedure CalcNormal(constref p1, p2, p3 : TGLZVector);
  public
    procedure Create(constref point, normal : TGLZVector); overload;
    procedure Create(constref p1, p2, p3 : TGLZVector); overload;
    procedure Normalize;
    function Normalized : TGLZHmgPlane;
    function AbsDistance(constref point : TGLZVector) : Single;
    function Distance(constref point : TGLZVector) : Single; overload;
    function Distance(constref Center : TGLZVector; constref Radius:Single) : Single; overload;

    { Calculates a vector perpendicular to P.
     self is assumed to be of unit length, subtract out any component parallel to Self }
    function Perpendicular(constref P : TGLZVector4f) : TGLZVector4f;

    { Reflects vector V against Self (assumes self is normalized) }
    function Reflect(constref V: TGLZVector4f): TGLZVector4f;

    function IsInHalfSpace(constref point: TGLZVector) : Boolean;

    case Byte of
       0: (V: TGLZVector4fType);         // should have type compat with other vector4f
       1: (A, B, C, D: Single);          // Plane Parameter access
       2: (AsNormal3: TGLZAffineVector); // super quick descriptive access to Normal as Affine Vector.
       3: (AsVector: TGLZVector);
       4: (X, Y, Z, W: Single);          // legacy access so existing code works
  end;

{%endregion%}

{%region%----[ Frustrum ]-------------------------------------------------------}

  TGLZFrustum =  record
    pLeft, pTop, pRight, pBottom, pNear, pFar : TGLZHmgPlane;
 end;

{%endregion%}

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

  TGLZEulerOrder = (eulXYZ, eulXZY, eulYXZ, eulYZX, eulZXY, eulZYX);
  TGLZQuaternion = record
  private
  public
    { Returns quaternion product qL * qR.
       Note: order is important!
    }
    class operator *(constref A, B: TGLZQuaternion): TGLZQuaternion;
    class operator =(constref A, B: TGLZQuaternion): Boolean;
    class operator <>(constref A, B: TGLZQuaternion): Boolean;

    function ToString : String;

    procedure Create(x,y,z: Single; Real : Single);overload;
    // Creates a quaternion from the given values
    procedure Create(const Imag: array of Single; Real : Single); overload;

    // Constructs a unit quaternion from two unit vectors
    procedure Create(const V1, V2: TGLZAffineVector); overload;

    // Constructs a unit quaternion from two unit vectors or two points or on unit sphere
    procedure Create(const V1, V2: TGLZVector); overload;

    // Constructs a unit quaternion from a rotation matrix
    procedure Create(const mat : TGLZMatrix); overload;

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
    function ConvertToMatrix : TGLZMatrix;

    { Constructs an affine rotation matrix from (possibly non-unit) quaternion. }
    //function ConvertToAffineMatrix : TGLZAffineMatrix;

    // Returns the conjugate of a quaternion
    function Conjugate : TGLZQuaternion;

    // Returns the magnitude of the quaternion
    function Magnitude : Single;

    // Normalizes the given quaternion
    procedure Normalize;

    // Applies rotation to V around local axes.
    function Transform(constref V: TGLZVector): TGLZVector;

    { if a scale factor is applied to a quaternion then the rotation will
    scale vectors when transforming them. Assumes quaternion is already normalized}
    procedure Scale(ScaleVal: single);


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

    function ToString: String;

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
    procedure Create(const AValue: TGLZVector);overload;
    procedure Create(const AMin, AMax: TGLZVector);overload;

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
    { : Returns given vector rotated around arbitrary axis (alpha is in rad, , use Pure Math Model)
      We are using right hand rule coordinate system
      Positive rotations are anticlockwise with postive axis toward you
      Posiitve rotations are clockwise viewed from origin along positive axis
        - Axis orientation to view positives in Upper Right quadrant [as graph axes]
        - with +Z pointing at you (as screen) positive X is to the right positive Y is Up
        - with +Y pointing at you positive Z is to the right positive X is Up
        - with +X pointing at you positive Y is to the left positive Z is up
    }
    function Rotate(constref axis : TGLZVector; angle : Single):TGLZVector;
    // Returns given vector rotated around the X axis (alpha is in rad, use Pure Math Model)
    function RotateWithMatrixAroundX(alpha : Single) : TGLZVector;
    // Returns given vector rotated around the Y axis (alpha is in rad, use Pure Math Model)
    function RotateWithMatrixAroundY(alpha : Single) : TGLZVector;
    // Returns given vector rotated around the Z axis (alpha is in rad, use Pure Math Model)
    function RotateWithMatrixAroundZ(alpha : Single) : TGLZVector;

    { : Returns given vector rotated around the X axis (alpha is in rad)
      - With +X pointing at you positive Y is to the left positive Z is Up.
        Positive rotation around x, Y becomes negative
    }
    function RotateAroundX(alpha : Single) : TGLZVector;

    { : Returns given vector rotated around the Y axis (alpha is in rad)
      - With +Y pointing at you positive Z is to the right positive X is Up.
        Positive rotation around y, Z becomes negative
    }
    function RotateAroundY(alpha : Single) : TGLZVector;

    { : Returns given vector rotated around the Z axis (alpha is in rad)
      - With +Z pointing at you (as screen) positive X is to the right positive Y is Up.
        Positive rotation around z, X becomes negative
    }
    function RotateAroundZ(alpha : Single) : TGLZVector;

    // Self is the point
    function PointProject(constref origin, direction : TGLZVector4f) : Single;


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

    { Extracted from Camera.MoveAroundTarget(pitch, turn). pitch and turn in deg }
    function MoveAround(constref AMovingObjectUp, ATargetPosition: TGLZVector; pitchDelta, turnDelta: Single): TGLZVector;

    { AOriginalPosition - Object initial position.
       ACenter - some point, from which is should be distanced.

       ADistance + AFromCenterSpot - distance, which object should keep from ACenter
       or
       ADistance + not AFromCenterSpot - distance, which object should shift from his current position away from center.
    }
    function ShiftObjectFromCenter(Constref ACenter: TGLZVector; const ADistance: Single; const AFromCenterSpot: Boolean): TGLZVector;

    function AverageNormal4(constref up, left, down, right: TGLZVector): TGLZVector;

    { : Extend a TGLZClipRect. Is a screen coord biased rect Top < Bottom, Left < Right
      (Left, Top, Right, Bottom: Single)
    }
    function ExtendClipRect(vX, vY: Single) : TGLZClipRect;

    {  : Implement a step function returning either zero or one.
      Implements a step function returning one for each component of Self that is
      greater than or equal to the corresponding component in the reference
      vector B, and zero otherwise.
      see : http://developer.download.nvidia.com/cg/step.html
    }
    function Step(ConstRef B : TGLZVector4f):TGLZVector4f;

    { : Returns a normal as-is if a vertex's eye-space position vector points in the opposite direction of a geometric normal, otherwise return the negated version of the normal
      Self = Peturbed normal vector.
      A = Incidence vector (typically a direction vector from the eye to a vertex).
      B = Geometric normal vector (for some facet the peturbed normal belongs).
      see : http://developer.download.nvidia.com/cg/faceforward.html
    }
    function FaceForward(constref A, B: TGLZVector4f): TGLZVector4f;

    { : Returns smallest integer not less than a scalar or each vector component.
      Returns Self saturated to the range [0,1] as follows:

      1) Returns 0 if Self is less than 0; else
      2) Returns 1 if Self is greater than 1; else
      3) Returns Self otherwise.

      For vectors, the returned vector contains the saturated result of each element
      of the vector Self saturated to [0,1].
      see : http://developer.download.nvidia.com/cg/saturate.html
    }
    function Saturate : TGLZVector4f;

    { : Interpolate smoothly between two input values based on a third
      Interpolates smoothly from 0 to 1 based on Self compared to a and b.
      1) Returns 0 if Self < a < b or Self > a > b
      1) Returns 1 if Self < b < a or Self > b > a
      3) Returns a value in the range [0,1] for the domain [a,b].

      if A = Self
      The slope of Self.smoothstep(a,b) and b.smoothstep(a,b) is zero.

      For vectors, the returned vector contains the smooth interpolation of each
      element of the vector x.
      see : http://developer.download.nvidia.com/cg/smoothstep.html
    }
    function SmoothStep(ConstRef A,B : TGLZVector4f): TGLZVector4f;
  end;

{%endregion%}

{%region%----[ TGLZHmgPlaneHelper ]---------------------------------------------}

  // for functions where we use types not declared before TGLZHmgPlane
  TGLZHmgPlaneHelper = record helper for TGLZHmgPlane
  public
    function Contains(const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;
    function PlaneContains(const Location, Normal: TGLZVector; const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;
  end;

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

{%region%----[ TGLZFrustrumHelper ]---------------------------------------------}

 (* TGLZFrustumHelper = record helper for TGLZFrustum
  public
    function Contains(const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;overload;
    // see http://www.flipcode.com/articles/article_frustumculling.shtml
    function Contains(const TestAABB: TGLZAxisAlignedBoundingBox) : TGLZSpaceContains;overload;
  end; *)
{%endregion%}

{%region%----[ Vectors Const ]--------------------------------------------------}

Const
  NullVector2f   : TGLZVector2f = (x:0;y:0);


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

// To place in new unit : GLZVectorMathUtils  ?????

function AffineVectorMake(const x, y, z : Single) : TGLZAffineVector;overload;
function AffineVectorMake(const v : TGLZVector) : TGLZAffineVector;overload;


//function MakeVector(Const aX,aY,aZ: single; const aW : Single = 0):TGLZVector4f; overload;
//function MakeVector(Const anAffineVector: TGLZVector3f; const aW : Single = 1):TGLZVector4f; overload;
//function MakeAffineVector(Const aX,aY,aZ: single):TGLZVector3f; overload;


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

     { SSE rounding modes (bits in MXCSR register) }
//  cSSE_ROUND_MASK         : DWord = $FFFF9FFF;
  cSSE_ROUND_MASK         : DWord = $00009FFF;   // never risk a stray bit being set in MXCSR reserved
  cSSE_ROUND_MASK_NEAREST : DWord = $00000000;
  cSSE_ROUND_MASK_TRUNC   : DWord = $00006000;

//  SSE_ROUND_DOWN    = $00002000;
//  SSE_ROUND_UP      = $00004000;

  cNullVector4f   : TGLZVector = (x:0;y:0;z:0;w:0);
  cNullVector4i   : TGLZVector4i = (x:0;y:0;z:0;w:0);
  cOneVector4f    : TGLZVector = (x:1;y:1;z:1;w:1);
  cOneMinusVector4f    : TGLZVector = (x:-1;y:-1;z:-1;w:-1);
  cNegateVector4f_PNPN    : TGLZVector = (x:1;y:-1;z:1;w:-1);
  cWOneVector4f   : TGLZVector = (x:0;y:0;z:0;w:1);
  cWOneSSEVector4f : TGLZVector = (X:0; Y:0; Z:0; W:1);

  cHalfOneVector4f    : TGLZVector  = (X:0.5; Y:0.5; Z:0.5; W:0.5); //  00800000h,00800000h,00800000h,00800000h

{$IFDEF USE_ASM}
  cSSE_MASK_ABS    : array [0..3] of UInt32 = ($7FFFFFFF, $7FFFFFFF, $7FFFFFFF, $7FFFFFFF);
  cSSE_MASK_NEGATE : array [0..3] of UInt32 = ($80000000, $80000000, $80000000, $80000000);
  cSSE_MASK_ONE :    array [0..3] of UInt32 = ($00000001, $00000001, $00000001, $00000001);
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

// ---- Used by ASM Round & Trunc functions ------------------------------------
var
  _bakMXCSR, _tmpMXCSR : DWord;

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

Var
  _oldMXCSR: DWord; // FLAGS SSE

//-----[ INCLUDE IMPLEMENTATION ]-----------------------------------------------

{$ifdef USE_ASM}
  {$ifdef CPU64}
    {$ifdef UNIX}
      {$IFDEF USE_ASM_AVX}

         {$I vectormath_vector2f_native_imp.inc}
         {$I vectormath_vector2f_unix64_avx_imp.inc}

         {$I vectormath_vector3b_native_imp.inc}
         {$I vectormath_vector4b_native_imp.inc}

         {$I vectormath_vector4f_native_imp.inc}
         {$I vectormath_vector4f_unix64_avx_imp.inc}

         {$I vectormath_vector4i_native_imp.inc}
         {$I vectormath_vector4i_unix64_avx_imp.inc}

         {$I vectormath_quaternion_native_imp.inc}
         {$I vectormath_quaternion_unix64_avx_imp.inc}

         {$I vectormath_matrix4f_native_imp.inc}
         {$I vectormath_matrix4f_unix64_avx_imp.inc}
         {$I vectormath_matrixhelper_native_imp.inc}


         {$I vectormath_vectorhelper_native_imp.inc}
         {$I vectormath_vectorhelper_unix64_avx_imp.inc}

         {$I vectormath_hmgplane_native_imp.inc}
         {$I vectormath_hmgplane_unix64_avx_imp.inc}

         {$I vectormath_boundingbox_native_imp.inc}
         {$I vectormath_boundingsphere_native_imp.inc}
         {$I vectormath_axisaligned_boundingbox_native_imp.inc}
         {.$I vectormath_boundingboxhelper_native_imp.inc}
         {.$I vectormath_axisaligned_boundingBoxhelper_native_imp.inc}
         {.$I vectormath_frustrumhelper_native_imp.inc}

      {$ELSE}

         {$I vectormath_vector2f_native_imp.inc}
         {$I vectormath_vector2f_unix64_sse_imp.inc}

         {$I vectormath_vector3b_native_imp.inc}
         {$I vectormath_vector4b_native_imp.inc}

         {$I vectormath_vector4i_native_imp.inc}
         {$I vectormath_vector4i_unix64_sse_imp.inc}

         {$I vectormath_vector4f_native_imp.inc}
         {$I vectormath_vector4f_unix64_sse_imp.inc}

         {$I vectormath_quaternion_native_imp.inc}
         {$I vectormath_quaternion_unix64_sse_imp.inc}

         {$I vectormath_matrix4f_native_imp.inc}
         {$I vectormath_matrix4f_unix64_sse_imp.inc}
         {$I vectormath_matrixhelper_native_imp.inc}

         {$I vectormath_vectorhelper_native_imp.inc}
         {$I vectormath_vectorhelper_unix64_sse_imp.inc}

         {$I vectormath_hmgplane_native_imp.inc}
         {$I vectormath_hmgplane_unix64_sse_imp.inc}

         {$I vectormath_boundingbox_native_imp.inc}
         {$I vectormath_boundingsphere_native_imp.inc}
         {$I vectormath_axisaligned_boundingbox_native_imp.inc}
         {.$I vectormath_boundingboxhelper_native_imp.inc}
         {.$I vectormath_axisaligned_boundingBoxhelper_native_imp.inc}
         {.$I vectormath_frustrumhelper_native_imp.inc}

      {$ENDIF}
    {$else} // win64
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
          {.$I vectormath_vector2i_native_imp.inc}
          {.$I vectormath_vector2i_win64_sse_imp.inc}

          {$I vectormath_vector2f_native_imp.inc}
          {$I vectormath_vector2f_win64_sse_imp.inc}

          {$I vectormath_vector3b_native_imp.inc}
          {.$I vectormath_vector3i_native_imp.inc}
          {.$I vectormath_vector3f_native_imp.inc}

          {$I vectormath_vector4b_native_imp.inc}
          {$I vectormath_vector4i_native_imp.inc}
          {$I vectormath_vector4i_win64_sse_imp.inc}

          {$I vectormath_vector4f_native_imp.inc}
          {$I vectormath_vector4f_win64_sse_imp.inc}



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

          {$I vectormath_hmgplane_native_imp.inc}
          {$I vectormath_hmgplane_win64_sse_imp.inc}

          {$I vectormath_vectorhelper_native_imp.inc}
          {$I vectormath_vectorhelper_win64_sse_imp.inc}

          {$I vectormath_matrixhelper_native_imp.inc}
          {.$I vectormath_matrixhelper_win64_sse_imp.inc}

       {$ENDIF}
    {$endif}  //unix
  {$else} // CPU32
     {$IFDEF USE_ASM_AVX}
         {$I vectormath_vector2f_native_imp.inc}
         {$I vectormath_vector2f_intel32_avx_imp.inc}

         {$I vectormath_vector3b_native_imp.inc}
         {$I vectormath_vector4b_native_imp.inc}

         {$I vectormath_vector4f_native_imp.inc}
         {$I vectormath_vector4f_intel32_avx_imp.inc}

         {$I vectormath_vectorhelper_native_imp.inc}
         {$I vectormath_vectorhelper_intel32_avx_imp.inc}

         {$I vectormath_hmgplane_native_imp.inc}
         {$I vectormath_hmgplane_intel32_avx_imp.inc}

         {$I vectormath_matrix4f_native_imp.inc}
         {$I vectormath_matrix4f_intel32_avx_imp.inc}
         {$I vectormath_matrixhelper_native_imp.inc}

         {$I vectormath_quaternion_native_imp.inc}
         {$I vectormath_quaternion_intel32_avx_imp.inc}

         {$I vectormath_boundingbox_native_imp.inc}
         {$I vectormath_boundingsphere_native_imp.inc}
         {$I vectormath_axisaligned_boundingbox_native_imp.inc}
         {.$I vectormath_boundingboxhelper_native_imp.inc}
         {.$I vectormath_axisaligned_boundingBoxhelper_native_imp.inc}
         {.$I vectormath_frustrumhelper_native_imp.inc}

     {$ELSE}
        {$I vectormath_vector2f_native_imp.inc}
        {$I vectormath_vector2f_intel32_sse_imp.inc}

        {$I vectormath_vector3b_native_imp.inc}
        {$I vectormath_vector4b_native_imp.inc}

        {$I vectormath_vector4f_native_imp.inc}
        {$I vectormath_vector4f_intel32_sse_imp.inc}
        {$I vectormath_vector4i_native_imp.inc}
        {$I vectormath_vector4i_intel32_sse_imp.inc}

        {$I vectormath_vectorhelper_native_imp.inc}
        {$I vectormath_vectorhelper_intel32_sse_imp.inc}

        {$I vectormath_hmgplane_native_imp.inc}
        {$I vectormath_hmgplane_intel32_sse_imp.inc}

        {$I vectormath_matrix4f_native_imp.inc}
        {$I vectormath_matrix4f_intel32_sse_imp.inc}
        {$I vectormath_matrixhelper_native_imp.inc}

        {$I vectormath_quaternion_native_imp.inc}
        {$I vectormath_quaternion_intel32_sse_imp.inc}

        {$I vectormath_boundingbox_native_imp.inc}
        {$I vectormath_boundingsphere_native_imp.inc}
        {$I vectormath_axisaligned_boundingbox_native_imp.inc}
        {.$I vectormath_boundingboxhelper_native_imp.inc}
        {.$I vectormath_axisaligned_boundingBoxhelper_native_imp.inc}
        {.$I vectormath_frustrumhelper_native_imp.inc}

     {$ENDIF}
  {$endif}

{$else}  // pascal
  {$I vectormath_vector2f_native_imp.inc}
  {.$I vectormath_vector2i_native_imp.inc}

  {$I vectormath_vector3b_native_imp.inc}
  {.$I vectormath_vector3i_native_imp.inc}
  {.$I vectormath_vector3f_native_imp.inc}

  {$I vectormath_vector4b_native_imp.inc}
  {$I vectormath_vector4i_native_imp.inc}
  {$I vectormath_vector4f_native_imp.inc}

  {$I vectormath_quaternion_native_imp.inc}
  {$I vectormath_boundingbox_native_imp.inc}
  {$I vectormath_boundingsphere_native_imp.inc}
  {$I vectormath_axisaligned_boundingbox_native_imp.inc}

  {$I vectormath_matrix4f_native_imp.inc}
  {$I vectormath_matrixhelper_native_imp.inc}

  {$I vectormath_hmgplane_native_imp.inc}
  {$I vectormath_vectorhelper_native_imp.inc}
  {.$I vectormath_boundingboxhelper_native_imp.inc}
  {.$I vectormath_axisaligned_boundingBoxhelper_native_imp.inc}
  {.$I vectormath_frustrumhelper_native_imp.inc}
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
  _oldFPURoundingMode : TFPURoundingMode;

initialization

  // Store Default FPC "Rounding Mode"
  { We need to set rounding mode to is the same as our SSE code
    Because in FPC, the "function Round" using "banker's rounding" algorithm.
    In fat, is not doing a RoundUp or RoundDown if the is exactly x.50
    Round(2.5)=2 else Round(3.5)=4
    See for more infos : https://www.freepascal.org/docs-html/rtl/system/round.html }

  _oldFPURoundingMode := GetRoundMode;
  Math.SetRoundMode(rmNearest);

  // Store MXCSR SSE Flags
  _oldMXCSR := get_mxcsr;
  set_mxcsr (mxcsr_default);

finalization

  // Restore MXCSR SSE Flags to default value
  set_mxcsr(_oldMXCSR);
  // Restore Default FPC "Rounding Mode"
  Math.SetRoundMode(_oldFPURoundingMode);

End.

