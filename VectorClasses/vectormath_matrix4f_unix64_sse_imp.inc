
{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZMatrix4f.+(constref A, B: TGLZMatrix4f): TGLZMatrix4f; assembler;
asm
  movaps xmm0, [A]$00   // Load 4 rows of A  //0
  movaps xmm1, [A]$10                        //16
  movaps xmm2, [A]$20                        //32
  movaps xmm3, [A]$30                        //48
  movaps xmm4, [B]$00   // Load 2 rows of B
  movaps xmm5, [B]$10
  addps  xmm0, xmm4     // Add rows
  addps  xmm1, xmm5
  movaps xmm4, [B]$20   // Load 2 rows of B
  movaps xmm5, [B]$30
  addps  xmm2, xmm4     // Add rows
  addps  xmm3, xmm5
  movaps [Result]$00, xmm0
  movaps [Result]$10, xmm1
  movaps [Result]$20, xmm2
  movaps [Result]$30, xmm3
end;

class operator TGLZMatrix4f.-(constref A, B: TGLZMatrix4f): TGLZMatrix4f; assembler;
asm
  movaps xmm0, [A]$00
  movaps xmm1, [A]$10
  movaps xmm2, [A]$20
  movaps xmm3, [A]$30
  movaps xmm4, [B]$00
  movaps xmm5, [B]$10
  subps  xmm0, xmm4
  subps  xmm1, xmm5
  movaps xmm4, [B]$20
  movaps xmm5, [B]$30
  subps  xmm2, xmm4
  subps  xmm3, xmm5
  movaps [Result]$00, xmm0
  movaps [Result]$10, xmm1
  movaps [Result]$20, xmm2
  movaps [Result]$30, xmm3
end;

class operator TGLZMatrix4f.+(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; assembler;
asm
  movaps xmm0, [A]$00     // Load 4 rows
  movaps xmm1, [A]$10
  movaps xmm2, [A]$20
  movaps xmm3, [A]$30
  movss  xmm4, [B]
  shufps xmm4, xmm4, 0    // Replicate B

  addps  xmm0, xmm4       // Add B to each row
  addps  xmm1, xmm4
  addps  xmm2, xmm4
  addps  xmm3, xmm4

  movaps [Result]$00, xmm0
  movaps [Result]$10, xmm1
  movaps [Result]$20, xmm2
  movaps [Result]$30, xmm3
end;

class operator TGLZMatrix4f.-(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; assembler;
asm
  movaps xmm0, [A]$00
  movaps xmm1, [A]$10
  movaps xmm2, [A]$20
  movaps xmm3, [A]$30
  movss xmm4, [B]
  shufps xmm4, xmm4, 0

  subps  xmm0, xmm4
  subps  xmm1, xmm4
  subps  xmm2, xmm4
  subps  xmm3, xmm4

  movaps [Result]$00, xmm0
  movaps [Result]$10, xmm1
  movaps [Result]$20, xmm2
  movaps [Result]$30, xmm3
end;

class operator TGLZMatrix4f.*(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; assembler;
asm
  movaps xmm0, [A]$00
  movaps xmm1, [A]$10
  movaps xmm2, [A]$20
  movaps xmm3, [A]$30
  movss xmm4, [B]
  shufps xmm4, xmm4, 0

  mulps  xmm0, xmm4
  mulps  xmm1, xmm4
  mulps  xmm2, xmm4
  mulps  xmm3, xmm4

  movaps [Result]$00, xmm0
  movaps [Result]$10, xmm1
  movaps [Result]$20, xmm2
  movaps [Result]$30, xmm3
end;

// https://github.com/WojciechMula/toys/blob/master/sse/sse-matvecmult.c
class operator TGLZMatrix4f.*(constref A: TGLZMatrix4f; constref B: TGLZVector4f): TGLZVector4f; assembler;
asm
  movaps   xmm0, [B]      // Load vector
  movaps   xmm4, [A]$00   // Load 1st row
  movaps   xmm1, xmm0
  movaps   xmm2, xmm0
  movaps   xmm3, xmm0
  movaps   xmm5, [A]$10  // Load 2nd row
  mulps    xmm0, xmm4    // (Bx * A00), (By * A01), (Bz * A02), (Bw * A03)
  mulps    xmm1, xmm5    // (Bx * A10), (By * A11), (Bz * A12), (Bw * A13)
  movups   xmm4, [A]$20  // Load 3rd row
  movups   xmm5, [A]$30  // Load 4st row
  mulps    xmm2, xmm4    // (Bx * A20), (By * A21), (Bz * A22), (Bw * A23)
  mulps    xmm3, xmm5    // (Bx * A30), (By * A31), (Bz * A32), (Bw * A33)

  { Transpose }
  movaps   xmm4, xmm2
  unpcklps xmm2, xmm3    // A32 A22 A33 A23
  unpckhps xmm4, xmm3    // A30 A20 A31 A21

  movaps   xmm3, xmm0
  unpcklps xmm0, xmm1    // A12 A02 A13 A03
  unpckhps xmm3, xmm1    // A10 A00 A11 A01

  movaps   xmm1, xmm0
  unpcklpd xmm0, xmm2    // A33 A23 A13 A03
  unpckhpd xmm1, xmm2    // A32 A22 A12 A02

  movaps   xmm2, xmm3
  unpcklpd xmm2, xmm4    // A31 A21 A11 A01
  unpckhpd xmm3, xmm4    // A30 A20 A10 A00

  addps    xmm0, xmm1    // Add rows
  addps    xmm2, xmm3
  addps    xmm0, xmm2
  movaps   [Result], xmm0
end;


class operator TGLZMatrix4f./(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f; assembler;
asm
  movaps xmm0, [A]$00
  movaps xmm1, [A]$10
  movaps xmm2, [A]$20
  movaps xmm3, [A]$30
  movss xmm4, [B]
  shufps xmm4, xmm4, 0

  divps  xmm0, xmm4
  divps  xmm1, xmm4
  divps  xmm2, xmm4
  divps  xmm3, xmm4

  movaps [Result]$00, xmm0
  movaps [Result]$10, xmm1
  movaps [Result]$20, xmm2
  movaps [Result]$30, xmm3
end;

class operator TGLZMatrix4f.-(constref A: TGLZMatrix4f): TGLZMatrix4f; assembler;
asm
  movaps xmm0, [RIP+cSSE_MASK_NEGATE]  // Load mask with 4 sign (upper) bits
  movaps xmm1, [A]$00 // Load 4 rows
  movaps xmm2, [A]$10
  movaps xmm3, [A]$20
  movaps xmm4, [A]$30
  xorps  xmm1, xmm0             // Flip sign bits of each element in each row
  xorps  xmm2, xmm0
  xorps  xmm3, xmm0
  xorps  xmm4, xmm0
  movaps [Result]$00, xmm1
  movaps [Result]$10, xmm2
  movaps [Result]$20, xmm3
  movaps [Result]$30, xmm4
end;


// https://stackoverflow.com/questions/18499971/efficient-4x4-matrix-multiplication-c-vs-assembly
// http://www.mindfruit.co.uk/2012/02/avx-matrix-multiplication-or-something.html
// https://stackoverflow.com/questions/14967969/efficient-4x4-matrix-vector-multiplication-with-sse-horizontal-add-and-dot-prod
class operator TGLZMatrix4f.*(constref A, B: TGLZMatrix4f): TGLZMatrix4f; assembler;
{ Code below consists of 4 Vector*Matrix calculations }
asm
(*  snip from gcc
"movaps   (%0), %%xmm0\n"c	/* xmm0 = pRight[0..3] */
"movaps 16(%0), %%xmm1\n"	/* xmm1 = pRight[5..7] */
"movaps 32(%0), %%xmm2\n"	/* xmm2 = pRight[8..11] */
"movaps 48(%0), %%xmm3\n"	/* xmm3 = pRight[12..15] */

/* Processes 1/2 of the matrix at a time (2x4), unrolled loop */
"movss    (%1), %%xmm4\n"
"movss   4(%1), %%xmm6\n"
"movss  16(%1), %%xmm5\n"
"movss  20(%1), %%xmm7\n"
"shufps $0x00, %%xmm4, %%xmm4\n"
"shufps $0x00, %%xmm5, %%xmm5\n"
"shufps $0x00, %%xmm6, %%xmm6\n"
"shufps $0x00, %%xmm7, %%xmm7\n"
"mulps %%xmm0, %%xmm4\n"
"mulps %%xmm0, %%xmm5\n"
"mulps %%xmm1, %%xmm6\n"
"mulps %%xmm1, %%xmm7\n"
"addps %%xmm7, %%xmm5\n"
"addps %%xmm6, %%xmm4\n"


"movss  8(%1), %%xmm6\n"
"movss 24(%1), %%xmm7\n"
"shufps $0x00, %%xmm6, %%xmm6\n"
"shufps $0x00, %%xmm7, %%xmm7\n"
"mulps %%xmm2, %%xmm6\n"
"mulps %%xmm2, %%xmm7\n"
"addps %%xmm6, %%xmm4\n"
"addps %%xmm7, %%xmm5\n"

"movss  12(%1), %%xmm6\n"
"movss  28(%1), %%xmm7\n"
"shufps $0x00, %%xmm6, %%xmm6\n"
"shufps $0x00, %%xmm7, %%xmm7\n"
"mulps %%xmm3, %%xmm6\n"
"mulps %%xmm3, %%xmm7\n"
"addps %%xmm6, %%xmm4\n"
"addps %%xmm7, %%xmm5\n"

"movaps %%xmm4, (%1)\n"
"movaps %%xmm5, 16(%1)\n"

/* second half of the matrix */
"movss  32(%1), %%xmm4\n"
"movss  36(%1), %%xmm6\n"
"movss  48(%1), %%xmm5\n"
"movss  52(%1), %%xmm7\n"
"shufps $0x00, %%xmm4, %%xmm4\n"
"shufps $0x00, %%xmm5, %%xmm5\n"
"mulps %%xmm0, %%xmm4\n"
"mulps %%xmm0, %%xmm5\n"

"shufps $0x00, %%xmm6, %%xmm6\n"
"shufps $0x00, %%xmm7, %%xmm7\n"
"mulps %%xmm1, %%xmm6\n"
"mulps %%xmm1, %%xmm7\n"
"addps %%xmm6, %%xmm4\n"
"addps %%xmm7, %%xmm5\n"


"movss 40(%1), %%xmm6\n"
"movss 56(%1), %%xmm7\n"
"shufps $0x00, %%xmm6, %%xmm6\n"
"shufps $0x00, %%xmm7, %%xmm7\n"
"mulps %%xmm2, %%xmm6\n"
"mulps %%xmm2, %%xmm7\n"
"addps %%xmm6, %%xmm4\n"
"addps %%xmm7, %%xmm5\n"

"movss  44(%1), %%xmm6\n"
"movss  60(%1), %%xmm7\n"
"shufps $0x00, %%xmm6, %%xmm6\n"
"shufps $0x00, %%xmm7, %%xmm7\n"
"mulps %%xmm3, %%xmm6\n"
"mulps %%xmm3, %%xmm7\n"
"addps %%xmm6, %%xmm4\n"
"addps %%xmm7, %%xmm5\n"

"movaps %%xmm4, 32(%1)\n"
"movaps %%xmm5, 48(%1)\n"
*)

  { A.V[0] * B }
  movaps xmm0, [A]$00
  movaps xmm4, [B]$00
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  movaps xmm5, [B]$10
  movaps xmm6, [B]$20
  movaps xmm7, [B]$30
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movaps [Result]$00, xmm0

  { A.V[1] * B }
  movaps xmm0, [A]$10
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movaps [Result]$10, xmm0

  { A.V[2] * B }
  movups xmm0, [A]$20
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups [Result]$20, xmm0

  { A.V[3] * B }
  movaps xmm0, [A]$30
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movaps [Result]$30, xmm0
end;


//{%region%-----[ TODO  ]---------------------------------------------------------}


{%endregion%}



