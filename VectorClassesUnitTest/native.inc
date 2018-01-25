function NativeAffineVectorMake(const x, y, z : Single) : TNativeGLZAffineVector;
begin
   Result.X:=x;
   Result.Y:=y;
   Result.Z:=z;
end;

function NativeAffineVectorMake(const v : TNativeGLZVector) : TNativeGLZAffineVector;
begin
   Result.X:=v.X;
   Result.Y:=v.Y;
   Result.Z:=v.Z;
end;


{%region%-----[ TNativeGLZVector2f ]--------------------------------------------}

{%region%----[ TNativeGLZVector2f Operators ]-----------------------------------}

procedure TNativeGLZVector2f.Create(aX,aY: single);
begin
  Self.X := aX;
  Self.Y := aY;
end;

function TNativeGLZVector2f.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+')';
End;

class operator TNativeGLZVector2f.+(constref A, B: TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
end;

class operator TNativeGLZVector2f.-(constref A, B: TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
end;

class operator TNativeGLZVector2f.*(constref A, B: TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
end;

class operator TNativeGLZVector2f./(constref A, B: TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
end;

class operator TNativeGLZVector2f.+(constref A: TNativeGLZVector2f; constref B:Single): TNativeGLZVector2f;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
end;

class operator TNativeGLZVector2f.-(constref A: TNativeGLZVector2f; constref B:Single): TNativeGLZVector2f;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
end;

class operator TNativeGLZVector2f.*(constref A: TNativeGLZVector2f; constref B:Single): TNativeGLZVector2f;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
end;

class operator TNativeGLZVector2f./(constref A: TNativeGLZVector2f; constref B:Single): TNativeGLZVector2f;
Var
  d : Single;
begin
  d :=1/B;
  Result.X := A.X * d;
  Result.Y := A.Y * d;
end;

{%endregion%}

{%region%----[ TNativeGLZVector2f Functions ]-----------------------------------}

function TNativeGLZVector2f.Min(constref B: Single): TNativeGLZVector2f;
Begin
  Result.X := Math.Min(Self.X, B);
  Result.Y := Math.Min(Self.Y, B);
end;

function TNativeGLZVector2f.Min(constref B: TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result.X := Math.Min(Self.X, B.X);
  Result.Y := Math.Min(Self.Y, B.Y);
end;

function TNativeGLZVector2f.Max(constref B: Single): TNativeGLZVector2f;
begin
  Result.X := Math.Max(Self.X, B);
  Result.Y := Math.Max(Self.Y, B);
end;

function TNativeGLZVector2f.Max(constref B: TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result.X := Math.Max(Self.X, B.X);
  Result.Y := Math.Max(Self.Y, B.Y);
end;

function TNativeGLZVector2f.Clamp(constref AMin, AMax: Single): TNativeGLZVector2f;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin),AMax);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin),AMax);
end;

function TNativeGLZVector2f.Clamp(constref AMin, AMax: TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result.X := Math.Min(Math.Max(Self.X, AMin.X),AMax.X);
  Result.Y := Math.Min(Math.Max(Self.Y, AMin.Y),AMax.Y);
end;

function TNativeGLZVector2f.MulAdd(A,B:TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result := (Self*A) + B;
end;

function TNativeGLZVector2f.MulDiv(A,B:TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result := (Self*A) / B;
end;

function TNativeGLZVector2f.Length:Single;
begin
  Result := Sqrt((Self.X * Self.X) + (Self.Y * Self.Y));
end;

function TNativeGLZVector2f.LengthSquare:Single;
begin
  Result := (Self.X * Self.X) + (Self.Y * Self.Y);
end;

function TNativeGLZVector2f.Distance(A:TNativeGLZVector2f):Single;
begin
  Result := (Self - A).Length;
end;

function TNativeGLZVector2f.DistanceSquare(A:TNativeGLZVector2f):Single;
var
  t : TNativeGLZVector2f;
begin
   t := Self - A;
   Result := t.LengthSquare;
end;

function TNativeGLZVector2f.Normalize : TNativeGLZVector2f;
begin
 Result := Self * (1/Self.Length);
end;

class operator TNativeGLZVector2f.-(constref A: TNativeGLZVector2f): TNativeGLZVector2f;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
end;

class operator TNativeGLZVector2f.=(constref A, B: TNativeGLZVector2f): Boolean;
begin
 result := ((A.X = B.X) And (A.Y = B.Y));
end;
(*class operator >=(constref A, B: TVector4f): Boolean;
class operator <=(constref A, B: TVector4f): Boolean;
class operator >(constref A, B: TVector4f): Boolean;
class operator <(constref A, B: TVector4f): Boolean; *)
class operator TNativeGLZVector2f.<>(constref A, B: TNativeGLZVector2f): Boolean;
begin
  result := ((A.X <> B.X) or (A.Y <> B.Y));
end;

(* function TGLZVector2f.Abs(const A: TVector2f): TVector2f;
begin
  Result.X := System.Abs(A.X);
  Result.Y := System.Abs(A.Y);
end;  *)

function TNativeGLZVector2f.DotProduct(A:TNativeGLZVector2f):Single;
begin
  Result := (X * A.X) + (Y * A.Y);
end;

function TNativeGLZVector2f.AngleCosine(constref A: TNativeGLZVector2f): Single;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TNativeGLZVector2f.AngleBetween(Constref A, ACenterPoint : TNativeGLZVector2f): Single;
Var
  vt1,vt2  :  TNativeGLZVector2f;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vt1 := vt1.Normalize;
  vt2 := vt2.Normalize;
  Result := ArcCos(vt1.AngleCosine(vt2));
end;

function TNativeGLZVector2f.Round : TNativeGLZVector2i;
begin
 result.X := System.Round(Self.X);
 result.Y := System.Round(Self.Y);
end;

function TNativeGLZVector2f.Trunc : TNativeGLZVector2i;
begin
 result.X := System.Trunc(Self.X);
 result.Y := System.Trunc(Self.Y);
end;

{%endregion%}
{%endregion%}

{%region%----[ TNativeGLZVector3b ]---------------------------------------------}

procedure TNativeGLZVector3b.Create(const aX, aY, aZ: Byte);
begin
  Self.X := aX;
  Self.Y := aY;
  Self.Z := aZ;
end;

function TNativeGLZVector3b.ToString: String;
begin
  Result := '(X: '+IntToStr(Self.X)+
           ' ,Y: '+IntToStr(Self.Y)+
           ' ,Z: '+IntToStr(Self.Z)+')';
end;


class operator TNativeGLZVector3b.+(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X + B.X));
  Result.Y := ClampByte((A.Y + B.Y));
  Result.Z := ClampByte((A.Z + B.Z));
end;

class operator TNativeGLZVector3b.-(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X - B.X));
  Result.Y := ClampByte((A.Y - B.Y));
  Result.Z := ClampByte((A.Z - B.Z));
end;

class operator TNativeGLZVector3b.*(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X * B.X));
  Result.Y := ClampByte((A.Y * B.Y));
  Result.Z := ClampByte((A.Z * B.Z));
end;

class operator TNativeGLZVector3b.div(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X div B.X));
  Result.Y := ClampByte((A.Y div B.Y));
  Result.Z := ClampByte((A.Z div B.Z));
end;

class operator TNativeGLZVector3b.+(constref A: TNativeGLZVector3b; constref B: Byte ): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X + B));
  Result.Y := ClampByte((A.Y + B));
  Result.Z := ClampByte((A.Z + B));
end;

class operator TNativeGLZVector3b.-(constref A: TNativeGLZVector3b; constref B: Byte ): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X - B));
  Result.Y := ClampByte((A.Y - B));
  Result.Z := ClampByte((A.Z - B));
end;

class operator TNativeGLZVector3b.*(constref A: TNativeGLZVector3b; constref B: Byte ): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X * B));
  Result.Y := ClampByte((A.Y * B));
  Result.Z := ClampByte((A.Z * B));
end;

class operator TNativeGLZVector3b.*(constref A: TNativeGLZVector3b; constref B: Single): TNativeGLZVector3b;
begin
  Result.X := ClampByte(Round((A.X * B)));
  Result.Y := ClampByte(Round((A.Y * B)));
  Result.Z := ClampByte(Round((A.Z * B)));
end;

class operator TNativeGLZVector3b.div(constref A: TNativeGLZVector3b; constref B: Byte ): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X div B));
  Result.Y := ClampByte((A.Y div B));
  Result.Z := ClampByte((A.Z div B));
end;

class operator TNativeGLZVector3b.=(constref A, B: TNativeGLZVector3b): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z);
end;

class operator TNativeGLZVector3b.<>(constref A, B: TNativeGLZVector3b): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z);
end;

class operator TNativeGLZVector3b.and(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X and B.X));
  Result.Y := ClampByte((A.Y and B.Y));
  Result.Z := ClampByte((A.Z and B.Z));
end;

class operator TNativeGLZVector3b.Or(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X or B.X));
  Result.Y := ClampByte((A.Y or B.Y));
  Result.Z := ClampByte((A.Z or B.Z));
end;

class operator TNativeGLZVector3b.Xor(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X xor B.X));
  Result.Y := ClampByte((A.Y xor B.Y));
  Result.Z := ClampByte((A.Z xor B.Z));
end;

class operator TNativeGLZVector3b.and(constref A: TNativeGLZVector3b; constref B: Byte): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X and B));
  Result.Y := ClampByte((A.Y and B));
  Result.Z := ClampByte((A.Z and B));
end;

class operator TNativeGLZVector3b.or(constref A: TNativeGLZVector3b; constref B: Byte): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X or B));
  Result.Y := ClampByte((A.Y or B));
  Result.Z := ClampByte((A.Z or B));
end;

class operator TNativeGLZVector3b.Xor(constref A: TNativeGLZVector3b; constref B: Byte): TNativeGLZVector3b;
begin
  Result.X := ClampByte((A.X xor B));
  Result.Y := ClampByte((A.Y xor B));
  Result.Z := ClampByte((A.Z xor B));
end;

function TNativeGLZVector3b.Swizzle(const ASwizzle: TGLZVector3SwizzleRef ): TNativeGLZVector3b;
begin
  case ASwizzle of
    swXXX, swRRR :
    begin
      Result.X := Self.X;
      Result.Y := Self.X;
      Result.Z := Self.X;
    end;
    swYYY, swGGG :
    begin
      Result.X := Self.Y;
      Result.Y := Self.Y;
      Result.Z := Self.Y;
    end;
    swZZZ, swBBB :
    begin
      Result.X := Self.Z;
      Result.Y := Self.Z;
      Result.Z := Self.Z;
    end;
    swXZY, swRBG :
    begin
      Result.X := Self.X;
      Result.Y := Self.Z;
      Result.Z := Self.Y;
    end;
    swZYX, swBGR :
    begin
      Result.X := Self.Z;
      Result.Y := Self.Y;
      Result.Z := Self.X;
    end;
    swZXY, swBRG :
    begin
      Result.X := Self.Z;
      Result.Y := Self.X;
      Result.Z := Self.Y;
    end;
    swYXZ, swGRB :
    begin
      Result.X := Self.Y;
      Result.Y := Self.X;
      Result.Z := Self.Z;
    end;
    swYZX, swGBR :
    begin
      Result.X := Self.Y;
      Result.Y := Self.Z;
      Result.Z := Self.X;
    end;

    else result := self;
  end;
end;

{%endregion%}

{%region%----[ TNativeGLZVector4b ]---------------------------------------------}
procedure TNativeGLZVector4b.Create(const aX, aY, aZ : Byte; const aW : Byte);
begin
  Self.X := aX;
  Self.Y := aY;
  Self.Z := aZ;
  Self.w := aW;
end;

procedure TNativeGLZVector4b.Create(const aValue : TNativeGLZVector3b; const aW : Byte);
begin
  Self.X := aValue.X;
  Self.Y := aValue.Y;
  Self.Z := aValue.Z;
  Self.W := aW;
end;

function TNativeGLZVector4b.ToString: String;
begin
  Result := '(X: '+IntToStr(Self.X)+
           ' ,Y: '+IntToStr(Self.Y)+
           ' ,Z: '+IntToStr(Self.Z)+
           ' ,W: '+IntToStr(Self.W)+')';
end;

class operator TNativeGLZVector4b.+(constref A, B : TNativeGLZVector4b): TNativeGLZVector4b;
begin
  Result.X := ClampByte((A.X + B.X));
  Result.Y := ClampByte((A.Y + B.Y));
  Result.Z := ClampByte((A.Z + B.Z));
  Result.W := ClampByte((A.W + B.W));
end;

class operator TNativeGLZVector4b.-(constref A, B : TNativeGLZVector4b): TNativeGLZVector4b;
begin
  Result.X := ClampByte((A.X - B.X));
  Result.Y := ClampByte((A.Y - B.Y));
  Result.Z := ClampByte((A.Z - B.Z));
  Result.W := ClampByte((A.W - B.W));
end;

class operator TNativeGLZVector4b.*(constref A, B : TNativeGLZVector4b): TNativeGLZVector4b;
begin
  Result.X := ClampByte((A.X * B.X));
  Result.Y := ClampByte((A.Y * B.Y));
  Result.Z := ClampByte((A.Z * B.Z));
  Result.W := ClampByte((A.W * B.W));
end;

class operator TNativeGLZVector4b.div(constref A, B : TNativeGLZVector4b): TNativeGLZVector4b;
begin
  Result.X := ClampByte((A.X div B.X));
  Result.Y := ClampByte((A.Y div B.Y));
  Result.Z := ClampByte((A.Z div B.Z));
  Result.W := ClampByte((A.W div B.W));
end;

class operator TNativeGLZVector4b.+(constref A: TNativeGLZVector4b; constref B: Byte ): TNativeGLZVector4b;
begin
  Result.X := ClampByte((A.X + B));
  Result.Y := ClampByte((A.Y + B));
  Result.Z := ClampByte((A.Z + B));
  Result.W := ClampByte((A.W + B));
end;

class operator TNativeGLZVector4b.-(constref A: TNativeGLZVector4b; constref B: Byte ): TNativeGLZVector4b;
begin
  Result.X := ClampByte((A.X - B));
  Result.Y := ClampByte((A.Y - B));
  Result.Z := ClampByte((A.Z - B));
  Result.W := ClampByte((A.W - B));
end;

class operator TNativeGLZVector4b.*(constref A: TNativeGLZVector4b; constref B: Byte ): TNativeGLZVector4b;
begin
  Result.X := ClampByte((A.X * B));
  Result.Y := ClampByte((A.Y * B));
  Result.Z := ClampByte((A.Z * B));
  Result.W := ClampByte((A.W * B));
end;

class operator TNativeGLZVector4b.*(constref A: TNativeGLZVector4b; constref B: Single): TNativeGLZVector4b;
begin
  Result.X := ClampByte(Round((A.X * B)));
  Result.Y := ClampByte(Round((A.Y * B)));
  Result.Z := ClampByte(Round((A.Z * B)));
  Result.W := ClampByte(Round((A.W * B)));
end;

class operator TNativeGLZVector4b.div(constref A: TNativeGLZVector4b; constref B: Byte ): TNativeGLZVector4b;
begin
  Result := A;
  if B<>0 then Result.X := ClampByte(A.X div B);
  if B<>0 then Result.Y := ClampByte(A.Y div B);
  if B<>0 then Result.Z := ClampByte(A.Z div B);
  if B<>0 then Result.W := ClampByte(A.W div B);
end;

class operator TNativeGLZVector4b.=(constref A, B: TNativeGLZVector4b): Boolean;
begin
  Result := (A.W = B.W) and (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z);
end;

class operator TNativeGLZVector4b.<>(constref A, B: TNativeGLZVector4b): Boolean;
begin
  Result := (A.W <> B.W) or (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z);
end;

class operator TNativeGLZVector4b.and(constref A, B : TNativeGLZVector4b) : TNativeGLZVector4b;
begin
  Result.X := A.X and B.X;
  Result.Y := A.Y and B.Y;
  Result.Z := A.Z and B.Z;
  Result.W := A.W and B.W;
end;

class operator TNativeGLZVector4b.Or(constref A, B : TNativeGLZVector4b) : TNativeGLZVector4b;
begin
  Result.X := A.X or B.X;
  Result.Y := A.Y or B.Y;
  Result.Z := A.Z or B.Z;
  Result.W := A.W or B.W;
end;

class operator TNativeGLZVector4b.Xor(constref A, B : TNativeGLZVector4b) : TNativeGLZVector4b;
begin
  Result.X := A.X xor B.X;
  Result.Y := A.Y xor B.Y;
  Result.Z := A.Z xor B.Z;
  Result.W := A.W xor B.W;
end;

class operator TNativeGLZVector4b.and(constref A : TNativeGLZVector4b; constref B : Byte) : TNativeGLZVector4b;
begin
  Result.X := A.X and B;
  Result.Y := A.Y and B;
  Result.Z := A.Z and B;
  Result.W := A.W and B;
end;

class operator TNativeGLZVector4b.or(constref A : TNativeGLZVector4b; constref B : Byte) : TNativeGLZVector4b;
begin
  Result.X := A.X or B;
  Result.Y := A.Y or B;
  Result.Z := A.Z or B;
  Result.W := A.W or B;
end;

class operator TNativeGLZVector4b.Xor(constref A : TNativeGLZVector4b; constref B : Byte) : TNativeGLZVector4b;
begin
  Result.X := A.X xor B;
  Result.Y := A.Y xor B;
  Result.Z := A.Z xor B;
  Result.W := A.W xor B;
end;

function TNativeGLZVector4b.DivideBy2 : TNativeGLZVector4b;
begin
  Result.x := Round(Self.X*0.5);
  Result.y := Round(Self.Y*0.5);
  Result.z := Round(Self.Z*0.5);
  Result.w := Round(Self.W*0.5);
end;

function TNativeGLZVector4b.Min(Constref B : TNativeGLZVector4b) : TNativeGLZVector4b;
begin
  Result := Self;
  if Self.X>B.X then Result.X := B.X;
  if Self.Y>B.Y then Result.Y := B.Y;
  if Self.Z>B.Z then Result.Z := B.Z;
  if Self.W>B.W then Result.W := B.W;
end;

function TNativeGLZVector4b.Min(Constref B : Byte) : TNativeGLZVector4b;
begin
  Result := Self;
  if Self.X>B then Result.X := B;
  if Self.Y>B then Result.Y := B;
  if Self.Z>B then Result.Z := B;
  if Self.W>B then Result.W := B;
End;

function TNativeGLZVector4b.Max(Constref B : TNativeGLZVector4b) : TNativeGLZVector4b;
begin
  Result := Self;
  if Self.X<B.X then Result.X := B.X;
  if Self.Y<B.Y then Result.Y := B.Y;
  if Self.Z<B.Z then Result.Z := B.Z;
  if Self.W<B.W then Result.W := B.W;
end;

function TNativeGLZVector4b.Max(Constref B : Byte) : TNativeGLZVector4b;
begin
  Result := Self;
  if Self.X<B then Result.X := B;
  if Self.Y<B then Result.Y := B;
  if Self.Z<B then Result.Z := B;
  if Self.W<B then Result.W := B;
end;

function TNativeGLZVector4b.Clamp(Constref AMin, AMax : TNativeGLZVector4b) : TNativeGLZVector4b;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
end;

function TNativeGLZVector4b.Clamp(Constref AMin, AMax : Byte) : TNativeGLZVector4b;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
end;

function TNativeGLZVector4b.MulAdd(Constref B, C : TNativeGLZVector4b) : TNativeGLZVector4b;
begin
  result := (self*B)+C;
end;

function TNativeGLZVector4b.MulDiv(Constref B, C : TNativeGLZVector4b) : TNativeGLZVector4b;
var tmp: integer;
begin
  tmp := self.x * B.X;
  result.x := ClampByte(tmp div C.X);
  tmp := self.y * B.Y;
  result.y := ClampByte(tmp div C.Y);
  tmp := self.z * B.Z;
  result.z := ClampByte(tmp div C.Z);
  tmp := self.w * B.W;
  result.w := ClampByte(tmp div C.W);
end;

function TNativeGLZVector4b.Shuffle(const x,y,z,w : Byte):TNativeGLZVector4b;
begin
  Result.X := Self.V[x];
  Result.Y := Self.V[y];
  Result.Z := Self.V[z];
  Result.W := Self.V[w];
