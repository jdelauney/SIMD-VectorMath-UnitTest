{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

procedure TGLZVector3b.Create(const aX, aY, aZ: Byte);
begin
  Self.X := aX;
  Self.Y := aY;
  Self.Z := aZ;
end;

function TGLZVector3b.ToString: String;
begin
  Result := '(X: '+IntToStr(Self.X)+
           ' ,Y: '+IntToStr(Self.Y)+
           ' ,Z: '+IntToStr(Self.Z)+')';
end;


class operator TGLZVector3b.+(constref A, B: TGLZVector3b): TGLZVector3b;
begin
  Result.X := ClampByte((A.X + B.X));
  Result.Y := ClampByte((A.Y + B.Y));
  Result.Z := ClampByte((A.Z + B.Z));
end;

class operator TGLZVector3b.-(constref A, B: TGLZVector3b): TGLZVector3b;
begin
  Result.X := ClampByte((A.X - B.X));
  Result.Y := ClampByte((A.Y - B.Y));
  Result.Z := ClampByte((A.Z - B.Z));
end;

class operator TGLZVector3b.*(constref A, B: TGLZVector3b): TGLZVector3b;
begin
  Result.X := ClampByte((A.X * B.X));
  Result.Y := ClampByte((A.Y * B.Y));
  Result.Z := ClampByte((A.Z * B.Z));
end;

class operator TGLZVector3b.div(constref A, B: TGLZVector3b): TGLZVector3b;
begin
  Result.X := ClampByte((A.X div B.X));
  Result.Y := ClampByte((A.Y div B.Y));
  Result.Z := ClampByte((A.Z div B.Z));
end;

class operator TGLZVector3b.+(constref A: TGLZVector3b; constref B: Byte ): TGLZVector3b;
begin
  Result.X := ClampByte((A.X + B));
  Result.Y := ClampByte((A.Y + B));
  Result.Z := ClampByte((A.Z + B));
end;

class operator TGLZVector3b.-(constref A: TGLZVector3b; constref B: Byte ): TGLZVector3b;
begin
  Result.X := ClampByte((A.X - B));
  Result.Y := ClampByte((A.Y - B));
  Result.Z := ClampByte((A.Z - B));
end;

class operator TGLZVector3b.*(constref A: TGLZVector3b; constref B: Byte ): TGLZVector3b;
begin
  Result.X := ClampByte((A.X * B));
  Result.Y := ClampByte((A.Y * B));
  Result.Z := ClampByte((A.Z * B));
end;

class operator TGLZVector3b.*(constref A: TGLZVector3b; constref B: Single): TGLZVector3b;
begin
  Result.X := ClampByte(Round((A.X * B)));
  Result.Y := ClampByte(Round((A.Y * B)));
  Result.Z := ClampByte(Round((A.Z * B)));
end;

class operator TGLZVector3b.div(constref A: TGLZVector3b; constref B: Byte ): TGLZVector3b;
begin
  Result.X := ClampByte((A.X div B));
  Result.Y := ClampByte((A.Y div B));
  Result.Z := ClampByte((A.Z div B));
end;

class operator TGLZVector3b.=(constref A, B: TGLZVector3b): Boolean;
begin
  Result := (A.X = B.X) and (A.Y = B.Y) and (A.Z = B.Z);
end;

class operator TGLZVector3b.<>(constref A, B: TGLZVector3b): Boolean;
begin
  Result := (A.X <> B.X) or (A.Y <> B.Y) or (A.Z <> B.Z);
end;

class operator TGLZVector3b.and(constref A, B: TGLZVector3b): TGLZVector3b;
begin
  Result.X := ClampByte((A.X and B.X));
  Result.Y := ClampByte((A.Y and B.Y));
  Result.Z := ClampByte((A.Z and B.Z));
end;

class operator TGLZVector3b.Or(constref A, B: TGLZVector3b): TGLZVector3b;
begin
  Result.X := ClampByte((A.X or B.X));
  Result.Y := ClampByte((A.Y or B.Y));
  Result.Z := ClampByte((A.Z or B.Z));
end;

class operator TGLZVector3b.Xor(constref A, B: TGLZVector3b): TGLZVector3b;
begin
  Result.X := ClampByte((A.X xor B.X));
  Result.Y := ClampByte((A.Y xor B.Y));
  Result.Z := ClampByte((A.Z xor B.Z));
end;

class operator TGLZVector3b.and(constref A: TGLZVector3b; constref B: Byte): TGLZVector3b;
begin
  Result.X := ClampByte((A.X and B));
  Result.Y := ClampByte((A.Y and B));
  Result.Z := ClampByte((A.Z and B));
end;

class operator TGLZVector3b.or(constref A: TGLZVector3b; constref B: Byte): TGLZVector3b;
begin
  Result.X := ClampByte((A.X or B));
  Result.Y := ClampByte((A.Y or B));
  Result.Z := ClampByte((A.Z or B));
end;

class operator TGLZVector3b.Xor(constref A: TGLZVector3b; constref B: Byte): TGLZVector3b;
begin
  Result.X := ClampByte((A.X xor B));
  Result.Y := ClampByte((A.Y xor B));
  Result.Z := ClampByte((A.Z xor B));
end;

function TGLZVector3b.AsVector3f: TGLZVector3f;
begin
  Result.X := Self.X * cColorFloatRatio;
  Result.X := Self.Y * cColorFloatRatio;
  Result.X := Self.Z * cColorFloatRatio;
end;

function TGLZVector3b.Swizzle(const ASwizzle: TGLZVector3SwizzleRef ): TGLZVector3b;
begin
   //FSwizzleMode := ASwizzle;
   case ASwizzle of
     swXXX, swRRR :
     begin
       Result.X := Self.X;
       Result.Y := Self.X;
       Result.Z := Self.X;
     end;
     swYYY, swGGG :
     begin
       Result.X := Self.Y;
       Result.Y := Self.Y;
       Result.Z := Self.Y;
     end;
     swZZZ, swBBB :
     begin
       Result.X := Self.Z;
       Result.Y := Self.Z;
       Result.Z := Self.Z;
     end;
//     swWWW, swAAA :
     swZYX, swBGR :
     begin
       Result.X := Self.Z;
       Result.Y := Self.Y;
       Result.Z := Self.X;
     end;
     swYXZ, swGRB :
     begin
       Result.X := Self.Y;
       Result.Y := Self.X;
       Result.Z := Self.Z;
     end;
     swYZX, swGBR :
     begin
       Result.X := Self.Y;
       Result.Y := Self.Z;
       Result.Z := Self.X;
     end;

     else result := self;
   end;
end;

{%endregion}

{%region%----[ Pure Pascal may Convert at some point ]--------------------------}

{%endregion}

{$IFNDEF USE_ASM}

{%region----[ PASCAL VERSION OF ASSEMBLER ROUTINES BELOW ]----------------------}

{%region%----[ Operators ]------------------------------------------------------}

{%endregion%}

{%region%----[ Functions ]------------------------------------------------------}

{%endregion%}

{%endregion%}

{$ENDIF}
