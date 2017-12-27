{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZQuaternion.+(constref A, B: TGLZQuaternion): TGLZQuaternion;
begin
  Result.X := A.X + B.X;
  Result.Y := A.Y + B.Y;
  Result.Z := A.Z + B.Z;
  Result.W := A.W + B.W;
end;

class operator TGLZQuaternion.-(constref A, B: TGLZQuaternion): TGLZQuaternion;
begin
  Result.X := A.X - B.X;
  Result.Y := A.Y - B.Y;
  Result.Z := A.Z - B.Z;
  Result.W := A.W - B.W;
end;

class operator TGLZQuaternion.*(constref A, B: TGLZQuaternion): TGLZQuaternion;
begin

  // Returns the product B*A (which is the concatenation of a rotation Q1 followed by the rotation Q2)

  Result.X :=  (B.w * A.x) + (B.x * A.w) + (B.y * A.z) - (B.z * A.y);
  Result.Y :=  (B.w * A.y) - (B.x * A.z) + (B.y * A.w) + (B.z * A.x);
  Result.Z :=  (B.w * A.z) + (B.x * A.y) - (B.y * A.x) + (B.z * A.w);
  Result.W :=  (B.w * A.w) - (B.x * A.x) - (B.y * A.y) - (B.z * A.z);
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

class operator TGLZQuaternion.+(constref A: TGLZQuaternion; constref B:Single): TGLZQuaternion; overload;
begin
  Result.X := A.X + B;
  Result.Y := A.Y + B;
  Result.Z := A.Z + B;
  Result.W := A.W + B;
end;

class operator TGLZQuaternion.-(constref A: TGLZQuaternion; constref B:Single): TGLZQuaternion; overload;
begin
  Result.X := A.X - B;
  Result.Y := A.Y - B;
  Result.Z := A.Z - B;
  Result.W := A.W - B;
end;

class operator TGLZQuaternion.*(constref A: TGLZQuaternion; constref B:Single): TGLZQuaternion; overload;
begin
  Result.X := A.X * B;
  Result.Y := A.Y * B;
  Result.Z := A.Z * B;
  Result.W := A.W * B;
end;

class operator TGLZQuaternion./(constref A: TGLZQuaternion; constref B:Single): TGLZQuaternion; overload;
begin
  Result.X := A.X / B;
  Result.Y := A.Y / B;
  Result.Z := A.Z / B;
  Result.W := A.W / B;
end;

class operator TGLZQuaternion.-(constref A : TGLZQuaternion): TGLZQuaternion;
begin
  Result.X := -A.X;
  Result.Y := -A.Y;
  Result.Z := -A.Z;
  Result.W := -A.W;
end;

class operator TGLZQuaternion.=(constref A, B: TGLZQuaternion): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z) and (A.W = B.W);
end;

class operator TGLZQuaternion.<>(constref A, B: TGLZQuaternion): Boolean;
begin
  Result := (A.X <> B.X) and (A.Y <> B.Y) and (A.Z <> B.Z) and (A.W <> B.W);
end;

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZQuaternion.Conjugate : TGLZQuaternion;
begin
  Result.X:=-Self.X;
  Result.Y:=-Self.Y;
  Result.Z:=-Self.Z;
  Result.W:=Self.W;
end;

function TGLZQuaternion.Magnitude : Single;
begin
  Result:=Sqrt(Self.AsVector4f.Norm + Sqr(Self.RealPart));
end;

function TGLZQuaternion.Normalize : TGLZQuaternion;
var
   m, f, r : Single;
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
   Result := Result.Normalize;
end;


{%endregion%}
