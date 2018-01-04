{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

function TGLZMatrix4f.GetComponent(const ARow, AColumn: Integer): Single;
begin
  Result := Self.M[ARow, AColumn];
end;

procedure TGLZMatrix4f.SetComponent(const ARow, AColumn: Integer; const Value: Single);
begin
  Self.M[ARow, AColumn] := Value;
end;

procedure TGLZMatrix4f.SetRow(const AIndex: Integer; const Value: TGLZVector);
begin
  Self.V[AIndex] := Value;
end;

function TGLZMatrix4f.GetRow(const AIndex: Integer): TGLZVector;
begin
  Result := V[AIndex];
end;

function TGLZMatrix4f.ToString : String;
begin
  Result :='|'+V[0].ToString+'|'+#13+#10
          +'|'+V[1].ToString+'|'+#13+#10
          +'|'+V[2].ToString+'|'+#13+#10
          +'|'+V[3].ToString+'|'+#13+#10
End;

procedure TGLZMatrix4f.CreateIdentityMatrix;
begin
  Self:=IdentityHmgMatrix;
End;

procedure TGLZMatrix4f.CreateScaleMatrix(const v : TGLZAffineVector);
begin
   Self:=IdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TGLZMatrix4f.CreateScaleMatrix(const v : TGLZVector);
begin
   Self:=IdentityHmgMatrix;
   Self.X.X:=v.X;
   Self.Y.Y:=v.Y;
   Self.Z.Z:=v.Z;
end;

procedure TGLZMatrix4f.CreateTranslationMatrix(const V: TGLZAffineVector);
begin
   Self:=IdentityHmgMatrix;
   Self.W.X:=V.X;
   Self.W.Y:=V.Y;
   Self.W.Z:=V.Z;
end;

procedure TGLZMatrix4f.CreateTranslationMatrix(const V: TGLZVector);
begin
   Self:=IdentityHmgMatrix;
   Self.W.X:=V.X;
   Self.W.Y:=V.Y;
   Self.W.Z:=V.Z;
end;

procedure TGLZMatrix4f.CreateScaleAndTranslationMatrix(const ascale, offset : TGLZVector);
begin
   Self:=IdentityHmgMatrix;
   Self.X.X:=ascale.X;   Self.W.X:=offset.X;
   Self.Y.Y:=ascale.Y;   Self.W.Y:=offset.Y;
   Self.Z.Z:=ascale.Z;   Self.W.Z:=offset.Z;
end;

procedure TGLZMatrix4f.CreateRotationMatrixX(const sine, cosine: Single);
begin
   Self:=EmptyHmgMatrix;
   Self.X.X:=1;
   Self.Y.Y:=cosine;
   Self.Y.Z:=sine;
   Self.Z.Y:=-sine;
   Self.Z.Z:=cosine;
   Self.W.W:=1;
end;

procedure TGLZMatrix4f.CreateRotationMatrixX(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixX(s, c);
end;

procedure TGLZMatrix4f.CreateRotationMatrixY(const sine, cosine: Single);
begin
   Self:=EmptyHmgMatrix;
   Self.X.X:=cosine;
   Self.X.Z:=-sine;
   Self.Y.Y:=1;
   Self.Z.X:=sine;
   Self.Z.Z:=cosine;
   Self.W.W:=1;
end;

procedure TGLZMatrix4f.CreateRotationMatrixY(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixY(s, c);
end;

procedure TGLZMatrix4f.CreateRotationMatrixZ(const sine, cosine: Single);
begin
   Self:=EmptyHmgMatrix;
   Self.X.X:=cosine;
   Self.X.Y:=sine;
   Self.Y.X:=-sine;
   Self.Y.Y:=cosine;
   Self.Z.Z:=1;
   Self.W.W:=1;
end;

procedure TGLZMatrix4f.CreateRotationMatrixZ(const angle : Single);
var
   s, c : Single;
begin
   //GLZMath.
   SinCos(angle, s, c);
   CreateRotationMatrixZ(s, c);
end;

procedure TGLZMatrix4f.CreateRotationMatrix(const anAxis : TGLZAffineVector; angle : Single);
var
   axis : TGLZVector;
   cosine, sine, one_minus_cosine : Single;
begin
   axis.AsVector3f := anAxis;
   //GLZMath.
   SinCos(angle, sine, cosine);
   one_minus_cosine:=1-cosine;
   axis.Normalize;

   Self.X.X:=(one_minus_cosine * axis.V[0] * axis.V[0]) + cosine;
   Self.X.Y:=(one_minus_cosine * axis.V[0] * axis.V[1]) - (axis.V[2] * sine);
   Self.X.Z:=(one_minus_cosine * axis.V[2] * axis.V[0]) + (axis.V[1] * sine);
   Self.X.W:=0;

   Self.Y.X:=(one_minus_cosine * axis.V[0] * axis.V[1]) + (axis.V[2] * sine);
   Self.Y.Y:=(one_minus_cosine * axis.V[1] * axis.V[1]) + cosine;
   Self.Y.Z:=(one_minus_cosine * axis.V[1] * axis.V[2]) - (axis.V[0] * sine);
   Self.Y.W:=0;

   Self.Z.X:=(one_minus_cosine * axis.V[2] * axis.V[0]) - (axis.V[1] * sine);
   Self.Z.Y:=(one_minus_cosine * axis.V[1] * axis.V[2]) + (axis.V[0] * sine);
   Self.Z.Z:=(one_minus_cosine * axis.V[2] * axis.V[2]) + cosine;
   Self.Z.W:=0;

   Self.W.X:=0;
   Self.W.Y:=0;
   Self.W.Z:=0;
   Self.W.W:=1;
end;

procedure TGLZMatrix4f.CreateRotationMatrix(const anAxis : TGLZVector; angle : Single);
begin
   CreateRotationMatrix(anAxis.AsVector3f, angle);
end;


(* function TGLZMatrix4f.Invert:TGLZMatrix4;
var
   det : Single;
begin
   det:=GetDeterminant;
   if Abs(Det)<cEPSILON then  result:=IdentityHmgMatrix
   else
   begin
      Self.Adjoint;
      result := Self * (1/det);
   end;
end; *)



function TGLZMatrix4f.Decompose(var Tran: TGLZMatrixTransformations): Boolean;
var
   I, J: Integer;
   LocMat, pmat, invpmat : TGLZMatrix;
   prhs, psol: TGLZVector;
   row0, row1, row2 : TGLZVector;
   f : Single;
begin
  Result:=False;
  locmat:=Self;
  // normalize the matrix
  if LocMat.W.W = 0 then Exit;
  for I:=0 to 3 do
    for J:=0 to 3 do
      Locmat.V[I].V[J]:=locmat.V[I].V[J] / locmat.W.W;

  // pmat is used to solve for perspective, but it also provides
  // an easy way to test for singularity of the upper 3x3 component.

  pmat:=locmat;
  for I:=0 to 2 do pmat.V[I].W:=0;
  pmat.W.W:=1;

  if pmat.Determinant = 0 then Exit;

  // First, isolate perspective.  This is the messiest.
  if (locmat.X.W <> 0) or (locmat.Y.W <> 0) or (locmat.Z.W <> 0) then
  begin
    // prhs is the right hand side of the equation.
    prhs.X:=locmat.X.W;
    prhs.Y:=locmat.Y.W;
    prhs.Z:=locmat.Z.W;
    prhs.W:=locmat.W.W;

    // Solve the equation by inverting pmat and multiplying
    // prhs by the inverse.  (This is the easiest way, not
    // necessarily the best.)

    invpmat:=pmat;
    invpmat.Invert;
    invpmat.Transpose;
    psol:=  invpmat * prhs; //VectorTransform(prhs, invpmat);

    // stuff the answer away
    Tran[ttPerspectiveX]:=psol.X;
    Tran[ttPerspectiveY]:=psol.Y;
    Tran[ttPerspectiveZ]:=psol.Z;
    Tran[ttPerspectiveW]:=psol.W;

    // clear the perspective partition
    locmat.X.W:=0;
    locmat.Y.W:=0;
    locmat.Z.W:=0;
    locmat.W.W:=1;
  end
  else
  begin
    // no perspective
    Tran[ttPerspectiveX]:=0;
    Tran[ttPerspectiveY]:=0;
    Tran[ttPerspectiveZ]:=0;
    Tran[ttPerspectiveW]:=0;
  end;

  // next take care of translation (easy)
  for I:=0 to 2 do
  begin
    Tran[TGLZMAtrixTransType(Ord(ttTranslateX) + I)]:=locmat.V[3].V[I];
    locmat.V[3].V[I]:=0;
  end;

  // now get scale and shear
  row0 := locmat.X;
  row1 := locmat.Y;
  row2 := locmat.Z;

  // compute X scale factor and normalize first row
  Tran[ttScaleX]:=Row0.Norm;
  Row0 := Row0 * RSqrt(Tran[ttScaleX]); //VectorScale(row0, RSqrt(Tran[ttScaleX]));

  // compute XY shear factor and make 2nd row orthogonal to 1st
  Tran[ttShearXY]:=row0.DotProduct(row1);
  f:=-Tran[ttShearXY];
  Row1.Combine(row0, f);

  // now, compute Y scale and normalize 2nd row
  Tran[ttScaleY]:=Row1.Norm;
  Row1 := Row1 * RSqrt(Tran[ttScaleY]); //VectorScale(row1, RSqrt(Tran[ttScaleY]));
  Tran[ttShearXY]:=Tran[ttShearXY]/Tran[ttScaleY];

  // compute XZ and YZ shears, orthogonalize 3rd row
  Tran[ttShearXZ]:=row0.DotProduct(row2);
  f:=-Tran[ttShearXZ];
  row2.Combine(row0, f);
  Tran[ttShearYZ]:=Row1.DotProduct(row2);
  f:=-Tran[ttShearYZ];
  Row2.Combine(row1, f);

  // next, get Z scale and normalize 3rd row
  Tran[ttScaleZ]:=Row2.Norm;
  Row2:=row2* RSqrt(Tran[ttScaleZ]);
  Tran[ttShearXZ]:=Tran[ttShearXZ] / tran[ttScaleZ];
  Tran[ttShearYZ]:=Tran[ttShearYZ] / Tran[ttScaleZ];

  // At this point, the matrix (in rows[]) is orthonormal.
  // Check for a coordinate system flip.  If the determinant
  // is -1, then negate the matrix and the scaling factors.
  if row0.DotProduct(row1.CrossProduct(row2)) < 0 then
  begin
    for I:=0 to 2 do
      Tran[TGLZMatrixTransType(Ord(ttScaleX) + I)]:=-Tran[TGLZMatrixTransType(Ord(ttScaleX) + I)];
    row0.pNegate;
    row1.pNegate;
    row2.pNegate;
  end;

  // now, get the rotations out, as described in the gem
  Tran[ttRotateY]:=GLZMath.ArcSine(-row0.Z);
  if cos(Tran[ttRotateY]) <> 0 then
  begin
    Tran[ttRotateX]:=GLZMath.ArcTan2(row1.Z, row2.Z);
    Tran[ttRotateZ]:=GLZMath.ArcTan2(row0.Y, row0.X);
  end else
  begin
    tran[ttRotateX]:=GLZMath.ArcTan2(row1.X, row1.Y);
    tran[ttRotateZ]:=0;
  end;
  // All done!
  Result:=True;
end;



procedure TGLZMatrix4f.CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);
begin
  Self.X.X := 2 * ZNear / (Right - Left);
  Self.X.Y := 0;
  Self.X.Z := 0;
  Self.X.W := 0;

  Self.Y.X := 0;
  Self.Y.Y := 2 * ZNear / (Top - Bottom);
  Self.Y.Z := 0;
  Self.Y.W := 0;

  Self.Z.X := (Right + Left) / (Right - Left);
  Self.Z.Y := (Top + Bottom) / (Top - Bottom);
  Self.Z.Z := -(ZFar + ZNear) / (ZFar - ZNear);
  Self.Z.W := -1;

  Self.W.X := 0;
  Self.W.Y := 0;
  Self.W.Z := -2 * ZFar * ZNear / (ZFar - ZNear);
  Self.W.W := 0;
end;

procedure TGLZMatrix4f.CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);
var
  xx, yy: Single;
begin
  FOV := Min2s(179.9, Max2s(0, FOV));
  yy:= ZNear * GLZMath.Tan(GLZMath.DegToRadian(FOV) * 0.5);
  xx:= yy * Aspect;
  CreateMatrixFromFrustum(-xx, xx, -yy, yy, ZNear, ZFar);
end;

procedure TGLZMatrix4f.CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);
begin
  Self.V[0].V[0] := 2 / (Right - Left);
  Self.V[0].V[1] := 0;
  Self.V[0].V[2] := 0;
  Self.V[0].V[3] := 0;

  Self.V[1].V[0] := 0;
  Self.V[1].V[1] := 2 / (Top - Bottom);
  Self.V[1].V[2] := 0;
  Self.V[1].V[3] := 0;

  Self.V[2].V[0] := 0;
  Self.V[2].V[1] := 0;
  Self.V[2].V[2] := -2 / (ZFar - ZNear);
  Self.V[2].V[3] := 0;

  Self.V[3].V[0] := (Left + Right) / (Left - Right);
  Self.V[3].V[1] := (Bottom + Top) / (Bottom - Top);
  Self.V[3].V[2] := (ZNear + ZFar) / (ZNear - ZFar);
  Self.V[3].V[3] := 1;
