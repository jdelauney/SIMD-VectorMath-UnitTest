unit native;

{$mode objfpc}{$H+}


{$COPERATORS ON}
{.$INLINE ON}

{$MODESWITCH ADVANCEDRECORDS}

interface

uses
  Classes, SysUtils, GLZVectorMath;

type
{%region%----[ TNativeGLZVector2i ]---------------------------------------------}
  TNativeGLZVector2i = record
  case Byte of
    0: (V: TGLZVector2iType);
    1: (X, Y : Integer);
  end;
{%endregion%}

{%region%----[ TNativeGLZVector2f ]---------------------------------------------}
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
    function DotProduct(A:TNativeGLZVector2f):Single;
    function AngleBetween(Constref A, ACenterPoint : TNativeGLZVector2f): Single;
    function AngleCosine(constref A: TNativeGLZVector2f): Single;
    // function Reflect(I, NRef : TVector2f):TVector2f
    function Round: TNativeGLZVector2i;
    function Trunc: TNativeGLZVector2i;


    case Byte of
      0: (V: TGLZVector2fType);
      1: (X, Y : Single);
  End;

{%endregion%}


{%region%----[ TNativeGLZVector3b ]---------------------------------------------}

    TNativeGLZVector3b = Record
    private
      //FSwizzleMode : TGLZVector3SwizzleRef;
    public
      procedure Create(Const aX,aY,aZ: Byte); overload;

      function ToString : String;

      class operator +(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b; overload;
      class operator -(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b; overload;
      class operator *(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b; overload;
      class operator Div(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b; overload;

      class operator +(constref A: TNativeGLZVector3b; constref B:Byte): TNativeGLZVector3b; overload;
      class operator -(constref A: TNativeGLZVector3b; constref B:Byte): TNativeGLZVector3b; overload;
      class operator *(constref A: TNativeGLZVector3b; constref B:Byte): TNativeGLZVector3b; overload;
      class operator *(constref A: TNativeGLZVector3b; constref B:Single): TNativeGLZVector3b; overload;
      class operator Div(constref A: TNativeGLZVector3b; constref B:Byte): TNativeGLZVector3b; overload;

      class operator =(constref A, B: TNativeGLZVector3b): Boolean;
      class operator <>(constref A, B: TNativeGLZVector3b): Boolean;

      class operator And(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b; overload;
      class operator Or(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b; overload;
      class operator Xor(constref A, B: TNativeGLZVector3b): TNativeGLZVector3b; overload;
      class operator And(constref A: TNativeGLZVector3b; constref B:Byte): TNativeGLZVector3b; overload;
      class operator or(constref A: TNativeGLZVector3b; constref B:Byte): TNativeGLZVector3b; overload;
      class operator Xor(constref A: TNativeGLZVector3b; constref B:Byte): TNativeGLZVector3b; overload;

      function Swizzle(Const ASwizzle : TGLZVector3SwizzleRef): TNativeGLZVector3b;

      Case Integer of
        0 : (V:TGLZVector3bType);
        1 : (x,y,z:Byte);
        2 : (Red,Green,Blue:Byte);
    end;
{%endregion%}

{%region%----[ TNativeGLZVector3i ]---------------------------------------------}
  TNativeGLZVector3i = record
  case Byte of
    0: (V: TGLZVector3iType);
    1: (X, Y, Z : Integer);
    2: (Red, Green, Blue : Integer);
  end;
{%endregion%}

{%region%----[ TNativeGLZVector3f ]---------------------------------------------}
  TNativeGLZVector3f =  record
    case Byte of
      0: (V: TGLZVector3fType);
      1: (X, Y, Z: Single);
      2: (Red, Green, Blue: Single);
  End;

  TNativeGLZAffineVector = TNativeGLZVector3f;
  PNativeGLZAffineVector = ^TNativeGLZAffineVector;

{%endregion%}

{%region%----[ TNativeGLZVector4b ]---------------------------------------------}
  TNativeGLZVector4b = Record
  private

  public
    procedure Create(Const aX,aY,aZ: Byte; const aW : Byte = 255); overload;
    procedure Create(Const aValue : TNativeGLZVector3b; const aW : Byte = 255); overload;

    function ToString : String;

    class operator +(constref A, B: TNativeGLZVector4b): TNativeGLZVector4b; overload;
    class operator -(constref A, B: TNativeGLZVector4b): TNativeGLZVector4b; overload;
    class operator *(constref A, B: TNativeGLZVector4b): TNativeGLZVector4b; overload;
    class operator Div(constref A, B: TNativeGLZVector4b): TNativeGLZVector4b; overload;

    class operator +(constref A: TNativeGLZVector4b; constref B:Byte): TNativeGLZVector4b; overload;
    class operator -(constref A: TNativeGLZVector4b; constref B:Byte): TNativeGLZVector4b; overload;
    class operator *(constref A: TNativeGLZVector4b; constref B:Byte): TNativeGLZVector4b; overload;
    class operator *(constref A: TNativeGLZVector4b; constref B:Single): TNativeGLZVector4b; overload;
    class operator Div(constref A: TNativeGLZVector4b; constref B:Byte): TNativeGLZVector4b; overload;

    class operator =(constref A, B: TNativeGLZVector4b): Boolean;
    class operator <>(constref A, B: TNativeGLZVector4b): Boolean;

    class operator And(constref A, B: TNativeGLZVector4b): TNativeGLZVector4b; overload;
    class operator Or(constref A, B: TNativeGLZVector4b): TNativeGLZVector4b; overload;
    class operator Xor(constref A, B: TNativeGLZVector4b): TNativeGLZVector4b; overload;
    class operator And(constref A: TNativeGLZVector4b; constref B:Byte): TNativeGLZVector4b; overload;
    class operator or(constref A: TNativeGLZVector4b; constref B:Byte): TNativeGLZVector4b; overload;
    class operator Xor(constref A: TNativeGLZVector4b; constref B:Byte): TNativeGLZVector4b; overload;

    function DivideBy2 : TNativeGLZVector4b;

    function Min(Constref B : TNativeGLZVector4b):TNativeGLZVector4b; overload;
    function Min(Constref B : Byte):TNativeGLZVector4b; overload;
    function Max(Constref B : TNativeGLZVector4b):TNativeGLZVector4b; overload;
    function Max(Constref B : Byte):TNativeGLZVector4b; overload;
    function Clamp(Constref AMin, AMax : TNativeGLZVector4b):TNativeGLZVector4b; overload;
    function Clamp(Constref AMin, AMax : Byte):TNativeGLZVector4b; overload;

    function MulAdd(Constref B, C : TNativeGLZVector4b):TNativeGLZVector4b;
    function MulDiv(Constref B, C : Byte):TNativeGLZVector4b;

    function Shuffle(const x,y,z,w : Byte):TNativeGLZVector4b;
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TNativeGLZVector4b;

    function Combine(constref V2: TNativeGLZVector4b; constref F1: Single): TNativeGLZVector4b;
    function Combine2(constref V2: TNativeGLZVector4b; const F1, F2: Single): TNativeGLZVector4b;
    function Combine3(constref V2, V3: TNativeGLZVector4b; const F1, F2, F3: Single): TNativeGLZVector4b;

    function MinXYZComponent : Byte;
    function MaxXYZComponent : Byte;

    Case Integer of
     0 : (V:TGLZVector4bType);
     1 : (x,y,z,w:Byte);
     2 : (Red,Green,Blue, Alpha:Byte);
     3 : (AsVector3b : TNativeGLZVector3b);
     4 : (AsInteger : Integer);
  end;
{%endregion%}

{%region%----[ TNativeGLZVector4i ]---------------------------------------------}
  TNativeGLZVector4i = Record
  public
    procedure Create(Const aX,aY,aZ: Longint; const aW : Longint = 0); overload;
    procedure Create(Const aValue : TNativeGLZVector3i; const aW : Longint = MaxInt); overload;
    procedure Create(Const aValue : TNativeGLZVector3b; const aW : Longint = MaxInt); overload;

    function ToString : String;

    class operator +(constref A, B: TNativeGLZVector4i): TNativeGLZVector4i; overload;
    class operator -(constref A, B: TNativeGLZVector4i): TNativeGLZVector4i; overload;
    class operator *(constref A, B: TNativeGLZVector4i): TNativeGLZVector4i; overload;
    class operator Div(constref A, B: TNativeGLZVector4i): TNativeGLZVector4i; overload;

    class operator +(constref A: TNativeGLZVector4i; constref B:Longint): TNativeGLZVector4i; overload;
    class operator -(constref A: TNativeGLZVector4i; constref B:Longint): TNativeGLZVector4i; overload;
    class operator *(constref A: TNativeGLZVector4i; constref B:Longint): TNativeGLZVector4i; overload;
    class operator *(constref A: TNativeGLZVector4i; constref B:Single): TNativeGLZVector4i; overload;
    class operator Div(constref A: TNativeGLZVector4i; constref B:Longint): TNativeGLZVector4i; overload;

    class operator -(constref A: TNativeGLZVector4i): TNativeGLZVector4i; overload;
    class operator =(constref A, B: TNativeGLZVector4i): Boolean;
    class operator <>(constref A, B: TNativeGLZVector4i): Boolean;

    (* class operator And(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    class operator Or(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    class operator Xor(constref A, B: TGLZVector4i): TGLZVector4i; overload;
    class operator And(constref A: TGLZVector4i; constref B:LongInt): TGLZVector4i; overload;
    class operator or(constref A: TGLZVector4i; constref B:LongInt): TGLZVector4i; overload;
    class operator Xor(constref A: TGLZVector4i; constref B:LongInt): TGLZVector4i; overload; *)

    function DivideBy2 : TNativeGLZVector4i;
    function Abs: TNativeGLZVector4i;

    function Min(Constref B : TNativeGLZVector4i):TNativeGLZVector4i; overload;
    function Min(Constref B : LongInt):TNativeGLZVector4i; overload;
    function Max(Constref B : TNativeGLZVector4i):TNativeGLZVector4i; overload;
    function Max(Constref B : LongInt):TNativeGLZVector4i; overload;
    function Clamp(Constref AMin, AMax : TNativeGLZVector4i):TNativeGLZVector4i; overload;
    function Clamp(Constref AMin, AMax : LongInt):TNativeGLZVector4i; overload;

    function MulAdd(Constref B, C : TNativeGLZVector4i):TNativeGLZVector4i;
    function MulDiv(Constref B, C : TNativeGLZVector4i):TNativeGLZVector4i;


    function Shuffle(const x,y,z,w : Byte):TNativeGLZVector4i;
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TNativeGLZVector4i;

    function Combine(constref V2: TNativeGLZVector4i; constref F1: Single): TNativeGLZVector4i;
    function Combine2(constref V2: TNativeGLZVector4i; const F1, F2: Single): TNativeGLZVector4i;
    function Combine3(constref V2, V3: TNativeGLZVector4i; const F1, F2, F3: Single): TNativeGLZVector4i;

    function MinXYZComponent : LongInt;
    function MaxXYZComponent : LongInt;

    case Byte of
      0 : (V: TGLZVector4iType);
      1 : (X,Y,Z,W: longint);
      2 : (Red, Green, Blue, Alpha : Longint);
      3 : (TopLeft, BottomRight : TNativeGLZVector2i);
  end;
{%endregion%}

{%region%----[ TNativeGLZVector4f ]---------------------------------------------}
  TNativeGLZVector4f =  record  // With packed record the performance decrease a little
  private
    //FSwizzleMode :  TGLZVector4SwizzleRef;
  public
    procedure Create(Const aX,aY,aZ: single; const aW : Single = 0); overload;
    procedure Create(Const anAffineVector: TNativeGLZVector3f; const aW : Single = 0); overload;

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
    function Swizzle(const ASwizzle: TGLZVector4SwizzleRef ): TNativeGLZVector4f;
    function MinXYZComponent : Single;
    function MaxXYZComponent : Single;

    function Abs:TNativeGLZVector4f;overload;
    function Negate:TNativeGLZVector4f;
    function  DivideBy2:TNativeGLZVector4f;
    function Distance(constref A: TNativeGLZVector4f):Single;
    function Length:Single;
    function DistanceSquare(constref A: TNativeGLZVector4f):Single;
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

    function Round: TNativeGLZVector4i;
    function Trunc: TNativeGLZVector4i;

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
      2: (Red, Green, Blue, Alpha: Single);
      3: (AsVector3f : TNativeGLZVector3f);   //change name for AsAffine ?????
      4: (ST,UV : TNativeGLZVector2f);
      5: (Left, Top, Right, Bottom: Single);
      6: (TopLeft,BottomRight : TNativeGLZVector2f);
  end;

  TNativeGLZVector = TNativeGLZVector4f;
  PNativeGLZVector = ^TNativeGLZVector;
//  TNativeGLZHmgPlane = TNativeGLZVector;
  TNativeGLZVectorArray = array[0..MAXINT shr 5] of TNativeGLZVector4f;

  TNativeGLZColorVector = TNativeGLZVector;
  PNativeGLZColorVector = ^TNativeGLZColorVector;

  TNativeGLZClipRect = TNativeGLZVector;

{%endregion%}

{%region%----[ TNativeGLZHmgPlane ]---------------------------------------------}

  TNativeGLZHmgPlane = record
     // Computes the parameters of a plane defined by a point and a normal.
     procedure Create(constref point, normal : TNativeGLZVector); overload;
     procedure Create(constref p1, p2, p3 : TNativeGLZVector); overload;
     procedure CalcNormal(constref p1, p2, p3 : TNativeGLZVector);
     procedure Normalize; overload;
     function Normalized : TNativeGLZHmgPlane; overload;
     function AbsDistance(constref point : TNativeGLZVector) : Single;
     function Distance(constref point : TNativeGLZVector) : Single; overload;
     function Distance(constref Center : TNativeGLZVector; constref Radius:Single) : Single; overload;
     function IsInHalfSpace(constref point: TNativeGLZVector) : Boolean;

     case Byte of
       0: (V: TGLZVector4fType);         // should have type compat with other vector4f
       1: (A, B, C, D: Single);          // Plane Parameter access
       2: (AsNormal3: TNativeGLZAffineVector); // super quick descriptive access to Normal as Affine Vector.
       3: (AsVector: TNativeGLZVector);
       4: (X, Y, Z, W: Single);          // legacy access so existing code works
  end;

{%endregion%}

{%region%----[ TNativeGLZMatrix4 ]----------------------------------------------}

  TNativeGLZMatrix4f = record
  private
    function GetComponent(const ARow, AColumn: Integer): Single; inline;
    procedure SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
    function GetRow(const AIndex: Integer): TNativeGLZVector4f; inline;
    procedure SetRow(const AIndex: Integer; const Value: TNativeGLZVector4f); inline;

    function GetDeterminant: Single;

    function MatrixDetInternal(const a1, a2, a3, b1, b2, b3, c1, c2, c3: Single): Single;
    procedure Transpose_Scale_M33(constref src : TNativeGLZMatrix4f; Constref ascale : Single);
  public
    class operator +(constref A, B: TNativeGLZMatrix4f): TNativeGLZMatrix4f;overload;
    class operator +(constref A: TNativeGLZMatrix4f; constref B: Single): TNativeGLZMatrix4f; overload;
    class operator -(constref A, B: TNativeGLZMatrix4f): TNativeGLZMatrix4f;overload;
    class operator -(constref A: TNativeGLZMatrix4f; constref B: Single): TNativeGLZMatrix4f; overload;
    class operator *(constref A, B: TNativeGLZMatrix4f): TNativeGLZMatrix4f;overload;
    class operator *(constref A: TNativeGLZMatrix4f; constref B: Single): TNativeGLZMatrix4f; overload;
    class operator *(constref A: TNativeGLZMatrix4f; constref B: TNativeGLZVector4f): TNativeGLZVector4f; overload;
    class operator /(constref A: TNativeGLZMatrix4f; constref B: Single): TNativeGLZMatrix4f; overload;

    class operator -(constref A: TNativeGLZMatrix4f): TNativeGLZMatrix4f; overload;

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
    procedure CreateRotationMatrix(const anAxis : TNativeGLZAffineVector; angle : Single); overload;
    procedure CreateRotationMatrix(const anAxis : TNativeGLZVector4f; angle : Single); overload;

    procedure CreateLookAtMatrix(const eye, center, normUp: TNativeGLZVector4f);
    procedure CreateMatrixFromFrustum(Left, Right, Bottom, Top, ZNear, ZFar: Single);
    procedure CreatePerspectiveMatrix(FOV, Aspect, ZNear, ZFar: Single);
    procedure CreateOrthoMatrix(Left, Right, Bottom, Top, ZNear, ZFar: Single);
    procedure CreatePickMatrix(x, y, deltax, deltay: Single; const viewport: TGLZVector4i);

    { Creates a parallel projection matrix.
       Transformed points will projected on the plane along the specified direction. }
    procedure CreateParallelProjectionMatrix(const plane : TNativeGLZHmgPlane; const dir : TNativeGLZVector4f);

    { Creates a shadow projection matrix.
       Shadows will be projected onto the plane defined by planePoint and planeNormal,
       from lightPos. }
    procedure CreateShadowMatrix(const planePoint, planeNormal, lightPos : TNativeGLZVector4f);

    { Builds a reflection matrix for the given plane.
       Reflection matrix allow implementing planar reflectors in OpenGL (mirrors). }
    procedure CreateReflectionMatrix(const planePoint, planeNormal : TNativeGLZVector4f);

    function ToString : String;

    //function Transform(constref A: TNativeGLZVector4f):TNativeGLZVector4f;
    function Transpose : TNativeGLZMatrix4f;
    //procedure pTranspose;
    function Invert : TNativeGLZMatrix4f;
    //procedure pInvert;
    function Normalize : TNativeGLZMatrix4f;
    //procedure pNormalize;

    procedure Adjoint;
    procedure AnglePreservingMatrixInvert(constref mat : TNativeGLZMatrix4f);

    function Decompose(var Tran: TGLZMatrixTransformations): Boolean;

    Function Translate( constref v : TNativeGLZVector4f):TNativeGLZMatrix4f;
    function Multiply(constref M2: TNativeGLZMatrix4f):TNativeGLZMatrix4f;

    //function Lerp(constref m2: TGLZMatrix4f; const Delta: Single): TGLZMatrix4f;

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

  TNativeGLZMatrix = TNativeGLZMatrix4f;
  PNativeGLZMatrix = ^TNativeGLZMatrix;
  TNativeGLZMatrixArray = array [0..MaxInt shr 7] of TNativeGLZMatrix;
  PNativeGLZMatrixArray = ^TNativeGLZMatrixArray;

{%endregion%}

{%region%----[ TNativeGLZQuaternion ]-------------------------------------------}

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
    //class operator /(constref A, B: TNativeGLZQuaternion): TGLZQuaternion;overload;

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
    procedure Create(const V1, V2: TNativeGLZAffineVector); overload;
    //procedure Create(const V1, V2: TGLZVector); overload;

    // Constructs a unit quaternion from a rotation matrix
    //procedure Create(const mat : TGLZMatrix); overload;

    // Constructs quaternion from angle (in deg) and axis
    procedure Create(const angle  : Single; const axis : TNativeGLZAffineVector); overload;
    //procedure Create(const angle  : Single; const axis : TGLZVector); overload;

    // Constructs quaternion from Euler angles
    procedure Create(const r, p, y : Single); overload;

    // Constructs quaternion from Euler angles in arbitrary order (angles in degrees)
    procedure Create(const x, y, z: Single; eulerOrder : TGLZEulerOrder); overload;

    // Converts a unit quaternion into two points on a unit sphere
    procedure ConvertToPoints(var ArcFrom, ArcTo: TNativeGLZAffineVector); //overload;
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
      3: (ImagePart : TNativeGLZVector3f; RealPart : Single);
  End;
  PNativeGLZQuaternionArray = ^TNativeGLZQuaternionArray;
  TNativeGLZQuaternionArray = array[0..MAXINT shr 5] of TNativeGLZQuaternion;

{%endregion%}

{%region%----[ BoundingBox ]----------------------------------------------------}

  TNativeGLZBoundingBox = record
  private
  public
    procedure Create(Const AValue : TNativeGLZVector);

    class operator +(ConstRef A, B : TNativeGLZBoundingBox):TNativeGLZBoundingBox;overload;
    class operator +(ConstRef A: TNativeGLZBoundingBox; ConstRef B : TNativeGLZVector):TNativeGLZBoundingBox;overload;
    class operator =(ConstRef A, B : TNativeGLZBoundingBox):Boolean;overload;

    function Transform(ConstRef M:TNativeGLZMAtrix):TNativeGLZBoundingBox;
    function MinX : Single;
    function MaxX : Single;
    function MinY : Single;
    function MaxY : Single;
    function MinZ : Single;
    function MaxZ : Single;

    Case Integer of
     0 : (Points : Array[0..7] of TNativeGLZVector);
     1 : (pt1, pt2, pt3, pt4 :TNativeGLZVector;
          pt5, pt6, pt7, pt8 :TNativeGLZVector);
  end;

{%endregion%}

{%region%----[ BoundingSphere ]-------------------------------------------------}

  TNativeGLZBoundingSphere = record
  public

    procedure Create(Const x,y,z: Single;Const r: single = 1.0); overload;
    procedure Create(Const AValue : TNativeGLZAffineVector;Const r: single = 1.0); overload;
    procedure Create(Const AValue : TNativeGLZVector;Const r: single = 1.0); overload;

    function ToString: String;

    function Contains(const TestBSphere: TNativeGLZBoundingSphere) : TGLZSpaceContains;
    { : Determines if one BSphere intersects another BSphere }
    function Intersect(const TestBSphere: TNativeGLZBoundingSphere): Boolean;

    Case Integer of
          { : Center of Bounding Sphere }
      0 : (Center: TNativeGLZVector;
          { : Radius of Bounding Sphere }
          Radius: Single);
  end;

{%endregion%}

{%region%----[ Axis Aligned BoundingBox ]---------------------------------------}

{ : Structure for storing the corners of an AABB, used with ExtractAABBCorners }
  TNativeGLZAABBCorners = array [0 .. 7] of TNativeGLZVector;

  TNativeGLZAxisAlignedBoundingBox =  record
  public
    procedure Create(const AValue: TNativeGLZVector);
    { : Extract the AABB information from a BB. }
    procedure Create(const ABB: TNativeGLZBoundingBox);

    { : Make the AABB that is formed by sweeping a sphere (or AABB) from Start to Dest }
    procedure CreateFromSweep(const Start, Dest: TNativeGLZVector;const Radius: Single);

    { : Convert a BSphere to the AABB }
    procedure Create(const BSphere: TNativeGLZBoundingSphere); overload;
    procedure Create(const Center: TNativeGLZVector; Radius: Single); overload;


    class operator +(ConstRef A, B : TNativeGLZAxisAlignedBoundingBox):TNativeGLZAxisAlignedBoundingBox;overload;
    class operator +(ConstRef A: TNativeGLZAxisAlignedBoundingBox; ConstRef B : TNativeGLZVector):TNativeGLZAxisAlignedBoundingBox;overload;
    class operator *(ConstRef A: TNativeGLZAxisAlignedBoundingBox; ConstRef B : TNativeGLZVector):TNativeGLZAxisAlignedBoundingBox;overload;
    class operator =(ConstRef A, B : TNativeGLZAxisAlignedBoundingBox):Boolean;overload;

    function Transform(Constref M:TNativeGLZMatrix):TNativeGLZAxisAlignedBoundingBox;
    function Include(Constref P:TNativeGLZVector):TNativeGLZAxisAlignedBoundingBox;
    { : Returns the intersection of the AABB with second AABBs.
      If the AABBs don't intersect, will return a degenerated AABB (plane, line or point). }
    function Intersection(const B: TNativeGLZAxisAlignedBoundingBox): TNativeGLZAxisAlignedBoundingBox;

    { : Converts the AABB to its canonical BB. }
    function ToBoundingBox: TNativeGLZBoundingBox; overload;
    { : Transforms the AABB to a BB. }
    function ToBoundingBox(const M: TNativeGLZMatrix) : TNativeGLZBoundingBox; overload;
    { : Convert the AABB to a BSphere }
    function ToBoundingSphere: TNativeGLZBoundingSphere;

    function ToClipRect(ModelViewProjection: TNativeGLZMatrix; ViewportSizeX, ViewportSizeY: Integer): TNativeGLZClipRect;
    { : Determines if two AxisAlignedBoundingBoxes intersect.
      The matrices are the ones that convert one point to the other's AABB system }
    function Intersect(const B: TNativeGLZAxisAlignedBoundingBox;const M1, M2: TNativeGLZMatrix):Boolean;
    { : Checks whether two Bounding boxes aligned with the world axes collide in the XY plane. }
    function IntersectAbsoluteXY(const B: TNativeGLZAxisAlignedBoundingBox): Boolean;
    { : Checks whether two Bounding boxes aligned with the world axes collide in the XZ plane. }
    function IntersectAbsoluteXZ(const B: TNativeGLZAxisAlignedBoundingBox): Boolean;
    { : Checks whether two Bounding boxes aligned with the world axes collide. }
    function IntersectAbsolute(const B: TNativeGLZAxisAlignedBoundingBox): Boolean;
    { : Checks whether one Bounding box aligned with the world axes fits within
      another Bounding box. }
    function FitsInAbsolute(const B: TNativeGLZAxisAlignedBoundingBox): Boolean;

    { : Checks if a point "p" is inside the AABB }
    function PointIn(const P: TNativeGLZVector): Boolean;

    { : Extract the corners from the AABB }
    function ExtractCorners: TNativeGLZAABBCorners;

    { : Determines to which extent the AABB contains another AABB }
    function Contains(const TestAABB: TNativeGLZAxisAlignedBoundingBox): TGLZSpaceContains; overload;
    { : Determines to which extent the AABB contains a BSphere }
    function Contains(const TestBSphere: TNativeGLZBoundingSphere): TGLZSpaceContains; overload;

    { : Clips a position to the AABB }
    function Clip(const V: TNativeGLZAffineVector): TNativeGLZAffineVector;

    { : Finds the intersection between a ray and an axis aligned bounding box. }
    function RayCastIntersect(const RayOrigin, RayDirection: TNativeGLZVector; out TNear, TFar: Single): Boolean; overload;
    function RayCastIntersect(const RayOrigin, RayDirection: TNativeGLZVector; IntersectPoint: PNativeGLZVector = nil): Boolean; overload;

    Case Integer of
      0 : (Min, Max : TNativeGLZVector);
  end;

{%endregion%}

{%region%----[ TNativeGLZVectorHelper ]-----------------------------------------}

  TNativeGLZVectorHelper = record helper for TNativeGLZVector
  public

//  procedure CreatePlane(constref p1, p2, p3 : TNativeGLZVector);overload;
  // Computes the parameters of a plane defined by a point and a normal.
 // procedure CreatePlane(constref point, normal : TNativeGLZVector); overload;


//  procedure CalcPlaneNormal(constref p1, p2, p3 : TNativeGLZVector);

  //function PointIsInHalfSpace(constref point: TGLZVector) : Boolean;
  //function PlaneEvaluatePoint(constref point : TGLZVector) : Single;
//  function DistancePlaneToPoint(constref point : TNativeGLZVector) : Single;
//  function DistancePlaneToSphere(constref Center : TNativeGLZVector; constref Radius:Single) : Single;
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
    //function IsPerpendicular(constref v2: TGLZVector) : Boolean;
    //function IsParallel(constref v2: TGLZVector) : Boolean;
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

    function ExtendClipRect(vX, vY: Single) : TNativeGLZClipRect;
  end;

{%endregion%}

{%region%----[ TNativeGLZHmgPlaneHelper ]-----------------------------------------------}
  // for functions where we use types not declared before TGLZHmgPlane
  TNativeGLZHmgPlaneHelper = record helper for TNativeGLZHmgPlane
  public
    function Contains(const TestBSphere: TNativeGLZBoundingSphere): TGLZSpaceContains;

  end;
{%endregion%}

{%region%----[ TNativeGLZMatrixHelper ]-----------------------------------------}

  TNativeGLZMatrixHelper = record helper for TNativeGLZMatrix4f
  public
    // Self is ViewProjMatrix
    //function Project(Const objectVector: TGLZVector; const viewport: TVector4i; out WindowVector: TGLZVector): Boolean;
    //function UnProject(Const WindowVector: TGLZVector; const viewport: TVector4i; out objectVector: TGLZVector): Boolean;
    // coordinate system manipulation functions
    // Rotates the given coordinate system (represented by the matrix) around its Y-axis
    function Turn(angle : Single) : TNativeGLZMatrix4f; overload;
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

{%endregion%}

{%region%----[ Vector Const ]---------------------------------------------------}

Const

  NativeNullVector2f : TNativeGLZVector2f = (x:0;y:0);


  // standard affine vectors
  NativeXVector :    TNativeGLZAffineVector = (X:1; Y:0; Z:0);
  NativeYVector :    TNativeGLZAffineVector = (X:0; Y:1; Z:0);
  NativeZVector :    TNativeGLZAffineVector = (X:0; Y:0; Z:1);
  NativeXYVector :   TNativeGLZAffineVector = (X:1; Y:1; Z:0);
  NativeXZVector :   TNativeGLZAffineVector = (X:1; Y:0; Z:1);
  NativeYZVector :   TNativeGLZAffineVector = (X:0; Y:1; Z:1);
  NativeXYZVector :  TNativeGLZAffineVector = (X:1; Y:1; Z:1);
  NativeNullVector : TNativeGLZAffineVector = (X:0; Y:0; Z:0);
  // standard homogeneous vectors
  NativeXHmgVector : TNativeGLZVector = (X:1; Y:0; Z:0; W:0);
  NativeYHmgVector : TNativeGLZVector = (X:0; Y:1; Z:0; W:0);
  NativeZHmgVector : TNativeGLZVector = (X:0; Y:0; Z:1; W:0);
  NativeWHmgVector : TNativeGLZVector = (X:0; Y:0; Z:0; W:1);
  NativeNullHmgVector : TNativeGLZVector = (X:0; Y:0; Z:0; W:0);
  NativeXYHmgVector: TNativeGLZVector = (X: 1; Y: 1; Z: 0; W: 0);
  NativeYZHmgVector: TNativeGLZVector = (X: 0; Y: 1; Z: 1; W: 0);
  NativeXZHmgVector: TNativeGLZVector = (X: 1; Y: 0; Z: 1; W: 0);
  NativeXYZHmgVector: TNativeGLZVector = (X: 1; Y: 1; Z: 1; W: 0);
  NativeXYZWHmgVector: TGLZVector = (X: 1; Y: 1; Z: 1; W: 1);

  // standard homogeneous points
  NativeXHmgPoint :  TNativeGLZVector = (X:1; Y:0; Z:0; W:1);
  NativeYHmgPoint :  TNativeGLZVector = (X:0; Y:1; Z:0; W:1);
  NativeZHmgPoint :  TNativeGLZVector = (X:0; Y:0; Z:1; W:1);
  NativeWHmgPoint :  TNativeGLZVector = (X:0; Y:0; Z:0; W:1);
  NativeNullHmgPoint : TNativeGLZVector = (X:0; Y:0; Z:0; W:1);

  NativeNegativeUnitVector : TNativeGLZVector = (X:-1; Y:-1; Z:-1; W:-1);

{%region%----[ Matrix Const ]---------------------------------------------------}
  NativeIdentityHmgMatrix : TNativeGLZMatrix4f = (V:((X:1; Y:0; Z:0; W:0),
                                       (X:0; Y:1; Z:0; W:0),
                                       (X:0; Y:0; Z:1; W:0),
                                       (X:0; Y:0; Z:0; W:1)));

  NativeEmptyHmgMatrix : TNativeGLZMatrix4f = (V:((X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0),
                                    (X:0; Y:0; Z:0; W:0)));
{%endregion%}

{%region%----[ Quaternion Const ]-----------------------------------------------}

Const
 NativeIdentityQuaternion: TNativeGLZQuaternion = (ImagePart:(X:0; Y:0; Z:0); RealPart: 1);

{%endregion%}

{%region%----[ Others Const ]---------------------------------------------------}
  NativeNullBoundingBox: TNativeGLZBoundingBox =
  (Points:((X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1),
           (X: 0; Y: 0; Z: 0; W: 1)));


{%endregion%}
{%endregion%}

{%region%----[ Misc Vector Helpers functions ]----------------------------------}

 function NativeAffineVectorMake(const x, y, z : Single) : TNativeGLZAffineVector;overload;
 function NativeAffineVectorMake(const v : TNativeGLZVector) : TNativeGLZAffineVector;overload;


{%endregion%}

  function Compare(constref A: TNativeGLZVector3f; constref B: TGLZVector3f;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeGLZVector4f; constref B: TGLZVector4f;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeGLZHmgPlane; constref B: TGLZHmgPlane;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TGLZHmgPlane; constref B: TGLZHmgPlane;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TGLZVector4f; constref B: TGLZVector4f;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeGLZVector3b; constref B: TGLZVector3b): boolean; overload;
  function Compare(constref A: TNativeGLZVector4b; constref B: TGLZVector4b): boolean; overload;
  function Compare(constref A: TNativeGLZVector4i; constref B: TGLZVector4i): boolean; overload;
  function CompareWithRound(constref A: TNativeGLZVector4i; constref B: TGLZVector4i): boolean; overload;
  function Compare(constref A: TNativeGLZVector2i; constref B: TGLZVector2i): boolean; overload;
  function Compare(constref A: TNativeGLZVector2f; constref B: TGLZVector2f;Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeGLZBoundingBox; constref B: TGLZBoundingBox;Epsilon: Single = 1e-10): boolean; overload;
  function CompareMatrix(constref A: TNativeGLZMatrix4f; constref B: TGLZMatrix4f; Epsilon: Single = 1e-10): boolean;
  function CompareQuaternion(constref A: TNativeGLZQuaternion; constref B: TGLZQuaternion; Epsilon: Single = 1e-10): boolean;
  function Compare(constref A: TNativeGLZBoundingSphere; constref B: TGLZBoundingSphere; Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TGLZBoundingSphere; constref B: TGLZBoundingSphere; Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeGLZAxisAlignedBoundingBox; constref B: TGLZAxisAlignedBoundingBox; Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TNativeGLZAABBCorners; constref B: TGLZAABBCorners; Epsilon: Single = 1e-10): boolean; overload;
  function Compare(constref A: TGLZMatrix4f; constref B: TGLZMatrix4f; Epsilon: Single = 1e-10): boolean; overload;

  function IsEqual(A,B: Single; Epsilon: single = 1e-10): boolean; inline;

implementation

uses
  Math, GLZMath, GLZUtils;

function IsEqual(A,B: Single; Epsilon: single): boolean;
begin
  Result := Abs(A-B) < Epsilon;
end;


function Compare(constref A: TNativeGLZVector4f; constref B: TGLZVector4f; Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeGLZVector3f; constref B: TGLZVector3f; Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeGLZHmgPlane; constref B: TGLZHmgPlane;
  Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TGLZHmgPlane; constref B: TGLZHmgPlane;
  Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TGLZVector4f; constref B: TGLZVector4f;
  Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeGLZVector3b; constref B: TGLZVector3b): boolean;
begin
  Result := True;
  if A.Red <> B.Red then Result := False;
  if A.Green <> B.Green then Result := False;
  if A.Blue <> B.Blue then Result := False;
end;

function Compare(constref A: TNativeGLZVector4b; constref B: TGLZVector4b): boolean;
begin
  Result := True;
  if A.Red <> B.Red then Result := False;
  if A.Green <> B.Green then Result := False;
  if A.Blue <> B.Blue then Result := False;
  if A.Alpha<> B.Alpha then Result := False;
end;

function Compare(constref A: TNativeGLZVector4i; constref B: TGLZVector4i): boolean;
begin
  Result := True;
  if A.Red <> B.Red then Result := False;
  if A.Green <> B.Green then Result := False;
  if A.Blue <> B.Blue then Result := False;
  if A.Alpha<> B.Alpha then Result := False;
end;

function CompareWithRound(constref A: TNativeGLZVector4i; constref
  B: TGLZVector4i): boolean;
begin
  Result := True;
  if Abs(A.Red - B.Red) > 1 then Result := False;
  if Abs(A.Green - B.Green) > 1 then Result := False;
  if Abs(A.Blue - B.Blue) > 1 then Result := False;
  if Abs(A.Alpha - B.Alpha) > 1 then Result := False;
end;

function Compare(constref A: TNativeGLZVector2i; constref B: TGLZVector2i): boolean;
begin
  Result := True;
  if A.X <> B.Y then Result := False;
  if A.Y <> B.Y then Result := False;

end;


function Compare(constref A: TNativeGLZVector2f; constref B: TGLZVector2f; Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeGLZBoundingBox; constref
  B: TGLZBoundingBox; Epsilon: Single): boolean;
begin
  Result := True;
  if not compare(A.pt1,B.pt1) then Result := False;
  if not compare(A.pt2,B.pt2) then Result := False;
  if not compare(A.pt3,B.pt3) then Result := False;
  if not compare(A.pt4,B.pt4) then Result := False;
  if not compare(A.pt5,B.pt5) then Result := False;
  if not compare(A.pt6,B.pt6) then Result := False;
  if not compare(A.pt7,B.pt7) then Result := False;
  if not compare(A.pt8,B.pt8) then Result := False;
end;

function CompareMatrix(constref A: TNativeGLZMatrix4f; constref B: TGLZMatrix4f;  Epsilon: Single): boolean;
var i : Byte;
begin
  Result := true;
  for I:=0 to 3 do
  begin
   if not IsEqual (A.V[I].X, B.V[I].X, Epsilon) then Result := False;
   if not IsEqual (A.V[I].Y, B.V[I].Y, Epsilon) then Result := False;
   if not IsEqual (A.V[I].Z, B.V[I].Z, Epsilon) then Result := False;
   if not IsEqual (A.V[I].W, B.V[I].W, Epsilon) then Result := False;
   if result = false then break;
  end;
end;

function CompareQuaternion(constref A: TNativeGLZQuaternion; constref B: TGLZQuaternion; Epsilon: Single): boolean;
begin
  Result := true;
  if not IsEqual (A.X, B.X, Epsilon) then Result := False;
  if not IsEqual (A.Y, B.Y, Epsilon) then Result := False;
  if not IsEqual (A.Z, B.Z, Epsilon) then Result := False;
  if not IsEqual (A.W, B.W, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeGLZBoundingSphere; constref
  B: TGLZBoundingSphere; Epsilon: Single): boolean;
begin
  Result := True;
  if not Compare(A.Center, B.Center, Epsilon) then Result := False;
  if not IsEqual(A.Radius, B.Radius, Epsilon) then Result := False;
end;

function Compare(constref A: TGLZBoundingSphere; constref
  B: TGLZBoundingSphere; Epsilon: Single): boolean;
begin
  Result := True;
  if not Compare(A.Center, B.Center, Epsilon) then Result := False;
  if not IsEqual(A.Radius, B.Radius, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeGLZAxisAlignedBoundingBox; constref
  B: TGLZAxisAlignedBoundingBox; Epsilon: Single): boolean;
begin
  Result := True;
  if not Compare(A.Min, B.Min, Epsilon) then Result := False;
  if not Compare(A.Max, B.Max, Epsilon) then Result := False;
end;

function Compare(constref A: TNativeGLZAABBCorners; constref
  B: TGLZAABBCorners; Epsilon: Single): boolean;
var i: integer;
begin
  Result := True;
  for i := 0 to 7 do
    if not compare(A[i],B[i]) then Result := False;
end;

function Compare(constref A: TGLZMatrix4f; constref B: TGLZMatrix4f;
  Epsilon: Single): boolean;
begin
  Result := True;
  if not compare(A.V[0], B.V[0]) then Result := False;
  if not compare(A.V[1], B.V[1]) then Result := False;
  if not compare(A.V[2], B.V[2]) then Result := False;
  if not compare(A.V[3], B.V[3]) then Result := False;
end;

{$i native.inc}

end.
