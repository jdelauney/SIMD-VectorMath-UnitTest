(*====< GLZMath.pas >===========================================================@br
@created(2016-11-18)
@author(J.Delauney (BeanzMaster))
Historique : @br
@unorderedList(
  @item(18/11/2016 : Creation  )
)
--------------------------------------------------------------------------------@br
  ------------------------------------------------------------------------------
  Description :
  L'unité GLZMath regroupe des fonctions mathematiques, optimisées et jusqu'à
  100% plus rapide que celle implemntée dans l'unité "Math" de base.@br
  Elle inclue des fonctions avancées comme par exemple le calcul sur les angles,
  le calcul d'interpolations, de fonctions avancées comme Bessel, BlackMan.
  Elle dispose également de fonctions non définies dans l'unité Math de FPC tel
  que ArcCsc, ArcSec, ArcCot, CscH, SecH ect...@br
  Pour plus de fonction mathématique voir unités :  GLZVectorMath
  ------------------------------------------------------------------------------
  @bold(Notes :)

  Quelques liens :
   @unorderedList(
       @item(http://www.i-logic.com/utilities/trig.htm)
       @item(http://jacksondunstan.com/articles/1217)
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
Unit GLZMath;

{.$i glzscene_options.inc}

{$ASMMODE INTEL}

{.$DEFINE USE_FASTMATH}

Interface

{ TODO : Ajouter la prise en charge des nombre "Complex" }

Uses
  Classes, SysUtils, Math,
  GLZTypes;

{%region%-----[ Usefull Math Constants ]----------------------------------------}
Const
  cInfinity = 1e1000;
  EpsilonFuzzFactor = 1000;
  EpsilonXTResolution = 1E-19 * EpsilonFuzzFactor;
  cPI: Double = 3.1415926535897932384626433832795; //3.141592654;
  cInvPI: Double = 1.0 / 3.1415926535897932384626433832795;
  c2DivPI: Double = 2.0 / 3.1415926535897932384626433832795;
  cPIdiv180: Single = 0.017453292;
  cPI180 : Single =  3.1415926535897932384626433832795 * 180;
  c180divPI: Single = 57.29577951;
  c2PI: Single = 6.283185307;
  cPIdiv2: Single = 1.570796326;
  cPIdiv4: Single = 0.785398163;
  c3PIdiv2: Single = 4.71238898;
  c3PIdiv4: Single = 2.35619449;
  cInv2PI: Single = 1 / 6.283185307;
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

{%endregion%}

{%region%-----[ Reintroduced some general functions ]---------------------------}

//operator mod(const a,b:Single):Single;inline;overload;
function fmodf(const a,b:Single):Single;
//function fmod(const a,b:Single):Integer;inline;

Function Round(v: Single): Integer; Overload;
Function Trunc(v: Single): Integer; Overload;
Function Floor(v: Single): Integer; Overload;
Function Fract(v:Single):Single;
Function Ceil(v: Single): Integer; Overload;

// Calculates sine and cosine from the given angle Theta
procedure SinCos(const Theta: Single; out Sin, Cos: Single); overload;
{ Calculates sine and cosine from the given angle Theta and Radius.
   sin and cos values calculated from theta are multiplicated by radius. }
procedure SinCos(const theta, radius : Single; out Sin, Cos: Single); overload;
function Sin(x:Single):Single; overload;
function Cos(x:Single):Single; overload;


{%endregion%}

{%region%-----[ General utilities functions ]-----------------------------------}

Function IsZero(Const A: Extended; Const Epsilon: Extended = 0.0): Boolean;
Function Sign(x: Single): Integer;
Function SignStrict(x: Single): Integer;
Function RoundInt(v: Single): Single;
Function NewRound(x: Single): Integer;
Function Max(Const A, B, C: Integer): Integer; overload;
Function Min(Const A, B, C: Integer): Integer; overload;
Function Max(Const v1, v2 : Single): Single;
Function Min(Const v1, v2 : Single): Single;
Function Max(Const v1, v2, v3: Single): Single;
Function Min(Const v1, v2, v3: Single): Single;
Function ComputeReciprocal(Const x: Single): Single;
Function IsInRange(const X, a, b: Single): Boolean;


{%endregion%}

{%region%-----[ Utilities functions for Angle ]---------------------------------}

Function NormalizeRadAngle(angle: Single): Single;
Function NormalizeDegAngle(angle: Single): Single;
Function DistanceBetweenAngles(angle1, angle2: Single): Single;
Function DegToRadian(Const Degrees: Single): Single;
Function RadianToDeg(Const Radians: Single): Single;

{%endregion%}

{%region%-----[ Utilities functions for Power ]---------------------------------}

Function IsPowerOfTwo(Value: Longword): Boolean;
Function NextPowerOfTwo(Value: Cardinal): Cardinal;
Function PreviousPowerOfTwo(Value: Cardinal): Cardinal;
{Raise base to any power. For fractional exponents, or |exponents| > MaxInt, base must be > 0. }
function PowerSingle(const Base, Exponent: Single): Single; overload;
function PowerInteger(Const Base: Single; Exponent: Integer): Single; overload;
Function PowerInt(Const Base, Power: Integer): Single;
Function pow3(x: Single): Single;

{%endregion%}

{%region%-----[ Trigonometric functions ]---------------------------------------}

{ Fills up the two given dynamic arrays with sin cos values.
   start and stop angles must be given in degrees, the number of steps is
   determined by the length of the given arrays. }
procedure PrepareSinCosCache(var s, c : array of Single; startAngle, stopAngle : Single);
function  Tan(const X : Single) : Single; overload;
function  ArcCos(const x : Single) : Single; overload;
Function  ArcSin(Const x: Single): Single;
function  ArcTan2(const Y, X : Single) : Single; overload;
function  CoTan(const X : Single) : Single; overload;
Function ArcCsc(Const X: Single): Single;
Function ArcSec(Const X: Single): Single;
Function ArcCot(Const X: Single): Single;
function Sinh(const x : Single) : Single; overload;
function Cosh(const x : Single) : Single; overload;
Function CscH(Const X: Single): Single;
Function SecH(Const X: Single): Single;
Function CotH(Const X: Extended): Extended;
Function ArcCscH(Const X: Single): Single;
Function ArcSecH(Const X: Single): Single;
Function ArcCotH(Const X: Single): Single;
Function SinCosh(Const x: Single): Single;
Function InvSqrt(v: Single): Single;
Function Log2(X: Single): Single; Overload;
Function Exp(Const X: Single): Single;
Function Ln(Const X: Single): Single;
Function LnXP1(x: Single): Single;

// ldexp() multiplies x by 2**n.
// Interpolation Lineaire
// Interpolation Logarythmique
// Interpolation Exponentielle
//Interpolation par puissance
// Interpolation Sinuosidale Alt
// Interpolation Sinuosidale Alt
// Interpolation par tangente

{ : A phase shifter sinc curve can be useful if it starts at zero and ends at zero,
  for some bouncing behaviors (suggested by Hubert-Jan). Give k different integer values
  to tweak the amount of bounces. It peaks at 1.0, but that take negative values, which
  can make it unusable in some applications. }
Function Sinc(x: Single): Single;

Function Hypot(Const X, Y: Single): Single;

{%endregion%}

{%region%-----[ Interpolation functions ]---------------------------------------}

Function BesselOrderOne(x: Double): Double;
Function Bessel(x: Double): Double;
Function BesselIO(x: Double): Double;
Function Blackman(x: Double): Double;
Function InterpolateAngleLinear(start, stop, t: Single): Single;
Function InterpolateValue(Const Start, Stop, Delta: Single; Const DistortionDegree: Single; Const InterpolationType: TGLZInterpolationType): Single;
Function InterpolateValueFast(Const OriginalStart, OriginalStop, OriginalCurrent: Single; Const TargetStart, TargetStop: Single;Const DistortionDegree: Single; Const InterpolationType: TGLZInterpolationType): Single;
Function InterpolateValueSafe(Const OriginalStart, OriginalStop, OriginalCurrent: Single; Const TargetStart, TargetStop: Single;Const DistortionDegree: Single; Const InterpolationType: TGLZInterpolationType): Single;

{%endregion%}

{%region%-----[ Pixel Shader and Raymarch functions ]---------------------------}

{ : perform Hermite interpolation between two values }
function SmoothStep(Edge0,Edge1,x: Single): Single;
{: perform linear interpolation between two values }
function Lerp(Edge0,Edge1,x: Single): Single;
{: Generate a step function by comparing two values
   0.0 is returned if x < edge, and 1.0 is returned otherwise }
function Step(Edge,x: Single): Single;

// Return the lenght of vector 1D
Function Length1D(x:Single):Single; overload;

{%endregion%}

{%region%-----[Others useful functions for shader ]-----------------------------}

// For Animation or Interpolation
Function AlmostIdentity( x,m,n : single ):single;
function Impulse(k,x : Single):Single;
Function CubicPulse(c,w,x : Single) : Single;
Function ExpStep(x,k,n:Single):Single;
Function Parabola(x,k:Single):Single;
Function pcurve(x,a,b:Single):Single;
Function Sinc(x,k:Single):Single;overload;



//------------------------------------------------------------------------------

{%endregion%}

{%region%-----[ Others functions ]----------------------------------------------}

Function Val2Percent(min, val, max: Single): Integer;

{ : Multiplies values in the array by factor.<p>
  This function is especially efficient for large arrays, it is not recommended
  for arrays that have less than 10 items.<br>
  Expected performance is 4 to 5 times that of a Deliph-compiled loop on AMD
  CPUs, and 2 to 3 when 3DNow! isn't available. }
Procedure ScaleFloatArray(values: PSingleArray; nb: Integer; Var factor: Single); Overload;
Procedure ScaleFloatArray(Var values: TSingleArray; factor: Single); Overload;

{ : Adds delta to values in the array.<p>
  Array size must be a multiple of four. }
Procedure OffsetFloatArray(values: PSingleArray; nb: Integer; Var delta: Single); Overload;
Procedure OffsetFloatArray(Var values: Array Of Single; delta: Single); Overload;
Procedure OffsetFloatArray(valuesDest, valuesDelta: PSingleArray; nb: Integer); Overload;

{%endregion%}

Implementation

uses GLZUtils {$IFDEF USE_FASTMATH}, GLZFastMath{$ENDIF};

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
end;

function Sin(x:Single):Single;Inline;
begin
  {$IFDEF USE_FASTMATH}
    result := RemezSin(x);
  {$ELSE}
    result := System.Sin(x);
  {$ENDIF}
end;

function Cos(x:Single):Single; Inline;
begin
  {$IFDEF USE_FASTMATH}
    result := RemezCos(x);
  {$ELSE}
    result := System.Cos(x);
  {$ENDIF}
end;

procedure SinCos(const Theta: Single; out Sin, Cos: Single);
var
   s, c : Single;
begin
  {$ifdef USE_FASTMATH}
    C := RemezCos(Theta);
    S := RemezCos(cPIdiv2-Theta);
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
    C := RemezCos(Theta);
    S := RemezCos(cPIdiv2-Theta);
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
  Result := system.int(v + cOneDotFive);
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
Begin
   {$HINTS OFF}
  //If v < 0 Then
  //  Result := System.Trunc(v) - 1
  //Else
  //  Result := System.Trunc(v);
  Result := Trunc(v);
  if (v - Result) < 0 then Dec(Result);
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

function PowerSingle(const base, exponent : Single) : Single;
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

procedure PrepareSinCosCache(var s, c : array of Single;startAngle, stopAngle : Single);
var
   i : Integer;
   d, alpha, beta : Single;
begin
   Assert((High(s)=High(c)) and (Low(s)=Low(c)));
   stopAngle:=stopAngle+1e-5;
   if High(s)>Low(s) then
      d:=cPIdiv180*(stopAngle-startAngle)/(High(s)-Low(s))
   else d:=0;

   if High(s)-Low(s)<1000 then begin
      // Fast computation (approx 5.5x)
      alpha:=2*Sqr(Sin(d*0.5));
      beta:=Sin(d);
      SinCos(startAngle*cPIdiv180, s[Low(s)], c[Low(s)]);
      for i:=Low(s) to High(s)-1 do begin
         // Make use of the incremental formulae:
         // cos (theta+delta) = cos(theta) - [alpha*cos(theta) + beta*sin(theta)]
         // sin (theta+delta) = sin(theta) - [alpha*sin(theta) - beta*cos(theta)]
         c[i+1]:= c[i] - alpha * c[i] - beta * s[i];
         s[i+1]:= s[i] - alpha * s[i] + beta * c[i];
      end;
   end else begin
      // Slower, but maintains precision when steps are small
      startAngle:=startAngle*cPIdiv180;
      for i:=Low(s) to High(s) do
         SinCos((i-Low(s))*d+startAngle, s[i], c[i]);
   end;
end;

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

Function InvSqrt(v: Single): Single;
Begin
  {$IFDEF USE_FASTMATH}
    Result := FastInvSqrt(v);
  {$ELSE}
    Result := 1 / Sqrt(v);
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

Function LogN(Base, X: Extended): Extended;
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
  If x <= 0.0 Then
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
  result := Exp(-k * powersingle(x,n));
end;

Function Parabola(x,k:Single):Single;Inline;
begin
  result := powersingle( 4.0*x*(1.0-x), k );
end;

Function pcurve(x,a,b:Single):Single;Inline;
var
  k : Single;
begin
    k := powersingle(a+b,a+b) / (powersingle(a,a) * powersingle(b,b));
    result := k * powersingle(x, a) * powersingle(1.0-x, b);
end;

Function Sinc(x,k:Single):Single;Inline;
var
  a : Single;
begin
  a := cPI * (k*x-1.0);
  Result := sin(a)/a;
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

Procedure ScaleFloatArray(values: PSingleArray; nb: Integer; Var factor: Single);
Var
  i: Integer;
Begin
  For i := 0 To nb - 1 Do
    values^[i] := values^[i] * factor;
End;

Procedure ScaleFloatArray(Var values: TSingleArray; factor: Single);
Begin
  If System.Length(values) > 0 Then
    ScaleFloatArray(@values[0], System.Length(values), factor);
End;

Procedure OffsetFloatArray(values: PSingleArray; nb: Integer; Var delta: Single);
Var
  i: Integer;
Begin
  For i := 0 To nb - 1 Do
    values^[i] := values^[i] + delta;
End;

Procedure OffsetFloatArray(Var values: Array Of Single; delta: Single);
Begin
  If System.Length(values) > 0 Then
    OffsetFloatArray(@values[0], System.Length(values), delta);
End;

Procedure OffsetFloatArray(valuesDest, valuesDelta: PSingleArray; nb: Integer);
Var
  i: Integer;
Begin
  For i := 0 To nb - 1 Do
    valuesDest^[i] := valuesDest^[i] + valuesDelta^[i];
End;

{%endregion%}

Initialization

Finalization


End.
