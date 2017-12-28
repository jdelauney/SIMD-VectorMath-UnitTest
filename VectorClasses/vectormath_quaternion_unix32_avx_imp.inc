{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZQuaternion.+(constref A, B: TGLZQuaternion): TGLZQuaternion;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZQuaternion.-(constref A, B: TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZQuaternion.-(constref A: TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZQuaternion.*(constref A, B: TGLZQuaternion): TGLZQuaternion;  assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZQuaternion.+(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZQuaternion.-(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZQuaternion.*(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZQuaternion./(constref A : TGLZQuaternion; constref B:Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
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
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZQuaternion.Magnitude : Single; assembler;
asm
  vxorps xmm0, xmm0, xmm0
   movss [RESULT], {%H-}xmm0
end;

function TGLZQuaternion.Normalize : TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZQuaternion.MultiplyAsSecond(const qFirst : TGLZQuaternion): TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZQuaternion.Slerp(const QEnd: TGLZQuaternion; Spin: Integer; t: Single): TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZQuaternion.Slerp(const QEnd: TGLZQuaternion; const t : Single) : TGLZQuaternion; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

{%endregion%}
