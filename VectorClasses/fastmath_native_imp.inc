{%region%-----[ Utils Approximations Functions ]--------------------------------}

function TaylorCos(X:Single):Single; inline;
var
  xx,xx2 : single;
begin
    xx := x+x;
    xx2 :=xx*xx;
		result := 1
			- xx * _cTaylorCoefA
			+ xx2 * _cTaylorCoefB
			- (xx2 * xx) * _cTaylorCoefC
			+ (xx2 * xx2) * _cTaylorCoefD;
end;

function TaylorSin(X:Single):Single; inline;
begin
 result := TaylorCos(_cPIdiv2-X);
end;

function TaylorLambertCos(X : Single):Single; Inline;
var
  xx : Single;
begin
    xx := x*x;
		result := (0.9999932946 + xx * (-0.4999124376 + xx * (0.0414877472 + xx * -0.0012712095)));
end;

function TaylorLambertSin(X:Single):Single; inline;
begin
 result := TaylorLambertCos(_cPIdiv2-X);
end;

// low precision sine/cosine   ?????
//http://lab.polygonal.de/2007/07/18/fast-and-accurate-sinecosine-approximation/
function QuadraticCurveSinLP(x:Single):Single; Inline;
begin
  //always wrap input angle to -PI..PI
  if (x < - _cPI) then x := x + _C2PI
  else
  if (x >  _cPI) then x := x -_c2PI;

  //compute sine
  if (x < 0) then
      result := 1.27323954 * x + 0.405284735 * x * x
  else
      result := 1.27323954 * x - 0.405284735 * x * x;
end;

function QuadraticCurveCosLP(x:Single):Single; Inline;
begin
  //always wrap input angle to -PI..PI
  if (x >  _cPI) then x := x -_c2PI;

  //compute cosine: sin(x + PI/2) = cos(x)
  x := x + 1.57079632;
  if (x >  _cPI) then x := x - _c2PI;

  if (x < 0) then
      result := 1.27323954 * x + 0.405284735 * x * x
  else
      result := 1.27323954 * x - 0.405284735 * x * x;
end;

// high precision sine/cosine    ?????
function QuadraticCurveSinHP(x:Single):Single; Inline;
var
  s,ss,temp:Single;
begin
  //always wrap input angle to -PI..PI
  if (x < - _cPI) then x := x + _C2PI
  else
  if (x >  _cPI) then x := x -_c2PI;

//compute sine
  if (x < 0) then
    ss := 1.27323954 * x + 0.405284735 * x * x
  else
    ss := 1.27323954 * x - 0.405284735 * x * x;

   temp := x * _c2DivPI;
   s := temp * ( 2 - temp );
   s := ss * ( 0.225 * ( ss - 1 ) + 1 );

  result := ss;
end;

//compute cosine: sin(x + PI/2) = cos(x)
function QuadraticCurveCosHP(x:Single):Single; Inline;
var c:Single;
begin
 x:= x + 1.57079632;
 if (x >  _cPI) then x := x - _c2PI;

  if (x < 0) then
  begin
    c := 1.27323954 * x + 0.405284735 * x * x;

    if (c < 0) then
        c := 225 * (c *-c - c) + c
    else
        c := 225 * (c * c - c) + c;
  end
  else
  begin
    c := 1.27323954 * x - 0.405284735 * x * x;

    if (c < 0) then
        c := 0.225 * (c *-c - c) + c
    else
        c := 0.225 * (c * c - c) + c;
  end;
  result := c;
end;

// http://sollya.gforge.inria.fr
// Correct only in [-pi, pi] - Absolute error bounded by 5e-5 - Continuous error
function RemezCos( val: Single) : Single; inline;
var val2 : single;
begin
  val2 := val*val;

  (* Generated in Sollya using:
     > f = remez(cos(x)-1, [|x*x, x*x*x*x, x*x*x*x*x*x, x*x*x*x*x*x*x*x|],
                             [0.000001, pi], 1, 1e-8);
     > plot(f-cos(x)+1, [0, pi]);
     > f+1
 *)
  result :=
    1.0 + val2 *
    (-0.49985158205212948 + val2 *
     (4.151803521644389800e-2 + val2 *
      (-1.34229470252267675e-3 + val2 *
       1.89298648243010005378029e-5)));
end;

// Correct only in [-pi, pi] - Absolute error bounded by 6e-6 - Continuous error
function RemezSin(val:Single): Single;inline;
var
  val2 : Single;
begin
  Val2 := val*val;
  result:=
    val * (0.99997937679290771484375 + val2 *
           (-0.166624367237091064453125 + val2 *
            (8.30897875130176544189453125e-3 + val2 *
             (-1.92649182281456887722015380859375e-4 + val2 *
              2.147840177713078446686267852783203125e-6))));
end;

{%endregion%}

{%region%-----[ Fast Trigonometric Functions ]----------------------------------}

Function FastArcTangent2(y, x: Single): Single; inline;// accuracy of about 0.07 rads
Var
  abs_y: Single;
Begin
  abs_y := Abs(y) + _cEpsilon;      // prevent 0/0 condition
  If y < 0 Then
  Begin
    If x >= 0 Then
      Result := _cPIdiv4 * (x - abs_y) / (x + abs_y) - _cPIdiv4
    Else
      Result := _cPIdiv4 * (x + abs_y) / (abs_y - x) - _c3PIdiv4;
  End
  Else
  Begin
    If x >= 0 Then
      Result := _cPIdiv4 - _cPIdiv4 * (x - abs_y) / (x + abs_y)
    Else
      Result := _c3PIdiv4 - _cPIdiv4 * (x + abs_y) / (abs_y - x);
  End;
End;

Function FastArcSine(Const x: Single): Single;
Begin
  Result := FastArcTangent2(X, Sqrt(1 - (X*X)));
  //Result := x + x * x * x * x * x * 0.4971;
End;

Function FastInvSqrt(Const Value: Single): Single; Inline;
Var
  IntCast: Cardinal absolute Result;
Begin
  Result := Value;
  IntCast := ($BE6EB50C - IntCast) Shr 1;
  Result := 0.5 * Result * (3 - Value * Sqr(Result));
End;

Function FastSqrt(Const Value: Single): Single; Inline;
Var
  IntCast: Cardinal absolute Result;
Begin
  Result := Value;
  IntCast := ($5F3759DF - IntCast) Shr 1;
  Result := 0.5 * Result * (3 - Value * Sqr(Result));
End;

{%endregion%}