end;

procedure TGLZMatrix4f.CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i);
begin
  if (deltax <= 0) or (deltay <= 0) then
  begin
    Self := IdentityHmgMatrix;
    exit;
  end;
  // Translate and scale the picked region to the entire window
  CreateTranslationMatrix(AffineVectorMake( (viewport.V[2] - 2 * (x - viewport.V[0])) / deltax,
	                                    (viewport.V[3] - 2 * (y - viewport.V[1])) / deltay,
                                            0.0));
  Self.V[0].V[0] := viewport.V[2] / deltax;
  Self.V[1].V[1] := viewport.V[3] / deltay;
end;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

function TGLZMatrix4f.MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
// internal version for the determinant of a 3x3 matrix
begin
  Result:=  a1 * (b2 * c3 - b3 * c2)
          - b1 * (a2 * c3 - a3 * c2)
          + c1 * (a2 * b3 - a3 * b2);
end;




{ TODO 1 -oTMatrix4 -cASM : Adjoint : Add SSE/AVX Version }
procedure TGLZMatrix4f.Adjoint;
var
   a1, a2, a3, a4,
   b1, b2, b3, b4,
   c1, c2, c3, c4,
   d1, d2, d3, d4: Single;
begin
    a1:= Self.X.X; b1:= Self.X.Y;
    c1:= Self.X.Z; d1:= Self.X.W;
    a2:= Self.Y.X; b2:= Self.Y.Y;
    c2:= Self.Y.Z; d2:= Self.Y.W;
    a3:= Self.Z.X; b3:= Self.Z.Y;
    c3:= Self.Z.Z; d3:= Self.Z.W;
    a4:= Self.W.X; b4:= Self.W.Y;
    c4:= Self.W.Z; d4:= Self.W.W;

    // row column labeling reversed since we transpose rows & columns
    Self.X.X:= MatrixDetInternal(b2, b3, b4, c2, c3, c4, d2, d3, d4);
    Self.X.Y:=-MatrixDetInternal(b1, b3, b4, c1, c3, c4, d1, d3, d4);
    Self.X.Z:= MatrixDetInternal(b1, b2, b4, c1, c2, c4, d1, d2, d4);
    Self.X.W:=-MatrixDetInternal(b1, b2, b3, c1, c2, c3, d1, d2, d3);

    Self.Y.X:=-MatrixDetInternal(a2, a3, a4, c2, c3, c4, d2, d3, d4);
    Self.Z.X:= MatrixDetInternal(a2, a3, a4, b2, b3, b4, d2, d3, d4);
    Self.W.X:=-MatrixDetInternal(a2, a3, a4, b2, b3, b4, c2, c3, c4);


    Self.Y.Y:= MatrixDetInternal(a1, a3, a4, c1, c3, c4, d1, d3, d4);
    Self.Z.Y:=-MatrixDetInternal(a1, a3, a4, b1, b3, b4, d1, d3, d4);
    Self.W.Y:= MatrixDetInternal(a1, a3, a4, b1, b3, b4, c1, c3, c4);


    Self.Y.Z:=-MatrixDetInternal(a1, a2, a4, c1, c2, c4, d1, d2, d4);
    Self.Z.Z:= MatrixDetInternal(a1, a2, a4, b1, b2, b4, d1, d2, d4);
    Self.W.Z:=-MatrixDetInternal(a1, a2, a4, b1, b2, b4, c1, c2, c4);


    Self.Y.W:= MatrixDetInternal(a1, a2, a3, c1, c2, c3, d1, d2, d3);
    Self.Z.W:=-MatrixDetInternal(a1, a2, a3, b1, b2, b3, d1, d2, d3);
    Self.W.W:= MatrixDetInternal(a1, a2, a3, b1, b2, b3, c1, c2, c3);
