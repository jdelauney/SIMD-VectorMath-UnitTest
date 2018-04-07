{%region%----[ Operators ]--------------------------------------------------------}

class operator TGLZVector2d.+(constref A, B: TGLZVector2d): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [A]
  movapd xmm1, [B]
  addpd  xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector2d.-(constref A, B: TGLZVector2d): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [A]
  movapd xmm1, [B]
  subpd  xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector2d.*(constref A, B: TGLZVector2d): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [A]
  movapd xmm1, [B]
  mulpd  xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector2d.*(constref A: TGLZVector2d; constref B : TGLZVector2i): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd   xmm0, [A]
  cvtdq2pd xmm2, [B]
  mulpd    xmm0, xmm2
  movhlps xmm1, xmm0
end;

class operator TGLZVector2d./(constref A, B: TGLZVector2d): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [A]
  movapd xmm1, [B]
  divpd  xmm0, xmm1
  movhlps xmm1, xmm0
end;

(* The 4 for above functions are pit of doom for performances, so we use native instead

class operator TGLZVector2d.+(constref A: TGLZVector2d; constref B:Double): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [A]
  movq   xmm1, [B]
  shufpd xmm1, xmm1, $00
  addpd  xmm0, xmm1
  movapd [Result], xmm0
end;

class operator TGLZVector2d.-(constref A: TGLZVector2d; constref B:Double): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [A]
  movq   xmm1, [B]
  shufpd xmm1, xmm1, $00
  subpd  xmm0, xmm1
  movapd [Result], xmm0
end;

class operator TGLZVector2d.*(constref A: TGLZVector2d; constref B:Double): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [A]
  movq   xmm1, [B]
  shufpd xmm1, xmm1, $00
  //movhps xmm1, [B]
  //movlps xmm1, [B]
  mulpd  xmm0, xmm1
  movapd [Result], xmm0
end;

class operator TGLZVector2d./(constref A: TGLZVector2d; constref B:Double): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [A]
  movq xmm1, [B]
  shufpd xmm1, xmm1, $00
  divpd  xmm0, xmm1
  movapd [Result], xmm0
end; *)

class operator TGLZVector2d./(constref A: TGLZVector2d; constref B:TGLZVector2i): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd   xmm0, [A]
  cvtdq2pd xmm1, [B]
  divpd    xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector2d.+(constref A: TGLZVector2d; constref B: TGLZVector2i): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd   xmm0, [A]
  cvtdq2pd xmm1, [B]
  addpd    xmm0, xmm1
  movhlps xmm1, xmm0
end;

class operator TGLZVector2d.-(constref A: TGLZVector2d; constref B: TGLZVector2i): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd   xmm0, [A]
  cvtdq2pd xmm1, [B]
  subpd    xmm0, xmm1
  movhlps xmm1, xmm0
end;
{%endregion%}

{%region%----[ Functions ]--------------------------------------------------------}

function TGLZVector2d.Min(constref B: Double): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [RDI]
  movq   xmm1, [B]
  shufpd xmm1, xmm1, $00
  minpd  xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector2d.Min(constref B: TGLZVector2d): TGLZVector2d; assembler; nostackframe; register;
asm
  movapd xmm0, [RDI]
  movapd xmm1, [B]
  minpd  xmm0, xmm1
  movhlps xmm1, xmm0
end;


function TGLZVector2d.Max(constref B: Double): TGLZVector2d;Assembler; nostackframe;register;
asm
  movapd xmm0, [RDI]
  movq   xmm1, [B]
  shufpd xmm1, xmm1, $00
  maxpd  xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector2d.Max(constref B: TGLZVector2d): TGLZVector2d;Assembler; nostackframe;register;
asm
  movapd xmm0, [RDI]
  movapd xmm1, [B]
  maxpd  xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector2d.Clamp(constref AMin, AMax: Double): TGLZVector2d;Assembler; nostackframe;register;
