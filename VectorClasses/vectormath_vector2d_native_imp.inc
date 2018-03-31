{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

procedure TGLZVector2d.Create(aX,aY: Double);
begin
  Self.X := aX;
  Self.Y := aY;
end;

function TGLZVector2d.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+')';
End;

class operator TGLZVector2d.-(constref A: TGLZVector2d): TGLZVector2d;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

class operator TGLZVector2d.=(constref A, B: TGLZVector2d): Boolean;
begin
 result := ((A.X = B.X) And (A.Y = B.Y));
end;

(*class operator >=(constref A, B: TVector4f): Boolean;
class operator <=(constref A, B: TVector4f): Boolean;
class operator >(constref A, B: TVector4f): Boolean;
class operator <(constref A, B: TVector4f): Boolean; *)

class operator TGLZVector2d.<>(constref A, B: TGLZVector2d): Boolean;
begin
  result := ((A.X <> B.X) or (A.Y <> B.Y));
end;

function TGLZVector2d.DotProduct(A:TGLZVector2d):Double;
begin
  Result := (X * A.X) + (Y * A.Y);
end;

function TGLZVector2d.AngleCosine(constref A: TGLZVector2d): Double;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TGLZVector2d.AngleBetween(Constref A, ACenterPoint : TGLZVector2d): Double;
Var
  vt1,vt2  :  TGLZVector2d;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vt1 := vt1.Normalize;
  vt2 := vt2.Normalize;
  Result := ArcCos(vt1.AngleCosine(vt2));
end;

class operator TGLZVector2d.+(constref A: TGLZVector2d; constref B:Double): TGLZVector2d;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TGLZVector2d.-(constref A: TGLZVector2d; constref B:Double): TGLZVector2d;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TGLZVector2d.*(constref A: TGLZVector2d; constref B:Double): TGLZVector2d;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
end;

class operator TGLZVector2d./(constref A: TGLZVector2d; constref B:Double): TGLZVector2d;
Var
  d : Double;
begin
  d :=1/B;
  Result.X := A.X * d;
  Result.Y := A.Y * d;
end;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

//class operator TGLZVector2d.mod(const a,b:TGLZVector2d): TGLZVector2d;
//var
//  c: TGLZVector2d;
//begin
//  c:=a/b;
//  result := a-b * c.Trunc;//GLZVectorMath.trunc(c);
//end;

function TGLZVector2d.InvSqrt : TGLZVector2d;
begin
 result.X := GLZMath.InvSqrt(Self.X);
 result.Y := GLZMath.InvSqrt(Self.Y);
end;

function TGLZVector2d.Fract : TGLZVector2d;
begin
 result.X := GLZMath.Fract(Self.X);
 result.Y := GLZMath.Fract(Self.Y);
end;

{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

{%region%----[ Operators ]------------------------------------------------------}
class operator TGLZVector2d.+(constref A, B: TGLZVector2d): TGLZVector2d;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TGLZVector2d.-(constref A, B: TGLZVector2d): TGLZVector2d;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

class operator TGLZVector2d.*(constref A, B: TGLZVector2d): TGLZVector2d;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

class operator TGLZVector2d.*(constref A:TGLZVector2d; Constref B: TGLZVector2i): TGLZVector2d;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

class operator TGLZVector2d./(constref A, B: TGLZVector2d): TGLZVector2d;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

class operator TGLZVector2d./(constref A: TGLZVector2d; constref B:TGLZVector2i): TGLZVector2d;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

class operator TGLZVector2d.+(constref A: TGLZVector2d; constref B: TGLZVector2i): TGLZVector2d;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TGLZVector2d.-(constref A: TGLZVector2d; constref B: TGLZVector2i): TGLZVector2d;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZVector2d.Min(constref B: TGLZVector2d): TGLZVector2d;
begin
  Result := Self;
  if Result.X > B.X then Result.X := B.X;
  //:= Math.Min(Self.X, B.X);
  //Result.Y := Math.Min(Self.Y, B.Y);
  if Result.Y > B.Y then Result.Y := B.Y;
end;

function TGLZVector2d.Min(constref B: Double): TGLZVector2d;
Begin
  Result := Self;
  Result.X := Math.Min(Self.X, B);
  Result.Y := Math.Min(Self.Y, B);
end;

function TGLZVector2d.Max(constref B: TGLZVector2d): TGLZVector2d;
begin
  Result := Self;
  //Result.X := Math.Max(Self.X, B.X);
  //Result.Y := Math.Max(Self.Y, B.Y);
  Result := Self;
  if Result.X < B.X then Result.X := B.X;
  if Result.Y < B.Y then Result.Y := B.Y;
end;

function TGLZVector2d.Max(constref B: Double): TGLZVector2d;
begin
  Result := Self;
  Result.X := Math.Max(Self.X, B);
  Result.Y := Math.Max(Self.Y, B);
end;

function TGLZVector2d.Clamp(constref AMin, AMax: TGLZVector2d): TGLZVector2d;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin.X),AMax.X);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin.Y),AMax.Y);
end;

