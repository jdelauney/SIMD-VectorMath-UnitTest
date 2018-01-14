(*====< GLZFastMath.pas >=====================================================@br
@created(2017-11-25)
@author(J.Delauney (BeanzMaster) - Peter Dyson (Dicepd)
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
       @item(http://lab.polygonal.de/2007/07/18/fast-and-accurate-sinecosine-approximation/)
       @item(https://en.wikipedia.org/wiki/Fast_inverse_square_root)
       @item(https://en.wikipedia.org/wiki/Taylor_series)
       @item(https://stackoverflow.com/questions/18662261/fastest-implementation-of-sine-cosine-and-square-root-in-c-doesnt-need-to-b)
       @item(https://en.wikipedia.org/wiki/Newton%27s_method)
       @item(http://allenchou.net/2014/02/game-math-faster-sine-cosine-with-polynomial-curves/)
       @item(http://www.ue.eti.pg.gda.pl/~wrona/lab_dsp/cw04/fun_aprox.pdf)
       @item(http://www.netlib.org/cephes/)
       @item(http://www.ue.eti.pg.gda.pl/~wrona/lab_dsp/cw04/fun_aprox.pdf)
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
unit GLZFastMath;

{$mode objfpc}{$H+}

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

interface

uses
  Classes, SysUtils;


{%region%-----[ Approximations functions ]--------------------------------------}
//------------------------------------------------------------------------------
// At This Stage just for testing. Unused function will comment in final version
// and stay for educational purpose
//------------------------------------------------------------------------------

// Cosinus
function TaylorCos(X:Single):Single;
function TaylorLambertCos(X : Single):Single;
function QuadraticCurveCosLP(x:Single):Single;
function QuadraticCurveCosHP(x:Single):Single;
function RemezCos( val: Single) : Single;

// Sinus
function TaylorSin(X:Single):Single;
function TaylorLambertSin(X : Single):Single;
function QuadraticCurveSinLP(x:Single):Single;
function QuadraticCurveSinHP(x:Single):Single;
function RemezSin(val:Single): Single;


{%endregion%}

Function FastSinc(x: Single): Single;

Function FastTan(x:Single):Single;
Function FastArcTan(x:Single):Single;
{ Fast ArcTan2 approximation, about 0.07 rads accuracy. }
Function FastArcTan2(y, x: Single): Single;

Function FastArcSine(Const x: Single): Single;
Function FastArcCosine(const X: Single): Single;

Function FastInvSqrt(Const Value: Single): Single;
Function FastSqrt(Const Value: Single): Single;

Function FastLn(Const X: Single): Single;

Function FastExp(x:Single):Single;

Function FastLog(x:Single):Single;

Function FastLog2(X: Single): Single;

Function FastLog10(X: Single): Single;

Function FastLDExp(x: Single; N: Integer): Single;

Function FastLNXP1(Const x: Single): Single;

Function FastAbs(f:single):single;

Function FastNeg(f:single):single;

Function FastSign(f:single):longint;

function FastPower(i:single;n:integer):single;



implementation

// On defini quelques valeurs en vue d'optimiser les calculs
Const
  _cInfinity = 1e1000;
  _EpsilonFuzzFactor = 1000;
  _EpsilonXTResolution = 1E-19 * _EpsilonFuzzFactor;
  _cPI: double = 3.1415926535897932384626433832795; //3.141592654;
  _cInvPI: Double = 1.0 / 3.1415926535897932384626433832795;
  _c2DivPI: Double = 2.0 / 3.1415926535897932384626433832795;
  _cPIdiv180: Single = 0.017453292;
  _cPI180 : Single =  3.1415926535897932384626433832795 * 180;
  _c180divPI: Single = 57.29577951;
  _c2PI: Single = 6.283185307;
  _cPIdiv2: Single = 1.570796326;
  _cPIdiv4: Single = 0.785398163;
  _c3PIdiv2: Single = 4.71238898;
  _c3PIdiv4: Single = 2.35619449;
  _cInv2PI: Single = 1 / 6.283185307;
  _cInv360: Single = 1 / 360;
  _c180: Single = 180;
  _c360: Single = 360;
  _cOneHalf: Single = 0.5;
  _cMinusOneHalf: Single = -0.5;
  _cOneDotFive: Single = 0.5;
  _cZero: Single = 0.0;
  _cOne: Single = 1.0;
  _cLn10: Single = 2.302585093;
  _cEpsilon: Single = 1e-10;
  _cEpsilon40 : Single = 1E-40;
  _cEpsilon30 : Single = 1E-30;
  _cFullEpsilon: Double = 1e-12;
  _cColinearBias = 1E-8;
  _cEulerNumber = 2.71828182846;
  _cInvSqrt2   = 1.0 / sqrt(2.0);
  _cInvThree   = 1.0 / 3.0;

Const
  _cTaylorCoefA : single = 1.0/2.0;
  _cTaylorCoefB : single = 1.0 / 24.0;
  _cTaylorCoefC : single = 1.0 / 720.0;
  _cTaylorCoefD : single = 1.0 / 40320.0;

//-----[ INCLUDE IMPLEMENTATION ]-----------------------------------------------

{$ifdef USE_ASM}
  {$ifdef CPU64}
    {$ifdef UNIX}
      {$ifdef USE_ASM_AVX}
        {$I fastmath_native_imp.inc}
        {$I fastmath_unix64_avx_imp.inc}
      {$else}
        {$I fastmath_native_imp.inc}
        {$I fastmath_unix64_sse_imp.inc}
      {$endif}
    {$else} // windows
      {$ifdef USE_ASM_AVX}
        {$I fastmath_native_imp.inc}
        {$I fastmath_unix64_avx_imp.inc}
      {$else}
        {$I fastmath_native_imp.inc}
        {$I fastmath_win64_sse_imp.inc}
      {$endif}
    {$endif}
  {$else} //cpu32
    {$ifdef USE_ASM_AVX}
      {$I fastmath_native_imp.inc}
      {$I fastmath_intel32_avx_imp.inc}
    {$else}
      {$I fastmath_native_imp.inc}
      {$I fastmath_intel32_sse_imp.inc}
    {$endif}
  {$endif}
{$else}
  {$I fastmath_native_imp.inc}
{$endif}

//------------------------------------------------------------------------------

Initialization


{Vec4 VSin(const Vec4& x)

Vec4 c1 = VReplicate(-1.f/6.f);
Vec4 c2 = VReplicate(1.f/120.f);
Vec4 c3 = VReplicate(-1.f/5040.f);
Vec4 c4 = VReplicate(1.f/362880);
Vec4 c5 = VReplicate(-1.f/39916800);
Vec4 c6 = VReplicate(1.f/6227020800);
Vec4 c7 = VReplicate(-1.f/1307674368000);

Vec4 res =	x +
c1*x*x*x +
c2*x*x*x*x*x +
c3*x*x*x*x*x*x*x +
c4*x*x*x*x*x*x*x*x*x +
c5*x*x*x*x*x*x*x*x*x*x*x +
c6*x*x*x*x*x*x*x*x*x*x*x*x*x +
c7*x*x*x*x*x*x*x*x*x*x*x*x*x*x*x;

return (res);


//-----------

Vec4 c1 = VReplicate(-1.f/6.f);
Vec4 c2 = VReplicate(1.f/120.f);
Vec4 c3 = VReplicate(-1.f/5040.f);
Vec4 c4 = VReplicate(1.f/362880);
Vec4 c5 = VReplicate(-1.f/39916800);
Vec4 c6 = VReplicate(1.f/6227020800);
Vec4 c7 = VReplicate(-1.f/1307674368000);

Vec4 tmp0 = x;
Vec4 x3 = x*x*x;
Vec4 tmp1 = c1*x3;
Vec4 res = tmp0 + tmp1;

Vec4 x5 = x3*x*x;
tmp0 = c2*x5;
res	= res + tmp0;

Vec4 x7 = x5*x*x;
tmp0 = c3*x7;
res	= res + tmp0;

Vec4 x9 = x7*x*x;
tmp0 = c4*x9;
res	= res + tmp0;

Vec4 x11 = x9*x*x;
tmp0 = c5*x11;
res	= res + tmp0;

Vec4 x13 = x11*x*x;
tmp0 = c6*x13;
res	= res + tmp0;

Vec4 x15 = x13*x*x;
tmp0 = c7*x15;
res	= res + tmp0;

return (res);

}


end.

