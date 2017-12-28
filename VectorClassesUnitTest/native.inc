{%region%-----[ TNativeGLZVector2f ]------------------------------------------------}

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

{%region%----[ Functions ]--------------------------------------------------------}

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
 Result := Self * (1/Self.LengthSquare);
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

{%endregion%}

{%region%-----[ TNativeGLZVector4f ]------------------------------------------------}

procedure TNativeGLZVector4f.Create(const aX, aY, aZ: single; const aW: Single);
begin
   Self.X := AX;
   Self.Y := AY;
   Self.Z := AZ;
   Self.W := AW;
end;

procedure TNativeGLZVector4f.Create(const anAffineVector: TGLZVector3f; const aW: Single);
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
  Result.V[x]:=Self.X;
  Result.V[y]:=Self.Y;
  Result.V[z]:=Self.Z;
  Result.V[w]:=Self.W;
End;

function TNativeGLZVector4f.MinXYZComponent : Single;
begin
   Result:=Min3s(Self.X, Self.Y, Self.Z);
end;

function TNativeGLZVector4f.MaxXYZComponent : Single;
begin
   Result:=Max3s(Self.X, Self.Y, Self.Z);
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
  Result := (A.X <> B.X) and (A.Y <> B.Y) and (A.Z <> B.Z) and (A.W <> B.W);
end;

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
    result.W := 0; //cZero;
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

function TNativeGLZVector4f.Perpendicular(constref N : TNativeGLZVector4f) : TNativeGLZVector4f;
var
   dot : Single;
begin
   dot:=Self.DotProduct(N);
   Result.X:=Self.X-Dot * Self.X;
   Result.Y:=Self.Y-Dot * Self.Y;
   Result.Z:=Self.Z-Dot * Self.Z;
   Result.W:=0;
end;

function TNativeGLZVector4f.Reflect(constref N: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  //  Result:=Self.Combine(Self, N, 1, -2*VectorDotProduct(Self, N));
  Result := Self - (N*(2 * N.Dotproduct(Self)));
 // Result.W:=0;
end;

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
    Self.W := 0; //cZero;
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
  Self.Max(AMin);
  Self.Min(AMax);
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

{%region%-----[ TNativeGLZMatrix4 ]-------------------------------------------------}

function TNativeGLZMatrix4.GetComponent(const ARow, AColumn: Integer): Single;
begin
  Result := M[ARow, AColumn];
end;

procedure TNativeGLZMatrix4.SetComponent(const ARow, AColumn: Integer; const Value: Single);
begin
  M[ARow, AColumn] := Value;
end;

procedure TNativeGLZMatrix4.SetRow(const AIndex: Integer; const Value: TNativeGLZVector4f);
begin
  V[AIndex] := Value;
end;

function TNativeGLZMatrix4.GetRow(const AIndex: Integer): TNativeGLZVector4f;
begin
  Result := V[AIndex];
end;

function TNativeGLZMatrix4.ToString : String;
begin
  Result :='|'+V[0].ToString+'|'+#13+#10
          +'|'+V[1].ToString+'|'+#13+#10
          +'|'+V[2].ToString+'|'+#13+#10
          +'|'+V[3].ToString+'|'+#13+#10
End;

class operator TNativeGLZMatrix4.+(constref A, B: TNativeGLZMatrix4): TNativeGLZMatrix4;
begin
  Result.V[0] := A.V[0] + B.V[0];
  Result.V[1] := A.V[1] + B.V[1];
  Result.V[2] := A.V[2] + B.V[2];
  Result.V[3] := A.V[3] + B.V[3];
end;

class operator TNativeGLZMatrix4.+(constref A: TNativeGLZMatrix4; constref B: Single): TNativeGLZMatrix4;
begin
  Result.V[0] := A.V[0] + B;
  Result.V[1] := A.V[1] + B;
  Result.V[2] := A.V[2] + B;
  Result.V[3] := A.V[3] + B;
end;

class operator TNativeGLZMatrix4.-(constref A, B: TNativeGLZMatrix4): TNativeGLZMatrix4;
begin
  Result.V[0] := A.V[0] - B.V[0];
  Result.V[1] := A.V[1] - B.V[1];
  Result.V[2] := A.V[2] - B.V[2];
  Result.V[3] := A.V[3] - B.V[3];
end;

class operator TNativeGLZMatrix4.-(constref A: TNativeGLZMatrix4; constref B: Single): TNativeGLZMatrix4;
begin
  Result.V[0] := A.V[0] - B;
  Result.V[1] := A.V[1] - B;
  Result.V[2] := A.V[2] - B;
  Result.V[3] := A.V[3] - B;
end;

class operator TNativeGLZMatrix4.-(constref A: TNativeGLZMatrix4): TNativeGLZMatrix4;
begin
  Result.V[0] := -A.V[0];
  Result.V[1] := -A.V[1];
  Result.V[2] := -A.V[2];
  Result.V[3] := -A.V[3];
end;

class operator TNativeGLZMatrix4.*(constref A: TNativeGLZMatrix4; constref B: TNativeGLZVector4f): TNativeGLZVector4f;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[0,1]) + (B.Z * A.M[0,2]) + (B.W * A.M[0,3]);
  Result.Y := (B.X * A.M[1,0]) + (B.Y * A.M[1,1]) + (B.Z * A.M[1,2]) + (B.W * A.M[1,3]);
  Result.Z := (B.X * A.M[2,0]) + (B.Y * A.M[2,1]) + (B.Z * A.M[2,2]) + (B.W * A.M[2,3]);
  Result.W := (B.X * A.M[3,0]) + (B.Y * A.M[3,1]) + (B.Z * A.M[3,2]) + (B.W * A.M[3,3]);
