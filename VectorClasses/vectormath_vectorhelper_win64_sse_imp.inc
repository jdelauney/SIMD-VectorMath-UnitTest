function TGLZVectorHelper.PointProject(constref origin, direction : TGLZVector4f) : Single;assembler;register; nostackframe;
asm
  movaps xmm0, [RCX]
  movaps xmm1, [Origin]
  subps  xmm0, xmm1
  movaps xmm2, [Direction]
  mulps  xmm0, xmm2
  //andps  xmm0, [RIP+cSSE_MASK_NO_W]
  {$ifdef USE_ASM_SSE_3} // Horizontal add
  {$ifdef TEST}
    haddps xmm0, xmm0  //Slow
	  haddps xmm0, xmm0
  {$else}
    movshdup xmm1,xmm0
    addps  xmm0,xmm1
    movhlps xmm1,xmm0
    addss  xmm0,xmm1
  {$endif}
  {$else}
    movaps xmm1,xmm0
    movhlps xmm1, xmm1
  	addps xmm1, xmm0
  	shufps xmm0, xmm0, 1
  	addss xmm0, xmm1
  {$endif}

  //movss  [RDX], {%H-}xmm0
end;

function TGLZVectorHelper.AverageNormal4(constref up, left, down,right : TGLZVector) : TGLZVector;assembler; register; nostackframe;
asm
  movaps xmm1, [RCX] // cen

  //VectorSubtract(up^,cen^,s{%H-});
  movaps xmm2, [up]   //s
  subps  xmm2, xmm1
  //VectorSubtract(left^,cen^,t{%H-});
  movaps xmm3, [left]  //t
  subps  xmm3, xmm1
  //VectorSubtract(down^,cen^,u{%H-});
  movaps xmm4, [down]   //u
  subps  xmm4, xmm1
  //VectorSubtract(right^,cen^,v{%H-});
  movups xmm5, [right]  //v   //Here we use MOVUPS. On Win64 all Args over the stack become unaligned
  subps  xmm5, xmm1

  movaps xmm0, [RIP+cSSE_MASK_NO_W]
  andps  xmm2, xmm0
  andps  xmm3, xmm0
  andps  xmm4, xmm0
  andps  xmm5, xmm0
                                   // state for result
  //------------------------------------
  // X := s.Y*t.Z,    1*-0.34
  // Y := s.Z*t.X,    -0.34 * -1
  // Z := s.X*t.Y     0 * 0
  // S =   ,x,z,Y
  // T =  -,y,x,z
  movaps xmm6, xmm2
  shufps xmm6, xmm6, 11001001b
  movaps xmm7, xmm3
  shufps xmm7, xmm7, 11010010b
  mulps  xmm6, xmm7                  // s gone t in 7


  // X := s.Z*t.Y
  // Y := s.X*t.Z
  // Z := s.Y*t.X
  // S =   w,y,x,z
  // t = from -,y,x,z to -,x,z,y
  shufps xmm7, xmm7, 11010010b
  movaps xmm8, xmm2
  shufps xmm8, xmm8, 11010010b
  mulps  xmm7, xmm8

  subps  xmm6, xmm7
  movaps xmm0, xmm6
  //-------------------------------------
  // same again for t and u
  //------------------------------------
  // X := t.Y*u.Z,
  // Y := t.Z*u.X,
  // Z := t.X*u.Y
  // T =   w,z,y,x
  // U = * -,x,z,y
  movaps xmm6, xmm3
  shufps xmm6, xmm6, 11001001b
  movaps xmm7, xmm4
  shufps xmm7, xmm7, 11010010b
  mulps  xmm6, xmm7                  // s gone t in 7

  // X := t.Z*u.Y
  // Y := t.X*u.Z
  // Z := t.Y*u.X
  // T =   w,z,y,x
  // U = * -,y,x,z
  shufps xmm7, xmm7, 11010010b
  movaps xmm8, xmm3
  shufps xmm8, xmm8, 11010010b
  mulps  xmm7, xmm8

  subps  xmm6, xmm7
  addps  xmm0, xmm6

  //-------------------------------------
  // same again for u and v
  //------------------------------------
  // X := u.Y*v.Z,
  // Y := u.Z*v.X,
  // Z := u.X*v.Y
  // U =   w,z,y,x
  // V = * -,x,z,y
  movaps xmm6, xmm4
  shufps xmm6, xmm6, 11001001b
  movaps xmm7, xmm5
  shufps xmm7, xmm7, 11010010b
  mulps  xmm6, xmm7                  // s gone t in 7

  // X := u.Z*v.Y
  // Y := u.X*v.Z
  // Z := u.Y*v.X
  // U =   w,z,y,x
  // V = * -,y,x,z
  shufps xmm7, xmm7, 11010010b
  movaps xmm8, xmm4
  shufps xmm8, xmm8, 11010010b
  mulps  xmm7, xmm8

  subps  xmm6, xmm7
  addps  xmm0, xmm6

  //-------------------------------------
  // same again for v and s
  //------------------------------------
  // X := v.Y*s.Z,
  // Y := v.Z*s.X,
  // Z := v.X*s.Y
  // V =   w,z,y,x
  // S = * -,x,z,y
  movaps xmm6, xmm5
  shufps xmm6, xmm6, 11001001b
  movaps xmm7, xmm2
  shufps xmm7, xmm7, 11010010b
  mulps  xmm6, xmm7                  // s gone t in 7

  // X := v.Z*s.Y
  // Y := v.X*s.Z
  // Z := v.Y*s.X
  // V =   w,z,y,x
  // S = * -,y,x,z
  shufps xmm7, xmm7, 11010010b
  movaps xmm8, xmm5
  shufps xmm8, xmm8, 11010010b
  mulps  xmm7, xmm8

  subps  xmm6, xmm7
  addps  xmm0, xmm6

  //  xmm0        =      xmm6       +        xmm7         +         xmm8        +         xmm2
  //Result.X := (s.Y*t.Z - s.Z*t.Y) + (t.Y*u.Z - t.Z*u.Y) + (u.Y*v.Z - u.Z*v.Y) + (v.Y*s.Z - v.Z*s.Y);
  //Result.Y := (s.Z*t.X - s.X*t.Z) + (t.Z*u.X - t.x*u.Z) + (u.Z*v.X - u.X*v.Z) + (v.Z*s.X - v.X*s.Z);
  //Result.Z := (s.X*t.Y - s.Y*t.X) + (t.X*u.Y - t.Y*u.X) + (u.X*v.Y - u.Y*v.X) + (v.X*s.Y - v.Y*s.X);

  movaps xmm2, xmm0
  mulps  xmm0, xmm0
  movaps xmm1, xmm0
  shufps xmm0, xmm1, $4e
  addps  xmm0, xmm1
  movaps xmm1, xmm0
  shufps xmm1, xmm1, $11
  addps  xmm0, xmm1
  sqrtps xmm0, xmm0
  divps  xmm2, xmm0
  movaps xmm0, xmm2
