
{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

function TGLZQuaternion.ToString : String;
begin
   Result := '(ImagePart.X: '+FloattoStrF(Self.X,fffixed,5,5)+
            ' ,ImagePart.Y: '+FloattoStrF(Self.Y,fffixed,5,5)+
            ' ,ImagePart.Z: '+FloattoStrF(Self.Z,fffixed,5,5)+
            ' , RealPart.W: '+FloattoStrF(Self.W,fffixed,5,5)+')';
End;

procedure TGLZQuaternion.Create(const Imag: array of Single; Real : Single);
var
   n : Integer;
begin
   n:=Length(Imag);
   if n>=1 then Self.ImagePart.X:=Imag[0];
   if n>=2 then Self.ImagePart.Y:=Imag[1];
   if n>=3 then Self.ImagePart.Z:=Imag[2];
   Self.RealPart:=real;
end;

procedure TGLZQuaternion.Create(x,y,z: Single; Real : Single);
begin
  Self.ImagePart.X:=X;
  Self.ImagePart.Y:=Y;
  Self.ImagePart.Z:=Z;
  Self.RealPart:=real;
end;


function TGLZQuaternion.Transform(constref V: TGLZVector): TGLZVector;
var
  res, v2, Conj: TGLZQuaternion;
begin
    conj := self.Conjugate;
    v2.Create(V.X,V.Y,V.Z,0);
    res := Self * v2;
    res := res * conj;
    Result := Res.AsVector4f;
    Result.W := 1;
end;

{%endregion%}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}


// This region is for pascal routines that are required to create a working
// library of routines. We may or may not convert these to SSE/AVX.

procedure TGLZQuaternion.Create(const V1, V2: TGLZAffineVector);
Var
 vv, vv1,vv2 : TGLZVector;
begin
   vv1.AsVector3f := V1;
   vv2.AsVector3f := V2;
   Self.AsVector4f:=vv1.CrossProduct(vv2);
   Self.RealPart:= vv1.DotProduct(vv2) + 1;
   self.Normalize;
end;

procedure TGLZQuaternion.Create(const V1, V2: TGLZVector); overload;
begin
   Self.AsVector4f := v1.CrossProduct(v2);
   Self.RealPart := v1.DotProduct(v2) + 1;
   self.Normalize;
end;

//procedure TGLZQuaternion.Create(const V1, V2: TGLZVector);

//procedure TGLZQuaternion.Create(const mat : TGLZMatrix);
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

procedure TGLZQuaternion.Create(const angle  : Single; const axis : TGLZAffineVector);
//procedure TGLZQuaternion.Create(const angle  : Single; const axis : TGLZVector);
var
   f, s, c : Single;
   vaxis : TGLZVector;
begin
   GLZMath.SinCos(DegToRadian(angle*cOneHalf), s, c);
   Self.RealPart:=c;
   vaxis.AsVector3f := axis;
   f:=s/vAxis.Length;
   Self.ImagePart.V[0]:=axis.V[0]*f;
   Self.ImagePart.V[1]:=axis.V[1]*f;
   Self.ImagePart.V[2]:=axis.V[2]*f;
end;

procedure TGLZQuaternion.Create(const r, p, y : Single); //Roll Pitch Yaw
var
   qp, qy : TGLZQuaternion;
begin
   Self.Create(r, ZVector); // Create From Angle Axis
   qp.Create(p, XVector);
   qy.Create(y, YVector);

   Self:=qp * Self;
   Self:=qy * Self;
end;

procedure TGLZQuaternion.Create(const x, y, z: Single; eulerOrder : TGLZEulerOrder);
// input angles in degrees
var
   gimbalLock: Boolean;
   quat1, quat2: TGLZQuaternion;

   function EulerToQuat(const X, Y, Z: Single; eulerOrder: TGLZEulerOrder) : TGLZQuaternion;
   const
      cOrder : array [Low(TGLZEulerOrder)..High(TGLZEulerOrder)] of array [1..3] of Byte =
         ( (1, 2, 3), (1, 3, 2), (2, 1, 3),     // eulXYZ, eulXZY, eulYXZ,
           (3, 1, 2), (2, 3, 1), (3, 2, 1) );   // eulYZX, eulZXY, eulZYX
   var
      q : array [1..3] of TGLZQuaternion;
   begin
      q[cOrder[eulerOrder][1]].Create(X, XVector); // Create From Angle Axis
      q[cOrder[eulerOrder][2]].Create(Y, YVector);
      q[cOrder[eulerOrder][3]].Create(Z, ZVector);
      result:=(q[2] * q[3]);
      result:=(q[1] * result);
   end;

const
   SMALL_ANGLE = 0.001;
begin

