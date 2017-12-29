
{%region%----[ Operators ]--------------------------------------------------------}
class operator TGLZVector4f.+(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
  asm
    VMOVAPS XMM0,[A]
    VMOVAPS XMM1,[B]
    VADDPS  XMM0,XMM0, XMM1
    MOVHLPS XMM1, XMM0
  end;

  class operator TGLZVector4f.-(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
  asm
    VMOVAPS XMM0,[A]
    VMOVAPS XMM1,[B]
    VSUBPS  XMM0,XMM0, XMM1
    MOVHLPS XMM1, XMM0
  end;

  class operator TGLZVector4f.*(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
  asm
    VMOVAPS XMM0,[A]
    VMOVAPS XMM1,[B]
    VMULPS  XMM0,XMM0, XMM1
    MOVHLPS XMM1, XMM0
  end;

  class operator TGLZVector4f./(constref A, B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
  asm
    VMOVAPS XMM0,[A]
    VMOVAPS XMM1,[B]
    VDIVPS  XMM0,XMM0, XMM1
    MOVHLPS XMM1, XMM0
  end;

  class operator TGLZVector4f.+(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
  asm
    VMOVAPS XMM0,[A]
    VMOVSS  XMM1,[B]
    VSHUFPS XMM1, XMM1, XMM1,0
    VADDPS  XMM0,XMM1, XMM0
    MOVHLPS XMM1, XMM0
  end;

  class operator TGLZVector4f.-(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
  asm
    VMOVAPS XMM0,[A]
    VMOVSS  XMM1,[B]
    VSHUFPS XMM1, XMM1, XMM1,0
    VSUBPS  XMM0,XMM0, XMM1
    MOVHLPS XMM1, XMM0
  end;

  class operator TGLZVector4f.*(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
  asm
    VMOVAPS XMM0,[A]
    VMOVSS  XMM1,[B]
    VSHUFPS XMM1, XMM1, XMM1,0
    VMULPS  XMM0,XMM1, XMM0
    MOVHLPS XMM1, XMM0
  end;

  class operator TGLZVector4f./(constref A: TGLZVector4f; constref B:Single): TGLZVector4f; assembler; nostackframe; register;
  asm
    VMOVAPS XMM0,[A]
    VMOVSS  XMM1,[B]
    VSHUFPS XMM1, XMM1, XMM1,0
    VDIVPS  XMM0,XMM0, XMM1
    MOVHLPS XMM1, XMM0
  end;

  class operator TGLZVector4f.-(constref A: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
  asm
    vmovaps xmm1,[A]
    vmovaps xmm0,[RIP+cNullVector4f]
    VSUBPS  XMM0,XMM0, XMM1
    MOVHLPS XMM1, XMM0
  End;

  class operator TGLZVector4f.=(constref A, B: TGLZVector4f): Boolean; assembler; nostackframe; register;
  asm
    movaps xmm0,[A]
    movaps xmm1,[B]
    vcmpps xmm0, xmm0,xmm1, cSSE_OPERATOR_EQUAL
    movmskps eax, xmm0
    xor eax, $f
    setz al
  end;

  class operator TGLZVector4f.<=(constref A, B: TGLZVector4f): Boolean; assembler; nostackframe; register;
  asm
    vmovaps xmm0,[A]
    vmovaps xmm1,[B]
    vcmpps xmm0, xmm0,xmm1, cSSE_OPERATOR_LESS_OR_EQUAL
    movmskps eax, xmm0
    xor eax, $f
    setz al
  end;

  class operator TGLZVector4f.>=(constref A, B: TGLZVector4f): Boolean; assembler; nostackframe; register;
  asm
    vmovaps xmm0,[A]
    vmovaps xmm1,[B]
    vcmpps xmm0, xmm0,xmm1, cSSE_OPERATOR_NOT_LESS_OR_EQUAL
    movmskps eax, xmm0
    xor eax, $f
    setz al
  end;

  class operator TGLZVector4f.>(constref A, B: TGLZVector4f): Boolean; assembler; nostackframe; register;
  asm
    vmovaps xmm0,[A]
    vmovaps xmm1,[B]
    vcmpps xmm0, xmm0,xmm1, cSSE_OPERATOR_NOT_LESS
    movmskps eax, xmm0
    xor eax, $f
    setz al
  end;

  class operator TGLZVector4f.<(constref A, B: TGLZVector4f): Boolean; assembler; nostackframe; register;
  asm
    vmovaps xmm0,[A]
    vmovaps xmm1,[B]
    vcmpps xmm0, xmm0,xmm1, cSSE_OPERATOR_LESS
    movmskps eax, xmm0
    xor eax, $f
    setz al
  end;

  class operator TGLZVector4f.<>(constref A, B: TGLZVector4f): Boolean; assembler; nostackframe; register;
  asm
    vmovaps xmm0,[A]
    vmovaps xmm1,[B]
    vcmpps xmm0, xmm0,xmm1, cSSE_OPERATOR_NOT_EQUAL
    movmskps eax, xmm0
    xor eax, $f
    setz al
  end;

{%endregion%}
{%region%----[ Functions ]--------------------------------------------------------}
function TGLZVector4f.Abs: TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [RIP+cSSE_MASK_ABS]
  vandps  xmm0, xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Negate:TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1,[RIP+cSSE_MASK_NEGATE]
  vxorps xmm0, xmm0,xmm1
  movhlps xmm1, xmm0
End;

function TGLZVector4f.DivideBy2:TGLZVector4f;assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1,[RIP+cHalfOneVector4f]
  vmulps xmm0, xmm0,xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Distance(constref A: TGLZVector4f):Single;assembler; nostackframe; register;
Asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [A]
  vsubps  xmm0, xmm0, xmm1
  vandps  xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  vmulps  xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vsqrtss xmm0, xmm0, xmm0
end;

function TGLZVector4f.DistanceSquare(constref A: TGLZVector4f):Single;assembler; nostackframe; register;
Asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [A]
  vsubps  xmm0, xmm0, xmm1
  vandps  xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  vmulps  xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
end;

function TGLZVector4f.Length:Single;assembler; nostackframe; register;
Asm
  vmovaps xmm0,[RDI]
  vandps  xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  vmulps  xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vsqrtss xmm0, xmm0, xmm0
end;

function TGLZVector4f.LengthSquare:Single;assembler; nostackframe; register;
Asm
  vmovaps xmm0,[RDI]
  vandps  xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  vmulps  xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
end;

function TGLZVector4f.Spacing(constref A : TGLZVector4f) : Single; assembler; nostackframe; register;
asm
  //Result:=Abs(v2.X-Self.X)+Abs(v2.Y-Self.Y)+Abs(v2.Z-Self.Z)+Abs(v2.W-Self.W);
  vmovaps xmm1, [RDI]
  vmovaps xmm0, [A]
  vsubps xmm0, xmm0, xmm1
  vandps xmm0, xmm0, [RIP+cSSE_MASK_ABS]
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
end;


function TGLZVector4f.CrossProduct(constref A: TGLZVector4f): TGLZVector4f;assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]

  VMOVAPS XMM1, [A]
  VMOVAPS XMM2, XMM0
  VMOVAPS XMM3, XMM1


  VSHUFPS XMM0, XMM0, XMM0, $C9

  VSHUFPS XMM1, XMM1, XMM1, $D2
  VSHUFPS XMM2, XMM2, XMM2, $D2
  VSHUFPS XMM3, XMM3, XMM3, $C9

  VMULPS  XMM0, XMM0, XMM1
  VMULPS  XMM2, XMM2, XMM3

  VSUBPS  XMM0, XMM0, XMM2
  vaddps  xmm0, xmm0, [RIP+cWOneSSEVector4f] // It would Better change by logical operator
  movhlps xmm1, xmm0
end;

function TGLZVector4f.DotProduct(constref A: TGLZVector4f):Single;assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [A]
  vdpps xmm0, xmm0, xmm1, 01110001b //or $F1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Norm:Single;assembler;
asm
  vmovaps xmm0,[RDI]

  vmulps xmm0,xmm0, xmm0
  vmovaps xmm1, xmm0
  vshufps xmm0, xmm0, xmm1, $4e
  vaddps xmm0,xmm0, xmm1

  vshufps xmm1, xmm1, xmm0, $11
  vaddps xmm0, xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Normalize: TGLZVector4f;  assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm3,xmm0
  vandps  xmm3, xmm3, [RIP+cSSE_MASK_ONLY_W]
  vandps  xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  vmovaps xmm2, xmm0
  vmulps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
{$IFDEF USE_ASM_SIMD_HIGHPRECISION}
  // High Precision
  vsqrtps xmm0, xmm0
  vdivps xmm0, xmm2, xmm0
{$ELSE}
  // Low precision
  rsqrtps xmm0, xmm0       //approximate reciprocal
  mulps xmm2, xmm0
{$ENDIF}
  vaddps  xmm0,xmm0,xmm3
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Min(constref B: Single): TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00 // Replicate B
  vminps  xmm0, xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Min(constref B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [B]
  vminps  xmm0, xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Max(constref B: Single): TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00 // Replicate B
  vmaxps  xmm0, xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Max(constref B: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [B]
  vmaxps  xmm0, xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Clamp(constref AMin, AMax: Single): TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss xmm2, [AMin]
  vmovss xmm3, [AMax]
  vshufps xmm2, xmm2, xmm2, $00
  vshufps xmm3, xmm3, xmm3, $00
  vmaxps  xmm0, xmm0, xmm2
  vminps  xmm0, xmm0, xmm3
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Clamp(Constref AMin, AMax: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [AMin]
  vmovaps xmm2, [AMax]
  vmaxps  xmm0, xmm0, xmm1
  vminps  xmm0, xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector4f.MulAdd(Constref B, C: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [B]
  vmovaps xmm2, [C]
  vmulps xmm0, xmm0, xmm1
  vaddps xmm0, xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector4f.MulDiv(Constref B, C: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [B]
  vmovaps xmm2, [C]
  vmulps  xmm0, xmm0, xmm1
  vdivps  xmm0,xmm0, xmm2
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Lerp(Constref B: TGLZVector4f; Constref T:Single): TGLZVector4f;assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [B]
  vmovss  xmm2, [T]
  vshufps xmm2, xmm2,xmm2, $0
  vandps xmm2, xmm2, [RIP+cSSE_MASK_NO_W]
  vsubps xmm1, xmm1,xmm0
  vmulps xmm1, xmm1, xmm2

  vaddps xmm0, xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZVector4f.AngleCosine(constref A : TGLZVector4f): Single;assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]

  vmovaps xmm1,[A]
  vmovaps xmm2, xmm0 // Coypy Self
  vmovaps xmm4, xmm1 // Copy A

  // DotProd in xmm0 Result in xmm3
  //andps xmm0, [RIP+cSSE_MASK_NO_W]
  vdpps xmm3, xmm0, xmm1, 01110001b //or $F1

  // Length Self in xmm2 result in xmm2
  vandps  xmm2, xmm2, [RIP+cSSE_MASK_NO_W]
  vmulps  xmm2, xmm2, xmm2
  vhaddps xmm2, xmm2, xmm2
  vhaddps xmm2, xmm2, xmm2
  vsqrtss xmm2, xmm2, xmm2

  // Lenght A in xmm4 result in xmm4
  vandps  xmm4, xmm4, [RIP+cSSE_MASK_NO_W]
  vmulps xmm4, xmm4, xmm4
  vhaddps xmm4, xmm4, xmm4
  vhaddps xmm4, xmm4, xmm4
  vsqrtss xmm4, xmm4, xmm4

  vmulps xmm2, xmm2, xmm4
  vdivps xmm3, xmm3, xmm2
  movaps xmm0, xmm3
end;

function TGLZVector4f.AngleBetween(Constref A, ACenterPoint : TGLZVector4f): Single;
Var
  vResult  :  Single;
begin
  asm
    vmovaps xmm0,[RDI]
    mov rax, [A]            // A is a pointer on the stack
    vmovups xmm1, [RAX]
    mov rax, [ACenterPoint] // ACenterPoint is a pointer on the stack
    vmovups xmm2, [RAX]
    vsubps xmm0, xmm0, xmm2
    vsubps xmm1, xmm1, xmm2

    // Normalize xmm0 result in xmm2
    vmovaps xmm3,xmm0

    vandps  xmm3, xmm3, [RIP+cSSE_MASK_ONLY_W]
    vandps  xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
    vmovaps xmm2, xmm0

    vmulps  xmm0, xmm0, xmm0
    vhaddps xmm0, xmm0, xmm0
    vhaddps xmm0, xmm0, xmm0

    {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
      // High Precision
      vsqrtps xmm0, xmm0
      vdivps xmm2, xmm2, xmm0
    {$ELSE}
      // Low precision
      rsqrtps xmm0, xmm0       //approximate reciprocal
      mulps xmm2, xmm0
    {$ENDIF}
    vaddps xmm2, xmm2,xmm3
    // Normalize xmm1 result in xmm4
    vmovaps xmm3, xmm1
    vandps  xmm3, xmm3, [RIP+cSSE_MASK_ONLY_W]
    vandps  xmm1, xmm1, [RIP+cSSE_MASK_NO_W]
    vmovaps xmm4, xmm1

    vmulps  xmm1, xmm1, xmm1
    vhaddps xmm1, xmm1, xmm1
    vhaddps xmm1, xmm1, xmm1
    {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
      // High Precision
      vsqrtps xmm1, xmm1
      vdivps xmm4, xmm4, xmm1
    {$ELSE}
      // Low precision
      rsqrtps xmm1, xmm1       //approximate reciprocal
      mulps xmm4, xmm1
    {$ENDIF}
    vaddps xmm4, xmm4,xmm3

    // AngleCosine
    vmovaps xmm1, xmm4
    vmovaps xmm0, xmm2 // Copy A

    // DotProd  xmm0/xmm1 Result in xmm3
    vdpps xmm3, xmm0, xmm1, 01110001b //or $F1

    // Length xmm2 result in xmm2
    vandps xmm2, xmm2, [RIP+cSSE_MASK_NO_W]
    vdpps xmm2, xmm2, xmm2, $FF;
    vsqrtss xmm2, xmm2, xmm2
    // Lenght  xmm4 result in xmm4
    vandps xmm4, xmm4, [RIP+cSSE_MASK_NO_W]
    vdpps xmm4, xmm4, xmm4, $FF;
    vsqrtss xmm4, xmm4, xmm4
    vmulps xmm2, xmm2,xmm4
    vdivps xmm3, xmm3, xmm2
    movss [vResult], {%H-}xmm3
  end;
  Result := ArcCos(vResult);
end;



function TGLZVector4f.Combine(constref V2: TGLZVector4f; constref F1: Single): TGLZVector4f;assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [V2]
  vmovss xmm2, [F1]
  vshufps xmm2, xmm2, xmm2, $00 // replicate

  vmulps xmm1, xmm1, xmm2 //V2*F1
  vaddps xmm0, xmm0, xmm1 // Self + (V2*F1)

  vandps xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Combine3(constref V2, V3: TGLZVector4f; const F1, F2, F3: Single): TGLZVector4f;  assembler; nostackframe; register;
asm
  vmovaps xmm3,[RDI]
  vmovaps xmm4, [V2]
  vmovaps xmm5, [V3]

  vshufps xmm0, xmm0, xmm0, $00 // replicate
  vshufps xmm1, xmm1, xmm1, $00 // replicate
  vshufps xmm2, xmm2, xmm2, $00 // replicate

  vmulps xmm0, xmm0, xmm3 // Self * F1
  vmulps xmm4, xmm4, xmm1 // V2 * F2
  vmulps xmm5, xmm5, xmm2 // V3 * F3

  vaddps xmm0, xmm0, xmm4 // (Self * F1) + (V2 * F2)
  vaddps xmm0, xmm0, xmm5 // ((Self * F1) + (V2 * F2)) + (V3 * F3)

  vandps xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Combine2(constref V2: TGLZVector4f; Const F1, F2: Single): TGLZVector4f;assembler; nostackframe; register;
asm
  vmovaps xmm2,[RDI]
  vmovaps xmm3, [V2]

  vshufps xmm0, xmm0, xmm0, $00 // replicate
  vshufps xmm1, xmm1, xmm1, $00 // replicate

  vmulps xmm0, xmm0, xmm2  // Self * F1
  vmulps xmm1, xmm1, xmm3  // V2 * F2

  vaddps xmm0, xmm0, xmm1  // (Self * F1) + (V2 * F2)

  vandps xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Perpendicular(constref N : TGLZVector4f) : TGLZVector4f; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [N]
  vandps xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  vmovaps xmm2, xmm0
   // Self.Dot(N) Result in xmm0
  vdpps xmm0, xmm0, xmm1, 01110001b //or $F1
  vShufps xmm0, xmm0,xmm0, $0
  vmulps xmm0, xmm0, xmm2    // (Dot * Self)
  vsubps xmm0, xmm0, xmm2    //(Dot * Self) * Self
  xorps xmm0, [RIP+cSSE_MASK_NEGATE]
  movhlps xmm1, xmm0
end;

function TGLZVector4f.Reflect(constref N: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
 vmovaps xmm0,[RDI]
 vmovaps xmm1, [N]
 vmovaps xmm2, xmm1
 vmovaps xmm3, xmm0
 // N.Dot(SELF) Result in xmm1
 vdpps xmm1, xmm1, xmm0, 01110001b //or $F1
 vShufps xmm1, xmm1,xmm1, $0  // Replicate
 vaddps xmm1, xmm1,xmm1  // (2 * N.Dot(Self))
 vmulps xmm1, xmm1, xmm2 // ((2 * N.Dot(Self)) * N)
 vsubps xmm3, xmm3, xmm1 // Self - ((2 * N.Dot(Self)) * N)
 vmovups xmm0, xmm3
 movhlps xmm1, xmm0
end;

{%endregion%}
{%region%----[ Operations on Self ]-----------------------------------------------}
procedure TGLZVector4f.pAdd(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [A]
  vAddps xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pSub(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [A]
  vsubps xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pMul(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [A]
  vmulps xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pDiv(constref A: TGLZVector4f); assembler; nostackframe; register;
asm
  vmovups xmm0,[RDI]
  vmovups xmm1, [A]
  vdivps xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pAdd(constref A: Single); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss  xmm1,[A]
  vshufps xmm1, xmm1, xmm1,0
  vaddps  xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pSub(constref A: Single); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss  xmm1,[A]
  vshufps xmm1, xmm1, xmm1,0
  vsubps  xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pMul(constref A: Single); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss  xmm1,[A]
  vshufps xmm1, xmm1, xmm1,0
  vmulps  xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pDiv(constref A: Single); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss  xmm1,[A]
  vshufps xmm1, xmm1, xmm1,0
  vdivps  xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pInvert;assembler; nostackframe; register;
asm
  vmovaps xmm1,[RDI]
  vmovaps xmm0,[RIP+cNullVector4f]
  vsubps xmm0, xmm0,xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pNegate; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1,[RIP+cSSE_MASK_NEGATE]
  vxorps xmm0, xmm0,xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pAbs; assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [RIP+cSSE_MASK_ABS]
  vandps  xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
end;

procedure TGLZVector4f.pDivideBy2;assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1,[RIP+cHalfOneVector4f]
  vmulps  xmm0, xmm0,xmm1
  vmovups [RDI],xmm0
end;

procedure TGLZVector4f.pCrossProduct(constref A: TGLZVector4f);assembler; nostackframe; register;
asm
  // Place unaligned data to registers
  //v1:x,y,z,w
  vmovaps xmm0,[RDI]
  //v2:x,y,z,w
  vMOVAPS XMM1, [A]                // XMM1 = V2
  vMOVAPS XMM2, XMM0               // XMM2 = V1 // move aligned data
  vMOVAPS XMM3, XMM1               // XMM3 = V2

  // Shuffle members
  vSHUFPS xmm0, XMM0, XMM0, $C9  //w z y x -> $C9 = 11 00 10 01 -> w x z y
  vSHUFPS xmm1, XMM1, XMM1, $D2  //w z y x -> $D2 = 11 01 00 10 -> w y x z
  vSHUFPS xmm2, XMM2, XMM2, $D2
  vSHUFPS xmm3, XMM3, XMM3, $C9
  // Scale
  vMULPS  xmm0, XMM0, XMM1
  vMULPS  xmm2, XMM2, XMM3
  // Sub the results
  vSUBPS  xmm0, XMM0, XMM2
  vaddps  xmm0, xmm0, [RIP+cWOneSSEVector4f] // It would Better change by logical operator
  vmovups [RDI],xmm0
end;

procedure TGLZVector4f.pNormalize;  assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm3,xmm0
  vandps  xmm3, xmm3, [RIP+cSSE_MASK_ONLY_W]
  vandps  xmm0, xmm0, [RIP+cSSE_MASK_NO_W]
  vmovaps xmm2, xmm0
  vmulps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  vhaddps xmm0, xmm0, xmm0
  {$IFDEF USE_ASM_SIMD_HIGHPRECISION}
  // High Precision
  vsqrtps xmm0, xmm0
  vdivps xmm0, xmm2, xmm0
  {$ELSE}
  // Low precision
  rsqrtps xmm0, xmm0       //approximate reciprocal
  mulps xmm2, xmm0
  {$ENDIF}
  vaddps  xmm0,xmm0,xmm3
  vmovups [RDI],xmm0
end;

procedure TGLZVector4f.pMin(constref B: TGLZVector4f); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [B]
  vminps  xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pMin(constref B: Single); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vminps  xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pMax(constref B: TGLZVector4f); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [B]
  vmaxps  xmm0, xmm0, xmm1
  vmovups [RDI],xmm0
End;

procedure TGLZVector4f.pMax(constref B: Single); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss xmm1, [B]
  vshufps xmm1, xmm1, xmm1, $00
  vmaxps xmm0, xmm0, xmm1
  vmovaps [RDI],xmm0
End;

procedure TGLZVector4f.pClamp(Constref AMin, AMax: TGLZVector4f); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm2, [AMin]
  vmovaps xmm3, [AMax]
  vmaxps  xmm0, xmm0, xmm2
  vminps  xmm0, xmm0, xmm3
  vmovaps [RDI],xmm0
End;

procedure TGLZVector4f.pClamp(constref AMin, AMax: Single); assembler; nostackframe; register;
asm
  vmovaps xmm0,[RDI]
  vmovss xmm2, [AMin]
  vmovss xmm3, [AMax]
  vshufps xmm2, xmm2, xmm2, $00 // Replicate AMin
  vshufps xmm3, xmm3, xmm3, $00 // Replicate AMax
  vmaxps  xmm0, xmm0, xmm2
  vminps  xmm0, xmm0, xmm3
  vmovaps [RDI],xmm0
End;

procedure TGLZVector4f.pMulAdd(Constref B, C: TGLZVector4f); assembler; nostackframe; register; // (Self*B)+c
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [B]
  vmovaps xmm2, [C]
  vmulps  xmm0, xmm0, xmm1
  vaddps  xmm0, xmm0, xmm2
  vmovaps [RDI],xmm0
End;

procedure TGLZVector4f.pMulDiv(Constref B, C: TGLZVector4f); assembler; nostackframe; register; // (Self*B)-c
asm
  vmovaps xmm0,[RDI]
  vmovaps xmm1, [B]
  vmovaps xmm2, [C]
  vmulps  xmm0, xmm0, xmm1
  vdivps  xmm0, xmm0, xmm2
  vmovups [RDI],xmm0
End;
{%endregion%}