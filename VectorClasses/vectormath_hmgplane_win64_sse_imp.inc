procedure TGLZHmgPlane.Create(constref p1, p2, p3 : TGLZVector);assembler; register; nostackframe;
asm
  //A := p1y * (p2Z - p3Z) + p2Y * (p3Z - p1Z) + p3Y * (p1Z - p2Z);
  //B := p1Z * (p2X - p3X) + p2Z * (p3X - p1X) + p3Z * (p1X - p2X);
  //C := p1X * (p2Y - p3Y) + p2X * (p3Y - p1y) + p3X * (p1y - p2Y);
  //     NT1     T1(2-3)     NT2     T1(3-1)     NT3     T1(1-2)   NT order currently |-|B|A|C|
  // shuffle Z -> X  Y -> Z   X ->Y    NT = |W|Z|Y|X|  T1 = |W|X|Z|Y| = 11001001b
  // keep  p1 p2 p3 for later

  movaps xmm0, [p1]
  movaps xmm1, [p2]
  movaps xmm2, [p3]

  movaps xmm4, xmm0
  movaps xmm5, xmm2
  movaps xmm6, xmm1

  shufps xmm4, xmm4, 11001001b   //|p1 T1|
  shufps xmm5, xmm5, 11001001b   //|p3 T1|
  shufps xmm6, xmm6, 11001001b   //|p2 T1|

  movaps xmm3, xmm6
  subps  xmm3, xmm5              //|T1(2-3)|
  subps  xmm5, xmm4              //|T1(3-1)|
  subps  xmm4, xmm6              //|T1(1-2)|

  movaps xmm6, xmm0              // stash p1 for later

  mulps  xmm0, xmm3              // NT1*(T1(2-3))
  mulps  xmm1, xmm5              // NT2*(T1(3-1))
  mulps  xmm2, xmm4              // NT3*(T1(1-2))
  addps  xmm1, xmm0              // NT1*(T1(2-3)) + NT2*(T1(3-1))
  addps  xmm1, xmm2              // NT1*(T1(2-3)) + NT2*(T1(3-1)) + NT3*(T1(1-2))
                                 // xmm1 now holds |-|B|A|C|
  movaps xmm0, xmm1              // stash for result

  {$ifdef USE_ASM_SSE_4}
    dpps     xmm1, xmm1, 01111111b  // result in all bytes
    sqrtps   xmm1, xmm1
  {$else}
    mulps    xmm1, xmm1
    {$ifdef USE_ASM_SSE_3}
      //movhlps xmm2, xmm1
      //haddps  xmm1, xmm1
      //addss   xmm1, xmm2
      movshdup xmm2,xmm1
      addps  xmm1,xmm2
      movhlps xmm2,xmm1
      addss  xmm1,xmm2
    {$else}
      movhlps xmm2, xmm1
      addss   xmm2, xmm1
      shufps  xmm1, xmm1, 01010101b
      addss   xmm1, xmm2
    {$endif}
    sqrtss  xmm1, xmm1
    shufps  xmm1, xmm1, 00000000b // fill all byte with result.
  {$endif}
    divps   xmm0, xmm1            // xmm0 now holds (|-|B|A|C|)unitvector
    shufps  xmm0, xmm0, 11001001b // xmm0 now holds (|-|C|B|A|)unitvector

  // now a choice of two
  // D := -(p1X * (p2Y * p3Z - p3Y * p2Z) + p2X * (p3Y * p1Z - p1y * p3Z) + p3X * (p1y * p2Z - p2Y * p1Z)
  // or
  // D := -(p1.DotProduct(Self))  <-------

  {$ifdef USE_ASM_SSE_4}
    dpps     xmm6, xmm0, 01110001b
  {$else}
    mulps    xmm6, xmm0
    {$ifdef USE_ASM_SSE_3}
      //movhlps xmm2, xmm6
      //haddps  xmm6, xmm6
      //addss   xmm6, xmm2

      movshdup xmm2,xmm6
      addps  xmm6,xmm2
      movhlps xmm2,xmm6
      addss  xmm6,xmm2
    {$else}
      movhlps xmm2, xmm6
      addss   xmm2, xmm6
      shufps  xmm6, xmm6, 01010101b
      addss   xmm6, xmm2
    {$endif}
  {$endif}

    xorps   xmm6, [RIP+cSSE_MASK_NEGATE] // xmm6 now holds |-|-|-|D|
    shufps  xmm6, xmm0, 10100000b        // xmm6 now holds |C|C|D|D|
    shufps  xmm6, xmm6, 00000011b        // xmm6 now holds |D|D|D|C|
    movlhps xmm0, xmm6
    movaps [RCX], xmm0                      //SF 7.14

