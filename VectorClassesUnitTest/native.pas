unit native;

{$mode objfpc}{$H+}


{$COPERATORS ON}
{.$INLINE ON}

{$MODESWITCH ADVANCEDRECORDS}

interface

uses
  Classes, SysUtils, GLZVectorMath;

type
  TNativeGLZVector2f =  record
    procedure Create(aX,aY: single);

    function ToString : String;

    class operator +(constref A, B: TNativeGLZVector2f): TNativeGLZVector2f; overload;
    class operator -(constref A, B: TNativeGLZVector2f): TNativeGLZVector2f; overload;
    class operator *(constref A, B: TNativeGLZVector2f): TNativeGLZVector2f; overload;
    class operator /(constref A, B: TNativeGLZVector2f): TNativeGLZVector2f; overload;

    class operator +(constref A: TNativeGLZVector2f; constref B:Single): TNativeGLZVector2f; overload;
    class operator -(constref A: TNativeGLZVector2f; constref B:Single): TNativeGLZVector2f; overload;
    class operator *(constref A: TNativeGLZVector2f; constref B:Single): TNativeGLZVector2f; overload;
    class operator /(constref A: TNativeGLZVector2f; constref B:Single): TNativeGLZVector2f; overload;

    class operator -(constref A: TNativeGLZVector2f): TNativeGLZVector2f; overload;

    class operator =(constref A, B: TNativeGLZVector2f): Boolean;
    (*class operator >=(constref A, B: TNativeGLZVector2f): Boolean;
    class operator <=(constref A, B: TNativeGLZVector2f): Boolean;
    class operator >(constref A, B: TNativeGLZVector2f): Boolean;
    class operator <(constref A, B: TNativeGLZVector2f): Boolean;*)
    class operator <>(constref A, B: TNativeGLZVector2f): Boolean;

    function Min(constref B: TNativeGLZVector2f): TNativeGLZVector2f; overload;
    function Min(constref B: Single): TNativeGLZVector2f; overload;
    function Max(constref B: TNativeGLZVector2f): TNativeGLZVector2f; overload;
    function Max(constref B: Single): TNativeGLZVector2f; overload;

    function Clamp(constref AMin, AMax: TNativeGLZVector2f): TNativeGLZVector2f;overload;
    function Clamp(constref AMin, AMax: Single): TNativeGLZVector2f;overload;
    function MulAdd(A,B:TNativeGLZVector2f): TNativeGLZVector2f;
    function MulDiv(A,B:TNativeGLZVector2f): TNativeGLZVector2f;
    function Length:Single;
    function LengthSquare:Single;
    function Distance(A:TNativeGLZVector2f):Single;
    function DistanceSquare(A:TNativeGLZVector2f):Single;
    function Normalize : TNativeGLZVector2f;
    // function DotProduct(A:TVector2f):TVector2f;
    // function Reflect(I, NRef : TVector2f):TVector2f
    //function Round: TVector2I;
    //function Trunc: TVector2I;


    case Byte of
      0: (V: TGLZVector2fType);
      1: (X, Y : Single);
  End;

  TNativeGLZVector4f =  record  // With packed record the performance decrease a little
  public
    procedure Create(Const aX,aY,aZ: single; const aW : Single = 0); overload;
    procedure Create(Const anAffineVector: TGLZVector3f; const aW : Single = 0); overload;

    function ToString : String;

    class operator +(constref A, B: TNativeGLZVector4f): TNativeGLZVector4f; overload;
    class operator -(constref A, B: TNativeGLZVector4f): TNativeGLZVector4f; overload;
    class operator *(constref A, B: TNativeGLZVector4f): TNativeGLZVector4f; overload;
    class operator /(constref A, B: TNativeGLZVector4f): TNativeGLZVector4f; overload;

    class operator +(constref A: TNativeGLZVector4f; constref B:Single): TNativeGLZVector4f; overload;
    class operator -(constref A: TNativeGLZVector4f; constref B:Single): TNativeGLZVector4f; overload;
    class operator *(constref A: TNativeGLZVector4f; constref B:Single): TNativeGLZVector4f; overload;
    class operator /(constref A: TNativeGLZVector4f; constref B:Single): TNativeGLZVector4f; overload;

    class operator -(constref A: TNativeGLZVector4f): TNativeGLZVector4f; overload;

    class operator =(constref A, B: TNativeGLZVector4f): Boolean;
    class operator >=(constref A, B: TNativeGLZVector4f): Boolean;
    class operator <=(constref A, B: TNativeGLZVector4f): Boolean;
    class operator >(constref A, B: TNativeGLZVector4f): Boolean;
    class operator <(constref A, B: TNativeGLZVector4f): Boolean;
    class operator <>(constref A, B: TNativeGLZVector4f): Boolean;

    function Shuffle(const x,y,z,w : Byte):TNativeGLZVector4f;
    function MinXYZComponent : Single;
    function MaxXYZComponent : Single;

    function Abs:TNativeGLZVector4f;overload;
    function Negate:TNativeGLZVector4f;
    function  DivideBy2:TNativeGLZVector4f;
    function Distance(constref A: TNativeGLZVector4f):Single;
    function DistanceSquare(constref A: TNativeGLZVector4f):Single;
    function Length:Single;
    function LengthSquare:Single;
    function Spacing(constref A: TNativeGLZVector4f):Single;
    function DotProduct(constref A: TNativeGLZVector4f):Single;
    function CrossProduct(constref A: TNativeGLZVector4f): TNativeGLZVector4f;
    function Normalize: TNativeGLZVector4f;
    function Norm:Single;
    function Min(constref B: TNativeGLZVector4f): TNativeGLZVector4f; overload;
    function Min(constref B: Single): TNativeGLZVector4f; overload;
    function Max(constref B: TNativeGLZVector4f): TNativeGLZVector4f; overload;
    function Max(constref B: Single): TNativeGLZVector4f; overload;
    function Clamp(Constref AMin, AMax: TNativeGLZVector4f): TNativeGLZVector4f; overload;
    function Clamp(constref AMin, AMax: Single): TNativeGLZVector4f; overload;
    function MulAdd(Constref B, C: TNativeGLZVector4f): TNativeGLZVector4f;
    function MulDiv(Constref B, C: TNativeGLZVector4f): TNativeGLZVector4f;

    function Lerp(Constref B: TNativeGLZVector4f; Constref T:Single): TNativeGLZVector4f;
    function AngleCosine(constref A : TNativeGLZVector4f): Single;
    function AngleBetween(Constref A, ACenterPoint : TNativeGLZVector4f): Single;

    function Combine(constref V2: TNativeGLZVector4f; constref F1: Single): TNativeGLZVector4f;
    function Combine2(constref V2: TNativeGLZVector4f; const F1, F2: Single): TNativeGLZVector4f;
    function Combine3(constref V2, V3: TNativeGLZVector4f; const F1, F2, F3: Single): TNativeGLZVector4f;

    function Perpendicular(constref N : TNativeGLZVector4f) : TNativeGLZVector4f;

    function Reflect(constref N: TNativeGLZVector4f): TNativeGLZVector4f;

