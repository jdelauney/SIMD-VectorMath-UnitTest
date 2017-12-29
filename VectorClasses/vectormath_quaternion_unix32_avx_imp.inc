{$I vectormath_quaternion_native_imp.inc}

{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZQuaternion.+(constref A, B: TGLZQuaternion): TGLZQuaternion;assembler; nostackframe; register;
asm
  vmovups  xmm0, [A]
  vmovups  xmm1, [B]
  vaddps   xmm0, xmm0, xmm1
  vmovups  [Result], xmm0
end;

class operator TGLZQuaternion.-(constref A, B: TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
asm
vmovups xmm0, [A]
vmovups xmm1, [B]
vsubps  xmm0, xmm0, xmm1
vmovups [Result], xmm0
end;

class operator TGLZQuaternion.-(constref A: TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
asm
  vmovups xmm1, [A]
  vmovups xmm0, [cNullVector4f]
  vsubps  xmm0, xmm0, xmm1
  vmovups [Result], xmm0
end;

////TODO OPTIMIZE TO AVX STILL SSE CODE
class operator TGLZQuaternion.*(constref A, B: TGLZQuaternion): TGLZQuaternion;  assembler; nostackframe; register;
Const
 cControlWZYX : TGLZQuaternion =(x:1.0;y:-1.0;z:1.0;w:-1.0);
 cControlZWXY : TGLZQuaternion =(x:1.0;y:1.0;z:-1.0;w:-1.0);
 cControlYXWZ : TGLZQuaternion =(x:-1.0;y:1.0;z:1.0;w:-1.0);
asm
 vmovups xmm0, [A]
 vmovups xmm1, [B]

 vmovaps xmm2, xmm1
 vmovaps xmm3, xmm1
 vmovaps xmm4, xmm1
 vmovaps xmm5, xmm1

 vshufps xmm5, xmm5, xmm5, 11111111b //w
 vshufps xmm2, xmm2, xmm2, 00000000b //x
 vshufps xmm3, xmm3, xmm3, 01010101b //y
 vshufps xmm4, xmm4, xmm4, 10101010b //z

 //(B.w * A.x)
 //(B.w * A.y)
 //(B.w * A.z)
 //(B.w * A.w)
 vmulps xmm5, xmm5, xmm0
 //(B.x * A.w)
 //-(B.x * A.z)
 //(B.x * A.y)
 //-(B.x * A.x)
 vmovaps xmm6, xmm0
 vshufps xmm6, xmm6, xmm6, 00011011b //wzyx
 vmulps  xmm2, xmm2, xmm6
 vmulps  xmm2, xmm2, [cControlWZYX]
 //(B.y * A.z)
 //(B.y * A.w)
 //-(B.y * A.x)
 //-(B.y * A.y)
 vmovaps xmm6, xmm0
 vshufps xmm6, xmm6, xmm6, 01001110b //zwxy
 vmulps  xmm3, xmm3, xmm6
 vmulps  xmm3, xmm3, [cControlZWXY]
 //(B.z * A.y)
 //(B.z * A.x)
 //(B.z * A.w)
 //(B.z * A.z)
 vmovaps xmm6, xmm0
 vshufps xmm6, xmm6, xmm6, 10110001b //yxwz
 vmulps  xmm4, xmm4, xmm6
 vmulps  xmm4, xmm4, [cControlYXWZ]

 vaddps  xmm0, xmm5, xmm2
 vaddps  xmm0, xmm0, xmm3
 vaddps  xmm0, xmm0, xmm4
 vmovups [Result], xmm0
end;

class operator TGLZQuaternion.+(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vmovups  xmm0,[A]
  vmovss   xmm1,[B]
  vshufps  xmm1, xmm1, xmm1, $00
  vaddps   xmm0, xmm0, xmm1
  vmovups  [Result], xmm0
end;

class operator TGLZQuaternion.-(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vmovups xmm0, [A]
  vmovss  xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vsubps  xmm0, xmm0, xmm1
  vmovups [Result], xmm0
end;

class operator TGLZQuaternion.*(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vmovups xmm0, [A]
  vmovss  xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vmulps  xmm0, xmm0, xmm1
  vmovups [Result], xmm0
end;

class operator TGLZQuaternion./(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vmovups xmm0, [A]
  vmovss  xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vdivps  xmm0, xmm0, xmm1
  vmovups [Result], xmm0
end;

class operator TGLZQuaternion.=(constref A, B: TGLZQuaternion): Boolean; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0

end;

class operator TGLZQuaternion.<>(constref A, B: TGLZQuaternion): Boolean; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0

end;

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZQuaternion.Conjugate : TGLZQuaternion; assembler; nostackframe; register;
Const
 cSSE_SIGNMASK_XYZ : array [0..3] of UInt32 = ($80000000, $80000000, $80000000, $00000000);
asm
  vmovups xmm0, [EAX]
  vxorps  xmm0, xmm0, [cSSE_SIGNMASK_XYZ]
  movss   [RESULT], {%H-}xmm0
end;

function TGLZQuaternion.Magnitude : Single; assembler;
asm
  vmovups xmm0,[EAX]
  vmulps  xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  sqrtps  xmm0, xmm0
  movss   [RESULT], {%H-}xmm0
end;

////TODO OPTIMIZE TO AVX STILL SSE CODE
function TGLZQuaternion.Normalize : TGLZQuaternion; assembler; nostackframe; register;
asm
  vmovups xmm0,[EAX]
  vmovaps xmm2,xmm0
  movlps  xmm1,[EAX]12        //???? moving 8 bytes 4 past record should this be movss?????
  vandps  xmm2, xmm2, [cSSE_MASK_NO_W]

  vmulps  xmm2, xmm2, xmm2
  pshufd  xmm1, xmm2, $0E
  vaddps  xmm2, xmm2, xmm1
  pshufd  xmm1, xmm2, $01
  vaddss  xmm2, xmm2, xmm1
  vsqrtss xmm2, xmm2, xmm2
  movlps  xmm5, [cEpsilon30]
  vcomiss xmm2, xmm5
  jb  @LessThan
  //rcpss xmm2,xmm2
  vshufps xmm2, xmm2, xmm2, $00
  vmovups xmm3, [cOneVector4f]
  vdivps  xmm3, xmm3, xmm2
  vmulps  xmm0, xmm0, xmm3
  jmp @Finish
  @LessThan:
  vmovups xmm0, [IdentityQuaternion]
  @Finish:
  vmovups [Result], xmm0
end;

////TODO OPTIMIZE TO AVX STILL SSE CODE
function TGLZQuaternion.MultiplyAsSecond(const qFirst : TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
Const
 cControlWZYX : TGLZQuaternion =(x:1.0;y:-1.0;z:1.0;w:-1.0);
 cControlZWXY : TGLZQuaternion =(x:1.0;y:1.0;z:-1.0;w:-1.0);
 cControlYXWZ : TGLZQuaternion =(x:-1.0;y:1.0;z:1.0;w:-1.0);
asm
  vmovups xmm0, [EAX]
  vmovups xmm1, [qFirst]
  vmovaps xmm2, xmm1
  vmovaps xmm3, xmm1
  vmovaps xmm4, xmm1
  vmovaps xmm5, xmm1

  vshufps xmm5, xmm5, xmm5, 11111111b //w
  vshufps xmm2, xmm2, xmm2, 00000000b //x
  vshufps xmm3, xmm3, xmm3, 01010101b //y
  vshufps xmm4, xmm4, xmm4, 10101010b //z

  //(B.w * A.x)
  //(B.w * A.y)
  //(B.w * A.z)
  //(B.w * A.w)
  vmulps xmm5, xmm5, xmm0
  //(B.x * A.w)
  //-(B.x * A.z)
  //(B.x * A.y)
  //-(B.x * A.x)
  vmovaps xmm6,xmm0
  vshufps xmm6, xmm6, xmm6, 00011011b //wzyx
  vmulps  xmm2, xmm2, xmm6
  vmulps  xmm2, xmm2, [cControlWZYX]
  //  "xorps _POSNEGPOSNEG, %%xmm4\n"		/* C2 = { + - + - } */
  //  "xorps _POSPOSNEGNEG, %%xmm5\n"		/* C3 = { + + - - } */
  //  "xorps _NEGPOSPOSNEG, %%xmm6\n"		/* C4 = { - + + - } */
  //(B.y * A.z)
  //(B.y * A.w)
  //-(B.y * A.x)
  //-(B.y * A.y)
  vmovaps xmm6, xmm0
  vshufps xmm6, xmm6, xmm6, 01001110b //zwxy
  vmulps  xmm3, xmm3, xmm6
  vmulps  xmm3, xmm3, [cControlZWXY]
  //(B.z * A.y)
  //(B.z * A.x)
  //(B.z * A.w)
  //(B.z * A.z)
  vmovaps xmm6, xmm0
  vshufps xmm6, xmm6, xmm6, 10110001b //yxwz
  vmulps  xmm4, xmm4, xmm6
  vmulps  xmm4, xmm4, [cControlYXWZ]

  vaddps xmm0, xmm5, xmm2
  vaddps xmm0, xmm0, xmm3
  vaddps xmm0, xmm0, xmm4
  vmovups  [Result], xmm0
end;

function TGLZQuaternion.Slerp(const QEnd: TGLZQuaternion; Spin: Integer; t: Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
vmovups  [Result], xmm0
end;

function TGLZQuaternion.Slerp(const QEnd: TGLZQuaternion; const t : Single) : TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
vmovups  [Result], xmm0
end;

{%endregion%}