end;

class operator TNativeGLZMatrix4.*(constref A, B: TNativeGLZMatrix4): TNativeGLZMatrix4;
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

class operator TNativeGLZMatrix4.*(constref A: TNativeGLZMatrix4; constref B: Single): TNativeGLZMatrix4;
begin
  Result.V[0] := A.V[0] * B;
  Result.V[1] := A.V[1] * B;
  Result.V[2] := A.V[2] * B;
  Result.V[3] := A.V[3] * B;
end;

class operator TNativeGLZMatrix4./(constref A: TNativeGLZMatrix4; constref B: Single): TNativeGLZMatrix4;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.V[0] := A.V[0] * InvB;
  Result.V[1] := A.V[1] * InvB;
  Result.V[2] := A.V[2] * InvB;
  Result.V[3] := A.V[3] * InvB;
end;

procedure TNativeGLZMatrix4.CreateIdentityMatrix;
begin
  Self:=NativeIdentityHmgMatrix;
End;

procedure TNativeGLZMatrix4.CreateScaleMatrix(const v : TGLZAffineVector);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TNativeGLZMatrix4.CreateScaleMatrix(const v : TNativeGLZVector4f);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TNativeGLZMatrix4.CreateTranslationMatrix(const V: TGLZAffineVector);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.W.X:=V.X;
   Self.W.Y:=V.Y;
   Self.W.Z:=V.Z;
end;

procedure TNativeGLZMatrix4.CreateTranslationMatrix(const V: TNativeGLZVector4f);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.W.X:=V.X;
   Self.W.Y:=V.Y;
   Self.W.Z:=V.Z;
end;

procedure TNativeGLZMatrix4.CreateScaleAndTranslationMatrix(const ascale, offset : TNativeGLZVector4f);
begin
   Self:=NativeIdentityHmgMatrix;
   Self.X.X:=ascale.X;   Self.W.X:=offset.X;
   Self.Y.Y:=ascale.Y;   Self.W.Y:=offset.Y;
   Self.Z.Z:=ascale.Z;   Self.W.Z:=offset.Z;
end;

procedure TNativeGLZMatrix4.CreateRotationMatrixX(const sine, cosine: Single);
begin
   Self:=NativeEmptyHmgMatrix;
   Self.X.X:=1;
   Self.Y.Y:=cosine;
   Self.Y.Z:=sine;
   Self.Z.Y:=-sine;
   Self.Z.Z:=cosine;
   Self.W.W:=1;
end;

