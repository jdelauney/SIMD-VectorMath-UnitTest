procedure TGLZHmgPlane.Create(constref p1, p2, p3 : TGLZVector); assembler; register; nostackframe;
asm
  vmovaps  xmm0, [p1]
  vmovaps  xmm1, [p2]
  vmovaps  xmm2, [p3]

  vshufps  xmm4, xmm0, xmm0, 11001001b   //|p1 T1|
  vshufps  xmm5, xmm2, xmm2, 11001001b   //|p3 T1|
  vshufps  xmm6, xmm1, xmm1, 11001001b   //|p2 T1|

  vsubps   xmm3, xmm6, xmm5
  vsubps   xmm5, xmm5, xmm4
  vsubps   xmm4, xmm4, xmm6

  vmovaps  xmm6, xmm0

  vmulps   xmm0, xmm0, xmm3
  vmulps   xmm1, xmm1, xmm5
  vmulps   xmm2, xmm2, xmm4

  vaddps   xmm0, xmm0, xmm1
  vaddps   xmm0, xmm0, xmm2

  vdpps    xmm1, xmm0, xmm0, 01111111b
  vsqrtps  xmm1, xmm1
  vdivps   xmm0, xmm0, xmm1
  vshufps  xmm0, xmm0, xmm0, 11001001b

  vdpps    xmm1, xmm0, xmm6, 01110011b
  vxorps   xmm1, xmm1, [RIP+cSSE_MASK_NEGATE] // xmm1 now holds |-|-|D|D|
  vshufps  xmm1, xmm1, xmm0, 10100000b         // xmm1 now holds |C|C|D|D|
  vshufps  xmm0, xmm0, xmm1, 00110100b
  vmovaps [RDI], xmm0
end;


procedure TGLZHmgPlane.Normalize; assembler; register; nostackframe;
asm
  vmovaps  xmm0, [RDI]
  vdpps    xmm1, xmm0, xmm0, 01111111b
  vsqrtps  xmm1, xmm1
  vdivps   xmm0, xmm0, xmm1
  vmovaps [RDI], xmm0
end;

function TGLZHmgPlane.Normalized : TGLZHmgPlane; assembler; register; nostackframe;
asm
  vmovaps xmm0, [RDI]
  vdpps   xmm1, xmm0, xmm0, 01111111b
  vsqrtps xmm1, xmm1
  vdivps  xmm0, xmm0, xmm1
  movhlps xmm1, xmm0
end;

function TGLZHmgPlane.Distance(constref point : TGLZVector) : Single;assembler; register; nostackframe;
asm
  vmovaps xmm0, [RDI]
  vdpps   xmm0, xmm0, [POINT], 01110001b
  vaddps  xmm0, xmm0, [RDI]12
end;

function TGLZHmgPlane.AbsDistance(constref point : TGLZVector) : Single; assembler; register; nostackframe;
asm
  vmovaps xmm0, [RDI]
  vdpps   xmm0, xmm0, [POINT], 01110001b
  vaddps  xmm0, xmm0, [RDI]12
  vandps  xmm0, xmm0, [RIP+cSSE_MASK_ABS]
end;

