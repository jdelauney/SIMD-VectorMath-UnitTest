{%region%----[ Operators ]--------------------------------------------------------}

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
var
  Temp : TQuaternion;
begin
  Temp.RealPart := A.RealPart * B.RealPart - A.ImagPart.X * B.ImagPart.X
                 - A.ImagPart.Y * B.ImagPart.Y - A.ImagPart.Z * B.ImagPart.Z;

  Temp.ImagPart.X := A.RealPart * B.ImagPart.X + A.ImagPart.X * B.RealPart
                   + A.ImagPart.Y * B.ImagPart.Z - A.ImagPart.Z * B.ImagPart.Y;

  Temp.ImagPart.Y := A.RealPart * B.ImagPart.Y + A.ImagPart.Y * B.RealPart
                   + A.ImagPart.Z * B.ImagPart.X - A.ImagPart.X * B.ImagPart.Z;

  Temp.ImagPart.Z := A.RealPart * B.ImagPart.Z + A.ImagPart.Z * B.RealPart
                   + A.ImagPart.X * B.ImagPart.Y - A.ImagPart.Y * B.ImagPart.X;
  Result:=Temp;
end;


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

{%region%----[ Functions ]--------------------------------------------------------}

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
   if m>cEPSILON2 then
   begin
      f:=1/m;
      Self := Self.AsVector4f * f;
   end
   else
   Self:=IdentityQuaternion;
end;

function TGLZQuaternion.MultiplyAsSecond(const qFirst : TGLZQuaternion): TGLZQuaternion;
var
  Temp : TQuaternion;
begin
  Temp.RealPart := qFirst.RealPart * Self.RealPart - qFirst.ImagPart.X * Self.ImagPart.X
                 - qFirst.ImagPart.Y * Self.ImagPart.Y - qFirst.ImagPart.Z * Self.ImagPart.Z;

  Temp.ImagPart.X := qFirst.RealPart * Self.ImagPart.X + qFirst.ImagPart.X * Self.RealPart
                   + qFirst.ImagPart.Y * Self.ImagPart.Z - qFirst.ImagPart.Z * Self.ImagPart.Y;

  Temp.ImagPart.Y := qFirst.RealPart * Self.ImagPart.Y + qFirst.ImagPart.Y * Self.RealPart
                   + qFirst.ImagPart.Z * Self.ImagPart.X - qFirst.ImagPart.X * Self.ImagPart.Z;

  Temp.ImagPart.Z := qFirst.RealPart * Self.ImagPart.Z + qFirst.ImagPart.Z * Self.RealPart
                   + qFirst.ImagPart.X * Self.ImagPart.Y - qFirst.ImagPart.Y * Self.ImagPart.X;
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