//   NormalizeDegAngle(x);
//   NormalizeDegAngle(y);
//   NormalizeDegAngle(z);
   //case EulerOrder of
   //   eulXYZ, eulZYX: GimbalLock := Abs(Abs(y) - 90.0) <= cEpsilon30; // cos(Y) = 0;
   //   eulYXZ, eulZXY: GimbalLock := Abs(Abs(x) - 90.0) <= cEpsilon30; // cos(X) = 0;
   //   eulXZY, eulYZX: GimbalLock := Abs(Abs(z) - 90.0) <= cEpsilon30; // cos(Z) = 0;
   //else
   //   Assert(False);
   //   gimbalLock:=False;
   //end;
   //if gimbalLock then
   //begin
   //   case EulerOrder of
   //     eulXYZ, eulZYX: quat1 := EulerToQuat(x, y - SMALL_ANGLE, z, EulerOrder);
   //     eulYXZ, eulZXY: quat1 := EulerToQuat(x - SMALL_ANGLE, y, z, EulerOrder);
   //     eulXZY, eulYZX: quat1 := EulerToQuat(x, y, z - SMALL_ANGLE, EulerOrder);
   //   end;
   //   case EulerOrder of
   //     eulXYZ, eulZYX: quat2 := EulerToQuat(x, y + SMALL_ANGLE, z, EulerOrder);
   //     eulYXZ, eulZXY: quat2 := EulerToQuat(x + SMALL_ANGLE, y, z, EulerOrder);
   //     eulXZY, eulYZX: quat2 := EulerToQuat(x, y, z + SMALL_ANGLE, EulerOrder);
   //   end;
   //   Self := Quat1.Slerp(quat2{%H-}, 0.5);
   //end
   //else
   //begin
      Self := EulerToQuat(x, y, z, EulerOrder);
   //end;
end;

procedure TGLZQuaternion.ConvertToPoints(var ArcFrom, ArcTo: TGLZAffineVector);
//procedure ConvertToPoints(var ArcFrom, ArcTo: TGLZVector); //overload;
var
   s, invS : Single;
begin
   s:=Self.ImagePart.X*Self.ImagePart.X+Self.ImagePart.Y*Self.ImagePart.Y;
   if s=0 then ArcFrom := AffineVectorMake( 0, 1, 0)
   else
   begin
      invS:=InvSqrt(s);
      ArcFrom := AffineVectorMake( -Self.ImagePart.Y*invS, Self.ImagePart.X*invS, 0);
   end;
   ArcTo.X:=Self.RealPart*ArcFrom.X-Self.ImagePart.Z*ArcFrom.Y;
   ArcTo.Y:=Self.RealPart*ArcFrom.Y+Self.ImagePart.Z*ArcFrom.X;
   ArcTo.Z:=Self.ImagePart.X*ArcFrom.Y-Self.ImagePart.Y*ArcFrom.X;
   if Self.RealPart<0 then ArcFrom := AffineVectorMake( -ArcFrom.X, -ArcFrom.Y, 0);
end;


{ Constructs a rotation matrix from (possibly non-unit) quaternion.
   Assumes matrix is used to multiply column vector on the left:
   vnew = mat vold.
   Works correctly for right-handed coordinate system and right-handed rotations. }
//function TGLZQuaternion.ConvertToMatrix : TGLZMatrix;
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

//function TGLZQuaternion.ConvertToAffineMatrix : TGLZAffineMatrix;
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

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}




{%region%----[ Operators ]------------------------------------------------------}



// Returns the product A*B (which is the concatenation of a rotation Q1 followed by the rotation Q2)
// Order is important reverted to A prod B as B prod A gave wrong results.
class operator TGLZQuaternion.*(constref A, B: TGLZQuaternion): TGLZQuaternion;
begin
  Result.X :=  (A.w * B.x) + (A.x * B.w) + (A.y * B.z) - (A.z * B.y);
  Result.Y :=  (A.w * B.y) - (A.x * B.z) + (A.y * B.w) + (A.z * B.x);
  Result.Z :=  (A.w * B.z) + (A.x * B.y) - (A.y * B.x) + (A.z * B.w);
  Result.W :=  (A.w * B.w) - (A.x * B.x) - (A.y * B.y) - (A.z * B.z);
end;
{*
class operator TGLZQuaternion.*(constref A, B: TGLZQuaternion): TGLZQuaternion;
var
  Temp : TQuaternion;
begin
  Temp.RealPart := A.RealPart * B.RealPart - A.ImagePart.X * B.ImagePart.X
                 - A.ImagePart.Y * B.ImagePart.Y - A.ImagePart.Z * B.ImagePart.Z;

  Temp.ImagePart.X := A.RealPart * B.ImagePart.X + A.ImagePart.X * B.RealPart
                   + A.ImagePart.Y * B.ImagePart.Z - A.ImagePart.Z * B.ImagePart.Y;

  Temp.ImagePart.Y := A.RealPart * B.ImagePart.Y + A.ImagePart.Y * B.RealPart
                   + A.ImagePart.Z * B.ImagePart.X - A.ImagePart.X * B.ImagePart.Z;

  Temp.ImagePart.Z := A.RealPart * B.ImagePart.Z + A.ImagePart.Z * B.RealPart
                   + A.ImagePart.X * B.ImagePart.Y - A.ImagePart.Y * B.ImagePart.X;
  Result:=Temp;
end;
*}



