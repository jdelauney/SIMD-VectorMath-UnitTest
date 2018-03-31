(*====< GLZMath.pas >===========================================================@br
@created(2016-11-18)
@author(J.Delauney (BeanzMaster))
Historique : @br
@unorderedList(
  @item(18/11/2016 : Creation  )
)
--------------------------------------------------------------------------------@br

  Description : @br
  The GLZMath unit containss optimized mathematical functions. @br
  Appoximative functions can be used if desired (useful for real time). @br

  For example: @br
  The 'approximated' functions of Sin and Cos have an average accuracy of 4E-8.

  It includes trigonometric functions, calculating interpolations,
  Advanced features like Bessel, BlackMan. And also some useful functions

  It also has undefined functions in the FPC Math unit tel
  ArcCsc, ArcSec, ArcCot, CscH, SecH ect ... @ br

  For more mathematical functions see units: @br
  - @SeeAlso (GLZVectorMath), @SeeAlso (GLZFastMath), @SeeAlso (GLZRayMarchMath)

  ------------------------------------------------------------------------------ @br
  @bold(Notes :)

  Quelques liens :
   @unorderedList(
       @item(http://www.i-logic.com/utilities/trig.htm)
       @item(http://jacksondunstan.com/articles/1217)
       @item(http://mathworld.wolfram.com)
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
Unit GLZMath;

{$WARN 5036 on : Local variable "$1" does not seem to be initialized}
{$WARN 5025 on : Local variable "$1" not used}
{$WARN 5028 on : Local const "$1" not used}

{$mode objfpc}{$H+}

{$ASMMODE INTEL}

{.$DEFINE USE_FASTMATH}

Interface

{ TODO : Ajouter la prise en charge des nombre "Complex" }

Uses
  Classes, SysUtils, Math;

{%region%-----[ Usefull Math Constants ]----------------------------------------}

{ Commons usefull Math Constants @groupbegin}
Const
  cInfinity = 1e1000;
  EpsilonFuzzFactor = 1000;
  EpsilonXTResolution = 1E-19 * EpsilonFuzzFactor;
  cPI: Double = 3.1415926535897932384626433832795; //3.141592654;
  cInvPI: Double = 1.0 / 3.1415926535897932384626433832795;
  c2DivPI: Double = 2.0 / 3.1415926535897932384626433832795;
  cPIdiv180: Single = 3.1415926535897932384626433832795 / 180;
  cPI180 : Single =  3.1415926535897932384626433832795 * 180;
  c180divPI: Single = 180 / 3.1415926535897932384626433832795;
  c2PI: Single = 3.1415926535897932384626433832795*2; //5286766559;
  cPIdiv2: Single = 3.1415926535897932384626433832795 / 2;
  cPIdiv4: Single = 3.1415926535897932384626433832795 / 4;
  c3PIdiv2: Single = 3*3.1415926535897932384626433832795/2;
  c3PIdiv4: Single = 3*3.1415926535897932384626433832795/4;
  cInv2PI: Single = 1 / (2*3.1415926535897932384626433832795);
  cInv360: Single = 1 / 360;
  c180: Single = 180;
  c360: Single = 360;
  cOneHalf: Single = 0.5;
  cMinusOneHalf: Single = -0.5;
  cOneDotFive: Single = 0.5;
  cZero: Single = 0.0;
  cOne: Single = 1.0;
  cLn10: Single = 2.302585093;
  cEpsilon: Single = 1e-10;
  cEpsilon40 : Single = 1E-40;
  cEpsilon30 : Single = 1E-30;
  cFullEpsilon: Double = 1e-12;
  cColinearBias = 1E-8;
  cEulerNumber = 2.71828182846;
  cInvSqrt2   = 1.0 / sqrt(2.0);
  cInvThree   = 1.0 / 3.0;
  cInv255 = 1/255;
  // portées maximal les types de points flottants IEEE
  // Compatible avec Math.pas
  MinSingle   = 1.5e-45;
  MaxSingle   = 3.4e+38;
  MinDouble   = 5.0e-324;
  MaxDouble   = 1.7e+308;
  MinExtended = 3.4e-4932;
  MaxExtended = 1.1e+4932;
  // Complex
  MinComp     = -9.223372036854775807e+18;
  MaxComp     = 9.223372036854775807e+18;

{@groupbegin}

{%endregion%}

type
  {$ifdef USE_DOUBLE}
  TSinCos = record
    sin: double;
    cos: double;
  end;
  PSinCos = ^TSinCos;
  {$else}
  TSinCos = record
    sin: single;
    cos: single;
  end;
  PSinCos = ^TSinCos;
  {$endif}

Type
  { Type of interpolation. @SeeAlso(InterpolateValue)}
  TGLZInterpolationType = (itLinear, itPower, itSin, itSinAlt, itTan, itLn, itExp);

{%region%-----[ Rounding functions ]--------------------------------------------}


//function fmod(const a,b:Single):Integer;inline;

{ @name : Rounds a value towards its nearest integer
  @param(V value to round)
  @return(Rounded value)}
Function Round(v: Single): Integer; Overload;

{ @name : Rounds a value towards 0
  @param(V : Value to trunc)
  @return(Truncated value)}
Function Trunc(v: Single): Integer; Overload;

{ @name : Rounds a value towards negative infinity
  @param(v : value to floor)
  @return(Floored value)}
Function Floor(v: Single): Integer; Overload;

{ @name : Returns the fractional part of a number
  @param(v value where extract fractionnal part)
  @return(Fractionnal part)}
Function Fract(v:Single):Single;

{ @name : Rounds a value towards positive infinity
  @param(v : value to ceil)
  @return(Ceilled value)}
Function Ceil(v: Single): Integer; Overload;

{%endregion%}

{%region%-----[ General utilities functions ]-----------------------------------}

//operator mod(const a,b:Single):Single;inline;overload;

{ @name : calculates the remainder of a floating-point division
  @param(A : Number to divide)
  @param(A : Divisor)
  @return(remainder in floating point)}
function fmodf(const A,B:Single):Single;

{ @name : Clamps a given value into a range of two Integer values
  @param(V : Value to compare)
  @param(Min : Clamp to Minimum )
  @param(Max : Clamp to Maximum )
  @return(Value ensured in range [min..max])}
function Clamp(const V,Min,Max : integer) : integer; overload;

{ @name : Clamps a given value into a range of two Single values
  @param(V : Value to compare)
  @param(Min : Clamp to Minimum )
  @param(Max : Clamp to Maximum )
  @return(Value ensured in range [min..max])}
function Clamp(const V,Min,Max : Single):  Single; overload;

{ @name : Clamps a given value into a range of 0..255
  @param(V : Value to compare)
  @return(Value ensured in ragne [0..255])}
function ClampByte(Const Value:Integer):Byte;

{ @name : Check if value is near zero or absolute zero
  @param(A : Value to test)
  @param(Epsilon : Précision test, default absolute zero = 0.0)
  @return(@True if equal or less than Epsilon. @false otherwise)}
Function IsZero(Const A: Extended; Const Epsilon: Extended = 0.0): Boolean;

{ @name : Returns the sign of the x value using the (-1, 0, +1) convention
  @param(X : Value to get sign)
  @return(Sign :
   @unorderedlist(
     @item(-1 : Less than zero)
     @item( 0 : Equal to zero)
     @item(+1 : Greater than zero)
   )) }
Function Sign(x: Single): Integer;

{ @name : Returns the strict sign of the x value using the (-1,  +1) convention
  @param(X : Value to get Strict sign) )
  @return(Strict Sign :
    @unorderedlist(
      @item(-1 : Less than zero)
      @item(+1 : Equal or Greater than zero)
    )) }
Function SignStrict(x: Single): Integer;

{ @name : Rounds the floating point value to the closest Integer. @br
  Behaves like Round but returns a floating point value like Int.
  @param(v : value to round)
  @return(Rounded value)}
Function RoundInt(v: Single): Single;

{ @name : rounds a value towards its nearest integer
  @param()
  @return()}
Function NewRound(x: Single): Integer;

{ @name : Returns the maximum of three integer values
  @param(A : value 1)
  @param(B : value 2)
  @param(C : value 3)
  @return(The maximum value)}
Function Max(Const A, B, C: Integer): Integer; overload;

{ @name : Returns the minimum of three integer values
  @param(A : value 1)
  @param(B : value 2)
  @param(C : value 3)
  @return(The minimum value)}
Function Min(Const A, B, C: Integer): Integer; overload;

{ @name : Returns the maximum of two values
  @param(v1 : value 1)
  @param(v2 : value 2)
  @return(The maximum value)}
Function Max(Const v1, v2 : Single): Single; overload;

{ @name : Returns the minimum of two values
  @param(v1 : value 1)
  @param(v2 : value 2)
  @return(The minimum value)}
Function Min(Const v1, v2 : Single): Single; overload;

{ @name : calculates the maximum of three single values
  @param(A : value 1)
  @param(B : value 2)
  @param(C : value 3)
  @return(The maximum value)}
Function Max(Const v1, v2, v3: Single): Single; overload;

{ @name : calculates the minimum of three single values
  @param(A : value 1)
  @param(B : value 2)
  @param(C : value 3)
  @return(The minimum value)}
Function Min(Const v1, v2, v3: Single): Single; overload;

{ @name : Compute Reciprocal (1 / x)
  @param(x : value to get reciprocal)
  @return(Reciprocal)}
Function ComputeReciprocal(Const x: Single): Single;

{ @name : rounds a value towards its nearest integer
  @param(X : value to test)
  @param(A : minimum range value )
  @param(B : maximum range value )
  @return(@true if in range [a..b]. @false otherwise)}
Function IsInRange(const X, a, b: Single): Boolean;
//Function IsInRange(const X, a, b: Integer): Boolean;overload;


{%endregion%}

{%region%-----[ Angles functions ]----------------------------------------------}

{ @name : Normalize angle in radian
  @param(Angle : Value in radian to normalize)
  @return(Normalized value)}
Function NormalizeRadAngle(angle: Single): Single;

{ @name : Normalize angle in degree
  @param(Angle : Value in degree to normalize)
  @return(Normalized value)}
Function NormalizeDegAngle(angle: Single): Single;

{ @name : Compute distance between two angle
  @param(Angle1 : Value 1 in degree)
  @param(Angle2 : Value 2 in degree)
  @return(Distance between Angle1 and Angle2)}
Function DistanceBetweenAngles(angle1, angle2: Single): Single;

{ @name : converts degrees to radians
  @param(Degrees : Angle to convert in degrees 
  @return(Converted value as Radian)}
Function DegToRadian(Const Degrees: Single): Single;

{ @name : converts radians to degrees
  @param(Degrees : Angle to convert in Radian 
  @return(Converted value as Degrees)}
Function RadianToDeg(Const Radians: Single): Single;

{ @name : Linear interpolation between angle
  @param(Start : Start Angle)
  @param(Stop  : Stop Angle)
  @param(t : Current step in range [0..1])
  @return(Interpolated value)}
Function InterpolateAngleLinear(start, stop, t: Single): Single;


{%endregion%}

{%region%-----[ Power functions ]-----------------------------------------------}

{ @name : Returns if value is a power of two. 
  @param(Value : Value to test)
  @return(@True if the specified value is a power of two or @False otherwise)}
Function IsPowerOfTwo(Value: Longword): Boolean;

{ @name : Returns next power of two fro m value
  @param(Value : Value reference)
  @return(Next power of two)}
Function NextPowerOfTwo(Value: Cardinal): Cardinal;

{ @name : Returns previous power of two fro m value
  @param(Value : Value reference)
  @return(Previous power of two)}
Function PreviousPowerOfTwo(Value: Cardinal): Cardinal;

{ @name : Raise base to any power. For fractional exponents, or |exponents| > MaxInt, base must be > 0.
  @param(Base : Base)
  @param(Exponent : Exponent)
  @return(Single float precision Raise Base to Exponent power)}
function Pow(const Base, Exponent: Single): Single; overload;

{ @name : Raise float single precision base to Integer power
  @param(Base : Base)
  @param(Exponent : Exponent)
  @return(Single float precision Raise Base to Exponent power)}
function PowerInteger(Const Base: Single; Exponent: Integer): Single; overload;

{ @name : Raise Integer base to Integer power
  @param(Base : Base)
  @param(Exponent : Exponent)
  @return(Single float precision Raise Base to Exponent power)}
Function PowerInt(Const Base, Power: Integer): Single;

{ @name : Raise base to power of 3
  @param(X : Base)
  @return(Base raise by 3)}
Function pow3(x: Single): Single;

{%endregion%}

{%region%-----[ Trigonometric functions ]---------------------------------------}

{ Fills up the two given dynamic arrays with sin cos values.
   start and stop angles must be given in degrees, the number of steps is
   determined by the length of the given arrays. }
//procedure PrepareSinCosCache(var s, c : array of Single; startAngle, stopAngle : Single);

{ @name : Calculates sine from the given angle X 
  @param(X : Angle in radian)
  @return(Single float precision Sine)}
function Sin(x:Single):Single; overload;

{ @name : Calculates cosine from the given angle X 
  @param(X : Angle in radian)
  @return(Single float precision Cosine)}
function Cos(x:Single):Single; overload;

{ @name : calculates the tangent of an angle
  @param(X : Angle in radian)
  @return(Single float precision Tangent)}
function  Tan(const X : Single) : Single; overload;


{ @name : Calculates sine and cosine from the given angle Theta 
  @param(Theta in radian)
  @return(@unorderedlis(
    @item( Sin : Single float precision Sine)
    @item( Cos : Single float precision Cosine)}
procedure SinCos(const Theta: Single; out Sin, Cos: Single); overload;

{ @name : Calculates sine and cosine from the given angle Theta and Radius. @br
          sin and cos values calculated from theta are multiplicated by radius. 
  @param(Theta  : Angle in radian)
  @param(Radius : factor)
  @return(@unorderedlis(
    @item( Sin : Single float precision Sine)
    @item( Cos : Single float precision Cosine)}
procedure SinCos(const theta, radius : Single; out Sin, Cos: Single); overload;

{ @name : Compute the Hypotenuse 
  @param(X : Value)
  @param(Y : Value)
  @return(Hypotenus)}
Function Hypot(Const X, Y: Single): Single;
//Function Hypot(Const X, Y, Z: Single): Single;

{ @name : Calculates cotangent from the given angle X 
  @param(X : Angle in radian)
  @return(Single float precision Cotangent)}
function  CoTan(const X : Single) : Single; overload;

{%endregion%}

{%region%-----[ Inverse trigonometric functions ]-------------------------------}

{ @name : calculates an arc cosine
  @param(X : Angle in radian)
  @return(Single float precision Inverse Cosine)}
function  ArcCos(const x : Single) : Single; overload;

{ @name : calculates an arc sine
  @param(X : Angle in radian)
  @return(Single float precision Inverse Sine)}
Function  ArcSin(Const x: Single): Single;

{ @name : calculates an arctangent for angle and quadrant
  @param(X : Angle in radian)
  @param(Y : Quadrant)
  @return(Single float precision Inverse Tangent)}
function  ArcTan2(const Y, X : Single) : Single; overload;

{ @name : Calculates Inverse Cosecant from the given value
  @param(X : Value)
  @return(Single float precision Inverse Cosecant)}
Function ArcCsc(Const X: Single): Single;

{ @name : Calculates Inverse Secant from the given value
  @param(X : Value)
  @return(Single float precision Inverse Secant)}
Function ArcSec(Const X: Single): Single;

{ @name : Calculates Inverse Cotangent from the given value
  @param(X : Value)
  @return(Single float precision Inverse Cotangent)}
Function ArcCot(Const X: Single): Single;

{%endregion%}

{%region%-----[ Hyperbolic functions ]------------------------------------------}

{ @name : calculates a hyperbolic sine
  @param(X : Value)
  @return(Single float precision Hyperbolic Sine)}
function Sinh(const x : Single) : Single; overload;

{ @name : calculates a hyperbolic cosine
  @param(X : Value)
  @return(Single float precision Hyperbolic Cosine)}
function Cosh(const x : Single) : Single; overload;

{ @name : calculates a hyperbolic cosecant
  @param(X : Value)
  @return(Single float precision Hyperbolic Cosecant)}
Function CscH(Const X: Single): Single;

{ @name : calculates a hyperbolic Secant
  @param(X : Value)
  @return(Single float precision Hyperbolic Secant)}
Function SecH(Const X: Single): Single;

{ @name : calculates a hyperbolic Cotangent
  @param(X : Value)
  @return(Single float precision Hyperbolic Cotangent)}
Function CotH(Const X: Extended): Extended;

{ @name : calculates a hyperbolic Sine/Cosine
  @param(X : Value)
  @return(Single float precision Hyperbolic Sine/Cosine)}
Function SinCosh(Const x: Single): Single;

{%endregion%}

{%region%-----[ Inverse hyperbolic functions ]----------------------------------}

{ @name : calculates a Inverse hyperbolic CoSecant
  @param(X : Value)
  @return(Single float precision Inverse Hyperbolic CoSecant)}
Function ArcCscH(Const X: Single): Single;

{ @name : calculates a Inverse hyperbolic Secant
  @param(X : Value)
  @return(Single float precision Inverse Hyperbolic Secant)}
Function ArcSecH(Const X: Single): Single;

{ @name : calculates a Inverse hyperbolic CoTangent
  @param(X : Value)
  @return(Single float precision Inverse Hyperbolic CoTangent)}
Function ArcCotH(Const X: Single): Single;

{%endregion%}

{%region%-----[ Square root functions ]-----------------------------------------}

{ @name : calculates square root
  @param(A : Value)
  @return(Squared root value)}
function Sqrt(const A: Single): Single; overload;

{ @name : calculates an inverse square root 
  @param(v : Value)
  @return(Inverse Squared root value)}
Function InvSqrt(v: Single): Single;

{%endregion%}

{%region%-----[ Logarithmic functions ]-----------------------------------------}

{ @name : calculates a base 2 logarithm
  @param(X : Value)
  @return(Log2 value)}
Function Log2(X: Single): Single; Overload;

{ @name : calculates a base 10 logarithm
  @param(X : Value)
  @return(Log10 value)}
function Log10(X: Single): Single;

{ @name : calculates a base N logarithm
  @param(Base : Value)
  @param(N : Value)
  @return(Log N value)}
function LogN(Base, X: Single): Single;

{%endregion%}

{%region%-----[ Exponentiation functions ]--------------------------------------}

{ @name : calculates a natural exponentiation
  @param(X : Value)
  @return(Exp value)}
Function Exp(Const X: Single): Single;

{ @name : multiplies x by 2 power of n.
  @param(X : Value)
  @param(N : Exponent)
  @return(Exp value)}
Function ldExp(x: Single; N: Integer): Single;

{%endregion%}

{%region%-----[ Natural logarithmic functions ]---------------------------------}

{ @name :  calculates a natural logarithm
  @param(X : Value)
  @return(Logarithmic value)}
Function Ln(Const X: Single): Single;

{ @name : Return ln(1 + X),  accurate for X near 0. 
  @param(X : Value)
  @return(Logarithmic XP1 value)}
Function LnXP1(x: Single): Single;

{%endregion%}

{%region%-----[ Interpolation functions ]---------------------------------------}

{ @name : Compute Bessel Order Onefactor
  @param(X : Value)
  @return(Bessel Order One Double float precicion)}
Function BesselOrderOne(x: Double): Double;

{ @name : Compute Bessel factor
  @param(X : Value)
  @return(Bessel Double float precicion)}
Function Bessel(x: Double): Double;

{ @name : Compute Bessel IO factor
  @param(X : Value)
  @return(Bessel IO Double float precicion)}
Function BesselIO(x: Double): Double;

{ @name : Compute Blackman factor
  @param(X : Value)
  @return(Blackman Double float precicion)}
Function Blackman(x: Double): Double;

{ @name : A phase shifter sinc curve can be useful if it starts at zero and ends at zero,
  for some bouncing behaviors (suggested by Hubert-Jan). Give k different integer values
  to tweak the amount of bounces. It peaks at 1.0, but that take negative values, which
  can make it unusable in some applications
  @param(X : Value)
  @return(Sinc Single float precision)}
Function Sinc(x: Single): Single;

{ @name : Do the same as "Lerp", but add some distortions.
  @param(Start : Start Value)
  @param(Stop : Stop Value)
  @param(Delta : Delta Value)
  @param(Distortion : Distortion Value in degree)
  @param(InterpolationType : Kind of interpolation. @SeeAlso(TGLZInterpolationType)) )
  @return(Interpolated value at Delta)}
Function InterpolateValue(Const Start, Stop, Delta: Single; Const DistortionDegree: Single; Const InterpolationType: TGLZInterpolationType): Single;

{ @name : Do the same as "Lerp", but add some distortions, fast
  @param(OriginalStart : Start Value)
  @param(OriginalStop : Stop Value)
  @param(OriginalCurrent : Delta Value)
  @param(TargetStart : Start Value)
  @param(TargetStop : Stop Value)
  @param(Distortion : Distortion Value in degree)
  @param(InterpolationType : Kind of interpolation. @SeeAlso(TGLZInterpolationType)) )
  @return(Interpolated value at Delta)}
Function InterpolateValueFast(Const OriginalStart, OriginalStop, OriginalCurrent: Single; Const TargetStart, TargetStop: Single;Const DistortionDegree: Single; Const InterpolationType: TGLZInterpolationType): Single;

{ @name : Do the same as "Lerp", but add some distortions, values are checked
  @param(OriginalStart : Start Value)
  @param(OriginalStop : Stop Value)
  @param(OriginalCurrent : Delta Value)
  @param(TargetStart : Start Value)
  @param(TargetStop : Stop Value)
  @param(Distortion : Distortion Value in degree)
  @param(InterpolationType : Kind of interpolation. @SeeAlso(TGLZInterpolationType)) )
  @return(Interpolated value at Delta)}
Function InterpolateValueSafe(Const OriginalStart, OriginalStop, OriginalCurrent: Single; Const TargetStart, TargetStop: Single;Const DistortionDegree: Single; Const InterpolationType: TGLZInterpolationType): Single;

// Interpolation Lineaire
// Interpolation Logarythmique
// Interpolation Exponentielle
//Interpolation par puissance
// Interpolation Sinuosidale Alt
// Interpolation Sinuosidale Alt
// Interpolation par tangente

{%endregion%}

{%region%-----[ HL/GL Shader Language script like functions ]-------------------}

{ @name :Perform Hermite interpolation between two values
  @param(Edge0 : Start Value)
  @param(Edge1 : Stop Value)
  @param(X : Position Value)
  @return(Smoothed value) }
function SmoothStep(Edge0,Edge1,x: Single): Single;

{ @name : Perform linear interpolation between two values
  @param(Edge0 : Start Value)
  @param(Edge1 : Stop Value)
  @param(X : Position Value)
  @return(Lerp value) }
function Lerp(Edge0,Edge1,x: Single): Single;

{ @name : Generate a step function by comparing two values
  @param(Edge : Value 1)
  @param(X : Value 2)
  @return(0.0 is returned if x < edge, and 1.0 is returned otherwise) }   
function Step(Edge,x: Single): Single;

{ @name : Return the lenght of vector 1D
  @param(X : Value)
  @return(Length of X)}
Function Length1D(x:Single):Single;

{%endregion%}

{%region%-----[usefull functions for animations or interpolations ]-------------}

{ @name : blend  value with  threshold, and  smooth it with a cubic polynomial.
  @param(X : Value to Blend)
  @param(M : Thresold)
  @param(N : Value things will take when X is zero.
  @return(Smoothed value)
  @SeeAlso(http://www.iquilezles.org/www/articles/functions/functions.htm)}
Function AlmostIdentity( x,m,n : single ):single;

{ @name : Great for triggering behaviours or making envelopes for music or animation
  @param(K :control the stretching)
  @param(X : A Value)
  @return(Smoothed Value)
  @SeeAlso(http://www.iquilezles.org/www/articles/functions/functions.htm)}
function Impulse(k,x : Single):Single;

{ @name : Cubic interpolation. Same as smoothstep(c-w,c,x)-smoothstep(c,c+w,x)@br
  You can use it as a cheap replacement for a gaussian
  @param(C : Value)
  @param(W : Value)
  @param(X : Value to smoothed)
  @return(Smoothed Value)
  @SeeAlso(http://www.iquilezles.org/www/articles/functions/functions.htm)}
Function CubicPulse(c,w,x : Single) : Single;

{ @name : A natural attenuation
  @param(X : Value to smoothed)
  @param(K : Limit Value)
  @param(N : Power exponent)
  @return(Smoothed Value)
  @SeeAlso(http://www.iquilezles.org/www/articles/functions/functions.htm)}
Function ExpStep(x,k,n:Single):Single;

{ @name : Remap the 0..1 interval into 0..1, such that the corners are remapped to 0 and the center to 1 @br
          @bold(Note : ) parabola(0) = parabola(1) = 0, and parabola(1/2) = 1
  @param(X :  Value)
  @param(N : Power exponent)
  @return(Smoothed Value)
  @SeeAlso(http://www.iquilezles.org/www/articles/functions/functions.htm)}
Function Parabola(x,k:Single):Single;

{ @name : Remap the 0..1 interval into 0..1, such that the corners are remapped to 0. @br
          Very useful to skew the shape one side or the other in order to make leaves, eyes, and many other interesting shapes
  @param(X : Value)
  @param(A : Value)
  @param(B : Value)
  @return(Curved Value)
  @SeeAlso(http://www.iquilezles.org/www/articles/functions/functions.htm)}
Function pcurve(x,a,b:Single):Single;

{ @name : Remapping the unit interval into the unit interval by expanding the sides and compressing the center, and keeping 1/2 mapped to 1/2 @br
          This was a common function in RSL tutorials (the Renderman Shading Language).
  @param(X : Value)
  @param(K :k=1 is the identity curve, k<1 produces the classic gain() shape, and k>1 produces "s" shaped curces. @br
         @bold(Note : ) The curves are symmetric (and inverse) for k=a and k=1/a.
  @return(Curved value)
  @SeeAlso(http://www.iquilezles.org/www/articles/functions/functions.htm)}
Function pGain(x,k:Single):Single;

{ @name : A phase shifter sinc curve
  @param(X : Value)
  @param(K : Value)
  @return(Curved value)
  @SeeAlso(SinC)
  @SeeAlso(http://mathworld.wolfram.com/SincFunction.html)}
Function pSinc(x,k:Single):Single;overload;

{%endregion%}

{%region%-----[ Others tools functions ]----------------------------------------}

{ @name : Convert a value to percent from range of [min..max]
  @param(Min : Minimum value)
  @param(Val : Value to get percent)
  @param(Min : Maximum value)
  @return(Percent)}
Function Val2Percent(min, val, max: Single): Integer;

{%endregion%}

Implementation

{$IFDEF USE_FASTMATH} uses  GLZFastMath;{$ENDIF}

{%region%-----[ Reintroduced some general functions ]---------------------------}

//operator mod(const a,b:Single):Single;
function fmodf(const a,b:Single):Single; Inline;
begin
    result := a-b * trunc(a/b);
end;


Function Round(v: Single): Integer;Inline;
Begin
  {$HINTS OFF}
  Result := System.round(v);
  {$HINTS ON}
End;

Function Trunc(v: Single): Integer;Inline;
Begin
  {$HINTS OFF}
  Result := System.Trunc(v);
  {$HINTS ON}
End;

function Fract(v : Single) : Single;Inline;
begin
  result := v - trunc(v);
  //result := frac(v); //v-Int(v);
end;

function Sin(x:Single):Single;Inline;
begin
  {$IFDEF USE_FASTMATH}
    result := FastSinLUT(x);//RemezSin(x);
  {$ELSE}
    result := System.Sin(x);
  {$ENDIF}
end;

function Cos(x:Single):Single; Inline;
begin
  {$IFDEF USE_FASTMATH}
    result := FastCosLUT(x); //RemezCos(x);
  {$ELSE}
    result := System.Cos(x);
  {$ENDIF}
end;

procedure SinCos(const Theta: Single; out Sin, Cos: Single);
var
   s, c : Single;
begin
  {$ifdef USE_FASTMATH}
    //C := RemezCos(Theta);
    //S := RemezCos(cPIdiv2-Theta);
    S := FastSinLUT(Theta);
    C := FastCosLUT(Theta);
  {$else}
     Math.SinCos(Theta, s, c);
  {$endif}
  {$HINTS OFF}
     Sin:=s; Cos:=c;
  {$HINTS ON}
end;

procedure SinCos(const theta, radius : Single; out Sin, Cos: Single);
var
   s, c : Single;
begin
  {$ifdef USE_FASTMATH}
    //C := RemezCos(Theta);
    //S := RemezCos(cPIdiv2-Theta);
    S := FastSinLUT(Theta);
    C := FastCosLUT(Theta);
  {$else}
     Math.SinCos(Theta, s, c);
  {$endif}
  {$HINTS OFF}
     Sin:=s; Cos:=c;
  {$HINTS ON}
   Sin:=s*radius; Cos:=c*radius;
end;

{$endregion}

{%region%-----[ General utilities functions ]-----------------------------------}

function Clamp(const V,Min,Max : integer) : integer;
begin
  Result := V;
  if Result > Max then begin result := Max; exit; end;
  if Result < Min then result := Min;
end;

function Clamp(const V,Min,Max : Single) : Single;
begin
  Result := V;
  if V > Max then result := Max
  else if V < Min then result := Min;
end;

{$IFNDEF NO_ASM_OPTIMIZATIONS}
function ClampByte(const Value: Integer): Byte; assembler; nostackframe;
asm
{$IFDEF CPU64}
  {$IFDEF UNIX}
     MOV     EAX,EDI
  {$ELSE}
     // in win x64 calling convention parameters are passed in ECX, EDX, R8 & R9
     MOV     EAX,ECX
  {$ENDIF}
{$ENDIF}
        TEST    EAX,$FFFFFF00
        JNZ     @above
        RET
@above:
        JS      @below
        MOV     EAX,$FF
        RET
@Below:     XOR     EAX,EAX
end;
{$ELSE}
function ClampByte(const Value: Integer): Byte;
begin
 Result := Value;
 if Value > 255 then Result := 255
 else if Value < 0 then Result := 0;
end;
{$ENDIF}


Function IsZero(Const A: Extended; Const Epsilon: Extended = 0.0): Boolean; Inline;
Var
  e: Extended;
Begin
  If Epsilon = 0 Then
    E := EpsilonXTResolution
  Else
    E := Epsilon;
  Result := Abs(A) <= E;
End;

Function Sign(x: Single): Integer;  Inline;
Begin
  {$IFDEF USE_FASTMATH}
    Result := FastSign(x);
  {$ELSE}
    If x < 0 Then
      Result := -1
    Else If x > 0 Then
      Result := 1
    Else
      Result := 0;
  {$ENDIF}
End;

Function SignStrict(x: Single): Integer; Inline;
Begin
  If x < 0 Then
    Result := -1
  Else
    Result := 1;
End;

Function RoundInt(v: Single): Single;Inline;
Begin
  {$HINTS OFF}
  //Result := system.int
  Result := System.Round(v + cOneDotFive);
  {$HINTS ON}
End;

Function NewRound(x: Single): Integer; Inline;
Var
  y: Integer;
Begin
  y := 0;
  If (x - floor(x) < 0.5) Then
    y := floor(x)
  Else If (x - floor(x) = 0) Then
    y := Trunc(x)
  Else
    y := Trunc(x) + 1;
  Result := y;
End;

Function Ceil(v: Single): Integer; Inline;
Begin
  {$HINTS OFF}
  //If Fract(v) > 0 Then
  //  Result := Trunc(v) + 1
  //Else
  //  Result := Trunc(v);
  Result := Trunc(v);
  if (v - Result) > 0 then Inc(Result);
  {$HINTS ON}
End;

Function Floor(v: Single): Integer;Inline;
var i:integer;
Begin
   {$HINTS OFF}

  result :=0;
  if (v=0.0) then exit
  else If (v > 0) Then
    Result := System.Trunc(v)
  Else
    Result := System.Trunc(v-0.999999999);

  {$HINTS ON}
End;

function Min(const v1, v2 : Single) : Single; Inline;
begin
   if v1<v2 then Result:=v1
   else Result:=v2;
end;

function Max(const v1, v2 : Single) : Single; Inline;
begin
   if v1>v2 then Result:=v1
   else Result:=v2;
end;

Function Min(Const v1, v2, v3: Single): Single; Inline;
Var
  N: Single;
Begin
  N := v3;
  If v1 < N Then N := v1;
  If v2 < N Then N := v2;
  Result := N;
End;

Function Max(Const v1, v2, v3: Single): Single; Inline;
Var
  N: Single;
Begin
  N := v3;
  If v1 > N Then N := v1;
  If v2 > N Then N := v2;
  Result := N;
End;

{$IFDEF USE_ASM}
Function Max(Const A, B, C: Integer): Integer;   Assembler; Register;
asm
  {$IFDEF CPU64}
    {$IFDEF UNIX}
        MOV       EAX, EDI
        CMP       ESI, EAX
        CMOVG     EAX, ESI
        CMP       EDX, EAX
        CMOVG     EAX, EDX
    {$ELSE}
        MOV       RAX, RCX
        MOV       RCX, R8
        CMP       EDX, EAX
        CMOVG     EAX, EDX
        CMP       ECX, EAX
        CMOVG     EAX, ECX
    {$ENDIF}
  {$ELSE}
        CMP       EDX, EAX
        CMOVG     EAX, EDX
        CMP       ECX, EAX
        CMOVG     EAX, ECX
  {$ENDIF}
End;
{$else}
Function Max(Const A, B, C: Integer): Integer; Inline;
Var
  n: Integer;
Begin
  If A > C Then
    N := A
  Else
    N := C;
  If B > N Then
    N := B;
  Result := N;
End;
{$endif}

{$IFDEF USE_ASM}
Function Min(Const A, B, C: Integer): Integer;  Assembler; Register;
Asm
  {$IFDEF CPU64}
    {$IFDEF UNIX}
        MOV       EAX, EDI
        CMP       ESI, EAX
        CMOVL     EAX, ESI
        CMP       EDX, EAX
        CMOVL     EAX, EDX
    {$ELSE}
        MOV       RAX, RCX
        MOV       RCX, R8
        CMP       EDX, EAX
        CMOVL     EAX, EDX
        CMP       ECX, EAX
        CMOVL     EAX, ECX
    {$ENDIF}
{$ELSE}
        CMP       EDX, EAX
        CMOVL     EAX, EDX
        CMP       ECX, EAX
        CMOVL     EAX, ECX
{$ENDIF}
End;
{$else}
Function Min(Const A, B, C: Integer): Integer; Inline;
Var
  n: Integer;
Begin
  If A < C Then
    N := A
  Else
    N := C;
  If B < N Then
    N := B;
  Result := N;
End;
{$endif}

Function ComputeReciprocal(Const x: Single): Single; Inline;
Var
  a: Integer;
Begin
  Result := 0;
  If x = 0 Then exit;
  a := Sign(x);
  If ((a * x) >= cEpsilon) Then
    Result := 1.0 / x
  Else
    Result := a * (1.0 / cEpsilon);
End;

Function IsInRange(const X, a, b: Single): Boolean; Inline;
begin
  if a < b then
    result := (a <= X) and (X <= b)
  else
    result := (b <= X) and (X <= a);
end;

{%endregion%}

{%region%-----[ Utilities functions for Angle ]---------------------------------}

Function NormalizeRadAngle(angle: Single): Single;inline;
Begin
  Result := angle - RoundInt(angle * cInv2PI) * c2PI;
  If Result > cPI Then Result := Result -  c2PI
  Else If Result < -PI Then Result := Result +  c2PI;
End;

Function NormalizeDegAngle(angle: Single): Single;
Begin
  Result := angle - RoundInt(angle * cInv360) * c360;
  If Result > c180 Then Result := Result - c360
  Else If Result < -c180 Then Result := Result + c360;
End;

Function DistanceBetweenAngles(angle1, angle2: Single): Single;
Begin
  angle1 := NormalizeRadAngle(angle1);
  angle2 := NormalizeRadAngle(angle2);
  Result := Abs(angle2 - angle1);
  If Result > cPI Then Result := c2PI - Result;
End;

Function DegToRadian(Const Degrees: Single): Single;
Begin
  Result := Degrees * cPIdiv180;
End;

Function RadianToDeg(Const Radians: Single): Single;
Begin
  Result := Radians * c180divPI;
End;

{%endregion}

{%region%-----[ Utilities functions for Power ]---------------------------------}

Function IsPowerOfTwo(Value: Longword): Boolean;
Const
  BitCountTable: Array[0..255] Of Byte =
    (0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8);

  Function BitCount(Value: Longword): Longword; inline;
  Var
    V: Array[0..3] Of Byte absolute Value;
  Begin
    Result := BitCountTable[V[0]] + BitCountTable[V[1]] + BitCountTable[V[2]] + BitCountTable[V[3]];
  End;
Begin
  Result := BitCount(Value) = 1;
End;

Function PreviousPowerOfTwo(Value: Cardinal): Cardinal;
Var
  I, N: Cardinal;
Begin
  Result := 0;
  For I := 14 Downto 2 Do
  Begin
    N := (1 Shl I);
    If N < Value Then
      Break
    Else
      Result := N;
  End;
End;

Function NextPowerOfTwo(Value: Cardinal): Cardinal;
Begin
  If (Value > 0) Then
  Begin
    Dec(Value);
    Value := Value Or (Value Shr 1);
    Value := Value Or (Value Shr 2);
    Value := Value Or (Value Shr 4);
    Value := Value Or (Value Shr 8);
    Value := Value Or (Value Shr 16);
  End;

  Result := Value + 1;
End;

function Pow(const base, exponent : Single) : Single;
begin
  {$IFDEF USE_FASTMATH}
    if exponent=cZero then Result:=cOne
    else if (base=cZero) and (exponent>cZero) then Result:=cZero
    else if RoundInt(exponent)=exponent then Result:=FastPower(base, Integer(Round(exponent)))
    else Result:=FastExp(exponent*FastLn(base));
  {$ELSE}
    {$HINTS OFF}
    if exponent=cZero then Result:=cOne
    else if (base=cZero) and (exponent>cZero) then Result:=cZero
    else if RoundInt(exponent)=exponent then Result:=Power(base, Integer(Round(exponent)))
    else Result:=Exp(exponent*Ln(base));
    {$HINTS ON}
   {$ENDIF}
end;

function PowerInteger(Const Base: Single; Exponent: Integer): Single;
begin
  {$IFDEF USE_FASTMATH}
    result := FastPower(Base,Exponent);
  {$ELSE}
    {$HINTS OFF}
    Result:=Math.Power(Base, Exponent);
    {$HINTS ON}
  {$ENDIF}
end;

Function PowerInt(Const Base, Power: Integer): Single;
Var
  I:    Integer;
  Temp: Double;
Begin
  Temp := 1;

  For I := 0 To Pred(Power) Do
    Temp := Temp * Base;

  Result := Temp;
End;

{%endregion}

{%region%-----[ Trigonometric functions ]---------------------------------------}

function ArcCos(const x : Single): Single;
begin
  {$IFDEF USE_FASTMATH}
    if Abs(X) > 1.0 then
       Result := FastArcCosine(Sign(X))
     else
     Result:=FastArcCosine(X);
  {$ELSE}
    {$HINTS OFF}
     if Abs(X) > 1.0 then
       Result := Math.ArcCos(Sign(X))
     else
     Result:=Math.ArcCos(X);
   {$HINTS ON}
  {$ENDIF}
end;

function ArcSin(const x : Single) : Single;
begin
  {$IFDEF USE_FASTMATH}
    Result:= FastArcTan2(X, Sqrt(1 - Sqr(X)))
  {$ELSE}
    Result:= Math.ArcTan2(X, Sqrt(1 - Sqr(X)))
  {$ENDIF}
end;

function ArcTan2(const y, x : Single) : Single;
begin
  {$IFDEF USE_FASTMATH}
    Result:= FastArcTan2(x, y)
  {$ELSE}
    Result:= Math.ArcTan2(x,y)
  {$ENDIF}
end;

Function ArcCsc(Const X: Single): Single;
Begin
  If IsZero(X) Then
    Result := cInfinity
  Else
    Result := ArcSin(1 / X);
End;

Function ArcSec(Const X: Single): Single;
Begin
  If IsZero(X) Then
    Result := cInfinity
  Else
    Result := ArcCos(1 / X);
End;

Function ArcCot(Const X: Single): Single;
Begin
  If IsZero(X) Then Result := cPIDiv2
  Else
    {$IFDEF USE_FASTMATH}
      Result := FastArcTan(1 / X);
    {$ELSE}
      Result := ArcTan(1 / X);
    {$ENDIF}
End;

Function CscH(Const X: Single): Single;
Begin
  Result := 1 / SinH(X);
End;

Function SecH(Const X: Single): Single;
Begin
  Result := 1 / CosH(X);
End;

Function CotH(Const X: Extended): Extended;
Begin
  Result := 1 / TanH(X);
End;

Function ArcCscH(Const X: Single): Single;
Begin
  {$IFDEF USE_FASTMATH}
    If IsZero(X) Then Result := cInfinity
    Else
    If X < 0 Then
      Result := FastLn((1 - FastInvSqrt(1 + X * X)) * X)
    Else
      Result := FastLn((1 + FastInvSqrt(1 + X * X)) * X);
  {$ELSE}
    If IsZero(X) Then
      Result := Infinity
    Else
    If X < 0 Then
      Result := Ln((1 - Sqrt(1 + X * X)) / X)
    Else
      Result := Ln((1 + Sqrt(1 + X * X)) / X);
  {$ENDIF}
End;

Function ArcSecH(Const X: Single): Single;
Begin
  {$IFDEF USE_FASTMATH}
  If IsZero(X) Then Result := cInfinity
  Else If SameValue(X, 1) Then Result := 0
  Else
    Result := FastLn((FastInvSqrt(1 - X * X) + 1) * X);
  {$ELSE}
    If IsZero(X) Then Result := cInfinity
    Else If SameValue(X, 1) Then Result := 0
    Else
      Result := Ln((Sqrt(1 - X * X) + 1) / X);
  {$ENDIF}
End;

Function ArcCotH(Const X: Single): Single;
Begin
  {$IFDEF USE_FASTMATH}
    If SameValue(X, 1) Then Result := cInfinity // 1.0 / 0.0
    Else If SameValue(X, -1) Then Result := -cInfinity // -1.0 / 0.0
    Else
      Result := 0.5 * FastLn((X + 1) / (X - 1));
  {$ELSE}
    If SameValue(X, 1) Then Result := cInfinity // 1.0 / 0.0
    Else If SameValue(X, -1) Then Result := -cInfinity // -1.0 / 0.0
    Else
      Result := 0.5 * Ln((X + 1) / (X - 1));
  {$ENDIF}
End;

function Tan(const x : Single) : Single;
begin
  {$IFDEF USE_FASTMATH}
    Result := FastTan(x);
  {$ELSE}
    {$HINTS OFF}
    Result:=Math.Tan(x);
    {$HINTS ON}
  {$ENDIF}
end;

function CoTan(const x : Single) : Single;
begin
   {$HINTS OFF}
   Result:=Math.CoTan(x);
   {$HINTS ON}
end;

function Sinh(const x : Single) : Single;
begin
   {$IFDEF USE_FASTMATH}
      Result:=0.5*(FastExp(x) - FastExp(-x));
   {$ELSE}
     Result:=0.5*(Exp(x)- Exp(-x));
   {$ENDIF}
end;

function Cosh(const x : Single) : Single;
begin
  {$IFDEF USE_FASTMATH}
     Result:=0.5*(FastExp(x)+ FastExp(-x));
  {$ELSE}
    Result:=0.5*(Exp(x)+ Exp(-x));
  {$ENDIF}
end;

Function SinCosh(Const x: Single): Single;
Begin
  {$IFDEF USE_FASTMATH}
    Result := 0.5 * (FastExp(x) - FastExp(-x));
  {$ELSE}
    Result := 0.5 * (Exp(x) - Exp(-x));
  {$ENDIF}
End;

function Sqrt(const A: Single): Single;
Begin
  {$IFDEF USE_FASTMATH}
    Result := FastSqrt(A);
  {$ELSE}
    Result := System.Sqrt(A);
  {$ENDIF}
End;

Function InvSqrt(v: Single): Single;
var s : single;
Begin
  {$IFDEF USE_FASTMATH}
    Result := FastInvSqrt(v);
  {$ELSE}
    s:= System.sqrt(v); //+ EpsilonXTResolution;
    Result := 1 / s;
  {$ENDIF}
End;

Function LnXP1(X: Single): Single;
{$IFDEF USE_FASTMATH}   Var  y: Single; {$ENDIF}
Begin
  {$IFDEF USE_FASTMATH}
    If (x >= 4.0) Then
      Result := FastLn(1.0 + x)
    Else
    Begin
      y := 1.0 + x;
      If (y = 1.0) Then
        Result := x
      Else
      Begin
        Result := FastLn(y);     // lnxp1(-1) = ln(0) = -Inf
        If y > 0.0 Then
          Result := Result + (x - (y - 1.0)) / y;
      End;
    End;
  {$ELSE}
    Result := Math.LnXP1(X);
  {$ENDIF}
End;

Function Log10(X: Single): Single;
// Log10(X):=Log2(X) * Log10(2)
Begin
  {$IFDEF USE_FASTMATH}
     Result := FastLog10(x);
  {$ELSE}
     Result := Math.Log10(X);
    //Result := Ln(x) * 0.4342944819;    // 1/ln(10)
  {$ENDIF}
End;

Function Log2(X: Single): Single;
Begin
  {$IFDEF USE_FASTMATH}
     Result := FastLog2(x);
  {$ELSE}
    Result := Math.Log2(X);
   //Result := Ln(x) * 1.4426950408889634079;    // 1/ln(2)
  {$ENDIF}

End;

Function LogN(Base, X: Single): Single;
Begin
  {$IFDEF USE_FASTMATH}
    // LogN(X):=Log2(X) / Log2(N)
    Result := FastLog2(Base) / FastLog2(X);
  {$ELSE}
    Result := Math.LogN(Base, X);
  {$ENDIF}
End;

Function Exp(Const X: Single): Single;
Var
  I, N: Integer;
  D:    Double;
Begin
  If (X = 1.0) Then
    Result := cEulerNumber
  Else
  If (x < 0) Then
    Result := 1.0 / Exp(-X)
  Else
  Begin
    N := 2;
    Result := 1.0 + X;
    Repeat
      D := X;
      For I := 2 To N Do
      Begin
        D := D * (X / I);
      End;

      Result := Result + D;
      Inc(N);
    Until (d <= cEpsilon);
  End;
End;

Function Ln(Const X: Single): Single;
Var
  Lo, Hi, Mid, Val: Single;
Begin
  If (X < 0) Then
  Begin
    Result := 0;
    Exit;
  End;

  // use recursion to get approx range
  If (X < 1) Then
  Begin
    Result := -ln(1 / X);
    Exit;
  End;

  If (X > cEulerNumber) Then
  Begin
    Result := Ln(X / cEulerNumber) + 1;
    Exit;
  End;

  // X is now between 1 and e
  // Y is between 0 and 1
  lo := 0.0;
  hi := 1.0;

  While (True) Do
  Begin
    mid := (lo + hi) / 2;
    val := exp(mid);
    If (val > X) Then hi := mid;

    If (val < X) Then lo := mid;

    If (abs(val - X) < cEpsilon) Then
    Begin
      Result := mid;
      Exit;
    End;
  End;
End;

Function ldexp(x: Single; N: Integer): Single;
Var
  r: Single;
Begin
  R := 1;
  If N > 0 Then
  Begin
    While N > 0 Do
    Begin
      R := R * 2;
      Dec(N);
    End;
  End
  Else
  Begin
    While N < 0 Do
    Begin
      R := R / 2;
      Inc(N);
    End;
  End;

  Result := x * R;
End;

Function pow3(x: Single): Single;
Begin
  If x = 0.0 Then
    Result := 0.0
  Else
    Result := x * x * x;
End;

Function Sinc(x: Single): Single;
{$IFNDEF USE_FASTMATH} Var xx: Single; {$ENDIF}
Begin
  {$IFDEF USE_FASTMATH}
  If x = 0.0 Then Result := 1.0
  Else FastSinC(x);
  {$ELSE}
    If x = 0.0 Then
      Result := 1.0
    Else
    Begin
      xx := cPI * x;
      Result := System.Sin(xx) / (xx);
    End;
  {$ENDIF}
End;

Function Hypot(Const X, Y: Single): Single; Inline;
Begin
  {$IFDEF USE_FASTMATH}
    Result := FastSqrt((X*X) + (Y*Y));
  {$ELSE}
    Result := Sqrt(Sqr(X) + Sqr(Y));
  {$ENDIF}
End;

{%endregion%}

{%region%-----[ Interpolation functions ]---------------------------------------}

Function BesselOrderOne(x: Double): Double;
Var
  p, q: Double;

  Function J1(x: Double): Double;
  Const
    Pone: Array[0..8] Of Double =
      (
      0.581199354001606143928050809e+21, -0.6672106568924916298020941484e+20,
      0.2316433580634002297931815435e+19, -0.3588817569910106050743641413e+17,
      0.2908795263834775409737601689e+15, -0.1322983480332126453125473247e+13,
      0.3413234182301700539091292655e+10, -0.4695753530642995859767162166e+7,
      0.270112271089232341485679099e+4
      );
    Qone: Array[0..8] Of Double =
      (
      0.11623987080032122878585294e+22,
      0.1185770712190320999837113348e+20,
      0.6092061398917521746105196863e+17,
      0.2081661221307607351240184229e+15,
      0.5243710262167649715406728642e+12,
      0.1013863514358673989967045588e+10,
      0.1501793594998585505921097578e+7,
      0.1606931573481487801970916749e+4,
      0.1e+1
      );
  Var
    pj, qj: Double;
    i:      Byte;
  Begin
    pj := 0.0;
    qj := 0.0;
    pj := Pone[8];
    qj := Qone[8];
    For i := 7 Downto 0 Do
    Begin
      pj := pj * x * x + Pone[i];
      qj := qj * x * x + Qone[i];
    End;
    Result := (pj / qj);
  End;

  Function P1(x: Double): Double;
  Const
    Pone: Array[0..5] Of Double =
      (
      0.352246649133679798341724373e+5,
      0.62758845247161281269005675e+5,
      0.313539631109159574238669888e+5,
      0.49854832060594338434500455e+4,
      0.2111529182853962382105718e+3,
      0.12571716929145341558495e+1
      );
    Qone: Array[0..5] Of Double =
      (
      0.352246649133679798068390431e+5,
      0.626943469593560511888833731e+5,
      0.312404063819041039923015703e+5,
      0.4930396490181088979386097e+4,
      0.2030775189134759322293574e+3,
      0.1e+1
      );
  Var
    xx, pp, qp: Double;
    i: Byte;
  Begin
    pp := 0.0;
    qp := 0.0;
    pp := Pone[5];
    qp := Qone[5];
    xx := 8.0 / x;
    xx := xx * xx;
    For i := 4 Downto 0 Do
    Begin
      pp := pp * xx + Pone[i];
      qp := qp * xx + Qone[i];
    End;
    Result := (pp / qp);
  End;

  Function Q1(x: Double): Double;
  Const
    Pone: Array[0..5] Of Double =
      (
      0.3511751914303552822533318e+3,
      0.7210391804904475039280863e+3,
      0.4259873011654442389886993e+3,
      0.831898957673850827325226e+2,
      0.45681716295512267064405e+1,
      0.3532840052740123642735e-1
      );
    Qone: Array[0..5] Of Double =
      (
      0.74917374171809127714519505e+4,
      0.154141773392650970499848051e+5,
      0.91522317015169922705904727e+4,
      0.18111867005523513506724158e+4,
      0.1038187585462133728776636e+3,
      0.1e+1
      );
  Var
    xx, pq, qq: Double;
    i: Byte;
  Begin
    pq := 0.0;
    qq := 0.0;
    pq := Pone[5];
    qq := Qone[5];
    xx := 8.0 / x;
    xx := xx * xx;
    For i := 4 Downto 0 Do
    Begin
      pq := pq * xx + Pone[i];
      qq := qq * xx + Qone[i];
    End;
    Result := (pq / qq);
  End;

Begin
  Result := 0.0;
  If x = 0.0 Then
    exit;
  p := x;
  If x < 0.0 Then
    x := -x;
  If x < 8.0 Then
    Result := p * J1(x)
  Else
  Begin
    q := Sqrt(2.0 / (cPI * x)) * (P1(x) * (cInvSqrt2 * (sin(x) - cos(x))) - 8.0 / x * Q1(x) * (-cInvSqrt2 * (sin(x) + cos(x))));
    If p < 0.0 Then
      q := -q;
    Result := q;
  End;
End;

Function Bessel(x: Double): Double;
Begin
  If x = 0.0 Then
    Result := cPIdiv4
  Else
    Result := BesselOrderOne(cPI * x) / (2.0 * x);
End;

Function BesselIO(X: Double): Double;
Var
  I: Integer;
  Sum, Y, T: Double;
Begin
  Y := Sqr(0.5 * X);
  T := Y;
  I := 2;
  Sum := 0.0;
  While T > cFullEpsilon Do
  Begin
    Sum := Sum + T;
    T := T * (Y / (I * I));
    Inc(I);
  End;
  Result := Sum;
End;

Function Blackman(x: Double): Double;
Var
  xpi: Double;
Begin
  xpi := PI * x;
  Result := 0.42 + 0.5 * cos(xpi) + 0.08 * cos(2 * xpi);
End;

Function InterpolateAngleLinear(start, stop, t: Single): Single;
Var
  d: Single;
Begin
  start := NormalizeRadAngle(start);
  stop := NormalizeRadAngle(stop);
  d := stop - start;
  If d > PI Then
  Begin
    // positive d, angle on opposite side, becomes negative i.e. changes direction
    d := -d - c2PI;
  End
  Else If d < -PI Then
  Begin
    // negative d, angle on opposite side, becomes positive i.e. changes direction
    d := d + c2PI;
  End;
  Result := start + d * t;
End;

Function InterpolateLinear(Const start, stop, t: Single): Single;
Begin
  Result := start + (stop - start) * t;
End;

Function InterpolateLn(Const Start, Stop, Delta: Single; Const DistortionDegree: Single): Single;
Begin
  Result := (Stop - Start) * Ln(1 + Delta * DistortionDegree) / Ln(1 + DistortionDegree) + Start;
End;

Function InterpolateExp(Const Start, Stop, Delta: Single; Const DistortionDegree: Single): Single;
Begin
  Result := (Stop - Start) * Exp(-DistortionDegree * (1 - Delta)) + Start;
End;

Function InterpolatePower(Const Start, Stop, Delta: Single; Const DistortionDegree: Single): Single;
Var
  i: Integer;
Begin
  If (Round(DistortionDegree) <> DistortionDegree) And (Delta < 0) Then
  Begin
    i := Round(DistortionDegree);
    Result := (Stop - Start) * PowerInteger(Delta, i) + Start;
  End
  Else
    Result := (Stop - Start) * Power(Delta, DistortionDegree) + Start;
End;

Function InterpolateSinAlt(Const Start, Stop, Delta: Single): Single;
Begin
  Result := (Stop - Start) * Delta * Sin(Delta * cPIDiv2) + Start;
End;

Function InterpolateSin(Const Start, Stop, Delta: Single): Single;
Begin
  Result := (Stop - Start) * Sin(Delta * cPIDiv2) + Start;
End;

Function InterpolateTan(Const Start, Stop, Delta: Single): Single;
Begin
  Result := (Stop - Start) * Tan(Delta * cPIDiv4) + Start;
End;

Function InterpolateValue(Const Start, Stop, Delta: Single; Const DistortionDegree: Single; Const InterpolationType: TGLZInterpolationType): Single;
Begin
  Case InterpolationType Of
    itLinear: Result := InterpolateLinear(Start, Stop, Delta);
    itPower: Result := InterpolatePower(Start, Stop, Delta, DistortionDegree);
    itSin: Result := InterpolateSin(Start, Stop, Delta);
    itSinAlt: Result := InterpolateSinAlt(Start, Stop, Delta);
    itTan: Result := InterpolateTan(Start, Stop, Delta);
    itLn: Result := InterpolateLn(Start, Stop, Delta, DistortionDegree);
    itExp: Result := InterpolateExp(Start, Stop, Delta, DistortionDegree);
    Else
    Begin
      Result := -1;
    End;
  End;
End;

Function InterpolateValueSafe(Const OriginalStart, OriginalStop, OriginalCurrent: Single; Const TargetStart, TargetStop: Single;
  Const DistortionDegree: Single; Const InterpolationType: TGLZInterpolationType): Single;
Var
  ChangeDelta: Single;
Begin
  If OriginalStop = OriginalStart Then
    Result := TargetStart
  Else
  Begin
    ChangeDelta := (OriginalCurrent - OriginalStart) / (OriginalStop - OriginalStart);
    Result := InterpolateValue(TargetStart, TargetStop, ChangeDelta, DistortionDegree, InterpolationType);
  End;
End;

Function InterpolateValueFast(Const OriginalStart, OriginalStop, OriginalCurrent: Single; Const TargetStart, TargetStop: Single;
  Const DistortionDegree: Single; Const InterpolationType: TGLZInterpolationType): Single;
Var
  ChangeDelta: Single;
Begin
  ChangeDelta := (OriginalCurrent - OriginalStart) / (OriginalStop - OriginalStart);
  Result := InterpolateValue(TargetStart, TargetStop, ChangeDelta, DistortionDegree, InterpolationType);
End;

{%endregion%}

{%region%-----[ Pixel Shader functions ]----------------------------------------}

function SmoothStep(Edge0,Edge1,x: Single): Single;Inline;
var
  t:single;
begin
  t:= Clamp((x-Edge0) / (Edge1 - Edge0),0.0,1.0);
  result := t * t * (3.0 - 2.0 * t); //t*t * ((t*2.0)*3.0);
end;

function Lerp(Edge0,Edge1,x: Single): Single; Inline;
begin
  result := Edge0 * (1 - x) + (Edge1 * x);
end;

function Step(Edge,x: Single): Single;
begin
  if x<Edge then result := 0.0 else result := 1.0;
end;

Function Length1D(x:Single):Single; Inline;
begin
  Result := Sqrt(x*x);
end;


//------------------------------------------------------------------

{%endregion%}

{%region%-----[Others useful functions for shader ]-----------------------------}

// Converted from http://www.iquilezles.org/www/articles/functions/functions.htm

// Useful for animation

Function AlmostIdentity( x,m,n : single ):single;Inline;
var
  a,b,t : Single;
begin
    if (x>m) then
    begin
      result:= x;
      exit;
    end;
    a := 2.0*n - m;
    b := 2.0*m - 3.0*n;
    t := x/m;
    result := (a*t + b)*t*t + n;
end;

function Impulse(k,x : Single):Single; Inline;
var
  h:Single;
begin
  h := k*x;
  result := h * exp(1.0-h);
end;

Function CubicPulse(c,w,x : Single) : Single; Inline;
begin
  result := 0.0;
  x := abs(x - c);
  if(x>w ) then exit;
  x := x / w;
  Result := 1.0 - x * x * (3.0-2.0 * x);
end;

Function ExpStep(x,k,n:Single):Single;Inline;
begin
  result := Exp(-k * pow(x,n));
end;

Function Parabola(x,k:Single):Single;Inline;
begin
  result := pow( 4.0*x*(1.0-x), k );
end;

Function pcurve(x,a,b:Single):Single;Inline;
var
  k : Single;
begin
    k := pow(a+b,a+b) / (pow(a,a) * pow(b,b));
    result := k * pow(x, a) * pow(1.0-x, b);
end;

Function pSinc(x,k:Single):Single;Inline;
var
  a : Single;
begin
  a := cPI * (k*x-1.0);
  Result := sin(a)/a;
end;

Function pGain(x,k:Single):Single; Inline;
var
  a : Single;
begin
   if x<0.5 then
   begin
     a := 0.5 * Pow(2.0*x,k);
     Result := a;
   end
   else
   begin
    a := 0.5 * Pow(2.0*(1.0-x),k);
    result :=1.0-a;
   end;
end;

{%endregion%}

{%region%-----[ Others functions ]----------------------------------------------}

Function Val2Percent(min, val, max: Single): Integer;
Var
  S: Single;
Begin
  If max = min Then
    S := 0
  Else If max < min Then
    S := 100 * ((val - max) / (min - max))
  Else
    S := 100 * ((val - min) / (max - min));
  If S < 0 Then
    S := 0;
  If S > 100 Then
    S := 100;
  Result := round(S);
End;

{%endregion%}

initialization
 {$IFDEF USE_FASTMATH}
  _InitSinLUT;
 {$ENDIF}

finalization
 {$IFDEF USE_FASTMATH}
 _DoneSinLUT;
 {$ENDIF}


End.