asm
  movapd xmm0, [RDI]
  movq   xmm1, [AMin]
  movq   xmm2, [AMax]
  shufpd xmm1, xmm1, $00 // Replicate AMin
  shufpd xmm2, xmm2, $00 // Replicate AMax
  maxpd  xmm0, xmm1
  minpd  xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector2d.Clamp(constref AMin, AMax: TGLZVector2d): TGLZVector2d;Assembler; nostackframe;register;
asm
  movapd xmm0, [RDI]
  movapd xmm1, [AMin]
  movapd xmm2, [AMax]
  maxpd  xmm0, xmm1
  minpd  xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector2d.MulAdd(constref A,B:TGLZVector2d): TGLZVector2d;Assembler; nostackframe;register;
asm
  movapd xmm0, [RDI]
  movapd xmm1, {%H-}[A]
  movapd xmm2, {%H-}[B]
  Mulpd  xmm0, xmm1
  Addpd  xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector2d.MulSub(constref A,B:TGLZVector2d): TGLZVector2d;Assembler; nostackframe;register;
asm
  movapd xmm0, [RDI]
  movapd xmm1, [A]
  movapd xmm2, [B]
  Mulpd  xmm0, xmm1
  Subpd  xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector2d.MulDiv(constref A,B:TGLZVector2d): TGLZVector2d;Assembler;nostackframe;register;
asm
  movapd xmm0, [RDI]
  movapd xmm1, [A]
  movapd xmm2, [B]
  Mulpd  xmm0, xmm1
  Divpd  xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector2d.Length:Double;Assembler;nostackframe;register;
asm
  movapd xmm0, [RDI]
  mulpd  xmm0, xmm0
  haddpd xmm0, xmm0
  //movddup xmm1, xmm0
  //addpd    xmm0, xmm1
  sqrtsd   xmm0, xmm0
end;

function TGLZVector2d.LengthSquare:Double;Assembler;nostackframe;register;
asm
  movapd xmm0, [RDI]
  mulpd  xmm0, xmm0
  haddpd xmm0, xmm0
  //movddup xmm1, xmm0
  //addpd    xmm0, xmm1
end;

function TGLZVector2d.Distance(constref A:TGLZVector2d):Double;Assembler;nostackframe;register;
asm
  movapd xmm0, [RDI]
  movapd xmm1, [A]
  subpd  xmm0, xmm1
  mulpd  xmm0, xmm0
  haddpd xmm0, xmm0
  //movddup xmm1, xmm0
  //addpd    xmm0, xmm1
  sqrtsd   xmm0, xmm0
end;

function TGLZVector2d.DistanceSquare(Constref A:TGLZVector2d):Double;Assembler;nostackframe;register;
asm
  movapd xmm0, [RDI]
  movapd xmm1, [A]
  subpd  xmm0, xmm1
  mulpd  xmm0, xmm0
  haddpd xmm0, xmm0
  //movddup xmm1, xmm0
  //addpd    xmm0, xmm1
end;

function TGLZVector2d.Normalize : TGLZVector2d;Assembler;nostackframe;register;
asm
  movapd xmm2, [RDI]
  movapd xmm0, xmm2
  mulpd  xmm2, xmm2
  haddpd xmm2, xmm2
  sqrtpd xmm2, xmm2
  divpd  xmm0, xmm2
  movhlps xmm1, xmm0
end;

// function Reflect(I, NRef : TVector2f):TVector2f
function TGLZVector2d.Round: TGLZVector2i;assembler;nostackframe;register;
asm
  // Rounding mode defaults to round-to-nearest
  movapd   xmm0, [RDI]

  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00000000                    // Set bits

  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtpd2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax

  movq     rax, xmm0
end;

function TGLZVector2d.Abs: TGLZVector2d; assembler; nostackframe; register;
asm
  movapd   xmm0, [RDI]
  andpd    xmm0, XMMWORD PTR [RIP+cSSE_MASK_ABS]//xmm1
  movhlps xmm1, xmm0
end;