function TGLZVector2d.Clamp(constref AMin, AMax: Double): TGLZVector2d;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin),AMax);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin),AMax);
end;

function TGLZVector2d.MulAdd(constref A,B:TGLZVector2d): TGLZVector2d;
begin
  Result := (Self*A) + B;
end;

function TGLZVector2d.MulSub(constref A,B:TGLZVector2d): TGLZVector2d;
begin
  Result := (Self*A) - B;
end;

function TGLZVector2d.MulDiv(constref A,B:TGLZVector2d): TGLZVector2d;
begin
  Result := (Self*A) / B;
end;

function TGLZVector2d.Length:Double;
begin
  Result := System.Sqrt((Self.X * Self.X) + (Self.Y * Self.Y));
end;

function TGLZVector2d.LengthSquare:Double;
begin
  Result := (Self.X * Self.X) + (Self.Y * Self.Y);
end;

function TGLZVector2d.Distance(constref A:TGLZVector2d):Double;
begin
  Result := (Self - A).Length;
end;

function TGLZVector2d.DistanceSquare(constref A:TGLZVector2d):Double;
var
  t : TGLZVector2d;
begin
   t := Self - A;
   Result := t.LengthSquare;
end;

function TGLZVector2d.Normalize : TGLZVector2d;
begin
 Result := Self * (1/Self.Length);
end;

function TGLZVector2d.Abs: TGLZVector2d;
begin
  Result.X := System.abs(Self.X);
  Result.Y := System.abs(Self.Y);
end;

function TGLZVector2d.Round : TGLZVector2i;
begin
 result.X := System.Round(Self.X);
 result.Y := System.Round(Self.Y);
end;

function TGLZVector2d.Trunc : TGLZVector2i;
begin
 result.X := System.Trunc(Self.X);
 result.Y := System.Trunc(Self.Y);
end;

function TGLZVector2d.Floor : TGLZVector2i;
begin
 result.X := GLZMath.Floor(Self.X);
 result.Y := GLZMath.Floor(Self.Y);
end;

function TGLZVector2d.Ceil : TGLZVector2i;
begin
 result.X := GLZMath.Ceil(Self.X);
 result.Y := GLZMath.Ceil(Self.Y);
end;

//function TGLZVector2d.Fract : TGLZVector2d;
//begin
// result.X := GLZMath.Fract(Self.X);
// result.Y := GLZMath.Fract(Self.Y);
//end;

function TGLZVector2d.Sqrt : TGLZVector2d;
begin
 result.X := System.Sqrt(Self.X);
 result.Y := System.Sqrt(Self.Y);
end;

//function TGLZVector2d.InvSqrt : TGLZVector2d;
//begin
// result.X := GLZMath.InvSqrt(Self.X);
// result.Y := GLZMath.InvSqrt(Self.Y);
//end;

function TGLZVector2d.ModF(Constref A : TGLZVector2d): TGLZVector2d;
var
  t : TGLZVector2i;
  vt : TGLZVector2d;
begin
  vt := (Self / a);
  t := vt.floor;
  vt.x:=t.x;
  vt.y:=t.y;
  result := (Self - (a*vt));
end;

function TGLZVector2d.fMod(Constref A : TGLZVector2d): TGLZVector2i;
var
  t : TGLZVector2i;
  vt : TGLZVector2d;
begin
  vt := (Self / A);
  t := vt.floor;
  vt.x:=t.x;
  vt.y:=t.y;
  vt := (Self - (A*vt));
  result := vt.Trunc;
end;

{%endregion%}

{%endregion%}

{$ENDIF}