end;


function TGLZHmgPlane.Normalized:TGLZHmgPlane;assembler; register; nostackframe;
//   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
//   Result :=Self * n; have to do the lot as dist was wrongly calced when created.
asm
  movaps   xmm0, [RCX]
  movaps   xmm2, xmm0
{$ifdef USE_ASM_SSE_4}
  dpps     xmm2, xmm2, 01110111b
{$else}
  mulps    xmm2, xmm2
  {$ifdef USE_ASM_SSE_3}
    //movhlps xmm3, xmm2
    //haddps  xmm2, xmm2
    //addss   xmm2, xmm3
    movhlps xmm3, xmm2
    movaps xmm5, xmm2
    andps xmm5, [RIP+cSSE_MASK_NO_W]
    movshdup xmm4,xmm5
    addps  xmm2,xmm4
    addss   xmm2, xmm3 // x + w
  {$else}
    movhlps xmm1, xmm2
    addss   xmm1, xmm2
    shufps  xmm2, xmm2, 01010101b
    addss   xmm2, xmm1
  {$endif}
{$endif}
  sqrtss  xmm2, xmm2
  shufps  xmm2, xmm2, 00000000b
  divps   xmm0, xmm2
  movaps [RESULT], xmm0
end;

procedure TGLZHmgPlane.Normalize; assembler; register; nostackframe;
//   n:=1/Sqrt(Self.X*Self.X+Self.Y*Self.Y+Self.Z*Self.Z);
//   Result := Self * n;  have to do the lot as dist was wrongly calced when created.
asm
  movaps   xmm0, [RCX]
  movaps   xmm2, xmm0
  {$ifdef USE_ASM_SSE_4}
  dpps     xmm2, xmm2, 01110111b
  {$else}
  mulps    xmm2, xmm2
  {$ifdef USE_ASM_SSE_3}
    movhlps xmm3, xmm2  //zwzw
   // haddps  xmm2, xmm2 //x+y+z
    movaps xmm5, xmm2
    andps xmm5, [RIP+cSSE_MASK_NO_W]
    movshdup xmm4,xmm5
    addps  xmm2,xmm4

    addss   xmm2, xmm3 // x + w


  {$else}
    movhlps xmm1, xmm2
    addss   xmm1, xmm2
    shufps  xmm2, xmm2, 01010101b
    addss   xmm2, xmm1
  {$endif}
  {$endif}
  sqrtss  xmm2, xmm2
  shufps  xmm2, xmm2, 00000000b
  divps   xmm0, xmm2
  movaps [RCX], xmm0
end;

function TGLZHmgPlane.Distance(constref point : TGLZVector) : Single; assembler; register; nostackframe;
asm
{.$ifdef TEST}
  movaps xmm0, [RCX]     // xmm0 = Plane->d | Plane->c | Plane->b | Plane->a
  movaps xmm1, [POINT]   // xmm1 = ???????? | Point->z | Point->y | Point->x

  //andps xmm1, [RIP+cSSE_MASK_NO_W] // xmm1 = 0 | ...
  {$ifdef USE_ASM_SSE_4}
    dpps    xmm0, xmm1, 01110111b    //12% slower (6% slower with while..do loop)
    addss   xmm0, [RCX]12
  {$else}
    {$ifdef USE_ASM_SSE_3}  // (1,2%<>4.800% fastest with while..do loop)
      movss xmm4, [RCX]12
      //movaps xmm4, xmm0 WHY WE MUST USE THIS INSTRUCTION BEFORE SHUFFLE ?????????
      //shufps xmm4, xmm0, $FF
      mulps xmm0, xmm1
      movshdup xmm2,xmm0
      movhlps xmm3, xmm0
      addps  xmm0, xmm2    //x+y
      addps  xmm0,xmm3     //(x+y)+z
      addss  xmm0, xmm4    // (x+y+z) + plane.w
    {$else}
      movss xmm0, [RCX]           // fastest 0-4% slower --> +4,249% with while..do loop
      mulss xmm0, [POINT]
      movss xmm1, [RCX]4
      mulss xmm1, [POINT]4
      addss xmm0, xmm1
      movss xmm2, [RCX]8
      mulss xmm2, [POINT]8
      addss xmm0, [RCX]12
      addss xmm0, xmm2
    {$endif}
  {$endif}
