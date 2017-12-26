function TGLZVectorHelper.PointProject(constref origin, direction : TGLZVector) : Single; assembler; register; nostackframe;
asm
  movaps xmm0, [RDI]
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
//  movss [RESULT], {%H-}xmm0
end;

function TGLZVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector): TGLZVector; assembler; register; nostackframe;
asm
  movaps xmm1, [RDI] // cen

  //VectorSubtract(up^,cen^,s{%H-});
  movaps xmm2, [up]   //s
  subps xmm2, xmm1
  //VectorSubtract(left^,cen^,t{%H-});
  movaps xmm3, [left]  //t
  subps xmm3, xmm1
  //VectorSubtract(down^,cen^,u{%H-});
  movaps xmm4, [down]   //u
  subps xmm4, xmm1
  //VectorSubtract(right^,cen^,v{%H-});
  movaps xmm5, [right]  //v
  subps xmm5, xmm1

  movaps xmm0, [RIP+cSSE_MASK_NO_W]
  andps xmm2, xmm0
  andps xmm3, xmm0
  andps xmm4, xmm0
  andps xmm5, xmm0
                                   // state for result
  //------------------------------------
  // X := s.Y*t.Z,    1*-0.34
  // Y := s.Z*t.X,    -0.34 * -1
  // Z := s.X*t.Y     0 * 0
  // S =   ,x,z,Y
  // T =  -,y,x,z
  movaps xmm6,xmm2
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm3
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7


  // X := s.Z*t.Y
  // Y := s.X*t.Z
  // Z := s.Y*t.X
  // S =   w,y,x,z
  // t = from -,y,x,z to -,x,z,y
  shufps xmm7, xmm7, 11010010b
  movaps xmm8, xmm2
  shufps xmm8, xmm8, 11010010b
  mulps xmm7,xmm8

  subps xmm6,xmm7
  movaps xmm0, xmm6
  //-------------------------------------
  // same again for t and u
  //------------------------------------
  // X := t.Y*u.Z,
  // Y := t.Z*u.X,
  // Z := t.X*u.Y
  // T =   w,z,y,x
  // U = * -,x,z,y
  movaps xmm6,xmm3
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm4
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7

  // X := t.Z*u.Y
  // Y := t.X*u.Z
  // Z := t.Y*u.X
  // T =   w,z,y,x
  // U = * -,y,x,z
  shufps xmm7, xmm7, 11010010b
  movaps xmm8, xmm3
  shufps xmm8, xmm8, 11010010b
  mulps xmm7,xmm8

  subps xmm6,xmm7
  addps xmm0, xmm6

  //-------------------------------------
  // same again for u and v
  //------------------------------------
  // X := u.Y*v.Z,
  // Y := u.Z*v.X,
  // Z := u.X*v.Y
  // U =   w,z,y,x
  // V = * -,x,z,y
  movaps xmm6,xmm4
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm5
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7

  // X := u.Z*v.Y
  // Y := u.X*v.Z
  // Z := u.Y*v.X
  // U =   w,z,y,x
  // V = * -,y,x,z
  shufps xmm7, xmm7, 11010010b
  movaps xmm8, xmm4
  shufps xmm8, xmm8, 11010010b
  mulps xmm7,xmm8

  subps xmm6,xmm7
  addps xmm0, xmm6

  //-------------------------------------
  // same again for v and s
  //------------------------------------
  // X := v.Y*s.Z,
  // Y := v.Z*s.X,
  // Z := v.X*s.Y
  // V =   w,z,y,x
  // S = * -,x,z,y
  movaps xmm6,xmm5
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm2
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7

  // X := v.Z*s.Y
  // Y := v.X*s.Z
  // Z := v.Y*s.X
  // V =   w,z,y,x
  // S = * -,y,x,z
  shufps xmm7, xmm7, 11010010b
  movaps xmm8, xmm5
  shufps xmm8, xmm8, 11010010b
  mulps xmm7,xmm8

  subps xmm6,xmm7
  addps xmm0, xmm6

  //  xmm0        =      xmm6       +        xmm7         +         xmm8        +         xmm2
  //Result.X := (s.Y*t.Z - s.Z*t.Y) + (t.Y*u.Z - t.Z*u.Y) + (u.Y*v.Z - u.Z*v.Y) + (v.Y*s.Z - v.Z*s.Y);
  //Result.Y := (s.Z*t.X - s.X*t.Z) + (t.Z*u.X - t.x*u.Z) + (u.Z*v.X - u.X*v.Z) + (v.Z*s.X - v.X*s.Z);
  //Result.Z := (s.X*t.Y - s.Y*t.X) + (t.X*u.Y - t.Y*u.X) + (u.X*v.Y - u.Y*v.X) + (v.X*s.Y - v.Y*s.X);

  movaps xmm2, xmm0
  mulps xmm0, xmm0
  movaps xmm1, xmm0
  shufps xmm0, xmm1, $4e
  addps xmm0, xmm1
  movaps xmm1, xmm0
  shufps xmm1, xmm1, $11
  addps xmm0, xmm1
  sqrtps xmm0, xmm0
  divps xmm2, xmm0
  movaps xmm0, xmm2
  movhlps xmm1,xmm0
end;