//    function MoveAround(constRef AMovingUp, ATargetPosition: TNativeGLZVector4f; pitchDelta, turnDelta: Single): TNativeGLZVector4f;

    procedure pAdd(constref A: TNativeGLZVector4f);overload;
    procedure pSub(constref A: TNativeGLZVector4f);overload;
    procedure pMul(constref A: TNativeGLZVector4f);overload;
    procedure pDiv(constref A: TNativeGLZVector4f);overload;
    procedure pAdd(constref A: Single);overload;
    procedure pSub(constref A: Single);overload;
    procedure pMul(constref A: Single);overload;
    procedure pDiv(constref A: Single);overload;
    procedure pInvert;
    procedure pNegate;
    procedure pAbs;
    procedure pDivideBy2;
    procedure pCrossProduct(constref A: TNativeGLZVector4f);
    procedure pNormalize;
    procedure pMin(constref B: TNativeGLZVector4f); overload;
    procedure pMin(constref B: Single);overload;
    procedure pMax(constref B: TNativeGLZVector4f); overload;
    procedure pMax(constref B: Single); overload;
    procedure pClamp(Constref AMin, AMax: TNativeGLZVector4f); overload;
    procedure pClamp(constref AMin, AMax: Single); overload;
    procedure pMulAdd(Constref B, C: TNativeGLZVector4f); // (Self*B)+c
    procedure pMulDiv(Constref B, C: TNativeGLZVector4f); // (Self*B)-c
    //procedure Lerp(Constref B: TNativeGLZVector4f; Constref T:Single): TNativeGLZVector4f;


    case Byte of
      0: (V: TGLZVector4fType);
      1: (X, Y, Z, W: Single);
      2: (AsVector3f : TGLZVector3f);
  end;

  TNativeGLZVector = TNativeGLZVector4f;
  TNativeGLZHmgPlane = TNativeGLZVector;