end;

function TGLZHmgPlane.AbsDistance(constref point : TGLZVector) : Single; assembler; register; nostackframe;
asm
  movaps xmm0, [RCX]     // xmm0 = Plane->d | Plane->c | Plane->b | Plane->a
  movaps xmm1, [POINT]   // xmm1 = ???????? | Point->z | Point->y | Point->x


  andps xmm1, [RIP+cSSE_MASK_NO_W] // xmm1 = 0 | ...
  movaps xmm7, xmm0                // xmm7 = Plane...

  mulps xmm0, xmm1        // xmm1 = d*0.0 | c*z | b*y | a*x
  shufps xmm7, xmm7, $FF  // xmm7 = d | d | d | d

  {$ifdef USE_ASM_SSE_3}
    movshdup xmm1,xmm0
    addps  xmm0,xmm1
    movhlps xmm1,xmm0
    addss  xmm0,xmm1
    //haddps xmm0, xmm0               // xmm1 = ... | ... | z*c + 0 | x*a + y*b
    //haddps xmm0, xmm0               // xmm1 = ... | ... | dot(Plane, Point)
    addss xmm0, xmm7                // xmm1 = ? | ? | ? | fabsf(dot(Plane, Point)) + Plane->d
    andps xmm0, [RIP+cSSE_MASK_ABS] // xmm1 = ??? | ??? | ??? | abs(dot(Plane, Point))
  {$else}
    movhlps xmm2, xmm0              // xmm2 = ???? | ???? | d*0.0 | z*c */
    addss xmm2, xmm0                // xmm2 = ???? | ???? | ????  | x*a + z*c*/
    shufps xmm0, xmm0, $55          // xmm1 = ???? | ???? | ????  | y*b */
    addss xmm0, xmm2
    addss xmm0, xmm7                // xmm1 = + Plane.W
    andps xmm0, [RIP+cSSE_MASK_ABS] // xmm1 = abs(dot(Plane, Point))
  {$endif}
end;

function TGLZHmgPlane.Perpendicular(constref P : TGLZVector4f) : TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0, [RCX]
  movaps xmm1, [P]
//  andps  xmm1, [RIP+cSSE_MASK_NO_W]  // use this to zero out final W if required
  movaps xmm2, xmm0
  {$IFDEF USE_ASM_SSE_4}
     dpps xmm0, xmm1, 01110111b // |dot|dot|dot|0|
  {$ELSE}
    {$IFDEF USE_ASM_SSE_3}
      mulps   xmm0, xmm1
      movhlps xmm3, xmm0
      haddps  xmm0, xmm0
      addss   xmm0, xmm3
    {$ELSE}
      mulps   xmm0, xmm1             //   xmm0 =  w | z  | y  | x  |
      movhlps xmm3, xmm0             //   xmm1 =  - | -  | w  | z  |
      addps   xmm3, xmm0             // x + z
      shufps  xmm0, xmm0, 00000001b  //   xmm1 =  - | -  | -  | y  |
      addps   xmm0, xmm3             // (x + z ) + y
      andps   xmm0, [RIP+cSSE_MASK_NO_W]   // only SSE2 needs one of these.
    {$ENDIF}
    shufps  xmm0, xmm0, 11000000b    // SSE4 does not need this.
  {$ENDIF}
  mulps   xmm0, xmm2                 // (Dot * Self)
  subps   xmm1, xmm0                 // Self - (Dot * Self) xxx should be P-Dot*Self
  movaps  xmm0, xmm1
 // movhlps xmm1, xmm0
  movaps [RESULT], xmm0