class operator TGLZQuaternion.=(constref A, B: TGLZQuaternion): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

class operator TGLZQuaternion.<>(constref A, B: TGLZQuaternion): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z) or (A.W <> B.W);
end;

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZQuaternion.Conjugate : TGLZQuaternion;
begin
  Result.X:=-Self.X;
  Result.Y:=-Self.Y;
  Result.Z:=-Self.Z;
  Result.W:= Self.W;
end;

function TGLZQuaternion.Magnitude : Single;
begin
  Result:=Sqrt(Self.AsVector4f.Norm + Sqr(Self.RealPart));
end;

procedure TGLZQuaternion.Normalize;
var
   m, f: Single;
begin
   m:=Self.Magnitude;
   if m>cEPSILON then
   begin
      f:=1/m;
      Self.AsVector4f := Self.AsVector4f * f;
   end
   else
   Self:=IdentityQuaternion;
end;

function TGLZQuaternion.MultiplyAsSecond(const qFirst : TGLZQuaternion): TGLZQuaternion;
var
  Temp : TGLZQuaternion;
begin
  Temp.RealPart := qFirst.RealPart * Self.RealPart - qFirst.ImagePart.X * Self.ImagePart.X
                 - qFirst.ImagePart.Y * Self.ImagePart.Y - qFirst.ImagePart.Z * Self.ImagePart.Z;

  Temp.ImagePart.X := qFirst.RealPart * Self.ImagePart.X + qFirst.ImagePart.X * Self.RealPart
                   + qFirst.ImagePart.Y * Self.ImagePart.Z - qFirst.ImagePart.Z * Self.ImagePart.Y;

  Temp.ImagePart.Y := qFirst.RealPart * Self.ImagePart.Y + qFirst.ImagePart.Y * Self.RealPart
                   + qFirst.ImagePart.Z * Self.ImagePart.X - qFirst.ImagePart.X * Self.ImagePart.Z;

  Temp.ImagePart.Z := qFirst.RealPart * Self.ImagePart.Z + qFirst.ImagePart.Z * Self.RealPart
                   + qFirst.ImagePart.X * Self.ImagePart.Y - qFirst.ImagePart.Y * Self.ImagePart.X;
  Result:=Temp;
end;

function TGLZQuaternion.Slerp(const QEnd: TGLZQuaternion; Spin: Integer; t: Single): TGLZQuaternion;
var
    beta,                   // complementary interp parameter
    theta,                  // Angle between A and B
    sint, cost,             // sine, cosine of theta
    phi: Single;            // theta plus spins
    bflip: Boolean;         // use negativ t?
begin
  // cosine theta
  cost:=Self.AsVector4f.AngleCosine(QEnd.AsVector4f);  // q.imag half rot angle

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

   if (1 - cost) < cEpsilon then  // full rotation would yield half angle 180
   begin                          // then CosT would come out at -1
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

   // interpolate   ?? direct mult on a Vector changes length to use quats
   // effectivly they must be normalized after most operations.???
   Result.ImagePart.X:=beta * Self.ImagePart.X + t * QEnd.ImagePart.X;
   Result.ImagePart.Y:=beta * Self.ImagePart.Y + t * QEnd.ImagePart.Y;
   Result.ImagePart.Z:=beta * Self.ImagePart.Z + t * QEnd.ImagePart.Z;
   Result.RealPart:=beta * Self.RealPart + t * QEnd.RealPart;
end;

function TGLZQuaternion.Slerp(const QEnd: TGLZQuaternion; const t : Single) : TGLZQuaternion;
var
   to1: array[0..4] of Single;
   omega, cosom, sinom, scale0, scale1: Extended;
// t goes from 0 to 1
// absolute rotations
begin
   // calc cosine
   cosom:= Self.ImagePart.V[0]*QEnd.ImagePart.X
          +Self.ImagePart.V[1]*QEnd.ImagePart.Y
          +Self.ImagePart.V[2]*QEnd.ImagePart.Z
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
   Result.RealPart := scale0 * Self.RealPart + scale1 * to1[3];
   //NormalizeQuaternion(Result);
   //Result.pNormalize;
   Result.Normalize;
end;


{%endregion%}

{%endregion%----Assembler----}

{$ENDIF USE_ASM}