End;

function TNativeGLZVector4b.Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TNativeGLZVector4b;
begin
   //FSwizzleMode :=  ASwizzle;
   case ASwizzle of
     swXXXX, swRRRR :
     begin
       Result.X := Self.X;
       Result.Y := Self.X;
       Result.Z := Self.X;
       Result.W := Self.X;
     end;
     swYYYY, swGGGG :
     begin
       Result.X := Self.Y;
       Result.Y := Self.Y;
       Result.Z := Self.Y;
       Result.W := Self.Y;
     end;
     swZZZZ, swBBBB :
     begin
       Result.X := Self.Z;
       Result.Y := Self.Z;
       Result.Z := Self.Z;
       Result.W := Self.Z;
     end;
     swWWWW, swAAAA :
     begin
       Result.X := Self.W;
       Result.Y := Self.W;
       Result.Z := Self.W;
       Result.W := Self.W;
     end;
     swZYXW, swBGRA :
     begin
       Result.X := Self.Z;
       Result.Y := Self.Y;
       Result.Z := Self.X;
       Result.W := Self.W;
     end;
     swXZYW, swRBGA :
     begin
       Result.X := Self.X;
       Result.Y := Self.Z;
       Result.Z := Self.Y;
       Result.W := Self.W;
     end;
     swZXYW, swBRGA :
     begin
       Result.X := Self.Z;
       Result.Y := Self.X;
       Result.Z := Self.Y;
       Result.W := Self.W;
     end;
     swYXZW, swGRBA :
     begin
       Result.X := Self.Y;
       Result.Y := Self.X;
       Result.Z := Self.Z;
       Result.W := Self.W;
     end;
     swYZXW, swGBRA :
     begin
       Result.X := Self.Y;
       Result.Y := Self.Z;
       Result.Z := Self.X;
       Result.W := Self.W;
     end;
     swWXYZ, swARGB :
     begin
       Result.X := Self.W;
       Result.Y := Self.X;
       Result.Z := Self.Y;
       Result.W := Self.Z;
     end;
     swWZYX, swABGR :
     begin
       Result.X := Self.W;
       Result.Y := Self.Z;
       Result.Z := Self.Y;
       Result.W := Self.X;
     end;
     swWXZY, swARBG :
     begin
       Result.X := Self.W;
       Result.Y := Self.X;
       Result.Z := Self.Z;
       Result.W := Self.Y;
     end;
     swWZXY, swABRG :
     begin
       Result.X := Self.W;
       Result.Y := Self.Z;
       Result.Z := Self.X;
       Result.W := Self.Y;
     end;
     swWYXZ, swAGRB :
     begin
       Result.X := Self.W;
       Result.Y := Self.Y;
       Result.Z := Self.X;
       Result.W := Self.Z;
     end;
     swWYZX, swAGBR :
     begin
       Result.X := Self.W;
       Result.Y := Self.Y;
       Result.Z := Self.Z;
       Result.W := Self.X;
     end;

     else result := self; //swXYZW, swRGBA
   end;
end;

function TNativeGLZVector4b.Combine(constref V2: TNativeGLZVector4b; constref F1: Single): TNativeGLZVector4b;
Var
  v3 : TNativeGLZVector4b;
begin
  v3 := v2 * F1;
  result := Self + v3;
  result.W := Self.W;
End;

function TNativeGLZVector4b.Combine2(constref V2: TNativeGLZVector4b; const F1, F2: Single): TNativeGLZVector4b;
begin
  result.X := ClampByte(Round(Self.X * F1 + V2.X * F2));
  result.Y := ClampByte(Round(Self.Y * F1 + V2.Y * F2));
  result.Z := ClampByte(Round(Self.Z * F1 + V2.Z * F2));
  result.W := Self.W;
end;

function TNativeGLZVector4b.Combine3(constref V2, V3: TNativeGLZVector4b; const F1, F2, F3: Single): TNativeGLZVector4b;
begin
  result.X := ClampByte(Round(Self.X * F1 + V2.X * F2 + V3.X * F3));
  result.Y := ClampByte(Round(Self.Y * F1 + V2.Y * F2 + V3.Y * F3));
  result.Z := ClampByte(Round(Self.Z * F1 + V2.Z * F2 + V3.Z * F3));
  result.W := Self.W;
end;

function TNativeGLZVector4b.MinXYZComponent : Byte;
begin
  Result:=GLZMath.Min(Self.X, Self.Y, Self.Z);
end;

function TNativeGLZVector4b.MaxXYZComponent : Byte;
begin
  Result:=GLZMath.Max(Self.X, Self.Y, Self.Z);
end;
{%endregion%}

{%region%-----[ TNativeGLZVector4i ]--------------------------------------------}

procedure TNativeGLZVector4i.Create(const aX, aY, aZ : Longint; const aW : Longint);
begin
  Self.X := aX;
  Self.Y := aY;
  Self.Z := aZ;
  Self.W := aW;
end;

procedure TNativeGLZVector4i.Create(const aValue : TNativeGLZVector3i; const aW : Longint);
begin
  Self.X := aValue.X;
  Self.Y := aValue.Y;
  Self.Z := aValue.Z;
  Self.W := aW;
end;

procedure TNativeGLZVector4i.Create(const aValue : TNativeGLZVector3b; const aW : Longint);
begin
  Self.X := aValue.X;
  Self.Y := aValue.Y;
  Self.Z := aValue.Z;
  Self.W := aW;
end;

function TNativeGLZVector4i.ToString : String;
begin
  Result := '(X: '+IntToStr(Self.X)+
           ' ,Y: '+IntToStr(Self.Y)+
           ' ,Z: '+IntToStr(Self.Z)+
           ' ,W: '+IntToStr(Self.W)+')';
end;


function TNativeGLZVector4i.Shuffle(const x, y, z, w : Byte) : TNativeGLZVector4i;
begin
  Result.X:=Self.V[x];
  Result.Y:=Self.V[y];
  Result.Z:=Self.V[z];
  Result.W:=Self.V[w];
end;

function TNativeGLZVector4i.Swizzle(const ASwizzle : TGLZVector4SwizzleRef) : TNativeGLZVector4i;
begin
  //FSwizzleMode :=  ASwizzle;
  case ASwizzle of
    //swXYXY movlhps
    //swZWZW movhlps
    //swXXYY unpacklo
    //swZZWW unpackhi
    //swXXZZ movldup
    //swYYWW movhdup
    swXXXX, swRRRR :  // Shufps ,00000000b
    begin
      Result.X := Self.X;
      Result.Y := Self.X;
      Result.Z := Self.X;
      Result.W := Self.X;
    end;
    swYYYY, swGGGG :  // Shufps ,01010101b
    begin
      Result.X := Self.Y;
      Result.Y := Self.Y;
      Result.Z := Self.Y;
      Result.W := Self.Y;
    end;
    swZZZZ, swBBBB : // Shufps ,10101010b
    begin
      Result.X := Self.Z;
      Result.Y := Self.Z;
      Result.Z := Self.Z;
      Result.W := Self.Z;
    end;
    swWWWW, swAAAA :  // Shufps ,11111111b
    begin
      Result.X := Self.W;
      Result.Y := Self.W;
      Result.Z := Self.W;
      Result.W := Self.W;
    end;
    swZYXW, swBGRA : // Shufps ,11000110b ==>  ARGB
    begin
      Result.X := Self.Z;
      Result.Y := Self.Y;
      Result.Z := Self.X;
      Result.W := Self.W;
    end;
    swXZYW, swRBGA :  // Shufps ,11011000b
    begin
      Result.X := Self.X;
      Result.Y := Self.Z;
      Result.Z := Self.Y;
      Result.W := Self.W;
    end;
    swZXYW, swBRGA :
    begin
      Result.X := Self.Z;
      Result.Y := Self.X;
      Result.Z := Self.Y;
      Result.W := Self.W;
    end;
    swYXZW, swGRBA :
    begin
      Result.X := Self.Y;
      Result.Y := Self.X;
      Result.Z := Self.Z;
      Result.W := Self.W;
    end;
    swYZXW, swGBRA :
    begin
      Result.X := Self.Y;
      Result.Y := Self.Z;
      Result.Z := Self.X;
      Result.W := Self.W;
    end;
    swWXYZ, swARGB :
    begin
      Result.X := Self.W;
      Result.Y := Self.X;
      Result.Z := Self.Y;
      Result.W := Self.Z;
    end;
    swWZYX, swABGR :
    begin
      Result.X := Self.W;
      Result.Y := Self.Z;
      Result.Z := Self.Y;
      Result.W := Self.X;
    end;
    swWXZY, swARBG :
    begin
      Result.X := Self.W;
      Result.Y := Self.X;
      Result.Z := Self.Z;
      Result.W := Self.Y;
    end;
    swWZXY, swABRG :
    begin
      Result.X := Self.W;
      Result.Y := Self.Z;
      Result.Z := Self.X;
      Result.W := Self.Y;
    end;
    swWYXZ, swAGRB :
    begin
      Result.X := Self.W;
      Result.Y := Self.Y;
      Result.Z := Self.X;
      Result.W := Self.Z;
    end;
    swWYZX, swAGBR :
    begin
      Result.X := Self.W;
      Result.Y := Self.Y;
      Result.Z := Self.Z;
      Result.W := Self.X;
    end;

    else result := self; //swXYZW, swRGBA
  end;
end;

function TNativeGLZVector4i.Combine(constref V2 : TNativeGLZVector4i; constref F1 : Single) : TNativeGLZVector4i;
Var
  v3 : TNativeGLZVector4i;
begin
  v3 := v2 * F1;
  result := Self + v3;
  result.W := Self.W;
end;

function TNativeGLZVector4i.Combine2(constref V2 : TNativeGLZVector4i; const F1, F2 : Single) : TNativeGLZVector4i;
begin
  result.X := Round(Self.X * F1 + V2.X * F2);
  result.Y := Round(Self.Y * F1 + V2.Y * F2);
  result.Z := Round(Self.Z * F1 + V2.Z * F2);
  result.W := Self.W;
end;

function TNativeGLZVector4i.Combine3(constref V2, V3 : TNativeGLZVector4i; const F1, F2, F3 : Single) : TNativeGLZVector4i;
begin
  result.X := Round(Self.X * F1 + V2.X * F2 + V3.X * F3);
  result.Y := Round(Self.Y * F1 + V2.Y * F2 + V3.Y * F3);
  result.Z := Round(Self.Z * F1 + V2.Z * F2 + V3.Z * F3);
  result.W := Self.W;
end;

function TNativeGLZVector4i.MinXYZComponent : LongInt;
begin
  Result:=GLZMath.Min(Self.X, Self.Y, Self.Z);
end;

function TNativeGLZVector4i.MaxXYZComponent : LongInt;
begin
  Result:=GLZMath.Max(Self.X, Self.Y, Self.Z);
end;

{%region%----[ Operators ]------------------------------------------------------}