procedure TNativeGLZMatrix4.CreateRotationMatrixX(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixX(s, c);
end;

procedure TNativeGLZMatrix4.CreateRotationMatrixY(const sine, cosine: Single);
begin
   Self:=NativeEmptyHmgMatrix;
   Self.X.X:=cosine;
   Self.X.Z:=-sine;
   Self.Y.Y:=1;
   Self.Z.X:=sine;
   Self.Z.Z:=cosine;
   Self.W.W:=1;
end;

procedure TNativeGLZMatrix4.CreateRotationMatrixY(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixY(s, c);
end;

procedure TNativeGLZMatrix4.CreateRotationMatrixZ(const sine, cosine: Single);
begin
   Self:=NativeEmptyHmgMatrix;
   Self.X.X:=cosine;
   Self.X.Y:=sine;
   Self.Y.X:=-sine;
   Self.Y.Y:=cosine;
   Self.Z.Z:=1;
   Self.W.W:=1;
end;

procedure TNativeGLZMatrix4.CreateRotationMatrixZ(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixZ(s, c);
end;

procedure TNativeGLZMatrix4.CreateRotationMatrix(const anAxis : TGLZAffineVector; angle : Single);
var
   axis : TGLZVector;
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

procedure TNativeGLZMatrix4.CreateRotationMatrix(const anAxis : TNativeGLZVector4f; angle : Single);
begin
   CreateRotationMatrix(anAxis.AsVector3f, angle);
end;

function TNativeGLZMatrix4.Invert:TNativeGLZMatrix4;
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

function TNativeGLZMatrix4.MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
// internal version for the determinant of a 3x3 matrix
begin
  Result:=  a1 * (b2 * c3 - b3 * c2)
          - b1 * (a2 * c3 - a3 * c2)
          + c1 * (a2 * b3 - a3 * b2);
end;

function TNativeGLZMatrix4.GetDeterminant: Single;
begin
  Result:= Self.V[0].X*MatrixDetInternal(Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z, Self.V[1].W, Self.V[2].W, Self.V[3].W)
        -Self.V[0].Y*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z, Self.V[1].W, Self.V[2].W, Self.V[3].W)
        +Self.V[0].Z*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].W, Self.V[2].W, Self.V[3].W)
        -Self.V[0].W*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].Z, Self.V[3].Z, Self.V[3].Z);
end;

(* function TMatrix4.GetDeterminant: Single;
var
  F00, F01, F02, F03, F04, F05: Single;
  C: TVector4;
begin
  F00 := (M[2,2] * M[3,3]) - (M[3,2] * M[2,3]);
  F01 := (M[2,1] * M[3,3]) - (M[3,1] * M[2,3]);
  F02 := (M[2,1] * M[3,2]) - (M[3,1] * M[2,2]);
  F03 := (M[2,0] * M[3,3]) - (M[3,0] * M[2,3]);
  F04 := (M[2,0] * M[3,2]) - (M[3,0] * M[2,2]);
  F05 := (M[2,0] * M[3,1]) - (M[3,0] * M[2,1]);

  C.X := + ((M[1,1] * F00) - (M[1,2] * F01) + (M[1,3] * F02));
  C.Y := - ((M[1,0] * F00) - (M[1,2] * F03) + (M[1,3] * F04));
  C.Z := + ((M[1,0] * F01) - (M[1,1] * F03) + (M[1,3] * F05));
  C.W := - ((M[1,0] * F02) - (M[1,1] * F04) + (M[1,2] * F05));

  Result := (M[0,0] * C.X) + (M[0,1] * C.Y) + (M[0,2] * C.Z) + (M[0,3] * C.W);
end; *)

procedure TNativeGLZMatrix4.Adjoint;
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

function TNativeGLZMatrix4.Translate(constref v : TNativeGLZVector4f):TNativeGLZMatrix4;
begin
   Result := Self;
   Result.W.X:=Self.W.X+v.X;
   Result.W.Y:=Self.W.Y+v.Y;
   Result.W.Z:=Self.W.Z+v.Z;
end;

function TNativeGLZMatrix4.Multiply(constref M2 : TNativeGLZMatrix4): TNativeGLZMatrix4;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.V[I] := Self.V[I] * M2.V[I];
end;

function TNativeGLZMatrix4.Normalize: TNativeGLZMatrix4;
begin
   Result.X.W:=0;
   Result.X.Normalize;
   Result.Y.W:=0;
   Result.Y.Normalize;
   Result.Z:=Result.X.CrossProduct(Result.Y);
   Result.X:=Result.Y.CrossProduct(Result.Z);
   Result.W:=NativeWHmgVector;
end;

procedure TNativeGLZMatrix4.Transpose_Scale_M33(constref src : TNativeGLZMatrix4; Constref ascale : Single);
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

function TNativeGLZMatrix4.Transpose: TNativeGLZMatrix4;
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

procedure TNativeGLZMatrix4.AnglePreservingMatrixInvert(constref mat : TNativeGLZMatrix4);
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

function TNativeGLZMatrix4.Decompose(var Tran: TGLZMatrixTransformations): Boolean;
var
   I, J: Integer;
   LocMat, pmat, invpmat : TNativeGLZMatrix4;
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
  Row0 := Row0 * RSqrt(Tran[ttScaleX]); //VectorScale(row0, RSqrt(Tran[ttScaleX]));

  // compute XY shear factor and make 2nd row orthogonal to 1st
  Tran[ttShearXY]:=row0.DotProduct(row1);
  f:=-Tran[ttShearXY];
  Row1.Combine(row0, f);

  // now, compute Y scale and normalize 2nd row
  Tran[ttScaleY]:=Row1.Norm;
  Row1 := Row1 * RSqrt(Tran[ttScaleY]); //VectorScale(row1, RSqrt(Tran[ttScaleY]));
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
  Row2:=row2* RSqrt(Tran[ttScaleZ]);
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
  Tran[ttRotateY]:=GLZMath.ArcSine(-row0.Z);
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

