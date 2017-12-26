unit averagenormal_code;

{$mode objfpc}{$H+}
{$MODESWITCH ADVANCEDRECORDS}
{$ASMMODE INTEL}


{$IFDEF USE_ASM_SSE_4}
  {$DEFINE USE_ASM_SSE_3}
{$ENDIF}
// In case of
{$IFDEF USE_ASM_SSE_3}
  {$DEFINE USE_ASM}
{$ENDIF}

{$IFDEF USE_ASM_AVX}
  {$DEFINE USE_ASM}
{$ENDIF}

{$DEFINE USE_ASM_SIMD_HIGHPRECISION}

interface

uses
  Classes, SysUtils, native, GLZVectorMath;


type


  TNativeHelper = record helper for TNativeGLZVector4f
  public
    function AverageNormal4(constref up, left, down, right: TNativeGLZVector4f): TNativeGLZVector4f;
  end;


  { TVectorHelper }

  TVectorHelper = record helper for TGLZVector4f
  public
      function AverageNormal4(constref up, left, down, right: TGLZVector4f): TGLZVector4f;
  end;


implementation

{ TVectorHelper }
{$CODEALIGN CONSTMIN=16}
const
cSSE_MASK_NO_W   : array [0..3] of UInt32 = ($FFFFFFFF, $FFFFFFFF, $FFFFFFFF, $00000000);

{$ifdef USE_ASM}
{$ifdef UNIX}
{%region%--------[ Unix 64 ]----------------------------------------------------}
  {$ifdef CPU64}
    {$IFDEF USE_ASM_AVX}
 {Code for vectormath_vector_unix64_avx_imp.inc}
function TVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector4f): TGLZVector4f; assembler; register; nostackframe;
asm
{$ifdef TEST}
    vmovaps xmm2, [RDI]
    vsubps xmm2, xmm2, [up]
    vmovaps xmm3, [RDI]
    vsubps xmm3, xmm3, [left]
    vmovaps xmm4, [RDI]
    vsubps xmm4, xmm4, [down]
    vmovaps xmm5, [RDI]
    vsubps xmm5, xmm5, [right]

    vshufps xmm6, xmm2, xmm2, 11001001b
    vshufps xmm8, xmm2, xmm2, 11010010b
    vshufps xmm7, xmm3, xmm3, 11010010b
    vshufps xmm9, xmm3, xmm3, 11001001b
    vshufps xmm10, xmm3, xmm3, 11001001b
    vshufps xmm12, xmm3, xmm3, 11010010b
    vshufps xmm13, xmm4, xmm4, 11001001b
    vshufps xmm11, xmm4, xmm4, 11010010b

    vmulps  xmm0, xmm6, xmm7
    vmulps  xmm8, xmm8, xmm9
    vmulps  xmm10, xmm10, xmm11
    vmulps  xmm12, xmm12, xmm13
    vsubps xmm0, xmm0, xmm8

    vsubps xmm10, xmm10, xmm12

    vaddps xmm0, xmm0, xmm10
    vshufps xmm6, xmm4, xmm4, 11001001b
    vshufps xmm7, xmm5, xmm5, 11010010b
    vshufps xmm8, xmm4, xmm4, 11010010b
    vshufps xmm9, xmm5, xmm5, 11001001b


    vshufps xmm10, xmm5, xmm5, 11001001b
    vshufps xmm11, xmm2, xmm2, 11010010b
    vshufps xmm12, xmm5, xmm5, 11010010b
    vshufps xmm13, xmm2, xmm2, 11001001b

    vmulps  xmm6, xmm6, xmm7
    vmulps  xmm8, xmm8, xmm9
    vmulps  xmm10, xmm10, xmm11
    vmulps  xmm12, xmm12, xmm13

    vaddps xmm0, xmm0, xmm6
    vsubps xmm0, xmm0, xmm8
    vaddps xmm0, xmm0, xmm10
    vsubps xmm0, xmm0, xmm12

    vmovaps xmm2, xmm0
    vmulps xmm0, xmm0, xmm0
    vhaddps xmm0, xmm0, xmm0
    vhaddps xmm0, xmm0, xmm0

    vsqrtps xmm0, xmm0
    vdivps xmm0, xmm2, xmm0
    movhlps xmm1,xmm0
 {$else}
    vmovups xmm1, [RDI]
    vmovups xmm2, [up]
    vsubps xmm2, xmm2, xmm1
    vmovups xmm3, [left]
    vsubps xmm3, xmm3, xmm1
    vmovups xmm4, [down]
    vsubps xmm4, xmm4, xmm1
    vmovups xmm5, [right]
    vsubps xmm5, xmm5, xmm1

    vmovups xmm0, [RIP+cSSE_MASK_NO_W]
    vandps xmm2, xmm2, xmm0
    vandps xmm3, xmm3, xmm0
    vandps xmm4, xmm4, xmm0
    vandps xmm5, xmm5, xmm0

    vshufps xmm6, xmm2, xmm2, 11001001b
    vshufps xmm7, xmm3, xmm3, 11010010b
    vmulps  xmm6, xmm6, xmm7

    vshufps xmm7, xmm7, xmm7, 11010010b
    vshufps xmm1, xmm2, xmm2, 11010010b
    vmulps  xmm7, xmm7, xmm1

    vsubps xmm0, xmm6, xmm7

    vshufps xmm6, xmm3, xmm3, 11001001b
    vshufps xmm7, xmm4, xmm4, 11010010b
    vmulps  xmm6, xmm6, xmm7

    vshufps xmm7, xmm7, xmm7, 11010010b
    vshufps xmm1, xmm3, xmm3, 11010010b
    vmulps  xmm7, xmm7, xmm1

    vsubps xmm6, xmm6, xmm7
    vaddps xmm0, xmm0, xmm6

    vshufps xmm6, xmm4, xmm4, 11001001b
    vshufps xmm7, xmm5, xmm5, 11010010b
    vmulps  xmm6, xmm6, xmm7

    vshufps xmm7, xmm7, xmm7, 11010010b
    vshufps xmm1, xmm4, xmm4, 11010010b
    vmulps  xmm7, xmm7, xmm1

    vsubps xmm6, xmm6, xmm7
    vaddps xmm0, xmm0, xmm6

    vshufps xmm6, xmm5, xmm5, 11001001b
    vshufps xmm7, xmm2, xmm2, 11010010b
    vmulps  xmm6, xmm6, xmm7

    vshufps xmm7, xmm7, xmm7, 11010010b
    vshufps xmm1, xmm5, xmm5, 11010010b
    vmulps  xmm7, xmm7, xmm1

    vsubps xmm6, xmm6, xmm7
    vaddps xmm0, xmm0, xmm6

    vmovaps xmm2, xmm0
    vmulps xmm0, xmm0, xmm0
    vhaddps xmm0, xmm0, xmm0
    vhaddps xmm0, xmm0, xmm0

    vsqrtps xmm0, xmm0
    vdivps xmm0, xmm2, xmm0

    movhlps xmm1, xmm0
 {$endif}
end;
    {$ELSE}
 {Code for vectormath_vector_unix64_sse_imp.inc}
function TVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector4f): TGLZVector4f; assembler; register; nostackframe;
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
  // t = from -,y,x,z -,x,z,y
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
    {$ENDIF}
{%endregion}
{$else}
{%region%--------[ Unix 32 ]----------------------------------------------------}
    {$IFDEF USE_ASM_AVX}
 {Code for vectormath_vector_unix32_avx_imp.inc}
function TVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector4f): TGLZVector4f; assembler; register;
asm
  vmovups xmm1, [EAX]

  vmovups xmm2, [up]          //in edx
  vsubps xmm2, xmm2, xmm1
  vmovups xmm3, [left]        //in ecx
  vsubps xmm3, xmm3, xmm1
  mov ebx, [down]
  vmovups xmm4, [ebx]
  vsubps xmm4, xmm4, xmm1
  mov ebx, [right]
  vmovups xmm5, [ebx]
  vsubps xmm5, xmm5, xmm1

  vmovups xmm0, [cSSE_MASK_NO_W]
  vandps xmm2, xmm2, xmm0
  vandps xmm3, xmm3, xmm0
  vandps xmm4, xmm4, xmm0
  vandps xmm5, xmm5, xmm0

  vshufps xmm6, xmm2, xmm2, 11001001b
  vshufps xmm7, xmm3, xmm3, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm2, xmm2, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm0, xmm6, xmm7

  vshufps xmm6, xmm3, xmm3, 11001001b
  vshufps xmm7, xmm4, xmm4, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm3, xmm3, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm6, xmm6, xmm7
  vaddps xmm0, xmm0, xmm6

  vshufps xmm6, xmm4, xmm4, 11001001b
  vshufps xmm7, xmm5, xmm5, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm4, xmm4, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm6, xmm6, xmm7
  vaddps xmm0, xmm0, xmm6

  vshufps xmm6, xmm5, xmm5, 11001001b
  vshufps xmm7, xmm2, xmm2, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm5, xmm5, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm6, xmm6, xmm7
  vaddps xmm0, xmm0, xmm6

  vmovaps xmm2, xmm0
  vmulps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0

  vsqrtps xmm0, xmm0
  vdivps xmm0, xmm2, xmm0

  mov ebx, [Result]
  vmovups [ebx], xmm0

end;
    {$ELSE}
 {Code for vectormath_vector_unix32_sse_imp.inc}
function TVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector4f): TGLZVector4f; assembler; register;
asm
  movups xmm1, [EAX]

  movups xmm2, [up]          //in edx
  subps  xmm2, xmm1
  movups xmm3, [left]        //in ecx
  subps  xmm3, xmm1
  mov ebx, [down]
  movups xmm4, [ebx]
  subps  xmm4, xmm1
  mov ebx, [right]
  movups xmm5, [ebx]
  subps  xmm5, xmm1

  movups xmm0, [cSSE_MASK_NO_W]
  andps xmm2, xmm0
  andps xmm3, xmm0
  andps xmm4, xmm0
  andps xmm5, xmm0

  movaps xmm6,xmm2
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm3
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7


  shufps xmm7, xmm7, 11010010b
  movaps xmm1, xmm2
  shufps xmm1, xmm1, 11010010b
  mulps xmm7,xmm1

  subps xmm6,xmm7
  movaps xmm0, xmm6
  movaps xmm6,xmm3
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm4
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7

  shufps xmm7, xmm7, 11010010b
  movaps xmm1, xmm3
  shufps xmm1, xmm1, 11010010b
  mulps xmm7,xmm1

  subps xmm6,xmm7
  addps xmm0, xmm6

  movaps xmm6,xmm4
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm5
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7

  shufps xmm7, xmm7, 11010010b
  movaps xmm1, xmm4
  shufps xmm1, xmm1, 11010010b
  mulps xmm7,xmm1

  subps xmm6,xmm7
  addps xmm0, xmm6

  movaps xmm6,xmm5
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm2
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7

  shufps xmm7, xmm7, 11010010b
  movaps xmm1, xmm5
  shufps xmm1, xmm1, 11010010b
  mulps xmm7,xmm1

  subps xmm6,xmm7
  addps xmm0, xmm6

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
  mov ebx, [Result]
  vmovups [ebx], xmm0
end;
    {$ENDIF}
  {$endif}
{%endregion}
{$else}
{%region%--------[ Windows 64 ]-------------------------------------------------}
{$ifdef CPU64}
     {$IFDEF USE_ASM_AVX}
 {Code for vectormath_vector_win64_avx_imp.inc}
function TVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector4f): TGLZVector4f; assembler; register;
asm
  vmovups xmm1, [RDX]
  vmovups xmm2, [up]          //in edx
  vsubps xmm2, xmm2, xmm1
  vmovups xmm3, [left]        //in ecx
  vsubps xmm3, xmm3, xmm1
  mov rax, [down]
  vmovups xmm4, [rax]
  vsubps xmm4, xmm4, xmm1
  mov rax, [right]
  vmovups xmm5, [rax]
  vsubps xmm5, xmm5, xmm1

  vmovups xmm0, [RIP+cSSE_MASK_NO_W]
  vandps xmm2, xmm2, xmm0
  vandps xmm3, xmm3, xmm0
  vandps xmm4, xmm4, xmm0
  vandps xmm5, xmm5, xmm0

  vshufps xmm6, xmm2, xmm2, 11001001b
  vshufps xmm7, xmm3, xmm3, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm2, xmm2, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm0, xmm6, xmm7

  vshufps xmm6, xmm3, xmm3, 11001001b
  vshufps xmm7, xmm4, xmm4, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm3, xmm3, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm6, xmm6, xmm7
  vaddps xmm0, xmm0, xmm6

  vshufps xmm6, xmm4, xmm4, 11001001b
  vshufps xmm7, xmm5, xmm5, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm4, xmm4, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm6, xmm6, xmm7
  vaddps xmm0, xmm0, xmm6

  vshufps xmm6, xmm5, xmm5, 11001001b
  vshufps xmm7, xmm2, xmm2, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm5, xmm5, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm6, xmm6, xmm7
  vaddps xmm0, xmm0, xmm6

  vmovaps xmm2, xmm0
  vmulps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0

  vsqrtps xmm0, xmm0
  vdivps xmm0, xmm2, xmm0

  vmovups [Result], xmm0

end;
      {$ELSE}
 {Code for vectormath_vector_win64_sse_imp.inc}
function TVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector4f): TGLZVector4f; assembler; register;
asm
movaps xmm1, [RCX] // cen

  //VectorSubtract(up^,cen^,s{%H-});
  movaps xmm2, [up]   //s
  subps xmm2, xmm1
  //VectorSubtract(left^,cen^,t{%H-});
  movaps xmm3, [left]  //t
  subps xmm3, xmm1
  //VectorSubtract(down^,cen^,u{%H-});
  mov RAX, down
  movaps xmm4, [RAX]   //u
  subps xmm4, xmm1
  //VectorSubtract(right^,cen^,v{%H-});
  mov RAX, right
  movaps xmm5, [RAX]  //v
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
//  movhlps xmm1,xmm0      
                                   
end;
      {$ENDIF}
{%endregion}
{$else}
{%region%--------[ Windows 32 ]-------------------------------------------------}
  {$IFDEF USE_ASM_AVX}
 {Code for vectormath_vector_win32_avx_imp.inc}
function TVectorHelper.AverageNormal4(constref up, left, down, right: TGLZVector4f): TGLZVector4f; assembler; register;
asm
  vmovups xmm1, [EAX]
  vmovups xmm2, [up]          //in edx
  vsubps xmm2, xmm2, xmm1
  vmovups xmm3, [left]        //in ecx
  vsubps xmm3, xmm3, xmm1
  mov ecx, [down]
  vmovups xmm4, [ecx]
  vsubps xmm4, xmm4, xmm1
  mov ecx, [right]
  vmovups xmm5, [ecx]
  vsubps xmm5, xmm5, xmm1

  vmovups xmm0, [cSSE_MASK_NO_W]
  vandps xmm2, xmm2, xmm0
  vandps xmm3, xmm3, xmm0
  vandps xmm4, xmm4, xmm0
  vandps xmm5, xmm5, xmm0

  vshufps xmm6, xmm2, xmm2, 11001001b
  vshufps xmm7, xmm3, xmm3, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm2, xmm2, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm0, xmm6, xmm7

  vshufps xmm6, xmm3, xmm3, 11001001b
  vshufps xmm7, xmm4, xmm4, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm3, xmm3, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm6, xmm6, xmm7
  vaddps xmm0, xmm0, xmm6

  vshufps xmm6, xmm4, xmm4, 11001001b
  vshufps xmm7, xmm5, xmm5, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm4, xmm4, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm6, xmm6, xmm7
  vaddps xmm0, xmm0, xmm6

  vshufps xmm6, xmm5, xmm5, 11001001b
  vshufps xmm7, xmm2, xmm2, 11010010b
  vmulps  xmm6, xmm6, xmm7

  vshufps xmm7, xmm7, xmm7, 11010010b
  vshufps xmm1, xmm5, xmm5, 11010010b
  vmulps  xmm7, xmm7, xmm1

  vsubps xmm6, xmm6, xmm7
  vaddps xmm0, xmm0, xmm6

  vmovaps xmm2, xmm0
  vmulps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0

  vsqrtps xmm0, xmm0
  vdivps xmm0, xmm2, xmm0

  mov ebx, [Result]
  vmovups [ebx], xmm0