class operator TNativeGLZVector4i.+ (constref A, B : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

class operator TNativeGLZVector4i.- (constref A, B : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

class operator TNativeGLZVector4i.*(constref A, B : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
  Result.W := A.W * B.W;
end;

class operator TNativeGLZVector4i.div(constref A, B : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result.X := A.X div B.X;
  Result.Y := A.Y div B.Y;
  Result.Z := A.Z div B.Z;
  Result.W := A.W div B.W;
end;

class operator TNativeGLZVector4i. + (constref A : TNativeGLZVector4i; constref B : Longint) : TNativeGLZVector4i;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TNativeGLZVector4i. - (constref A : TNativeGLZVector4i; constref B : Longint) : TNativeGLZVector4i;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TNativeGLZVector4i. * (constref A : TNativeGLZVector4i; constref B : Longint) : TNativeGLZVector4i;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TNativeGLZVector4i. * (constref A : TNativeGLZVector4i; constref B : Single) : TNativeGLZVector4i;
begin
  Result.X := Round(A.X * B);
  Result.Y := Round(A.Y * B);
  Result.Z := Round(A.Z * B);
  Result.W := Round(A.W * B);
end;

class operator TNativeGLZVector4i.div(constref A : TNativeGLZVector4i; constref B : Longint) : TNativeGLZVector4i;
begin
  Result.X := A.X div B;
  Result.Y := A.Y div B;
  Result.Z := A.Z div B;
  Result.W := A.W div B;
end;

class operator TNativeGLZVector4i. = (constref A, B : TNativeGLZVector4i) : Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

class operator TNativeGLZVector4i. <> (constref A, B : TNativeGLZVector4i) : Boolean;
begin
    Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z) or (A.W <> B.W);
end;

class operator TNativeGLZVector4i.-(constref A : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

(* class operator TNativeGLZVector4i.and(constref A, B : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result.X := ClampByte((A.X and B.X));
  Result.Y := ClampByte((A.Y and B.Y));
  Result.Z := ClampByte((A.Z and B.Z));
  Result.W := ClampByte((A.W and B.W));
end;

class operator TNativeGLZVector4i.Or(constref A, B : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result.X := ClampByte((A.X or B.X));
  Result.Y := ClampByte((A.Y or B.Y));
  Result.Z := ClampByte((A.Z or B.Z));
  Result.W := ClampByte((A.W or B.W));
end;

class operator TNativeGLZVector4i.Xor(constref A, B : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result.X := ClampByte((A.X xor B.X));
  Result.Y := ClampByte((A.Y xor B.Y));
  Result.Z := ClampByte((A.Z xor B.Z));
  Result.W := ClampByte((A.W xor B.W));
end;

class operator TNativeGLZVector4i.and(constref A : TNativeGLZVector4i; constref B : LongInt) : TNativeGLZVector4i;
begin
  Result.X := ClampByte((A.X and B));
  Result.Y := ClampByte((A.Y and B));
  Result.Z := ClampByte((A.Z and B));
  Result.W := ClampByte((A.W and B));
end;

class operator TNativeGLZVector4i.or(constref A : TNativeGLZVector4i; constref B : LongInt) : TNativeGLZVector4i;
begin
  Result.X := ClampByte((A.X or B));
  Result.Y := ClampByte((A.Y or B));
  Result.Z := ClampByte((A.Z or B));
  Result.W := ClampByte((A.W or B));
end;

class operator TNativeGLZVector4i.Xor(constref A : TNativeGLZVector4i; constref B : LongInt) : TNativeGLZVector4i;
begin
  Result.X := ClampByte((A.X xor B));
  Result.Y := ClampByte((A.Y xor B));
  Result.Z := ClampByte((A.Z xor B));
  Result.W := ClampByte((A.W xor B));
end;       *)

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TNativeGLZVector4i.DivideBy2 : TNativeGLZVector4i;
begin
  Result.X := (Self.X shr 1);
  Result.Y := (Self.Y shr 1);
  Result.Z := (Self.Z shr 1);
  Result.W := (Self.W shr 1);
end;

function TNativeGLZVector4i.abs : TNativeGLZVector4i;
begin
  Result.X := system.Abs(Self.X);
  Result.Y := system.Abs(Self.Y);
  Result.Z := system.Abs(Self.Z);
  Result.W := system.Abs(Self.W);
end;

function TNativeGLZVector4i.Min(Constref B : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result := Self;
  if Self.X>B.X then Result.X := B.X;
  if Self.Y>B.Y then Result.Y := B.Y;
  if Self.Z>B.Z then Result.Z := B.Z;
  if Self.W>B.W then Result.W := B.W;
end;

function TNativeGLZVector4i.Min(Constref B : LongInt) : TNativeGLZVector4i;
begin
  Result := Self;
  if Self.X>B then Result.X := B;
  if Self.Y>B then Result.Y := B;
  if Self.Z>B then Result.Z := B;
  if Self.W>B then Result.W := B;
end;

function TNativeGLZVector4i.Max(Constref B : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result := Self;
  if Self.X<B.X then Result.X := B.X;
  if Self.Y<B.Y then Result.Y := B.Y;
  if Self.Z<B.Z then Result.Z := B.Z;
  if Self.W<B.W then Result.W := B.W;
end;

function TNativeGLZVector4i.Max(Constref B : LongInt) : TNativeGLZVector4i;
begin
  Result := Self;
  if Self.X<B then Result.X := B;
  if Self.Y<B then Result.Y := B;
  if Self.Z<B then Result.Z := B;
  if Self.W<B then Result.W := B;
end;

function TNativeGLZVector4i.Clamp(Constref AMin, AMax : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
end;

function TNativeGLZVector4i.Clamp(Constref AMin, AMax : LongInt) : TNativeGLZVector4i;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
end;

function TNativeGLZVector4i.MulAdd(Constref B, C : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  result := (self*B)+C;
end;

function TNativeGLZVector4i.MulDiv(Constref B, C : TNativeGLZVector4i) : TNativeGLZVector4i;
begin
  result := (self*B) div C;
end;

{%endregion%}

{%endregion%}

{%region%-----[ TNativeGLZVector4f ]--------------------------------------------}

{%region%----[ TNativeGLZVector4f Operators ]-----------------------------------}
procedure TNativeGLZVector4f.Create(const aX, aY, aZ: single; const aW: Single);
begin
   Self.X := AX;
   Self.Y := AY;
   Self.Z := AZ;
   Self.W := AW;
end;

procedure TNativeGLZVector4f.Create(const anAffineVector: TNativeGLZVector3f; const aW: Single);
begin
   Self.X := anAffineVector.X;
   Self.Y := anAffineVector.Y;
   Self.Z := anAffineVector.Z;
   Self.W := AW;
end;

function TNativeGLZVector4f.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+
            ' ,Z: '+FloattoStrF(Self.Z,fffixed,5,5)+
            ' ,W: '+FloattoStrF(Self.W,fffixed,5,5)+')';
End;


function TNativeGLZVector4f.Shuffle(const x,y,z,w : Byte):TNativeGLZVector4f;
begin
  Result.X:=Self.V[x];
  Result.Y:=Self.V[y];
  Result.Z:=Self.V[z];
  Result.W:=Self.V[w];
End;

function TNativeGLZVector4f.MinXYZComponent : Single;
begin
   Result:=GLZMath.Min(Self.X, Self.Y, Self.Z);
end;

function TNativeGLZVector4f.MaxXYZComponent : Single;
begin
   Result:=GLZMath.Max(Self.X, Self.Y, Self.Z);
end;

class operator TNativeGLZVector4f.+(constref A, B: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

class operator TNativeGLZVector4f.-(constref A, B: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

class operator TNativeGLZVector4f.*(constref A, B: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
  Result.W := A.W * B.W;
end;

class operator TNativeGLZVector4f./(constref A, B: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
  Result.Z := A.Z / B.Z;
  Result.W := A.W / B.W;
end;

class operator TNativeGLZVector4f.+(constref A: TNativeGLZVector4f; constref B:Single): TNativeGLZVector4f;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TNativeGLZVector4f.-(constref A: TNativeGLZVector4f; constref B:Single): TNativeGLZVector4f;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TNativeGLZVector4f.*(constref A: TNativeGLZVector4f; constref B:Single): TNativeGLZVector4f;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TNativeGLZVector4f./(constref A: TNativeGLZVector4f; constref B:Single): TNativeGLZVector4f;
begin
  Result.X := A.X / B;
  Result.Y := A.Y / B;
  Result.Z := A.Z / B;
  Result.W := A.W / B;
end;

class operator TNativeGLZVector4f.-(constref A : TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

class operator TNativeGLZVector4f.=(constref A, B: TNativeGLZVector4f): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

class operator TNativeGLZVector4f.>=(constref A, B: TNativeGLZVector4f): Boolean;
begin
  Result := (A.X >= B.X) and (A.Y >= B.Y) and (A.Z >= B.Z) and (A.W >= B.W);
end;

class operator TNativeGLZVector4f.<=(constref A, B: TNativeGLZVector4f): Boolean;
begin
  Result := (A.X <= B.X) and (A.Y <= B.Y) and (A.Z <= B.Z) and (A.W <= B.W);
end;

class operator TNativeGLZVector4f.>(constref A, B: TNativeGLZVector4f): Boolean;
begin
  Result := (A.X > B.X) and (A.Y > B.Y) and (A.Z > B.Z) and (A.W > B.W);
end;

class operator TNativeGLZVector4f.<(constref A, B: TNativeGLZVector4f): Boolean;
begin
  Result := (A.X < B.X) and (A.Y < B.Y) and (A.Z < B.Z) and (A.W < B.W);
end;

class operator TNativeGLZVector4f.<>(constref A, B: TNativeGLZVector4f): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z) or (A.W <> B.W);
end;
{%endregion%}

{%region%----[ TNativeGLZVector4f Functions ]-----------------------------------}

function TNativeGLZVector4f.Abs:TNativeGLZVector4f;
begin
  result.X:=System.Abs(Self.X);
  result.Y:=System.Abs(Self.Y);
  result.Z:=System.Abs(Self.Z);
  result.W:=System.Abs(Self.W);
End;

function TNativeGLZVector4f.Negate:TNativeGLZVector4f;
begin
  Result:=Self;
  Result.X := -Result.X;
  Result.Y := -Result.Y;
  Result.Z := -Result.Z;
  Result.W := -Result.W;
end;

function TNativeGLZVector4f.DivideBy2 : TNativeGLZVector4f;
begin
  Result.x := Self.X*0.5;
  Result.y := Self.Y*0.5;
  Result.z := Self.Z*0.5;
  Result.w := Self.W*0.5;
end;

function TNativeGLZVector4f.Distance(constref A: TNativeGLZVector4f):Single;
begin
  result := sqrt(sqr(Self.X-A.X)+ sqr(Self.Y-A.Y) + sqr(Self.Z-A.Z));
end;

function TNativeGLZVector4f.DistanceSquare(constref A: TNativeGLZVector4f):Single;
begin
  result := sqr(Self.X-A.X)+ sqr(Self.Y-A.Y) + sqr(Self.Z-A.Z);
end;

function TNativeGLZVector4f.Length : Single;
//var
//X1 : Single;
begin
  Result := Sqrt((Self.X * Self.X) +(Self.Y * Self.Y) +(Self.Z * Self.Z));
  { Ensure result is non-zero to avoid divide-by-zero errors }
  //if X1 = 0 then X1 := 0.0000000001;
  //Result := X1;
end;

function TNativeGLZVector4f.LengthSquare : Single;
begin
  Result := (Self.X * Self.X) +(Self.Y * Self.Y) +(Self.Z * Self.Z);
end;

function TNativeGLZVector4f.Spacing(constref A : TNativeGLZVector4f) : Single;
//var vr : TNativeGLZVector4f;
begin
//  vr := A -Self;
//  vr.pAbs;
//  result :=vr.x+vr.y+vr.z+vr.W;
  Result:=System.Abs(A.X-Self.X)+System.Abs(A.Y-Self.Y)+System.Abs(A.Z-Self.Z)+System.Abs(A.W-Self.W);
end;

function TNativeGLZVector4f.DotProduct(constref A: TNativeGLZVector4f) : Single;
var
 V2:TNativeGLZVector4f;
begin
  V2.X := Self.X*A.X;
  V2.Y := Self.Y*A.Y;
  V2.Z := Self.Z*A.Z;
  //V2.W := Self.W*A.W;
  Result := V2.X + V2.Y + V2.Z;// + V2.W;
end;

function TNativeGLZVector4f.CrossProduct(constref A: TNativeGLZVector4f
  ): TNativeGLZVector4f;
begin
  result.X:=Self.Y*A.Z-Self.Z*A.Y;
  result.Y:=Self.Z*A.X-Self.X*A.Z;
  result.Z:=Self.X*A.Y-Self.Y*A.X;
  result.W:=1;
end;

function TNativeGLZVector4f.Norm : Single;
var v2:TNativeGLZVector4f;
begin
  v2.x := Self.X*Self.X;
  v2.y := Self.Y*Self.Y;
  v2.z := Self.Z*Self.Z;
  v2.w := Self.W*Self.W;
  Result := v2.X + v2.Y + v2.Z; //+ v2.w;
end;

function TNativeGLZVector4f.Normalize : TNativeGLZVector4f;
var
  invLen : Single;
  vn : single;
begin
  vn:=Self.Norm;
  if vn=0 then
  begin
    result := Self;
//    result.W := 0; //cZero;
  end
  else
  begin
    invLen:=1/Sqrt(vn);
    result.X:=Self.X*invLen;
    result.Y:=Self.Y*invLen;
    result.Z:=Self.Z*invLen;
    result.W:=Self.W;
  end;
end;

function TNativeGLZVector4f.Min(constref B: Single): TNativeGLZVector4f;
begin
  Result := Self;
  if Self.X>B then Result.X := B;
  if Self.Y>B then Result.Y := B;
  if Self.Z>B then Result.Z := B;
  if Self.W>B then Result.W := B;
End;

function TNativeGLZVector4f.Min(constref B: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result := Self;
  if Self.X>B.X then Result.X := B.X;
  if Self.Y>B.Y then Result.Y := B.Y;
  if Self.Z>B.Z then Result.Z := B.Z;
  if Self.W>B.W then Result.W := B.W;
End;

function TNativeGLZVector4f.Max(constref B: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result := Self;
  if Self.X<B.X then Result.X := B.X;
  if Self.Y<B.Y then Result.Y := B.Y;
  if Self.Z<B.Z then Result.Z := B.Z;
  if Self.W<B.W then Result.W := B.W;
End;

function TNativeGLZVector4f.Max(constref B: Single): TNativeGLZVector4f;
begin
  Result := Self;
  if Self.X<B then Result.X := B;
  if Self.Y<B then Result.Y := B;
  if Self.Z<B then Result.Z := B;
  if Self.W<B then Result.W := B;
End;

function TNativeGLZVector4f.Clamp(Constref AMin, AMax: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
End;

function TNativeGLZVector4f.Clamp(constref AMin, AMax: Single): TNativeGLZVector4f;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
End;

function TNativeGLZVector4f.MulAdd(Constref B, C: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  result := (self*B)+C;
end;

function TNativeGLZVector4f.MulDiv(Constref B, C: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  result := (self*B)/C;
end;

function TNativeGLZVector4f.Lerp(Constref B: TNativeGLZVector4f; Constref T:Single): TNativeGLZVector4f;
begin
   Result.X:=Self.X+(B.X-Self.X)*t;
   Result.Y:=Self.Y+(B.Y-Self.Y)*t;
   Result.Z:=Self.Z+(B.Z-Self.Z)*t;
   Result.W := Self.W;
end;

function TNativeGLZVector4f.AngleCosine(constref A: TNativeGLZVector4f): Single;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TNativeGLZVector4f.AngleBetween(Constref A, ACenterPoint : TNativeGLZVector4f): Single;
Var
  vt1,vt2  :  TNativeGLZVector4f;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vt1.pNormalize;
  vt2.pNormalize;
  Result := ArcCos(vt1.AngleCosine(vt2));
end;

function TNativeGLZVector4f.Combine(constref V2: TNativeGLZVector4f; constref F1: Single): TNativeGLZVector4f;
begin
  Result.X:=Self.X+v2.X*F1;
  Result.Y:=Self.Y+v2.Y*F1;
  Result.Z:=Self.Z+v2.Z*F1;
//  Result.W:=Self.W+v2.W*F1;
  Result.W:=0;
End;

function TNativeGLZVector4f.Combine2(constref V2: TNativeGLZVector4f; const F1, F2: Single): TNativeGLZVector4f;
begin
   Result.X:=( Self.X*F1) + (V2.X*F2);
   Result.Y:=( Self.Y*F1) + (V2.Y*F2);
   Result.Z:=( Self.Z*F1) + (V2.Z*F2);
   Result.W:=0;
end;

function TNativeGLZVector4f.Combine3(constref V2, V3: TNativeGLZVector4f; const F1, F2, F3: Single): TNativeGLZVector4f;
begin
  Result.X:=( Self.X*F1) + (V2.X*F2) + (V3.X*F3);
  Result.Y:=( Self.Y*F1) + (V2.Y*F2) + (V3.Y*F3);
  Result.Z:=( Self.Z*F1) + (V2.Z*F2) + (V3.Z*F3);
  Result.W:=0;
end;

function TNativeGLZVector4f.Round:TNativeGLZVector4i;
begin
  result.X:=System.Round(Self.X);
  result.Y:=System.Round(Self.Y);
  result.Z:=System.Round(Self.Z);
  result.W:=System.Round(Self.W);
end;

function TNativeGLZVector4f.Trunc:TNativeGLZVector4i;
begin
  result.X:=System.Trunc(Self.X);
  result.Y:=System.Trunc(Self.Y);
  result.Z:=System.Trunc(Self.Z);
  result.W:=System.Trunc(Self.W);
end;

function TNativeGLZVector4f.Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TNativeGLZVector4f;
begin
   //FSwizzleMode :=  ASwizzle;
   case ASwizzle of
     //swXYXY movlhps
     //swZWZW movhlps
     //swXXYY unpacklo
     //swZZWW unpackhi
     //swXXZZ movldup
     //swYYWW movhdup
     swXXXX, swRRRR :  // Shufps ,00000000b
     begin
       Result.X := Self.X;
       Result.Y := Self.X;
       Result.Z := Self.X;
       Result.W := Self.X;
     end;
     swYYYY, swGGGG :  // Shufps ,01010101b
     begin
       Result.X := Self.Y;
       Result.Y := Self.Y;
       Result.Z := Self.Y;
       Result.W := Self.Y;
     end;
     swZZZZ, swBBBB : // Shufps ,10101010b
     begin
       Result.X := Self.Z;
       Result.Y := Self.Z;
       Result.Z := Self.Z;
       Result.W := Self.Z;
     end;
     swWWWW, swAAAA :  // Shufps ,11111111b
     begin
       Result.X := Self.W;
       Result.Y := Self.W;
       Result.Z := Self.W;
       Result.W := Self.W;
     end;
     swZYXW, swBGRA : // Shufps ,11000110b ==>  ARGB
     begin
       Result.X := Self.Z;
       Result.Y := Self.Y;
       Result.Z := Self.X;
       Result.W := Self.W;
     end;
     swXZYW, swRBGA :  // Shufps ,11011000b
     begin
       Result.X := Self.X;
       Result.Y := Self.Z;
       Result.Z := Self.Y;
       Result.W := Self.W;
     end;
     swZXYW, swBRGA :
     begin
       Result.X := Self.Z;
       Result.Y := Self.X;
       Result.Z := Self.Y;
       Result.W := Self.W;
     end;
     swYXZW, swGRBA :
     begin
       Result.X := Self.Y;
       Result.Y := Self.X;
       Result.Z := Self.Z;
       Result.W := Self.W;
     end;
     swYZXW, swGBRA :
     begin
       Result.X := Self.Y;
       Result.Y := Self.Z;
       Result.Z := Self.X;
       Result.W := Self.W;
     end;
     swWXYZ, swARGB :
     begin
       Result.X := Self.W;
       Result.Y := Self.X;
       Result.Z := Self.Y;
       Result.W := Self.Z;
     end;
     swWZYX, swABGR :
     begin
       Result.X := Self.W;
       Result.Y := Self.Z;
       Result.Z := Self.Y;
       Result.W := Self.X;
     end;
     swWXZY, swARBG :
     begin
       Result.X := Self.W;
       Result.Y := Self.X;
       Result.Z := Self.Z;
       Result.W := Self.Y;
     end;
     swWZXY, swABRG :
     begin
       Result.X := Self.W;
       Result.Y := Self.Z;
       Result.Z := Self.X;
       Result.W := Self.Y;
     end;
     swWYXZ, swAGRB :
     begin
       Result.X := Self.W;
       Result.Y := Self.Y;
       Result.Z := Self.X;
       Result.W := Self.Z;
     end;
     swWYZX, swAGBR :
     begin
       Result.X := Self.W;
       Result.Y := Self.Y;
       Result.Z := Self.Z;
       Result.W := Self.X;
     end;

     else result := self; //swXYZW, swRGBA
   end;
end;

{%endregion%}

{%region%----[ TNativeGLZVector4f Ops on self ]---------------------------------}


procedure TNativeGLZVector4f.pAdd(constref A: TNativeGLZVector4f);
begin
  Self.X := Self.X + A.X;
  Self.Y := Self.Y + A.Y;
  Self.Z := Self.Z + A.Z;
  Self.W := Self.W + A.W;
end;

procedure TNativeGLZVector4f.pSub(constref A: TNativeGLZVector4f);
begin
  Self.X := Self.X - A.X;
  Self.Y := Self.Y - A.Y;
  Self.Z := Self.Z - A.Z;
  Self.W := Self.W - A.W;
end;

procedure TNativeGLZVector4f.pMul(constref A: TNativeGLZVector4f);
begin
  Self.X := Self.X * A.X;
  Self.Y := Self.Y * A.Y;
  Self.Z := Self.Z * A.Z;
  Self.W := Self.W * A.W;
end;

procedure TNativeGLZVector4f.pDiv(constref A: TNativeGLZVector4f);
begin
  Self.X := Self.X / A.X;
  Self.Y := Self.Y / A.Y;
  Self.Z := Self.Z / A.Z;
  Self.W := Self.W / A.W;
end;

procedure TNativeGLZVector4f.pAdd(constref A: Single);
begin
  Self.X := Self.X + A;
  Self.Y := Self.Y + A;
  Self.Z := Self.Z + A;
  Self.W := Self.W + A;
end;

procedure TNativeGLZVector4f.pSub(constref A: Single);
begin
  Self.X := Self.X - A;
  Self.Y := Self.Y - A;
  Self.Z := Self.Z - A;
  Self.W := Self.W - A;
end;

procedure TNativeGLZVector4f.pMul(constref A: Single);
begin
  Self.X := Self.X * A;
  Self.Y := Self.Y * A;
  Self.Z := Self.Z * A;
  Self.W := Self.W * A;
end;

procedure TNativeGLZVector4f.pDiv(constref A: Single);
begin
  Self.X := Self.X / A;
  Self.Y := Self.Y / A;
  Self.Z := Self.Z / A;
  Self.W := Self.W / A;
end;

procedure TNativeGLZVector4f.pInvert;
begin
  Self.X := -Self.X;
  Self.Y := -Self.Y;
  Self.Z := -Self.Z;
  Self.W := -Self.W;
end;

procedure TNativeGLZVector4f.pNegate;
begin
   Self.X := -Self.X;
   Self.Y := -Self.Y;
   Self.Z := -Self.Z;
   Self.W := -Self.W;
end;

procedure TNativeGLZVector4f.pAbs;
begin
  Self.X:=System.Abs(Self.X);
  Self.Y:=System.Abs(Self.Y);
  Self.Z:=System.Abs(Self.Z);
  Self.W:=System.Abs(Self.W);
End;

procedure TNativeGLZVector4f.pDivideBy2;
begin
  Self.x := Self.X*0.5;
  Self.y := Self.Y*0.5;
  Self.z := Self.Z*0.5;
  Self.w := Self.W*0.5;
end;

procedure TNativeGLZVector4f.pCrossProduct(constref A: TNativeGLZVector4f);
Var
 Tmp : TNativeGLZVector4f;
begin
  Tmp.X:=Self.Y*A.Z-Self.Z*A.Y;
  Tmp.Y:=Self.Z*A.X-Self.X*A.Z;
  Tmp.Z:=Self.X*A.Y-Self.Y*A.X;
  Tmp.W:=1;
  Self := Tmp;
end;

procedure TNativeGLZVector4f.pNormalize;
var
  invLen : Single;
  vn : single;
begin
  vn:=Self.Norm;
  if vn=0 then
  begin
//    result := Self;
//    Self.W := 0; //cZero;
  end
  else
  begin
    invLen:=1/Sqrt(vn);
    Self.X:=Self.X*invLen;
    Self.Y:=Self.Y*invLen;
    Self.Z:=Self.Z*invLen;
    Self.W:=Self.W;
  end;
end;

procedure TNativeGLZVector4f.pMin(constref B: TNativeGLZVector4f);
begin
  if Self.X>B.X then Self.X := B.X;
  if Self.Y>B.Y then Self.Y := B.Y;
  if Self.Z>B.Z then Self.Z := B.Z;
  if Self.W>B.W then Self.W := B.W;
End;

procedure TNativeGLZVector4f.pMin(constref B: Single);
begin
  if Self.X>B then Self.X := B;
  if Self.Y>B then Self.Y := B;
  if Self.Z>B then Self.Z := B;
  if Self.W>B then Self.W := B;
End;

procedure TNativeGLZVector4f.pMax(constref B: TNativeGLZVector4f);
begin
  if Self.X<B.X then Self.X := B.X;
  if Self.Y<B.Y then Self.Y := B.Y;
  if Self.Z<B.Z then Self.Z := B.Z;
  if Self.W<B.W then Self.W := B.W;
End;

procedure TNativeGLZVector4f.pMax(constref B: Single);
begin
  if Self.X<B then Self.X := B;
  if Self.Y<B then Self.Y := B;
  if Self.Z<B then Self.Z := B;
  if Self.W<B then Self.W := B;
End;

procedure TNativeGLZVector4f.pClamp(Constref AMin, AMax: TNativeGLZVector4f);
begin
  Self.pMax(AMin);
  Self.pMin(AMax);
End;

procedure TNativeGLZVector4f.pClamp(constref AMin, AMax: Single);
begin
  Self.pMax(AMin);
  Self.pMin(AMax);
End;

procedure TNativeGLZVector4f.pMulAdd(Constref B, C: TNativeGLZVector4f); // (Self*B)+c
begin
  Self := (self*B)+C;
end;

procedure TNativeGLZVector4f.pMulDiv(Constref B, C: TNativeGLZVector4f); // (Self*B)-c
begin
  Self := (self*B)/C;
end;
{%endregion%}
{%endregion%}

{%region%-----[ TNativeGLZMatrix4 ]---------------------------------------------}

function TNativeGLZMatrix4f.GetComponent(const ARow, AColumn: Integer): Single;
begin
  Result := M[ARow, AColumn];
end;

procedure TNativeGLZMatrix4f.SetComponent(const ARow, AColumn: Integer; const Value: Single);
begin
  M[ARow, AColumn] := Value;
end;

procedure TNativeGLZMatrix4f.SetRow(const AIndex: Integer; const Value: TNativeGLZVector4f);
begin
  V[AIndex] := Value;
end;

function TNativeGLZMatrix4f.GetRow(const AIndex: Integer): TNativeGLZVector4f;
begin
  Result := V[AIndex];
end;

function TNativeGLZMatrix4f.ToString : String;
begin
  Result :='|'+V[0].ToString+'|'+#13+#10
          +'|'+V[1].ToString+'|'+#13+#10
          +'|'+V[2].ToString+'|'+#13+#10
          +'|'+V[3].ToString+'|'+#13+#10
End;

class operator TNativeGLZMatrix4f.+(constref A, B: TNativeGLZMatrix4f): TNativeGLZMatrix4f;
begin
  Result.V[0] := A.V[0] + B.V[0];
  Result.V[1] := A.V[1] + B.V[1];
  Result.V[2] := A.V[2] + B.V[2];
  Result.V[3] := A.V[3] + B.V[3];
end;

class operator TNativeGLZMatrix4f.+(constref A: TNativeGLZMatrix4f; constref B: Single): TNativeGLZMatrix4f;
begin
  Result.V[0] := A.V[0] + B;
  Result.V[1] := A.V[1] + B;
  Result.V[2] := A.V[2] + B;
  Result.V[3] := A.V[3] + B;
end;

class operator TNativeGLZMatrix4f.-(constref A, B: TNativeGLZMatrix4f): TNativeGLZMatrix4f;
begin
  Result.V[0] := A.V[0] - B.V[0];
  Result.V[1] := A.V[1] - B.V[1];
  Result.V[2] := A.V[2] - B.V[2];
  Result.V[3] := A.V[3] - B.V[3];
end;

class operator TNativeGLZMatrix4f.-(constref A: TNativeGLZMatrix4f; constref B: Single): TNativeGLZMatrix4f;
begin
  Result.V[0] := A.V[0] - B;
  Result.V[1] := A.V[1] - B;
  Result.V[2] := A.V[2] - B;
  Result.V[3] := A.V[3] - B;
end;

class operator TNativeGLZMatrix4f.-(constref A: TNativeGLZMatrix4f): TNativeGLZMatrix4f;
begin
  Result.V[0] := -A.V[0];
  Result.V[1] := -A.V[1];
  Result.V[2] := -A.V[2];
  Result.V[3] := -A.V[3];
end;

class operator TNativeGLZMatrix4f.*(constref A: TNativeGLZMatrix4f; constref B: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[0,1]) + (B.Z * A.M[0,2]) + (B.W * A.M[0,3]);
  Result.Y := (B.X * A.M[1,0]) + (B.Y * A.M[1,1]) + (B.Z * A.M[1,2]) + (B.W * A.M[1,3]);
  Result.Z := (B.X * A.M[2,0]) + (B.Y * A.M[2,1]) + (B.Z * A.M[2,2]) + (B.W * A.M[2,3]);
  Result.W := (B.X * A.M[3,0]) + (B.Y * A.M[3,1]) + (B.Z * A.M[3,2]) + (B.W * A.M[3,3]);
end;

class operator TNativeGLZMatrix4f.*(constref A, B: TNativeGLZMatrix4f): TNativeGLZMatrix4f;
begin
  Result.M[0,0] := (A.M[0,0] * B.M[0,0]) + (A.M[0,1] * B.M[1,0]) + (A.M[0,2] * B.M[2,0]) + (A.M[0,3] * B.M[3,0]);
  Result.M[0,1] := (A.M[0,0] * B.M[0,1]) + (A.M[0,1] * B.M[1,1]) + (A.M[0,2] * B.M[2,1]) + (A.M[0,3] * B.M[3,1]);
  Result.M[0,2] := (A.M[0,0] * B.M[0,2]) + (A.M[0,1] * B.M[1,2]) + (A.M[0,2] * B.M[2,2]) + (A.M[0,3] * B.M[3,2]);
  Result.M[0,3] := (A.M[0,0] * B.M[0,3]) + (A.M[0,1] * B.M[1,3]) + (A.M[0,2] * B.M[2,3]) + (A.M[0,3] * B.M[3,3]);

  Result.M[1,0] := (A.M[1,0] * B.M[0,0]) + (A.M[1,1] * B.M[1,0]) + (A.M[1,2] * B.M[2,0]) + (A.M[1,3] * B.M[3,0]);
  Result.M[1,1] := (A.M[1,0] * B.M[0,1]) + (A.M[1,1] * B.M[1,1]) + (A.M[1,2] * B.M[2,1]) + (A.M[1,3] * B.M[3,1]);
  Result.M[1,2] := (A.M[1,0] * B.M[0,2]) + (A.M[1,1] * B.M[1,2]) + (A.M[1,2] * B.M[2,2]) + (A.M[1,3] * B.M[3,2]);
  Result.M[1,3] := (A.M[1,0] * B.M[0,3]) + (A.M[1,1] * B.M[1,3]) + (A.M[1,2] * B.M[2,3]) + (A.M[1,3] * B.M[3,3]);

  Result.M[2,0] := (A.M[2,0] * B.M[0,0]) + (A.M[2,1] * B.M[1,0]) + (A.M[2,2] * B.M[2,0]) + (A.M[2,3] * B.M[3,0]);
  Result.M[2,1] := (A.M[2,0] * B.M[0,1]) + (A.M[2,1] * B.M[1,1]) + (A.M[2,2] * B.M[2,1]) + (A.M[2,3] * B.M[3,1]);
  Result.M[2,2] := (A.M[2,0] * B.M[0,2]) + (A.M[2,1] * B.M[1,2]) + (A.M[2,2] * B.M[2,2]) + (A.M[2,3] * B.M[3,2]);
  Result.M[2,3] := (A.M[2,0] * B.M[0,3]) + (A.M[2,1] * B.M[1,3]) + (A.M[2,2] * B.M[2,3]) + (A.M[2,3] * B.M[3,3]);

  Result.M[3,0] := (A.M[3,0] * B.M[0,0]) + (A.M[3,1] * B.M[1,0]) + (A.M[3,2] * B.M[2,0]) + (A.M[3,3] * B.M[3,0]);
  Result.M[3,1] := (A.M[3,0] * B.M[0,1]) + (A.M[3,1] * B.M[1,1]) + (A.M[3,2] * B.M[2,1]) + (A.M[3,3] * B.M[3,1]);
  Result.M[3,2] := (A.M[3,0] * B.M[0,2]) + (A.M[3,1] * B.M[1,2]) + (A.M[3,2] * B.M[2,2]) + (A.M[3,3] * B.M[3,2]);
  Result.M[3,3] := (A.M[3,0] * B.M[0,3]) + (A.M[3,1] * B.M[1,3]) + (A.M[3,2] * B.M[2,3]) + (A.M[3,3] * B.M[3,3]);
end;

class operator TNativeGLZMatrix4f.*(constref A: TNativeGLZMatrix4f; constref B: Single): TNativeGLZMatrix4f;
begin
  Result.V[0] := A.V[0] * B;
  Result.V[1] := A.V[1] * B;
  Result.V[2] := A.V[2] * B;
  Result.V[3] := A.V[3] * B;
end;

class operator TNativeGLZMatrix4f./(constref A: TNativeGLZMatrix4f; constref B: Single): TNativeGLZMatrix4f;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.V[0] := A.V[0] * InvB;
  Result.V[1] := A.V[1] * InvB;
  Result.V[2] := A.V[2] * InvB;
  Result.V[3] := A.V[3] * InvB;
end;

procedure TNativeGLZMatrix4f.CreateIdentityMatrix;
begin
  Self:=NativeIdentityHmgMatrix;
End;

procedure TNativeGLZMatrix4f.CreateScaleMatrix(const v : TGLZAffineVector);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TNativeGLZMatrix4f.CreateScaleMatrix(const v : TNativeGLZVector4f);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TNativeGLZMatrix4f.CreateTranslationMatrix(const V: TGLZAffineVector);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.W.X:=V.X;
   Self.W.Y:=V.Y;
   Self.W.Z:=V.Z;
end;

procedure TNativeGLZMatrix4f.CreateTranslationMatrix(const V: TNativeGLZVector4f);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.W.X:=V.X;
   Self.W.Y:=V.Y;
   Self.W.Z:=V.Z;
end;

procedure TNativeGLZMatrix4f.CreateScaleAndTranslationMatrix(const ascale, offset : TNativeGLZVector4f);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.X:=ascale.X;   Self.W.X:=offset.X;
   Self.Y.Y:=ascale.Y;   Self.W.Y:=offset.Y;
   Self.Z.Z:=ascale.Z;   Self.W.Z:=offset.Z;
end;

procedure TNativeGLZMatrix4f.CreateRotationMatrixX(const sine, cosine: Single);
begin
  Self:=NativeEmptyHmgMatrix;

  // Right Hand Rotation Matrix around X
  // For Left Hand invert the sign of Sin
  {    X     Y     Z    W
   X | 1 |   0  |  0  | 0
   Y | 0 |  cos | sin | 0
   Z | 0 | -sin | cos | 0
   W | 0 |   0  |  0  | 1
  }

  Self.X.X:=1;

  Self.Y.Y:=cosine;
  Self.Y.Z:=-sine;

  Self.Z.Y:=sine;
  Self.Z.Z:=cosine;

  Self.W.W:=1;
end;

procedure TNativeGLZMatrix4f.CreateRotationMatrixX(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixX(s, c);
end;

procedure TNativeGLZMatrix4f.CreateRotationMatrixY(const sine, cosine: Single);
begin
  Self:=NativeEmptyHmgMatrix;

  // Right Hand Rotation Matrix around Y
  // For Left Hand invert the sign of Sin
  {     X      Y      Z     W
   X | Cos |   0  |  Sin  | 0
   Y |  0  |   1  |   0   | 0
   Z |-Sin |   0  |  cos  | 0
   W |  0  |   0  |   0   | 1
  }

  Self.X.X:=cosine;
  Self.X.Z:=sine;
  Self.Y.Y:=1;
  Self.Z.X:=-sine;
  Self.Z.Z:=cosine;
  Self.W.W:=1;
end;

procedure TNativeGLZMatrix4f.CreateRotationMatrixY(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixY(s, c);
end;

procedure TNativeGLZMatrix4f.CreateRotationMatrixZ(const sine, cosine: Single);
begin
  Self:=NativeEmptyHmgMatrix;

  // Right Hand Rotation Matrix around Z
  // For Left Hand invert the sign of Sin
  {     X      Y      Z     W
   X | Cos | -Sin |   0   | 0
   Y | Sin |  Cos |   0   | 0
   Z |  0  |   0  |   1   | 0
   W |  0  |   0  |   0   | 1
  }

  Self.X.X:=cosine;
  Self.X.Y:=-sine;
  Self.Y.X:=sine;
  Self.Y.Y:=cosine;
  Self.Z.Z:=1;
  Self.W.W:=1;
end;

procedure TNativeGLZMatrix4f.CreateRotationMatrixZ(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixZ(s, c);
end;

procedure TNativeGLZMatrix4f.CreateRotationMatrix(const anAxis : TNativeGLZAffineVector; angle : Single);
var
   axis : TNativeGLZVector;
   cosine, sine, one_minus_cosine : Single;
begin
   axis.AsVector3f := anAxis;
   //GLZMath.
   SinCos(angle, sine, cosine);
   one_minus_cosine:=1-cosine;
   axis.Normalize;

   Self.X.X:=(one_minus_cosine * axis.V[0] * axis.V[0]) + cosine;
   Self.X.Y:=(one_minus_cosine * axis.V[0] * axis.V[1]) - (axis.V[2] * sine);
   Self.X.Z:=(one_minus_cosine * axis.V[2] * axis.V[0]) + (axis.V[1] * sine);
   Self.X.W:=0;

   Self.Y.X:=(one_minus_cosine * axis.V[0] * axis.V[1]) + (axis.V[2] * sine);
   Self.Y.Y:=(one_minus_cosine * axis.V[1] * axis.V[1]) + cosine;
   Self.Y.Z:=(one_minus_cosine * axis.V[1] * axis.V[2]) - (axis.V[0] * sine);
   Self.Y.W:=0;

   Self.Z.X:=(one_minus_cosine * axis.V[2] * axis.V[0]) - (axis.V[1] * sine);
   Self.Z.Y:=(one_minus_cosine * axis.V[1] * axis.V[2]) + (axis.V[0] * sine);
   Self.Z.Z:=(one_minus_cosine * axis.V[2] * axis.V[2]) + cosine;
   Self.Z.W:=0;

   Self.W.X:=0;
   Self.W.Y:=0;
   Self.W.Z:=0;
   Self.W.W:=1;
end;

procedure TNativeGLZMatrix4f.CreateRotationMatrix(const anAxis : TNativeGLZVector4f; angle : Single);
begin
   CreateRotationMatrix(anAxis.AsVector3f, angle);
end;

function TNativeGLZMatrix4f.Invert:TNativeGLZMatrix4f;
var
   det : Single;
begin
   det:=GetDeterminant;
   if Abs(Det)<cEPSILON then  result:=NativeIdentityHmgMatrix
   else
   begin
      Self.Adjoint;
      result := Self * (1/det);
   end;
end;

(*function TMatrix4.Inverse: TMatrix4;
var
  C00, C02, C03, C04, C06, C07, C08, C10, C11: Single;
  C12, C14, C15, C16, C18, C19, C20, C22, C23: Single;
  F0, F1, F2, F3, F4, F5, V0, V1, V2, V3, I0, I1, I2, I3, SA, SB, Row, Dot: TVector4;
  Inv: TMatrix4;
  OneOverDeterminant: Single;
begin
  C00 := (M[2,2] * M[3,3]) - (M[3,2] * M[2,3]);
  C02 := (M[1,2] * M[3,3]) - (M[3,2] * M[1,3]);
  C03 := (M[1,2] * M[2,3]) - (M[2,2] * M[1,3]);

  C04 := (M[2,1] * M[3,3]) - (M[3,1] * M[2,3]);
  C06 := (M[1,1] * M[3,3]) - (M[3,1] * M[1,3]);
  C07 := (M[1,1] * M[2,3]) - (M[2,1] * M[1,3]);

  C08 := (M[2,1] * M[3,2]) - (M[3,1] * M[2,2]);
  C10 := (M[1,1] * M[3,2]) - (M[3,1] * M[1,2]);
  C11 := (M[1,1] * M[2,2]) - (M[2,1] * M[1,2]);

  C12 := (M[2,0] * M[3,3]) - (M[3,0] * M[2,3]);
  C14 := (M[1,0] * M[3,3]) - (M[3,0] * M[1,3]);
  C15 := (M[1,0] * M[2,3]) - (M[2,0] * M[1,3]);

  C16 := (M[2,0] * M[3,2]) - (M[3,0] * M[2,2]);
  C18 := (M[1,0] * M[3,2]) - (M[3,0] * M[1,2]);
  C19 := (M[1,0] * M[2,2]) - (M[2,0] * M[1,2]);

  C20 := (M[2,0] * M[3,1]) - (M[3,0] * M[2,1]);
  C22 := (M[1,0] * M[3,1]) - (M[3,0] * M[1,1]);
  C23 := (M[1,0] * M[2,1]) - (M[2,0] * M[1,1]);

  F0 := Vector4(C00, C00, C02, C03);
  F1 := Vector4(C04, C04, C06, C07);
  F2 := Vector4(C08, C08, C10, C11);
  F3 := Vector4(C12, C12, C14, C15);
  F4 := Vector4(C16, C16, C18, C19);
  F5 := Vector4(C20, C20, C22, C23);

  V0 := Vector4(M[1,0], M[0,0], M[0,0], M[0,0]);
  V1 := Vector4(M[1,1], M[0,1], M[0,1], M[0,1]);
  V2 := Vector4(M[1,2], M[0,2], M[0,2], M[0,2]);
  V3 := Vector4(M[1,3], M[0,3], M[0,3], M[0,3]);

  I0 := (V1 * F0) - (V2 * F1) + (V3 * F2);
  I1 := (V0 * F0) - (V2 * F3) + (V3 * F4);
  I2 := (V0 * F1) - (V1 * F3) + (V3 * F5);
  I3 := (V0 * F2) - (V1 * F4) + (V2 * F5);

  SA := Vector4(+1, -1, +1, -1);
  SB := Vector4(-1, +1, -1, +1);

  Inv := Matrix4(I0 * SA, I1 * SB, I2 * SA, I3 * SB);

  Row := Vector4(Inv[0,0], Inv[1,0], Inv[2,0], Inv[3,0]);
  Dot := V[0] * Row;

  OneOverDeterminant := 1 / ((Dot.X + Dot.Y) + (Dot.Z + Dot.W));
  Result := Inv * OneOverDeterminant;
end;  *)

function TNativeGLZMatrix4f.MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
// internal version for the determinant of a 3x3 matrix
begin
  Result:=  a1 * (b2 * c3 - b3 * c2)
          - b1 * (a2 * c3 - a3 * c2)
          + c1 * (a2 * b3 - a3 * b2);
end;

function TNativeGLZMatrix4f.GetDeterminant: Single;
begin
  Result:= Self.V[0].X*MatrixDetInternal(Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z, Self.V[1].W, Self.V[2].W, Self.V[3].W)
          -Self.V[0].Y*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z, Self.V[1].W, Self.V[2].W, Self.V[3].W)
          +Self.V[0].Z*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].W, Self.V[2].W, Self.V[3].W)
          -Self.V[0].W*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z);
end;

procedure TNativeGLZMatrix4f.Adjoint;
var
   a1, a2, a3, a4,
   b1, b2, b3, b4,
   c1, c2, c3, c4,
   d1, d2, d3, d4: Single;
begin
    a1:= Self.X.X; b1:= Self.X.Y;
    c1:= Self.X.Z; d1:= Self.X.W;
    a2:= Self.Y.X; b2:= Self.Y.Y;
    c2:= Self.Y.Z; d2:= Self.Y.W;
    a3:= Self.Z.X; b3:= Self.Z.Y;
    c3:= Self.Z.Z; d3:= Self.Z.W;
    a4:= Self.W.X; b4:= Self.W.Y;
    c4:= Self.W.Z; d4:= Self.W.W;

    // row column labeling reversed since we transpose rows & columns
    Self.X.X:= MatrixDetInternal(b2, b3, b4, c2, c3, c4, d2, d3, d4);
    Self.Y.X:=-MatrixDetInternal(a2, a3, a4, c2, c3, c4, d2, d3, d4);
    Self.Z.X:= MatrixDetInternal(a2, a3, a4, b2, b3, b4, d2, d3, d4);
    Self.W.X:=-MatrixDetInternal(a2, a3, a4, b2, b3, b4, c2, c3, c4);

    Self.X.Y:=-MatrixDetInternal(b1, b3, b4, c1, c3, c4, d1, d3, d4);
    Self.Y.Y:= MatrixDetInternal(a1, a3, a4, c1, c3, c4, d1, d3, d4);
    Self.Z.Y:=-MatrixDetInternal(a1, a3, a4, b1, b3, b4, d1, d3, d4);
    Self.W.Y:= MatrixDetInternal(a1, a3, a4, b1, b3, b4, c1, c3, c4);

    Self.X.Z:= MatrixDetInternal(b1, b2, b4, c1, c2, c4, d1, d2, d4);
    Self.Y.Z:=-MatrixDetInternal(a1, a2, a4, c1, c2, c4, d1, d2, d4);
    Self.Z.Z:= MatrixDetInternal(a1, a2, a4, b1, b2, b4, d1, d2, d4);
    Self.W.Z:=-MatrixDetInternal(a1, a2, a4, b1, b2, b4, c1, c2, c4);

    Self.X.W:=-MatrixDetInternal(b1, b2, b3, c1, c2, c3, d1, d2, d3);
    Self.Y.W:= MatrixDetInternal(a1, a2, a3, c1, c2, c3, d1, d2, d3);
    Self.Z.W:=-MatrixDetInternal(a1, a2, a3, b1, b2, b3, d1, d2, d3);
    Self.W.W:= MatrixDetInternal(a1, a2, a3, b1, b2, b3, c1, c2, c3);
end;


(*procedure TNativeGLZMatrix4.Translate(constref v : TGLZAffineVector);
begin
   Self.W.X:=Self.W.X+v.X;
   Self.W.Y:=Self.W.Y+v.Y;
   Self.W.Z:=Self.W.Z+v.Z;
end; *)

function TNativeGLZMatrix4f.Translate(constref v : TNativeGLZVector4f):TNativeGLZMatrix4f;
begin
   Result := Self;
   Result.W.X:=Self.W.X+v.X;
   Result.W.Y:=Self.W.Y+v.Y;
   Result.W.Z:=Self.W.Z+v.Z;
end;

function TNativeGLZMatrix4f.Multiply(constref M2 : TNativeGLZMatrix4f): TNativeGLZMatrix4f;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.V[I] := Self.V[I] * M2.V[I];
end;

function TNativeGLZMatrix4f.Normalize: TNativeGLZMatrix4f;
begin
   Result.X.W:=0;
   Result.X.Normalize;
   Result.Y.W:=0;
   Result.Y.Normalize;
   Result.Z:=Result.X.CrossProduct(Result.Y);
   Result.X:=Result.Y.CrossProduct(Result.Z);
   Result.W:=NativeWHmgVector;
end;

procedure TNativeGLZMatrix4f.Transpose_Scale_M33(constref src : TNativeGLZMatrix4f; Constref ascale : Single);
// EAX src
// EDX dest
// ECX scale
begin
   Self.V[0].V[0]:=ascale*src.V[0].V[0];
   Self.V[1].V[0]:=ascale*src.V[0].V[1];
   Self.V[2].V[0]:=ascale*src.V[0].V[2];
   Self.V[0].V[1]:=ascale*src.V[1].V[0];
   Self.V[1].V[1]:=ascale*src.V[1].V[1];
   Self.V[2].V[1]:=ascale*src.V[1].V[2];
   Self.V[0].V[2]:=ascale*src.V[2].V[0];
   Self.V[1].V[2]:=ascale*src.V[2].V[1];
   Self.V[2].V[2]:=ascale*src.V[2].V[2];
end;

function TNativeGLZMatrix4f.Transpose: TNativeGLZMatrix4f;
begin
  Result.M[0,0] := M[0,0];
  Result.M[0,1] := M[1,0];
  Result.M[0,2] := M[2,0];
  Result.M[0,3] := M[3,0];

  Result.M[1,0] := M[0,1];
  Result.M[1,1] := M[1,1];
  Result.M[1,2] := M[2,1];
  Result.M[1,3] := M[3,1];

  Result.M[2,0] := M[0,2];
  Result.M[2,1] := M[1,2];
  Result.M[2,2] := M[2,2];
  Result.M[2,3] := M[3,2];

  Result.M[3,0] := M[0,3];
  Result.M[3,1] := M[1,3];
  Result.M[3,2] := M[2,3];
  Result.M[3,3] := M[3,3];
end;

procedure TNativeGLZMatrix4f.AnglePreservingMatrixInvert(constref mat : TNativeGLZMatrix4f);
var
   ascale : Single;
begin
   ascale:=mat.V[0].Norm;

   // Is the submatrix A singular?
   if Abs(ascale)<cEPSILON then
   begin
      // Matrix M has no inverse
      Self:=NativeIdentityHmgMatrix;
      Exit;
   end
   else
   begin
      // Calculate the inverse of the square of the isotropic scale factor
      ascale:=1.0/ascale;
   end;

   // Fill in last row while CPU is busy with the division
   Self.V[0].V[3]:=0.0;
   Self.V[1].V[3]:=0.0;
   Self.V[2].V[3]:=0.0;
   Self.V[3].V[3]:=1.0;

   // Transpose and scale the 3 by 3 upper-left submatrix
   Self.transpose_scale_m33(mat,ascale);

   // Calculate -(transpose(A) / s*s) C
   Self.V[3].V[0]:=-(Self.V[0].V[0]*mat.V[3].V[0]
                    +Self.V[1].V[0]*mat.V[3].V[1]
                    +Self.V[2].V[0]*mat.V[3].V[2]);
   Self.V[3].V[1]:=-(Self.V[0].V[1]*mat.V[3].V[0]
                    +Self.V[1].V[1]*mat.V[3].V[1]
                    +Self.V[2].V[1]*mat.V[3].V[2]);
   Self.V[3].V[2]:=-(Self.V[0].V[2]*mat.V[3].V[0]
                    +Self.V[1].V[2]*mat.V[3].V[1]
                    +Self.V[2].V[2]*mat.V[3].V[2]);
end;

function TNativeGLZMatrix4f.Decompose(var Tran: TGLZMatrixTransformations): Boolean;
var
   I, J: Integer;
   LocMat, pmat, invpmat : TNativeGLZMatrix4f;
   prhs, psol: TNativeGLZVector4f;
   row0, row1, row2 : TNativeGLZVector4f;
   f : Single;
begin
  Result:=False;
  locmat:=Self;
  // normalize the matrix
  if LocMat.W.W = 0 then Exit;
  for I:=0 to 3 do
    for J:=0 to 3 do
      Locmat.V[I].V[J]:=locmat.V[I].V[J] / locmat.W.W;

  // pmat is used to solve for perspective, but it also provides
  // an easy way to test for singularity of the upper 3x3 component.

  pmat:=locmat;
  for I:=0 to 2 do pmat.V[I].W:=0;
  pmat.W.W:=1;

  if pmat.Determinant = 0 then Exit;

  // First, isolate perspective.  This is the messiest.
  if (locmat.X.W <> 0) or (locmat.Y.W <> 0) or (locmat.Z.W <> 0) then begin
    // prhs is the right hand side of the equation.
    prhs.X:=locmat.X.W;
    prhs.Y:=locmat.Y.W;
    prhs.Z:=locmat.Z.W;
    prhs.W:=locmat.W.W;

    // Solve the equation by inverting pmat and multiplying
    // prhs by the inverse.  (This is the easiest way, not
    // necessarily the best.)

    invpmat:=pmat;
    invpmat.Invert;
    invpmat.Transpose;
    psol:=  invpmat * prhs; //VectorTransform(prhs, invpmat);

    // stuff the answer away
    Tran[ttPerspectiveX]:=psol.X;
    Tran[ttPerspectiveY]:=psol.Y;
    Tran[ttPerspectiveZ]:=psol.Z;
    Tran[ttPerspectiveW]:=psol.W;

    // clear the perspective partition
    locmat.X.W:=0;
    locmat.Y.W:=0;
    locmat.Z.W:=0;
    locmat.W.W:=1;
  end else begin
    // no perspective
    Tran[ttPerspectiveX]:=0;
    Tran[ttPerspectiveY]:=0;
    Tran[ttPerspectiveZ]:=0;
    Tran[ttPerspectiveW]:=0;
  end;

  // next take care of translation (easy)
  for I:=0 to 2 do begin
    Tran[TGLZMAtrixTransType(Ord(ttTranslateX) + I)]:=locmat.V[3].V[I];
    locmat.V[3].V[I]:=0;
  end;

  // now get scale and shear
  row0 := locmat.X;
  row1 := locmat.Y;
  row2 := locmat.Z;

  // compute X scale factor and normalize first row
  Tran[ttScaleX]:=Row0.Norm;
  Row0 := Row0 * InvSqrt(Tran[ttScaleX]); //VectorScale(row0, RSqrt(Tran[ttScaleX]));

  // compute XY shear factor and make 2nd row orthogonal to 1st
  Tran[ttShearXY]:=row0.DotProduct(row1);
  f:=-Tran[ttShearXY];
  Row1.Combine(row0, f);

  // now, compute Y scale and normalize 2nd row
  Tran[ttScaleY]:=Row1.Norm;
  Row1 := Row1 * InvSqrt(Tran[ttScaleY]); //VectorScale(row1, RSqrt(Tran[ttScaleY]));
  Tran[ttShearXY]:=Tran[ttShearXY]/Tran[ttScaleY];

  // compute XZ and YZ shears, orthogonalize 3rd row
  Tran[ttShearXZ]:=row0.DotProduct(row2);
  f:=-Tran[ttShearXZ];
  row2.Combine(row0, f);
  Tran[ttShearYZ]:=Row1.DotProduct(row2);
  f:=-Tran[ttShearYZ];
  Row2.Combine(row1, f);

  // next, get Z scale and normalize 3rd row
  Tran[ttScaleZ]:=Row2.Norm;
  Row2:=row2* InvSqrt(Tran[ttScaleZ]);
  Tran[ttShearXZ]:=Tran[ttShearXZ] / tran[ttScaleZ];
  Tran[ttShearYZ]:=Tran[ttShearYZ] / Tran[ttScaleZ];

  // At this point, the matrix (in rows[]) is orthonormal.
  // Check for a coordinate system flip.  If the determinant
  // is -1, then negate the matrix and the scaling factors.
  if row0.DotProduct(row1.CrossProduct(row2)) < 0 then
  begin
    for I:=0 to 2 do
      Tran[TGLZMatrixTransType(Ord(ttScaleX) + I)]:=-Tran[TGLZMatrixTransType(Ord(ttScaleX) + I)];
    row0.pNegate;
    row1.pNegate;
    row2.pNegate;
  end;

  // now, get the rotations out, as described in the gem
  Tran[ttRotateY]:=FastArcSine(-row0.Z);
  if cos(Tran[ttRotateY]) <> 0 then
  begin
    Tran[ttRotateX]:=GLZMath.ArcTan2(row1.Z, row2.Z);
    Tran[ttRotateZ]:=GLZMath.ArcTan2(row0.Y, row0.X);
  end else
  begin
    tran[ttRotateX]:=GLZMath.ArcTan2(row1.X, row1.Y);
    tran[ttRotateZ]:=0;
  end;
  // All done!
  Result:=True;
end;

procedure TNativeGLZMatrix4f.CreateLookAtMatrix(const eye, center, normUp: TNativeGLZVector4f);
var
  XAxis, YAxis, ZAxis, negEye: TNativeGLZVector4f;
begin
  ZAxis := center - eye;
  ZAxis.Normalize;
  XAxis := ZAxis.CrossProduct(normUp);
  XAxis.Normalize;
  YAxis := XAxis.CrossProduct(ZAxis);
  Self.V[0] := XAxis;
  Self.V[1] := YAxis;
  Self.V[2] := ZAxis;
  Self.V[2].pNegate;
  Self.V[3] := NativeNullHmgPoint;
  Self.Transpose;
  negEye := eye;
  negEye.pNegate;
  negEye.V[3] := 1;
  negEye := Self * negEye;// Self.Transform(negEye) ; //VectorTransform(negEye, Self);
  Self.V[3] := negEye;
end;

procedure TNativeGLZMatrix4f.CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);
begin
  Self.X.X := 2 * ZNear / (Right - Left);
  Self.X.Y := 0;
  Self.X.Z := 0;
  Self.X.W := 0;

  Self.Y.X := 0;
  Self.Y.Y := 2 * ZNear / (Top - Bottom);
  Self.Y.Z := 0;
  Self.Y.W := 0;

  Self.Z.X := (Right + Left) / (Right - Left);
  Self.Z.Y := (Top + Bottom) / (Top - Bottom);
  Self.Z.Z := -(ZFar + ZNear) / (ZFar - ZNear);
  Self.Z.W := -1;

  Self.W.X := 0;
  Self.W.Y := 0;
  Self.W.Z := -2 * ZFar * ZNear / (ZFar - ZNear);
  Self.W.W := 0;
end;

procedure TNativeGLZMatrix4f.CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);
var
  xx, yy: Single;
begin
  FOV := GLZMath.Min(179.9, GLZMath.Max(0, FOV));
  yy:= ZNear * GLZMath.Tan(GLZMath.DegToRadian(FOV) * 0.5);
  xx:= yy * Aspect;
  CreateMatrixFromFrustum(-xx, xx, -yy, yy, ZNear, ZFar);
end;

procedure TNativeGLZMatrix4f.CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);
begin
  Self.V[0].V[0] := 2 / (Right - Left);
  Self.V[0].V[1] := 0;
  Self.V[0].V[2] := 0;
  Self.V[0].V[3] := 0;

  Self.V[1].V[0] := 0;
  Self.V[1].V[1] := 2 / (Top - Bottom);
  Self.V[1].V[2] := 0;
  Self.V[1].V[3] := 0;

  Self.V[2].V[0] := 0;
  Self.V[2].V[1] := 0;
  Self.V[2].V[2] := -2 / (ZFar - ZNear);
  Self.V[2].V[3] := 0;

  Self.V[3].V[0] := (Left + Right) / (Left - Right);
  Self.V[3].V[1] := (Bottom + Top) / (Bottom - Top);
  Self.V[3].V[2] := (ZNear + ZFar) / (ZNear - ZFar);
  Self.V[3].V[3] := 1;
end;

procedure TNativeGLZMatrix4f.CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i);
begin
  if (deltax <= 0) or (deltay <= 0) then
  begin
    Self := NativeIdentityHmgMatrix;
    exit;
  end;
  // Translate and scale the picked region to the entire window
  CreateTranslationMatrix(AffineVectorMake( (viewport.V[2] - 2 * (x - viewport.V[0])) / deltax,
	                                    (viewport.V[3] - 2 * (y - viewport.V[1])) / deltay,
                                            0.0));
  Self.V[0].V[0] := viewport.V[2] / deltax;
  Self.V[1].V[1] := viewport.V[3] / deltay;
end;

procedure TNativeGLZMatrix4f.CreateParallelProjectionMatrix(const plane : TNativeGLZHmgPlane;const dir : TNativeGLZVector4f);
// Based on material from a course by William D. Shoaff (www.cs.fit.edu)
var
   dot, invDot : Single;
begin
   dot:=plane.V[0]*dir.V[0]+plane.V[1]*dir.V[1]+plane.V[2]*dir.V[2];
   if Abs(dot)<1e-5 then
   begin
      Self:=NativeIdentityHmgMatrix;
      Exit;
   end;
   invDot:=1/dot;

   Self.V[0].V[0]:=(plane.V[1]*dir.V[1]+plane.V[2]*dir.V[2])*invDot;
   Self.V[1].V[0]:=(-plane.V[1]*dir.V[0])*invDot;
   Self.V[2].V[0]:=(-plane.V[2]*dir.V[0])*invDot;
   Self.V[3].V[0]:=(-plane.V[3]*dir.V[0])*invDot;

   Self.V[0].V[1]:=(-plane.V[0]*dir.V[1])*invDot;
   Self.V[1].V[1]:=(plane.V[0]*dir.V[0]+plane.V[2]*dir.V[2])*invDot;
   Self.V[2].V[1]:=(-plane.V[2]*dir.V[1])*invDot;
   Self.V[3].V[1]:=(-plane.V[3]*dir.V[1])*invDot;

   Self.V[0].V[2]:=(-plane.V[0]*dir.V[2])*invDot;
   Self.V[1].V[2]:=(-plane.V[1]*dir.V[2])*invDot;
   Self.V[2].V[2]:=(plane.V[0]*dir.V[0]+plane.V[1]*dir.V[1])*invDot;
   Self.V[3].V[2]:=(-plane.V[3]*dir.V[2])*invDot;

   Self.V[0].V[3]:=0;
   Self.V[1].V[3]:=0;
   Self.V[2].V[3]:=0;
   Self.V[3].V[3]:=1;
end;

procedure TNativeGLZMatrix4f.CreateShadowMatrix(const planePoint, planeNormal, lightPos : TNativeGLZVector4f);
var
   planeNormal3, dot : Single;
begin
	// Find the last coefficient by back substitutions
	planeNormal3:=-( planeNormal.V[0]*planePoint.V[0]
                   +planeNormal.V[1]*planePoint.V[1]
                   +planeNormal.V[2]*planePoint.V[2]);
	// Dot product of plane and light position
	dot:= planeNormal.V[0]*lightPos.V[0]
        +planeNormal.V[1]*lightPos.V[1]
        +planeNormal.V[2]*lightPos.V[2]
        +planeNormal3  *lightPos.V[3];
	// Now do the projection
	// First column
        Self.V[0].V[0]:= dot - lightPos.V[0] * planeNormal.V[0];
        Self.V[1].V[0]:=     - lightPos.V[0] * planeNormal.V[1];
        Self.V[2].V[0]:=     - lightPos.V[0] * planeNormal.V[2];
        Self.V[3].V[0]:=     - lightPos.V[0] * planeNormal3;
	// Second column
	Self.V[0].V[1]:=     - lightPos.V[1] * planeNormal.V[0];
	Self.V[1].V[1]:= dot - lightPos.V[1] * planeNormal.V[1];
	Self.V[2].V[1]:=     - lightPos.V[1] * planeNormal.V[2];
	Self.V[3].V[1]:=     - lightPos.V[1] * planeNormal3;
	// Third Column
	Self.V[0].V[2]:=     - lightPos.V[2] * planeNormal.V[0];
	Self.V[1].V[2]:=     - lightPos.V[2] * planeNormal.V[1];
	Self.V[2].V[2]:= dot - lightPos.V[2] * planeNormal.V[2];
	Self.V[3].V[2]:=     - lightPos.V[2] * planeNormal3;
	// Fourth Column
	Self.V[0].V[3]:=     - lightPos.V[3] * planeNormal.V[0];
	Self.V[1].V[3]:=     - lightPos.V[3] * planeNormal.V[1];
	Self.V[2].V[3]:=     - lightPos.V[3] * planeNormal.V[2];
	Self.V[3].V[3]:= dot - lightPos.V[3] * planeNormal3;
end;

procedure TNativeGLZMatrix4f.CreateReflectionMatrix(const planePoint, planeNormal : TNativeGLZVector4f);
var
   pv2 : Single;
begin
   // Precalcs
   pv2:=2*planepoint.DotProduct(planeNormal);
   // 1st column
   Self.V[0].V[0]:=1-2*Sqr(planeNormal.V[0]);
   Self.V[0].V[1]:=-2*planeNormal.V[0]*planeNormal.V[1];
   Self.V[0].V[2]:=-2*planeNormal.V[0]*planeNormal.V[2];
   Self.V[0].V[3]:=0;
   // 2nd column
   Self.V[1].V[0]:=-2*planeNormal.V[1]*planeNormal.V[0];
   Self.V[1].V[1]:=1-2*Sqr(planeNormal.V[1]);
   Self.V[1].V[2]:=-2*planeNormal.V[1]*planeNormal.V[2];
   Self.V[1].V[3]:=0;
   // 3rd column
   Self.V[2].V[0]:=-2*planeNormal.V[2]*planeNormal.V[0];
   Self.V[2].V[1]:=-2*planeNormal.V[2]*planeNormal.V[1];
   Self.V[2].V[2]:=1-2*Sqr(planeNormal.V[2]);
   Self.V[2].V[3]:=0;
   // 4th column
   Self.V[3].V[0]:=pv2*planeNormal.V[0];
   Self.V[3].V[1]:=pv2*planeNormal.V[1];
   Self.V[3].V[2]:=pv2*planeNormal.V[2];
   Self.V[3].V[3]:=1;
end;



(* class operator TMatrix4.Divide(const A, B: TMatrix4): TMatrix4;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix4.Divide(const A: TVector4; const B: TMatrix4): TVector4;
begin
  Result := A * B.Inverse;
end;

class operator TMatrix4.Divide(const A: TMatrix4; const B: TVector4): TVector4;
begin
  Result := A.Inverse * B;
end;

function TMatrix4.CompMult(const AOther: TMatrix4): TMatrix4;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.V[I] := V[I] * AOther.V[I];
end; *)

{%endregion%}

{%region%-----[ TNativeGLZQuaternion ]------------------------------------------}

class operator TNativeGLZQuaternion.-(constref A: TNativeGLZQuaternion): TNativeGLZQuaternion;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

class operator TNativeGLZQuaternion.+(constref A, B: TNativeGLZQuaternion): TNativeGLZQuaternion;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

class operator TNativeGLZQuaternion.-(constref A, B: TNativeGLZQuaternion): TNativeGLZQuaternion;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

class operator TNativeGLZQuaternion.+(constref A : TNativeGLZQuaternion; constref B:Single): TNativeGLZQuaternion;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TNativeGLZQuaternion.-(constref A : TNativeGLZQuaternion; constref B:Single): TNativeGLZQuaternion;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TNativeGLZQuaternion./(constref A : TNativeGLZQuaternion; constref B:Single): TNativeGLZQuaternion;
begin
  Result.X := A.X / B;
  Result.Y := A.Y / B;
  Result.Z := A.Z / B;
  Result.W := A.W / B;
end;

class operator TNativeGLZQuaternion.*(constref A: TNativeGLZQuaternion; constref B: Single): TNativeGLZQuaternion;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;


class operator TNativeGLZQuaternion.*(constref A, B: TNativeGLZQuaternion): TNativeGLZQuaternion;
begin

  // Returns the product B*A (which is the concatenation of a rotation Q1 followed by the rotation Q2)

  Result.X :=  (B.w * A.x) + (B.x * A.w) + (B.y * A.z) - (B.z * A.y);
  Result.Y :=  (B.w * A.y) - (B.x * A.z) + (B.y * A.w) + (B.z * A.x);
  Result.Z :=  (B.w * A.z) + (B.x * A.y) - (B.y * A.x) + (B.z * A.w);
  Result.W :=  (B.w * A.w) - (B.x * A.x) - (B.y * A.y) - (B.z * A.z);
end;

class operator TNativeGLZQuaternion.=(constref A, B: TNativeGLZQuaternion): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

class operator TNativeGLZQuaternion.<>(constref A, B: TNativeGLZQuaternion): Boolean;
begin
  Result := (A.X <> B.X) and (A.Y <> B.Y) and (A.Z <> B.Z) and (A.W <> B.W);
end;

function TNativeGLZQuaternion.Conjugate : TNativeGLZQuaternion;
begin
  Result.X:=-Self.X;
  Result.Y:=-Self.Y;
  Result.Z:=-Self.Z;
  Result.W:=Self.W;
end;

{ function TNativeGLQuaternion.Magnitude : Single;
begin
  Result := Sqrt((X * X) + (Y * Y) + (Z * Z) + (W * W));
end; }

function TNativeGLZQuaternion.Magnitude : Single;
begin
//  Result:=Sqrt(Self.AsVector4f.Norm + Sqr(Self.RealPart));
  Result := Sqrt((X * X) + (Y * Y) + (Z * Z) + (W * W));
end;

function TNativeGLZQuaternion.Normalize : TNativeGLZQuaternion;
var
   m, f : Single;
begin
   m:=Self.Magnitude;
   if m>cEpsilon30 then
   begin
      f:=1/m;
      result := Self * f;
   end
   else result:=NativeIdentityQuaternion;
end;

{%region%====[ Commons functions ]==============================================}

function TNativeGLZQuaternion.ToString : String;
begin
   Result := '(ImagePart.X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,ImagePart.Y: '+FloattoStrF(Self.Y,fffixed,5,5)+
            ' ,ImagePart.Z: '+FloattoStrF(Self.Z,fffixed,5,5)+
            ' , RealPart.W: '+FloattoStrF(Self.W,fffixed,5,5)+')';
End;

procedure TNativeGLZQuaternion.Create(x,y,z: Single; Real : Single);
begin
  Self.ImagePart.X:=X;
  Self.ImagePart.Y:=Y;
  Self.ImagePart.Z:=Z;
  Self.RealPart:=real;
end;

procedure TNativeGLZQuaternion.Create(const Imag: array of Single; Real : Single);
var
   n : Integer;
begin
   n:=Length(Imag);
   if n>=1 then Self.ImagePart.X:=Imag[0];
   if n>=2 then Self.ImagePart.Y:=Imag[1];
   if n>=3 then Self.ImagePart.Z:=Imag[2];
   Self.RealPart:=real;
end;

procedure TNativeGLZQuaternion.Create(const V1, V2: TNativeGLZAffineVector);
Var
 //av : TGLZAffineVector;
 vv, vv1,vv2 : TNativeGLZVector;
begin
   vv1.AsVector3f := V1;
   vv2.AsVector3f := V2;
   vv:=vv1.CrossProduct(vv2);
   Self.ImagePart:= vv.AsVector3f;
   Self.RealPart:= Sqrt((vv1.DotProduct(vv2) + 1)/2);
end;
//procedure TNativeGLZQuaternion.Create(const V1, V2: TGLZVector);

//procedure TNativeGLZQuaternion.Create(const mat : TGLZMatrix);
{// the matrix must be a rotation matrix!
var
   traceMat, s, invS : Double;
begin
   traceMat := 1 + mat.V[0].V[0] + mat.V[1].V[1] + mat.V[2].V[2];
   if traceMat>EPSILON2 then begin
      s:=Sqrt(traceMat)*2;
      invS:=1/s;
      Result.ImagPart.V[0]:=(mat.V[1].V[2]-mat.V[2].V[1])*invS;
      Result.ImagPart.V[1]:=(mat.V[2].V[0]-mat.V[0].V[2])*invS;
      Result.ImagPart.V[2]:=(mat.V[0].V[1]-mat.V[1].V[0])*invS;
      Result.RealPart         :=0.25*s;
   end else if (mat.V[0].V[0]>mat.V[1].V[1]) and (mat.V[0].V[0]>mat.V[2].V[2]) then begin  // Row 0:
      s:=Sqrt(MaxFloat(EPSILON2, cOne+mat.V[0].V[0]-mat.V[1].V[1]-mat.V[2].V[2]))*2;
      invS:=1/s;
      Result.ImagPart.V[0]:=0.25*s;
      Result.ImagPart.V[1]:=(mat.V[0].V[1]+mat.V[1].V[0])*invS;
      Result.ImagPart.V[2]:=(mat.V[2].V[0]+mat.V[0].V[2])*invS;
      Result.RealPart         :=(mat.V[1].V[2]-mat.V[2].V[1])*invS;
   end else if (mat.V[1].V[1]>mat.V[2].V[2]) then begin  // Row 1:
      s:=Sqrt(MaxFloat(EPSILON2, cOne+mat.V[1].V[1]-mat.V[0].V[0]-mat.V[2].V[2]))*2;
      invS:=1/s;
      Result.ImagPart.V[0]:=(mat.V[0].V[1]+mat.V[1].V[0])*invS;
      Result.ImagPart.V[1]:=0.25*s;
      Result.ImagPart.V[2]:=(mat.V[1].V[2]+mat.V[2].V[1])*invS;
      Result.RealPart         :=(mat.V[2].V[0]-mat.V[0].V[2])*invS;
   end else begin  // Row 2:
      s:=Sqrt(MaxFloat(EPSILON2, cOne+mat.V[2].V[2]-mat.V[0].V[0]-mat.V[1].V[1]))*2;
      invS:=1/s;
      Result.ImagPart.V[0]:=(mat.V[2].V[0]+mat.V[0].V[2])*invS;
      Result.ImagPart.V[1]:=(mat.V[1].V[2]+mat.V[2].V[1])*invS;
      Result.ImagPart.V[2]:=0.25*s;
      Result.RealPart         :=(mat.V[0].V[1]-mat.V[1].V[0])*invS;
   end;
   NormalizeQuaternion(Result);
end; }

procedure TNativeGLZQuaternion.Create(const angle  : Single; const axis : TNativeGLZAffineVector);
//procedure TNativeGLZQuaternion.Create(const angle  : Single; const axis : TGLZVector);
var
   f, s, c : Single;
   vaxis : TNativeGLZVector;
begin
   GLZMath.SinCos(DegToRadian(angle*cOneDotFive), s, c);
   Self.RealPart:=c;
   vaxis.AsVector3f := axis;
   f:=s/vAxis.Length;
   Self.ImagePart.V[0]:=axis.V[0]*f;
   Self.ImagePart.V[1]:=axis.V[1]*f;
   Self.ImagePart.V[2]:=axis.V[2]*f;
end;

procedure TNativeGLZQuaternion.Create(const r, p, y : Single); //Roll Pitch Yaw
var
   qp, qy : TNativeGLZQuaternion;
begin
   Self.Create(r, NativeZVector); // Create From Angle Axis
   qp.Create(p, NativeXVector);
   qy.Create(y, NativeYVector);

   Self:=qp * Self;
   Self:=qy * Self;
end;

procedure TNativeGLZQuaternion.Create(const x, y, z: Single; eulerOrder : TGLZEulerOrder);
// input angles in degrees
var
   gimbalLock: Boolean;
   quat1, quat2: TNativeGLZQuaternion;

   function EulerToQuat(const X, Y, Z: Single; eulerOrder: TGLZEulerOrder) : TNativeGLZQuaternion;
   const
      cOrder : array [Low(TGLZEulerOrder)..High(TGLZEulerOrder)] of array [1..3] of Byte =
         ( (1, 2, 3), (1, 3, 2), (2, 1, 3),     // eulXYZ, eulXZY, eulYXZ,
           (3, 1, 2), (2, 3, 1), (3, 2, 1) );   // eulYZX, eulZXY, eulZYX
   var
      q : array [1..3] of TNativeGLZQuaternion;
   begin
      q[cOrder[eulerOrder][1]].Create(X, NativeXVector); // Create From Angle Axis
      q[cOrder[eulerOrder][2]].Create(Y, NativeYVector);
      q[cOrder[eulerOrder][3]].Create(Z, NativeZVector);
      result:=(q[2] * q[3]);
      result:=(q[1] * Self);
   end;

const
   SMALL_ANGLE = 0.001;
begin
   NormalizeDegAngle(x);
   NormalizeDegAngle(y);
   NormalizeDegAngle(z);
   case EulerOrder of
      eulXYZ, eulZYX: GimbalLock := Abs(Abs(y) - 90.0) <= cEpsilon30; // cos(Y) = 0;
      eulYXZ, eulZXY: GimbalLock := Abs(Abs(x) - 90.0) <= cEpsilon30; // cos(X) = 0;
      eulXZY, eulYZX: GimbalLock := Abs(Abs(z) - 90.0) <= cEpsilon30; // cos(Z) = 0;
   else
      Assert(False);
      gimbalLock:=False;
   end;
   if gimbalLock then
   begin
      case EulerOrder of
        eulXYZ, eulZYX: quat1 := EulerToQuat(x, y - SMALL_ANGLE, z, EulerOrder);
        eulYXZ, eulZXY: quat1 := EulerToQuat(x - SMALL_ANGLE, y, z, EulerOrder);
        eulXZY, eulYZX: quat1 := EulerToQuat(x, y, z - SMALL_ANGLE, EulerOrder);
      end;
      case EulerOrder of
        eulXYZ, eulZYX: quat2 := EulerToQuat(x, y + SMALL_ANGLE, z, EulerOrder);
        eulYXZ, eulZXY: quat2 := EulerToQuat(x + SMALL_ANGLE, y, z, EulerOrder);
        eulXZY, eulYZX: quat2 := EulerToQuat(x, y, z + SMALL_ANGLE, EulerOrder);
      end;
      Self := Quat1.Slerp(quat2, 0.5);
   end
   else
   begin
      Self := EulerToQuat(x, y, z, EulerOrder);
   end;
end;

procedure TNativeGLZQuaternion.ConvertToPoints(var ArcFrom, ArcTo: TNativeGLZAffineVector);
//procedure ConvertToPoints(var ArcFrom, ArcTo: TGLZVector); //overload;
var
   s, invS : Single;
begin
   s:=Self.ImagePart.X*Self.ImagePart.X+Self.ImagePart.Y*Self.ImagePart.Y;
   if s=0 then ArcFrom := NativeAffineVectorMake( 0, 1, 0)
   else
   begin
      invS:=InvSqrt(s);
      ArcFrom := NativeAffineVectorMake( -Self.ImagePart.Y*invS, Self.ImagePart.X*invS, 0);
   end;
   ArcTo.X:=Self.RealPart*ArcFrom.X-Self.ImagePart.Z*ArcFrom.Y;
   ArcTo.Y:=Self.RealPart*ArcFrom.Y+Self.ImagePart.Z*ArcFrom.X;
   ArcTo.Z:=Self.ImagePart.X*ArcFrom.Y-Self.ImagePart.Y*ArcFrom.X;
   if Self.RealPart<0 then ArcFrom := NativeAffineVectorMake( -ArcFrom.X, -ArcFrom.Y, 0);
end;

function TNativeGLZQuaternion.MultiplyAsSecond(const qFirst : TNativeGLZQuaternion): TNativeGLZQuaternion;
Begin
  Result.X :=  (QFirst.w * Self.x) + (QFirst.x * Self.w) + (QFirst.y * Self.z) - (QFirst.z * Self.y);
  Result.Y :=  (QFirst.w * Self.y) - (QFirst.x * Self.z) + (QFirst.y * Self.w) + (QFirst.z * Self.x);
  Result.Z :=  (QFirst.w * Self.z) + (QFirst.x * Self.y) - (QFirst.y * Self.x) + (QFirst.z * Self.w);
  Result.W :=  (QFirst.w * Self.w) - (QFirst.x * Self.x) - (QFirst.y * Self.y) - (QFirst.z * Self.z);
end;


function TNativeGLZQuaternion.Slerp(const QEnd: TNativeGLZQuaternion; Spin: Integer; t: Single): TNativeGLZQuaternion;
var
    beta,                   // complementary interp parameter
    theta,                  // Angle between A and B
    sint, cost,             // sine, cosine of theta
    phi: Single;            // theta plus spins
    bflip: Boolean;         // use negativ t?
begin
  // cosine theta
  cost:=Self.AsVector4f.AngleCosine(QEnd.AsVector4f);

   // if QEnd is on opposite hemisphere from QStart, use -QEnd instead
   if cost < 0 then
   begin
      cost:=-cost;
      bflip:=True;
   end
   else
     bflip:=False;

   // if QEnd is (within precision limits) the same as QStart,
   // just linear interpolate between QStart and QEnd.
   // Can't do spins, since we don't know what direction to spin.

   if (1 - cost) < cEpsilon then
   begin
      beta:=1 - t
   end
   else
   begin
      // normal case
      theta:=arccos(cost);
      phi:=theta + Spin * Pi;
      sint:=sin(theta);
      beta:=sin(theta - t * phi) / sint;
      t:=sin(t * phi) / sint;
   end;

   if bflip then t:=-t;

   // interpolate
   Result.ImagePart.X:=beta * Self.ImagePart.X + t * QEnd.ImagePart.X;
   Result.ImagePart.Y:=beta * Self.ImagePart.Y + t * QEnd.ImagePart.Y;
   Result.ImagePart.Z:=beta * Self.ImagePart.Z + t * QEnd.ImagePart.Z;
   Result.RealPart:=beta * Self.RealPart + t * QEnd.RealPart;
end;

function TNativeGLZQuaternion.Slerp(const QEnd: TNativeGLZQuaternion; const t : Single) : TNativeGLZQuaternion;
var
   to1: array[0..4] of Single;
   omega, cosom, sinom, scale0, scale1: Extended;
// t goes from 0 to 1
// absolute rotations
begin
   // calc cosine
   cosom:= Self.ImagePart.X*QEnd.ImagePart.X
          +Self.ImagePart.Y*QEnd.ImagePart.Y
          +Self.ImagePart.Z*QEnd.ImagePart.Z
	  +Self.RealPart   *QEnd.RealPart;
   // adjust signs (if necessary)
   if cosom<0 then
   begin
      cosom := -cosom;
      to1[0] := - QEnd.ImagePart.X;
      to1[1] := - QEnd.ImagePart.Y;
      to1[2] := - QEnd.ImagePart.Z;
      to1[3] := - QEnd.RealPart;
   end
   else
   begin
      to1[0] := QEnd.ImagePart.X;
      to1[1] := QEnd.ImagePart.Y;
      to1[2] := QEnd.ImagePart.Z;
      to1[3] := QEnd.RealPart;
   end;
   // calculate coefficients
   if ((1.0-cosom)>cEpsilon30) then // standard case (slerp)
   begin
      omega:=GLZMath.ArcCos(cosom);
      sinom:=1/Sin(omega);
      scale0:=Sin((1.0-t)*omega)*sinom;
      scale1:=Sin(t*omega)*sinom;
   end
   else  // "from" and "to" quaternions are very close
   begin
      //  ... so we can do a linear interpolation
      scale0:=1.0-t;
      scale1:=t;
   end;
   // calculate final values
   Result.ImagePart.V[0] := scale0 * Self.ImagePart.V[0] + scale1 * to1[0];
   Result.ImagePart.V[1] := scale0 * Self.ImagePart.V[1] + scale1 * to1[1];
   Result.ImagePart.V[2] := scale0 * Self.ImagePart.V[2] + scale1 * to1[2];
   Result.RealPart       := scale0 * Self.RealPart       + scale1 * to1[3];
   //NormalizeQuaternion(Result);
   //Result.pNormalize;
   Result := Result.Normalize;
end;

{ Constructs a rotation matrix from (possibly non-unit) quaternion.
   Assumes matrix is used to multiply column vector on the left:
   vnew = mat vold.
   Works correctly for right-handed coordinate system and right-handed rotations. }
//function TNativeGLZQuaternion.ConvertToMatrix : TGLZMatrix;
{ var
   w, x, y, z, xx, xy, xz, xw, yy, yz, yw, zz, zw: Single;
begin
   NormalizeQuaternion(quat);
   w := quat.RealPart;
   x := quat.ImagPart.V[0];
   y := quat.ImagPart.V[1];
   z := quat.ImagPart.V[2];
   xx := x * x;
   xy := x * y;
   xz := x * z;
   xw := x * w;
   yy := y * y;
   yz := y * z;
   yw := y * w;
   zz := z * z;
   zw := z * w;
   Result.V[0].V[0] := 1 - 2 * ( yy + zz );
   Result.V[1].V[0] :=     2 * ( xy - zw );
   Result.V[2].V[0] :=     2 * ( xz + yw );
   Result.V[3].V[0] := 0;
   Result.V[0].V[1] :=     2 * ( xy + zw );
   Result.V[1].V[1] := 1 - 2 * ( xx + zz );
   Result.V[2].V[1] :=     2 * ( yz - xw );
   Result.V[3].V[1] := 0;
   Result.V[0].V[2] :=     2 * ( xz - yw );
   Result.V[1].V[2] :=     2 * ( yz + xw );
   Result.V[2].V[2] := 1 - 2 * ( xx + yy );
   Result.V[3].V[2] := 0;
   Result.V[0].V[3] := 0;
   Result.V[1].V[3] := 0;
   Result.V[2].V[3] := 0;
   Result.V[3].V[3] := 1;
end; }

//function TNativeGLZQuaternion.ConvertToAffineMatrix : TGLZAffineMatrix;
{ var
   w, x, y, z, xx, xy, xz, xw, yy, yz, yw, zz, zw: Single;
begin
   NormalizeQuaternion(quat);
   w := quat.RealPart;
   x := quat.ImagPart.V[0];
   y := quat.ImagPart.V[1];
   z := quat.ImagPart.V[2];
   xx := x * x;
   xy := x * y;
   xz := x * z;
   xw := x * w;

   yy := y * y;
   yz := y * z;
   yw := y * w;

   zz := z * z;
   zw := z * w;

   Result.V[0].V[0] := 1 - 2 * ( yy + zz );
   Result.V[1].V[0] :=     2 * ( xy - zw );
   Result.V[2].V[0] :=     2 * ( xz + yw );
   Result.V[0].V[1] :=     2 * ( xy + zw );
   Result.V[1].V[1] := 1 - 2 * ( xx + zz );
   Result.V[2].V[1] :=     2 * ( yz - xw );
   Result.V[0].V[2] :=     2 * ( xz - yw );
   Result.V[1].V[2] :=     2 * ( yz + xw );
   Result.V[2].V[2] := 1 - 2 * ( xx + yy );
end; }

{%endregion%}

{%endregion%}

{%region%----[ TNativeGLZHmgPlane Helper ]--------------------------------------}

procedure TNativeGLZHmgPlane.Create(constref point, normal : TNativeGLZVector);
begin
   Self.AsNormal3 := normal.AsVector3f;
   Self.W:=-(Point.DotProduct(normal));
end;

procedure TNativeGLZHmgPlane.Create(constref p1, p2, p3 : TNativeGLZVector);
begin
  CalcNormal(p1, p2, p3);
  Self.W:=-(p1.DotProduct(Self.AsVector));
end;

procedure TNativeGLZHmgPlane.CalcNormal(constref p1, p2, p3 : TNativeGLZVector);
var
   v1, v2 : TNativeGLZVector;
begin
   v1:=p2-p1;
   v2:=p3-p1;
   Self.AsVector:=v1.CrossProduct(v2);
   Self.AsVector:=Self.AsVector.Normalize;
end;

function TNativeGLZHmgPlane.Distance(constref point : TNativeGLZVector) : Single;
begin
   result:= (Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W;
end;

function TNativeGLZHmgPlane.AbsDistance(constref point : TNativeGLZVector) : Single;
begin
   result:= System.Abs((Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W );
end;

function TNativeGLZHmgPlane.Distance(constref Center : TNativeGLZVector; constref Radius:Single) : Single;
var dist : single;
begin
  dist := Self.Distance(Center);
  result := 0.0;
  if(Abs(dist) > Radius) then
    if Dist > 0 then
      result := dist - radius
    else
      result := dist + radius;
end;

function TNativeGLZHmgPlane.Normalized:TNativeGLZHmgPlane;
var
   n : Single;
begin
   Result := Self;
   Result.Normalize;
end;

procedure TNativeGLZHmgPlane.Normalize;
var
   n : Single;
begin
   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
   Self.AsVector.pMul(n);
end;

function TNativeGLZHmgPlane.IsInHalfSpace(constref point: TNativeGLZVector) : Boolean;
begin
 Result := ((Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W) > 0;
end;
function TNativeGLZHmgPlane.Perpendicular(constref P : TNativeGLZVector4f) : TNativeGLZVector4f;
var
   dot : Single;
begin
  dot:= Self.AsVector.DotProduct(P);
  Result.X:=P.X - (Dot * Self.X);
  Result.Y:=P.Y - (Dot * Self.Y);
  Result.Z:=P.Z - (Dot * Self.Z);
  Result.W:=P.W;
end;

function TNativeGLZHmgPlane.Reflect(constref V: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  //  Result:=Self.Combine(Self, N, 1, -2*VectorDotProduct(Self, N));
  //  Result := Self - (N*(2 * N.Dotproduct(Self)));
    Result :=  V - (Self.AsVector * (2 * V.DotProduct(Self.AsVector)));
 // Result.W:=0;
end;
function TNativeGLZHmgPlaneHelper.Contains(const TestBSphere: TNativeGLZBoundingSphere): TGLZSpaceContains;
var
   Dist: Single;
begin
  Dist := self.Distance(TestBSphere.Center);

  if Abs(Dist) < TestBSphere.Radius then
    Result := ScContainsPartially
  else if Dist < 0 then
    Result :=  ScNoOverlap
  else
    Result := ScContainsFully;
end;

{%endregion%}

{%region%----[ TNativeGLZVectorHelper ]-----------------------------------------}

function TNativeGLZVectorHelper.Rotate(constref axis : TNativeGLZVector; angle : Single):TNativeGLZVector;
var
   rotMatrix : TNativeGLZMatrix;
begin
   rotMatrix.CreateRotationMatrix(axis, Angle);
   Result:=rotMatrix*Self;
end;

function TNativeGLZVectorHelper.RotateWithMatrixAroundX(alpha : Single) : TNativeGLZVector;
var
   rotMatrix : TNativeGLZMatrix;
begin
   rotMatrix.CreateRotationMatrixX(Alpha);
   Result:=rotMatrix*Self;
end;

function TNativeGLZVectorHelper.RotateWithMatrixAroundY(alpha : Single) : TNativeGLZVector;
var
   rotMatrix : TNativeGLZMatrix;
begin
   rotMatrix.CreateRotationMatrixY(Alpha);
   Result:=rotMatrix*Self;
end;

function TNativeGLZVectorHelper.RotateWithMatrixAroundZ(alpha : Single) : TNativeGLZVector;
var
   rotMatrix : TNativeGLZMatrix;
begin
   rotMatrix.CreateRotationMatrixZ(Alpha);
   Result:=rotMatrix*Self;
end;

function TNativeGLZVectorHelper.RotateAroundX( alpha : Single) : TNativeGLZVector;
var
   c, s : Single;
begin
  SinCos(alpha, s, c);
  Result.X := Self.X;
  Result.Y := c * Self.Y - s * Self.Z;
  Result.Z := c * Self.Z + s * Self.Y;
  Result.W := Self.W
end;

function TNativeGLZVectorHelper.RotateAroundY(alpha : Single) : TNativeGLZVector;
var
   c, s : Single;
begin
  SinCos(alpha, s, c);
  Result.X := c * Self.X + s * Self.Z;
  Result.Y := Self.Y;
  Result.Z := c * Self.Z - s * Self.X;
  Result.W := Self.W
end;

function TNativeGLZVectorHelper.RotateAroundZ(alpha : Single) : TNativeGLZVector;
var
   c, s : Single;
begin
  SinCos(alpha, s, c);
  Result.X := c * Self.Y - s * Self.X;
  Result.Y := c * Self.X + s * Self.Y;
  Result.Z := Self.Z;
  Result.W := Self.W
end;

function TNativeGLZVectorHelper.MoveAround(constref AMovingObjectUp, ATargetPosition: TNativeGLZVector;pitchDelta, turnDelta: Single): TNativeGLZVector;
var
  originalT2C, normalT2C, normalCameraRight: TNativeGLZVector;
  pitchNow, dist: Single;
begin
    // normalT2C points away from the direction the camera is looking
    originalT2C := Self - ATargetPosition;
    normalT2C := originalT2C;
    dist := normalT2C.Length;
    normalT2C := normalT2C.Normalize;
    // normalRight points to the camera's right
    // the camera is pitching around this axis.
    normalCameraRight := AMovingObjectUp.CrossProduct(normalT2C);
    if normalCameraRight.Length < 0.001 then
      normalCameraRight:= NativeXHmgVector // arbitrary vector
    else
      normalCameraRight := normalCameraRight.Normalize;
    // calculate the current pitch.
    // 0 is looking down and PI is looking up
    pitchNow := ArcCos(AMovingObjectUp.DotProduct(normalT2C));
    pitchNow := GLZUtils.Clamp(pitchNow - DegToRadian(pitchDelta), 0 + 0.025, cPI - 0.025);
    // create a new vector pointing up and then rotate it down
    // into the new position
    normalT2C := AMovingObjectUp;
    normalT2C := normalT2C.Rotate(normalCameraRight, pitchNow);
    normalT2C := normalT2C.Rotate(AMovingObjectUp, DegToRadian(turnDelta));
    normalT2C := normalT2C * dist;
    Result := Self + (normalT2C - originalT2C);
end;

function TNativeGLZVectorHelper.PointProject(constref origin, direction : TNativeGLZVector) : Single;
begin
   Result:= direction.X*(Self.X-origin.X)
           +direction.Y*(Self.Y-origin.Y)
           +direction.Z*(Self.Z-origin.Z);
end;

function TNativeGLZVectorHelper.ShiftObjectFromCenter(Constref
  ACenter : TNativeGLZVector; const ADistance : Single;
  const AFromCenterSpot : Boolean) : TNativeGLZVector;
var
  lDirection: TNativeGLZVector;
begin
  lDirection := Self - ACenter;
  lDirection := lDirection.Normalize;
  if AFromCenterSpot then Result := ACenter + (lDirection * ADistance)
  else Result := Self + (lDirection * ADistance)
end;

{gets the normal at cen based on the connected quad mesh vectors}
function TNativeGLZVectorHelper.AverageNormal4(constref up, left, down,right: TNativeGLZVector): TNativeGLZVector;
var
  s,t,u,r: TNativeGLZVector4f;
begin
  s := up - self;
  t := left - self;
  u := down - self;
  r := right - self;
  Result.X := s.Y*t.Z - s.Z*t.Y + t.Y*u.Z - t.Z*u.Y + u.Y*r.Z - u.Z*r.Y + r.Y*s.Z - r.Z*s.Y;
  Result.Y := s.Z*t.X - s.X*t.Z + t.Z*u.X - t.x*u.Z + u.Z*r.X - u.X*r.Z + r.Z*s.X - r.X*s.Z;
  Result.Z := s.X*t.Y - s.Y*t.X + t.X*u.Y - t.Y*u.X + u.X*r.Y - u.Y*r.X + r.X*s.Y - r.Y*s.X;
  Result := Result.Normalize;
end;

function TNativeGLZVectorHelper.ExtendClipRect(vX, vY: Single) : TNativeGLZClipRect;
begin
  Result := Self;
  with Result do
  begin
    if vX < Left then Left := vX;
    if vY < Top then Top := vY;

    if vX > Right then Right := vX;
    if vY > Bottom then Bottom := vY;
  end;
end;

function TNativeGLZVectorHelper.Step(ConstRef B : TNativeGLZVector) : TNativeGLZVector;
begin
  result := Self;
  if self.X <= B.X then result.X := 0;
  if self.Y <= B.Y then result.Y := 0;
  if self.Z <= B.Z then result.Z := 0;
  if self.W <= B.W then result.W := 0;
end;

function TNativeGLZVectorHelper.FaceForward(constref A, B : TNativeGLZVector) : TNativeGLZVector;
begin
  if (B.DotProduct(A) < 0) then
     Result := -Self
   else
     Result := Self;
end;

function TNativeGLZVectorHelper.Saturate : TNativeGLZVector;
begin
  Result := Self.Min(NativeXYZWHmgVector);
  Result := Result.Max(NativeNullHmgVector);
end;

function TNativeGLZVectorHelper.SmoothStep(ConstRef  A,B : TNativeGLZvector): TNativeGLZVector;
var
  t: TNativeGLZVector;
begin
  t := (Self-a)/(b-a);
  t := t.Saturate;
  // t * t * (3.0 - (t * 2.0)); <--- no overload for single - vector
  result := t * t * -((t * 2.0) + -3);
end;


{%endregion%}

{%region%----[ TNativeGLZMatrixHelper ]-----------------------------------------}

// Turn (Y axis)
function TNativeGLZMatrixHelper.Turn( Angle: Single): TNativeGLZMatrix;
var
  m : TNativeGLZMatrix;
begin
  m.CreateRotationMatrix(NativeAffineVectorMake(Self.V[1].V[0], Self.V[1].V[1], Self.V[1].V[2]), Angle);
  Result:=Self * m;
end;

// Turn (direction)
function TNativeGLZMatrixHelper.Turn(constref MasterUp: TNativeGLZVector; Angle: Single): TNativeGLZMatrix;
var
  m : TNativeGLZMatrix;
begin
  m.CreateRotationMatrix(MasterUp, Angle);
  Result:=Self * m;
end;

// Pitch (X axis)
function TNativeGLZMatrixHelper.Pitch(Angle: Single): TNativeGLZMatrix;
var
  m : TNativeGLZMatrix;
begin
  m.CreateRotationMatrix(NativeAffineVectorMake(Self.V[0].V[0], Self.V[0].V[1], Self.V[0].V[2]), Angle);
  Result:=Self * m;
end;

// Pitch (direction)
function TNativeGLZMatrixHelper.Pitch(constref MasterRight: TNativeGLZVector; Angle: Single): TNativeGLZMatrix;
var
  m : TNativeGLZMatrix;
begin
  m.CreateRotationMatrix(MasterRight, Angle);
  Result := Self * m;
end;

// Roll (Z axis)
function TNativeGLZMatrixHelper.Roll(Angle: Single): TNativeGLZMatrix;
var
  m : TNativeGLZMatrix;
begin
  m.CreateRotationMatrix(NativeAffineVectorMake(Self.V[2].V[0], Self.V[2].V[1], Self.V[2].V[2]), Angle);
  Result := Self * m;
end;

// Roll (direction)
function TNativeGLZMatrixHelper.Roll(constref MasterDirection: TNativeGLZVector; Angle: Single): TNativeGLZMatrix;
var
  m : TNativeGLZMatrix;
begin
  m.CreateRotationMatrix(MasterDirection, Angle);
  Result := Self * m;
end;

{%endregion%}

{%region%----[ TNativeGLZBoundingBox ]------------------------------------------}
type
  TPlanIndices = array [0 .. 3] of Integer;
  TPlanBB = array [0 .. 5] of TPlanIndices;
  TDirPlan = array [0 .. 5] of Integer;

const
  CBBFront: TPlanIndices = (0, 1, 2, 3);
  CBBBack: TPlanIndices = (4, 5, 6, 7);
  CBBLeft: TPlanIndices = (0, 4, 7, 3);
  CBBRight: TPlanIndices = (1, 5, 6, 2);
  CBBTop: TPlanIndices = (0, 1, 5, 4);
  CBBBottom: TPlanIndices = (2, 3, 7, 6);
  CBBPlans: TPlanBB = ((0, 1, 2, 3), (4, 5, 6, 7), (0, 4, 7, 3), (1, 5, 6, 2),
    (0, 1, 5, 4), (2, 3, 7, 6));
  CDirPlan: TDirPlan = (0, 0, 1, 1, 2, 2);


procedure SetPlanBB(Var A:TNativeGLZBoundingBox;const NumPlan: Integer; const Valeur: Double);
var
  I: Integer;
begin
  for I := 0 to 3 do
  begin
    A.Points[CBBPlans[NumPlan][I]].V[CDirPlan[NumPlan]] := Valeur;
    A.Points[CBBPlans[NumPlan][I]].V[3] := 1;
  end;
end;

procedure TNativeGLZBoundingBox.Create(Const AValue : TNativeGLZVector);
begin
  SetPlanBB(Self, 0,  AValue.X);
  SetPlanBB(Self, 1, -AValue.X);
  SetPlanBB(Self, 2,  AValue.Y);
  SetPlanBB(Self, 3, -AValue.Y);
  SetPlanBB(Self, 4,  AValue.Z);
  SetPlanBB(Self, 5, -AValue.Z);
end;

class operator TNativeGLZBoundingBox.+(ConstRef A, B : TNativeGLZBoundingBox):TNativeGLZBoundingBox;overload;
var
  I, J: Integer;
  C1, C2 : TNativeGLZBoundingBox;
begin
  C1 := A;
  C2 := B;
  for I := 0 to 7 do
  begin
    for J := 0 to 3 do
      if C1.Points[CBBFront[J]].X < C2.Points[I].X then SetPlanBB(C1, 0, C2.Points[I].X);
    for J := 0 to 3 do
      if C1.Points[CBBBack[J]].X > C2.Points[I].X then SetPlanBB(C1, 1, C2.Points[I].X);
    for J := 0 to 3 do
      if C1.Points[CBBLeft[J]].Y < C2.Points[I].Y then SetPlanBB(C1, 2, C2.Points[I].Y);
    for J := 0 to 3 do
      if C1.Points[CBBRight[J]].Y > C2.Points[I].Y then SetPlanBB(C1, 3, C2.Points[I].Y);
    for J := 0 to 3 do
      if C1.Points[CBBTop[J]].Z < C2.Points[I].Z then SetPlanBB(C1, 4, C2.Points[I].Z);
    for J := 0 to 3 do
      if C1.Points[CBBBottom[J]].Z > C2.Points[I].Z then SetPlanBB(C1, 5, C2.Points[I].Z);
  end;
  Result := C1;
end;

class operator TNativeGLZBoundingBox.+(ConstRef A: TNativeGLZBoundingBox; ConstRef B : TNativeGLZVector):TNativeGLZBoundingBox;
var
  I: Integer;
begin
  for I := 0 to 7 do
   result.Points[I] := A.Points[I] + B;
end;

class operator TNativeGLZBoundingBox.=(ConstRef A, B : TNativeGLZBoundingBox):Boolean;
begin
  Result := CompareMem(@A, @B, SizeOf(TNativeGLZBoundingBox));

(*  Result := (A.Points[0] = B.Points[0]) and
            (A.Points[1] = B.Points[1]) and
            (A.Points[2] = B.Points[2]) and
            (A.Points[3] = B.Points[3]) and
            (A.Points[4] = B.Points[4]) and
            (A.Points[5] = B.Points[5]) and
            (A.Points[6] = B.Points[6]) and
            (A.Points[7] = B.Points[7]); *)
end;

function TNativeGLZBoundingBox.Transform(ConstRef M:TNativeGLZMAtrix):TNativeGLZBoundingBox;
var
  I: Integer;
begin
  Result := Self;
  for I := 0 to 7 do
    Result.Points[I] := M * Result.Points[I];
end;

function TNativeGLZBoundingBox.MinX : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].X;
  for I := 1 to 7 do
    Result := Math.Min(Result, Self.Points[I].X);
end;

function TNativeGLZBoundingBox.MaxX : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].X;
  for I := 1 to 7 do
    Result := Math.Max(Result, Self.Points[I].X);
end;

function TNativeGLZBoundingBox.MinY : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Y;
  for I := 1 to 7 do
    Result := Math.Min(Result, Self.Points[I].y);
end;

function TNativeGLZBoundingBox.MaxY : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Y;
  for I := 1 to 7 do
    Result := Math.Max(Result, Self.Points[I].Y);
end;

function TNativeGLZBoundingBox.MinZ : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Z;
  for I := 1 to 7 do
    Result := Math.Min(Result, Self.Points[I].Z);
end;

function TNativeGLZBoundingBox.MaxZ : Single;
var
  I: Integer;
begin
  Result := Self.Points[0].Z;
  for I := 1 to 7 do
    Result := Math.Max(Result, Self.Points[I].Z);
end;

{%endregion}

{%region%----[ TNativeGLZBoundingSphere ]---------------------------------------}

procedure TNativeGLZBoundingSphere.Create(Const x,y,z: Single;Const r: single = 1.0);
begin
 Center.Create(x,y,z,1);
 Radius := r;
end;

procedure TNativeGLZBoundingSphere.Create(Const AValue : TNativeGLZAffineVector;Const r: single = 1.0);
begin
  Center.Create(AValue,1);
  Radius := r;
end;

procedure TNativeGLZBoundingSphere.Create(Const AValue : TNativeGLZVector;Const r: single = 1.0);
begin
  Center := AValue;
  Center.W := 1;
  Radius := r;
end;

function TNativeGLZBoundingSphere.ToString: String;
begin
  Result := '{' +Self.Center.ToString + ' R: ' + FloattoStrF(Self.Radius,fffixed,5,5) + '}';
end;

function TNativeGLZBoundingSphere.Contains(const TestBSphere: TNativeGLZBoundingSphere) : TGLZSpaceContains;
var
  D2: Single;
begin
  D2 := Self.Center.DistanceSquare(TestBSphere.Center); // VectorDistance2(MainBSphere.Center, TestBSphere.Center);

  if D2 < Sqr(Self.Radius + TestBSphere.Radius) then
  begin
    if D2 < Sqr(Self.Radius - TestBSphere.Radius) then Result := ScContainsFully
    else
      Result := ScContainsPartially;
  end
  else Result := ScNoOverlap;
end;

function TNativeGLZBoundingSphere.Intersect(const TestBSphere: TNativeGLZBoundingSphere): Boolean;
begin
  Result := Self.Center.DistanceSquare(TestBSphere.Center) < Sqr(Self.Radius + TestBSphere.Radius);
end;

{%endregion}

{%region%----[ TNativeGLZAxisAlignedBoundingBox ]-------------------------------}


procedure TNativeGLZAxisAlignedBoundingBox.Create(const AValue: TNativeGLZVector);
begin
  Self.Max := AValue.Abs;
  Self.Min := - Self.Max;

(*  Bb.Max.V[0] := Abs(V.V[0]);
  Bb.Max.V[1] := Abs(V.V[1]);
  Bb.Max.V[2] := Abs(V.V[2]);
  Bb.Min.V[0] := -Bb.Max.V[0];
  Bb.Min.V[1] := -Bb.Max.V[1];
  Bb.Min.V[2] := -Bb.Max.V[2]; *)
end;

{ : Extract the AABB information from a BB. }
procedure TNativeGLZAxisAlignedBoundingBox.Create(const ABB: TNativeGLZBoundingBox);
var
   I: Integer;
 begin
   //SetVector(Result.Min, ABB.BBox[0]);
   Self.Min := ABB.Points[0];
   //SetVector(Self.Max, ABB.Points[0]);
   Self.Max := ABB.Points[0];

   for I := 1 to 7 do
   begin
     if ABB.Points[I].X < Self.Min.X then Self.Min.X := ABB.Points[I].X;
     if ABB.Points[I].X > Self.Max.X then Self.Max.X := ABB.Points[I].X;

     if ABB.Points[I].Y < Self.Min.Y then Self.Min.Y := ABB.Points[I].Y;
     if ABB.Points[I].Y > Self.Max.Y then Self.Max.Y := ABB.Points[I].Y;

     if ABB.Points[I].Z < Self.Min.Z then Self.Min.Z := ABB.Points[I].Z;
     if ABB.Points[I].Z > Self.Max.Z then Self.Max.Z := ABB.Points[I].Z;
   end;
end;

{ : Make the AABB that is formed by sweeping a sphere (or AABB) from Start to Dest }
procedure TNativeGLZAxisAlignedBoundingBox.CreateFromSweep(const Start, Dest: TNativeGLZVector;const Radius: Single);
begin
  if Start.X < Dest.X then
  begin
    Self.Min.X := Start.X - Radius;
    Self.Max.X := Dest.X + Radius;
  end
  else
  begin
    Self.Min.X := Dest.X - Radius;
    Self.Max.X := Start.X + Radius;
  end;

  if Start.Y < Dest.Y then
  begin
    Self.Min.Y := Start.Y - Radius;
    Self.Max.Y := Dest.Y + Radius;
  end
  else
  begin
    Self.Min.Y := Dest.Y - Radius;
    Self.Max.Y := Start.Y + Radius;
  end;

  if Start.Z < Dest.Z then
  begin
    Self.Min.Z := Start.Z - Radius;
    Self.Max.Z := Dest.Z + Radius;
  end
  else
  begin
    Self.Min.Z := Dest.Z - Radius;
    Self.Max.Z := Start.Z + Radius;
  end;
end;

{ : Convert a BSphere to the AABB }
procedure TNativeGLZAxisAlignedBoundingBox.Create(const BSphere: TNativeGLZBoundingSphere); overload;
begin
 Self.Min := BSphere.Center - BSphere.Radius; // VectorSubtract(BSphere.Center, BSphere.Radius);
 Self.Max := BSphere.Center + BSphere.Radius; //VectorAdd(BSphere.Center, BSphere.Radius);
end;

procedure TNativeGLZAxisAlignedBoundingBox.Create(const Center: TNativeGLZVector; Radius: Single); overload;
begin
 Self.Min := Center - Radius; // VectorSubtract(Center, Radius);
 Self.Max := Center + Radius; //VectorAdd(Center, Radius);
end;

class operator TNativeGLZAxisAlignedBoundingBox.+(ConstRef A, B : TNativeGLZAxisAlignedBoundingBox):TNativeGLZAxisAlignedBoundingBox;overload;
begin
  Result := A;

  if B.Min.X < A.Min.X then Result.Min.X := B.Min.X;
  if B.Min.Y < A.Min.Y then Result.Min.Y := B.Min.Y;
  if B.Min.Z < A.Min.Z then Result.Min.Z := B.Min.Z;
  if B.Max.X > A.Max.X then Result.Max.X := B.Max.X;
  if B.Max.Y > A.Max.Y then Result.Max.Y := B.Max.Y;
  if B.Max.Z > A.Max.Z then Result.Max.Z := B.Max.Z;

  (*Result.Min := A.Min;
    Result.Max := A.Max;
    Result.Min := Result.Min.Min(B.Min);
    Result.Max := Result.Max.Max(B.Max);
  *)
end;

class operator TNativeGLZAxisAlignedBoundingBox.+(ConstRef A: TNativeGLZAxisAlignedBoundingBox; ConstRef B : TNativeGLZVector):TNativeGLZAxisAlignedBoundingBox;overload;
begin
  Result.Min := A.Min + B;
  Result.Max := A.Max + B;
end;

class operator TNativeGLZAxisAlignedBoundingBox.*(ConstRef A: TNativeGLZAxisAlignedBoundingBox; ConstRef B : TNativeGLZVector):TNativeGLZAxisAlignedBoundingBox;overload;
begin
  Result.Min := A.Min * B;
  Result.Max := A.Max * B;
end;

class operator TNativeGLZAxisAlignedBoundingBox.=(ConstRef A, B : TNativeGLZAxisAlignedBoundingBox):Boolean;overload;
begin
  result := (A.Min = B.Min) and (A.Max = B.Max);
end;

function TNativeGLZAxisAlignedBoundingBox.Transform(Constref M:TNativeGLZMatrix):TNativeGLZAxisAlignedBoundingBox;
var
  Temp, OldMin, OldMax: TNativeGLZVector;
begin
  OldMin := Self.Min;
  OldMax := Self.Max;
  Result.Min := M * OldMin; //VectorTransform(OldMin, M);
  Result.Max := Self.Min;
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMin.V[0], OldMin.V[1], OldMax.V[2]), M));
  Temp.Create(OldMin.X, OldMin.Y, OldMax.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMin.V[0], OldMax.V[1], OldMin.V[2]), M));
  Temp.Create(OldMin.X, OldMax.Y, OldMin.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMin.V[0], OldMax.V[1], OldMax.V[2]), M));
  Temp.Create(OldMin.X, OldMax.Y, OldMax.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMax.V[0], OldMin.V[1], OldMin.V[2]), M));
  Temp.Create(OldMax.X, OldMin.Y, OldMin.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMax.V[0], OldMin.V[1], OldMax.V[2]), M));
  Temp.Create(OldMax.X, OldMin.Y, OldMax.Z,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(AffineVectorMake(OldMax.V[0], OldMax.V[1], OldMin.V[2]), M));
  Temp.Create(OldMax.X, OldMax.Y, OldMin.Z ,1);
  Temp := M * Temp;
  Result := Result.Include(Temp);
  //AABBInclude(Bb, VectorTransform(OldMax, M));
  Temp := M * OldMax;
  Result := Result.Include(Temp);
end;

function TNativeGLZAxisAlignedBoundingBox.Include(Constref P:TNativeGLZVector):TNativeGLZAxisAlignedBoundingBox;
begin
  Result := Self;
  if P.X < Result.Min.X then Result.Min.X := P.X;
  if P.X > Result.Max.X then Result.Max.X := P.X;
  if P.Y < Result.Min.Y then Result.Min.Y := P.Y;
  if P.Y > Result.Max.Y then Result.Max.Y := P.Y;
  if P.Z < Result.Min.Z then Result.Min.Z := P.Z;
  if P.Z > Result.Max.Z then Result.Max.Z := P.Z;
end;

{ : Returns the intersection of the AABB with second AABBs.
  If the AABBs don't intersect, will return a degenerated AABB (plane, line or point). }
function TNativeGLZAxisAlignedBoundingBox.Intersection(const B: TNativeGLZAxisAlignedBoundingBox): TNativeGLZAxisAlignedBoundingBox;
var
  I: Integer;
begin
  for I := 0 to 2 do
  begin
    Result.Min.V[I] := Math.Max(Self.Min.V[I], B.Min.V[I]);
    Result.Max.V[I] := Math.Min(Self.Max.V[I], B.Max.V[I]);
  end;
end;

{ : Converts the AABB to its canonical BB. }
function TNativeGLZAxisAlignedBoundingBox.ToBoundingBox: TNativeGLZBoundingBox; overload;
begin
  result:=NativeNullBoundingBox;
  with Self do
  begin
    SetPlanBB(Result, 0, Max.X);
    SetPlanBB(Result, 1, Min.X);
    SetPlanBB(Result, 2, Max.Y);
    SetPlanBB(Result, 3, Min.Y);
    SetPlanBB(Result, 4, Max.Z);
    SetPlanBB(Result, 5, Min.Z);
  end;
end;

{ : Transforms the AABB to a BB. }
function TNativeGLZAxisAlignedBoundingBox.ToBoundingBox(const M: TNativeGLZMatrix) : TNativeGLZBoundingBox; overload;
begin
  Result := Self.ToBoundingBox;
  Result := Result.Transform(M);
end;

{ : Convert the AABB to a BSphere }
function TNativeGLZAxisAlignedBoundingBox.ToBoundingSphere: TNativeGLZBoundingSphere;
begin
 Result.Center := (Self.Min + Self.Max) * 0.5;// VectorScale(VectorAdd(AABB.Min, AABB.Max), 0.5);
 Result.Radius := Self.Min.Distance(Self.Max) * 0.5; // VectorDistance(AABB.Min, AABB.Max) * 0.5;
end;

function TNativeGLZAxisAlignedBoundingBox.ToClipRect(ModelViewProjection: TNativeGLZMatrix; ViewportSizeX, ViewportSizeY: Integer): TNativeGLZClipRect;
var
  I: Integer;
  v, Vt: TNativeGLZVector;
  Minmax: array [0 .. 1] of PNativeGLZAffineVector;
begin

  Minmax[0] := @Self.Min;
  Minmax[1] := @Self.Max;
  v.W := 1;
  for I := 0 to 7 do
  begin
    v.X := Minmax[I and 1]^.V[0];
    v.Y := Minmax[(I shr 1) and 1]^.V[1];
    v.Z := Minmax[(I shr 2) and 1]^.V[2];

    // Project
    Vt := ModelViewProjection * v; //VectorTransform(V, ModelViewProjection);
    vt := vt * (1/vt.W); // ScaleVector(Vt, 1 / Vt.V[3]);

    // Convert to screen coordinates
    if I > 0 then
      //IncludeInClipRect(Result, ViewportSizeX * (Vt.V[0] + 1) * 0.5, ViewportSizeY * (Vt.V[1] + 1) * 0.5)
      Result := Result.ExtendClipRect(ViewportSizeX * (Vt.V[0] + 1) * 0.5, ViewportSizeY * (Vt.V[1] + 1) * 0.5)
    else
    begin
      Result.Left := ViewportSizeX * (Vt.X + 1) * 0.5;
      Result.Top := ViewportSizeY * (Vt.Y + 1) * 0.5;
      Result.Right := Result.Left;
      Result.Bottom := Result.Top;
    end;
  end;
end;

{ : Determines if two AxisAlignedBoundingBoxes intersect.
  The matrices are the ones that convert one point to the other's AABB system }
function TNativeGLZAxisAlignedBoundingBox.Intersect(const B: TNativeGLZAxisAlignedBoundingBox;const M1, M2: TNativeGLZMatrix):Boolean;
begin
  result := false;
 (* const
  CWires: array [0 .. 11, 0 .. 1] of Integer // Points of the wire
    = ((0, 1), (1, 2), (2, 3), (3, 0), (4, 5), (5, 6), (6, 7), (7, 4), (0, 4),
    (1, 5), (2, 6), (3, 7));
  CPlanes: array [0 .. 5, 0 .. 3] of Integer // points of the planes
    = ((1, 2, 6, 5), (2, 3, 7, 6), (0, 1, 2, 3), (0, 3, 7, 4), (0, 1, 5, 4),
    (5, 6, 7, 4));

  procedure MakeAABBPoints(const AABB: TGLZAxisAlignedBoundingBox; var Pt: array of TGLZVector);
  begin
    with AABB do
    begin
      Pt[0].Create(Min.X, Min.Y, Min.Z,1);
      Pt[1].Create(Max.X, Min.Y, Min.Z,1);
      Pt[2].Create(Max.X, Max.Y, Min.Z,1);
      Pt[3].Create(Min.X, Max.Y, Min.Z,1);
      Pt[4].Create(Min.X, Min.Y, Max.Z,1);
      Pt[5].Create(Max.X, Min.Y, Max.Z,1);
      Pt[6].Create(Max.X, Max.Y, Max.Z,1);
      Pt[7].Create(Min.X, Max.Y, Max.Z,1);
    end;
  end;

  procedure MakePlanes(const Pt: array of TGLZVector; var Planes: array of TGLZHmgPlane);
  var
    I: Integer;
  begin
    for I := 0 to 5 do
      Planes[I] := PlaneMake(Pt[CPlanes[I, 0]], Pt[CPlanes[I, 1]],Pt[CPlanes[I, 2]]);
  end;

var
  Pt1, Pt2: array [0 .. 7] of TGLZVector;
  Pt: TGLZVector;
  Planes2: array [0 .. 5] of TGLZHmgPlane;
  I, T: Integer;
  V: TGLZVector;
  P: TGLZVector;
begin
  Result := False;

  // Build Points
  MakeAABBPoints(AABB1, Pt1);
  MakeAABBPoints(AABB2, Pt2);
  for I := 0 to 7 do
  begin
    Pt := M2 * Pt2[I]; //VectorTransform(Pt2[I], M2To1);
    // check for inclusion (points of Obj2 in Obj1)
    if IsInRange(Pt.V[0], AABB1.Min.V[0], AABB1.Max.V[0]) and
      IsInRange(Pt.V[1], AABB1.Min.V[1], AABB1.Max.V[1]) and
      IsInRange(Pt.V[2], AABB1.Min.V[2], AABB1.Max.V[2]) then
    begin
      Result := True;
      Exit;
    end;
  end;

  for I := 0 to 7 do
  begin
    Pt1[I] := M2 * Pt1[I]; // VectorTransform(Pt1[I], M1To2);
    // check for inclusion (points of Obj1 in Obj2)
    if IsInRange(Pt1[I].V[0], AABB2.Min.V[0], AABB2.Max.V[0]) and
      IsInRange(Pt1[I].V[1], AABB2.Min.V[1], AABB2.Max.V[1]) and
      IsInRange(Pt1[I].V[2], AABB2.Min.V[2], AABB2.Max.V[2]) then
    begin
      Result := True;
      Exit;
    end;
  end;

  // Build Planes

  MakePlanes(Pt2, Planes2);

  // Wire test
  for I := 0 to 11 do
  begin
    for T := 0 to 5 do
    begin
      // Build Vector of Ray
      V := Pt1[CWires[I, 0]] - Pt1[CWires[I, 1]]; // VectorSubtract(Pt1[CWires[I, 0]], Pt1[CWires[I, 1]]);
      if IntersectLinePlane(VectorMake(Pt1[CWires[I, 0]]), VectorMake(V),
        Planes2[T], @P) = 1 then
      begin
        // check point in Wire
        if IsInRange(P.V[0], Pt1[CWires[I, 0]].V[0],
          Pt1[CWires[I, 1]].V[0]) and
          IsInRange(P.V[1], Pt1[CWires[I, 0]].V[1],
          Pt1[CWires[I, 1]].V[1]) and
          IsInRange(P.V[2], Pt1[CWires[I, 0]].V[2],
          Pt1[CWires[I, 1]].V[2]) then
        begin
          // check point in Plane
          if IsInRange(P.V[0], Pt2[CPlanes[T, 0]].V[0],
            Pt2[CPlanes[T, 2]].V[0]) and
            IsInRange(P.V[1], Pt2[CPlanes[T, 0]].V[1],
            Pt2[CPlanes[T, 2]].V[1]) and
            IsInRange(P.V[2], Pt2[CPlanes[T, 0]].V[2],
            Pt2[CPlanes[T, 2]].V[2]) then
          begin
            Result := True;
            Exit;
          end;
        end;
      end;
    end;
  end;   *)
end;

{ : Checks whether two Bounding boxes aligned with the world axes collide in the XY plane. }
function TNativeGLZAxisAlignedBoundingBox.IntersectAbsoluteXY(const B: TNativeGLZAxisAlignedBoundingBox): Boolean;
begin
 Result := False;

 if (B.Min.X > Self.Max.X) or (B.Min.Y > Self.Max.Y) then Exit
 else if (B.Max.X < Self.Min.X) or (B.Max.Y < Self.Min.Y) then Exit
 else
   Result := True;

end;

{ : Checks whether two Bounding boxes aligned with the world axes collide in the XZ plane. }
function TNativeGLZAxisAlignedBoundingBox.IntersectAbsoluteXZ(const B: TNativeGLZAxisAlignedBoundingBox): Boolean;
begin
 Result := ((Self.Min.X < B.Max.X) and (Self.Min.Z < B.Max.Z) and
            (B.Min.X < Self.Max.X) and (B.Min.Z < Self.Max.Z));
end;

{ : Checks whether two Bounding boxes aligned with the world axes collide. }
function TNativeGLZAxisAlignedBoundingBox.IntersectAbsolute(const B: TNativeGLZAxisAlignedBoundingBox): Boolean;
begin
 Result := not((Self.Min.X > B.Max.X) or (Self.Min.Y > B.Max.Y) or
               (Self.Min.Z > B.Max.Z) or (B.Min.X > Self.Max.X) or
               (B.Min.Y > Self.Max.Y) or (B.Min.Z > Self.Max.Z));
end;

{ : Checks whether one Bounding box aligned with the world axes fits within
  another Bounding box. }
function TNativeGLZAxisAlignedBoundingBox.FitsInAbsolute(const B: TNativeGLZAxisAlignedBoundingBox): Boolean;
begin
 // AABB1 fits completely inside AABB2?
 // AABB1 min must be >= to AABB2 min
 // AABB1 max must be <= to AABB2 max

 Result := (Self.Min.X >= B.Min.X) and (Self.Min.Y >= B.Min.Y) and
           (Self.Min.Z >= B.Min.Z) and (Self.Max.X <= B.Max.X) and
           (Self.Max.Y <= B.Max.Y) and (Self.Max.Z <= B.Max.Z);
end;

{ : Checks if a point "p" is inside the AABB }
function TNativeGLZAxisAlignedBoundingBox.PointIn(const P: TNativeGLZVector): Boolean;
begin
   Result := (P.X <= Self.Max.X) and (P.X >= Self.Min.X) and
             (P.Y <= Self.Max.Y) and (P.Y >= Self.Min.Y) and
             (P.Z <= Self.Max.Z) and (P.Z >= Self.Min.Z);
end;

{ : Extract the corners from the AABB }
function TNativeGLZAxisAlignedBoundingBox.ExtractCorners: TNativeGLZAABBCorners;
begin
  Result[0].Create(Self.Min.X, Self.Min.Y, Self.Min.Z,1);
  Result[1].Create(Self.Min.X, Self.Min.Y, Self.Max.Z,1);
  Result[2].Create(Self.Min.X, Self.Max.Y, Self.Min.Z,1);
  Result[3].Create(Self.Min.X, Self.Max.Y, Self.Max.Z,1);
  Result[4].Create(Self.Max.X, Self.Min.Y, Self.Min.Z,1);
  Result[5].Create(Self.Max.X, Self.Min.Y, Self.Max.Z,1);
  Result[6].Create(Self.Max.X, Self.Max.Y, Self.Min.Z,1);
  Result[7].Create(Self.Max.X, Self.Max.Y, Self.Max.Z,1);
end;

{ : Determines to which extent the AABB contains another AABB }
function TNativeGLZAxisAlignedBoundingBox.Contains(const TestAABB: TNativeGLZAxisAlignedBoundingBox): TGLZSpaceContains; overload;
begin
 // AABB1 fits completely inside AABB2?
  // AABB1 min must be >= to AABB2 min
  // AABB1 max must be <= to AABB2 max

  if ((Self.Min.X < TestAABB.Max.X) and (Self.Min.Y < TestAABB.Max.Y) and
      (Self.Min.Z < TestAABB.Max.Z) and (TestAABB.Min.X < Self.Max.X) and
      (TestAABB.Min.Y < Self.Max.Y) and (TestAABB.Min.Z < Self.Max.Z)) then
  begin
    if (TestAABB.Min.X >= Self.Min.X) and (TestAABB.Min.Y >= Self.Min.Y) and
       (TestAABB.Min.Z >= Self.Min.Z) and (TestAABB.Max.X <= Self.Max.X) and
       (TestAABB.Max.Y <= Self.Max.Y) and (TestAABB.Max.Z <= Self.Max.Z) then
      Result := ScContainsFully
    else
      Result := ScContainsPartially;
  end
  else
    Result := ScNoOverlap;
end;

{ : Determines to which extent the AABB contains a BSphere }
function TNativeGLZAxisAlignedBoundingBox.Contains(const TestBSphere: TNativeGLZBoundingSphere): TGLZSpaceContains; overload;
var
  TestAABB: TNativeGLZAxisAlignedBoundingBox;
begin
  TestAABB.Create(TestBSphere);
  Result := Self.Contains(TestAABB);
end;

{ : Clips a position to the AABB }
function TNativeGLZAxisAlignedBoundingBox.Clip(const V: TNativeGLZAffineVector): TNativeGLZAffineVector;
begin
 Result := V;

 if Result.X < Self.Min.X then Result.X := Self.Min.X;
 if Result.Y < Self.Min.Y then Result.Y := Self.Min.Y;
 if Result.Z < Self.Min.Z then Result.Z := Self.Min.Z;

 if Result.X > Self.Max.X then Result.X := Self.Max.X;
 if Result.Y > Self.Max.Y then Result.Y := Self.Max.Y;
 if Result.Z > Self.Max.Z then Result.Z := Self.Max.Z;
end;

{ : Finds the intersection between a ray and an axis aligned bounding box. }
function TNativeGLZAxisAlignedBoundingBox.RayCastIntersect(const RayOrigin, RayDirection: TNativeGLZVector; out TNear, TFar: Single): Boolean; overload;
const
  Infinity = 1.0 / 0.0;
var
  P: Integer;
  InvDir: Double;
  T0, T1, Tmp: Single;
begin
  Result := False;

  TNear := -Infinity;
  TFar := Infinity;

  for P := 0 to 2 do
  begin
    if (RayDirection.V[P] = 0) then
    begin
      if ((RayOrigin.V[P] < Self.Min.V[P]) or
          (RayOrigin.V[P] > Self.Max.V[P])) then Exit;
    end
    else
    begin
      // T0 := Self.Min.SubAndMul(
      InvDir := 1 / RayDirection.V[P];
      T0 := (Self.Min.V[P] - RayOrigin.V[P]) * InvDir;
      T1 := (Self.Max.V[P] - RayOrigin.V[P]) * InvDir;

      if (T0 > T1) then
      begin
        Tmp := T0;
        T0 := T1;
        T1 := Tmp;
      end;

      if (T0 > TNear) then TNear := T0;
      if (T1 < TFar) then TFar := T1;

      if ((TNear > TFar) or (TFar < 0)) then Exit;
    end;
  end;

  Result := True;
end;

function TNativeGLZAxisAlignedBoundingBox.RayCastIntersect(const RayOrigin, RayDirection: TNativeGLZVector; IntersectPoint: PNativeGLZVector = nil): Boolean; overload;
var
  TNear, TFar: Single;
begin
  Result := RayCastIntersect(RayOrigin, RayDirection, TNear, TFar);

  if Result and Assigned(IntersectPoint) then
  begin
    if TNear >= 0 then
        // origin outside the box
        IntersectPoint^ :=RayOrigin.Combine2(RayDirection, 1, TNear) // VectorCombine(RayOrigin, RayDirection, 1, TNear)
    else
       // origin inside the box, near is "behind", use far
       IntersectPoint^ := RayOrigin.Combine2(RayDirection, 1, TFar); // VectorCombine(RayOrigin, RayDirection, 1, TFar);
  end;
end;

{%endregion}
