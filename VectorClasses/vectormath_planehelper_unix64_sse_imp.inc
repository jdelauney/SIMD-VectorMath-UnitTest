procedure TGLZVectorHelper.CreatePlane(constref p1, p2, p3 : TGLZVector);assembler;
asm
  movaps xmm0, [p1]
  movaps xmm1, [p2]
  movaps xmm2, [p3]
  movaps xmm7, xmm0
  subps xmm0, xmm1
  subps xmm2, xmm1

  // Crossprod of xmm0 and xmm2
  movaps xmm1, xmm0
  movaps xmm3, xmm2
  shufps xmm0, xmm0, $C9
  shufps xmm1, xmm1, $D2
  shufps xmm2, xmm2, $D2
  shufps xmm3, xmm3, $C9

  mulps xmm2, xmm0
  mulps xmm3, xmm1

  subps xmm2, xmm3

  // Calculation of 'd' component

  andps xmm2, [RIP+cSSE_MASK_NO_W]

  movaps xmm4, xmm2

  // Multiply with point 'p1' on the polygon (saved in xmm7): xmm2 = 0 | a.z*z | a.y*y | a.x*x
  mulps xmm2, xmm7
  {$ifdef USE_ASM_SSE_3}
    // horizontally add, xmm2 = x^2+y^2+z^2 | x^2+y^2+z^2 | x^2+y^2+z^2 | x^2+y^2+z^2
    haddps xmm2, xmm2
    haddps xmm2, xmm2

    // Change sign for top component, remove bits for others
    xorps xmm2, [RIP+cSSE_SIGN_MASK_PPPN]  // xmm2 = -(x^2+y^2+z^2) | .... | ...
    andps xmm2, [RIP+cSSE_MASK_ONLY_W]	  // xmm2 = -(x^2+y^2+z^2) | 0 | 0 | 0
    orps xmm4, xmm2                       // xmm4 = -(x^2+y^2+z^2) | z | y | x
  {$else}

    movhlps xmm3, xmm2     // xmm3 = ?   | ?   | 0   |  z^2
    addss xmm3, xmm2       // xmm3 = ?   | ?   | 0   | z^2 + x^2
    shufps xmm2, xmm2, $55 // xmm2 = y^2 | y^2 | y^2 | y^2
    addss xmm3, xmm2       // xmm3 = ?   | ?   | ?   | x^2+y^2+z^2
    // Change sign
    xorps xmm3, [RIP+cSSE_SIGN_MASK_NPPP] // xmm3 = ? | ? | ? | -(x^2+y^2+z^2)
    // Move to w component location, mask off xyz, and OR with saved portions
    shufps xmm3,xmm3, $00                // xmm3 = -(x^2+y^2+z^2) | -(x^2+y^2+z^2) | -(x^2+y^2+z^2) | -(x^2+y^2+z^2)
    andps xmm3, [RIP+cSSE_MASK_ONLY_W]   // xmm3 = -(x^2+y^2+z^2) | 0 | 0 | 0
    orps xmm4, xmm3                      // xmm4 = -(x^2+y^2+z^2) | z | y | x */
  {$endif}

  // Save plane coefficients
  movaps [RDI],xmm4
end;


function TGLZVectorHelper.NormalizePlane:TGLZHmgPlane;assembler;
//   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
//   Result :=Self * n;
asm
  movaps xmm0, [RDI]
  movaps xmm2, xmm0
  mulps xmm0, xmm0
  andps xmm0, [RIP+cSSE_MASK_NO_W]
  {$ifdef USE_ASM_SSE_3}

       haddps xmm0, xmm0
       haddps xmm0, xmm0

  {$else}
    movhlps xmm1, xmm0
    addss xmm1, xmm0
    shufps xmm1, xmm1, $55
    addss xmm0, xmm1
  {$endif}
  sqrtps xmm0, xmm0
  movaps xmm1, [RIP+cOneVector4f]
  divps xmm1, xmm0
  mulps xmm2, xmm1
  movaps xmm0, xmm2
  movhlps xmm1,xmm0
