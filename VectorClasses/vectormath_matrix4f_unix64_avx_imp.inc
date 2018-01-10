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

function TGLZMatrix4f.GetDeterminant: Single;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;


function TGLZMatrix4f.Transpose: TGLZMatrix4f;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZMatrix4f.Invert : TGLZMatrix4f;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZMatrix4f.Normalize : TGLZMatrix4f;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

//procedure TGLZMatrix4f.Adjoint;assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4f.AnglePreservingMatrixInvert(constref mat : TGLZMatrix4);assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//
//function TGLZMatrix4f.Decompose(var Tran: TGLZMatrixTransformations): Boolean;assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;

function TGLZMatrix4f.Translate( constref v : TGLZVector):TGLZMatrix4f;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

function TGLZMatrix4f.Multiply(constref M2: TGLZMatrix4f):TGLZMatrix4f;assembler; nostackframe; register;
asm
  vxorps xmm0, xmm0, xmm0
end;

{%endregion%}

{%region%----[ Operations on Self ]---------------------------------------------}

//procedure TGLZMatrix4f.Transpose_Scale_M33(constref src : TGLZMatrix4; Constref ascale : Single); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//
//procedure TGLZMatrix4f.CreateLookAtMatrix(const eye, center, normUp: TGLZVector);assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4f.CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4f.CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4f.CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//procedure TGLZMatrix4f.CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//
//
//procedure TGLZMatrix4f.CreateParallelProjectionMatrix(const plane : TGLZHmgPlane; const dir : TGLZVector); assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;
//
//procedure TGLZMatrix4f.CreateShadowMatrix(const planePoint, planeNormal, lightPos : TGLZVector);assembler; nostackframe; register;
//asm
// vxorps xmm0, xmm0, xmm0
//end;
//
//
//procedure TGLZMatrix4f.CreateReflectionMatrix(const planePoint, planeNormal : TGLZVector);assembler; nostackframe; register;
//asm
//  vxorps xmm0, xmm0, xmm0
//end;


{%endregion%}