end;

{ TODO 1 -oTMatrix4 -cASM : Add SSE/AVX Version }
procedure TGLZMatrix4f.Transpose_Scale_M33(constref src : TGLZMatrix4f; Constref ascale : Single);
// EAX src
// EDX dest
// ECX scale
begin
   Self.V[0].V[0]:=ascale*src.V[0].V[0];
   Self.V[1].V[0]:=ascale*src.V[0].V[1];
   Self.V[2].V[0]:=ascale*src.V[0].V[2];

   Self.V[0].V[1]:=ascale*src.V[1].V[0];
   Self.V[1].V[1]:=ascale*src.V[1].V[1];
   Self.V[2].V[1]:=ascale*src.V[1].V[2];

   Self.V[0].V[2]:=ascale*src.V[2].V[0];
   Self.V[1].V[2]:=ascale*src.V[2].V[1];
   Self.V[2].V[2]:=ascale*src.V[2].V[2];
end;



{ TODO 1 -oTMatrix4 -cASM : Add SSE/AVX Version }
procedure TGLZMatrix4f.AnglePreservingMatrixInvert(constref mat : TGLZMatrix4f);
var
   ascale : Single;
begin
   ascale:=mat.V[0].Norm;

   // Is the submatrix A singular?
   if Abs(ascale)<cEPSILON then
   begin
      // Matrix M has no inverse
      Self:=IdentityHmgMatrix;
      Exit;
   end
   else
   begin
      // Calculate the inverse of the square of the isotropic scale factor
      ascale:=1.0/ascale;
   end;

   // Fill in last row while CPU is busy with the division
   Self.V[0].V[3]:=0.0;
   Self.V[1].V[3]:=0.0;
   Self.V[2].V[3]:=0.0;
   Self.V[3].V[3]:=1.0;

   // Transpose and scale the 3 by 3 upper-left submatrix
   Self.transpose_scale_m33(mat,ascale);

   // Calculate -(transpose(A) / s*s) C
   Self.V[3].V[0]:=-(Self.V[0].V[0]*mat.V[3].V[0]
                    +Self.V[1].V[0]*mat.V[3].V[1]
                    +Self.V[2].V[0]*mat.V[3].V[2]);
   Self.V[3].V[1]:=-(Self.V[0].V[1]*mat.V[3].V[0]
                    +Self.V[1].V[1]*mat.V[3].V[1]
                    +Self.V[2].V[1]*mat.V[3].V[2]);
   Self.V[3].V[2]:=-(Self.V[0].V[2]*mat.V[3].V[0]
                    +Self.V[1].V[2]*mat.V[3].V[1]
                    +Self.V[2].V[2]*mat.V[3].V[2]);