end;

function TGLZVectorHelper.FaceForward(constref A, B : TGLZVector4f) : TGLZVector4f;assembler; register; nostackframe;
asm
  movaps   xmm0, [RCX]
  movaps   xmm1, [A]
  movaps   xmm2, [B]
  xorps    xmm3, xmm3
 // movups   xmm4, [RIP+cSSE_MASK_NEGATE]

  // Dotproduct(A, B)
  mulps  xmm2, xmm1
  {$IFDEF USE_ASM_SSE_3}
     movshdup    xmm1, xmm2
     addps       xmm2, xmm1
     movhlps     xmm1, xmm2
     addss       xmm2, xmm1
  {$ELSE}
     movhlps xmm1, xmm2
     addps xmm1, xmm2
     shufps xmm2, xmm2, 00000001b
     addps xmm2, xmm1
  {$ENDIF}
  cmpnltps xmm2, xmm3 // >= 0?  Yes: $FFFFFFFF, No: $00000000
  andps    xmm2, [RIP+cSSE_MASK_NEGATE] //xmm4 // Yes: $80000000, No: $00000000
  xorps    xmm0, xmm2   // Flip sign >= 0
  movaps   [RDX], xmm0
end;

function TGLZVectorHelper.Step(ConstRef B : TGLZVector4f) : TGLZVector4f;assembler; register; nostackframe;
asm
  movaps xmm1, [RCX]
  movaps xmm0, xmm1
  cmpnleps xmm1, XMMWORD PTR [B] //xmm1
  andps xmm1, XMMWORD PTR [RIP+cOneVector4f]
  //andps xmm0, xmm1
  mulps xmm0,xmm1
  movaps   [RDX], xmm0
end;

function TGLZVectorHelper.Saturate : TGLZVector4f;assembler; register; nostackframe;
asm
  movaps xmm0, [RCX]
  minps xmm0,[RIP+cOneVector4f]
  maxps xmm0,[RIP+cNullVector4f]
  movaps   [RDX], xmm0
end;

function TGLZVectorHelper.SmoothStep(ConstRef A, B : TGLZVector4f) : TGLZVector4f; assembler; register; nostackframe;
Const
  cVecSet2 : TGLZVector4f = (x:2.0;y:2.0;z:2.0;w:2.0);
  cVecSet3 : TGLZVector4f = (x:3.0;y:3.0;z:3.0;w:3.0);
  //cVecSet6 : TGLZVector4f = (x:6.0;y:6.0;z:6.0;w:6.0);
asm
  movaps xmm0, [RCX]
  //Saturate((self-a)/(b-a))
  movaps xmm1, [A]
  subps xmm0, xmm1
  movaps xmm2, [B]
  subps xmm2, xmm1
  divps xmm0,xmm2
  { Approximation
  rcpps xmm2,xmm1
  mulps xmm0, xmm2
  }
  minps xmm0,[RIP+cOneVector4f]
  maxps xmm0,[RIP+cNullVector4f]

  //result :=t*t * ((t*2.0)*3.0)  // = t^2 * 6t = 6t^3
  movaps xmm1,xmm0
  mulps xmm0, xmm0
  mulps xmm1, [RIP+cVecSet2]
  mulps xmm1, [RIP+cVecSet3]
  mulps xmm0, xmm1
  //mulps xmm0,[RIP+cVecSet3]
  //mulps xmm0,xmm0
  //mulps xmm0,xmm0
  //mulps xmm0,Xmm0
  movaps   [RDX], xmm0
end;

