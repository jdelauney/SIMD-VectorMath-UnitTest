procedure TGLZMatrix4.Multiply(constref M2: TGLZMatrix4);
begin
  Self.X.X:=Self.X.X*M2.X.X+Self.X.Y*M2.Y.X+Self.X.Z*M2.Z.X+Self.X.W*M2.W.X;
  Self.X.Y:=Self.X.X*M2.X.Y+Self.X.Y*M2.Y.Y+Self.X.Z*M2.Z.Y+Self.X.W*M2.W.Y;
  Self.X.Z:=Self.X.X*M2.X.Z+Self.X.Y*M2.Y.Z+Self.X.Z*M2.Z.Z+Self.X.W*M2.W.Z;
  Self.X.W:=Self.X.X*M2.X.W+Self.X.Y*M2.Y.W+Self.X.Z*M2.Z.W+Self.X.W*M2.W.W;
  Self.Y.X:=Self.Y.X*M2.X.X+Self.Y.Y*M2.Y.X+Self.Y.Z*M2.Z.X+Self.Y.W*M2.W.X;
  Self.Y.Y:=Self.Y.X*M2.X.Y+Self.Y.Y*M2.Y.Y+Self.Y.Z*M2.Z.Y+Self.Y.W*M2.W.Y;
  Self.Y.Z:=Self.Y.X*M2.X.Z+Self.Y.Y*M2.Y.Z+Self.Y.Z*M2.Z.Z+Self.Y.W*M2.W.Z;
  Self.Y.W:=Self.Y.X*M2.X.W+Self.Y.Y*M2.Y.W+Self.Y.Z*M2.Z.W+Self.Y.W*M2.W.W;
  Self.Z.X:=Self.Z.X*M2.X.X+Self.Z.Y*M2.Y.X+Self.Z.Z*M2.Z.X+Self.Z.W*M2.W.X;
  Self.Z.Y:=Self.Z.X*M2.X.Y+Self.Z.Y*M2.Y.Y+Self.Z.Z*M2.Z.Y+Self.Z.W*M2.W.Y;
  Self.Z.Z:=Self.Z.X*M2.X.Z+Self.Z.Y*M2.Y.Z+Self.Z.Z*M2.Z.Z+Self.Z.W*M2.W.Z;
  Self.Z.W:=Self.Z.X*M2.X.W+Self.Z.Y*M2.Y.W+Self.Z.Z*M2.Z.W+Self.Z.W*M2.W.W;
  Self.W.X:=Self.W.X*M2.X.X+Self.W.Y*M2.Y.X+Self.W.Z*M2.Z.X+Self.W.W*M2.W.X;
  Self.W.Y:=Self.W.X*M2.X.Y+Self.W.Y*M2.Y.Y+Self.W.Z*M2.Z.Y+Self.W.W*M2.W.Y;
  Self.W.Z:=Self.W.X*M2.X.Z+Self.W.Y*M2.Y.Z+Self.W.Z*M2.Z.Z+Self.W.W*M2.W.Z;
  Self.W.W:=Self.W.X*M2.X.W+Self.W.Y*M2.Y.W+Self.W.Z*M2.Z.W+Self.W.W*M2.W.W;
end;

procedure TGLZMatrix4.Transpose;
var
   f : Single;
begin
   f:=Self.V[0].V[1]; Self.V[0].V[1]:=Self.V[1].V[0]; Self.V[1].V[0]:=f;
   f:=Self.V[0].V[2]; Self.V[0].V[2]:=Self.V[2].V[0]; Self.V[2].V[0]:=f;
   f:=Self.V[0].V[3]; Self.V[0].V[3]:=Self.V[3].V[0]; Self.V[3].V[0]:=f;
   f:=Self.V[1].V[2]; Self.V[1].V[2]:=Self.V[2].V[1]; Self.V[2].V[1]:=f;
   f:=Self.V[1].V[3]; Self.V[1].V[3]:=Self.V[3].V[1]; Self.V[3].V[1]:=f;
   f:=Self.V[2].V[3]; Self.V[2].V[3]:=Self.V[3].V[2]; Self.V[3].V[2]:=f;
end;