end;
     {$ELSE}
 {Code for vectormath_vector_win32_sse_imp.inc}
function TVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector4f): TGLZVector4f; assembler; register;
asm
  movups xmm1, [EAX]

  movups xmm2, [up]          //in edx
  subps  xmm2, xmm1
  movups xmm3, [left]        //in ecx
  subps  xmm3, xmm1
  mov ebx, [down]
  movups xmm4, [ebx]
  subps  xmm4, xmm1
  mov ebx, [right]
  movups xmm5, [ebx]
  subps  xmm5, xmm1

  movups xmm0, [cSSE_MASK_NO_W]
  andps xmm2, xmm0
  andps xmm3, xmm0
  andps xmm4, xmm0
  andps xmm5, xmm0

  movaps xmm6,xmm2
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm3
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7


  shufps xmm7, xmm7, 11010010b
  movaps xmm1, xmm2
  shufps xmm1, xmm1, 11010010b
  mulps xmm7,xmm1

  subps xmm6,xmm7
  movaps xmm0, xmm6
  movaps xmm6,xmm3
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm4
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7

  shufps xmm7, xmm7, 11010010b
  movaps xmm1, xmm3
  shufps xmm1, xmm1, 11010010b
  mulps xmm7,xmm1

  subps xmm6,xmm7
  addps xmm0, xmm6

  movaps xmm6,xmm4
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm5
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7

  shufps xmm7, xmm7, 11010010b
  movaps xmm1, xmm4
  shufps xmm1, xmm1, 11010010b
  mulps xmm7,xmm1

  subps xmm6,xmm7
  addps xmm0, xmm6

  movaps xmm6,xmm5
  shufps xmm6, xmm6, 11001001b
  movaps xmm7,xmm2
  shufps xmm7, xmm7, 11010010b
  mulps xmm6, xmm7                  // s gone t in 7

  shufps xmm7, xmm7, 11010010b
  movaps xmm1, xmm5
  shufps xmm1, xmm1, 11010010b
  mulps xmm7,xmm1

  subps xmm6,xmm7
  addps xmm0, xmm6

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
  mov ebx, [Result]
  vmovups [ebx], xmm0
end;
     {$ENDIF}
  {$endif}
{%endregion}
{$endif}
{$else}
function TVectorHelper.AverageNormal4(constref up, left, down, right: TGLZVector4f): TGLZVector4f;
var
  s,t,u,r: TGLZVector4f;
begin
  s := up - self;
  t := left - self;
  u := down - self;
  r := right - self;
  Result.X := s.Y*t.Z - s.Z*t.Y + t.Y*u.Z - t.Z*u.Y + u.Y*r.Z - u.Z*r.Y + r.Y*s.Z - r.Z*s.Y;
  Result.Y := s.Z*t.X - s.X*t.Z + t.Z*u.X - t.x*u.Z + u.Z*r.X - u.X*r.Z + r.Z*s.X - r.X*s.Z;
  Result.Z := s.X*t.Y - s.Y*t.X + t.X*u.Y - t.Y*u.X + u.X*r.Y - u.Y*r.X + r.X*s.Y - r.Y*s.X;
  Result := Result.Normalize;
end;
{$endif}


{gets the normal at cen based on the connected quad mesh vectors}
function TNativeHelper.AverageNormal4(constref up, left, down,
  right: TNativeGLZVector4f): TNativeGLZVector4f;
var
  s,t,u,r: TNativeGLZVector4f;
begin
  s := up - self;
  t := left - self;
  u := down - self;
  r := right - self;
  Result.X := s.Y*t.Z - s.Z*t.Y + t.Y*u.Z - t.Z*u.Y + u.Y*r.Z - u.Z*r.Y + r.Y*s.Z - r.Z*s.Y;
  Result.Y := s.Z*t.X - s.X*t.Z + t.Z*u.X - t.x*u.Z + u.Z*r.X - u.X*r.Z + r.Z*s.X - r.X*s.Z;
  Result.Z := s.X*t.Y - s.Y*t.X + t.X*u.Y - t.Y*u.X + u.X*r.Y - u.Y*r.X + r.X*s.Y - r.Y*s.X;
  Result := Result.Normalize;
  Result.W := 0;
end;

end.