end;

function TGLZHmgPlane.Reflect(constref V: TGLZVector4f): TGLZVector4f; assembler; nostackframe; register;
asm
  movaps xmm0,[V]
  movaps xmm1, [RCX]
  movaps xmm2, xmm1
  movaps xmm3, xmm0
  // Self.Dot(V) Result in xmm1
  {$IFDEF USE_ASM_SSE_4}
     dpps xmm1, xmm0, 01110001b //or $F1
  {$ELSE}
    {$IFDEF USE_ASM_SSE_3}
    {$ifdef CPU64}
      andps xmm0, [RIP+cSSE_MASK_NO_W]
    {$else}
      andps xmm0, [cSSE_MASK_NO_W]
    {$endif}
      mulps xmm1, xmm0
      haddps xmm1, xmm1
      haddps xmm1, xmm1
    {$ELSE}
      andps xmm0, [RIP+cSSE_MASK_NO_W]
      mulps  xmm1, xmm0             //   xmm0 =  w | z  | y  | x  |
      movhlps xmm0, xmm1            //   xmm1 =  - | -  | w  | z  |
      addps xmm0, xmm1              // x + z
      shufps xmm1, xmm1, 00000001b  //   xmm1 =  - | -  | -  | y  |
      addps xmm1, xmm0              // (x + z ) + y
    {$ENDIF}
  {$ENDIF}
  Shufps xmm1,xmm1, $0
  addps xmm1,xmm1  // (2 * N.Dot(Self))
  mulps xmm1, xmm2 // ((2 * N.Dot(Self)) * N)
  subps xmm3, xmm1 // Self - ((2 * N.Dot(Self)) * N)
  movaps [RESULT], xmm3

end;