function TGLZVector2d.Trunc: TGLZVector2i;assembler;//nostackframe;register;
asm
  movapd   xmm0, [RDI]
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00006000                    // Set bits
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtpd2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax
  movq     rax, xmm0
end;

function TGLZVector2d.Floor : TGLZVector2i; assembler;//nostackframe;register;
asm
  movapd   xmm0, [RDI]
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00002000;                    // Set bits Round Mask Down
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtpd2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax
  movq   rax, xmm0
end;

function TGLZVector2d.Ceil : TGLZVector2i; assembler;//nostackframe;register;
asm
  movapd   xmm0, [RDI]
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00004000;                    // Set bits Round Mask up
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtpd2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax
  movq     rax, xmm0
end;

// NOT WORKING GIVE WRONG RESULT. It return the entire part  :(

//function TGLZVector2d.Fract: TGLZVector2d; assembler;//nostackframe;register;
//asm
//  movapd   xmm0, [RDI]
//  movapd   xmm1, xmm0
//  push     rax                               // create a mem area for mxcsr
//  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
//  mov      eax, DWORD PTR [rsp]              // get it
//  mov      ecx, eax                          // make local copy   self is done with at this point
//  // smaller opcode no mem access required.
//  and      eax, $00009FFF
//  or       eax, $00006000                    // Set bits
//  mov      DWORD PTR [rsp], eax              // mov bits to mem
//  ldmxcsr  DWORD PTR [rsp]                   // set new bits
//  cvtpd2dq xmm0, xmm0
//  mov      DWORD PTR [rsp], ecx              // put old bits in mem
//  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
//  pop      rax
//  cvtdq2pd xmm0, xmm0
//  subpd    xmm1, xmm0 // A - Trunc(A)
//  movq     rdx, xmm1
//end;

function TGLZVector2d.Sqrt: TGLZVector2d; assembler;nostackframe;register;
asm
  movapd xmm0,[RDI]
  sqrtpd xmm0, xmm0
  movhlps xmm1, xmm0
end;

//function TGLZVector2d.InvSqrt: TGLZVector2d; assembler;nostackframe;register;
//asm
//  movapd   xmm0,[RDI]
//  //rsqrtpd  xmm0, xmm0
//  movapd   [Result], xmm0
//end;

function TGLZVector2d.ModF(Constref A : TGLZVector2d): TGLZVector2d; assembler;nostackframe;register;
asm
  movapd   xmm0, [RDI]
  movapd   xmm1, xmm0
  movapd   xmm2, [A]
  divpd    xmm0, xmm2
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00006000                   // Set bits
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtpd2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax
  cvtdq2pd xmm0, xmm0
  mulpd    xmm0, xmm2
  subpd    xmm1, xmm0 // A - Trunc(A)
  movapd   xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector2d.fMod(Constref A : TGLZVector2d): TGLZVector2i; assembler;nostackframe;register;
asm
  movapd   xmm0, [RDI]
  movapd   xmm1, xmm0
  movapd   xmm2, [A]

  divpd    xmm0, xmm2
  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00002000                    // Set bits
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtpd2dq xmm0, xmm0
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax

  cvtdq2pd xmm0, xmm0
  mulpd    xmm0, xmm2
  subpd    xmm1, xmm0 // A - Trunc(A)

  push     rax                               // create a mem area for mxcsr
  stmxcsr  DWORD PTR [rsp]                   //  store mxcsr
  mov      eax, DWORD PTR [rsp]              // get it
  mov      ecx, eax                          // make local copy   self is done with at this point
  // smaller opcode no mem access required.
  and      eax, $00009FFF
  or       eax, $00006000                   // Set bits
  mov      DWORD PTR [rsp], eax              // mov bits to mem
  ldmxcsr  DWORD PTR [rsp]                   // set new bits
  cvtpd2dq xmm1, xmm1
  mov      DWORD PTR [rsp], ecx              // put old bits in mem
  ldmxcsr  DWORD PTR [rsp]                   // Pop rounding mode
  pop      rax

  movq rax,{%H-}xmm1
end;

{%endregion%}