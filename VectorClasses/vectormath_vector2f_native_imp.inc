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


{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector2f.Min(constref B: TGLZVector2f): TGLZVector2f;
begin
  Result.X := Math.Min(Self.X, B.X);
  Result.Y := Math.Min(Self.Y, B.Y);
end;

function TGLZVector2f.Min(constref B: Single): TGLZVector2f;
Begin
  Result.X := Math.Min(Self.X, B);
  Result.Y := Math.Min(Self.Y, B);
end;

function TGLZVector2f.Max(constref B: TGLZVector2f): TGLZVector2f;
begin
  Result.X := Math.Max(Self.X, B.X);
  Result.Y := Math.Max(Self.Y, B.Y);
end;

function TGLZVector2f.Max(constref B: Single): TGLZVector2f;
begin
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

function TGLZVector2f.MulDiv(constref A,B:TGLZVector2f): TGLZVector2f;
begin
  Result := (Self*A) / B;
end;

function TGLZVector2f.Length:Single;
begin
  Result := Sqrt((Self.X * Self.X) + (Self.Y * Self.Y));
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
 Result := Self * (1/Self.LengthSquare);
end;

{%endregion%}
