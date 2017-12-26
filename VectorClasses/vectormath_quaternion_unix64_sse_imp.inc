{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZQuaternion.+(constref A, B: TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movaps xmm1,[B]
  addps  xmm0,xmm1
  movhlps xmm1,xmm0
end;

class operator TGLZQuaternion.+(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion;  assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movss  xmm1,[B]
  shufps xmm1, xmm1, $00
  addps  xmm0,xmm1
  movhlps xmm1,xmm0
end;

class operator TGLZQuaternion.-(constref A, B: TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movaps xmm1,[B]
  subps  xmm0,xmm1
  movhlps xmm1,xmm0
end;

class operator TGLZQuaternion.-(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movss  xmm1,[B]
  shufps xmm1, xmm1, $00
  subps  xmm0,xmm1
  movhlps xmm1,xmm0
end;

class operator TGLZQuaternion.-(constref A: TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
asm
  movups xmm1,[A]
  movups xmm0,[RIP+cNullVector4f]
  subps xmm0,xmm1
  movhlps xmm1,xmm0
End;


class operator TGLZQuaternion.*(constref A, B: TGLZQuaternion): TGLZQuaternion; assembler;
Const
 cControlWZYX : TGLZQuaternion =(x:1.0;y:-1.0;z:1.0;w:-1.0);
 cControlZWXY : TGLZQuaternion =(x:1.0;y:1.0;z:-1.0;w:-1.0);
 cControlYXWZ : TGLZQuaternion =(x:-1.0;y:1.0;z:1.0;w:-1.0);
asm
 movaps xmm0, [A]
 movaps xmm1, [B]

 movaps xmm2, xmm1
 movaps xmm3, xmm1
 movaps xmm4, xmm1
 movaps xmm5, xmm1

 shufps xmm5, xmm5, 11111111b //w
 shufps xmm2, xmm2, 00000000b //x
 shufps xmm3, xmm3, 01010101b //y
 shufps xmm4, xmm4, 10101010b //z

 //(B.w * A.x)
 //(B.w * A.y)
 //(B.w * A.z)
 //(B.w * A.w)
 mulps xmm5,xmm0
 //(B.x * A.w)
 //-(B.x * A.z)
 //(B.x * A.y)
 //-(B.x * A.x)
 movaps xmm6,xmm0
 shufps xmm6, xmm6, 00011011b //wzyx
 mulps xmm2, xmm6
 mulps xmm2, [RIP+cControlWZYX]
 //(B.y * A.z)
 //(B.y * A.w)
 //-(B.y * A.x)
 //-(B.y * A.y)
 movaps xmm6,xmm0
 shufps xmm6, xmm6, 01001110b //zwxy
 mulps xmm3, xmm6
 mulps xmm3, [RIP+cControlZWXY]
 //(B.z * A.y)
 //(B.z * A.x)
 //(B.z * A.w)
 //(B.z * A.z)
 movaps xmm6,xmm0
 shufps xmm6, xmm6, 10110001b //yxwz
 mulps xmm4,xmm6
 mulps xmm4, [RIP+cControlYXWZ]

 addps xmm5, xmm2
 addps xmm5, xmm3
 addps xmm5, xmm4

 movaps [RESULT], xmm5
end;

class operator TGLZQuaternion.*(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movss  xmm1,[B]
  shufps xmm1, xmm1, $00
  mulps  xmm0,xmm1
  movhlps xmm1,xmm0
end;

class operator TGLZQuaternion./(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movss  xmm1,[B]
  shufps xmm1, xmm1,$00
  divps  xmm0,xmm1
  movhlps xmm1,xmm0
end;

class operator TGLZQuaternion.=(constref A, B: TGLZQuaternion): Boolean; assembler; nostackframe; register;
asm
  movaps xmm1,[A]
  movaps xmm0,[B]
  cmpps  xmm0, xmm1, cSSE_OPERATOR_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 0 = Operator Equal
  movmskps eax, xmm0
  xor eax, $F
  setz al
end;

class operator TGLZQuaternion.<>(constref A, B: TGLZQuaternion): Boolean; assembler; nostackframe; register;
asm
  movaps xmm0,[A]
  movaps xmm1,[B]
  cmpps  xmm0, xmm1, cSSE_OPERATOR_NOT_EQUAL    //  Yes: $FFFFFFFF, No: $00000000 ; 4 = Operator Not Equal
  movmskps eax, xmm0
  xor eax, $f
  setz al
end;

{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZQuaternion.Conjugate : TGLZQuaternion;  assembler; nostackframe; register;
Const
 cSSE_SIGNMASK_XYZ : array [0..3] of UInt32 = ($80000000, $80000000, $80000000, $00000000);
asm
  movaps xmm0, [RDI]
  xorps xmm0, [RIP+cSSE_SIGNMASK_XYZ]
  movhlps xmm1,xmm0
end;

function TGLZQuaternion.Magnitude : Single; assembler;
asm
  movaps xmm0, [RDI]
  mulps  xmm0, xmm0
  pshufd xmm1, xmm0, $0E
  addps  xmm0, xmm1
  pshufd xmm1, xmm0, $01
  addss  xmm0, xmm1
  sqrtss xmm0, xmm0
  movss [RESULT], {%H-}xmm0
end;


function TGLZQuaternion.Normalize : TGLZQuaternion; assembler;
asm
{$ifdef TEST}
  // Normalize fast
  movaps  xmm0, [RDI]
  movaps  xmm2, xmm0

  // Dot(A, A)
  mulps   xmm0, xmm0
  pshufd  xmm1, xmm0, $4E
  addps   xmm0, xmm1
  pshufd  xmm1, xmm0, $11
  addps   xmm0, xmm1

  rsqrtps xmm0, xmm0
  mulps   xmm0, xmm2
  movhlps xmm1,xmm0
{$else}
  movaps xmm0,[RDI]
  movaps xmm2,xmm0
  movlps xmm1,[RDI]12
  andps xmm2, [RIP+cSSE_MASK_NO_W]

  mulps  xmm2, xmm2
  pshufd xmm1, xmm2, $0E
  addps  xmm2, xmm1
  pshufd xmm1, xmm2, $01
  addss  xmm2, xmm1
  sqrtss xmm2, xmm2
  movlps    xmm5, [RIP+cEpsilon30]
  comiss   xmm2, xmm5
  jb  @LessThan
  //rcpss xmm2,xmm2
  shufps xmm2, xmm2, $00
  movaps xmm3, [RIP+cOneVector4f]
  divps xmm3, xmm2
  mulps  xmm0, xmm3
  jmp @Finish
@LessThan:
  movaps xmm0, [RIP+IdentityQuaternion]
@Finish:
  movhlps xmm1,xmm0
{$endif}

end;


// TODO Note in unix qFirst is already in xmm0, xmm1
function TGLZQuaternion.MultiplyAsSecond(const qFirst : TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
Const
 cControlWZYX : TGLZQuaternion =(x:1.0;y:-1.0;z:1.0;w:-1.0);
 cControlZWXY : TGLZQuaternion =(x:1.0;y:1.0;z:-1.0;w:-1.0);
 cControlYXWZ : TGLZQuaternion =(x:-1.0;y:1.0;z:1.0;w:-1.0);
asm
  movlhps xmm0, xmm1     // get upper half from xmm1
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  movaps xmm4, xmm0
  movaps xmm5, xmm0
  movaps xmm0, [RDI]

  shufps xmm5, xmm5, 11111111b //w
  shufps xmm2, xmm2, 00000000b //x
  shufps xmm3, xmm3, 01010101b //y
  shufps xmm4, xmm4, 10101010b //z

  //(B.w * A.x)
  //(B.w * A.y)
  //(B.w * A.z)
  //(B.w * A.w)
  mulps xmm5,xmm0
  //(B.x * A.w)
  //-(B.x * A.z)
  //(B.x * A.y)
  //-(B.x * A.x)
  movaps xmm6,xmm0
  shufps xmm6, xmm6, 00011011b //wzyx
  mulps xmm2, xmm6
  mulps xmm2, [RIP+cControlWZYX]
//  "xorps _POSNEGPOSNEG, %%xmm4\n"		/* C2 = { + - + - } */
//  "xorps _POSPOSNEGNEG, %%xmm5\n"		/* C3 = { + + - - } */
//  "xorps _NEGPOSPOSNEG, %%xmm6\n"		/* C4 = { - + + - } */
  //(B.y * A.z)
  //(B.y * A.w)
  //-(B.y * A.x)
  //-(B.y * A.y)
  movaps xmm6,xmm0
  shufps xmm6, xmm6, 01001110b //zwxy
  mulps xmm3, xmm6
  mulps xmm3, [RIP+cControlZWXY]
  //(B.z * A.y)
  //(B.z * A.x)
  //(B.z * A.w)
  //(B.z * A.z)
  movaps xmm6,xmm0
  shufps xmm6, xmm6, 10110001b //yxwz
  mulps xmm4,xmm6
  mulps xmm4, [RIP+cControlYXWZ]

  addps xmm5, xmm2
  addps xmm5, xmm3
  addps xmm5, xmm4

  movaps xmm0, xmm5
  movhlps xmm1,xmm0
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