procedure TNativeGLZMatrix4.CreateLookAtMatrix(const eye, center, normUp: TNativeGLZVector4f);
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

procedure TNativeGLZMatrix4.CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);
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

procedure TNativeGLZMatrix4.CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);
var
  xx, yy: Single;
begin
  FOV := Min2s(179.9, Max2s(0, FOV));
  yy:= ZNear * GLZMath.Tan(GLZMath.DegToRadian(FOV) * 0.5);
  xx:= yy * Aspect;
  CreateMatrixFromFrustum(-xx, xx, -yy, yy, ZNear, ZFar);
end;

procedure TNativeGLZMatrix4.CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);
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

procedure TNativeGLZMatrix4.CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i);
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

procedure TNativeGLZMatrix4.CreateParallelProjectionMatrix(const plane : TGLZHmgPlane;const dir : TNativeGLZVector4f);
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

procedure TNativeGLZMatrix4.CreateShadowMatrix(const planePoint, planeNormal, lightPos : TNativeGLZVector4f);
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

procedure TNativeGLZMatrix4.CreateReflectionMatrix(const planePoint, planeNormal : TNativeGLZVector4f);
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

{%region%-----[ TNativeGLZQuaternion ]----------------------------------------------}

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

procedure TNativeGLZQuaternion.Create(const V1, V2: TGLZAffineVector);
Var
 //av : TGLZAffineVector;
 vv, vv1,vv2 : TGLZVector;
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

procedure TNativeGLZQuaternion.Create(const angle  : Single; const axis : TGLZAffineVector);
//procedure TNativeGLZQuaternion.Create(const angle  : Single; const axis : TGLZVector);
var
   f, s, c : Single;
   vaxis : TGLZVector;
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
   Self.Create(r, ZVector); // Create From Angle Axis
   qp.Create(p, XVector);
   qy.Create(y, YVector);

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
      q[cOrder[eulerOrder][1]].Create(X, XVector); // Create From Angle Axis
      q[cOrder[eulerOrder][2]].Create(Y, YVector);
      q[cOrder[eulerOrder][3]].Create(Z, ZVector);
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

procedure TNativeGLZQuaternion.ConvertToPoints(var ArcFrom, ArcTo: TGLZAffineVector);
//procedure ConvertToPoints(var ArcFrom, ArcTo: TGLZVector); //overload;
var
   s, invS : Single;
begin
   s:=Self.ImagePart.X*Self.ImagePart.X+Self.ImagePart.Y*Self.ImagePart.Y;
   if s=0 then ArcFrom := AffineVectorMake( 0, 1, 0)
   else
   begin
      invS:=RSqrt(s);
      ArcFrom := AffineVectorMake( -Self.ImagePart.Y*invS, Self.ImagePart.X*invS, 0);
   end;
   ArcTo.X:=Self.RealPart*ArcFrom.X-Self.ImagePart.Z*ArcFrom.Y;
   ArcTo.Y:=Self.RealPart*ArcFrom.Y+Self.ImagePart.Z*ArcFrom.X;
   ArcTo.Z:=Self.ImagePart.X*ArcFrom.Y-Self.ImagePart.Y*ArcFrom.X;
   if Self.RealPart<0 then ArcFrom := AffineVectorMake( -ArcFrom.X, -ArcFrom.Y, 0);
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

{%region%----[ TNativeGLZHmgPlane Helper ]------------------------------------------}

{ TODO 1 -oASM -cTHmgPlane : Create(point, normal) Add ASM Version }
procedure TNativeGLZVectorHelper.CreatePlane(constref point, normal : TNativeGLZVector);
begin
   Self:=normal;
   Self.W:=-Point.DotProduct(normal);
end;

{ TODO 1 -oASM -cTHmgPlane : CalcPlaneNormal(p1, p2, p3)  Add ASM Version }
procedure TNativeGLZVectorHelper.CalcPlaneNormal(constref p1, p2, p3 : TNativeGLZVector);
var
   v1, v2 : TNativeGLZVector;
begin
   v1:=p2-p1;
   v2:=p3-p1;
   Self:=v1.CrossProduct(v2);
   Self:=Self.Normalize;
end;