end;

function TGLZVectorHelper.DistancePlaneToPoint(constref point : TGLZVector) : Single; assembler;
asm
  movaps xmm0, [RDI]     // xmm0 = Plane->d | Plane->c | Plane->b | Plane->a
  movaps xmm1, [POINT]   // xmm1 = ???????? | Point->z | Point->y | Point->x

  andps xmm1, [RIP+cSSE_MASK_NO_W] // xmm1 = 0 | ...
  movaps xmm7, xmm0                // xmm7 = Plane...

  mulps xmm1, xmm0        // xmm1 = d*0.0 | c*z | b*y | a*x
  shufps xmm7, xmm7, $FF  // xmm7 = d | d | d | d

  {$ifdef USE_ASM_SSE_3}
    haddps xmm1, xmm1               // xmm1 = ... | ... | z*c + 0 | x*a + y*b
    haddps xmm1, xmm1               // xmm1 = ... | ... | dot(Plane, Point)
    andps xmm1, [RIP+cSSE_MASK_ABS] // xmm1 = ??? | ??? | ??? | abs(dot(Plane, Point))
    addss xmm1, xmm7                // xmm1 = ? | ? | ? | fabsf(dot(Plane, Point)) + Plane->d
  {$else}
    movhlps xmm2, xmm1              // xmm2 = ???? | ???? | d*0.0 | z*c */
    addss xmm2, xmm1                // xmm2 = ???? | ???? | ????  | x*a + z*c*/
    shufps xmm1, xmm1, $55          // xmm1 = ???? | ???? | ????  | y*b */
    andps xmm1, [RIP+cSSE_MASK_ABS] // xmm1 = abs(dot(Plane, Point))
    addss xmm1, xmm2                // xmm1 = + Plane.W
  {$endif}
  movss [RESULT], {%H-}xmm1
end;

