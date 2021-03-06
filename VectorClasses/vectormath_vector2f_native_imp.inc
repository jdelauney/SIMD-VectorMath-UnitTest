{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

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

function TGLZVector2f.DotProduct(A:TGLZVector2f):Single;
begin
  Result := (X * A.X) + (Y * A.Y);
end;

function TGLZVector2f.AngleCosine(constref A: TGLZVector2f): Single;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TGLZVector2f.AngleBetween(Constref A, ACenterPoint : TGLZVector2f): Single;
Var
  vt1,vt2  :  TGLZVector2f;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vt1 := vt1.Normalize;
  vt2 := vt2.Normalize;
  Result := ArcCos(vt1.AngleCosine(vt2));
end;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

//class operator TGLZVector2f.mod(const a,b:TGLZVector2f): TGLZVector2f;
//var
//  c: TGLZVector2f;
//begin
//  c:=a/b;
//  result := a-b * c.Trunc;//GLZVectorMath.trunc(c);
//end;




{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

{%region%----[ Operators ]------------------------------------------------------}
class operator TGLZVector2f.+(constref A, B: TGLZVector2f): TGLZVector2f;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TGLZVector2f.-(constref A, B: TGLZVector2f): TGLZVector2f;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

class operator TGLZVector2f.*(constref A, B: TGLZVector2f): TGLZVector2f;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

class operator TGLZVector2f.*(constref A:TGLZVector2f; Constref B: TGLZVector2i): TGLZVector2f;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

class operator TGLZVector2f./(constref A, B: TGLZVector2f): TGLZVector2f;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

class operator TGLZVector2f.+(constref A: TGLZVector2f; constref B:Single): TGLZVector2f;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TGLZVector2f.-(constref A: TGLZVector2f; constref B:Single): TGLZVector2f;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TGLZVector2f.*(constref A: TGLZVector2f; constref B:Single): TGLZVector2f;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
end;

class operator TGLZVector2f./(constref A: TGLZVector2f; constref B:Single): TGLZVector2f;
Var
  d : Single;
begin
  d :=1/B;
  Result.X := A.X * d;
  Result.Y := A.Y * d;
end;

class operator TGLZVector2f./(constref A: TGLZVector2f; constref B:TGLZVector2i): TGLZVector2f;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

class operator TGLZVector2f.+(constref A: TGLZVector2f; constref B: TGLZVector2i): TGLZVector2f;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TGLZVector2f.-(constref A: TGLZVector2f; constref B: TGLZVector2i): TGLZVector2f;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZVector2f.Min(constref B: TGLZVector2f): TGLZVector2f;
begin
  Result := Self;
  if Result.X > B.X then Result.X := B.X;
  //:= Math.Min(Self.X, B.X);
  //Result.Y := Math.Min(Self.Y, B.Y);
  if Result.Y > B.Y then Result.Y := B.Y;
end;

function TGLZVector2f.Min(constref B: Single): TGLZVector2f;
Begin
  Result := Self;
  Result.X := Math.Min(Self.X, B);
  Result.Y := Math.Min(Self.Y, B);
end;

function TGLZVector2f.Max(constref B: TGLZVector2f): TGLZVector2f;
begin
  Result := Self;
  //Result.X := Math.Max(Self.X, B.X);
  //Result.Y := Math.Max(Self.Y, B.Y);
  Result := Self;
  if Result.X < B.X then Result.X := B.X;
  if Result.Y < B.Y then Result.Y := B.Y;
end;

function TGLZVector2f.Max(constref B: Single): TGLZVector2f;
begin
  Result := Self;
  Result.X := Math.Max(Self.X, B);
  Result.Y := Math.Max(Self.Y, B);
end;

function TGLZVector2f.Clamp(constref AMin, AMax: TGLZVector2f): TGLZVector2f;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin.X),AMax.X);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin.Y),AMax.Y);
end;

function TGLZVector2f.Clamp(constref AMin, AMax: Single): TGLZVector2f;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin),AMax);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin),AMax);
end;

function TGLZVector2f.MulAdd(constref A,B:TGLZVector2f): TGLZVector2f;
begin
  Result := (Self*A) + B;
end;

function TGLZVector2f.MulSub(constref A,B:TGLZVector2f): TGLZVector2f;
begin
  Result := (Self*A) - B;
end;

function TGLZVector2f.MulDiv(constref A,B:TGLZVector2f): TGLZVector2f;
begin
  Result := (Self*A) / B;
end;

function TGLZVector2f.Length:Single;
begin
  Result := System.Sqrt((Self.X * Self.X) + (Self.Y * Self.Y));
end;

function TGLZVector2f.LengthSquare:Single;
begin
  Result := (Self.X * Self.X) + (Self.Y * Self.Y);
end;

function TGLZVector2f.Distance(constref A:TGLZVector2f):Single;
begin
  Result := (Self - A).Length;
end;

function TGLZVector2f.DistanceSquare(constref A:TGLZVector2f):Single;
var
  t : TGLZVector2f;
begin
   t := Self - A;
   Result := t.LengthSquare;
end;

function TGLZVector2f.Normalize : TGLZVector2f;
begin
 Result := Self * (1/Self.Length);
end;

function TGLZVector2f.Abs: TGLZvector2f;
begin
  Result.X := System.abs(Self.X);
  Result.Y := System.abs(Self.Y);
end;

function TGLZVector2f.Round : TGLZVector2i;
begin
 result.X := System.Round(Self.X);
 result.Y := System.Round(Self.Y);
end;

function TGLZVector2f.Trunc : TGLZVector2i;
begin
 result.X := System.Trunc(Self.X);
 result.Y := System.Trunc(Self.Y);
end;

function TGLZVector2f.Floor : TGLZVector2i;
begin
 result.X := GLZMath.Floor(Self.X);
 result.Y := GLZMath.Floor(Self.Y);
end;

function TGLZVector2f.Ceil : TGLZVector2i;
begin
 result.X := GLZMath.Ceil(Self.X);
 result.Y := GLZMath.Ceil(Self.Y);
end;

function TGLZVector2f.Fract : TGLZVector2f;
begin
 result.X := GLZMath.Fract(Self.X);
 result.Y := GLZMath.Fract(Self.Y);
end;

function TGLZVector2f.Sqrt : TGLZVector2f;
begin
 result.X := System.Sqrt(Self.X);
 result.Y := System.Sqrt(Self.Y);
end;

function TGLZVector2f.InvSqrt : TGLZVector2f;
begin
 result.X := GLZMath.InvSqrt(Self.X);
 result.Y := GLZMath.InvSqrt(Self.Y);
end;

function TGLZVector2f.ModF(Constref A : TGLZVector2f): TGLZVector2f;
var
  t : TGLZVector2i;
  vt : TGLZVector2f;
begin
  vt := (Self / a);
  t := vt.floor;
  vt.x:=t.x;
  vt.y:=t.y;
  result := (Self - (a*vt));
end;

function TGLZVector2f.fMod(Constref A : TGLZVector2f): TGLZVector2i;
var
  t : TGLZVector2i;
  vt : TGLZVector2f;
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
