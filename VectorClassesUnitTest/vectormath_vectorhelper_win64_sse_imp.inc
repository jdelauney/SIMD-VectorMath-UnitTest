function TGLZVectorHelper.PointProject(constref origin, direction : TGLZVector) : Single;assembler;
asm
  movaps xmm0, [RCX]
  movaps xmm1, [Origin]
  movaps xmm2, [Direction]
  subps xmm0, xmm1
  mulps xmm0, xmm2
  andps xmm0, [RIP+cSSE_MASK_NO_W]
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  shufps xmm0, xmm0, 00000000b
  shufps xmm1, xmm1, 01010101b
  shufps xmm2, xmm2, 10101010b
  addss xmm0,xmm1
  addss xmm0,xmm2
  movss [RESULT], {%H-}xmm0
end;

function TGLZVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector4f): TGLZVector; assembler; //register; nostackframe;
asm
  movaps xmm2, [RCX] //s
  movaps xmm3, xmm2   //t
  movaps xmm4, xmm2   //u
  movaps xmm5, xmm2   //v

  //VectorSubtract(up^,cen^,s{%H-});
  movaps xmm1, [up]
  subps xmm2, xmm1
  //VectorSubtract(left^,cen^,t{%H-});
  movaps xmm1, [left]
  subps xmm3, xmm1
  //VectorSubtract(down^,cen^,u{%H-});
  movaps xmm1, [down]
  subps xmm4, xmm1
  //VectorSubtract(right^,cen^,v{%H-});
  movaps xmm1, [right]
  subps xmm5, xmm1

  movaps xmm0, [RIP+cSSE_MASK_NO_W]
  andps xmm2, xmm0
  andps xmm3, xmm0
  andps xmm4, xmm0
  andps xmm5, xmm0

  //------------------------------------
  // S*T  (xmm2*xmm3)
  //------------------------------------
  // X := s.Y*t.Z,
  // Y := s.Z*t.X,
  // Z := s.X*t.Y
  // S =   w,z,y,x
  // T = * -,x,z,y
  shufps xmm6, xmm3, 11001001b
  mulps xmm6,xmm2

  // X := s.Z*t.Y
  // Y := s.X*t.Z
  // Z := s.Y*t.X
  // S =   w,z,y,x
  // t = * -,y,x,z
  shufps xmm7, xmm3, 11010010b
  mulps xmm7,xmm2
  subps xmm6,xmm7
  movaps xmm0, xmm6

  //-------------------------------------
  // T*U  (xmm3*xmm4)
  //-------------------------------------
  // X :=t.Y*u.Z
  // Y :=t.Z*u.X
  // Z :=t.X*u.Y
  // T =   w,z,y,x
  // U = * -,x,z,y
  shufps xmm7, xmm4, 11001001b
  mulps xmm7,xmm3

  // X := t.Z*u.Y
  // Y := t.x*u.Z
  // Z := t.Y*u.X
  // S =   w,z,y,x
  // t = * -,y,x,z
  shufps xmm6, xmm4, 11010010b
  mulps xmm6,xmm3
  subps xmm7,xmm6
  //movaps xmm7, xmm6

  //-------------------------------------
  // U*V (xmm4*xmm5)
  //-------------------------------------
  // X := u.Y*v.Z
  // Y := u.Z*v.X,
  // Z := u.X*v.Y
  // U =   w,z,y,x
  // V = * -,x,z,y
  shufps xmm8, xmm5, 11001001b
  mulps xmm8,xmm4

  // X := u.Z*v.Y
  // Y := u.X*v.Z
  // Z := u.Y*v.X
  // U =   w,z,y,x
  // V = * -,y,x,z
  shufps xmm6, xmm5, 11010010b
  mulps xmm6,xmm4
  subps xmm8,xmm6
  //movaps xmm7, xmm6
  //-------------------------------------

  //-------------------------------------
  // V*S (xmm5*xmm2)
  //-------------------------------------
  // X := v.Y*s.Z
  // Y := v.Z*s.X
  // Z := v.X*s.Y
  // V =   w,z,y,x
  // S = * -,x,z,y
  shufps xmm9, xmm2, 11001001b
  mulps xmm9,xmm5

  // X := u.Z*v.Y
  // Y := u.X*v.Z
  // Z := u.Y*v.X
  // V =   w,z,y,x
  // S = * -,y,x,z
  shufps xmm6, xmm2, 11010010b
  mulps xmm6,xmm5
  subps xmm9,xmm6
  //movaps xmm7, xmm6
  //-------------------------------------
  //  xmm0        =      xmm6       +        xmm7         +         xmm8        +         xmm9
  //Result.X := (s.Y*t.Z - s.Z*t.Y) + (t.Y*u.Z - t.Z*u.Y) + (u.Y*v.Z - u.Z*v.Y) + (v.Y*s.Z - v.Z*s.Y);
  //Result.Y := (s.Z*t.X - s.X*t.Z) + (t.Z*u.X - t.x*u.Z) + (u.Z*v.X - u.X*v.Z) + (v.Z*s.X - v.X*s.Z);
  //Result.Z := (s.X*t.Y - s.Y*t.X) + (t.X*u.Y - t.Y*u.X) + (u.X*v.Y - u.Y*v.X) + (v.X*s.Y - v.Y*s.X);

 (* shufps xmm0, xmm0, 11011000b  //Y Z X W
  shufps xmm7, xmm7, 11011000b
  shufps xmm8, xmm8, 11011000b
  shufps xmm9, xmm9, 11011000b *)

  addps xmm0,xmm7
  addps xmm0,xmm8
  addps xmm0,xmm9

  movaps [RESULT], xmm0
  //movhlps xmm1,xmm0
end;


