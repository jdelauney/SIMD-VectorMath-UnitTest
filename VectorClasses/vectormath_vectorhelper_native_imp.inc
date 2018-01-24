{%region%----[ Pure Pascal will never Convert ]---------------------------------}
// Temp comment this region is where we keep pascal routines for which it does
// not make sense to use SSE/AVX

function TGLZVectorHelper.Rotate(constref axis : TGLZVector; angle : Single):TGLZVector;
var
   rotMatrix : TGLZMatrix;
begin
   rotMatrix.CreateRotationMatrix(axis, Angle);
   Result := rotMatrix * Self;
end;

function TGLZVectorHelper.RotateWithMatrixAroundX(alpha : Single) : TGLZVector;
var
   rotMatrix : TGLZMatrix;
begin
   rotMatrix.CreateRotationMatrixX(Alpha);
   Result:=rotMatrix*Self;
end;

function TGLZVectorHelper.RotateWithMatrixAroundY(alpha : Single) : TGLZVector;
var
   rotMatrix : TGLZMatrix;
begin
   rotMatrix.CreateRotationMatrixY(Alpha);
   Result:=rotMatrix*Self;
end;

function TGLZVectorHelper.RotateWithMatrixAroundZ(alpha : Single) : TGLZVector;
var
   rotMatrix : TGLZMatrix;
begin
   rotMatrix.CreateRotationMatrixZ(Alpha);
   Result:=rotMatrix*Self;
end;

function TGLZVectorHelper.RotateAroundX( alpha : Single) : TGLZVector;
var
   c, s : Single;
begin
   SinCos(alpha, s, c);
   Result.X := Self.X;
   Result.Y := c * Self.Y - s * Self.Z;
   Result.Z := c * Self.Z + s * Self.Y;
   Result.W := Self.W
end;

function TGLZVectorHelper.RotateAroundY(alpha : Single) : TGLZVector;
var
   c, s : Single;
begin
   SinCos(alpha, s, c);
   Result.X := c * Self.X + s * Self.Z;
   Result.Y := Self.Y;
   Result.Z := c * Self.Z - s * Self.X;
   Result.W := Self.W
end;

function TGLZVectorHelper.RotateAroundZ(alpha : Single) : TGLZVector;
var
   c, s : Single;
begin
   SinCos(alpha, s, c);
   Result.X := c * Self.Y - s * Self.X;
   Result.Y := c * Self.X + s * Self.Y;
   Result.Z := Self.Z;
   Result.W := Self.W
end;

function TGLZVectorHelper.MoveAround(constref AMovingObjectUp, ATargetPosition: TGLZVector; pitchDelta, turnDelta: Single): TGLZVector;
var
  originalT2C, normalT2C, normalCameraRight: TGLZVector;
  pitchNow, dist: Single;
begin
    // normalT2C points away from the direction the camera is looking
    originalT2C := Self - ATargetPosition;
    normalT2C := originalT2C;
    dist := normalT2C.Length;
    normalT2C := normalT2C.Normalize;
    // normalRight points to the camera's right
    // the camera is pitching around this axis.
    normalCameraRight := AMovingObjectUp.CrossProduct(normalT2C);
    if normalCameraRight.Length < 0.001 then
      normalCameraRight:= XHmgVector // arbitrary vector
    else
      normalCameraRight := normalCameraRight.Normalize;
    // calculate the current pitch.
    // 0 is looking down and PI is looking up
    pitchNow := ArcCos(AMovingObjectUp.DotProduct(normalT2C));
    pitchNow := GLZUtils.Clamp(pitchNow - DegToRadian(pitchDelta), 0 + 0.025, cPI - 0.025);
    // create a new vector pointing up and then rotate it down
    // into the new position
    normalT2C := AMovingObjectUp;
    normalT2C := normalT2C.Rotate(normalCameraRight, pitchNow);
    normalT2C := normalT2C.Rotate(AMovingObjectUp, DegToRadian(turnDelta));
    normalT2C := normalT2C * dist;
    Result := Self + (normalT2C - originalT2C);
end;


function TGLZVectorHelper.ShiftObjectFromCenter(Constref ACenter : TGLZVector;
  const ADistance : Single; const AFromCenterSpot : Boolean) : TGLZVector;
var
  lDirection: TGLZVector;
begin
  lDirection := Self - ACenter;
  lDirection := lDirection.Normalize;
  ldirection := lDirection * ADistance;
  if AFromCenterSpot then Result := ACenter + lDirection
  else Result := Self + lDirection;
end;

function TGLZVectorHelper.ExtendClipRect(vX, vY: Single) : TGLZClipRect;
begin
  Result := Self;
  with Result do
  begin
    if vX < Left then Left := vX;
    if vY < Top then Top := vY;

    if vX > Right then Right := vX;
    if vY > Bottom then Bottom := vY;
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

function TGLZVectorHelper.PointProject(constref origin, direction : TGLZVector) : Single;
begin
   Result:= direction.X*(Self.X-origin.X)
           +direction.Y*(Self.Y-origin.Y)
           +direction.Z*(Self.Z-origin.Z);
end;

{gets the normal at cen based on the connected quad mesh vectors}
function TGLZVectorHelper.AverageNormal4(constref up, left, down,right: TGLZVector): TGLZVector;
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

function TGLZVectorHelper.Step(ConstRef B : TGLZVector4f):TGLZVector4f;
begin
  result := Self;
  if self.X <= B.X then result.X := 0;
  if self.Y <= B.Y then result.Y := 0;
  if self.Z <= B.Z then result.Z := 0;
  if self.W <= B.W then result.W := 0;
end;

function TGLZVectorHelper.FaceForward(constref A, B: TGLZVector4f): TGLZVector4f;
begin
  if (B.DotProduct(A) < 0) then
     Result := -Self
   else
     Result := Self;
end;

function TGLZVectorHelper.Saturate : TGLZVector4f;
begin
  Result := Self.Min(XYZWHmgVector);
  Result := Result.Max(NullHmgVector);
end;

function TGLZVectorHelper.SmoothStep(ConstRef A,B : TGLZVector4f): TGLZVector4f;
var
  t: TGLZVector;
begin
  t := (Self-a)/(b-a);
  t := t.Saturate;
  result :=t*t * ((t*2.0)*3.0);
end;

{%endregion%}

{%endregion%}

{$ENDIF}
