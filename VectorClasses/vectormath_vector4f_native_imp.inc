{%region%----[ Operators ]--------------------------------------------------------}

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

{%region%----[ Functions ]--------------------------------------------------------}

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

function TGLZVector4f.CrossProduct(Constref A : TGLZVector4f):TGLZVector4f;
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
  vt1.pNormalize;
  vt2.pNormalize;
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

{%endregion%}

{%region%----[ Operations on Self ]-----------------------------------------------}

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

procedure TGLZVector4f.pCrossProduct(Constref A : TGLZVector4f);
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

{function GetNormFromCutPlane(cen, up, left, down, right: TGLZVector4f): TGLZVector4f;
//  s,t,u,v: xmm2,xmm3, xmm4, xmm5
asm
  movaps xmm2, [Cent] //s
  movaps xmm3, xmm2   //t
  movaps xmm4, xmm2   //u
  movaps xmm5, xmm2   //v

  //VectorSubtract(up^,cen^,s{%H-});
  movaps xmm1, [up]
  subps xmm2, xmm1
  //VectorSubtract(left^,cen^,t{%H-});
  movaps xmm1, [left]
  subps xmm3, xmm1
  //VectorSubtract(down^,cen^,u{%H-});
  movaps xmm1, [down]
  subps xmm4, xmm1
  //VectorSubtract(right^,cen^,v{%H-});
  movaps xmm1, [right]
  subps xmm5, xmm1

  andps xmm2, [RIP+cSSE_MASK_NO_W]
  andps xmm3, [RIP+cSSE_MASK_NO_W]
  andps xmm4, [RIP+cSSE_MASK_NO_W]
  andps xmm5, [RIP+cSSE_MASK_NO_W]

  //------------------------------------
  // X := s.Y*t.Z,
  // Y := s.Z*t.X,
  // Z := s.X*t.Y
  // S =   w,z,y,x
  // T = * -,x,z,y
  shufps xmm6, xmm3, 11001001b
  mulps xmm6,xmm2

  // X := s.Z*t.Y
  // Y := s.X*t.Z
  // Z := s.Y*t.X
  // S =   w,z,y,x
  // t = * -,y,x,z
  shufps xmm7, xmm3, 11010010b
  mulps xmm7,xmm2

  //xmm6 = w,x,z,y
  //xmm7 = w,y,x,z
  subps xmm6,xmm7
  movaps xmm0, xmm6
  //-------------------------------------

  //  xmm0        =      xmm6       +        xmm7         +         xmm8        +         xmm2
  //Result.X := (s.Y*t.Z - s.Z*t.Y) + (t.Y*u.Z - t.Z*u.Y) + (u.Y*v.Z - u.Z*v.Y) + (v.Y*s.Z - v.Z*s.Y);
  //Result.Y := (s.Z*t.X - s.X*t.Z) + (t.Z*u.X - t.x*u.Z) + (u.Z*v.X - u.X*v.Z) + (v.Z*s.X - v.X*s.Z);
  //Result.Z := (s.X*t.Y - s.Y*t.X) + (t.X*u.Y - t.Y*u.X) + (u.X*v.Y - u.Y*v.X) + (v.X*s.Y - v.Y*s.X);

  addps xmm0,xmm7
  addps xmm0,xmm8
  addps xmm0,xmm2

  //NormalizeVector(Result);
end;}

