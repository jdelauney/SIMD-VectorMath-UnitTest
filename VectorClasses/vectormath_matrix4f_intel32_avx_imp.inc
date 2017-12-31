{%region%----[ Operators ]------------------------------------------------------}

{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZMatrix4f.+(constref A, B: TGLZMatrix4f): TGLZMatrix4f; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4f.+(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4f.-(constref A, B: TGLZMatrix4f): TGLZMatrix4f; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4f.-(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4f.*(constref A, B: TGLZMatrix4f): TGLZMatrix4f; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4f.*(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4f.*(constref A: TGLZMatrix4f; constref B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4f./(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4f.-(constref A: TGLZMatrix4f): TGLZMatrix4f; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}