end;

{ TODO 1 -oTMatrix4 -cASM : Add SSE/AVX Version }
procedure TGLZMatrix4f.CreateLookAtMatrix(const eye, center, normUp: TGLZVector);
var
  XAxis, YAxis, ZAxis, negEye: TGLZVector;
begin
  ZAxis := center - eye;
  ZAxis.Normalize;
  XAxis := ZAxis.CrossProduct(normUp);
  XAxis.Normalize;
  YAxis := XAxis.CrossProduct(ZAxis);
  Self.V[0] := XAxis;
  Self.V[1] := YAxis;
  Self.V[2] := ZAxis;
  Self.V[2].pNegate;
  Self.V[3] := NullHmgPoint;
  Self.Transpose;
  negEye := eye;
  negEye.pNegate;
  negEye.V[3] := 1;
  negEye :=  Self * negEye ; //VectorTransform(negEye, Self);
  Self.V[3] := negEye;
end;

procedure TGLZMatrix4f.CreateParallelProjectionMatrix(const plane : TGLZHmgPlane;const dir : TGLZVector);
// Based on material from a course by William D. Shoaff (www.cs.fit.edu)
var
   dot, invDot : Single;
begin
   dot:=plane.V[0]*dir.V[0]+plane.V[1]*dir.V[1]+plane.V[2]*dir.V[2];
   if Abs(dot)<1e-5 then
   begin
      Self:=IdentityHmgMatrix;
      Exit;
   end;
   invDot:=1/dot;

   Self.V[0].V[0]:=(plane.V[1]*dir.V[1]+plane.V[2]*dir.V[2])*invDot;
   Self.V[1].V[0]:=(-plane.V[1]*dir.V[0])*invDot;
   Self.V[2].V[0]:=(-plane.V[2]*dir.V[0])*invDot;
   Self.V[3].V[0]:=(-plane.V[3]*dir.V[0])*invDot;

   Self.V[0].V[1]:=(-plane.V[0]*dir.V[1])*invDot;
   Self.V[1].V[1]:=(plane.V[0]*dir.V[0]+plane.V[2]*dir.V[2])*invDot;
   Self.V[2].V[1]:=(-plane.V[2]*dir.V[1])*invDot;
   Self.V[3].V[1]:=(-plane.V[3]*dir.V[1])*invDot;

   Self.V[0].V[2]:=(-plane.V[0]*dir.V[2])*invDot;
   Self.V[1].V[2]:=(-plane.V[1]*dir.V[2])*invDot;
   Self.V[2].V[2]:=(plane.V[0]*dir.V[0]+plane.V[1]*dir.V[1])*invDot;
   Self.V[3].V[2]:=(-plane.V[3]*dir.V[2])*invDot;

   Self.V[0].V[3]:=0;
   Self.V[1].V[3]:=0;
   Self.V[2].V[3]:=0;
   Self.V[3].V[3]:=1;
