{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

// Internal for pascal only
{%region%----[ Misc Vector Helpers functions ]----------------------------------}

function AffineVectorMake(const x, y, z : Single) : TGLZAffineVector;
begin
   Result.X:=x;
   Result.Y:=y;
   Result.Z:=z;
end;

function AffineVectorMake(const v : TGLZVector) : TGLZAffineVector;
begin
   Result.X:=v.X;
   Result.Y:=v.Y;
   Result.Z:=v.Z;
end;

function vec2(vx,vy:single):TGLZVector2f;
begin
  result.Create(vx,vy);
end;

function vec4(vx,vy,vz,vw:single):TGLZVector4f;
begin
  result.Create(vx,vy,vz,vw);
end;

function vec4(vx:single):TGLZVector4f;
begin
  result.Create(vx,vx,vx,vx);
end;

function Affinevec4(vx:single):TGLZVector4f;
begin
  result.Create(vx,vx,vx,1);
end;

function AffineVec4(vx,vy,vz:single):TGLZVector4f;
begin
  result.Create(vx,vy,vz,1);
end;

{%endregion%}

{%region%----[ Misc functions for non complete records ]------------------------}
// pascal only functions for simple records which have few or one method.
// items may be moved to full incs when requred.


{%endregion%}


{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

//----------- Algebra and Trigo fo TGLZvector2f --------------------------------

Type
  TSinCosRemezArrayType = array[0..4] of TSinCos;

Const
  SinCos_Remez_const : TSinCosRemezArrayType = ((sin:0.99997937679290771484375;
                                   cos:1.0),
                                  (sin:-0.166624367237091064453125;
                                   cos:-0.49985158205212948 ),
                                  (sin:8.30897875130176544189453125e-3;
                                   cos:4.151803521644389800e-2 ),
                                  (sin:-1.92649182281456887722015380859375e-4;
                                   cos:-1.34229470252267675e-3 ),
                                  (sin:2.147840177713078446686267852783203125e-6 ;
                                   cos:1.89298648243010005378029e-5 ));



function Sin(v:TGLZVector2f):TGLZVector2f; overload;
begin
  result.X := Sin(v.X);
  result.Y := Sin(v.Y);
end;

//function Sin(v:TGLZVector4f):TGLZVector4f; overload;
function Cos(v:TGLZVector2f):TGLZVector2f; overload;
begin
  result.X := Cos(v.X);
  result.Y := Sin(v.Y);
end;
//function Cos(v:TGLZVector2f):TGLZVector4f; overload;

function SinCos(x:Single):TGLZvector2f;
begin
  result.X := Sin(x);
  result.Y := Cos(x);
end;

function SinCos(v:TGLZVector2f):TGLZvector2f;
begin
  result.X := Sin(v.X);
  result.Y := Cos(v.Y);
end;

function Fract(Constref v:TGLZVector4f):TGLZVector4f;
var
  vt : TGLZVector4f;
  vi : TGLZVector4i;
begin
  vi := v.Floor;
  vt.Create(vi.x,vi.y,vi.z,vi.W);
  vt := v - vt;
  result := vt;    //vt.Trunc
end;



{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

function Trunc(Constref v:TGLZVector2f):TGLZVector2i;
begin
  result := v.Trunc;
end;

function Round(Constref v:TGLZVector2f):TGLZVector2i;
begin
  result := v.Round;
end;

function Floor(Constref v:TGLZVector2f):TGLZVector2i;
begin
  result := v.Floor;
end;

function Ceil(Constref v:TGLZVector2f):TGLZVector2i;
begin
  result := v.Ceil;
end;

function Fract(Constref v:TGLZVector2f):TGLZVector2f;
var
  vt : TGLZVector2f;
  vi : TGLZVector2i;
begin
  vi := v.Floor;
  vt.Create(vi.x,vi.y);
  vt := v - vt;
  result := vt;    //vt.Trunc
end;

function Sqrt(Constref v:TGLZVector2f):TGLZVector2f;
begin
  result.Create(Sqrt(v.X), Sqrt(v.Y));
end;

function InvSqrt(Constref v:TGLZVector2f):TGLZVector2f;
begin
  result.Create(InvSqrt(v.X), InvSqrt(v.Y));
end;


//procedure ConvertQuaternionToArcPoints(Constref Q : TGLZQuaternion; var ArcFrom, ArcTo: TGLZVector);
//var
//   s, invS : Single;
//begin
//   s:=Q.ImagePart.X*Q.ImagePart.X+Q.ImagePart.Y*Q.ImagePart.Y;
//   if s=0 then ArcFrom := AffineVectorMake( 0, 1, 0)
//   else
//   begin
//      invS:=InvSqrt(s);
//      ArcFrom := AffineVectorMake( -Q.ImagePart.Y*invS, Q.ImagePart.X*invS, 0);
//   end;
//   ArcTo.X:=Q.RealPart*ArcFrom.X-Q.ImagePart.Z*ArcFrom.Y;
//   ArcTo.Y:=Q.RealPart*ArcFrom.Y+Q.ImagePart.Z*ArcFrom.X;
//   ArcTo.Z:=Q.ImagePart.X*ArcFrom.Y-Q.ImagePart.Y*ArcFrom.X;
//   if Q.RealPart<0 then ArcFrom := AffineVectorMake( -ArcFrom.X, -ArcFrom.Y, 0);
//end;

{%endregion%}

{$ENDIF}
