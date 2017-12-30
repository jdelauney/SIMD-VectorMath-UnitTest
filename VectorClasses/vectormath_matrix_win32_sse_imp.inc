
{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZMatrix4.+(constref A, B: TGLZMatrix4): TGLZMatrix4; assembler;
asm
  movups xmm0, [A]$00   // Load 4 rows of A  //0
  movups xmm1, [A]$10                        //16
  movups xmm2, [A]$20                        //32
  movups xmm3, [A]$30                        //48
  movups xmm4, [B]$00   // Load 2 rows of B
  movups xmm5, [B]$10
  addps  xmm0, xmm4     // Add rows
  addps  xmm1, xmm5
  movups xmm4, [B]$20   // Load 2 rows of B
  movups xmm5, [B]$30
  addps  xmm2, xmm4     // Add rows
  addps  xmm3, xmm5
  movups [Result]$00, xmm0
  movups [Result]$10, xmm1
  movups [Result]$20, xmm2
  movups [Result]$30, xmm3
end;

class operator TGLZMatrix4.-(constref A, B: TGLZMatrix4): TGLZMatrix4; assembler;
asm
  movups xmm0, [A]$00
  movups xmm1, [A]$10
  movups xmm2, [A]$20
  movups xmm3, [A]$30
  movups xmm4, [B]$00
  movups xmm5, [B]$10
  subps  xmm0, xmm4
  subps  xmm1, xmm5
  movups xmm4, [B]$20
  movups xmm5, [B]$30
  subps  xmm2, xmm4
  subps  xmm3, xmm5
  movups [Result]$00, xmm0
  movups [Result]$10, xmm1
  movups [Result]$20, xmm2
  movups [Result]$30, xmm3
end;

class operator TGLZMatrix4.+(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; assembler;
asm
  movups xmm0, [A]$00     // Load 4 rows
  movups xmm1, [A]$10
  movups xmm2, [A]$20
  movups xmm3, [A]$30
  movss  xmm4, [B]
  shufps xmm4, xmm4, 0    // Replicate B

  addps  xmm0, xmm4       // Add B to each row
  addps  xmm1, xmm4
  addps  xmm2, xmm4
  addps  xmm3, xmm4

  movups [Result]$00, xmm0
  movups [Result]$10, xmm1
  movups [Result]$20, xmm2
  movups [Result]$30, xmm3
end;

class operator TGLZMatrix4.-(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; assembler;
asm
  movups xmm0, [A]$00
  movups xmm1, [A]$10
  movups xmm2, [A]$20
  movups xmm3, [A]$30
  movss  xmm4, [B]
  shufps xmm4, xmm4, 0

  subps  xmm0, xmm4
  subps  xmm1, xmm4
  subps  xmm2, xmm4
  subps  xmm3, xmm4

  movups [Result]$00, xmm0
  movups [Result]$10, xmm1
  movups [Result]$20, xmm2
  movups [Result]$30, xmm3
end;

class operator TGLZMatrix4.*(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; assembler;
asm
  movups xmm0, [A]$00
  movups xmm1, [A]$10
  movups xmm2, [A]$20
  movups xmm3, [A]$30
  movss  xmm4, [B]
  shufps xmm4, xmm4, 0

  mulps  xmm0, xmm4
  mulps  xmm1, xmm4
  mulps  xmm2, xmm4
  mulps  xmm3, xmm4

  movups [Result]$00, xmm0
  movups [Result]$10, xmm1
  movups [Result]$20, xmm2
  movups [Result]$30, xmm3
end;

// https://github.com/WojciechMula/toys/blob/master/sse/sse-matvecmult.c
class operator TGLZMatrix4.*(constref A: TGLZMatrix4; constref B: TGLZVector4f): TGLZVector4f; assembler;
asm
  movups   xmm0, [B]      // Load vector
  movups   xmm4, [A]$00   // Load 1st row
  movaps   xmm1, xmm0
  movaps   xmm2, xmm0
  movaps   xmm3, xmm0
  movups   xmm5, [A]$10  // Load 2nd row
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
  movups   [Result], xmm0
end;


// https://stackoverflow.com/questions/18499971/efficient-4x4-matrix-multiplication-c-vs-assembly
// http://www.mindfruit.co.uk/2012/02/avx-matrix-multiplication-or-something.html
// https://stackoverflow.com/questions/14967969/efficient-4x4-matrix-vector-multiplication-with-sse-horizontal-add-and-dot-prod
class operator TGLZMatrix4.*(constref A, B: TGLZMatrix4): TGLZMatrix4; assembler;
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
  movups xmm0, [A]$00
  movups xmm4, [B]$00
  movaps xmm1, xmm0
  movaps xmm2, xmm0
  movaps xmm3, xmm0
  shufps xmm0, xmm0, $00
  shufps xmm1, xmm1, $55
  shufps xmm2, xmm2, $AA
  shufps xmm3, xmm3, $FF
  movups xmm5, [B]$10
  movups xmm6, [B]$20
  movups xmm7, [B]$30
  mulps  xmm0, xmm4
  mulps  xmm1, xmm5
  mulps  xmm2, xmm6
  mulps  xmm3, xmm7
  addps  xmm0, xmm1
  addps  xmm2, xmm3
  addps  xmm0, xmm2
  movups [Result]$00, xmm0

  { A.V[1] * B }
  movups xmm0, [A]$10
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
  movups [Result]$10, xmm0

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
  movups xmm0, [A]$30
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
  movups [Result]$30, xmm0
end;

class operator TGLZMatrix4./(constref A: TGLZMatrix4; constref B: Single): TGLZMatrix4; assembler;
asm
  movups xmm0, [A]$00
  movups xmm1, [A]$10
  movups xmm2, [A]$20
  movups xmm3, [A]$30
  movss  xmm4, [B]
  shufps xmm4, xmm4, 0

  divps  xmm0, xmm4
  divps  xmm1, xmm4
  divps  xmm2, xmm4
  divps  xmm3, xmm4

  movups [Result]$00, xmm0
  movups [Result]$10, xmm1
  movups [Result]$20, xmm2
  movups [Result]$30, xmm3
end;

class operator TGLZMatrix4.-(constref A: TGLZMatrix4): TGLZMatrix4; assembler;
asm
  movups xmm0, [cSSE_MASK_NEGATE]  // Load mask with 4 sign (upper) bits
  movups xmm1, [A]$00 // Load 4 rows
  movups xmm2, [A]$10
  movups xmm3, [A]$20
  movups xmm4, [A]$30
  xorps  xmm1, xmm0             // Flip sign bits of each element in each row
  xorps  xmm2, xmm0
  xorps  xmm3, xmm0
  xorps  xmm4, xmm0
  movups [Result]$00, xmm1
  movups [Result]$10, xmm2
  movups [Result]$20, xmm3
  movups [Result]$30, xmm4
end;

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

function TGLZMatrix4.Multiply(constref M2: TGLZMatrix4):TGLZMatrix4;assembler;
asm
   movups xmm0, [EAX]$00   // Self[0]
   movups xmm1, [EAX]$10   // Self[1]
   movups xmm2, [EAX]$20   // Self[2]
   movups xmm3, [EAX]$30   // Self[3]

   movups xmm4, [M2]$00
   movups xmm5, [M2]$10
   movups xmm6, [M2]$20
   movups xmm7, [M2]$30
   // Component-wise multiplication
   mulps  xmm0, xmm4
   mulps  xmm1, xmm5
   mulps  xmm2, xmm6
   mulps  xmm3, xmm7

   movups [Result]$00, xmm0
   movups [Result]$10, xmm1
   movups [Result]$20, xmm2
   movups [Result]$30, xmm3
end;

// https://www.gamedev.net/forums/topic/621951-sse-4x4-matrix-transpose-and-invert/
// http://www.mersenneforum.org/showthread.php?t=17555
// https://github.com/floodyberry/supercop/blob/master/crypto_hash/groestl512/avx/groestl-asm-avx.h
function TGLZMatrix4.Transpose:TGLZMatrix4; assembler;
asm
  {$ifdef TEST}
    movlps     xmm1, [EAX]
    movlps     xmm3, [EAX]8
    movhps     xmm1, [EAX]16
    movhps     xmm3, [EAX]24
    movlps     xmm5, [EAX]32
    movlps     xmm4, [EAX]40
    movhps     xmm5, [EAX]48
    movhps     xmm4, [EAX]56
    movaps     xmm0, xmm1
    movaps     xmm2, xmm3
    shufps     xmm1, xmm5, $DD
    shufps     xmm3, xmm4, $DD
    shufps     xmm0, xmm5, $88
    shufps     xmm2, xmm4, $88
    movups [EAX]$00, xmm0
    movups [EAX]$10, xmm1 //16
    movups [EAX]$20, xmm2 //32
    movups [EAX]$30, xmm3 //48
  {$else}
    movups   xmm0, [EAX]$00  // A03 A02 A01 A00
    movups   xmm1, [EAX]$10 // A13 A12 A11 A10
    movups   xmm2, [EAX]$20 // A23 A22 A21 A20
    movups   xmm3, [EAX]$30 // A33 A32 A31 A30

    movaps   xmm4, xmm2
    unpcklps xmm2, xmm3               // A31 A21 A30 A20
    unpckhps xmm4, xmm3               // A33 A23 A32 A22

    movaps   xmm3, xmm0
    unpcklps xmm0, xmm1               // A11 A01 A10 A00
    unpckhps xmm3, xmm1               // A13 A03 A12 A02

    movaps   xmm1, xmm0
    unpcklpd xmm0, xmm2               // A30 A20 A10 A00
    unpckhpd xmm1, xmm2               // A31 A21 A11 A01

    movaps   xmm2, xmm3
    unpcklpd xmm2, xmm4               // A32 A22 A12 A02
    unpckhpd xmm3, xmm4               // A33 A23 A13 A03

    movups  [RESULT]$00, xmm0
    movups  [RESULT]$10, xmm1
    movups  [RESULT]$20, xmm2
    movups  [RESULT]$30, xmm3
  {$endif}
end;

// Translated from DirectXMathMatrix.nl
function TGLZMatrix4.GetDeterminant : Single; assembler;
asm

(*
  movaps xmm0, [EAX]$00
  movaps xmm1, [EAX]$10
  movaps xmm2, [EAX]$20
  movaps xmm3, [EAX]$30

  movaps xmm4,xmm2
  shufps xmm4,xmm4,00000001b
  movaps xmm5, xmm4

  movaps xmm6, xmm2
  shufps xmm6, xmm6, 01011111b

  movaps xmm7, xmm3
  shufps xmm7, xmm7, 01011111b

  movaps xmm8, xmm3
  shufps xmm8, xmm8, 10111111b
  movaps xmm9, xmm8

  mulps xmm4, xmm7
  mulps xmm5, xmm8
  mulps xmm6, xmm8

  movaps xmm7, xmm2
  shufps xmm7, xmm7, 01011010b

  movaps xmm8, xmm3
  shufps xmm8, xmm8, 00000001b

  movaps xmm10, xmm2
  shufps xmm10, xmm10, 10111111b
  movaps xmm11, xmm10

  movaps xmm12, xmm3
  shufps xmm12, xmm12, 01011111b

  mulps xmm7, xmm8
  subps xmm4, xmm7
  mulps xmm10, xmm8
  subps xmm5, xmm10
  mulps xmm11, xmm12
  subps xmm6, xmm11

  movaps xmm7, xmm1
  movaps xmm8, xmm1
  movaps xmm9, xmm1
  shufps xmm7, xmm7, 10111111b
  shufps xmm8, xmm8, 01011010b
  shufps xmm9, xmm9, 00000001b

  movaps xmm10, xmm0
  mulps xmm10, [RIP+cNegateVector4f_PNPN]

  mulps xmm4, xmm7

  mulps xmm5, xmm8
  subps xmm4, xmm5

  mulps xmm6, xmm9
  addps xmm4, xmm6

  // Dot
  {$IFDEF USE_ASM_SSE_4}
     dpps xmm10, xmm4, 01110001b //or $F1
     movss [RESULT], {%H-}xmm0
  {$ELSE}
    {$IFDEF USE_ASM_SSE_3}
       andps xmm10, [RIP+cSSE_MASK_NO_W]
       mulps xmm4, xmm10
       {$ifdef TEST}
         movshdup    xmm4, xmm10
         addps       xmm10, xmm4
         movhlps     xmm4, xmm10
         addss       xmm10, xmm4
       {$else}
         haddps xmm0, xmm0
         haddps xmm0, xmm0
       {$endif}
        movss [RESULT], {%H-}xmm10
    {$ELSE}
      movaps xmm0,[EAX]
      movaps xmm1, [A]
      andps xmm10, [RIP+cSSE_MASK_NO_W]
      mulps  xmm10, xmm4
      movhlps xmm4, xmm10
      addps xmm4, xmm10
      shufps xmm10, xmm10, 00000001b
      addps xmm10, xmm4
      movss [RESULT], {%H-}xmm10
    {$ENDIF}
  {$ENDIF}

*)
movss [result], xmm0  ////dummy
end;

Function TGLZMatrix4.Translate(constref V : TGLZVector) : TGLZMatrix4; assembler;
asm
   //Self.W.X:=Self.W.X+v.X;
   //Self.W.Y:=Self.W.Y+v.Y;
   //Self.W.Z:=Self.W.Z+v.Z;
  movups xmm2, [EAX]$00
  movups xmm3, [EAX]$10
  movups xmm4, [EAX]$20
  movups xmm0, [EAX]$30
  movaps xmm1, [V]
  andps  xmm1, [cSSE_MASK_NO_W]
  addps  xmm0, xmm1
  movups [RESULT]$00, xmm2
  movups [RESULT]$10, xmm3
  movups [RESULT]$20, xmm4
  movups [RESULT]$30, xmm0
end;

// https://software.intel.com/en-us/articles/optimized-matrix-library-for-use-with-the-intel-pentiumr-4-processors-sse2-instructions/
// https://lxjk.github.io/2017/09/03/Fast-4x4-Matrix-Inverse-with-SSE-SIMD-Explained.html

(* Function TGLZMatrix4.Invert : TGLZMatrix4; assembler;  myfirst try but is wrong
asm
// Convert from Intel Math Lib
// https://software.intel.com/en-us/articles/optimized-matrix-library-for-use-with-the-intel-pentiumr-4-processors-sse2-instructions/
// The inverse is calculated using "Divide and Conquer" technique. The
// original matrix is divide into four 2x2 sub-matrices. Since each
// register holds four matrix element, the smaller matrices are
// represented as a registers. Hence we get a better locality of the calculations.

  movaps xmm0, [EAX]$00
  movaps xmm1, [EAX]$10
  movaps xmm2, [EAX]$20
  movaps xmm3, [EAX]$30

  movlhps xmm0, xmm1  //A
  movhlps xmm1, xmm0  //B
  movlhps xmm2, xmm3  //C
  movhlps xmm3, xmm2  //D
   //  AB = A# * B
  movaps xmm4, xmm0  //xmm4 = AB
  shufps xmm4, xmm4, $0F
  mulps  xmm4, xmm1
  movaps xmm8, xmm0
  shufps xmm8, xmm8, $A5
  movaps xmm5,xmm1
  shufps xmm5, xmm5, $4E
  mulps  xmm8, xmm5
  subps  xmm4, xmm8
  //  DC = D# * C
  movaps xmm5, xmm3  //xmm5 = DC
  shufps xmm5, xmm5, $0F
  mulps  xmm5, xmm2
  movaps xmm8, xmm3
  shufps xmm8, xmm8, $A5
  movaps xmm6,xmm2
  shufps xmm6, xmm6, $4E
  mulps  xmm8, xmm6
  subps  xmm5, xmm8
  //  dA = |A|
  movaps xmm6, xmm0 //xmm6 = dA
  shufps xmm6, xmm6, $5F
  mulps  xmm6, xmm0
  //  dB = |B|
  movaps xmm7, xmm1 //xmm7 = dB
  shufps xmm7, xmm7, $5F
  mulps  xmm7, xmm1
  //  dC = |C|
  movaps xmm8, xmm2 //xmm8 = dC
  shufps xmm8, xmm8, $5F
  mulps  xmm8, xmm2
  //  dD = |D|
  movaps xmm9, xmm3 //xmm9 = dC
  shufps xmm9, xmm9, $5F
  mulps  xmm9, xmm3
  //  d = trace(AB*DC) = trace(A#*B*D#*C)
  movaps xmm10,xmm5 //xmm10 = d
  shufps xmm10, xmm10, $D8
  mulps xmm10,xmm4
  //  iD = C*A#*B
  movaps xmm11, xmm2  //xmm11 = iD
  shufps xmm11, xmm11, $A0
  movaps xmm12,xmm4
  movlhps xmm12, xmm4
  mulps xmm11, xmm12
  movaps xmm12, xmm2
  shufps xmm12, xmm12, $F5
  movhlps xmm4, xmm4
  mulps xmm12, xmm4
  subps xmm11, xmm12
  //  iA = B*D#*C
  movaps xmm12, xmm1  //xmm12 = iA
  shufps xmm12, xmm12, $A0
  movaps xmm13,xmm5
  movlhps xmm13, xmm5
  mulps xmm12, xmm13
  movaps xmm13, xmm1
  shufps xmm13, xmm13, $F5
  movhlps xmm5, xmm5
  mulps xmm13, xmm5
  subps xmm12, xmm13
  //  d = trace(AB*DC) = trace(A#*B*D#*C)
  movaps xmm15, xmm10
  movhlps xmm10,xmm10
  addps xmm10,xmm15
  //d = _mm_add_ss(d, _mm_shuffle_ps(d, d, 1));  ???????? correct or not
  shufps xmm15, xmm15, 1
  addss xmm10, xmm15
  //  iD = D*|A| - C*A#*B --> iD = D*_mm_shuffle_ps(dA,dA,0) - iD;
  movaps xmm13, xmm3
  movaps xmm14, xmm6
  shufps xmm14, xmm14, $00
  mulps  xmm13,xmm14
  subps xmm13, xmm11 //xmm13 = iD
  //  iA = A*|D| - B*D#*C --> iA = A*_mm_shuffle_ps(dD,dD,0) - iA;
  movaps xmm14, xmm0
  movaps xmm15, xmm9
  shufps xmm15, xmm15, $00
  mulps  xmm15,xmm15
  subps xmm14, xmm12 //xmm14 = iA
  //d1 = dA*dD;
  //d2 = dB*dC;
  movaps xmm11, xmm6 //xmm11 = d1
  mulps xmm11,xmm9
  movaps xmm12, xmm7 //xmm12 = d2
  mulps xmm12,xmm8
  //  det = |A|*|D| + |B|*|C| - trace(A#*B*D#*C)
  addps xmm4,xmm5
  subps xmm4, xmm10
  movaps xmm10, [RIP+cOneVector4f]
  divps xmm10, xmm4  //xmm10 =rd
  //rcpps xmm5, xmm4

  //  iB = D * (A#B)# = D*B#*A
  movaps xmm6,xmm3
  movaps xmm9,xmm4
  shufps xmm9,xmm9,$33
  mulps xmm6,xmm9
  shufps xmm3,xmm3,$B1
  shufps xmm4,xmm4,$66
  mulps xmm3,xmm4
  subps xmm6,xmm3 //xmm6 = iB
  //  iC = A * (D#C)# = A*C#*D
  movaps xmm11,xmm0
  movaps xmm9,xmm8
  shufps xmm9,xmm9,$33
  mulps xmm11,xmm9
  shufps xmm0,xmm0,$B1
  shufps xmm5,xmm5,$66
  mulps xmm0,xmm5
  subps xmm11,xmm0 //xmm11 = iC

  shufps xmm10, xmm10,$00
  xorps xmm10, [RIP+cSSE_SIGN_MASK_PNNP]

  //  iB = C*|B| - D*B#*A
  shufps xmm7,xmm7,$00
  mulps xmm2,xmm7
  subps xmm2, xmm6 //xmm2 =iB
  //  iC = B*|C| - A*C#*D;
  shufps xmm8,xmm8,$00
  mulps xmm1, xmm8
  subps xmm1,xmm11 //xmm1 = iC

  //  iX = iX / det
  mulps xmm14, xmm10
  mulps xmm2 , xmm10
  mulps xmm11, xmm10
  mulps xmm13, xmm10

  movaps xmm0, xmm14
  movaps xmm1, xmm11
  shufps xmm0, xmm2,$77
  movaps [RESULT]$00, xmm0
  shufps xmm14, xmm2,$22
  movaps [RESULT]$10, xmm14
  shufps xmm1, xmm13,$77
  movaps [RESULT]$20, xmm1
  shufps xmm11, xmm13,$22
  movaps [RESULT]$30, xmm11


end; *)
{  Code Gen GCC 7.2 with https://gcc.godbolt.org/ from this :

#include <immintrin.h>

float Inverse(__m128 *_L1, __m128 *_L2,__m128 *_L3,__m128 *_L4)

    // The inverse is calculated using "Divide and Conquer" technique. The
    // original matrix is divide into four 2x2 sub-matrices. Since each
    // register holds four matrix element, the smaller matrices are
    // represented as a registers. Hence we get a better locality of the
    // calculations.

    __m128
           A =_mm_movelh_ps(*_L1, *_L2),    // the four sub-matrices
           B =_mm_movehl_ps(*_L2, *_L1),
           C =_mm_movelh_ps(*_L3, *_L4),
           D =_mm_movehl_ps(*_L4, *_L3);

    __m128 iA, iB, iC, iD,					// partial inverse of the sub-matrices
            DC, AB;
    __m128 dA, dB, dC, dD;                 // determinant of the sub-matrices
    __m128 det, d, d1, d2;
    __m128 rd;

    //  AB = A# * B
    AB = _mm_mul_ps(_mm_shuffle_ps(A,A,0x0F), B);
    AB -= (__m128)_mm_mul_ps(_mm_shuffle_ps(A,A,0xA5), _mm_shuffle_ps(B,B,0x4E));
    //  DC = D# * C
    DC = _mm_mul_ps(_mm_shuffle_ps(D,D,0x0F), C);
    DC -= (__m128)_mm_mul_ps(_mm_shuffle_ps(D,D,0xA5), _mm_shuffle_ps(C,C,0x4E));

    //  dA = |A|
    dA = _mm_mul_ps(_mm_shuffle_ps(A, A, 0x5F),A);
    dA = _mm_sub_ss(dA, _mm_movehl_ps(dA,dA));
    //  dB = |B|
    dB = _mm_mul_ps(_mm_shuffle_ps(B, B, 0x5F),B);
    dB = _mm_sub_ss(dB, _mm_movehl_ps(dB,dB));

    //  dC = |C|
    dC = _mm_mul_ps(_mm_shuffle_ps(C, C, 0x5F),C);
    dC = _mm_sub_ss(dC, _mm_movehl_ps(dC,dC));
    //  dD = |D|
    dD = _mm_mul_ps(_mm_shuffle_ps(D, D, 0x5F),D);
    dD = _mm_sub_ss(dD, _mm_movehl_ps(dD,dD));

    //  d = trace(AB*DC) = trace(A#*B*D#*C)
    d = _mm_mul_ps(_mm_shuffle_ps(DC,DC,0xD8),AB);

    //  iD = C*A#*B
    iD = _mm_mul_ps(_mm_shuffle_ps(C,C,0xA0), _mm_movelh_ps(AB,AB));
    iD += (__m128)_mm_mul_ps(_mm_shuffle_ps(C,C,0xF5), _mm_movehl_ps(AB,AB));
    //  iA = B*D#*C
    iA = _mm_mul_ps(_mm_shuffle_ps(B,B,0xA0), _mm_movelh_ps(DC,DC));
    iA += (__m128)_mm_mul_ps(_mm_shuffle_ps(B,B,0xF5), _mm_movehl_ps(DC,DC));

    //  d = trace(AB*DC) = trace(A#*B*D#*C) [continue]
    d = _mm_add_ps(d, _mm_movehl_ps(d, d));
    d = _mm_add_ss(d, _mm_shuffle_ps(d, d, 1));
    d1 = dA*dD;
    d2 = dB*dC;

    //  iD = D*|A| - C*A#*B
    iD = D*_mm_shuffle_ps(dA,dA,0) - iD;

    //  iA = A*|D| - B*D#*C;
    iA = A*_mm_shuffle_ps(dD,dD,0) - iA;

    //  det = |A|*|D| + |B|*|C| - trace(A#*B*D#*C)
    det = d1+d2-d;
    rd = (__m128)((1.0f)/det);
    //rd =det;
    #ifdef ZERO_SINGULAR
        rd = _mm_and_ps(_mm_cmpneq_ss(det,_mm_setzero_ps()), rd);
    #endif

    //  iB = D * (A#B)# = D*B#*A
    iB = _mm_mul_ps(D, _mm_shuffle_ps(AB,AB,0x33));
    iB -= (__m128)_mm_mul_ps(_mm_shuffle_ps(D,D,0xB1), _mm_shuffle_ps(AB,AB,0x66));
    //  iC = A * (D#C)# = A*C#*D
    iC = _mm_mul_ps(A, _mm_shuffle_ps(DC,DC,0x33));
    iC -= (__m128)_mm_mul_ps(_mm_shuffle_ps(A,A,0xB1), _mm_shuffle_ps(DC,DC,0x66));

    rd = _mm_shuffle_ps(rd,rd,0);
    //rd ^= Sign_PNNP;

    //  iB = C*|B| - D*B#*A
    iB = C*_mm_shuffle_ps(dB,dB,0) - iB;

    //  iC = B*|C| - A*C#*D;
    iC = B*_mm_shuffle_ps(dC,dC,0) - iC;

    //  iX = iX / det
    iA *= rd;
    iB *= rd;
    iC *= rd;
    iD *= rd;

    *_L1 = _mm_shuffle_ps(iA,iB,0x77);
    *_L2 = _mm_shuffle_ps(iA,iB,0x22);
    *_L3 = _mm_shuffle_ps(iC,iD,0x77);
    *_L4 = _mm_shuffle_ps(iC,iD,0x22);

    return *(float*)&det;

//Note  Xmm0 = Determinant
}

Function TGLZMatrix4.Invert : TGLZMatrix4; assembler;
asm
  // Convert from Intel Math Lib
  // https://software.intel.com/en-us/articles/optimized-matrix-library-for-use-with-the-intel-pentiumr-4-processors-sse2-instructions/
  // The inverse is calculated using "Divide and Conquer" technique. The
  // original matrix is divide into four 2x2 sub-matrices. Since each
  // register holds four matrix element, the smaller matrices are
  // represented as a registers. Hence we get a better locality of the calculations.
{
  movups  xmm12,[RDI]$00
  //movaps  xmm1, XMMWORD PTR [RCX]$10
  // movaps  xmm1, XMMWORD PTR [RCX+$10]
  movups  xmm1, [RDI]$10
  movhps  xmm12, QWORD PTR [RDI]$10
  movups  xmm2, [RDI]$30
  movlps  xmm1, QWORD PTR [RDI]$20+8
  movaps  xmm4, xmm12
  movaps  xmm5, xmm12
  movups  xmm3, [RDI]$20
  movaps  xmm0, xmm1
  shufps  xmm5, xmm12, 165
  shufps  xmm4, xmm12, 15
  movhps  xmm2, QWORD PTR [RDI]
  shufps  xmm0, xmm1, 78
  mulps   xmm4, xmm1
  movlps  xmm3, QWORD PTR [RDI]$30+8
  movaps  xmm9, xmm1
  mulps   xmm0, xmm5
  movaps  xmm6, xmm3
  movaps  xmm5, xmm3
  shufps  xmm9, xmm1, 95
  shufps  xmm6, xmm3, 165
  shufps  xmm5, xmm3, 15
  mulps   xmm5, xmm2
  movaps  xmm8, xmm2
  shufps  xmm8, xmm2, 95
  movsldup        xmm14, xmm2
  mulps   xmm9, xmm1
  mulps   xmm8, xmm2
  subps   xmm4, xmm0
  movaps  xmm0, xmm2
  shufps  xmm0, xmm2, 78
  movshdup        xmm13, xmm2
  mulps   xmm0, xmm6
  movsldup        xmm15, xmm1
  movaps  xmm10, xmm4
  movlhps xmm10, xmm4
  subps   xmm5, xmm0
  mulps   xmm10, xmm14
  movaps  xmm0, xmm12
  shufps  xmm0, xmm12, 95
  movshdup        xmm14, xmm1
  mulps   xmm0, xmm12
  movaps  xmm6, xmm0
  movhlps xmm6, xmm0
  subss   xmm0, xmm6
  movaps  xmm6, xmm9
  movhlps xmm6, xmm9
  subss   xmm9, xmm6
  movaps  xmm6, xmm8
  movhlps xmm6, xmm8
  subss   xmm8, xmm6
  movaps  xmm6, xmm3
  shufps  xmm6, xmm3, 95
  mulps   xmm6, xmm3
  movaps  xmm7, xmm6
  movhlps xmm7, xmm6
  subss   xmm6, xmm7
  movaps  xmm7, xmm4
  movhlps xmm7, xmm4
  mulps   xmm7, xmm13
  movaps  xmm13, xmm5
  movaps  xmm11, xmm6
  movlhps xmm13, xmm5
  movaps  xmm6, xmm5
  shufps  xmm6, xmm5, 216
  mulps   xmm13, xmm15
  mulps   xmm6, xmm4
  addps   xmm7, xmm10
  movaps  xmm10, xmm5
  movhlps xmm10, xmm5
  mulps   xmm10, xmm14
  addps   xmm13, xmm10
  movaps  xmm10, xmm6
  movhlps xmm10, xmm6
  addps   xmm6, xmm10
  movaps  xmm10, xmm6
  shufps  xmm10, xmm6, 1
  addss   xmm6, xmm10
  movaps  xmm10, xmm6
  movaps  xmm6, xmm0
  shufps  xmm6, xmm0, 0
  mulps   xmm6, xmm3
  mulps   xmm0, xmm11
  subps   xmm6, xmm7
  movaps  xmm7, xmm11
  shufps  xmm7, xmm11, 0
  mulps   xmm7, xmm12
  movaps  xmm11, xmm9
  shufps  xmm9, xmm9, 0
  mulps   xmm11, xmm8
  shufps  xmm8, xmm8, 0
  mulps   xmm2, xmm9
  mulps   xmm1, xmm8
  subps   xmm7, xmm13
  movaps  xmm13, xmm4
  addps   xmm0, xmm11
  movaps  xmm11, xmm3
  shufps  xmm13, xmm4, 51
  shufps  xmm4, xmm4, 102
  shufps  xmm11, xmm3, 177
  mulps   xmm3, xmm13
  mulps   xmm11, xmm4
  movaps  xmm4, xmm5
  subps   xmm0, xmm10
  movaps  xmm10, [RIP+cOneVector4f] // XMMWORD PTR [RIP+cOneVector4f]
  shufps  xmm4, xmm5, 51
  shufps  xmm5, xmm5, 102
  mulps   xmm4, xmm12
  divps   xmm10, xmm0
  subps   xmm3, xmm11
  movaps  xmm11, xmm12
  shufps  xmm11, xmm12, 177
  mulps   xmm5, xmm11
  subps   xmm2, xmm3
  subps   xmm4, xmm5
  subps   xmm1, xmm4
  shufps  xmm10, xmm10, 0
  xorps   xmm10, [RIP+cSSE_SIGN_MASK_PNNP]
  mulps   xmm7, xmm10
  mulps   xmm2, xmm10
  mulps   xmm1, xmm10
  mulps   xmm10, xmm6
  movaps  xmm3, xmm7
  shufps  xmm3, xmm2, 119
  shufps  xmm7, xmm2, 34
  movaps  [RDI]$00, xmm3
  movaps  xmm2, xmm1
  movaps  [RDI]$10, xmm7
  shufps  xmm2, xmm10, 119
  shufps  xmm1, xmm10, 34
  movaps  [RDI]$30, xmm2
  movaps  [RDI]$20, xmm1
}
end;

(*function TGLZMatrix4.Normalize:TGLZMatrix4; assembler;
asm


 movaps  [RCX]$30, [RIP+WHmgVector]
end; *)

function TGLZMatrix4.Normalize:TGLZMatrix4;
begin
   result :=self;
   Result.X.W:=0;
   Result.X.Normalize;
   Result.Y.W:=0;
   Result.Y.Normalize;
   Result.Z:=Result.X.CrossProduct(Result.Y);
   Result.X:=Result.Y.CrossProduct(Result.Z);
   Result.W:=WHmgVector;
end;

{%endregion%}


{%region%-----[ TODO  ]---------------------------------------------------------}

{
function TGLZMatrix4.MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single; assembler;
asm
end;

procedure TGLZMatrix4.Transpose_Scale_M33(constref src : TGLZMatrix4; Constref ascale : Single); assembler;
asm
end;

procedure TGLZMatrix4.CreateLookAtMatrix(const eye, center, normUp: TGLZVector); assembler;
asm
end;
procedure TGLZMatrix4.CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single); assembler;
asm
end;
procedure TGLZMatrix4.CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single); assembler;
asm
end;
procedure TGLZMatrix4.CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single); assembler;
asm
end;
procedure TGLZMatrix4.CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i); assembler;
asm
end;


procedure TGLZMatrix4.CreateParallelProjectionMatrix(const plane : TGLZHmgPlane; const dir : TGLZVector); assembler;
asm
end;


procedure TGLZMatrix4.CreateShadowMatrix(const planePoint, planeNormal, lightPos : TGLZVector); assembler;
asm
end;

procedure TGLZMatrix4.CreateReflectionMatrix(const planePoint, planeNormal : TGLZVector); assembler;
asm
end;

procedure TGLZMatrix4.Adjoint; assembler;
asm
end;
procedure TGLZMatrix4.AnglePreservingMatrixInvert(constref mat : TGLZMatrix4); assembler;
asm
end;

function TGLZMatrix4.Decompose(var Tran: TGLZMatrixTransformations): Boolean; assembler;
asm
end;

}
{%endregion%}