procedure TNativeGLZVectorHelper.CreatePlane(constref p1, p2, p3 : TNativeGLZVector);
begin
  CalcPlaneNormal(p1, p2, p3);
  Self.W:=-p1.DotProduct(Self);
end;

function TNativeGLZVectorHelper.DistancePlaneToPoint(constref point : TNativeGLZVector) : Single;
begin
   result:= System.abs( (Self.X*Point.X) + (Self.Y*Point.Y) + (Self.Z*Point.Z) + Self.W );
end;

function TNativeGLZVectorHelper.DistancePlaneToSphere(constref Center : TNativeGLZVector; constref Radius:Single) : Single;
var dist : single;
begin
  dist := DistancePlaneToPoint(Center);
  result := 0.0;
  if(dist > Radius) then result := dist - radius
end;

function TNativeGLZVectorHelper.NormalizePlane:TNativeGLZHmgPlane;
var
   n : Single;
begin
   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
   Result :=Self * n;
end;

{%endregion%}

{%region%----[ TNativeGLZVectorHelper ]---------------------------------------------}

function TNativeGLZVectorHelper.Rotate(constref axis : TNativeGLZVector; angle : Single):TNativeGLZVector;
var
   rotMatrix : TNativeGLZMatrix;
begin
   rotMatrix.CreateRotationMatrix(axis, Angle);
   Result:=rotMatrix*Self;
end;

function TNativeGLZVectorHelper.RotateAroundX( alpha : Single) : TNativeGLZVector;
var
   c, s : Single;
begin
   SinCos(alpha, s, c);
   Result.X:=Self.X;
   Result.Y:=c*Self.Y+s*Self.Z;
   Result.Z:=c*Self.Z-s*Self.Y;
end;

function TNativeGLZVectorHelper.RotateAroundY(alpha : Single) : TNativeGLZVector;
var
   c, s : Single;
begin
   SinCos(alpha, s, c);
   Result.Y:=Self.Y;
   Result.X:=c*Self.X+s*Self.Z;
   Result.Z:=c*Self.Z-s*Self.X;
end;

function TNativeGLZVectorHelper.RotateAroundZ(alpha : Single) : TNativeGLZVector;
var
   c, s : Single;
begin
   SinCos(alpha, s, c);
   Result.X:=c*Self.X+s*Self.Y;
   Result.Y:=c*Self.Y-s*Self.X;
   Result.Z:=Self.Z;
end;

{ TODO 1 -oASM -cVectorHelper : IsColinear(v2) Add ASM version }
function TNativeGLZVectorHelper.IsColinear(constref v2: TNativeGLZVector) : Boolean;
var
  a, b, c : Single;
begin
  a := Self.DotProduct(Self);
  b := Self.DotProduct(v2);
  c := v2.DotProduct(v2);
  Result :=  (a*c - b*b) < cColinearBias;
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
    pitchNow := GLZUtils.Clamp(pitchNow + DegToRadian(pitchDelta), 0 + 0.025, cPI - 0.025);
    // create a new vector pointing up and then rotate it down
    // into the new position
    normalT2C := AMovingObjectUp;
    normalT2C := normalT2C.Rotate(normalCameraRight, -pitchNow);
    normalT2C := normalT2C.Rotate(AMovingObjectUp, -DegToRadian(turnDelta));
    normalT2C := normalT2C * dist;
    Result := Self + (normalT2C - originalT2C);
end;

function TNativeGLZVectorHelper.PointProject(constref origin, direction : TNativeGLZVector) : Single;
begin
   Result:= direction.X*(Self.X-origin.X)
           +direction.Y*(Self.Y-origin.Y)
           +direction.Z*(Self.Z-origin.Z);
end;

function TNativeGLZVectorHelper.ShiftObjectFromCenter(constref ACenter: TNativeGLZVector; const ADistance: Single;const AFromCenterSpot: Boolean):TNativeGLZVector;
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


{%endregion%}

{%region%----[ TNativeGLZMatrixHelper ]---------------------------------------------}

// Turn (Y axis)
function TNativeGLZMatrixHelper.Turn( Angle: Single): TNativeGLZMatrix;
var
  m : TNativeGLZMatrix;
begin
  m.CreateRotationMatrix(AffineVectorMake(Self.V[1].V[0], Self.V[1].V[1], Self.V[1].V[2]), Angle);
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
  m.CreateRotationMatrix(AffineVectorMake(Self.V[0].V[0], Self.V[0].V[1], Self.V[0].V[2]), Angle);
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
  m.CreateRotationMatrix(AffineVectorMake(Self.V[2].V[0], Self.V[2].V[1], Self.V[2].V[2]), Angle);
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




