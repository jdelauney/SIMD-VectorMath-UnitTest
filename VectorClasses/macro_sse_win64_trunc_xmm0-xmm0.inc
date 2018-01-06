{ Macro SSE for TGLZVector2f and TGLZVector4f : "Trunc"
  Input  : xmm0
  Output : xmm0
}
stmxcsr  DWORD PTR[ECX] // Push rounding mode
mov      edx, ecx    // need to move
and      edx, [RIP+cSSE_ROUND_MASK]
or       edx, [RIP+cSSE_ROUND_MASK_TRUNC]
ldmxcsr   DWORD PTR[EDX]
cvtps2dq xmm0, xmm0
ldmxcsr  DWORD PTR[ECX]  // Pop rounding mode
