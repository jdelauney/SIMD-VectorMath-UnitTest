{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

procedure TGLZVector2i.Create(aX,aY: Integer);
begin
  Self.X := aX;
  Self.Y := aY;
end;


function TGLZVector2i.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+')';
End;

class operator TGLZVector2i.-(constref A: TGLZVector2i): TGLZVector2i;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

class operator TGLZVector2i.=(constref A, B: TGLZVector2i): Boolean;
begin
 result := ((A.X = B.X) And (A.Y = B.Y));
end;

(*class operator >=(constref A, B: TVector4f): Boolean;
class operator <=(constref A, B: TVector4f): Boolean;
class operator >(constref A, B: TVector4f): Boolean;
class operator <(constref A, B: TVector4f): Boolean; *)

class operator TGLZVector2i.<>(constref A, B: TGLZVector2i): Boolean;
begin
  result := ((A.X <> B.X) or (A.Y <> B.Y));
end;

function TGLZVector2i.DotProduct(A:TGLZVector2i):Single;
begin
  Result := (X * A.X) + (Y * A.Y);
end;

function TGLZVector2i.AngleCosine(constref A: TGLZVector2i): Single;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TGLZVector2i.AngleBetween(Constref A, ACenterPoint : TGLZVector2i): Single;
Var
  vt1,vt2  :  TGLZVector2i;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vt1 := vt1.Normalize;
  vt2 := vt2.Normalize;
  Result := ArcCos(vt1.AngleCosine(vt2));
end;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

class operator TGLZVector2i.Mod(Constref A, B : TGLZVector2i): TGLZVector2i;
begin
  Result.x := A.X Mod B.X;
  Result.Y := A.Y Mod B.Y;
end;

{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZVector2i.+(constref A, B: TGLZVector2i): TGLZVector2i;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TGLZVector2i.-(constref A, B: TGLZVector2i): TGLZVector2i;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

class operator TGLZVector2i.*(constref A, B: TGLZVector2i): TGLZVector2i;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

//class operator TGLZVector2i.*(constref A:TGLZVector2i; Constref B: TGLZVector2f): TGLZVector2i;
//begin
//  Result.X := Round(A.X * B.X);
//  Result.Y := Round(A.Y * B.Y);
//end;

class operator TGLZVector2i.div(constref A, B: TGLZVector2i): TGLZVector2i;
begin
  Result.X := A.X div B.X;
  Result.Y := A.Y div B.Y;
end;

class operator TGLZVector2i.div(constref A : TGLZVector2i;Constref B:Integer ): TGLZVector2i;
begin
  Result.X := A.X div B;
  Result.Y := A.Y div B;
end;

class operator TGLZVector2i.+(constref A: TGLZVector2i; constref B:Single): TGLZVector2i;
begin
  Result.X := Round(A.X + B);
  Result.Y := Round(A.Y + B);
end;

class operator TGLZVector2i.-(constref A: TGLZVector2i; constref B:Single): TGLZVector2i;
begin
  Result.X := Round(A.X - B);
  Result.Y := Round(A.Y - B);
end;

class operator TGLZVector2i.*(constref A: TGLZVector2i; constref B:Single): TGLZVector2i;
begin
  Result.X := Round(A.X * B);
  Result.Y := Round(A.Y * B);
end;

//For Increase performance add this to an TGLZVector2iHelper and you TGLZVector2f for compute values
class operator TGLZVector2i./(constref A: TGLZVector2i; constref B:Single): TGLZVector2i;
Var
  d : Single;
  //v2 : TGLZVector2f;
begin
  d :=1/B;
  //v2.Create(self);
  //v2 := v2 * d
  //result := v2.Trunc;
  Result.X := Round(A.X * d);
  Result.Y := Round(A.Y * d);
end;



{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZVector2i.Min(constref B: TGLZVector2i): TGLZVector2i;
begin
  Result := Self;
  if Result.X > B.X then Result.X := B.X;
  //:= Math.Min(Self.X, B.X);
  //Result.Y := Math.Min(Self.Y, B.Y);
  if Result.Y > B.Y then Result.Y := B.Y;
end;

function TGLZVector2i.Min(constref B: Integer): TGLZVector2i;
Begin
  Result := Self;
  Result.X := Math.Min(Self.X, B);
  Result.Y := Math.Min(Self.Y, B);
end;

function TGLZVector2i.Max(constref B: TGLZVector2i): TGLZVector2i;
begin
  Result := Self;
  if Result.X < B.X then Result.X := B.X;
  if Result.Y < B.Y then Result.Y := B.Y;
end;

function TGLZVector2i.Max(constref B: Integer): TGLZVector2i;
begin
  Result := Self;
  Result.X := Math.Max(Self.X, B);
  Result.Y := Math.Max(Self.Y, B);
end;

function TGLZVector2i.Clamp(constref AMin, AMax: TGLZVector2i): TGLZVector2i;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin.X),AMax.X);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin.Y),AMax.Y);
end;

function TGLZVector2i.Clamp(constref AMin, AMax: Integer): TGLZVector2i;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin),AMax);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin),AMax);
end;

function TGLZVector2i.MulAdd(constref A,B:TGLZVector2i): TGLZVector2i;
begin
  Result := (Self*A) + B;
end;

function TGLZVector2i.MulDiv(constref A,B:TGLZVector2i): TGLZVector2i;
begin
  Result := (Self*A) div B;
end;

function TGLZVector2i.Length:Single;
begin
  Result := System.Sqrt((Self.X * Self.X) + (Self.Y * Self.Y));
end;

function TGLZVector2i.LengthSquare:Single;
begin
  Result := (Self.X * Self.X) + (Self.Y * Self.Y);
end;

function TGLZVector2i.Distance(constref A:TGLZVector2i):Single;
begin
  Result := (Self - A).Length;
end;

function TGLZVector2i.DistanceSquare(constref A:TGLZVector2i):Single;
var
  t : TGLZVector2i;
begin
   t := Self - A;
   Result := t.LengthSquare;
end;

function TGLZVector2i.Normalize : TGLZVector2i;
begin
 Result := Self * (1/Self.Length);
end;

function TGLZVector2i.Abs: TGLZVector2i;
begin
  Result.X := System.abs(Self.X);
  Result.Y := System.abs(Self.Y);
end;




{%endregion%}

{%endregion%}

{$ENDIF}