end;

procedure TGLZMatrix4f.CreateShadowMatrix(const planePoint, planeNormal, lightPos : TGLZVector);
var
   planeNormal3, dot : Single;
   v1,v2  : TGLZVector;
   //, vl, vpn
begin
  v1 := planeNormal;
  v1.W := 0;

  v2 := planePoint;
  v2.W := 0;
	// Find the last coefficient by back substitutions
  v2 := v1 * v2;
  planeNormal3 := -(v2.X+v2.Y+v2.Z);
(*	planeNormal3:=-( planeNormal.V[0]*planePoint.V[0]
                   +planeNormal.V[1]*planePoint.V[1]
                   +planeNormal.V[2]*planePoint.V[2]); *)
	// Dot product of plane and light position
  v2 := LightPos;
	// Find the last coefficient by back substitutions
  v1 := v1 * v2;
  dot := (v1.X+v1.Y+v1.Z+(planeNormal3 * v2.W));
(*	dot:= planeNormal.V[0]*lightPos.V[0]
        +planeNormal.V[1]*lightPos.V[1]
        +planeNormal.V[2]*lightPos.V[2]
        +planeNormal3  *lightPos.V[3]; *)

	// Now do the projection
	// First column


  //---- OPTIMIZATION ---------------------------
  //vpn1.Create(planeNormal.X,planeNormal.X,planeNormal.X,planeNormal.X);
  //vpn2.Create(planeNormal.Y,planeNormal.Y,planeNormal.Y,planeNormal.Y);
  //vpn3.Create(planeNormal.Z,planeNormal.Z,planeNormal.Z,planeNormal.Z);
  //vpn4.Create(planeNormal3,planeNormal3,planeNormal3,planeNormal3);
  //vl := lightPos;

  //v2 := v1 * vpn1
  //v3.Create(dot, 0, 0, 0)
  //Self.V[0] := v3 - v2;

  //v2 := v1 * vpn2
  //v3.Create(0, dot, 0, 0)
  //Self.V[1] := v3 - v2;

  //v2 := v1 * vpn3
  //v3.Create(0, 0, dot, 0)
  //Self.V[2] := v3 - v2;

  //v2 := v1 * vpn3
  //v3.Create(0, 0, 0, dot)
  //Self.V[3] := v3 - v2;
  //----------------------------------------------------

  Self.V[0].X:= dot - lightPos.X * planeNormal.X;
  Self.V[1].X:=     - lightPos.X * planeNormal.Y;
  Self.V[2].X:=     - lightPos.X * planeNormal.Z;
  Self.V[3].X:=     - lightPos.X * planeNormal3;
	// Second column
	Self.V[0].Y :=     - lightPos.Y * planeNormal.X;
	Self.V[1].Y := dot - lightPos.Y * planeNormal.Y;
	Self.V[2].Y :=     - lightPos.Y * planeNormal.Z;
	Self.V[3].Y :=     - lightPos.Y * planeNormal3;
	// Third Column
	Self.V[0].Z :=     - lightPos.Z * planeNormal.X;
	Self.V[1].Z :=     - lightPos.Z * planeNormal.Y;
	Self.V[2].Z := dot - lightPos.Z * planeNormal.Z;
	Self.V[3].Z :=     - lightPos.Z * planeNormal3;
	// Fourth Column
	Self.V[0].W :=     - lightPos.W * planeNormal.X;
	Self.V[1].W :=     - lightPos.W * planeNormal.Y;
	Self.V[2].W :=     - lightPos.W * planeNormal.Z;
	Self.V[3].W := dot - lightPos.W * planeNormal3;