Type
  TNativeGLZMatrix4 = packed record
  private
    function GetComponent(const ARow, AColumn: Integer): Single; inline;
    procedure SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
    function GetRow(const AIndex: Integer): TNativeGLZVector4f; inline;
    procedure SetRow(const AIndex: Integer; const Value: TNativeGLZVector4f); inline;

    function GetDeterminant: Single;

    function MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
    procedure Transpose_Scale_M33(constref src : TNativeGLZMatrix4; Constref ascale : Single);
  public
    class operator +(constref A, B: TNativeGLZMatrix4): TNativeGLZMatrix4;overload;
    class operator +(constref A: TNativeGLZMatrix4; constref B: Single): TNativeGLZMatrix4; overload;
    class operator -(constref A, B: TNativeGLZMatrix4): TNativeGLZMatrix4;overload;
    class operator -(constref A: TNativeGLZMatrix4; constref B: Single): TNativeGLZMatrix4; overload;
    class operator *(constref A, B: TNativeGLZMatrix4): TNativeGLZMatrix4;overload;
    class operator *(constref A: TNativeGLZMatrix4; constref B: Single): TNativeGLZMatrix4; overload;
    class operator *(constref A: TNativeGLZMatrix4; constref B: TNativeGLZVector4f): TNativeGLZVector4f; overload;
    class operator /(constref A: TNativeGLZMatrix4; constref B: Single): TNativeGLZMatrix4; overload;

    class operator -(constref A: TNativeGLZMatrix4): TNativeGLZMatrix4; overload;

    //class operator =(constref A, B: TGLZMatrix4): Boolean;overload;
    //class operator <>(constref A, B: TGLZMatrix4): Boolean;overload;

    procedure CreateIdentityMatrix;
    // Creates scale matrix
    procedure CreateScaleMatrix(const v : TGLZAffineVector); overload;
    // Creates scale matrix
    procedure CreateScaleMatrix(const v : TNativeGLZVector4f); overload;
    // Creates translation matrix
    procedure CreateTranslationMatrix(const V : TGLZAffineVector); overload;
    // Creates translation matrix
    procedure CreateTranslationMatrix(const V : TNativeGLZVector4f); overload;
    { Creates a scale+translation matrix.
       Scale is applied BEFORE applying offset }
    procedure CreateScaleAndTranslationMatrix(const ascale, offset : TNativeGLZVector4f); overload;
    // Creates matrix for rotation about x-axis (angle in rad)
    procedure CreateRotationMatrixX(const sine, cosine: Single); overload;
    procedure CreateRotationMatrixX(const angle: Single); overload;
    // Creates matrix for rotation about y-axis (angle in rad)
    procedure CreateRotationMatrixY(const sine, cosine: Single); overload;
    procedure CreateRotationMatrixY(const angle: Single); overload;
    // Creates matrix for rotation about z-axis (angle in rad)
    procedure CreateRotationMatrixZ(const sine, cosine: Single); overload;
    procedure CreateRotationMatrixZ(const angle: Single); overload;
    // Creates a rotation matrix along the given Axis by the given Angle in radians.
    procedure CreateRotationMatrix(const anAxis : TGLZAffineVector; angle : Single); overload;
    procedure CreateRotationMatrix(const anAxis : TNativeGLZVector4f; angle : Single); overload;

    procedure CreateLookAtMatrix(const eye, center, normUp: TNativeGLZVector4f);
    procedure CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);
    procedure CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);
    procedure CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);
    procedure CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i);

    { Creates a parallel projection matrix.
       Transformed points will projected on the plane along the specified direction. }
    procedure CreateParallelProjectionMatrix(const plane : TGLZHmgPlane; const dir : TNativeGLZVector4f);

    { Creates a shadow projection matrix.
       Shadows will be projected onto the plane defined by planePoint and planeNormal,
       from lightPos. }
    procedure CreateShadowMatrix(const planePoint, planeNormal, lightPos : TNativeGLZVector4f);

    { Builds a reflection matrix for the given plane.
       Reflection matrix allow implementing planar reflectors in OpenGL (mirrors). }
    procedure CreateReflectionMatrix(const planePoint, planeNormal : TNativeGLZVector4f);

    function ToString : String;

    //function Transform(constref A: TNativeGLZVector4f):TNativeGLZVector4f;
    function Transpose : TNativeGLZMatrix4;
    //procedure pTranspose;
    function Invert : TNativeGLZMatrix4;
    //procedure pInvert;
    function Normalize : TNativeGLZMatrix4;
    //procedure pNormalize;

    procedure Adjoint;
    procedure AnglePreservingMatrixInvert(constref mat : TNativeGLZMatrix4);

    function Decompose(var Tran: TGLZMatrixTransformations): Boolean;

    Function Translate( constref v : TNativeGLZVector4f):TNativeGLZMatrix4;
    //procedure pTranslate( constref v : TNativeGLZVector4f);

    function Multiply(constref M2: TNativeGLZMatrix4):TNativeGLZMatrix4;
    //procedure pMultiply(constref M2: TNativeGLZMatrix4)


    property Rows[const AIndex: Integer]: TNativeGLZVector4f read GetRow write SetRow;
    property Components[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;
    property Determinant: Single read GetDeterminant;

    case Byte of
    { The elements of the matrix in row-major order }
      0: (M: array [0..3, 0..3] of Single);
      1: (V: array [0..3] of TNativeGLZVector4f);
      2: (VX : Array[0..1] of array[0..7] of Single); //AVX Access
      3: (X,Y,Z,W : TNativeGLZVector4f);
      4: (m11, m12, m13, m14: Single;
          m21, m22, m23, m24: Single;
          m31, m32, m33, m34: Single;
          m41, m42, m43, m44: Single);
  End;

  TNativeGLZMatrix = TNativeGLZMatrix4;

Type
  TNativeGLZQuaternion = record
  private
  public
    class operator +(constref A, B: TNativeGLZQuaternion): TNativeGLZQuaternion; overload;
    class operator -(constref A, B: TNativeGLZQuaternion): TNativeGLZQuaternion; overload;
    class operator -(constref A: TNativeGLZQuaternion): TNativeGLZQuaternion; overload;
    { Returns quaternion product qL * qR.
       Note: order is important!
       To combine rotations, use the product Muliply(qSecond, qFirst),
       which gives the effect of rotating by qFirst then qSecond.
    }
    class operator *(constref A, B: TNativeGLZQuaternion): TNativeGLZQuaternion;  overload;

    class operator +(constref A : TNativeGLZQuaternion; constref B:Single): TNativeGLZQuaternion; overload;
    class operator -(constref A : TNativeGLZQuaternion; constref B:Single): TNativeGLZQuaternion; overload;
    class operator *(constref A : TNativeGLZQuaternion; constref B:Single): TNativeGLZQuaternion; overload;
    class operator /(constref A : TNativeGLZQuaternion; constref B:Single): TNativeGLZQuaternion; overload;

    class operator =(constref A, B: TNativeGLZQuaternion): Boolean;
    class operator <>(constref A, B: TNativeGLZQuaternion): Boolean;

    function ToString : String;

    procedure Create(x,y,z: Single; Real : Single);overload;
    // Creates a quaternion from the given values
    procedure Create(const Imag: array of Single; Real : Single); overload;

    // Constructs a unit quaternion from two points on unit sphere
    procedure Create(const V1, V2: TGLZAffineVector); overload;
    //procedure Create(const V1, V2: TGLZVector); overload;

    // Constructs a unit quaternion from a rotation matrix
    //procedure Create(const mat : TGLZMatrix); overload;

    // Constructs quaternion from angle (in deg) and axis
    procedure Create(const angle  : Single; const axis : TGLZAffineVector); overload;
    //procedure Create(const angle  : Single; const axis : TGLZVector); overload;

    // Constructs quaternion from Euler angles
    procedure Create(const r, p, y : Single); overload;

    // Constructs quaternion from Euler angles in arbitrary order (angles in degrees)
    procedure Create(const x, y, z: Single; eulerOrder : TGLZEulerOrder); overload;

    // Converts a unit quaternion into two points on a unit sphere
    procedure ConvertToPoints(var ArcFrom, ArcTo: TGLZAffineVector); //overload;
    //procedure ConvertToPoints(var ArcFrom, ArcTo: TGLZVector); //overload;

    { Constructs a rotation matrix from (possibly non-unit) quaternion.
       Assumes matrix is used to multiply column vector on the left:
       vnew = mat vold.
       Works correctly for right-handed coordinate system and right-handed rotations. }
    //function ConvertToMatrix : TGLZMatrix;

    { Constructs an affine rotation matrix from (possibly non-unit) quaternion. }
    //function ConvertToAffineMatrix : TGLZAffineMatrix;

    // Returns the conjugate of a quaternion
    function Conjugate : TNativeGLZQuaternion;
    //procedure pConjugate;

    // Returns the magnitude of the quaternion
    function Magnitude : Single;

    // Normalizes the given quaternion
    function Normalize : TNativeGLZQuaternion;
    //procedure pNormalize;

    { Returns quaternion product qL * qR.
       Note: order is important!
       To combine rotations, use the product Muliply(qSecond, qFirst),
       which gives the effect of rotating by qFirst then qSecond.
      }
    //function MultiplyAsFirst(const qSecond : TNativeGLZQuaternion): TNativeGLZQuaternion;
    function MultiplyAsSecond(const qFirst : TNativeGLZQuaternion): TNativeGLZQuaternion;

    { Spherical linear interpolation of unit quaternions with spins.
       QStart, QEnd - start and end unit quaternions
       t            - interpolation parameter (0 to 1)
       Spin         - number of extra spin rotations to involve  }
    function Slerp(const QEnd: TNativeGLZQuaternion; Spin: Integer; t: Single): TNativeGLZQuaternion; overload;
    function Slerp(const QEnd: TNativeGLZQuaternion; const t : Single) : TNativeGLZQuaternion; overload;

    case Byte of
      0: (V: TGLZVector4fType);
      1: (X, Y, Z, W: Single);
      2: (AsVector4f : TNativeGLZVector4f);
      3: (ImagePart : TGLZVector3f; RealPart : Single);
  End;

(* Type
  TNativeGLZHmgPlaneHelper = record helper for TNativeGLZVector //TNativeGLZHmgPlane
  public
    procedure CreatePlane(constref p1, p2, p3 : TNativeGLZVector);overload;
    // Computes the parameters of a plane defined by a point and a normal.
    procedure CreatePlane(constref point, normal : TNativeGLZVector); overload;

    //function Normalize : TGLZHmgPlane; overload;
    function NormalizePlane : TNativeGLZHmgPlane;

    procedure CalcPlaneNormal(constref p1, p2, p3 : TNativeGLZVector);

    //function PointIsInHalfSpace(constref point: TGLZVector) : Boolean;
    //function PlaneEvaluatePoint(constref point : TGLZVector) : Single;
    function DistancePlaneToPoint(constref point : TNativeGLZVector) : Single;
    function DistancePlaneToSphere(constref Center : TNativeGLZVector; constref Radius:Single) : Single;
    { Compute the intersection point "res" of a line with a plane.
      Return value:
       0 : no intersection, line parallel to plane
       1 : res is valid
       -1 : line is inside plane
      Adapted from:
      E.Hartmann, Computeruntersttzte Darstellende Geometrie, B.G. Teubner Stuttgart 1988 }
    //function IntersectLinePlane(const point, direction : TGLZVector; intersectPoint : PGLZVector = nil) : Integer;
  end; *)

Type
  TNativeGLZVectorHelper = record helper for TNativeGLZVector
  public

  procedure CreatePlane(constref p1, p2, p3 : TNativeGLZVector);overload;
  // Computes the parameters of a plane defined by a point and a normal.
  procedure CreatePlane(constref point, normal : TNativeGLZVector); overload;

  //function Normalize : TGLZHmgPlane; overload;
  function NormalizePlane : TNativeGLZHmgPlane;

  procedure CalcPlaneNormal(constref p1, p2, p3 : TNativeGLZVector);

  //function PointIsInHalfSpace(constref point: TGLZVector) : Boolean;
  //function PlaneEvaluatePoint(constref point : TGLZVector) : Single;
  function DistancePlaneToPoint(constref point : TNativeGLZVector) : Single;
  function DistancePlaneToSphere(constref Center : TNativeGLZVector; constref Radius:Single) : Single;
  { Compute the intersection point "res" of a line with a plane.
    Return value:
     0 : no intersection, line parallel to plane
     1 : res is valid
     -1 : line is inside plane
    Adapted from:
    E.Hartmann, Computeruntersttzte Darstellende Geometrie, B.G. Teubner Stuttgart 1988 }
  //function IntersectLinePlane(const point, direction : TGLZVector; intersectPoint : PGLZVector = nil) : Integer;

    function Rotate(constref axis : TNativeGLZVector; angle : Single):TNativeGLZVector;
    // Returns given vector rotated around the X axis (alpha is in rad)
    function RotateAroundX(alpha : Single) : TNativeGLZVector;
    // Returns given vector rotated around the Y axis (alpha is in rad)
    function RotateAroundY(alpha : Single) : TNativeGLZVector;
    // Returns given vector rotated around the Z axis (alpha is in rad)
    function RotateAroundZ(alpha : Single) : TNativeGLZVector;
    // Self is the point
    function PointProject(constref origin, direction : TNativeGLZVector) : Single;
    // Returns true if both vector are colinear
    function IsColinear(constref v2: TNativeGLZVector) : Boolean;
    // Returns true if line intersect ABCD quad. Quad have to be flat and convex
    //function IsLineIntersectQuad(const direction, ptA, ptB, ptC, ptD : TGLZVector) : Boolean;
    // Computes closest point on a segment (a segment is a limited line).
    //function PointSegmentClosestPoint(segmentStart, segmentStop : TGLZVector) : TGLZVector;
    { Computes algebraic distance between segment and line (a segment is a limited line).}
    //function PointSegmentDistance(const point, segmentStart, segmentStop : TAffineVector) : single;
    { Computes closest point on a line.}
    //function PointLineClosestPoint(const linePoint, lineDirection : TGLZVector) : TGLZVector;
    { Computes algebraic distance between point and line.}
    //function PointLineDistance(const linePoint, lineDirection : TGLZVector) : Single;
    { Extracted from Camera.MoveAroundTarget(pitch, turn). }
    function MoveAround(constref AMovingObjectUp, ATargetPosition: TNativeGLZVector; pitchDelta, turnDelta: Single): TNativeGLZVector;
    { AOriginalPosition - Object initial position.
       ACenter - some point, from which is should be distanced.

       ADistance + AFromCenterSpot - distance, which object should keep from ACenter
       or
       ADistance + not AFromCenterSpot - distance, which object should shift from his current position away from center.
    }
    function ShiftObjectFromCenter(Constref ACenter: TNativeGLZVector; const ADistance: Single; const AFromCenterSpot: Boolean): TNativeGLZVector;
    function AverageNormal4(constref up, left, down, right: TNativeGLZVector): TNativeGLZVector;
  end;

Type
  TNativeGLZMatrixHelper = record helper for TNativeGLZMatrix
  public
    // Self is ViewProjMatrix
    //function Project(Const objectVector: TGLZVector; const viewport: TVector4i; out WindowVector: TGLZVector): Boolean;
    //function UnProject(Const WindowVector: TGLZVector; const viewport: TVector4i; out objectVector: TGLZVector): Boolean;
    // coordinate system manipulation functions
    // Rotates the given coordinate system (represented by the matrix) around its Y-axis
    function Turn(angle : Single) : TNativeGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around MasterUp
    function Turn(constref MasterUp : TNativeGLZVector; Angle : Single) : TNativeGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around its X-axis
    function Pitch(Angle: Single): TNativeGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around MasterRight
    function Pitch(constref MasterRight: TNativeGLZVector; Angle: Single): TNativeGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around its Z-axis
    function Roll(Angle: Single): TNativeGLZMatrix; overload;
    // Rotates the given coordinate system (represented by the matrix) around MasterDirection
    function Roll(constref MasterDirection: TNativeGLZVector; Angle: Single): TNativeGLZMatrix; overload;
  end;

{%region%----[ Const ]---------------------------------------------------------}

Const
  NativeNullHmgPoint : TNativeGLZVector4f = (X:0; Y:0; Z:0; W:1);
  NativeWHmgVector  :  TNativeGLZVector4f = (X:0; Y:0; Z:0; W:1);
  NativeXHmgVector  :  TNativeGLZVector4f = (X:1; Y:0; Z:0; W:0);

  NativeIdentityHmgMatrix : TNativeGLZMatrix4 = (V:((X:1; Y:0; Z:0; W:0),
                                       (X:0; Y:1; Z:0; W:0),
                                       (X:0; Y:0; Z:1; W:0),
                                       (X:0; Y:0; Z:0; W:1)));

  NativeEmptyHmgMatrix : TNativeGLZMatrix4 = (V:((X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0)));

 NativeIdentityQuaternion: TNativeGLZQuaternion = (ImagePart:(X:0; Y:0; Z:0); RealPart: 1);

{%endregion%}

  function Compare(constref A: TNativeGLZVector4f; constref B: TGLZVector4f;Espilon: Single = 1e-10): boolean;overload;
  function Compare(constref A: TNativeGLZVector2f; constref B: TGLZVector2f;Espilon: Single = 1e-10): boolean; overload;
  function CompareMatrix(constref A: TNativeGLZMatrix4; constref B: TGLZMatrix4f; Espilon: Single = 1e-10): boolean;
  function CompareQuaternion(constref A: TNativeGLZQuaternion; constref B: TGLZQuaternion; Espilon: Single = 1e-10): boolean;

  function IsEqual(A,B: Single; Epsilon: single = 1e-10): boolean; inline;

implementation

uses
  Math, GLZMath, GLZUtils;

function IsEqual(A,B: Single; Epsilon: single): boolean;
begin
  Result := Abs(A-B) < Epsilon;
end;


function Compare(constref A: TNativeGLZVector4f; constref B: TGLZVector4f; Espilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Espilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Espilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Espilon) then Result := False;
  if not IsEqual (A.W, B.W, Espilon) then Result := False;
end;

function Compare(constref A: TNativeGLZVector2f; constref B: TGLZVector2f; Espilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Espilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Espilon) then Result := False;
end;

function CompareMatrix(constref A: TNativeGLZMatrix4; constref B: TGLZMatrix4f;  Espilon: Single): boolean;
var i : Byte;
begin
  Result := true;
  for I:=0 to 3 do
  begin
   if not IsEqual (A.V[I].X, B.V[I].X, Espilon) then Result := False;
   if not IsEqual (A.V[I].Y, B.V[I].Y, Espilon) then Result := False;
   if not IsEqual (A.V[I].Z, B.V[I].Z, Espilon) then Result := False;
   if not IsEqual (A.V[I].W, B.V[I].W, Espilon) then Result := False;
   if result = false then break;
  end;
end;

function CompareQuaternion(constref A: TNativeGLZQuaternion; constref B: TGLZQuaternion; Espilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Espilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Espilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Espilon) then Result := False;
  if not IsEqual (A.W, B.W, Espilon) then Result := False;
end;

{$i native.inc}

end.
