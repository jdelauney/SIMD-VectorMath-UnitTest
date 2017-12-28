{%region%----[ Operators ]------------------------------------------------------}

{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZMatrix4.+(constref A, B: TGLZMatrix4): TGLZMatrix4; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4.+(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4.-(constref A, B: TGLZMatrix4): TGLZMatrix4; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4.-(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4.*(constref A, B: TGLZMatrix4): TGLZMatrix4; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4.*(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4.*(constref A: TGLZMatrix4; constref B: TGLZVector): TGLZVector; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4./(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

class operator TGLZMatrix4.-(constref A: TGLZMatrix4): TGLZMatrix4; assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZMatrix4.GetDeterminant: Single;assembler;
asm
  vxorps xmm0, xmm0, xmm0
  movss [RESULT], {%H-}xmm0
end;

//function TGLZMatrix4.MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single; assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;

function TGLZMatrix4.Transpose: TGLZMatrix4;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZMatrix4.Invert : TGLZMatrix4;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZMatrix4.Normalize : TGLZMatrix4;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

//procedure TGLZMatrix4.Adjoint;assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4.AnglePreservingMatrixInvert(constref mat : TGLZMatrix4);assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//
//function TGLZMatrix4.Decompose(var Tran: TGLZMatrixTransformations): Boolean;assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;

function TGLZMatrix4.Translate( constref v : TGLZVector):TGLZMatrix4;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;
function TGLZMatrix4.Multiply(constref M2: TGLZMatrix4):TGLZMatrix4;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

{%endregion%}

{%region%----[ Operations on Self ]---------------------------------------------}

//procedure TGLZMatrix4.Transpose_Scale_M33(constref src : TGLZMatrix4; Constref ascale : Single); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//
//procedure TGLZMatrix4.CreateLookAtMatrix(const eye, center, normUp: TGLZVector);assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4.CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4.CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4.CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4.CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//
//
//procedure TGLZMatrix4.CreateParallelProjectionMatrix(const plane : TGLZHmgPlane; const dir : TGLZVector); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//
//procedure TGLZMatrix4.CreateShadowMatrix(const planePoint, planeNormal, lightPos : TGLZVector);assembler; nostackframe; register;
//asm
// vxorps xmm0, xmm0, xmm0
//end;
//
//
//procedure TGLZMatrix4.CreateReflectionMatrix(const planePoint, planeNormal : TGLZVector);assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;


{%endregion%}