//function TGLZHmgPlane.Distance(constref Center : TGLZVector; constref Radius:Single) : Single; assembler;
//asm
//  movaps xmm0, [RCX]    // xmm0 = Plane->d | Plane->c | Plane->b | Plane->a
//  movaps xmm1, [Center] // xmm1 = ????????? | Sphere->Center.z | Sphere->Center.y | Sphere->Center.x
//
//  andps xmm1, [RIP+cSSE_MASK_NO_W] // xmm1 = 0 | ...
//  movaps xmm7, xmm0                // xmm7 = Plane...
//
//  mulps xmm1, xmm0        // xmm1 = d*0.0 | c*z | b*y | a*x
//  shufps xmm7, xmm7, $FF  // xmm7 = d | d | d | d
//  {$ifdef USE_ASM_SSE_3}
//    {$ifdef TEST}
//      movshdup    xmm2, xmm1
//      addps       xmm1, xmm2
//      movhlps     xmm2, xmm1
//      addss       xmm1, xmm2
//
//      // https://stackoverflow.com/questions/13219146/how-to-sum-m256-horizontally/13222410#13222410
//      // https://stackoverflow.com/questions/36195356/most-efficient-way-to-get-a-m256-of-horizontal-sums-of-8-source-m256-vectors
//      // https://stackoverflow.com/questions/6996764/fastest-way-to-do-horizontal-float-vector-sum-on-x86/35270026#35270026
//      // https://github.com/pcordes/vectorclass/commits/master
//      // Horizontal Add : https://gcc.godbolt.org/#compilers:!((compiler:g6,options:'-xc+-O3+-Wall+-fverbose-asm+-march%3Dhaswell+-mno-avx',sourcez:MQSwdgxgNgrgJgUwAQB4QFt3gC4CdwB0AFgHwBQoksiqAztnDseWQPStLZEi1I9JQQAa2QBZAIa5x2AOS0ANEgBGMbJwDuCcSLicA9kgh70ABxBRk2A0oTZsCXIb2ICbDtHFgA5khhgAZnq42H7SCFAAnkiIECCIvFa%2BtMjoegBu4ia0rLREMP4muuD0Wrp6/kipaURQWWT%2BUHrSSES0MOgA%2BlkdtMkAjAAUHR3ofQBMABxIaQCUSADeSEvLK6tr62vs00gAvEgA2kgAIkgAwkgAPkgAQkgAgkgAumQrw6OTSLn5y3sjnV/%2BBoILq0AZpRTgpAdUSiDoAZQAEgBVABiKIAMgBRAZjRQAZkUAAZFH0ZjMANxLLaHc4nK63B7PV4jcZTNroXhLX6YDriOBwEFgxQAimbDjs3h7Q5HADU51OMrpNxlDzuMtuTOWAI2XKhPKqCBqgoBwvatFFqy2B2W5yWStl8sVTypHAsai4yCMpnMDiQ4jSejifsq6WUUVwCBgtHAPgBLy1Zp1uz1nT5At6Awlwry/gp8aWEZCuDArx5EDS2F6HX8eLGmbNeYAvmR6o1mq12iCesk8UMWR9Zgt81D%2B2yc8m/iN0oa4DATILZpT1lslLgmnAIOJ6Ehwgh0AgwJWkAS%2BvokLjCcO3qzPonuan%2BQvs/k8yttet71O0oaoMac6aOVFLZuC8IgWnEKAKgAWhIAQ9HUcDIOHCUNk/NNu3rDln1zclh0LGBiw2Sdy0rWhq1rTDzVw5sWy2Wh0AgixHCMGhowALwQRQVDUKMYEYqJaEaTRHD8CxeicRAoPY5B%2BHEJATDXJQLHQVsmjUDtOm6Ig0z7d4pkHeYr1HW8OQnHltMfLIhWmV8E1Mj8Uw6CyBSsrMJVsgtbAIkt1mIisqxrOt3OoltQH8RAKmGO4ADUAA1hlU9t2TGABWAA2Lt/QAD101K0psodmT06YhN1P48o6Td6CyCqslZMEPJHYrqhAUCzPQCqECyvBxAgbB/FZJ8kFJSlgNasDWSM5qb3a3lLNBNIhIhECiAtZYtjTTgiGQUrJpWfDCI0rtegQXs0lZNakw2sAijAQQwEsbbPh7aYHGjPQwEUdRuAgMD%2BD0ExsAwCCkECRwYti4ctgGMADHULd7Fu%2BhcBgPqQA%2BhQ/Ruv0oCgJByi2vc/QjQmkAAFluLAwAwdoZjIZtgAPRh/BbNx2HZrY4D0GAlIQMguZ5iwWnZLp02SOtr0mXQ0jgOZFiTBWtjSZNDluK5GSmm8/AisqeW1hB/HABAXNBS6FY2TmPpkNR1CCXAIi%2B5APsiJJkDTOEjkUB7v0cKxUe4bxSa8SQlHELxkCUEAj3UKOwM8JAUQABT9flNY%2BAFsFMT8DSNKz9f8RRiIRwoF1li0tg9En%2BFhkNqlqOA04mXR30/KrsG6QpMxzTOTEag6fL8ysBX8NKyaGHl0NoOAwTgbCyRC2iOY5vhD1rMgcGFzsEDMWtuwQCXRxAJAsrligQHCg2RwhhKitZI/uFH3XOj8ExeqEbgOm3kBR4GLLFBPpcOoth4iggDBwnhdCwzAFBeIeBUZA2/PcOKAhbC8CjJ8f0bswz2CQDHLg3M1APWNjGYMVQKDhGSI3e%2B38yZPx6DmIEn8d51j/lCGE8JkRoixAMPoRJ8SKDGPPchN1z5UJMo/NCj4v4UQfmTf%2BjVJYTGobWOhAIgSNCYSAPoaVMKj0LuwxEqIMTYl4UgYkx4BHzxWFsOE8MTCk1KtgW2O5lIHkrGI9kKjJECmkUFdoeiWggFrH3LyhFB7RkGtGCinjBGAOsRwOEcJMRjFrg3eJ/dHJdR6n1TRMioBEjNjYpJcidzfhLPgmAbUo5OG9GJM8VQkb2D5PjCoclBD2CkHjEwWTcC6FwLWeQWVMDyEvDRDeR1fHdh7D0ISPQGK4xYggXSd9j4zEMisLKs1nK5JYfI3CGytnoV8b/PZeFQklnCVoyYPQgksKbKzReKdMiI1BmudASAJBSFkLwCGLQ7AmAAFzsHoG/acuAGjwQIF6VgABHGACB6DozANkPotY%2BgAE4%2BhkzSqwIg8EoJWCku0KCHV0pQTxfgNiH1sD8VYKisYDKyZ9EJMAeljLmWJXUiLboDEvnLI%2BCfQqywjDIrUIokyABFPiug9hZX2cKjGYrjKNCOHxPGex2RSr5PKl0gTVUgz2AMJAUFFAmuPniJAMpj4AHZ/4pKtVlfKdMVgiu3OK7g%2Br1WORzr%2BVy7QtWz0ldKxqdF2ieuTEas1ZqsqngdRah1KVLU2v/oSJNWV7XH1oQ6p1w5XVKuKuycN3jBQqrVYoD1aqQ2ugMIa41pr63H1TQ6jNWUs3HxzS6xVTUbyNGTIWtVOqkBjQjXW0d0bY3mrTYmh11qkDOoVaK7tHxuCzTURYY0Yay0mU9USGNVaTIjqjQ2rKTbj4TvTWm%2BNmap1pvyjOuduau3ivZLNSeoJGjlpAOXDg6EsjRANlob5hgoCeC8HIT4DChYAyBlgDiuAzlFguWWfyZFAqYXuUAA%3D%3D)),filterAsm:(binary:!t,commentOnly:!t,directives:!t,intel:!t,labels:!t),version:3
//      { hsum_ps_marat:
//         movaps xmm1,xmm0
//         movhlps xmm1,xmm0
//         addps  xmm0,xmm1
//         movaps xmm1,xmm0
//         shufps xmm1,xmm0,0x1
//         addss  xmm0,xmm1
//      }
//      { AVX :
//       vmovaps xmm2,xmm1
//       vextractf128 xmm2,ymm1,1
//       vaddps xmm1,xmm2,xmm1
//       vmovshdup xmm2,xmm1
//       vaddps xmm2,xmm2,xmm1
//       vmovhlps xmm2,xmm1,xmm1
//       vaddss xmm1,xmm1,xmm2
//       //vzeroupper ????
//      }
//    {$else}
//      haddps xmm1, xmm1               // xmm1 = ... | ... | z*c + 0 | x*a + y*b
//      haddps xmm1, xmm1               // xmm1 = ... | ... | dot(pPlane, pSphere->Center)
//    {$endif}
//      andps xmm1, [RIP+cSSE_MASK_ABS] // xmm1 = ? | ? | ? | abs(dot(Plane, Sphere->Center))
//      addss xmm1, xmm7                // xmm1 = ? | ? | ? | + pPlane->d
//  {$else}
//    movhlps xmm2, xmm1              // xmm2 = ???? | ???? | d*0.0 | z*c
//    addss xmm2, xmm1                // xmm2 = ???? | ???? | ????  | x*a + z*c
//    shufps xmm1, xmm1, $55          // xmm1 = ???? | ???? | ????  | y*b
//    andps xmm1, [RIP+cSSE_MASK_ABS] // xmm1 = ???? | ???? | ????  | abs(dot(Plane, Sphere->Center))
//    addss xmm1, xmm2                // xmm1 = ???? | ???? | ????  | + Plane->d
//  {$endif}
//
//  xorps xmm7, xmm7    // xmm7 = 0 | 0 | 0 | 0
//
//  // Subtract radius
//  movlps xmm3, [Radius]
//  subss xmm1, xmm3   // xmm1 = ? | ? | ? | dist - radius
//  maxss xmm1, xmm7   // xmm1 = ? | ? | ? | max(0, dist-radius)
//
//  movss [RESULT], {%H-}xmm1
//end;