end;

procedure TGLZMatrix4f.CreateReflectionMatrix(const planePoint, planeNormal : TGLZVector);
var
   pv2 : Single;
begin
   // Precalcs
   pv2:=2*planepoint.DotProduct(planeNormal);
   // 1st column
   Self.V[0].V[0]:=1-2*Sqr(planeNormal.V[0]);
   Self.V[0].V[1]:=-2*planeNormal.V[0]*planeNormal.V[1];
   Self.V[0].V[2]:=-2*planeNormal.V[0]*planeNormal.V[2];
   Self.V[0].V[3]:=0;
   // 2nd column
   Self.V[1].V[0]:=-2*planeNormal.V[1]*planeNormal.V[0];
   Self.V[1].V[1]:=1-2*Sqr(planeNormal.V[1]);
   Self.V[1].V[2]:=-2*planeNormal.V[1]*planeNormal.V[2];
   Self.V[1].V[3]:=0;
   // 3rd column
   Self.V[2].V[0]:=-2*planeNormal.V[2]*planeNormal.V[0];
   Self.V[2].V[1]:=-2*planeNormal.V[2]*planeNormal.V[1];
   Self.V[2].V[2]:=1-2*Sqr(planeNormal.V[2]);
   Self.V[2].V[3]:=0;
   // 4th column
   Self.V[3].V[0]:=pv2*planeNormal.V[0];
   Self.V[3].V[1]:=pv2*planeNormal.V[1];
   Self.V[3].V[2]:=pv2*planeNormal.V[2];
   Self.V[3].V[3]:=1;
end;

