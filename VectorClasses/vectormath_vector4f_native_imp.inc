{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

procedure TGLZVector4f.Create(Const aX,aY,aZ: single; const aW : Single = 0);
begin
   Self.X := AX;
   Self.Y := AY;
   Self.Z := AZ;
   Self.W := AW;
end;

procedure TGLZVector4f.Create(Const anAffineVector: TGLZVector3f; const aW : Single = 1); //W=1 because it's a point
begin
   Self.X := anAffineVector.X;
   Self.Y := anAffineVector.Y;
   Self.Z := anAffineVector.Z;
   Self.W := AW;
end;

function TGLZVector4f.ToString : String;
begin
   Result := '(X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,Y: '+FloattoStrF(Self.Y,fffixed,5,5)+
            ' ,Z: '+FloattoStrF(Self.Z,fffixed,5,5)+
            ' ,W: '+FloattoStrF(Self.W,fffixed,5,5)+')';
End;

function TGLZVector4f.Shuffle(const x,y,z,w : Byte):TGLZVector4f;
begin
  Result.X:=Self.V[x];
  Result.Y:=Self.V[y];
  Result.Z:=Self.V[z];
  Result.W:=Self.V[w];
End;

function TGLZVector4f.MinXYZComponent : Single;
begin
   Result:=GLZMath.Min(Self.X, Self.Y, Self.Z);
end;

function TGLZVector4f.MaxXYZComponent : Single;
begin
   Result:=GLZMath.Max(Self.X, Self.Y, Self.Z);
end;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

function TGLZVector4f.Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TGLZVector4f;
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
{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZVector4f.+(constref A, B: TGLZVector4f): TGLZVector4f;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

class operator TGLZVector4f.-(constref A, B: TGLZVector4f): TGLZVector4f;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

class operator TGLZVector4f.*(constref A, B: TGLZVector4f): TGLZVector4f;
begin
  Result.X := A.X * B.X;
  Result.Y := A.Y * B.Y;
  Result.Z := A.Z * B.Z;
  Result.W := A.W * B.W;
end;

class operator TGLZVector4f./(constref A, B: TGLZVector4f): TGLZVector4f;
begin
  Result.X := A.X / B.X;
  Result.Y := A.Y / B.Y;
  Result.Z := A.Z / B.Z;
  Result.W := A.W / B.W;
end;

class operator TGLZVector4f.+(constref A: TGLZVector4f; constref B:Single): TGLZVector4f;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TGLZVector4f.-(constref A: TGLZVector4f; constref B:Single): TGLZVector4f;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TGLZVector4f.*(constref A: TGLZVector4f; constref B:Single): TGLZVector4f;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TGLZVector4f./(constref A: TGLZVector4f; constref B:Single): TGLZVector4f;
begin
  Result.X := A.X / B;
  Result.Y := A.Y / B;
  Result.Z := A.Z / B;
  Result.W := A.W / B;
end;

class operator TGLZVector4f.-(constref A : TGLZVector4f): TGLZVector4f;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

class operator TGLZVector4f.=(constref A, B: TGLZVector4f): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

class operator TGLZVector4f.>=(constref A, B: TGLZVector4f): Boolean;
begin
  Result := (A.X >= B.X) and (A.Y >= B.Y) and (A.Z >= B.Z) and (A.W >= B.W);
end;

class operator TGLZVector4f.<=(constref A, B: TGLZVector4f): Boolean;
begin
  Result := (A.X <= B.X) and (A.Y <= B.Y) and (A.Z <= B.Z) and (A.W <= B.W);
end;

class operator TGLZVector4f.>(constref A, B: TGLZVector4f): Boolean;
begin
  Result := (A.X > B.X) and (A.Y > B.Y) and (A.Z > B.Z) and (A.W > B.W);
end;

class operator TGLZVector4f.<(constref A, B: TGLZVector4f): Boolean;
begin
  Result := (A.X < B.X) and (A.Y < B.Y) and (A.Z < B.Z) and (A.W < B.W);
end;

class operator TGLZVector4f.<>(constref A, B: TGLZVector4f): Boolean;
begin
  Result := (A.X <> B.X) and (A.Y <> B.Y) and (A.Z <> B.Z) and (A.W <> B.W);
end;

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZVector4f.Abs:TGLZVector4f;
begin
  result.X:=System.Abs(Self.X);
  result.Y:=System.Abs(Self.Y);
  result.Z:=System.Abs(Self.Z);
  result.W:=System.Abs(Self.W);
End;

function TGLZVector4f.Negate:TGLZVector4f;
begin
  Result:=Self;
  Result.X := -Result.X;
  Result.Y := -Result.Y;
  Result.Z := -Result.Z;
  Result.W := -Result.W;
end;

function TGLZVector4f.DivideBy2 : TGLZVector4f;
begin
  Result.x := Self.X*0.5;
  Result.y := Self.Y*0.5;
  Result.z := Self.Z*0.5;
  Result.w := Self.W*0.5;
end;

function TGLZVector4f.Distance(constref A: TGLZVector4f):Single;
begin
  result := sqrt(sqr(Self.X-A.X)+ sqr(Self.Y-A.Y) + sqr(Self.Z-A.Z));
end;

function TGLZVector4f.Length : Single;
//var
//X1 : Single;
begin
  Result := Sqrt((Self.X * Self.X) +(Self.Y * Self.Y) +(Self.Z * Self.Z));
  { Ensure result is non-zero to avoid divide-by-zero errors }
  //if X1 = 0 then X1 := 0.0000000001;
  //Result := X1;
end;

function TGLZVector4f.DistanceSquare(constref A: TGLZVector4f):Single;
begin
  result := sqr(Self.X-A.X)+ sqr(Self.Y-A.Y) + sqr(Self.Z-A.Z);
end;

function TGLZVector4f.LengthSquare: Single;
//var
//X1 : Single;
begin
  Result := (Self.X * Self.X) +(Self.Y * Self.Y) +(Self.Z * Self.Z);
  { Ensure result is non-zero to avoid divide-by-zero errors }
  //if X1 = 0 then X1 := 0.0000000001;
  //Result := X1;
end;

function TGLZVector4f.Spacing(constref A : TGLZVector4f) : Single;
//var v : TGLZVector4f;
begin
  Result:=System.Abs(A.X-Self.X)+System.Abs(A.Y-Self.Y)+System.Abs(A.Z-Self.Z)+System.Abs(A.W-Self.W);
end;

function TGLZVector4f.DotProduct(constref A: TGLZVector4f) : Single;
var
 V2:TGLZVector4f;
begin
  V2.X := Self.X*A.X;
  V2.Y := Self.Y*A.Y;
  V2.Z := Self.Z*A.Z;
  //V2.W := Self.W*A.W;
  Result := V2.X + V2.Y + V2.Z;// + V2.W;
end;

function TGLZVector4f.CrossProduct(constref A: TGLZVector4f): TGLZVector4f;
begin
  result.X:=Self.Y*A.Z-Self.Z*A.Y;
  result.Y:=Self.Z*A.X-Self.X*A.Z;
  result.Z:=Self.X*A.Y-Self.Y*A.X;
  result.W:=1;
end;

function TGLZVector4f.Norm : Single;
var v2:TGLZVector4f;
begin
  v2.x := Self.X*Self.X;
  v2.y := Self.Y*Self.Y;
  v2.z := Self.Z*Self.Z;
  v2.w := Self.W*Self.W;
  Result := v2.X + v2.Y + v2.Z; //+ v2.w;
end;

function TGLZVector4f.Normalize : TGLZVector4f;
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

function TGLZVector4f.Min(constref B: Single): TGLZVector4f;
begin
  Result := Self;
  if Self.X>B then Result.X := B;
  if Self.Y>B then Result.Y := B;
  if Self.Z>B then Result.Z := B;
  if Self.W>B then Result.W := B;
End;

function TGLZVector4f.Min(constref B: TGLZVector4f): TGLZVector4f;
begin
  Result := Self;
  if Self.X>B.X then Result.X := B.X;
  if Self.Y>B.Y then Result.Y := B.Y;
  if Self.Z>B.Z then Result.Z := B.Z;
  if Self.W>B.W then Result.W := B.W;
End;

function TGLZVector4f.Max(constref B: TGLZVector4f): TGLZVector4f;
begin
  Result := Self;
  if Self.X<B.X then Result.X := B.X;
  if Self.Y<B.Y then Result.Y := B.Y;
  if Self.Z<B.Z then Result.Z := B.Z;
  if Self.W<B.W then Result.W := B.W;
End;

function TGLZVector4f.Max(constref B: Single): TGLZVector4f;
begin
  Result := Self;
  if Self.X<B then Result.X := B;
  if Self.Y<B then Result.Y := B;
  if Self.Z<B then Result.Z := B;
  if Self.W<B then Result.W := B;
End;

function TGLZVector4f.Clamp(Constref AMin, AMax: TGLZVector4f): TGLZVector4f;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
End;

function TGLZVector4f.Clamp(constref AMin, AMax: Single): TGLZVector4f;
begin
  Result := Self.Max(AMin);
  Result := Result.Min(AMax);
End;

function TGLZVector4f.MulAdd(Constref B, C: TGLZVector4f): TGLZVector4f;
begin
  result := (self*B)+C;
end;

function TGLZVector4f.MulDiv(Constref B, C: TGLZVector4f): TGLZVector4f;
begin
  result := (self*B)/C;
end;

function TGLZVector4f.Lerp(Constref B: TGLZVector4f; Constref T:Single): TGLZVector4f;
begin
   Result.X:=Self.X+(B.X-Self.X)*t;
   Result.Y:=Self.Y+(B.Y-Self.Y)*t;
   Result.Z:=Self.Z+(B.Z-Self.Z)*t;
   Result.W := Self.W;
end;

function TGLZVector4f.AngleCosine(constref A: TGLZVector4f): Single;
begin
   Result:=Self.DotProduct(A)/(Self.Length*A.Length);
end;

function TGLZVector4f.AngleBetween(Constref A, ACenterPoint : TGLZVector4f): Single;
Var
  vt1,vt2  :  TGLZVector4f;
begin
  vt1 := Self - ACenterPoint;
  vt2 := A - ACenterPoint;
  vt1 := vt1.Normalize;
  vt2 := vt2.Normalize;
  Result := ArcCos(vt1.AngleCosine(vt2));
end;

function TGLZVector4f.Combine(constref V2: TGLZVector4f; constref F1: Single): TGLZVector4f;
begin
  Result.X:=Self.X+v2.X*F1;
  Result.Y:=Self.Y+v2.Y*F1;
  Result.Z:=Self.Z+v2.Z*F1;
//  Result.W:=Self.W+v2.W*F1;
  Result.W:=0;
End;

function TGLZVector4f.Combine2(constref V2: TGLZVector4f; const F1, F2: Single): TGLZVector4f;
begin
   Result.X:=( Self.X*F1) + (V2.X*F2);
   Result.Y:=( Self.Y*F1) + (V2.Y*F2);
   Result.Z:=( Self.Z*F1) + (V2.Z*F2);
   Result.W:=0;
end;

function TGLZVector4f.Combine3(constref V2, V3: TGLZVector4f; const F1, F2, F3: Single): TGLZVector4f;
begin
  Result.X:=( Self.X*F1) + (V2.X*F2) + (V3.X*F3);
  Result.Y:=( Self.Y*F1) + (V2.Y*F2) + (V3.Y*F3);
  Result.Z:=( Self.Z*F1) + (V2.Z*F2) + (V3.Z*F3);
  Result.W:=0;
end;

function TGLZVector4f.Perpendicular(constref N : TGLZVector4f) : TGLZVector4f;
var
   dot : Single;
begin
   dot:=Self.DotProduct(N);
   Result.X:=Self.X-Dot * Self.X;
   Result.Y:=Self.Y-Dot * Self.Y;
   Result.Z:=Self.Z-Dot * Self.Z;
   Result.W:=0;
end;

function TGLZVector4f.Reflect(constref N: TGLZVector4f): TGLZVector4f;
begin
  //  Result:=Self.Combine(Self, N, 1, -2*VectorDotProduct(Self, N));
  Result := Self - (N*(2 * N.Dotproduct(Self)));
 // Result.W:=0;
end;

function TGLZVector4f.Round:TGLZVector4i;
begin
  result.X:=System.Round(Self.X);
  result.Y:=System.Round(Self.Y);
  result.Z:=System.Round(Self.Z);
  result.W:=System.Round(Self.W);
end;

function TGLZVector4f.Trunc:TGLZVector4i;
begin
  result.X:=System.Trunc(Self.X);
  result.Y:=System.Trunc(Self.Y);
  result.Z:=System.Trunc(Self.Z);
  result.W:=System.Trunc(Self.W);
end;

{%endregion%}

{%region%----[ Operations on Self ]---------------------------------------------}

procedure TGLZVector4f.pAdd(constref A: TGLZVector4f);
begin
  Self.X := Self.X + A.X;
  Self.Y := Self.Y + A.Y;
  Self.Z := Self.Z + A.Z;
  Self.W := Self.W + A.W;
end;

procedure TGLZVector4f.pSub(constref A: TGLZVector4f);
begin
  Self.X := Self.X - A.X;
  Self.Y := Self.Y - A.Y;
  Self.Z := Self.Z - A.Z;
  Self.W := Self.W - A.W;
end;

procedure TGLZVector4f.pMul(constref A: TGLZVector4f);
begin
  Self.X := Self.X * A.X;
  Self.Y := Self.Y * A.Y;
  Self.Z := Self.Z * A.Z;
  Self.W := Self.W * A.W;
end;

procedure TGLZVector4f.pDiv(constref A: TGLZVector4f);
begin
  Self.X := Self.X / A.X;
  Self.Y := Self.Y / A.Y;
  Self.Z := Self.Z / A.Z;
  Self.W := Self.W / A.W;
end;

procedure TGLZVector4f.pAdd(constref A: Single);
begin
  Self.X := Self.X + A;
  Self.Y := Self.Y + A;
  Self.Z := Self.Z + A;
  Self.W := Self.W + A;
end;

procedure TGLZVector4f.pSub(constref A: Single);
begin
  Self.X := Self.X - A;
  Self.Y := Self.Y - A;
  Self.Z := Self.Z - A;
  Self.W := Self.W - A;
end;

procedure TGLZVector4f.pMul(constref A: Single);
begin
  Self.X := Self.X * A;
  Self.Y := Self.Y * A;
  Self.Z := Self.Z * A;
  Self.W := Self.W * A;
end;

procedure TGLZVector4f.pDiv(constref A: Single);
begin
  Self.X := Self.X / A;
  Self.Y := Self.Y / A;
  Self.Z := Self.Z / A;
  Self.W := Self.W / A;
end;

procedure TGLZVector4f.pInvert;
begin
  Self.X := -Self.X;
  Self.Y := -Self.Y;
  Self.Z := -Self.Z;
  Self.W := -Self.W;
end;

procedure TGLZVector4f.pNegate;
begin
  Self.X := -Self.X;
  Self.Y := -Self.Y;
  Self.Z := -Self.Z;
  Self.W := -Self.W;
end;

procedure TGLZVector4f.pAbs;
begin
  Self.X:=System.Abs(Self.X);
  Self.Y:=System.Abs(Self.Y);
  Self.Z:=System.Abs(Self.Z);
  Self.W:=System.Abs(Self.W);
End;

procedure TGLZVector4f.pDivideBy2;
begin
  Self.x := Self.X*0.5;
  Self.y := Self.Y*0.5;
  Self.z := Self.Z*0.5;
  Self.w := Self.W*0.5;
end;

procedure TGLZVector4f.pCrossProduct(constref A: TGLZVector4f);
Var
 Tmp : TGLZVector4f;
begin
  Tmp.X:=Self.Y*A.Z-Self.Z*A.Y;
  Tmp.Y:=Self.Z*A.X-Self.X*A.Z;
  Tmp.Z:=Self.X*A.Y-Self.Y*A.X;
  Tmp.W:=1;
  Self := Tmp;
end;

procedure TGLZVector4f.pNormalize;
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

procedure TGLZVector4f.pMin(constref B: TGLZVector4f);
begin
  if Self.X>B.X then Self.X := B.X;
  if Self.Y>B.Y then Self.Y := B.Y;
  if Self.Z>B.Z then Self.Z := B.Z;
  if Self.W>B.W then Self.W := B.W;
End;

procedure TGLZVector4f.pMin(constref B: Single);
begin
  if Self.X>B then Self.X := B;
  if Self.Y>B then Self.Y := B;
  if Self.Z>B then Self.Z := B;
  if Self.W>B then Self.W := B;
End;

procedure TGLZVector4f.pMax(constref B: TGLZVector4f);
begin
  if Self.X<B.X then Self.X := B.X;
  if Self.Y<B.Y then Self.Y := B.Y;
  if Self.Z<B.Z then Self.Z := B.Z;
  if Self.W<B.W then Self.W := B.W;
End;

procedure TGLZVector4f.pMax(constref B: Single);
begin
  if Self.X<B then Self.X := B;
  if Self.Y<B then Self.Y := B;
  if Self.Z<B then Self.Z := B;
  if Self.W<B then Self.W := B;
End;

procedure TGLZVector4f.pClamp(Constref AMin, AMax: TGLZVector4f);
begin
  Self.pMax(AMin);
  Self.pMin(AMax);
End;

procedure TGLZVector4f.pClamp(constref AMin, AMax: Single);
begin
  Self.pMax(AMin);
  Self.pMin(AMax);
End;

procedure TGLZVector4f.pMulAdd(Constref B, C: TGLZVector4f); // (Self*B)+c
begin
  Self := (self*B)+C;
end;

procedure TGLZVector4f.pMulDiv(Constref B, C: TGLZVector4f); // (Self*B)-c
begin
  Self := (self*B)/C;
end;

{%endregion%}

{%endregion%}

{$ENDIF}