function TGLZVectorHelper.DistancePlaneToSphere(constref Center : TGLZVector; constref Radius:Single) : Single; assembler;
asm
  movaps xmm0, [RDI]    // xmm0 = Plane->d | Plane->c | Plane->b | Plane->a
  movaps xmm1, [Center] // xmm1 = ????????? | Sphere->Center.z | Sphere->Center.y | Sphere->Center.x

  andps xmm1, [RIP+cSSE_MASK_NO_W] // xmm1 = 0 | ...
  movaps xmm7, xmm0                // xmm7 = Plane...

  mulps xmm1, xmm0        // xmm1 = d*0.0 | c*z | b*y | a*x
  shufps xmm7, xmm7, $FF  // xmm7 = d | d | d | d
  {$ifdef USE_ASM_SSE_3}
    {$ifdef TEST}
      movshdup    xmm2, xmm1
      addps       xmm1, xmm2
      movhlps     xmm2, xmm1
      addss       xmm1, xmm2

      // https://stackoverflow.com/questions/13219146/how-to-sum-m256-horizontally/13222410#13222410
      // https://stackoverflow.com/questions/36195356/most-efficient-way-to-get-a-m256-of-horizontal-sums-of-8-source-m256-vectors
      // https://stackoverflow.com/questions/6996764/fastest-way-to-do-horizontal-float-vector-sum-on-x86/35270026#35270026
      // https://github.com/pcordes/vectorclass/commits/master
      // Horizontal Add : https://gcc.godbolt.org/#compilers:!((compiler:g6,options:'-xc+-O3+-Wall+-fverbose-asm+-march%3Dhaswell+-mno-avx',sourcez:MQSwdgxgNgrgJgUwAQB4QFt3gC4CdwB0AFgHwBQoksiqAztnDseWQPStLZEi1I9JQQAa2QBZAIa5x2AOS0ANEgBGMbJwDuCcSLicA9kgh70ABxBRk2A0oTZsCXIb2ICbDtHFgA5khhgAZnq42H7SCFAAnkiIECCIvFa%2BtMjoegBu4ia0rLREMP4muuD0Wrp6/kipaURQWWT%2BUHrSSES0MOgA%2BlkdtMkAjAAUHR3ofQBMABxIaQCUSADeSEvLK6tr62vs00gAvEgA2kgAIkgAwkgAPkgAQkgAgkgAumQrw6OTSLn5y3sjnV/%2BBoILq0AZpRTgpAdUSiDoAZQAEgBVABiKIAMgBRAZjRQAZkUAAZFH0ZjMANxLLaHc4nK63B7PV4jcZTNroXhLX6YDriOBwEFgxQAimbDjs3h7Q5HADU51OMrpNxlDzuMtuTOWAI2XKhPKqCBqgoBwvatFFqy2B2W5yWStl8sVTypHAsai4yCMpnMDiQ4jSejifsq6WUUVwCBgtHAPgBLy1Zp1uz1nT5At6Awlwry/gp8aWEZCuDArx5EDS2F6HX8eLGmbNeYAvmR6o1mq12iCesk8UMWR9Zgt81D%2B2yc8m/iN0oa4DATILZpT1lslLgmnAIOJ6Ehwgh0AgwJWkAS%2BvokLjCcO3qzPonuan%2BQvs/k8yttet71O0oaoMac6aOVFLZuC8IgWnEKAKgAWhIAQ9HUcDIOHCUNk/NNu3rDln1zclh0LGBiw2Sdy0rWhq1rTDzVw5sWy2Wh0AgixHCMGhowALwQRQVDUKMYEYqJaEaTRHD8CxeicRAoPY5B%2BHEJATDXJQLHQVsmjUDtOm6Ig0z7d4pkHeYr1HW8OQnHltMfLIhWmV8E1Mj8Uw6CyBSsrMJVsgtbAIkt1mIisqxrOt3OoltQH8RAKmGO4ADUAA1hlU9t2TGABWAA2Lt/QAD101K0psodmT06YhN1P48o6Td6CyCqslZMEPJHYrqhAUCzPQCqECyvBxAgbB/FZJ8kFJSlgNasDWSM5qb3a3lLNBNIhIhECiAtZYtjTTgiGQUrJpWfDCI0rtegQXs0lZNakw2sAijAQQwEsbbPh7aYHGjPQwEUdRuAgMD%2BD0ExsAwCCkECRwYti4ctgGMADHULd7Fu%2BhcBgPqQA%2BhQ/Ruv0oCgJByi2vc/QjQmkAAFluLAwAwdoZjIZtgAPRh/BbNx2HZrY4D0GAlIQMguZ5iwWnZLp02SOtr0mXQ0jgOZFiTBWtjSZNDluK5GSmm8/AisqeW1hB/HABAXNBS6FY2TmPpkNR1CCXAIi%2B5APsiJJkDTOEjkUB7v0cKxUe4bxSa8SQlHELxkCUEAj3UKOwM8JAUQABT9flNY%2BAFsFMT8DSNKz9f8RRiIRwoF1li0tg9En%2BFhkNqlqOA04mXR30/KrsG6QpMxzTOTEag6fL8ysBX8NKyaGHl0NoOAwTgbCyRC2iOY5vhD1rMgcGFzsEDMWtuwQCXRxAJAsrligQHCg2RwhhKitZI/uFH3XOj8ExeqEbgOm3kBR4GLLFBPpcOoth4iggDBwnhdCwzAFBeIeBUZA2/PcOKAhbC8CjJ8f0bswz2CQDHLg3M1APWNjGYMVQKDhGSI3e%2B38yZPx6DmIEn8d51j/lCGE8JkRoixAMPoRJ8SKDGPPchN1z5UJMo/NCj4v4UQfmTf%2BjVJYTGobWOhAIgSNCYSAPoaVMKj0LuwxEqIMTYl4UgYkx4BHzxWFsOE8MTCk1KtgW2O5lIHkrGI9kKjJECmkUFdoeiWggFrH3LyhFB7RkGtGCinjBGAOsRwOEcJMRjFrg3eJ/dHJdR6n1TRMioBEjNjYpJcidzfhLPgmAbUo5OG9GJM8VQkb2D5PjCoclBD2CkHjEwWTcC6FwLWeQWVMDyEvDRDeR1fHdh7D0ISPQGK4xYggXSd9j4zEMisLKs1nK5JYfI3CGytnoV8b/PZeFQklnCVoyYPQgksKbKzReKdMiI1BmudASAJBSFkLwCGLQ7AmAAFzsHoG/acuAGjwQIF6VgABHGACB6DozANkPotY%2BgAE4%2BhkzSqwIg8EoJWCku0KCHV0pQTxfgNiH1sD8VYKisYDKyZ9EJMAeljLmWJXUiLboDEvnLI%2BCfQqywjDIrUIokyABFPiug9hZX2cKjGYrjKNCOHxPGex2RSr5PKl0gTVUgz2AMJAUFFAmuPniJAMpj4AHZ/4pKtVlfKdMVgiu3OK7g%2Br1WORzr%2BVy7QtWz0ldKxqdF2ieuTEas1ZqsqngdRah1KVLU2v/oSJNWV7XH1oQ6p1w5XVKuKuycN3jBQqrVYoD1aqQ2ugMIa41pr63H1TQ6jNWUs3HxzS6xVTUbyNGTIWtVOqkBjQjXW0d0bY3mrTYmh11qkDOoVaK7tHxuCzTURYY0Yay0mU9USGNVaTIjqjQ2rKTbj4TvTWm%2BNmap1pvyjOuduau3ivZLNSeoJGjlpAOXDg6EsjRANlob5hgoCeC8HIT4DChYAyBlgDiuAzlFguWWfyZFAqYXuUAA%3D%3D)),filterAsm:(binary:!t,commentOnly:!t,directives:!t,intel:!t,labels:!t),version:3
      { hsum_ps_marat:
         movaps xmm1,xmm0
         movhlps xmm1,xmm0
         addps  xmm0,xmm1
         movaps xmm1,xmm0
         shufps xmm1,xmm0,0x1
         addss  xmm0,xmm1
      }
      { AVX :
       vmovaps xmm2,xmm1
       vextractf128 xmm2,ymm1,1
       vaddps xmm1,xmm2,xmm1
       vmovshdup xmm2,xmm1
       vaddps xmm2,xmm2,xmm1
       vmovhlps xmm2,xmm1,xmm1
       vaddss xmm1,xmm1,xmm2
       //vzeroupper ????
      }
    {$else}
      haddps xmm1, xmm1               // xmm1 = ... | ... | z*c + 0 | x*a + y*b
      haddps xmm1, xmm1               // xmm1 = ... | ... | dot(pPlane, pSphere->Center)
    {$endif}
      andps xmm1, [RIP+cSSE_MASK_ABS] // xmm1 = ? | ? | ? | abs(dot(Plane, Sphere->Center))
      addss xmm1, xmm7                // xmm1 = ? | ? | ? | + pPlane->d
  {$else}
    movhlps xmm2, xmm1              // xmm2 = ???? | ???? | d*0.0 | z*c
    addss xmm2, xmm1                // xmm2 = ???? | ???? | ????  | x*a + z*c
    shufps xmm1, xmm1, $55          // xmm1 = ???? | ???? | ????  | y*b
    andps xmm1, [RIP+cSSE_MASK_ABS] // xmm1 = ???? | ???? | ????  | abs(dot(Plane, Sphere->Center))
    addss xmm1, xmm2                // xmm1 = ???? | ???? | ????  | + Plane->d
  {$endif}

  xorps xmm7, xmm7    // xmm7 = 0 | 0 | 0 | 0

  // Subtract radius
  movlps xmm3, [Radius]
  subss xmm1, xmm3   // xmm1 = ? | ? | ? | dist - radius
  maxss xmm1, xmm7   // xmm1 = ? | ? | ? | max(0, dist-radius)

  movss [RESULT], {%H-}xmm1
end;


