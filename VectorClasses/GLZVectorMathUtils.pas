(*====< GLZVectorMathEx.pas >=====================================================@br

  @created(2017-11-25)
  @author(J.Delauney (BeanzMaster))
  @author(Peter Dyson (Dicepd))

  Historique : @br
  @unorderedList(
    @item(Last Update : 13/03/2018  )
    @item(12/03/2018 : Creation  )
  )

  ------------------------------------------------------------------------------@br
  Description :@br
  GLZVectorMathUtils Contains extra inline functions for vectors

  ------------------------------------------------------------------------------@br
  @bold(Notes :)@br
	

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
unit GLZVectorMathUtils;

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
interface

uses
  Classes, SysUtils, GLZMath, GLZVectorMath, GLZVectorMathEx;

{%region%----[ Inline Vector Helpers functions ]--------------------------------}

{ @name : Create a 3D Float single precision affine vector from values
  @param(vX : Single -- value for X)
  @param(vY : Single -- value for Y)
  @param(vZ : Single -- value for Z)
  @return(A TGLZVector3f) }
function AffineVectorMake(const x, y, z : Single) : TGLZAffineVector;overload;

{ @name : Create a 3D Float single precision affine vector from one Homogenous vector
  @param(v : TGLZVector4f -- Homogenous vector )
  @return(A TGLZVector3f) }
function AffineVectorMake(const v : TGLZVector) : TGLZAffineVector;overload;

{ @name : Create a 2D Float single precision from values
  @param(vX : Single -- value for X)
  @param(vY : Single -- value for Y)
  @return(A TGLZVector2f) }
function vec2(vx,vy:single):TGLZVector2f;

{ @name : Create a 4D Float single precision homogenous vector from values
  @param(vX : Single -- value for X)
  @param(vY : Single -- value for Y)
  @param(vZ : Single -- value for Z)
  @param(vW : Single -- value for W)
  @return(A TGLZVector4f) }
function vec4(vx,vy,vz,vw:single):TGLZVector4f;overload;

{ @name : Create a 4D Float single precision homogenous vector from one value as Homogenous
  @param(vX : Single -- value for each component)
  @return(A TGLZVector4f) }
function vec4(vx:single):TGLZVector4f; overload;

{ @name : Create a 4D Float single precision Point vector from values
  @param(vX : Single -- value for X)
  @param(vY : Single -- value for Y)
  @param(vZ : Single -- value for Z)
  @return(A TGLZVector4f) }
function PointVec4(vx,vy,vz:single):TGLZVector4f;overload;

{ @name : Create a 4D Float single precision Point vector from values
  @param(vX : Single -- value for each component except W (W=1) )
  @return(a TGLZVector4f) }
function PointVec4(vx:single):TGLZVector4f;overload;

//function PointVec4(Const anAffineVector: TGLZVector3f):TGLZVector4f; overload;
{%endregion%}

{%region%-----[ Inline Algebra and Trigonometric functions for vectors ]--------}

//--- For TGLZVector2f ---------------------------------------------------------

{ @name : Rounds  each component of a 2D float single precision vector towards towards 0
  @param(V : TGLZVector2f -- value to Trunc)
  @return(Truncated value as TGLZVector2i )}
function Trunc(Constref v:TGLZVector2f):TGLZVector2i; overload;

{ @name : Rounds each component of a 2D float single precision vector towards its nearest integer
  @param(V : TGLZVector2f -- value to round)
  @return(Rounded value as TGLZVector2i )}
function Round(Constref v:TGLZVector2f):TGLZVector2i; overload;

{ @name : Rounds each component of a 2D float single precision vector towards negative infinity
  @param(V : TGLZVector2f -- value to round)
  @return(Floored value as TGLZVector2i )}
function Floor(Constref v:TGLZVector2f):TGLZVector2i; overload;

{ @name : Rounds each component of a 2D float single precision vector towards positive infinity
  @param(V : TGLZVector2f -- value to round)
  @return(Floored value as TGLZVector2i )}
//function Ceil(Constref v:TGLZVector2f):TGLZVector2i; overload;

{ @name : Returns the fractional part of each component of a 2D float single precision vector
  @param(v value where extract fractionnal part)
  @return(Fractionnal part)}
function Fract(Constref v:TGLZVector2f):TGLZVector2f; overload;

//function Length(v:TGLZVector2f):Single;overload;
//function Distance(v1,v2:TGLZVector2f):Single;
//function Normalize(v:TGLZVector2f):TGLZVector2f;

//function fma(v,m,a:TGLZVector2f): TGLZVector2f; overload;
//function fma(v:TGLZVector2f; m,a:Single): TGLZVector2f; overload;
//function fma(v,m:TGLZVector2f;a:Single): TGLZVector2f; overload;
//function fma(v:TGLZVector2f;m:Single; a:TGLZvector2f): TGLZVector2f; overload;

//function faceforward
//function SmoothStep;
//function Step;
//function Saturate;

//--- Trigonometrics functions

{ @name : Returns the Square root of each component of a 2D float single precision vector
  @param(v value where extract Square root)
  @return(Square root)}
function Sqrt(Constref v:TGLZVector2f):TGLZVector2f; overload;

{ @name : Returns the Inverse Square root of each component of a 2D float single precision vector
  @param(v value where extract Square root)
  @return(Inverse Square root)}
function InvSqrt(Constref v:TGLZVector2f):TGLZVector2f; overload;

{ @name : Returns the Sinus of each component of a 2D float single precision vector
  @param(v value where compute Sinus)
  @return(Sinus)}
function Sin(v:TGLZVector2f):TGLZVector2f; overload;

{ @name : Returns the Cosinus of each component of a 2D float single precision vector
  @param(v value where compute Cosinus)
  @return(Cosinus)}
function Cos(v:TGLZVector2f):TGLZVector2f; overload;

{ @name : Returns the Sinus and Cosinus from a single value to each component of a 2D float single precision vector
  @param(v value where compute Sinus and Cosinus)
  @return(Sinus in X component and Cosinus in Y component)}
function SinCos(x:Single):TGLZvector2f; overload;

{ @name : Returns the Sinus and Cosinus from a 2D float single precision vector
  @param(v value where compute Sinus and Cosinus)
  @return(Sinus of X in X component and Cosinus Y in Y component)}
function SinCos(v:TGLZVector2f):TGLZvector2f; overload;

// function Exp;
// function Ln;

//--- For TGLZVector4f ---------------------------------------------------------

{ @name : Returns the fractional part of each component of a 4D float single precision vector
  @param(v value where extract fractionnal part)
  @return(Fractionnal part)}
function Fract(Constref v:TGLZVector4f):TGLZVector4f; overload;

//function Trunc(v:TGLZVector4f):TGLZVector4i; overload;
//function Round(v:TGLZVector4f):TGLZVector4i; overload;
//function Floor(v:TGLZVector4f):TGLZVector4i; overload;
//function Fract(v:TGLZVector4f):TGLZVector4i; overload;

//function Sqrt(v:TGLZVector2f):TGLZVector4f; overload;
//function InvSqrt(v:TGLZVector2f):TGLZVector4f; overload;

//function Sin(v:TGLZVector4f):TGLZVector4f; overload;
//function Cos(v:TGLZVector4f):TGLZVector4f; overload;

// retun SinCos, SinCos (x and z = sin, y and w = cos)
//function SinCos(v:TGLZVector4f):TGLZVector4f; overload;


{%endregion%}

{%region%-----[ Misc Inline utilities functions for vectors ]-------------------}

{ @name : Returns true if both vector are colinear
  @param(v1 : Vector 1)
  @param(v2 : Vector 2)
  @return(@True vectors are colinear. @False otherwise)}
function VectorIsColinear(constref v1, v2: TGLZVector) : Boolean;

//function PlaneContains(const Location, Normal: TGLZVector; const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;

{ Calculates the barycentric coordinates for the point p on the triangle
   defined by the vertices v1, v2 and v3. That is, solves
     p = u * v1 + v * v2 + (1-u-v) * v3
   for u,v.
   Returns true if the point is inside the triangle, false otherwise.
   NOTE: This function assumes that the point lies on the plane defined by the triangle.
   If this is not the case, the function will not work correctly! }
//function BarycentricCoordinates(const v1, v2, v3, p: TGLZAffineVector; var u, v: single): boolean;

{ Computes the triangle's area. }
//function TriangleArea(const p1, p2, p3 : TGLZAffineVector) : Single; overload;

{ Computes the polygons's area.
   Points must be coplanar. Polygon needs not be convex. }
//function PolygonArea(const p : PAffineVectorArray; nSides : Integer) : Single; overload;

{ Computes a 2D triangle's signed area.
   Only X and Y coordinates are used, Z is ignored. }
//function TriangleSignedArea(const p1, p2, p3 : TGLZAffineVector) : Single; overload;

{ Computes a 2D polygon's signed area.
   Only X and Y coordinates are used, Z is ignored. Polygon needs not be convex. }
//function PolygonSignedArea(const p : PAffineVectorArray; nSides : Integer) : Single; overload;

{ Generates a random point on the unit sphere.
   Point repartition is correctly isotropic with no privilegied direction. }
//function RandomPointOnSphere:TGLZVector;

{%endregion%}

implementation

//-----[ INCLUDE IMPLEMENTATION ]-----------------------------------------------

{$ifdef USE_ASM}
  {$ifdef CPU64}
    {$ifdef UNIX}
      {$IFDEF USE_ASM_AVX}
	 {$I vectormath_utils_native_imp.inc}
         {$I vectormath_utils_avx_imp.inc}	
      {$ELSE}         
         {$I vectormath_utils_native_imp.inc}
         {$I vectormath_utils_sse_imp.inc}		 
      {$ENDIF}
    {$else} // win64
      {$IFDEF USE_ASM_AVX}
         {$I vectormath_utils_native_imp.inc}
         {$I vectormath_utils_avx_imp.inc}
       {$ELSE}
	 {$I vectormath_utils_native_imp.inc}
         {$I vectormath_utils_sse_imp.inc}
       {$ENDIF}
    {$endif}  //unix
  {$else} // CPU32
     {$IFDEF USE_ASM_AVX}
	{$I vectormath_utils_native_imp.inc}
        {$I vectormath_utils_avx_imp.inc}
     {$ELSE}
        {$I vectormath_utils_native_imp.inc}
        {$I vectormath_utils_sse_imp.inc}
     {$ENDIF}
  {$endif}

{$else}  // pascal
  {$I vectormath_utils_native_imp.inc}
{$endif}



end.

