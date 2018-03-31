(*====< GLZVectorMath.pas >=====================================================@br

@created(2017-11-25)
@author(J.Delauney (BeanzMaster))
@author(Peter Dyson (Dicepd))

Historique : @br
@unorderedList(
  @item(Last Update : 13/03/2018  )
  @item(25/11/2017 : Creation  )
)

  ------------------------------------------------------------------------------@br
  Description :@br
  GLZVectorMath is an optimized vector classes math library for FreePascal and Lazarus@br
  using SIMD (SSE, SSE3, SS4, AVX, AVX2) acceleration@br
  It can be used in 2D/3D graphics, computing apps.@br

  Support :@br
    @unorderedlist (
     @item(2D Integer, Single Vectors @TODO Double)
     @item(3D Byte, Integer, Single Vectors)
     @item(4D Byte, Integer, Single Vectors @TODO Double (AVX & native only) )
     @item(2D Single Matrix)
     @item(4D Single Matrix (@TODO Integer ????) )
     @item("Euler Angles")
     @item(Quaternion)
     @item(Homogenous Plane)
     @item(Functions like in GLSL / HLSL)
  )

  ------------------------------------------------------------------------------@br
  @bold(Notes :)@br

  Notice, here, we need to set rounding FPC mode to is the same as our SSE code.@br
  In FPC, the "function Round" using "banker's rounding" algorithm.@br
  In fat, is not doing a RoundUp or RoundDown if the is exactly x.50@br
  Examples : @br
  @code(Round(2.5) //return = 2)@br 
  @code(Round(3.5) //return = 4) @br
  
  For more informations see : https://www.freepascal.org/docs-html/rtl/system/round.html @br 
	
  Some links as references :@br
    @unorderedList(
       @item(http://forum.lazarus.freepascal.org/index.php/topic,32741.0.html)
       @item(http://agner.org/optimize/)
       @item(http://www.songho.ca/misc/sse/sse.html)
       @item(https://godbolt.org);
       @item(http://softpixel.com/~cwright/programming/simd/sse.php)
       @item(https://www.gamasutra.com/view/feature/132636/designing_fast_crossplatform_simd_.php?page=3)
       @item(https://butterflyofdream.wordpress.com/2016/07/05/converting-rotation-matrices-of-left-handed-coordinate-system/)
       @item(http://shybovycha.tumblr.com/post/122400740651/speeding-up-algorithms-with-sse)
       @item(https://www.scratchapixel.com/index.php)
       @item(http://mark.masmcode.com)
       @item(https://www.cs.uaf.edu/courses/cs441/notes/sse-avx/)
       @item(http://www.euclideanspace.com)
       @item(https://www.3dgep.com/category/math/)
     )@br

   Quelques liens en français (in french) :@br
     @unorderedList(
       @item(http://villemin.gerard.free.fr/Wwwgvmm/Nombre.htm);
       @item(https://ljk.imag.fr/membres/Bernard.Ycart/mel/);
       @item(https://www.gladir.com/CODER/ASM8086/)
     )@br

   Others interesting articles, papers at some points:@br
     @unorderedList(
       @item(https://conkerjo.wordpress.com/2009/06/13/spatial-hashing-implementation-for-fast-2d-collisions/)
       @item(https://realhet.wordpress.com/2016/11/02/fast-sse-3x3-median-filter-for-rgb24-images/)
       @item(http://www.jagregory.com/abrash-black-book/)
       @item(http://x86asm.net/articles/fixed-point-arithmetic-and-tricks/)
       @item(http://lolengine.net/blog/2011/3/20/understanding-fast-float-integer-conversions)
       @item(http://chrishecker.com/Miscellaneous_Technical_Articles)
       @item(http://catlikecoding.com/unity/tutorials/rendering/part-1/)
     )@br


   You can also found some papers in @bold(DocRefs) folder@br
  ------------------------------------------------------------------------------@br

  @bold(Credits :)@br
    @unorderedList(
      @item(FPC/Lazarus)
      @item(GLScene)
      @item(All authors of papers and web links)
    )

  ------------------------------------------------------------------------------@br
  LICENCE : MPL
  @br
  ------------------------------------------------------------------------------@br
*==============================================================================*)
Unit GLZVectorMath;

{$WARN 5036 on : Local variable "$1" does not seem to be initialized}
{$WARN 5025 on : Local variable "$1" not used}
{$WARN 5028 on : Local const "$1" not used}

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
{.$DEFINE TEST}

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
  Classes, Sysutils;

Const
  { Constant for normalise color byte component to float }
  cColorFloatRatio : Single = 1/255;

{%region%----[ SSE States Flags Const ]-----------------------------------------}

Type
  { Kind of SIMD rounding mode }
  sse_Rounding_Mode = (rmNearestSSE, rmFloorSSE, rmCeilSSE, rmDefaultSSE);

Const
  { SIMD mxcsr register bits }
  {@exclude}
  sse_FlagInvalidOp = %0000000000000001; 
  {@exclude}
  sse_FlagDenorm    = %0000000000000010;
  {@exclude}
  sse_FlagDivZero   = %0000000000000100;
  {@exclude}
  sse_FlagOverflow  = %0000000000001000;
  {@exclude}
  sse_FlagUnderflow = %0000000000010000;
  {@exclude}
  sse_FlagPrecision = %0000000000100000;
  {@exclude}
  sse_FlagDenormZero= %0000000001000000;
  {@exclude}
  sse_MaskInvalidOp = %0000000010000000;
  {@exclude}
  sse_MaskDenorm    = %0000000100000000;
  {@exclude}
  sse_MaskDivZero   = %0000001000000000;
  {@exclude}
  sse_MaskOverflow  = %0000010000000000;
  {@exclude}
  sse_MaskUnderflow = %0000100000000000;
  {@exclude}
  sse_MaskPrecision = %0001000000000000;
  {@exclude}
  sse_MaskNegRound  = %0010000000000000;
  {@exclude}
  sse_MaskPosRound  = %0100000000000000;
  {@exclude}
  sse_MaskZeroFlush = %1000000000000000;

  {@exclude} //mask for removing old rounding bits to set new bits
  sse_no_round_bits_mask= $ffffffff-sse_MaskNegRound-sse_MaskPosRound;

  { Default value of the mxcsr after booting the PC@br
    Default setting of the mxscr register ; disable all exception's }
  mxcsr_default : dword =sse_MaskInvalidOp or sse_MaskDenorm  or sse_MaskDivZero or sse_MaskOverflow
                      or sse_MaskUnderflow or sse_MaskPrecision or $00000000; //sse_MaskPosRound;
  {@exclude}
  mxcsr_default_TEST : dword =sse_MaskInvalidOp and sse_MaskDenorm  or sse_MaskDivZero or sse_MaskOverflow
                      or sse_MaskUnderflow or sse_MaskPrecision or $00000000 and sse_MaskZeroFlush; //sse_MaskPosRound;

  // Conversion table from rounding mode name to rounding bits
  sse_Rounding_Flags: array [sse_Rounding_Mode] of longint = (0,sse_MaskNegRound,sse_MaskPosRound,0);

  { SIMD Data Alignement Constant in bits  @groupbegin  }
  sse_align=16;
  sse_align_mask=sse_align-1; //< Mask for data alignement
  {@groupend}

{%endregion%}

{%region%----[ Vectors ]--------------------------------------------------------}

type
  { Aligned array for vector @groupbegin  }
  TGLZVector2fType = packed array[0..1] of Single;  //< Aligned array for 2D Single Vector
  TGLZVector2dType = packed array[0..1] of Double;  //< Aligned array for 2D Double Vector
  TGLZVector2iType = packed array[0..1] of Integer; //< Aligned array for 2D Integer Vector

  TGLZVector3fType = packed array[0..2] of Single;  //< Aligned array for 3D Single Vector
  TGLZVector3iType = packed Array[0..2] of Longint; //< Aligned array for 3D Integer Vector
  TGLZVector3bType = packed Array[0..2] of Byte;    //< Aligned array for 3D Byte Vector
  
  TGLZVector4fType = packed array[0..3] of Single;  //< Aligned array for 4D Single Vector
  TGLZVector4iType = packed array[0..3] of Longint; //< Aligned array for 4D Integer Vector
  TGLZVector4bType = packed Array[0..3] of Byte;    //< Aligned array for 4D Byte Vector
  {@groupend}

  { Reference for swizzle (shuffle) vector @groupbegin  }

  // Reference for swizzle (shuffle) 3D Vectors
  TGLZVector3SwizzleRef = (swDefaultSwizzle3,
    swXXX, swYYY, swZZZ, swXYZ, swXZY, swZYX, swZXY, swYXZ, swYZX,
    swRRR, swGGG, swBBB, swRGB, swRBG, swBGR, swBRG, swGRB, swGBR);

  // Reference for swizzle (shuffle) 4D Vectors
  TGLZVector4SwizzleRef = (swDefaultSwizzle4,
    swXXXX, swYYYY, swZZZZ, swWWWW,
    swXYZW, swXZYW, swZYXW, swZXYW, swYXZW, swYZXW,
    swWXYZ, swWXZY, swWZYX, swWZXY, swWYXZ, swWYZX,
    swRRRR, swGGGG, swBBBB, swAAAA,
    swRGBA, swRBGA, swBGRA, swBRGA, swGRBA, swGBRA,
    swARGB, swARBG, swABGR, swABRG, swAGRB, swAGBR);
  {@groupend}

  { TGLZVector2i : 2D Integer vector }
  TGLZVector2i = record

    { @name : Initialize X and Y value
      @param(aX : Integer -- value for X)
      @param(aY : Integer -- value for Y) }
    procedure Create(aX, aY:Integer); overload;

    { @name
      @return(Vector to a formatted string eg "("x, y")" ) }
    function ToString : String;

    { @name : Add two TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : TGLZVector2i)
      @return(TGLZVector2i) }
    class operator +(constref A, B: TGLZVector2i): TGLZVector2i; overload;

    { @name : Sub two TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : TGLZVector2i)
      @return(TGLZVector2i) }
    class operator -(constref A, B: TGLZVector2i): TGLZVector2i; overload;

    { @name : Multiply two TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : TGLZVector2i)
      @return(TGLZVector2i) }
    class operator *(constref A, B: TGLZVector2i): TGLZVector2i; overload;

    { @name : Divide two TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : TGLZVector2i)
      @return(TGLZVector2i) }
    class operator Div(constref A, B: TGLZVector2i): TGLZVector2i; overload;

    { @name : Divide one TGLZVector2i by one Integer
      @param(A : TGLZVector2i)
      @param(B : Integer)
      @return(TGLZVector2i) }
    class operator Div(constref A: TGLZVector2i; Constref B:Integer): TGLZVector2i; overload;

    { @name : Add one Integer to one TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : Integer)
      @return(TGLZVector2i) }
    class operator +(constref A: TGLZVector2i; constref B:Integer): TGLZVector2i; overload;

    { @name : Add one Float to one TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : Single)
      @return(TGLZVector2i) }
    class operator +(constref A: TGLZVector2i; constref B:Single): TGLZVector2i; overload;

    { @name : Sub one Integer to one TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : Integer)
      @return(TGLZVector2i)}
    class operator -(constref A: TGLZVector2i; constref B:Integer): TGLZVector2i; overload;

    { @name : Sub one Float to one TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : Single)
      @return(TGLZVector2i)}
    class operator -(constref A: TGLZVector2i; constref B:Single): TGLZVector2i; overload;

    { Mul one Integer to one TGLZVector2i }
    //class operator *(constref A: TGLZVector2i; constref B:Integer): TGLZVector2i; overload;

    { @name : Multiply one TGLZVector2i by one Float
      @param(A : TGLZVector2i)
      @param(B : Single)
      @return(TGLZVector2i)}
    class operator *(constref A: TGLZVector2i; constref B:Single): TGLZVector2i; overload;

    { @name : Divide one TGLZVector2i by one Float
      @param(A : TGLZVector2i)
      @param(B : Single)
      @return(TGLZVector2i)}
    class operator /(constref A: TGLZVector2i; constref B:Single): TGLZVector2i; overload;
    
    { @name : Negate a TGLZVector2i
      @param(A : TGLZVector2i)
      @return(TGLZVector2i)}
    class operator -(constref A: TGLZVector2i): TGLZVector2i; overload;

    { @name : Compare if two TGLZVector2i are equal
      @param(A : TGLZVector2i)
      @param(B : TGLZVector2i)
      @return(Boolean @True if equal)}
    class operator =(constref A, B: TGLZVector2i): Boolean; overload;

    { @name : Compare if two TGLZVector2i are not equal
      @param(A : TGLZVector2i)
      @param(B : TGLZVector2i)
      @return(Boolean @True if not equal)}
    class operator <>(constref A, B: TGLZVector2i): Boolean; overload;

    { @name : Mod of two TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : TGLZVector2i)
      @return(TGLZVector2i -- Remainder of Division)}
    class operator mod(constref A, B : TGLZVector2i): TGLZVector2i; overload;

    { @name : Return the minimum of each component in TGLZVector2i between self and another TGLZVector2i
      @param(B : TGLZVector2i)
      @return(TGLZVector2i) }
    function Min(constref B: TGLZVector2i): TGLZVector2i; overload;

    { @name : Return the minimum of each component in TGLZVector2i between self and an Integer
      @param(B : Integer)
      @return(TGLZVector2i) }
    function Min(constref B: Integer): TGLZVector2i; overload;

    { @name : Return the maximum of each component in TGLZVector2i between self and another TGLZVector2i
      @param(B : TGLZVector2i)
      @return(TGLZVector2i) }
    function Max(constref B: TGLZVector2i): TGLZVector2i; overload;

    { @name : Return the minimum of each component in TGLZVector2i between self and an Integer
      @param(B : Integer)
      @return(TGLZVector2i) }
    function Max(constref B: Integer): TGLZVector2i; overload;

    { @name :  Clamp Self beetween a min and a max TGLZVector2i
      @param(AMin : TGLZVector2i)
      @param(AMax : TGLZVector2i)
      @return(TGLZVector2i) }
    function Clamp(constref AMin, AMax: TGLZVector2i): TGLZVector2i;overload;

    { @name :  Clamp each component of Self beatween a min and a max float
      @param(AMin : Integer)
      @param(AMax : Integer)
      @return(TGLZVector2i) }
    function Clamp(constref AMin, AMax: Integer): TGLZVector2i;overload;

    { @name :  Multiply Self by a TGLZVector2i and add an another TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : TGLZVector2i)
      @return(TGLZVector2i) }
    function MulAdd(constref A,B:TGLZVector2i): TGLZVector2i;

    { @name :  Multiply Self by a TGLZVector2i and div with an another TGLZVector2i
      @param(A : TGLZVector2i)
      @param(B : TGLZVector2i)
      @return(TGLZVector2i) }
    function MulDiv(constref A,B:TGLZVector2i): TGLZVector2i;

    { @name : Return self length
      @return(Single) }
    function Length:Single;

    { @name : Return self length squared
      @return(Single) }
    function LengthSquare:Single;

    { @name : Return distance from self to an another TGLZVector2i
      @param(A : TGLZVector2i)
      @return(Single) }
    function Distance(constref A:TGLZVector2i):Single;

    { @name : Return Self distance squared
      @param(A : TGLZVector2i)
      @return(Single) }
    function DistanceSquare(constref A:TGLZVector2i):Single;

    { @name :  Return the dot product of self and an another TGLZVector2i
      @param(A : TGLZVector2i)
      @return(Single) }
    function DotProduct(A:TGLZVector2i):Single;

    { @name : Return angle between Self and an another TGLZVector2i, relative to a TGLZVector2i as a Center Point
      @param(A : TGLZVector2i)
      @param(ACenterPoint : TGLZVector2i)
      @return(Single) }
    function AngleBetween(Constref A, ACenterPoint : TGLZVector2i): Single;

    { @name : Return the angle cosine between Self and an another TGLZVector2i
      @param(A : TGLZVector2i)
      @return(Single) }
    function AngleCosine(constref A: TGLZVector2i): Single;

    { @name : Return absolute value of self
      @return(TGLZVector2i) }
    function Abs:TGLZVector2i;overload;

    case Byte of
      0: (V: TGLZVector2iType);
      1: (X, Y : Integer);
      2: (Width, Height : Integer);
  end;

  { TGLZVector2f : 2D Float vector (Single) }
  TGLZVector2f =  record
    { @name : Initialize X and Y float values
      @param(aX : Single -- value for X)
      @param(aY : Single -- value for Y) }
    procedure Create(aX,aY: single);

    { @name : Return Vector to a formatted string eg "("x, y")"
      @return(String) }
    function ToString : String;

    { @name : Add two TGLZVector2f
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2f)
      @return(TGLZVector2f) }
    class operator +(constref A, B: TGLZVector2f): TGLZVector2f; overload;

    { @name : Add one TGLZVector2i to one TGLZVector2f
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2i)
      @return(TGLZVector2f) }
    class operator +(constref A: TGLZVector2f; constref B: TGLZVector2i): TGLZVector2f; overload;

    { @name : Sub two TGLZVector2f
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2f)
      @return(TGLZVector2f) }
    class operator -(constref A, B: TGLZVector2f): TGLZVector2f; overload;

    { @name : Substract one TGLZVector2i to one TGLZVector2f
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2i)
      @return(TGLZVector2f) }
    class operator -(constref A: TGLZVector2f; constref B: TGLZVector2i): TGLZVector2f; overload;

    { @name : Multiply two TGLZVector2f
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2f)
      @return(TGLZVector2f) }
    class operator *(constref A, B: TGLZVector2f): TGLZVector2f; overload;

    { @name : Multiply one TGLZVector2f by a TGLZVector2i
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2i)
      @return(TGLZVector2f) }
    class operator *(constref A:TGLZVector2f; Constref B: TGLZVector2i): TGLZVector2f; overload;

    { @name : Divide two TGLZVector2i
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2f)
      @return(TGLZVector2f) }
    class operator /(constref A, B: TGLZVector2f): TGLZVector2f; overload;

    { @name : Add one Float to one TGLZVector2f
      @param(A : TGLZVector2f)
      @param(B : Single)
      @return(TGLZVector2f) }
    class operator +(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;

    { @name : Substract one Float to one TGLZVector2f
      @param(A : TGLZVector2f)
      @param(B : Single)
      @return(TGLZVector2f) }
    class operator -(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;

    { @name : Multiply one TGLZVector2f by a Float
      @param(A : TGLZVector2f)
      @param(B : Single)
      @return(TGLZVector2f) }
    class operator *(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;

    { @name : Divide one TGLZVector2f by a Float
      @param(A : TGLZVector2f)
      @param(B : Single)
      @return(TGLZVector2f) }
    class operator /(constref A: TGLZVector2f; constref B:Single): TGLZVector2f; overload;

    { @name : Multiply one TGLZVector2f by a TGLZVector2i
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2i)
      @return(TGLZVector2f) }
    class operator /(constref A: TGLZVector2f; constref B: TGLZVector2i): TGLZVector2f; overload;

    { @name : Negate a TGLZVector2f
      @param(A : TGLZVector2f)
      @return(TGLZVector2f) }
    class operator -(constref A: TGLZVector2f): TGLZVector2f; overload;

    { @name : Compare if two TGLZVector2f are equal
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2f)
      @return(Boolean @True if equal)}
    class operator =(constref A, B: TGLZVector2f): Boolean;

    { @name : Compare if two TGLZVector2f are not equal
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2f)
      @return(Boolean @True if not equal)}
    class operator <>(constref A, B: TGLZVector2f): Boolean;

    //class operator mod(const a,b:TGLZVector2f): TGLZVector2f;

    { @name : Return the minimum of each component in TGLZVector2f between self and another TGLZVector2f
      @param(B : TGLZVector2f)
      @return(TGLZVector2f) }
    function Min(constref B: TGLZVector2f): TGLZVector2f; overload;

    { @name : Return the minimum of each component in TGLZVector2f between self and a Float
      @param(B : Single)
      @return(TGLZVector2f) }
    function Min(constref B: Single): TGLZVector2f; overload;

    { @name : Return the maximum of each component in TGLZVector2f between self and another TGLZVector2f
      @param(B : TGLZVector2f)
      @return(TGLZVector2f) }
    function Max(constref B: TGLZVector2f): TGLZVector2f; overload;

    { @name : Return the maximum of each component in TGLZVector2f between self and a Float
      @param(B : Single)
      @return(TGLZVector2f) }
    function Max(constref B: Single): TGLZVector2f; overload;

    { @name : Clamp Self beetween a min and a max TGLZVector2f
      @param(AMin : TGLZVector2f)
      @param(AMax : TGLZVector2f)
      @return(TGLZVector2f) }
    function Clamp(constref AMin, AMax: TGLZVector2f): TGLZVector2f;overload;

    { @name : Clamp Self beetween a min and a max Float
      @param(AMin : Single)
      @param(AMax : Single)
      @return(TGLZVector2f) }
    function Clamp(constref AMin, AMax: Single): TGLZVector2f;overload;

    { @name : Multiply Self by a TGLZVector2f and add an another TGLZVector2f
      @param(A : TGLZVector2f)
      @param(B : TGLZVector2f)
      @return(TGLZVector2f) }
    function MulAdd(constref A,B:TGLZVector2f): TGLZVector2f;

    { @name : Multiply Self by a TGLZVector2f and substract an another TGLZVector2f
      @param( : TGLZVector2f)
      @param( : TGLZVector2f)
      @return(TGLZVector2f) }
    function MulSub(constref A,B:TGLZVector2f): TGLZVector2f;

    { @name : Multiply Self by a TGLZVector2f and div with an another TGLZVector2f
      @param( : TGLZVector2f)
      @param( : TGLZVector2f)
      @return(TGLZVector2f) }
    function MulDiv(constref A,B:TGLZVector2f): TGLZVector2f;

    { @name : Return self length
      @return(Single) }
    function Length:Single;

    { @name : Return self length squared
      @return(Single) }
    function LengthSquare:Single;

    { @name : Return distance from self to an another TGLZVector2f
      @param(A : TGLZVector2f)
      @return(Single) }
    function Distance(constref A:TGLZVector2f):Single;

    { @name : Return Self distance squared
      @param(A : TGLZVector2f)
      @param( : )
      @return(Single) }
    function DistanceSquare(constref A:TGLZVector2f):Single;

    { @name : Return self normalized TGLZVector2f
      @return(TGLZVector2f) }
    function Normalize : TGLZVector2f;

    { @name : Return the dot product of self and an another TGLZVector2f
      @param(A : TGLZVector2f)
      @return(Single) }
    function DotProduct(A:TGLZVector2f):Single;

    { @name : Return angle between Self and an another TGLZVector2f, relative to a TGLZVector2f as a Center Point
      @param(A : TGLZVector2f)
      @param(ACenterPoint : TGLZVector2f)
      @return(Single) }
    function AngleBetween(Constref A, ACenterPoint : TGLZVector2f): Single;

    { @name : Return the angle cosine between Self and an another TGLZVector2f
      @param(A : TGLZVector2f)
      @return(Single) }
    function AngleCosine(constref A: TGLZVector2f): Single;

    // function Reflect(I, NRef : TVector2f):TVector2f

 //   function Edge(ConstRef A, B : TGLZVector2f):Single; // @TODO : a passer dans TGLZVector2fHelper ???

    { @name : Return absolute value of each component
      @return(TGLZVector2f) }
    function Abs:TGLZvector2f;overload;

    { @name : Round Self to a TGLZVector2i
      @return(TGLZVector2i) }
    function Round: TGLZVector2i; overload;

    { @name : Trunc Self to a TGLZVector2i
      @return(TGLZVector2i) }
    function Trunc: TGLZVector2i; overload;

    { @name : Floor Self to a TGLZVector2i
      @return(TGLZVector2i) }
    function Floor: TGLZVector2i; overload;

    { @name : Ceil Self to a TGLZVector2i
      @return(TGLZVector2i) }
    function Ceil : TGLZVector2i; overload;

    { @name : Return factorial of Self
      @return(TGLZVector2f) }
    function Fract : TGLZVector2f; overload;

    { @name : Return remainder of each component
      @param(A : TGLZVector2f)
      @return(TGLZVector2f) }
    function Modf(constref A : TGLZVector2f): TGLZVector2f;

    { @name : Return remainder of each component as TGLZVector2i
      @param(A : TGLZVector2f)
      @param( : )
      @return(TGLZVector2i) }
    function fMod(Constref A : TGLZVector2f): TGLZVector2i;

    { @name : Return square root of each component
      @return(TGLZVector2f) }
    function Sqrt : TGLZVector2f; overload;

    { @name : Return inversed square root of each component
      @return(TGLZVector2f) }
    function InvSqrt : TGLZVector2f; overload;

    { Access properties }
    case Byte of
      0: (V: TGLZVector2fType);    //< Array access
      1: (X, Y : Single);          //< Legacy access
      2: (Width, Height : Single); //< Surface size
  End;


  { TGLZVector2d : 2D Float vector (Double) }
  TGLZVector2d =  record
    { @name : Initialize X and Y float values
      @param(aX : Single -- value for X)
      @param(aY : Single -- value for Y) }
    procedure Create(aX,aY: Double);

    { @name : Return Vector to a formatted string eg "("x, y")"
      @return(String) }
    function ToString : String;

    { @name : Add two TGLZVector2d
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2d)
      @return(TGLZVector2d) }
    class operator +(constref A, B: TGLZVector2d): TGLZVector2d; overload;

    { @name : Add one TGLZVector2i to one TGLZVector2d
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2i)
      @return(TGLZVector2d) }
    class operator +(constref A: TGLZVector2d; constref B: TGLZVector2i): TGLZVector2d; overload;

    { @name : Sub two TGLZVector2d
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2d)
      @return(TGLZVector2d) }
    class operator -(constref A, B: TGLZVector2d): TGLZVector2d; overload;

    { @name : Substract one TGLZVector2i to one TGLZVector2d
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2i)
      @return(TGLZVector2d) }
    class operator -(constref A: TGLZVector2d; constref B: TGLZVector2i): TGLZVector2d; overload;

    { @name : Multiply two TGLZVector2d
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2d)
      @return(TGLZVector2d) }
    class operator *(constref A, B: TGLZVector2d): TGLZVector2d; overload;

    { @name : Multiply one TGLZVector2d by a TGLZVector2i
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2i)
      @return(TGLZVector2d) }
    class operator *(constref A:TGLZVector2d; Constref B: TGLZVector2i): TGLZVector2d; overload;

    { @name : Divide two TGLZVector2i
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2d)
      @return(TGLZVector2d) }
    class operator /(constref A, B: TGLZVector2d): TGLZVector2d; overload;

    { @name : Add one Float to one TGLZVector2d
      @param(A : TGLZVector2d)
      @param(B : Single)
      @return(TGLZVector2d) }
    class operator +(constref A: TGLZVector2d; constref B:Double): TGLZVector2d; overload;

    { @name : Substract one Float to one TGLZVector2d
      @param(A : TGLZVector2d)
      @param(B : Single)
      @return(TGLZVector2d) }
    class operator -(constref A: TGLZVector2d; constref B:Double): TGLZVector2d; overload;

    { @name : Multiply one TGLZVector2d by a Float
      @param(A : TGLZVector2d)
      @param(B : Single)
      @return(TGLZVector2d) }
    class operator *(constref A: TGLZVector2d; constref B:Double): TGLZVector2d; overload;

    { @name : Divide one TGLZVector2d by a Float
      @param(A : TGLZVector2d)
      @param(B : Single)
      @return(TGLZVector2d) }
    class operator /(constref A: TGLZVector2d; constref B:Double): TGLZVector2d; overload;

    { @name : Multiply one TGLZVector2d by a TGLZVector2i
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2i)
      @return(TGLZVector2d) }
    class operator /(constref A: TGLZVector2d; constref B: TGLZVector2i): TGLZVector2d; overload;

    { @name : Negate a TGLZVector2d
      @param(A : TGLZVector2d)
      @return(TGLZVector2d) }
    class operator -(constref A: TGLZVector2d): TGLZVector2d; overload;

    { @name : Compare if two TGLZVector2d are equal
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2d)
      @return(Boolean @True if equal)}
    class operator =(constref A, B: TGLZVector2d): Boolean;

    { @name : Compare if two TGLZVector2d are not equal
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2d)
      @return(Boolean @True if not equal)}
    class operator <>(constref A, B: TGLZVector2d): Boolean;

    //class operator mod(const a,b:TGLZVector2d): TGLZVector2d;

    { @name : Return the minimum of each component in TGLZVector2d between self and another TGLZVector2d
      @param(B : TGLZVector2d)
      @return(TGLZVector2d) }
    function Min(constref B: TGLZVector2d): TGLZVector2d; overload;

    { @name : Return the minimum of each component in TGLZVector2d between self and a Float
      @param(B : Single)
      @return(TGLZVector2d) }
    function Min(constref B: Double): TGLZVector2d; overload;

    { @name : Return the maximum of each component in TGLZVector2d between self and another TGLZVector2d
      @param(B : TGLZVector2d)
      @return(TGLZVector2d) }
    function Max(constref B: TGLZVector2d): TGLZVector2d; overload;

    { @name : Return the maximum of each component in TGLZVector2d between self and a Float
      @param(B : Single)
      @return(TGLZVector2d) }
    function Max(constref B: Double): TGLZVector2d; overload;

    { @name : Clamp Self beetween a min and a max TGLZVector2d
      @param(AMin : TGLZVector2d)
      @param(AMax : TGLZVector2d)
      @return(TGLZVector2d) }
    function Clamp(constref AMin, AMax: TGLZVector2d): TGLZVector2d;overload;

    { @name : Clamp Self beetween a min and a max Float
      @param(AMin : Single)
      @param(AMax : Single)
      @return(TGLZVector2d) }
    function Clamp(constref AMin, AMax: Double): TGLZVector2d;overload;

    { @name : Multiply Self by a TGLZVector2d and add an another TGLZVector2d
      @param(A : TGLZVector2d)
      @param(B : TGLZVector2d)
      @return(TGLZVector2d) }
    function MulAdd(constref A,B:TGLZVector2d): TGLZVector2d;

    { @name : Multiply Self by a TGLZVector2d and substract an another TGLZVector2d
      @param( : TGLZVector2d)
      @param( : TGLZVector2d)
      @return(TGLZVector2d) }
    function MulSub(constref A,B:TGLZVector2d): TGLZVector2d;

    { @name : Multiply Self by a TGLZVector2d and div with an another TGLZVector2d
      @param( : TGLZVector2d)
      @param( : TGLZVector2d)
      @return(TGLZVector2d) }
    function MulDiv(constref A,B:TGLZVector2d): TGLZVector2d;

    { @name : Return self length
      @return(Single) }
    function Length:Double;

    { @name : Return self length squared
      @return(Single) }
    function LengthSquare:Double;

    { @name : Return distance from self to an another TGLZVector2d
      @param(A : TGLZVector2d)
      @return(Single) }
    function Distance(constref A:TGLZVector2d):Double;

    { @name : Return Self distance squared
      @param(A : TGLZVector2d)
      @param( : )
      @return(Single) }
    function DistanceSquare(constref A:TGLZVector2d):Double;

    { @name : Return self normalized TGLZVector2d
      @return(TGLZVector2d) }
    function Normalize : TGLZVector2d;

    { @name : Return the dot product of self and an another TGLZVector2d
      @param(A : TGLZVector2d)
      @return(Single) }
    function DotProduct(A:TGLZVector2d):Double;

    { @name : Return angle between Self and an another TGLZVector2d, relative to a TGLZVector2d as a Center Point
      @param(A : TGLZVector2d)
      @param(ACenterPoint : TGLZVector2d)
      @return(Single) }
    function AngleBetween(Constref A, ACenterPoint : TGLZVector2d): Double;

    { @name : Return the angle cosine between Self and an another TGLZVector2d
      @param(A : TGLZVector2d)
      @return(Single) }
    function AngleCosine(constref A: TGLZVector2d): Double;

    // function Reflect(I, NRef : TVector2f):TVector2f

 //   function Edge(ConstRef A, B : TGLZVector2d):Single; // @TODO : a passer dans TGLZVector2dHelper ???

    { @name : Return absolute value of each component
      @return(TGLZVector2d) }
    function Abs:TGLZVector2d;overload;

    { @name : Round Self to a TGLZVector2i
      @return(TGLZVector2i) }
    function Round: TGLZVector2i; overload;

    { @name : Trunc Self to a TGLZVector2i
      @return(TGLZVector2i) }
    function Trunc: TGLZVector2i; overload;

    { @name : Floor Self to a TGLZVector2i
      @return(TGLZVector2i) }
    function Floor: TGLZVector2i; overload;

    { @name : Ceil Self to a TGLZVector2i
      @return(TGLZVector2i) }
    function Ceil : TGLZVector2i; overload;

    { @name : Return factorial of Self
      @return(TGLZVector2d) }
    function Fract : TGLZVector2d; overload;

    { @name : Return remainder of each component
      @param(A : TGLZVector2d)
      @return(TGLZVector2d) }
    function Modf(constref A : TGLZVector2d): TGLZVector2d;

    { @name : Return remainder of each component as TGLZVector2i
      @param(A : TGLZVector2d)
      @param( : )
      @return(TGLZVector2i) }
    function fMod(Constref A : TGLZVector2d): TGLZVector2i;

    { @name : Return square root of each component
      @return(TGLZVector2d) }
    function Sqrt : TGLZVector2d; overload;

    { @name : Return inversed square root of each component
      @return(TGLZVector2d) }
    function InvSqrt : TGLZVector2d; overload;

    { Access properties }
    case Byte of
      0: (V: TGLZVector2dType);    //< Array access
      1: (X, Y : Double);          //< Legacy access
      2: (Width, Height : Double); //< Surface size
  End;


  
  { TGLZVector3b : 3D Byte vector }
  TGLZVector3b = Record
  public 
    { @name : Initialize X, Y and values in range of 0..255
      @param(aX : Byte  -- value for X)
      @param(aY : Byte  -- value for Y)
      @param(aZ : Byte  -- value for Z)
      @return(TGLZ ) }
    procedure Create(const aX, aY, aZ: Byte);

    { @name : Return Vector to a formatted string eg "("x, y, z")"      
      @return(String) }
    function ToString : String;
    
    { @name : Add two TGLZVector3b
      @param(A : TGLZVector3b)
      @param(B : TGLZVector3b)
      @return(TGLZVector3b) }
    class operator +(constref A, B: TGLZVector3b): TGLZVector3b; overload;
    
    { @name :  Sub two TGLZVector3b 
      @param(A : TGLZVector3b)
      @param(B : TGLZVector3b)
      @return(TGLZVector3b) }
    class operator -(constref A, B: TGLZVector3b): TGLZVector3b; overload;

    { @name : Multiply two TGLZVector3b 
      @param(A : TGLZVector3b)
      @param(B : TGLZVector3b)
      @return(TGLZVector3b) }
    class operator *(constref A, B: TGLZVector3b): TGLZVector3b; overload;

    { @name : Divide two TGLZVector3b
      @param(A : TGLZVector3b)
      @param(B : TGLZVector3b)
      @return(TGLZVector3b) }
    class operator Div(constref A, B: TGLZVector3b): TGLZVector3b; overload;

    { @name : Add to each component of a TGLZVector3b a Byte
      @param(A : TGLZVector3b)
      @param(B : Byte)
      @return(TGLZVector3b) }
    class operator +(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
    
    { @name : Substract to each component of a TGLZVector3b a Byte
      @param(A : TGLZVector3b)
      @param(B : Byte)
      @return(TGLZVector3b) }
    class operator -(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;
   
    { @name : Multiply  each component of a TGLZVector3b by a Byte
      @param(A : TGLZVector3b)
      @param(B : Byte)
      @return(TGLZVector3b) }
    class operator *(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;

    { @name :Multiply  each component of a TGLZVector3b by a Float
      @param(A : TGLZVector3b)
      @param(B : Single)
      @return(TGLZVector3b) }
    class operator *(constref A: TGLZVector3b; constref B:Single): TGLZVector3b; overload;

    { @name : Divide  each component of a TGLZVector3b by a Byte
      @param(A : TGLZVector3b)
      @param(B : Byte)
      @return(TGLZVector3b) }
    class operator Div(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;

    { @name : Compare if two TGLZVector3b are equal
      @param(A : TGLZVector3b)
      @param(B : TGLZVector3b)
      @return(Boolean @True if equal)}
    class operator =(constref A, B: TGLZVector3b): Boolean;

    { @name : Compare if two TGLZVector3b are NOT equal
      @param(A : TGLZVector3b)
      @param(B : TGLZVector3b)
      @return(Boolean @True if equal)}
    class operator <>(constref A, B: TGLZVector3b): Boolean;

    { @name : Logical Operator "AND" between two TGLZVector3b
      @param(A : TGLZVector3b)
      @param(B : TGLZVector3b)
      @return(TGLZVector3b ) }
    class operator And(constref A, B: TGLZVector3b): TGLZVector3b; overload;

    { @name : Logical Operator "OR" between two TGLZVector3b
      @param( : TGLZVector3b)
      @param( : TGLZVector3b)
      @return(TGLZVector3b) }
    class operator Or(constref A, B: TGLZVector3b): TGLZVector3b; overload;

    { @name : Logical Operator "XOR" between two TGLZVector3b
      @param( : TGLZVector3b)
      @param( : TGLZVector3b)
      @return(TGLZVector3b) }
    class operator Xor(constref A, B: TGLZVector3b): TGLZVector3b; overload;

    { @name : Logical Operator "AND" between a TGLZVector3b and a Byte
      @param( : TGLZVector3b)
      @param( : Byte)
      @return(TGLZVector3b) }
    class operator And(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;

    { @name : Logical Operator "OR" between a TGLZVector3b and a Byte
      @param( : Byte)
      @return(TGLZVector3b) }
    class operator or(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;

    { @name : Logical Operator "XOR" between a TGLZVector3b and a Byte
      @param( : TGLZVector3b)
      @param( : Byte)
      @return(TGLZVector3b) }
    class operator Xor(constref A: TGLZVector3b; constref B:Byte): TGLZVector3b; overload;

    { @name : Return swizzle (shuffle) components of self 
      @param(ASwizzle : TGLZVector3SwizzleRef)      
      @return(TGLZVector3b) }
    function Swizzle(Const ASwizzle : TGLZVector3SwizzleRef): TGLZVector3b;

    { Access properties }
    Case Byte of
      0 : (V:TGLZVector3bType);     //< Array access
      1 : (X, Y, Z:Byte);           //< Legacy access  
      2 : (Red, Green, Blue:Byte);  //< As Color Components in RGB order
  end;

  { TGLZVector3i : 3D Integer vector (only access definition, not extended, just for convenience)}
  TGLZVector3i = record
  { Access properties }
  case Byte of
    0: (V: TGLZVector3iType);         //< Array access
    1: (X, Y, Z : Integer);           //< Legacy access  
    2: (Red, Green, Blue : Integer);  //< As Color Components in RGB order
  end;

  { TGLZVector3f : 3D Float vector (only access definition, not extended, just for convenience) }
  TGLZVector3f =  record
  public
    function ToString : String;

    { Access properties }
    case Byte of
      0: (V: TGLZVector3fType);       //< Array access
      1: (X, Y, Z: Single);           //< Legacy access
      2: (Red, Green, Blue: Single);  //< As Color Components in RGB order
  End;

  { Spelling convenience for vector3f, describe an affine vector }
  TGLZAffineVector = TGLZVector3f;
  PGLZAffineVector = ^TGLZAffineVector; //< Pointer of TGLZAffineVector

  { TGLZVector4b : 4D Byte vector }
  TGLZVector4b = Record
  public
    
    { @name : Create from x,y,z,w values. Default value for W = 255
      @param(aX : Byte)
      @param(aY : Byte)
      @param(aZ : Byte)
      @param(aW : Byte) }
    procedure Create(Const aX,aY,aZ: Byte; const aW : Byte = 255); overload;
    
    { @name : Create from a TGLZVector3b and w value. Default value for W = 255
      @param(aValue : TGLZVector3b)
      @param(aW : Byte) }
    procedure Create(Const aValue : TGLZVector3b; const aW : Byte = 255); overload;
   
    { @name : Return Vector to a formatted string eg "("x, y, z, w")"     
      @return(String) }
    function ToString : String;
    
    { @name : Add two TGLZVector4b
      @param(A : TGLZVector4b)
      @param(B : TGLZVector4b)
      @return(TGLZ ) }
    class operator +(constref A, B: TGLZVector4b): TGLZVector4b; overload;

    { @name : Sub two TGLZVector4b
      @param(A : TGLZVector4b)
      @param(B : TGLZVector4b)
      @return(TGLZVector4b) }
    class operator -(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    
    { @name : Multiply two TGLZVector4b
      @param(A : TGLZVector4b)
      @param(B : TGLZVector4b)
      @return(TGLZVector4b) }
    class operator *(constref A, B: TGLZVector4b): TGLZVector4b; overload;
   
    { @name : Divide two TGLZVector4b
      @param(A : TGLZVector4b)
      @param(B : TGLZVector4b)
      @return(TGLZVector4b) }
    class operator Div(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    
    { @name : Add one Byte to each component of a TGLZVector4b
      @param(A : TGLZVector4b)
      @param(B : Byte)
      @return(TGLZVector4b) }
    class operator +(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    
    { @name : Sub one Byte to each component of a TGLZVector4b
      @param(A : TGLZVector4b)
      @param(B : Byte)
      @return(TGLZVector4b) }
    class operator -(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    
    { @name : Multiply each component of a TGLZVector4b by one Byte
      @param(A : TGLZVector4b)
      @param(B : Byte)
      @return(TGLZVector4b) }
    class operator *(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    
    { @name : Multiply each componentof a TGLZVector4b by one Float
      @param(A : TGLZVector4b)
      @param(B : Single)
      @return(Single) }
    class operator *(constref A: TGLZVector4b; constref B:Single): TGLZVector4b; overload;
    
    { @name : Divide each component of a TGLZVector4bby one Byte
      @param(A : TGLZVector4b)
      @param(B : byte)
      @return(TGLZVector4b) }
    class operator Div(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    
    { @name : Compare if two TGLZVector4b are equal
      @param(A : TGLZVector4b)
      @param(B : TGLZVector4b)
      @return(TGLZ ) }
    class operator =(constref A, B: TGLZVector4b): Boolean;
   
    { @name : Compare if two TGLZVector4b are not equal
      @param(A : TGLZVector4b)
      @param(B : TGLZVector4b)
      @return(TGLZVector4b) }
    class operator <>(constref A, B: TGLZVector4b): Boolean;
    
    { @name : Operator @bold(AND) two TGLZVector4b
      @param(A : TGLZVector4b)
      @param(B : TGLZVector4b)
      @return(TGLZVector4b) }
    class operator And(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    
    { @name : Operator @bold(OR) two TGLZVector4b
      @param(A : TGLZVector4b)
      @param(B : TGLZVector4b)
      @return(TGLZVector4b) }
    class operator Or(constref A, B: TGLZVector4b): TGLZVector4b; overload;

    { @name : Operator @bold(XOR) two TGLZVector4b
      @param(A : TGLZVector4b)
      @param(B : TGLZVector4b)
      @return(TGLZVector4b) }
    class operator Xor(constref A, B: TGLZVector4b): TGLZVector4b; overload;
    
    { @name : Operator @bold(AND) one TGLZVector4b and one Byte
      @param(A : TGLZVector4b)
      @param(B : Byte)
      @return(TGLZVector4b) }
    class operator And(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    
    { @name : Operator @bold(OR) one TGLZVector4b and one Byte
      @param(A : TGLZVector4b)
      @param(B : Byte)
      @return(TGLZVector4b) }
    class operator or(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;

    { @name : Operator @bold(XOR) one TGLZVector4b and one Byte
      @param(A : TGLZVector4b)
      @param(B : Byte)
      @return(TGLZVector4b) }
    class operator Xor(constref A: TGLZVector4b; constref B:Byte): TGLZVector4b; overload;
    
    { @name : Fast self divide by 2
      @return(TGLZVector4b) }
    function DivideBy2 : TGLZVector4b;
    
    { @name : Return the minimum of each component in TGLZVector4b between self and another TGLZVector4b 
      @param(B : TGLZVector4b)      
      @return(TGLZVector4b) }
    function Min(Constref B : TGLZVector4b):TGLZVector4b; overload;

    { @name : Return the minimum of each component in TGLZVector4b between self and a float
      @param(B: Byte)    
      @return(TGLZVector4b) }
    function Min(Constref B : Byte):TGLZVector4b; overload;

    { @name : Return the maximum of each component in TGLZVector4b between self and another TGLZVector4b
      @param(B : TGLZVector4b)
      @return(TGLZVector4b) }
    function Max(Constref B : TGLZVector4b):TGLZVector4b; overload;

    { @name : Return the maximum of each component in TGLZVector4b between self and a float
      @param(B : Byte)
      @return(TGLZVector4b) }
    function Max(Constref B : Byte):TGLZVector4b; overload;

    { @name : Clamp Self between a min and a max TGLZVector4b
      @param(AMin : TGLZVector4b)
      @param(AMax : TGLZVector4b)
      @return(TGLZVector4b) }
    function Clamp(Constref AMin, AMax : TGLZVector4b):TGLZVector4b; overload;

    { @name : Clamp each component of Self between a min and a max float
      @param(AMin : Byte)
      @param(AMax : Byte)
      @return(TGLZVector4b) }
    function Clamp(Constref AMin, AMax : Byte):TGLZVector4b; overload;
    
    { @name : Multiply Self by a TGLZVector4b and add an another TGLZVector4b
      @param(B : TGLZVector4b)
      @param(C : TGLZVector4b)
      @return(TGLZVector4b) }
    function MulAdd(Constref B, C : TGLZVector4b):TGLZVector4b;

    { @name : Multiply Self by a TGLZVector4b and div by an another TGLZVector4b
      @param(B : TGLZVector4b)
      @param(C : TGLZVector4b)
      @return(TGLZVector4b) }
    function MulDiv(Constref B, C : TGLZVector4b):TGLZVector4b;
    
    { @name : Return shuffle components of self following params orders
      @param(X : Byte)
      @param(Y : Byte)
      @param(Z : Byte)
      @param(W : Byte)
      @return(TGLZVector4b) }
    function Shuffle(const x,y,z,w : Byte):TGLZVector4b;
    
    { @name : Return swizzle (shuffle) components of self from  TGLZVector4SwizzleRef mask
      @param(ASwizzle: TGLZVector4SwizzleRef)
      @return(TGLZVector4b) }
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TGLZVector4b;

    { @name : Return Combine = Self + (V2 * F1)
      @param(V2 : TGLZVector4b)
      @param(F1 : Single)
      @return(TGLZVector4b) }
    function Combine(constref V2: TGLZVector4b; constref F1: Single): TGLZVector4b;

    { @name : Combine2 = (Self * F1) + (V2 * F2)
      @param(V2 : TGLZVector4b)
      @param(F1 : Single)
      @param(F2 : Single)
      @return(TGLZVector4b) }
    function Combine2(constref V2: TGLZVector4b; const F1, F2: Single): TGLZVector4b;

    { @name : Return Combine3 = (Self * F1) + (V2 * F2) + (V3 * F3)
      @param(V2 : TGLZVector4b)
	  @param(V3 : TGLZVector4b)
      @param(F1 : Single)
      @param(F2 : Single)
      @param(F3 : Single)
      @return(TGLZVector4b) }
    function Combine3(constref V2, V3: TGLZVector4b; const F1, F2, F3: Single): TGLZVector4b;

    { @name : Return the minimum component value in XYZ
      @return(Byte) }
    function MinXYZComponent : Byte;
    
    { @name : Return the maximum component value in XYZ
      @return(Byte) }
    function MaxXYZComponent : Byte;

    { Access properties }
    Case Integer of
     0 : (V:TGLZVector4bType);              //< Array access
     1 : (X, Y, Z, W:Byte);                 //< Legacy access
     2 : (Red, Green, Blue,  Alpha:Byte);   //< As Color component
     3 : (AsVector3b : TGLZVector3b);       //< As TGLZVector3b
     4 : (AsInteger : Integer);             //< As 32 bit Integer
  end;

  { TGLZVector4i : 4D Integer vector }
  TGLZVector4i = Record
  public
    { @name : Self Create TGLZVector4i from x,y,z,w value
      @param(aX : Longint)      
      @param(aY : Longint)
      @param(aZ : Longint)
      @param(aW : Longint) }
    procedure Create(Const aX,aY,aZ: Longint; const aW : Longint = 0); overload;

    { @name : Self Create TGLZVector4i from a TGLZVector3i and w value as homogenous. Default W=0
      @param(aValue : TGLZVector3i)
      @param(aW : Longint) }
    procedure Create(Const aValue : TGLZVector3i; const aW : Longint = 0); overload;

    { @name : Self Create TGLZVector4i from a TGLZVector3b and w value as homogenous. Default W=0
      @param(aValue : TGLZVector3b)
      @param(aW : Longint) }
    procedure Create(Const aValue : TGLZVector3b; const aW : Longint = 0); overload;

    //procedure Create(Const aX,aY,aZ: Longint); overload; @TODO ADD as Affine creation
    //procedure Create(Const aValue : TGLZVector3i); overload;
    //procedure Create(Const aValue : TGLZVector3b); overload;

    { @name : Return Vector to a formatted string eg "("x, y, z, w")" 
      @return(String) }
    function ToString : String;

    { Add two TGLZVector4i }
    { @name :
      @param(A : TGLZVector4i)
      @param(B : TGLZVector4i)
      @return(TGLZVector4i) }
    class operator +(constref A, B: TGLZVector4i): TGLZVector4i; overload;

    { @name : Sub two TGLZVector4i
      @param(A : TGLZVector4i)
      @param(B : TGLZVector4i)
      @return(TGLZVector4i) }
    class operator -(constref A, B: TGLZVector4i): TGLZVector4i; overload;

    { @name : Multiply two TGLZVector4i
      @param(A : TGLZVector4i)
      @param(B : TGLZVector4i)
      @return(TGLZVector4i) }
    class operator *(constref A, B: TGLZVector4i): TGLZVector4i; overload;

    { @name : Divide two TGLZVector4i
      @param(A : TGLZVector4i)
      @param(B : TGLZVector4i)
      @return(TGLZVector4i) }
    class operator Div(constref A, B: TGLZVector4i): TGLZVector4i; overload;

    { @name : Add to each component of a TGLZVector4i one LongInt
      @param(A : TGLZVector4i)
      @param(B : Longint)
      @return(TGLZVector4i) }
    class operator +(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; overload;

    { @name : Sub each component of a TGLZVector4i one LongInt
      @param(A : TGLZVector4i)
      @param(B : Longint)
      @return(TGLZVector4i) }
    class operator -(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; overload;

    { @name : Multiply one Int to each component of a TGLZVector4i
      @param(A : TGLZVector4i)
      @param(B : Longint)
      @return(TGLZVector4i) }
    class operator *(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; overload;

    { @name : Multiply each component of a TGLZVector4i by one Float 
      @param(A : TGLZVector4i)
      @param(B : Single)
      @return(TGLZVector4i) }
    class operator *(constref A: TGLZVector4i; constref B:Single): TGLZVector4i; overload;
    
    { @name : Divide each component of a TGLZVector4i by one LongInt
      @param(A : TGLZVector4i)
      @param(B : Longint)
      @return(TGLZVector4i) }
    class operator Div(constref A: TGLZVector4i; constref B:Longint): TGLZVector4i; overload;

    { @name : Negate each components in Self
      @param(A : TGLZVector4i)      
      @return(TGLZVector4i) }
    class operator -(constref A: TGLZVector4i): TGLZVector4i; overload;

    { @name : Compare if two TGLZVector4i are equal
      @param(A : TGLZVector4i)
      @param(B : TGLZVector4i)
      @return(Boolean @True if equal) }
    class operator =(constref A, B: TGLZVector4i): Boolean;

    { @name : Compare if two TGLZVector4i are not equal
      @param(A : TGLZVector4i)
      @param(B : TGLZVector4i)
      @return(Boolean @True if not equal) }
    class operator <>(constref A, B: TGLZVector4i): Boolean;

    (* class operator And(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    class operator Or(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    class operator Xor(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    class operator And(constref A: TGLZVector4i; constref B:LongInt): TGLZVector4i; overload;
    class operator or(constref A: TGLZVector4i; constref B:LongInt): TGLZVector4i; overload;
    class operator Xor(constref A: TGLZVector4i; constref B:LongInt): TGLZVector4i; overload; *)

    { @name : Fast self divide by 2
      @return(TGLZVector4i) }
    function DivideBy2 : TGLZVector4i;

    { @name : Return absolute value of each components in self      
      @return(TGLZVector4i) }
    function Abs: TGLZVector4i;

    { @name : Return the minimum of each component in TGLZVector4i between self and another TGLZVector4i
      @param(B : TGLZVector4i)
      @return(TGLZVector4i) }
    function Min(Constref B : TGLZVector4i):TGLZVector4i; overload;

    { @name : Return the minimum of each component in TGLZVector4i between self and a Longint
      @param( : )
      @param(B : Longint)
      @return(TGLZVector4i) }
    function Min(Constref B : LongInt):TGLZVector4i; overload;

    { @name : Return the maximum of each component in TGLZVector4i between self and another TGLZVector4i
      @param(B : TGLZVector4i)
      @return(TGLZVector4i) }
    function Max(Constref B : TGLZVector4i):TGLZVector4i; overload;

    { @name : Return the maximum of each component in TGLZVector4i between self and a Longint
      @param(B : Longint)
      @return(TGLZVector4i) }
    function Max(Constref B : LongInt):TGLZVector4i; overload;

    { @name : Clamp Self between a min and a max TGLZVector4i
      @param(AMin : TGLZVector4i)
      @param(AMax : TGLZVector4i)
      @return(TGLZVector4i) }
    function Clamp(Constref AMin, AMax : TGLZVector4i):TGLZVector4i; overload;

    { @name : Clamp each component of Self between a min and a max float
      @param(AMin : Longint)
      @param(AMax : Longint)
      @return(TGLZVector4i) }
    function Clamp(Constref AMin, AMax : LongInt):TGLZVector4i; overload;

    { @name : Multiply Self by a TGLZVector4i and Add an another TGLZVector4i
      @param(B : TGLZVector4i)
      @param(C : TGLZVector4i)
      @return(TGLZVector4i) }
    function MulAdd(Constref B, C : TGLZVector4i):TGLZVector4i;

    { @name : Multiply Self by a TGLZVector4b and Divide by an another TGLZVector4i
      @param(B : TGLZVector4i)
      @param(C : TGLZVector4i)
      @return(TGLZVector4i) }
    function MulDiv(Constref B, C : TGLZVector4i):TGLZVector4i;

    { @name : Return shuffle components of self following params orders
      @param(X : Byte)
      @param(Y : Byte)
      @param(Z : Byte)
      @param(W : Byte)
      @return(TGLZVector4i) }
    function Shuffle(const x,y,z,w : Byte):TGLZVector4i;
       
    { @name : Return swizzle (shuffle) components of self from  TGLZVector4SwizzleRef mask
      @param(ASwizzle : TGLZVector4SwizzleRef)      
      @return(TGLZVector4i) }
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TGLZVector4i;

    { @name : Return Combine = Self  + (V2 * F2)
      @param(V2 : TGLZVector4i)
      @param(F1 : Single)
      @return(TGLZVector4i) }
    function Combine(constref V2: TGLZVector4i; constref F1: Single): TGLZVector4i;

    { @name : Return Combine2 = (Self * F1) + (V2 * F2)
      @param(V2 : TGLZVector4i)
      @param(F1 : Single)
      @param(F2 : Single)
      @return(TGLZVector4i) }
    function Combine2(constref V2: TGLZVector4i; const F1, F2: Single): TGLZVector4i;

    { @name : Return Combine3 = (Self * F1) + (V2 * F2) + (V3 * F3)
      @param(V2 : TGLZVector4i)
      @param(V3 : TGLZVector4i)
      @param(F1 : Single)
      @param(F2 : Single)
      @param(F3 : Single)
      @return(TGLZVector4i) }
    function Combine3(constref V2, V3: TGLZVector4i; const F1, F2, F3: Single): TGLZVector4i;

    { @name : Return the minimum component value in XYZ
      @return(TGLZ ) }
    function MinXYZComponent : LongInt;

    { @name : Return the maximum component value in XYZ
      @return(TGLZ ) }
    function MaxXYZComponent : LongInt;

    { Access properties }
    case Byte of
      0 : (V: TGLZVector4iType);                //< Array access
      1 : (X,Y,Z,W: longint);                   //< Legacy access 
      2 : (Red, Green, Blue, Alpha : Longint);  //> As Color Components
      3 : (AsVector3i : TGLZVector3i);          //< As TGLZVector3i
      4 : (ST,UV : TGLZVector2i);               //< As Texture coordinates ST,UV or UV,ST ????? 
      5 : (Left, Top, Right, Bottom: Longint);  //< As Legacy rect 
      6 : (TopLeft,BottomRight : TGLZVector2i); //< As bounding rect
  end;

  { TGLZVector4f : 4D Float vector }
  TGLZVector4f =  record  
  public  
    { @name :  Create as Homogenous from a Float. W value set by default to 0.0
      @param(AValue : Single)}
    procedure Create(Const AValue: single); overload;
	
    { @name : Create  as Homogenous from three Float. W value set by default to 0.0
      @param(aX : Single)
      @param(aY : Single)
      @param(aZ : Single)}
    procedure Create(Const aX,aY,aZ: single; const aW : Single = 0); overload;

   { @name : Create  As Homogenous from a TGLZVector3f and w value set by default to 0.0
      @param(anAffineVector : TGLZVector3f)
      @param(aW : Single) }
    procedure Create(Const anAffineVector: TGLZVector3f; const aW : Single = 0); overload;
	
    { @name : Create As Point from a Float. W value set by default to 1.0
      @param(AValue : Single)}
    procedure CreatePoint(Const AValue: single); overload;
	
    { @name :  Create As Point from three Float. W value set by default to 1.0
      @param(aX : Single)
      @param(aY : Single)
      @param(aZ : Single)}	
    procedure CreatePoint(Const aX,aY,aZ: single); overload;
   
    { @name :  Create As Point from a TGLZVector3f and w value set by default to 1.0
      @param(anAffineVector : TGLZVector3f) }
    procedure CreatePoint(Const anAffineVector: TGLZVector3f); overload;

    { @name : Return Vector to a formatted string eg "("x, y, z, w")"     
      @return(String) }
    function ToString : String;

    { @name :  Add two TGLZVector4f
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(TGLZVector4f) }
    class operator +(constref A, B: TGLZVector4f): TGLZVector4f; overload;

    { @name : Sub two TGLZVector4f
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(TGLZVector4f) }
    class operator -(constref A, B: TGLZVector4f): TGLZVector4f; overload;

    { @name : Multiply two TGLZVector4f
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(TGLZVector4f) }
    class operator *(constref A, B: TGLZVector4f): TGLZVector4f; overload;

    { @name : Divide two TGLZVector4f
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(TGLZVector4f) }
    class operator /(constref A, B: TGLZVector4f): TGLZVector4f; overload;

    { @name : Add to each component of a TGLZVector4f one Float
      @param(A : TGLZVector4f)
      @param(B : Single)
      @return(TGLZVector4f) }
    class operator +(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;

    { @name : Sub each component of a TGLZVector4f by one float
      @param(A : TGLZVector4f)
      @param(B : Single)
      @return(TGLZVector4f) }
    class operator -(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;

    { @name : Multiply one Float to each component of a TGLZVector4f
      @param(A : TGLZVector4f)
      @param(B : Single)
      @return(TGLZVector4f) }
    class operator *(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;

    { @name : Divide each component of a TGLZVector4f by one Float
      @param(A : TGLZVector4f)
      @param(B : Single)
      @return(TGLZVector4f) }
    class operator /(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; overload;

    { @name : Negate one TGLZVector4f
      @param(A : TGLZVector4f)
      @return(TGLZVector4f) }
    class operator -(constref A: TGLZVector4f): TGLZVector4f; overload;

    { @name : Compare if two TGLZVector4f are equal
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(Boolean @True if equal) }
    class operator =(constref A, B: TGLZVector4f): Boolean;

    { @name : Compare if two TGLZVector4f are greater or equal 
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(Boolean @True if A greater or equal than B ) }
    class operator >=(constref A, B: TGLZVector4f): Boolean;

    { @name : Compare if two TGLZVector4f are less or equal
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(Boolean @True if A Less or equal than B ) }
    class operator <=(constref A, B: TGLZVector4f): Boolean;

    { @name : Compare if two TGLZVector4f are greater
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(Boolean @True if A greater than B ) }
    class operator >(constref A, B: TGLZVector4f): Boolean;

    { @name : Compare if two TGLZVector4f are less
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(Boolean @True if A Less than B ) }
    class operator <(constref A, B: TGLZVector4f): Boolean;

    { @name : Compare if two TGLZVector4f are not equal
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @return(Boolean @True if not equal) }
    class operator <>(constref A, B: TGLZVector4f): Boolean;

    (* class operator And(constref A, B: TGLZVector4f.): TGLZVector4f.; overload;
    class operator Or(constref A, B: TGLZVector4f.): TGLZVector4f.; overload;
    class operator Xor(constref A, B: TGLZVector4f.): TGLZVector4f.; overload;
    class operator And(constref A: TGLZVector4f.; constref B:Single): TGLZVector4f.; overload;
    class operator or(constref A: TGLZVector4f.; constref B:Single): TGLZVector4f.; overload;
    class operator Xor(constref A: TGLZVector4f.; constref B:Single): TGLZVector4f.; overload; *)

    { @name : Return shuffle components of self following params orders
      @param(X : Byte)
      @param(Y : Byte)
      @param(Z : Byte)
      @param(W : Byte)
      @return(TGLZVector4f) }
    function Shuffle(const x,y,z,w : Byte):TGLZVector4f;

    { @name : Return swizzle (shuffle) components of self from  TGLZVector4SwizzleRef mask
      @param(ASwizzle: TGLZVector4SwizzleRef)
      @return(TGLZVector4f) }
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TGLZVector4f;

    { @name : Return the minimum component value in XYZ
      @return(Single) }
    function MinXYZComponent : Single;

    { @name : Return the maximum component value in XYZ
      @return(Single) }
    function MaxXYZComponent : Single;

    { @name : Return absolute value of self
      @return(TGLZVector4f) }
    function Abs:TGLZVector4f;overload;

    { @name : Negate Self
      @return(TGLZVector4f) }
    function Negate:TGLZVector4f;

    { @name : Fast Self Divide by 2
      @return(TGLZVector4f) }
    function DivideBy2:TGLZVector4f;

    { @name : Return self length
      @return(Single) }
    function Length:Single;

    { @name : Return self length squared
      @return(Single) }
    function LengthSquare:Single;

    { @name : Return Distance from self to an another TGLZVector4f
      @param(A : TGLZVector4f)
      @return(Single) }
    function Distance(constref A: TGLZVector4f):Single;

    { @name : Return Distance squared from self to an another TGLZVector4f
      @param(A : TGLZVector4f)
      @return(Single) }
    function DistanceSquare(constref A: TGLZVector4f):Single;

    { @name : Calculates Abs(v1[x]-v2[x])+Abs(v1[y]-v2[y])+..., also know as "Norm1".
      @param(A : TGLZVector4f)
      @return(Single) }
    function Spacing(constref A: TGLZVector4f):Single;

    { @name : Return the Dot product of self and an another TGLZVector4f
      @param(A : @param( : TGLZVector4f))
      @return(Single) }
    function DotProduct(constref A: TGLZVector4f):Single;

    { @name : Return the Cross product of self and an another TGLZVector4f
      @param(A : TGLZVector4f)      
      @return(TGLZVector4f) }
    function CrossProduct(constref A: TGLZVector4f): TGLZVector4f;

    { @name : Return self normalized
      @return(TGLZVector4f) }
    function Normalize: TGLZVector4f;

    { @name : Return normal
      @return(Single) }
    function Norm:Single;

    { @name : Return the minimum of each component in TGLZVector4f between self and another TGLZVector4f
      @param(B : TGLZVector4f)
      @return(TGLZVector4f) }
    function Min(constref B: TGLZVector4f): TGLZVector4f; overload;

    { @name : Return the minimum of each component in TGLZVector4f between self and a float
      @param(B : Single)
      @return(TGLZVector4f) }
    function Min(constref B: Single): TGLZVector4f; overload;
    
    { @name : Return the maximum of each component in TGLZVector4f between self and another TGLZVector4f
      @param(B : TGLZVector4f)
      @return(TGLZVector4f) }
    function Max(constref B: TGLZVector4f): TGLZVector4f; overload;

    { @name : Return the maximum of each component in TGLZVector4f between self and a float
      @param(B : Single)
      @return(TGLZVector4f) }
    function Max(constref B: Single): TGLZVector4f; overload;

    { @name : Clamp Self beetween a min and a max TGLZVector4f
      @param(AMin : TGLZVector4f)
      @param(AMax : TGLZVector4f)
      @return(TGLZVector4f) }
    function Clamp(Constref AMin, AMax: TGLZVector4f): TGLZVector4f; overload;

    { @name : Clamp each component of Self beatween a min and a max float
      @param(AMin : Single)
      @param(AMax : Single)
      @return(TGLZVector4f) }
    function Clamp(constref AMin, AMax: Single): TGLZVector4f; overload;

    { @name : Multiply Self by a TGLZVector4f and Add an another TGLZVector4f
      @param(B : TGLZVector4f)
      @param(C : TGLZVector4f)
      @return(TGLZVector4f) }
    function MulAdd(Constref B, C: TGLZVector4f): TGLZVector4f;

    { @name : Multiply Self by a TGLZVector4f and Substract an another TGLZVector4f
      @param(B : TGLZVector4f)
      @param(C : TGLZVector4f)
      @return(TGLZVector4f) }
    function MulSub(Constref B, C: TGLZVector4f): TGLZVector4f;

    { @name : Multiply Self by a TGLZVector4f and Divide by an another TGLZVector4f
      @param(B : TGLZVector4f)
      @param(C : TGLZVector4f)
      @return(TGLZVector4f) }
    function MulDiv(Constref B, C: TGLZVector4f): TGLZVector4f;

    { @name : Return linear interpolate value at T between self and B
      @param(B : TGLZVector4f)
      @param(T : Single)
      @return(TGLZVector4f) }
    function Lerp(Constref B: TGLZVector4f; Constref T:Single): TGLZVector4f;

    { @name : Return the angle cosine between Self and an another TGLZVector4f
      @param(A : TGLZVector4f)
      @return(Single) }
    function AngleCosine(constref A : TGLZVector4f): Single;

    { @name : Return angle between Self and an another TGLZVector4f, relative to a TGLZVector4f as a Center Point
      @param(A : TGLZVector4f)
      @param(ACenterPoint : TGLZVector4f)
      @return(Single) }
    function AngleBetween(Constref A, ACenterPoint : TGLZVector4f): Single;

    { @name : Return Combine3 = Self + (V2 * F2)
      @param(V2 : TGLZVector4f)
      @param(F1 : Single)
      @return(TGLZVector4f) }
    function Combine(constref V2: TGLZVector4f; constref F1: Single): TGLZVector4f;

    { @name : Return Combine2 = (Self * F1) + (V2 * F2)
      @param(V2 : TGLZVector4f)
      @param(F1 : Single)
      @param(F2 : Single)
      @return(TGLZVector4f) }
    function Combine2(constref V2: TGLZVector4f; const F1, F2: Single): TGLZVector4f;

    { @name : Return Combine3 = (Self * F1) + (V2 * F2) + (V3 * F3)
      @param(V2 : TGLZVector4f)
      @param(V3 : TGLZVector4f)
      @param(F1 : Single)
      @param(F2 : Single)
      @param(F3 : Single)
      @return(TGLZVector4f) }
    function Combine3(constref V2, V3: TGLZVector4f; const F1, F2, F3: Single): TGLZVector4f;

    { @name : Round each components in Self
      @return(TGLZVector4i) }
    function Round: TGLZVector4i;

    { @name : Trunc each components in Self
      @return(TGLZVector4i) }
    function Trunc: TGLZVector4i;

    { @name : Floor each components in Self
      @return(TGLZVector4i) }
    function Floor: TGLZVector4i; overload;

    { @name : Ceil each components in Self
      @return(TGLZVector4i) }
    function Ceil : TGLZVector4i; overload;

    { @name : Return fractionnal part of each components in Self
      @return(TGLZVector4f) }
    function Fract : TGLZVector4f; overload;

    //function Modf(constref A : TGLZVector4f): TGLZVector4f;
    //function fMod(Constref A : TGLZVector4f): TGLZVector4i;

    { @name :   Return Square root of each components in Self
      @return(TGLZVector4f) }
    function Sqrt : TGLZVector4f; overload;

    { @name :  Return Inverse Square root of each components in Self
      @return(TGLZVector4f) }
    function InvSqrt : TGLZVector4f; overload;

    { Access properties }
    case Byte of
      0: (V: TGLZVector4fType);                //< Array access
      1: (X, Y, Z, W: Single);                 //< Legacy access² 
      2: (Red, Green, Blue, Alpha: Single);    //< As Color components in RGBA order
      3: (AsVector3f : TGLZVector3f);          //< As TGLZVector3f
      4: (UV, ST : TGLZVector2f);              //< As Texture Coordinates  
      5: (Left, Top, Right, Bottom: Single);   //< As Lagacy Rect
      6: (TopLeft,BottomRight : TGLZVector2f); //< As Bounding Rect

  end;

  { Spelling convenience for TGLZVector4f, describe an homogenous vector  }
  TGLZVector = TGLZVector4f;
  PGLZVector = ^TGLZVector; //< Pointer of TGLZVector


  TGLZColorVector = TGLZVector; //< @TODO Make Independant
  {@exclude}
  PGLZColorVector = ^TGLZColorVector;

  TGLZClipRect = TGLZVector; //< @TODO  Make Independant

{%endregion%}

{%region%----[ Plane ]----------------------------------------------------------}

Const
   { Half space representation. @groupbegin}
   cPlaneFront   = 0;
   cPlaneBack    = 1;
   cPlanePlanar  = 2;
   cPlaneClipped = 3;
   cPlaneCulled  = 4;
   cPlaneVisible = 5;
   {@groupend}

type
  { Positions for point relative to the normal axis of a plane.@br
    The positive definition is relative to the normal vector direction
  }
  TGLZHmgPlaneHalfSpace = (
    phsIsOnNegativeSide,     //< On negative side.
    phsIsOnPositiveSide,     //< On positive side.
    phsIsOnPlane,            //< Directly on plane.
    phsIsClipped,            //< Clipped by plane.
    phsIsAway                //< Away from plane.
  );

  { @abstract(@noAutoLink(A plane equation.
    Defined by its equation A.x+B.y+C.z+D, a plane can be mapped to the
    homogeneous space coordinates, and this is what we are doing here.@br
    The plane is normalized so in effect contains unit normal in ABC (XYZ)
    and distance from origin to plane.

    WARNING : Create(Point, Normal) will allow non unit vectors but basically @bold(DON'T DO IT).@br
    A non unit vector WILL calculate the wrong distance to the plane.

    It is a fast way to create a plane when we have a point and a
    normal without yet another sqrt call.
	
    More informations : @br
    @unorderedlist(
      @item(https://en.wikipedia.org/wiki/Plane_(geometry) )
      @item(http://www.songho.ca/math/plane/plane.html)
      @item(https://brilliant.org/wiki/3d-coordinate-geometry-equation-of-a-plane/ )
      @item(http://tutorial.math.lamar.edu/Classes/CalcII/EqnsOfPlanes.aspx )
    )))}
  TGLZHmgPlane = record
  private
    procedure CalcNormal(constref p1, p2, p3 : TGLZVector);
  public
    { @name : Will allow non unit vectors but basically @bold(DON'T DO IT).@br
      A non unit vector WILL calculate the wrong distance to the plane.
      @param(point : TGLZVector)
      @param(normal : TGLZVector)
      @return(TGLZ ) }
    procedure Create(constref point, normal : TGLZVector); overload;
	
    { @name : Create and Computes the parameters of plane defined by three points.
      @param(p1 : TGLZVector)
      @param(p2 : TGLZVector)
      @param(p3 : TGLZVector) }
    procedure Create(constref p1, p2, p3 : TGLZVector); overload;

    { @name : Normalize self }
    procedure Normalize;

    { @name : Return self normalized plane
      @return(TGLZHmgPlane) }
    function Normalized : TGLZHmgPlane;

    { @name : Return absolute distance between self and a point
      @param(point : TGLZVector)
      @return(Single) }
    function AbsDistance(constref point : TGLZVector) : Single;

    { @name : Return signed distance between self and a point
      @param(point : TGLZVector)
      @return(Single) }
    function Distance(constref point : TGLZVector) : Single; overload;

    { @name : Return distance between self and a sphere
      @param(Center : TGLZVector)
      @param(Radius : Single)
      @return(Single) }
    function Distance(constref Center : TGLZVector; constref Radius:Single) : Single; overload;
    
    { @name : Calculates a vector perpendicular to P.@br
      Self is assumed to be of unit length, subtract out any component parallel to Self 
      @param(P : TGLZVector4f)
      @return(TGLZVector4f) }
    function Perpendicular(constref P : TGLZVector) : TGLZVector;

    { @name : Reflects vector V against Self (assumes self is normalized)
      @param(V : TGLZVector)
      @return(TGLZVector) }
    function Reflect(constref V: TGLZVector): TGLZVector;

    { @name : Return if a point is in half space 
      @param(Point: TGLZVector)
      @return(Boolean @True if point is in Half Space) }
    function IsInHalfSpace(constref point: TGLZVector) : Boolean;

    { @name : Return the position for a point relative to the normal axis of the plane.
      @param( : TGLZVector)
      @return(TGLZHmgPlaneHalfSpace) }
	//function GetHalfSpacePosition(constref point: TGLZVector) : TGLZHmgPlaneHalfSpace;
	
	{ Computes point to plane projection. Plane and direction have to be normalized }
	//function PointOrthoProjection(const point: TAffineVector; const plane : THmgPlane; var inter : TAffineVector; bothface : Boolean = True) : Boolean;
	//function PointProjection(const point, direction : TAffineVector; const plane : THmgPlane; var inter : TAffineVector; bothface : Boolean = True) : Boolean;	

   { Computes segment / plane intersection return false if there isn't an intersection}
   // function SegmentIntersect(const ptA, ptB : TAffineVector; const plane : THmgPlane; var inter : TAffineVector) : Boolean;

	{ Access properties }
    case Byte of
       0: (V: TGLZVector4fType);         //< should have type compat with other vector4f
       1: (A, B, C, D: Single);          //< Plane Parameter access
       2: (AsNormal3: TGLZAffineVector); //< super quick descriptive access to Normal as Affine Vector.
       3: (AsVector: TGLZVector);        //< as TGLZVector4f
       4: (X, Y, Z, W: Single);          //< legacy access so existing code works
  end;

{%endregion%}

{%region%----[ Matrix ]---------------------------------------------------------}

  { Transformation actions type }
  TGLZMatrixTransType = (ttScaleX, ttScaleY, ttScaleZ,
                ttShearXY, ttShearXZ, ttShearYZ,
                ttRotateX, ttRotateY, ttRotateZ,
                ttTranslateX, ttTranslateY, ttTranslateZ,
                ttPerspectiveX, ttPerspectiveY, ttPerspectiveZ, ttPerspectiveW);

  { TGLZMatrixTransformations is used to describe a sequence of transformations in following order:@br
    [Sx][Sy][Sz][ShearXY][ShearXZ][ShearZY][Rx][Ry][Rz][Tx][Ty][Tz][P(x,y,z,w)]@br
    Constants are declared for easier access (see MatrixDecompose below) }
  TGLZMatrixTransformations  = array [TGLZMAtrixTransType] of Single;

{%region%----[ TGLZMatrix4f ]---------------------------------------------------}

  { @abstract( TGLZMatrix4f : 4D Float Matrix@br
    The elements of the matrix in row-major order
    More Informations :@br
    @unorderedlist(
     @item(http://www.euclideanspace.com/maths/algebra/matrix/index.htm)
     @item(http://www.euclideanspace.com/maths/differential/other/matrixcalculus/index.htm)
     @item(http://www.fastgraph.com/makegames/3drotation/)
    ) )
  }
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
  
    { @name : Create homogenous identity matrix}
    procedure CreateIdentityMatrix;

    { @name : Cretae Scale matrix from TGLZAffineVector
      @param(V : TGLZAffineVector)}
    procedure CreateScaleMatrix(const v : TGLZAffineVector); overload;
	
    { @name : Cretae Scale matrix from TGLZVector
      @param(V : TGLZVector)}	
    procedure CreateScaleMatrix(const v : TGLZVector); overload;

    { @name : Cretae Translation matrix from TGLZAffineVector
      @param(V : TGLZAffineVector)}	
    procedure CreateTranslationMatrix(const V : TGLZAffineVector); overload;
	
    { @name : Cretae Translation matrix from TGLZVector
      @param(V : TGLZVector)}	
    procedure CreateTranslationMatrix(const V : TGLZVector); overload;

    { @name : Creates a scale+translation matrix.@br
              Scale is applied BEFORE applying offset 
      @param(aScale : TGLZVector)
      @param(Offset : TGLZVector)}
    procedure CreateScaleAndTranslationMatrix(const aScale, Offset : TGLZVector); overload;

    { @name : Create Right Hand Rotation Matrix around X from Sin & Cos
      @param(Sine : Single)
      @param(Cosine : Single)}
    procedure CreateRotationMatrixX(const sine, cosine: Single); overload;
	
   { @name : Create Right Hand Rotation Matrix around X from Angle
     @param(Angle : Single -- angle in rad) }
    procedure CreateRotationMatrixX(const angle: Single); overload;

    { @name : Create Right Hand Rotation Matrix around Y from Sin & Cos
      @param(Sine : Single)
      @param(Cosine : Single)}
    procedure CreateRotationMatrixY(const sine, cosine: Single); overload;
	
    { @name : Create Right Hand Rotation Matrix around Y from Angle
      @param(Angle : Single -- angle in rad) }
    procedure CreateRotationMatrixY(const angle: Single); overload;

    { @name : Create Right Hand Rotation Matrix around Z from Sin & Cos
      @param(Sine : Single)
      @param(Cosine : Single)}
    procedure CreateRotationMatrixZ(const sine, cosine: Single); overload;
	
    { @name : Create Right Hand Rotation Matrix around Z from Angle
      @param(Angle : Single -- angle in rad) }
    procedure CreateRotationMatrixZ(const angle: Single); overload;

    { @name : Creates a rotation matrix along the given Axis by the given Angle in radians.
      @param(anAxis : TGLZAffineVector)
      @param(Angle : Single)}
    procedure CreateRotationMatrix(const anAxis : TGLZAffineVector; angle : Single); overload;
	
    { @name : Creates a rotation matrix along the given Axis by the given Angle in radians.
      @param(anAxis : TGLZVector)
      @param(Angle : Single)}
    procedure CreateRotationMatrix(const anAxis : TGLZVector; angle : Single); overload;

    { @name : Create Right Hand Look at matrix
      @param(Eye : TGLZVector)
      @param(Center : TGLZVector)
      @param(NormUp : TGLZVector)}
    procedure CreateLookAtMatrix(const eye, center, normUp: TGLZVector);

    { @name : Create View Matrix from Frustum parameters
      @param(Left   : Single)
      @param(Right  : Single)
      @param(Bottom : Single)
      @param(Top    : Single)
      @param(ZNear  : Single)
      @param(ZFar   : Single)}
    procedure CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);

    { @name : Create Perspective View Matrix with FOV X
      @param(FOV    : Single)
      @param(Aspect : Single)	  
      @param(ZNear  : Single)
      @param(ZFar   : Single) }
    procedure CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);

    { @name : Create Orthogonal View Matrix from Frustum parameters
      @param(Left   : Single)
      @param(Right  : Single)
      @param(Bottom : Single)
      @param(Top    : Single)
      @param(ZNear  : Single)
      @param(ZFar   : Single)}
    procedure CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);

    { @name : Create Pick Matrix
      @param(X : Single)
      @param(Y : Single)
      @param(DeltaX : Single)
      @param(DeltaY : Single)
      @param(Viewport : TGLZVector4i) }
    procedure CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i);

    { @name : Creates a parallel projection matrix.@br
              Transformed points will projected on the plane along the specified direction. 
      @param(Plane : TGLZHmgPlane)
      @param(Dir : TGLZVector) }
    procedure CreateParallelProjectionMatrix(const plane : TGLZHmgPlane; const dir : TGLZVector);

    { @name : Creates a shadow projection matrix.@br
              Shadows will be projected onto the plane defined by planePoint and planeNormal, from lightPos.
      @param(PlanePoint : TGLZVector)
      @param(PlaneNormal : TGLZVector)
      @param(LightPos : TGLZVector) }
    procedure CreateShadowMatrix(const planePoint, planeNormal, lightPos : TGLZVector);

    { @name : Create a reflection matrix for the given plane.@br
              Reflection matrix allow implementing planar reflectors in OpenGL (mirrors).
      @param(PlanePoint : TGLZVector)
      @param(PlaneNormal : TGLZVector) }
    procedure CreateReflectionMatrix(const planePoint, planeNormal : TGLZVector);

    { Convert to string }
    { @name : Return Matrix to a formatted string :@br
	  "("x, y, z, w")" @br
	  "("x, y, z, w")" @br
	  "("x, y, z, w")" @br
	  "("x, y, z, w")" @br	  
      @return(String) }
    function ToString : String;
	
    { @name : Add two matrices
      @param(A : TGLZMatrix4f)
      @param(B : TGLZMatrix4f)
      @return(TGLZMatrix4f) }
    class operator +(constref A, B: TGLZMatrix4f): TGLZMatrix4f; overload;

    { @name : Add to each component of the matrix one Float 
      @param(A : TGLZMatrix4f)
      @param(B : TGLZMatrix4f)
      @return(TGLZMatrix4f) }
    class operator +(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; overload;

    { @name : Substract two matrices
      @param(A : TGLZMatrix4f)
      @param(B : TGLZMatrix4f)
      @return(TGLZMatrix4f) }
    class operator -(constref A, B: TGLZMatrix4f): TGLZMatrix4f; overload;

    { @name : Substract to each component of the matrix one Float 
      @param(A : TGLZMatrix4f)
      @param(B : Single
      @return(TGLZMatrix4f) }
    class operator -(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; overload;

    { @name : Multiplies two matrices
      @param(A : TGLZMatrix4f)
      @param(B : TGLZMatrix4f)
      @return(TGLZMatrix4f) }
    class operator *(constref A, B: TGLZMatrix4f): TGLZMatrix4f; overload;

    { @name :  Multiplies all elements of a 4x4 matrix with a factor
      @param(A : TGLZMatrix4f)
      @param(B : Single)
      @return(TGLZMatrix4f) }
    class operator *(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; overload;

    { @name : Transforms a homogeneous vector by multiplying it with a matrix
      @param(A : TGLZMatrix4f)
      @param(B : TGLZVector)
      @return(TGLZVector) }
    class operator *(constref A: TGLZMatrix4f; constref B: TGLZVector): TGLZVector; overload;

    { @name : Transforms a homogeneous vector by multiplying it with a matrix
      @param(A : TGLZVector)
      @param(B : TGLZMatrix4f)
      @return(TGLZVector) }
    class operator *(constref A: TGLZVector; constref B: TGLZMatrix4f): TGLZVector; overload;

    { @name : Divide all elements of a 4x4 matrix by a divisor
      @param(A : TGLZMatrix4f)
      @param(B : Single)
      @return(TGLZMatrix4f) }
    class operator /(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; overload;

    { @name : Negate each element of a matrix
      @param(A : TGLZMatrix4f)
      @return(TGLZMatrix4f) }
    class operator -(constref A: TGLZMatrix4f): TGLZMatrix4f; overload;

    //class operator =(constref A, B: TGLZMatrix4): Boolean;overload;
    //class operator <>(constref A, B: TGLZMatrix4): Boolean;overload;

    { @name : Computes transpose of the matrix
      @return(TGLZMatrix4f) }
    function Transpose: TGLZMatrix4f;

    { @name : Finds the inverse of the matrix
      @return(TGLZMatrix4f) }
    function Invert : TGLZMatrix4f;

    { @name : Normalize the matrix and remove the translation component.@br
              The resulting matrix is an orthonormal matrix (Y direction preserved, then Z) 
      @return(TGLZMatrix4f) }
    function Normalize : TGLZMatrix4f;

    { @name : Adjugate and Determinant functionality.@br
              Is used in the computation of the inverse of a matrix@br
              So far has only been used in Invert and eliminated from  assembler algo might
              not need to do this just keep it for pascal do what it says on the tin anyway as it has combined. }
    procedure Adjoint;

    { @name : Finds the inverse of an angle preserving matrix.@br
              Angle preserving matrices can combine translation, rotation and isotropic
              scaling, other matrices won't be properly inverted by this function.
      @param( : TGLZMatrix4f)
      @return(TGLZMatrix4f) }
    procedure AnglePreservingMatrixInvert(constref mat : TGLZMatrix4f);

    { @name : Decompose a non-degenerated 4x4 transformation matrix into the sequence of transformations that produced it.@br
              Modified by ml then eg, original Author: Spencer W. Thomas, University of Michigan. @br
              The coefficient of each transformation is returned in the corresponding element of the vector Translation.             
      @param(Tran : TGLZMatrixTransformations)
	  @return(Tran : TGLZMatrixTransformations)
      @return(Boolean Return @true upon success, false if the matrix is singular.) }
    function Decompose(var Tran: TGLZMatrixTransformations): Boolean;

    { @name : Adds the translation vector into the matrix
      @param(V : TGLZVector)
      @return(TGLZMatrix4f) }
    function Translate( constref v : TGLZVector):TGLZMatrix4f;

    { @name : Component-wise multiplication
      @param(M2 : TGLZMatrix4f)
      @return(TGLZMatrix4f) }
    function Multiply(constref M2: TGLZMatrix4f):TGLZMatrix4f;  
	
    { Set or Get a raw of the matrix } 
    property Rows[const AIndex: Integer]: TGLZVector read GetRow write SetRow;
	{ Set or Get element of the matrix }
    property Components[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;	
	{ Return the determinant of the matrix }
    property Determinant: Single read GetDeterminant;

    { Access properties@br 
	  Note : The elements of the matrix are in row-major order }
    case Byte of
    
      0: (M: array [0..3, 0..3] of Single);           //< 2D Array Access
      1: (V: array [0..3] of TGLZVector);             //< Array of TGLZVector access 
      2: (VX : Array[0..1] of array[0..7] of Single); //< for AVX Access
      3: (X,Y,Z,W : TGLZVector);                      //< Row access 
      4: (m11, m12, m13, m14: Single;                 //< Legacy access 
          m21, m22, m23, m24: Single;
          m31, m32, m33, m34: Single;
          m41, m42, m43, m44: Single);
  End;

  { Spelling convenience for TGLZMAtrix4f, describe a 4D float matrix  }
  TGLZMatrix = TGLZMatrix4f;
  PGLZMatrix = ^TGLZMatrix; //< Pointer of TGLZMatrix

{%endregion%}
{%endregion%}

{%region%----[ TGLZEulerAngles ]------------------------------------------------}

  { Euler Angle rotation order.@br
    Here, We're using the Tait–Bryan angles conventions for the definition of the rotation axes@br
    (x-y-z, y-z-x, z-x-y, x-z-y, z-y-x, y-x-z). }
  TGLZEulerOrder = (eulXYZ, eulXZY, eulYXZ, eulYZX, eulZXY, eulZYX);

  { The Euler angles are three angles to describe the orientation of a rigid body
    with respect to a fixed coordinate system.@br
    They can also represent the orientation of a mobile frame of reference in physics
    or the orientation of a general basis in 3-dimensional linear algebra. Is used with TGLZQuaternion.

    Remember : @br
    - X = Roll  = Bank     = Tilt @br
    - Y = Yaw   = Heading  = Azimuth @br
    - Z = Pitch = Attitude = Elevation@br

    Source : https://en.wikipedia.org/wiki/Euler_angles

    More informations :@br
    @unorderedlist(
     @item(https://en.wikipedia.org/wiki/Euler%27s_rotation_theorem)
     @item(http://ressources.univ-lemans.fr/AccesLibre/UM/Pedago/physique/02/meca/angleeuler.html)
     @item(https://en.wikipedia.org/wiki/Orientation_(geometry))
     @item(https://en.wikipedia.org/wiki/Inertial_navigation_system)
     @item(http://www.euclideanspace.com/maths/geometry/rotations/euler/index.htm)
     @item(http://www.starlino.com/imu_guide.html)
    )
  }
  TGLZEulerAngles = record
  public

    { @name : Create Euler from XYZ angles
      @param(X : Single -- X Angle in deg)
      @param(Y : Single -- Y Angle in deg)
      @param(Z : Single -- Z Angle in deg)}
    procedure Create(X,Y,Z:Single); // Roll, Yaw, Pitch
   { @name : Create Euler from angles define in an  Axis vector
     @param(Angles : TGLZVector -- In Deg) }
    procedure Create(Const Angles: TGLZVector);

    { @name : Convert Euler angles To Angle and  Axis according the rotation order
      @param(EulerOrder : TGLZEulerOrder -- Default rotation order = YZX)
      @return(Angle : Single)
      @return(Axis : TGLZVector) }
    procedure ConvertToAngleAxis(Out Angle : Single; Out Axis : TGLZVector;Const EulerOrder : TGLZEulerOrder = eulYZX);

    { @name : Convert Euler angles To a rotation matrix according the rotation order
      @param(EulerOrder : TGLZEulerOrder -- Default rotation order = YZX)
      @return(TGLZMatrix) }
    function ConvertToRotationMatrix(Const  EulerOrder:TGLZEulerOrder = eulYZX): TGLZMatrix;

    { Access properties@br
      Remember : @br
      X = Roll  = Bank     = Tilt @br
      Y = Yaw   = Heading  = Azimuth @br
      Z = Pitch = Attitude = Elevation
    }
    Case Byte of
      0 : ( V : TGLZVector3fType );               //< Array access 
      1 : ( X, Y, Z : Single );                   //< Legacy access
      2 : ( Roll, Yaw, Pitch : Single );          //<
      3 : ( Bank, Heading, Attitude : Single );   //<
      4 : ( Tilt, Azimuth, Elevation : Single );  //<
  end;

{%endregion%}

{%region%----[ Quaternion ]-----------------------------------------------------}

  { TGLZQuaternion : The quaternions are a number system that extends the complex numbers
                     and applied to mechanics in three-dimensional space.@br
                     A feature of quaternions is that multiplication of two quaternions is noncommutative.@br

    More informations :@br
     @unorderedlist(
       @item(https://en.wikipedia.org/wiki/Quaternion)
       @item(http://developerblog.myo.com/quaternions/)
       @item(http://www.chrobotics.com/library/understanding-quaternions)
       @item(https://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation)
       @item(http://www.euclideanspace.com/maths/algebra/realNormedAlgebra/quaternions/)
       @item(http://mathworld.wolfram.com/Quaternion.html)
     )
  }
  TGLZQuaternion = record
  public  
    { @name : Create a quaternion from the given values
      @param(X : Single)
      @param(Y : Single)
      @param(Z : Single)
      @param(Real : Single)}
    procedure Create(x,y,z: Single; Real : Single);overload;

    { @name : Create a quaternion from the given values
      @param(Imag : Array of single)
      @param(Real : Single) }
    procedure Create(const Imag: array of Single; Real : Single); overload;

    { @name : Constructs a unit quaternion from two unit vectors
      @param(V1 : TGLZAffineVector)
      @param(V2 : TGLZAffineVector)}
    procedure Create(const V1, V2: TGLZAffineVector); overload;
    
    { @name : Constructs a unit quaternion from two unit vectors or two points or on unit sphere
      @param(V1 : TGLZVector)
      @param(V2 : TGLZVector) }
    procedure Create(const V1, V2: TGLZVector); overload;

    
    { @name : Constructs a unit quaternion from a matrix. @br
	          @bold(Note :) The matrix must be a rotation matrix !
      @param(mat : TGLZMatrix)}
    procedure Create(const mat : TGLZMatrix); overload;

    { @name : Constructs quaternion from angle (in deg) and axis
      @param(Angle : Single)
      @param(Axis : TGLZAffineVector) }
    procedure Create(const angle  : Single; const axis : TGLZAffineVector); overload;
    //procedure Create(const angle  : Single; const axis : TGLZVector); overload;

    { @name : Constructs quaternion from Euler angles. ( Common Standard Euler Order = YZX )
      @param(Yaw   : Single)
      @param(Pitch : Single)
      @param(Roll  : Single) }
    procedure Create(const Yaw, Pitch, Roll : Single); overload;

    { @name : Constructs quaternion from Euler angles in arbitrary order (angles in degrees)
      @param(X : Single)
      @param(Y : Single)
      @param(Z : Single)
      @param(eulerOrder : TGLZEulerOrder) }
    procedure Create(const x, y, z: Single; eulerOrder : TGLZEulerOrder); overload;
	
    { @name : Constructs quaternion from Euler angles in arbitrary order (angles in degrees)
	  @param(EulerAngles : TGLZEulerAngles)
      @param(eulerOrder : TGLZEulerOrder) }	
    procedure Create(const EulerAngles : TGLZEulerAngles; eulerOrder : TGLZEulerOrder); overload;
    
    { @name : Return quaternion product quatrenion_Left * quaternion_Right. (which is the concatenation of a rotation Q1 followed by the rotation Q2) @br
              @bold(Note :)  Order is important reverted to A prod B as B prod A gave wrong results !
      @param(A : TGLZQuaternion -- Left)
      @param(B : TGLZQuaternion -- Right)
      @return(TGLZQuaternion) }
    class operator *(constref A, B: TGLZQuaternion): TGLZQuaternion;

    { @name : Compare if two TGLZQuaternion are equal
      @param(A : TGLZQuaternion)
      @param(B : TGLZQuaternion)
      @return(Boolean @True if equal) }
    class operator =(constref A, B: TGLZQuaternion): Boolean;

    { @name : Compare if two TGLZQuaternion are not equal
      @param(A : TGLZQuaternion)
      @param(B : TGLZQuaternion)
      @return(Boolean @True if not equal) }
    class operator <>(constref A, B: TGLZQuaternion): Boolean;
    
    { @name :Return Quaternion to a formatted string eg "("x, y, z, w")" 
      @return(String) }
    function ToString : String;


    (* CONVERTS A UNIT QUATERNION INTO TWO POINTS ON A UNIT SPHERE
     PD THIS IS A NONSENSE FUNCTION. IT DOES NOT DO THIS. IT MAKES ASSUMTIONS
     THERE IS NO Z COMPONENT IN THE CALCS. IT TRIES TO USE IMAGINARY PART
     AS A VECTOR WHICH YOU CANNOT DO WITH A QUAT, IT IS A 4D OBJECT WHICH MUST
     USE OTHER METHODS TO TRANSFORM 3D OBJECTS. IT HOLDS NO POSITION INFO.
    
     THIS FUNCTION IS USE FOR "ARCBALL" GIZMO. CAN BE REMOVE FROM HERE.
     IT CAN TAKE PLACE IN THE "GIZMOARCBALL OBJECT"
    PROCEDURE CONVERTTOPOINTS(VAR ARCFROM, ARCTO: TGLZAFFINEVECTOR); //OVERLOAD;
    PROCEDURE CONVERTTOPOINTS(VAR ARCFROM, ARCTO: TGLZVECTOR); //OVERLOAD; *)

    { @name : Construct a rotation matrix from (possibly non-unit) quaternion. @br
              Assumes matrix is used to multiply column vector on the left : @br
              vnew = mat * vold. @br
              Works correctly for right-handed coordinate system and right-handed rotations.
      @return(TGLZMatrix) }
    function ConvertToMatrix : TGLZMatrix;

    { @name : Convert quaternion to Euler Angles according the rotation order
      @param(EulerOrder : TGLZEulerOrder)
      @return(TGLZEulerAngles ) }
    function ConvertToEuler(Const EulerOrder : TGLZEulerOrder) : TGLZEulerAngles;

    { @name : Convert quaternion to angle (in deg) and axis
      @return(Angle : Single)
      @return(Axis : TGLZAffineVector ) }
    procedure ConvertToAngleAxis(out angle  : Single; out axis : TGLZAffineVector);

    { @name : Returns the conjugate of a quaternion 
      @return(TGLZQuaternion ) }
    function Conjugate : TGLZQuaternion;

    { @name : Returns the magnitude of the quaternion
      @return(Single) }
    function Magnitude : Single;

    { @name : Normalizes the quaternion }
    procedure Normalize;

    { @name : Applies rotation to V around local axes.
      @param(V : TGLZVector)
      @return(TGLZVector) }
    function Transform(constref V: TGLZVector): TGLZVector;

    { @name : If a scale factor is applied to a quaternion then the rotation will scale vectors when transforming them. @br
	          Assumes quaternion is already normalized
      @param(ScaleVal : Single)}
    procedure Scale(ScaleVal: single);

    { @name : Returns quaternion product quaternion_Right * quaternion_Left. @br       
              To combine rotations, use the product Muliply(qSecond, qFirst), which gives the effect of rotating by qFirst then qSecond. @br
	          @bold(Note :) order is important !
      @param(qFirst : TGLZQuaternion -- Quaternion_Right)
      @return(TGLZQuaternion) }    
    function MultiplyAsSecond(const qFirst : TGLZQuaternion): TGLZQuaternion;
          
    { @name :Spherical linear interpolation of unit quaternions with spins.@br
             @bold(Note :) QStart = Self 
      @param(QEnd : TGLZQuaternion -- start and end unit quaternions)
      @param(t : Single -- interpolation parameter (0 to 1))
      @param(Spin : Integer -- number of extra spin rotations to involve)
      @return(TGLZQuaternion) }
    function Slerp(const QEnd: TGLZQuaternion; Spin: Integer; t: Single): TGLZQuaternion; overload;

    { @name :Spherical linear interpolation of unit quaternions with spins.@br
             @bold(Note :) QStart = Self 
      @param(QEnd : TGLZQuaternion -- start and end unit quaternions)
      @param(t : Single -- interpolation parameter (0 to 1))
      @return(TGLZQuaternion) }
    function Slerp(const QEnd: TGLZQuaternion; const t : Single) : TGLZQuaternion; overload;

    { Access properties }
    case Byte of
      0: (V: TGLZVector4fType);                          //< Array access
      1: (X, Y, Z, W: Single);                           //< Legacy access   
      2: (AsVector4f : TGLZVector4f);                    //< As TGLZVector 
      3: (ImagePart : TGLZVector3f; RealPart : Single);  //< As complex number
  End;
  
{%endregion%}

{%region%----[ TGLZVectorHelper ]-----------------------------------------------}

{%region%----[ TGLZVector2iHelper ]-----------------------------------------------}

  { Helper for TGLZVector2i }
  TGLZVector2iHelper = record helper for TGLZVector2i
  public
   { @name : Return self normalized TGLZVector2f 
     @return(TGLZVector2f) }
   function Normalize : TGLZVector2f;
  end;

{%endregion%}

{%region%----[ TGLZVector2fHelper ]-----------------------------------------------}

  { Helper for TGLZVector2f }
  TGLZVector2fHelper = record helper for TGLZVector2f
  private
    // Swizling access
    function GetXY : TGLZVector2f;
    function GetYX : TGLZVector2f;
    function GetXX : TGLZVector2f;
    function GetYY : TGLZVector2f;

    function GetXXY : TGLZVector4f;
    function GetYYX : TGLZVector4f;

    function GetXYY : TGLZVector4f;
    function GetYXX : TGLZVector4f;

    function GetXYX : TGLZVector4f;
    function GetYXY : TGLZVector4f;

    function GetXXX : TGLZVector4f;
    function GetYYY : TGLZVector4f;

  public

    { @name : @NoAutoLink( Implement a @bold(step) function returning either zero or one.@br
      Implements a step function returning one for each component of Self that is
      greater than or equal to the corresponding component in the reference
      vector B, and zero otherwise.@br
	  
      see also : @br
	  -- http://developer.download.nvidia.com/cg/step.html @br
	  -- https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/step.xhtml )
      @param(B : TGLZVector2f)
      @return(TGLZVector2f) }
    function Step(ConstRef B : TGLZVector2f):TGLZVector2f;

    { @name : @NoAutoLink(Return a normal as-is if a vertex's eye-space position vector points in the opposite direction of a geometric normal, otherwise return the negated version of the normal
      Self = Peturbed normal vector.
     
      see also : @br
	  -- http://developer.download.nvidia.com/cg/faceforward.html @br
	  -- https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/faceforward.xhtml )
	  
	  @param(A : TGLZVector2f -- Incidence vector (typically a direction vector from the eye to a vertex) ).
	  @param(B : TGLZVector2f -- Geometric normal vector (for some facet the peturbed normal belongs).)
	  @return(TGLZVector2f) }
    //function FaceForward(constref A, B: TGLZVector2f): TGLZVector2f;

    { @name : @NoAutoLink(Return smallest integer not less than a scalar or each vector component.@br
      Return Self saturated to the range [0,1] as follows : @br
      @orderedlist(
        @item(Returns 0 if Self is less than 0; else)
        @item(Returns 1 if Self is greater than 1; else)
        @item(Returns Self otherwise.)
	  )

      For vectors, the returned vector contains the saturated result of each element
      of the vector Self saturated to [0,1].@br
	  
      see also : @br
	  -- http://developer.download.nvidia.com/cg/saturate.html )
        
      @return(TGLZVector2f) } 
    function Saturate : TGLZVector2f;

    { @name : @NoAutoLink(Interpolate smoothly between two input values based on a third
      Interpolates smoothly from 0 to 1 based on Self compared to a and b. @br	  
	  @orderedlist(
  	    @item(Returns 0 if Self < a < b or Self > a > b)
		@item(Returns 1 if Self < b < a or Self > b > a)
		@item(Returns a value in the range [0,1] for the domain [a,b].)
	  ) @br

      if A = Self then, the slope of Self.smoothstep(a,b) and b.smoothstep(a,b) is zero.@br

      For vectors, the returned vector contains the smooth interpolation of each
      element of the vector x.@br
      see also : @br
        -- http://developer.download.nvidia.com/cg/smoothstep.html @br
	-- https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/smoothstep.xhtml )
		
      @return(TGLZVector2f) }
    function SmoothStep(ConstRef A,B : TGLZVector2f): TGLZVector2f;

    { @name : Returns the linear interpolation of Self and B based on weight T.@br
              If T has values outside the [0,1] range, it actually extrapolates.
			  
	  See also : @br
      -- http://developer.download.nvidia.com/cg/lerp.html @br
      -- https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/mix.xhtml
      @param(B : TGLZVector2f)
      @param(T : Single)
      @return(TGLZVector2f) }
    function Lerp(Constref B: TGLZVector2f; Constref T:Single): TGLZVector2f;

    { Quick Swizzling properties access like in HLSL and GLSL @groupbegin }
    property XY : TGLZVector2f read GetXY;
    property YX : TGLZVector2f read GetYX;
    property XX : TGLZVector2f read GetXX;
    property YY : TGLZVector2f read GetYY;

    property XXY : TGLZVector4f read GetXXY;
    property YYX : TGLZVector4f read GetYYX;

    property XYY : TGLZVector4f read GetXYY;
    property YXX : TGLZVector4f read GetYXX;

    property XYX : TGLZVector4f read GetXYX;
    property YXY : TGLZVector4f read GetYXY;

    property XXX : TGLZVector4f read GetXXX;
    property YYY : TGLZVector4f read GetYYY;
    {@groupend}

  end;

{%endregion%}

{%region%----[ TGLZVector(4f)Helper ]---------------------------------------------}

  { Helper for TGLZVector4f }
  TGLZVectorHelper = record helper for TGLZVector
  private
    // Swizling access
    function GetXY : TGLZVector2f;
    function GetYX : TGLZVector2f;
    function GetXZ : TGLZVector2f;
    function GetZX : TGLZVector2f;
    function GetYZ : TGLZVector2f;
    function GetZY : TGLZVector2f;
    function GetXX : TGLZVector2f;
    function GetYY : TGLZVector2f;
    function GetZZ : TGLZVector2f;

    function GetXYZ : TGLZVector4f;
    function GetXZY : TGLZVector4f;

    function GetYXZ : TGLZVector4f;
    function GetYZX : TGLZVector4f;

    function GetZXY : TGLZVector4f;
    function GetZYX : TGLZVector4f;

    function GetXXX : TGLZVector4f;
    function GetYYY : TGLZVector4f;
    function GetZZZ : TGLZVector4f;

    function GetYYX : TGLZVector4f;
    function GetXYY : TGLZVector4f;
    function GetYXY : TGLZVector4f;

  public
    { @name : @NoAutoLink(Returns given vector rotated around arbitrary axis (alpha is in rad, , use Pure Math Model) @br
      We are using right hand rule coordinate system.@br
      Positive rotations are anticlockwise with postive axis toward you. @br
      Posiitve rotations are clockwise viewed from origin along positive axis :. @br
      @unorderedlist(
        @item(Axis orientation to view positives in Upper Right quadrant [as graph axes] )
        @item(With +Z pointing at you (as screen) positive X is to the right positive Y is Up )
        @item(With +Y pointing at you positive Z is to the right positive X is Up )
        @item(With +X pointing at you positive Y is to the left positive Z is up )
      ))
      @param(Axis : TGLZVector)
      @param(Angle : Single)
      @return(TGLZVector) }
    function Rotate(constref axis : TGLZVector; angle : Single):TGLZVector;

    { @name : Returns given vector rotated around the X axis (use Pure Math Model)
      @param(Alpha : Single -- In Rad)
      @return(TGLZVector) }
    function RotateWithMatrixAroundX(alpha : Single) : TGLZVector;

    { @name : Returns given vector rotated around the Y axis (use Pure Math Model)
      @param(Alpha : Single -- In Rad)
      @return(TGLZVector)  }
    function RotateWithMatrixAroundY(alpha : Single) : TGLZVector;

    { @name : Returns given vector rotated around the Z axis (use Pure Math Model)
      @param(Alpha : Single -- In Rad)
      @return(TGLZVector) ) }
    function RotateWithMatrixAroundZ(alpha : Single) : TGLZVector;

    { @name : Returns given vector rotated around the X axis. @br
              - With +X pointing at you positive Y is to the left positive Z is Up. @br
              Positive rotation around x, Y becomes negative.
		
      @param(Alpha : Single)
      @return(TGLZVector)  }
    function RotateAroundX(alpha : Single) : TGLZVector;

    { @name : Returns given vector rotated around the Y axis. @br
              - With +Y pointing at you positive Z is to the right positive X is Up. @br
             Positive rotation around y, Z becomes negative.
			 
      @param(Alpha : Single)
      @return(TGLZVector)  }
    function RotateAroundY(alpha : Single) : TGLZVector;

    { @name : Returns given vector rotated around the Z axis. @br
              - With +Z pointing at you (as screen) positive X is to the right positive Y is Up. @br
              Positive rotation around z, X becomes negative
			  
      @param(Alpha : Single -- In Rad)
      @return(TGLZVector)  }
    function RotateAroundZ(alpha : Single) : TGLZVector;

    
    { @name : Projects self on the line defined by Origin and Direction. @br
              Performs  a DotProduct((p - origin), direction), which, if direction is normalized, 
	      computes the distance between origin and the projection of self on the (origin, direction) line.
			  
      @param(Origin : TGLZVector4f)
      @param(Direction : TGLZVector4f)
      @return(Single) }
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
  
    { @name : Change vector (camera) 's position to make it move around its target.@br
              This method helps in quickly implementing camera controls. @br
			  
       @bold(Note :) Angle deltas are in degrees @br 
		 
       @bold(Tips :)@br 
	    Vector (Camera) parent's coordinates should be identity. @br
	    Make the Vector (Camera) a child of a "target" dummy and make it a target the dummy. @br
		Now, to pan across the scene, just move the dummy, to change viewing angle, use this method.
		
      @param(AMovingObjectUp : TGLZVector)
      @param(ATargetPosition : TGLZVector)
      @param(pitchDelta : Single)
      @param(turnDelta : Single)
      @return(TGLZVector -- New position) }
    function MoveAround(constref AMovingObjectUp, ATargetPosition: TGLZVector; pitchDelta, turnDelta: Single): TGLZVector;

    { @name : Translate a point from a Center and a distance
      @param(ACenter : TGLZVector -- some point, from which is should be distanced.)
      @param(Distance : Single -- Distance to shift)
      @param(AFromCenterSpo : Boolean @br
	  -- if @true distance, which object should keep from ACenter @br
	  -- if @false distance, which object should shift from his current position away from center. )
      @return(TGLZ ) }
    function ShiftObjectFromCenter(Constref ACenter: TGLZVector; const ADistance: Single; const AFromCenterSpot: Boolean): TGLZVector;

    { @name : Return the average of 4 points, wich describe a plane
      @param(Up : TGLZVector)
      @param(Left : TGLZVector)
      @param(Down : TGLZVector)
      @param(Right : TGLZVector)
      @return(TGLZVector) }
    function AverageNormal4(constref up, left, down, right: TGLZVector): TGLZVector;

    { : Extend a TGLZClipRect. Is a screen coord biased rect Top < Bottom, Left < Right
      (Left, Top, Right, Bottom: Single)
    }
    { @name : @TODO MOVE TO SPECIALIZED RECORD TGLZClipRect
      @param( : )
      @param( : )
      @return(TGLZ ) }
    //function ExtendClipRect(vX, vY: Single) : TGLZClipRect;

    { @name : Implement a step function returning either 0 or 1.@br
	
      Returns 1 for each component of Self that is greater than or equal 
	  to the corresponding component in the reference vector "B", and 0 otherwise.
	  
      see also : @br
	  - http://developer.download.nvidia.com/cg/step.html
	  - https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/step.xhtml
      @param(B : TGLZVector4f)
      @return(TGLZVector4f) }
    function Step(ConstRef B : TGLZVector4f):TGLZVector4f;


    { @name : Returns a normal as-is if a vertex's eye-space position vector points in the opposite direction of a geometric normal, otherwise return the negated version of the normal @br
	
      @bold(Note :) Self = Peturbed normal vector.
      
      see also : @br
	  - http://developer.download.nvidia.com/cg/faceforward.html
	  - https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/faceforward.xhtml
	  
      @param(A : TGLZVector4f -- Incidence vector (typically a direction vector from the eye to a vertex).)
      @param(B : TGLZVector4f -- Geometric normal vector (for some facet the peturbed normal belongs).)
      @return(TGLZVector4f) }
    function FaceForward(constref A, B: TGLZVector4f): TGLZVector4f;

    
    { @name : Returns smallest integer not less than a scalar or each vector component. @br
        Returns Self saturated to the range [0,1] as follows:

      For vectors, the returned vector contains the saturated result of each element
      of the vector Self saturated to [0,1]. @br
	  
      see also : @br
	  - http://developer.download.nvidia.com/cg/saturate.html
      
      @return(TGLZVector4f @br
      @orderedlist(
		  @item(Returns 0 if Self is less than 0)
		  @item(Returns 1 if Self is greater than 1)
		  @item(Returns Self otherwise.)
      ))}
    function Saturate : TGLZVector4f;


    { @name : Interpolate smoothly between two input values based on a third @br
              Interpolates smoothly from 0 to 1 based on Self compared to a and b.
			  
      if A = Self then @br
      The slope of Self.smoothstep(a,b) and b.smoothstep(a,b) is zero.
	  
      For vectors, the returned vector contains the smooth interpolation of each
      element of the vector x.
	  
      see also : @br
	  - http://developer.download.nvidia.com/cg/smoothstep.html @br
	  - https://www.khronos.org/registry/OpenGL-Refpages/gl4/html/smoothstep.xhtml
	  
      @param(A : TGLZVector4f)
      @param(B : TGLZVector4f)
      @Return(TGLZVector4f @br
      @undorederedlist(
        @item(0 if Self < a < b or Self > a > b)
        @item(1 if Self < b < a or Self > b > a)
        @item(A value in the range [0,1] for the domain [a,b].)
    )) }
    function SmoothStep(ConstRef A,B : TGLZVector4f): TGLZVector4f;

    { @name :
      @param(N : TGLZVector4f)
      @return(TGLZVector4f ) }
    function Reflect(ConstRef N: TGLZVector4f): TGLZVector4f;

    {  Quick Swizzling Properties values accessability like in HLSL and GLSL. @groupbegin }
    property XY : TGLZVector2f read GetXY;
    property YX : TGLZVector2f read GetYX;
    property XZ : TGLZVector2f read GetXZ;
    property ZX : TGLZVector2f read GetZX;
    property YZ : TGLZVector2f read GetYZ;
    property ZY : TGLZVector2f read GetZY;
    property XX : TGLZVector2f read GetXX;
    property YY : TGLZVector2f read GetYY;
    property ZZ : TGLZVector2f read GetZZ;

    property XYZ : TGLZVector4f read GetXYZ;
    property XZY : TGLZVector4f read GetXZY;
    property YXZ : TGLZVector4f read GetYXZ;
    property YZX : TGLZVector4f read GetYZX;
    property ZXY : TGLZVector4f read GetZXY;
    property ZYX : TGLZVector4f read GetZYX;

    property XXX : TGLZVector4f read GetXXX;
    property YYY : TGLZVector4f read GetYYY;
    property ZZZ : TGLZVector4f read GetZZZ;

    property YYX : TGLZVector4f read GetYYX;
    property XYY : TGLZVector4f read GetXYY;
    property YXY : TGLZVector4f read GetYXY;
	{@groupbegin}
  end;

{%endregion%}

{%endregion%}

{%region%----[ TGLZMatrixHelper ]-----------------------------------------------}

  { Helper for TGLZMatrix4f }
  TGLZMatrixHelper = record helper for TGLZMatrix
  public


    // Create rotation matrix from "Euler angles" (Tait–Bryan angles) Yaw = Y, Pitch = Z, Roll = X  (angles in deg)
    { @name :
      @param( : )
      @param( : ) }
   // procedure CreateRotationMatrix(angleX, angleY, aangleZ : Single;Const  EulerOrder:TGLZEulerOrder = eulYZX);overload;


    // Self is ViewProjMatrix
    //function Project(Const objectVector: TGLZVector; const viewport: TVector4i; out WindowVector: TGLZVector): Boolean;
    //function UnProject(Const WindowVector: TGLZVector; const viewport: TVector4i; out objectVector: TGLZVector): Boolean;
    // coordinate system manipulation functions

    { @name : Rotates the given coordinate system (represented by the matrix) around its Y-axis      
      @param(Angle : Single)
      @return(TGLZMatrix) }
    function Turn(angle : Single) : TGLZMatrix; overload;

    { @name : Rotates the given coordinate system (represented by the matrix) around MasterUp
      @param(MasterUp : TGLZVector)
      @param(Angle : Single)
      @return(TGLZMatrix) }
    function Turn(constref MasterUp : TGLZVector; Angle : Single) : TGLZMatrix; overload;

    { @name : Rotates the given coordinate system (represented by the matrix) around its X-axis
      @param(Angle : Single)
      @return(TGLZMatrix) }
    function Pitch(Angle: Single): TGLZMatrix; overload;

    { @name : Rotates the given coordinate system (represented by the matrix) around MasterRight
      @param(MasterRight : TGLZVector)
      @param(Angle : Single)
      @return(TGLZMatrix) }
    function Pitch(constref MasterRight: TGLZVector; Angle: Single): TGLZMatrix; overload;

    { @name : Rotates the given coordinate system (represented by the matrix) around its Z-axis
      @param(Angle : Single)
      @return(TGLZMatrix) }
    function Roll(Angle: Single): TGLZMatrix; overload;

    { @name : Rotates the given coordinate system (represented by the matrix) around MasterDirection
      @param(MasterDirection : TGLZVector)
      @param(Angle : Single)
      @return(TGLZMatrix) }
    function Roll(constref MasterDirection: TGLZVector; Angle: Single): TGLZMatrix; overload;

    { @name :Convert matrix to Eulers Angles according Euler Order @br
       	     @bold(Note :) Assume matrix is a rotation matrix.
      @param( : )
      @param( : )
      @return(TGLZ ) }
    //function ConvertToEulerAngles(Const EulerOrder : TGLZEulerOrder):TGLZEulerAngles;
  end;

{%endregion%}

{%region%----[ Vectors Const ]--------------------------------------------------}

Const
  { Vectors Const @groupbegin }

  { standard 2D vectors @groupbegin }
  NullVector2f   : TGLZVector2f = (x:0;y:0);
  OneVector2f   : TGLZVector2f = (x:1;y:1);

  NullVector2d   : TGLZVector2d = (x:0;y:0);
  OneVector2d   : TGLZVector2d = (x:1;y:1);

  NullVector2i   : TGLZVector2i = (x:0;y:0);
  OneVector2i   : TGLZVector2i = (x:1;y:1);
  {@groupend}

  { standard affine vectors @groupbegin }
  XVector :    TGLZAffineVector = (X:1; Y:0; Z:0);
  YVector :    TGLZAffineVector = (X:0; Y:1; Z:0);
  ZVector :    TGLZAffineVector = (X:0; Y:0; Z:1);
  XYVector :   TGLZAffineVector = (X:1; Y:1; Z:0);
  XZVector :   TGLZAffineVector = (X:1; Y:0; Z:1);
  YZVector :   TGLZAffineVector = (X:0; Y:1; Z:1);
  XYZVector :  TGLZAffineVector = (X:1; Y:1; Z:1);
  NullVector : TGLZAffineVector = (X:0; Y:0; Z:0);
  {@groupend}

  { standard homogeneous vectors @groupbegin }
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
  {@groupend}

  { standard homogeneous points @groupbegin }
  XHmgPoint :  TGLZVector = (X:1; Y:0; Z:0; W:1);
  YHmgPoint :  TGLZVector = (X:0; Y:1; Z:0; W:1);
  ZHmgPoint :  TGLZVector = (X:0; Y:0; Z:1; W:1);
  WHmgPoint :  TGLZVector = (X:0; Y:0; Z:0; W:1);
  NullHmgPoint : TGLZVector = (X:0; Y:0; Z:0; W:1);
  {@groupend}
  
  // Negative Homogenous Unit Vector
  NegativeUnitVector : TGLZVector = (X:-1; Y:-1; Z:-1; W:-1);

  { @groupend }

{%endregion%}

{%region%----[ Matrix Const ]---------------------------------------------------}

Const
  // Identity Homogenous Matrix
  IdentityHmgMatrix : TGLZMatrix = (V:((X:1; Y:0; Z:0; W:0),
                                       (X:0; Y:1; Z:0; W:0),
                                       (X:0; Y:0; Z:1; W:0),
                                       (X:0; Y:0; Z:0; W:1)));
  // Empty Homogenous  Matrix
  EmptyHmgMatrix : TGLZMatrix = (V:((X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0)));
{%endregion%}

{%region%----[ Quaternion Const ]-----------------------------------------------}

Const
 // Identity Quaternion
 IdentityQuaternion: TGLZQuaternion = (ImagePart:(X:0; Y:0; Z:0); RealPart: 1);

{%endregion%}

{%region%----[ SSE Register States and utils funcs ]----------------------------}

// Return current SIMD Rounding Mode
function sse_GetRoundMode: sse_Rounding_Mode;
// Set current SIMD Rounding Mode
procedure sse_SetRoundMode(Round_Mode: sse_Rounding_Mode);

{%endregion%}

Implementation

Uses Math, GLZMath; //, GLZUtils;

{%region%----[ Internal Types and Const ]---------------------------------------}

Const
     { SSE rounding modes (bits in MXCSR register) }

  cSSE_ROUND_MASK         : DWord = $00009FFF;   // never risk a stray bit being set in MXCSR reserved
  cSSE_ROUND_MASK_NEAREST : DWord = $00000000;
  cSSE_ROUND_MASK_TRUNC   : DWord = $00006000;

//  cSSE_ROUND_MASK_DOWN    = $00002000;
//  cSSE_ROUND_MASK_UP      = $00004000;

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

const
   cEulerOrderRef : array [Low(TGLZEulerOrder)..High(TGLZEulerOrder)] of array [1..3] of Byte =
      ( (0, 1, 2), (0, 2, 1), (1, 0, 2),     // eulXYZ, eulXZY, eulYXZ,
        (1, 2, 0), (2, 0, 1), (2, 1, 0) );   // eulYZX, eulZXY, eulZYX




// ---- Used by ASM Round & Trunc functions ------------------------------------
//var
//  _bakMXCSR, _tmpMXCSR : DWord;

//------------------------------------------------------------------------------

{%endregion%}

Var
  _oldMXCSR: DWord; // FLAGS SSE

//-----[ INTERNAL FUNCTIONS ]---------------------------------------------------

function AffineVectorMake(const x, y, z : Single) : TGLZAffineVector; inline;
begin
   Result.X:=x;
   Result.Y:=y;
   Result.Z:=z;
end;

//-----[ FUNCTIONS For TGLZVector3f ]-------------------------------------------

function TGLZVector3f.ToString : String;
begin
 Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
          ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+
          ' ,Z: '+FloattoStrF(Self.Z,fffixed,5,5);
end;


//-----[ INCLUDE IMPLEMENTATION ]-----------------------------------------------

{$ifdef USE_ASM}
  {$ifdef CPU64}
    {$ifdef UNIX}
      {$IFDEF USE_ASM_AVX}
         {$I vectormath_vector2i_native_imp.inc}
         {.$I vectormath_vector2i_unix64_avx_imp.inc}

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


      {$ELSE}
         {$I vectormath_vector2i_native_imp.inc}
         {$I vectormath_vector2i_unix64_sse_imp.inc}

         {$I vectormath_vector2f_native_imp.inc}
         {$I vectormath_vector2f_unix64_sse_imp.inc}

         {$I vectormath_vector2d_native_imp.inc}
         {$I vectormath_vector2d_unix64_sse_imp.inc}

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

         {$I vectormath_vector2fhelper_native_imp.inc}
         {$I vectormath_vector2fhelper_unix64_sse_imp.inc}

         {$I vectormath_vectorhelper_native_imp.inc}
         {$I vectormath_vectorhelper_unix64_sse_imp.inc}

         {$I vectormath_hmgplane_native_imp.inc}
         {$I vectormath_hmgplane_unix64_sse_imp.inc}

      {$ENDIF}
    {$else} // win64
      {$IFDEF USE_ASM_AVX}
          {$I vectormath_vector2i_native_imp.inc}
          {$I vectormath_vector2i_win64_avx_imp.inc}

          {$I vectormath_vector2f_native_imp.inc}
          {$I vectormath_vector2f_win64_avx_imp.inc}
          {$I vectormath_vector2f_win64_avx_imp.inc}

          {$I vectormath_vector3b_native_imp.inc}
          {$I vectormath_vector4b_native_imp.inc}

          {$I vectormath_vector4f_native_imp.inc}
          {$I vectormath_vector4f_win64_avx_imp.inc}

          {$I vectormath_vector4i_native_imp.inc}
          {$I vectormath_vector4i_win64_avx_imp.inc}

          {$I vectormath_quaternion_native_imp.inc}
          {$I vectormath_quaternion_win64_avx_imp.inc}

          {$I vectormath_matrix4f_native_imp.inc}
          {$I vectormath_matrix4f_win64_avx_imp.inc}
          {$I vectormath_matrixhelper_native_imp.inc}


          {$I vectormath_vectorhelper_native_imp.inc}
          {$I vectormath_vectorhelper_win64_avx_imp.inc}

          {$I vectormath_hmgplane_native_imp.inc}
          {$I vectormath_hmgplane_win64_avx_imp.inc}

       {$ELSE}
          {$I vectormath_vector2i_native_imp.inc}
          {$I vectormath_vector2i_win64_sse_imp.inc}

          {$I vectormath_vector2f_native_imp.inc}
          {$I vectormath_vector2f_win64_sse_imp.inc}

          {$I vectormath_vector2d_native_imp.inc}
          {$I vectormath_vector2d_win64_sse_imp.inc}

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


          {$I vectormath_hmgplane_native_imp.inc}
          {$I vectormath_hmgplane_win64_sse_imp.inc}

          {$I vectormath_vector2fhelper_native_imp.inc}
          {$I vectormath_vector2fhelper_win64_sse_imp.inc}

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


     {$ENDIF}
  {$endif}

{$else}  // pascal
  {$I vectormath_vector2i_native_imp.inc}
  {$I vectormath_vector2f_native_imp.inc}
  

  {$I vectormath_vector3b_native_imp.inc}
  {.$I vectormath_vector3i_native_imp.inc}
  {.$I vectormath_vector3f_native_imp.inc}

  {$I vectormath_vector4b_native_imp.inc}
  {$I vectormath_vector4i_native_imp.inc}
  {$I vectormath_vector4f_native_imp.inc}

  {$I vectormath_quaternion_native_imp.inc}

  {$I vectormath_matrix4f_native_imp.inc}
  {$I vectormath_matrixhelper_native_imp.inc}

  {$I vectormath_hmgplane_native_imp.inc}
  {$I vectormath_vector2fhelper_native_imp.inc}
  {$I vectormath_vectorhelper_native_imp.inc}

{$endif}

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

  
  { We need to set rounding mode to is the same as our SSE code
    Because in FPC, the "function Round" using "banker's rounding" algorithm.
    In fat, is not doing a RoundUp or RoundDown if the is exactly x.50
    Round(2.5)=2 else Round(3.5)=4
    See for more infos : https://www.freepascal.org/docs-html/rtl/system/round.html }
 
  // Store Default FPC "Rounding Mode"
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