{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

{%region%----[ Operators ]------------------------------------------------------}

class operator TGLZMatrix4f.+(constref A, B: TGLZMatrix4f): TGLZMatrix4f;
begin
  Result.V[0] := A.V[0] + B.V[0];
  Result.V[1] := A.V[1] + B.V[1];
  Result.V[2] := A.V[2] + B.V[2];
  Result.V[3] := A.V[3] + B.V[3];
end;

class operator TGLZMatrix4f.+(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f;
begin
  Result.V[0] := A.V[0] + B;
  Result.V[1] := A.V[1] + B;
  Result.V[2] := A.V[2] + B;
  Result.V[3] := A.V[3] + B;
end;

class operator TGLZMatrix4f.-(constref A, B: TGLZMatrix4f): TGLZMatrix4f;
begin
  Result.V[0] := A.V[0] - B.V[0];
  Result.V[1] := A.V[1] - B.V[1];
  Result.V[2] := A.V[2] - B.V[2];
  Result.V[3] := A.V[3] - B.V[3];
end;

class operator TGLZMatrix4f.-(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f;
begin
  Result.V[0] := A.V[0] - B;
  Result.V[1] := A.V[1] - B;
  Result.V[2] := A.V[2] - B;
  Result.V[3] := A.V[3] - B;
end;

class operator TGLZMatrix4f.-(constref A: TGLZMatrix4f): TGLZMatrix4f;
begin
  Result.V[0] := -A.V[0];
  Result.V[1] := -A.V[1];
  Result.V[2] := -A.V[2];
  Result.V[3] := -A.V[3];
end;

class operator TGLZMatrix4f.*(constref A: TGLZMatrix4f; constref B: TGLZVector4f): TGLZVector4f;
begin
  Result.X := (B.X * A.M[0,0]) + (B.Y * A.M[0,1]) + (B.Z * A.M[0,2]) + (B.W * A.M[0,3]);
  Result.Y := (B.X * A.M[1,0]) + (B.Y * A.M[1,1]) + (B.Z * A.M[1,2]) + (B.W * A.M[1,3]);
  Result.Z := (B.X * A.M[2,0]) + (B.Y * A.M[2,1]) + (B.Z * A.M[2,2]) + (B.W * A.M[2,3]);
  Result.W := (B.X * A.M[3,0]) + (B.Y * A.M[3,1]) + (B.Z * A.M[3,2]) + (B.W * A.M[3,3]);
end;

class operator TGLZMatrix4f.*(constref A, B: TGLZMatrix4f): TGLZMatrix4f;
begin
  Result.M[0,0] := (A.M[0,0] * B.M[0,0]) + (A.M[0,1] * B.M[1,0]) + (A.M[0,2] * B.M[2,0]) + (A.M[0,3] * B.M[3,0]);
  Result.M[0,1] := (A.M[0,0] * B.M[0,1]) + (A.M[0,1] * B.M[1,1]) + (A.M[0,2] * B.M[2,1]) + (A.M[0,3] * B.M[3,1]);
  Result.M[0,2] := (A.M[0,0] * B.M[0,2]) + (A.M[0,1] * B.M[1,2]) + (A.M[0,2] * B.M[2,2]) + (A.M[0,3] * B.M[3,2]);
  Result.M[0,3] := (A.M[0,0] * B.M[0,3]) + (A.M[0,1] * B.M[1,3]) + (A.M[0,2] * B.M[2,3]) + (A.M[0,3] * B.M[3,3]);

  Result.M[1,0] := (A.M[1,0] * B.M[0,0]) + (A.M[1,1] * B.M[1,0]) + (A.M[1,2] * B.M[2,0]) + (A.M[1,3] * B.M[3,0]);
  Result.M[1,1] := (A.M[1,0] * B.M[0,1]) + (A.M[1,1] * B.M[1,1]) + (A.M[1,2] * B.M[2,1]) + (A.M[1,3] * B.M[3,1]);
  Result.M[1,2] := (A.M[1,0] * B.M[0,2]) + (A.M[1,1] * B.M[1,2]) + (A.M[1,2] * B.M[2,2]) + (A.M[1,3] * B.M[3,2]);
  Result.M[1,3] := (A.M[1,0] * B.M[0,3]) + (A.M[1,1] * B.M[1,3]) + (A.M[1,2] * B.M[2,3]) + (A.M[1,3] * B.M[3,3]);

  Result.M[2,0] := (A.M[2,0] * B.M[0,0]) + (A.M[2,1] * B.M[1,0]) + (A.M[2,2] * B.M[2,0]) + (A.M[2,3] * B.M[3,0]);
  Result.M[2,1] := (A.M[2,0] * B.M[0,1]) + (A.M[2,1] * B.M[1,1]) + (A.M[2,2] * B.M[2,1]) + (A.M[2,3] * B.M[3,1]);
  Result.M[2,2] := (A.M[2,0] * B.M[0,2]) + (A.M[2,1] * B.M[1,2]) + (A.M[2,2] * B.M[2,2]) + (A.M[2,3] * B.M[3,2]);
  Result.M[2,3] := (A.M[2,0] * B.M[0,3]) + (A.M[2,1] * B.M[1,3]) + (A.M[2,2] * B.M[2,3]) + (A.M[2,3] * B.M[3,3]);

  Result.M[3,0] := (A.M[3,0] * B.M[0,0]) + (A.M[3,1] * B.M[1,0]) + (A.M[3,2] * B.M[2,0]) + (A.M[3,3] * B.M[3,0]);
  Result.M[3,1] := (A.M[3,0] * B.M[0,1]) + (A.M[3,1] * B.M[1,1]) + (A.M[3,2] * B.M[2,1]) + (A.M[3,3] * B.M[3,1]);
  Result.M[3,2] := (A.M[3,0] * B.M[0,2]) + (A.M[3,1] * B.M[1,2]) + (A.M[3,2] * B.M[2,2]) + (A.M[3,3] * B.M[3,2]);
  Result.M[3,3] := (A.M[3,0] * B.M[0,3]) + (A.M[3,1] * B.M[1,3]) + (A.M[3,2] * B.M[2,3]) + (A.M[3,3] * B.M[3,3]);
end;

class operator TGLZMatrix4f.*(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f;
begin
  Result.V[0] := A.V[0] * B;
  Result.V[1] := A.V[1] * B;
  Result.V[2] := A.V[2] * B;
  Result.V[3] := A.V[3] * B;
end;

class operator TGLZMatrix4f./(constref A: TGLZMatrix4f; constref B: Single): TGLZMatrix4f;
var
  InvB: Single;
begin
  InvB := 1 / B;
  Result.V[0] := A.V[0] * InvB;
  Result.V[1] := A.V[1] * InvB;
  Result.V[2] := A.V[2] * InvB;
  Result.V[3] := A.V[3] * InvB;
end;


{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}
function TGLZMatrix4f.GetDeterminant: Single;
begin
  Result:= Self.V[0].X*MatrixDetInternal(Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z, Self.V[1].W, Self.V[2].W, Self.V[3].W)
          -Self.V[0].Y*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z, Self.V[1].W, Self.V[2].W, Self.V[3].W)
          +Self.V[0].Z*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].W, Self.V[2].W, Self.V[3].W)
          -Self.V[0].W*MatrixDetInternal(Self.V[1].X, Self.V[2].X, Self.V[3].X, Self.V[1].Y, Self.V[2].Y, Self.V[3].Y, Self.V[1].Z, Self.V[2].Z, Self.V[3].Z);
end;

function TGLZMatrix4f.Invert:TGLZMatrix4f;
var
   det : Single;
begin
   det:=GetDeterminant;
   if Abs(Det)<cEPSILON then  result:=IdentityHmgMatrix
   else
   begin
      Self.Adjoint;
      result := Self * (1/det);
   end;
end;

function TGLZMatrix4f.Translate(constref v : TGLZVector4f):TGLZMatrix4f;
begin
   Result := Self;
   Result.W.X:=Self.W.X+v.X;
   Result.W.Y:=Self.W.Y+v.Y;
   Result.W.Z:=Self.W.Z+v.Z;
end;

function TGLZMatrix4f.Multiply(constref M2 : TGLZMatrix4f): TGLZMatrix4f;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Result.V[I] := Self.V[I] * M2.V[I];
end;

function TGLZMatrix4f.Normalize: TGLZMatrix4f;
begin
   Result.X.W:=0;
   Result.X.Normalize;
   Result.Y.W:=0;
   Result.Y.Normalize;
   Result.Z:=Result.X.CrossProduct(Result.Y);
   Result.X:=Result.Y.CrossProduct(Result.Z);
   Result.W:=WHmgVector;
end;

function TGLZMatrix4f.Transpose: TGLZMatrix4f;
begin
  Result.M[0,0] := M[0,0];
  Result.M[0,1] := M[1,0];
  Result.M[0,2] := M[2,0];
  Result.M[0,3] := M[3,0];

  Result.M[1,0] := M[0,1];
  Result.M[1,1] := M[1,1];
  Result.M[1,2] := M[2,1];
  Result.M[1,3] := M[3,1];

  Result.M[2,0] := M[0,2];
  Result.M[2,1] := M[1,2];
  Result.M[2,2] := M[2,2];
  Result.M[2,3] := M[3,2];

  Result.M[3,0] := M[0,3];
  Result.M[3,1] := M[1,3];
  Result.M[3,2] := M[2,3];
  Result.M[3,3] := M[3,3];
end;




{%endregion%}

{%endregion%}

{$ENDIF}
