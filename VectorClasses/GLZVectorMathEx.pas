(*====< GLZVectorMathEx.pas >=====================================================@br

@created(2017-11-25)
@author(J.Delauney (BeanzMaster))
@author(Peter Dyson (Dicepd))

Historique : @br
@unorderedList(
  @item(Last Update : 13/03/2018  )
  @item(12/03/2018 : Creation  )
)

  ------------------------------------------------------------------------------@br
  Description :@br
  GLZVectorMathEx Contains extra optimized classes using SIMD (SSE, SSE3, SS4, AVX, AVX2) acceleration@br  
  Those classes are specialized and must be in graphic rendering/physics engine
  It can be used in 2D/3D graphics, computing apps, games...@br

  Support :@br
    @unorderedlist (
     @item(Frustum)
     @item(Oriented Bounding Box for 3D
     @item(Bounding Sphere for 3D, Bounding Circle for 2D )
     @item(Axis Aligned Bounding Box for 3D, Axis Aligned Bounding Rect for 2D )     
	 @item(Raycast)	 	 
  )

  ------------------------------------------------------------------------------@br
  @bold(Notes :)@br
	
  Some links as references :@br
    @unorderedList(
       @item()
     )@br

   Quelques liens en français (in french) :@br
     @unorderedList(
       @item()
     )@br

   Others interesting articles, papers at some points:@br
     @unorderedList(
       @item()
     )@br

   You can also found some papers in @bold(DocRefs) folder@br
  ------------------------------------------------------------------------------@br

  @bold(Credits :)@br
    @unorderedList(
      @item(FPC/Lazarus)
      @item(GLScene)
      @item(All authors of papers and web links)
    )

  ------------------------------------------------------------------------------@br
  LICENCE : MPL
  @br
  ------------------------------------------------------------------------------@br
*==============================================================================*)
Unit GLZVectorMathEx;

{$WARN 5036 on : Local variable "$1" does not seem to be initialized}
{$WARN 5025 on : Local variable "$1" not used}
{$WARN 5028 on : Local const "$1" not used}

{$mode objfpc}{$H+}

//-----------------------------
{$ASMMODE INTEL}
{$INLINE ON}
{$MODESWITCH ADVANCEDRECORDS}
//-----------------------------

//----------------------- DATA ALIGNMENT ---------------------------------------
{$ALIGN 16}
{$CODEALIGN CONSTMIN=16}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN VARMIN=16}
//------------------------------------------------------------------------------

// Those options are set in compiler options with the -d command
{.$DEFINE USE_ASM} // use SIMD SSE/SSE2 by default
{.$DEFINE USE_ASM_AVX}
{.$DEFINE USE_ASM_SSE_4}
{.$DEFINE USE_ASM_SSE_3}
{.$DEFINE TEST}

// Some function don't have SSE4 instruction, so enable SSE3
{$IFDEF USE_ASM_SSE_4}
  {$DEFINE USE_ASM_SSE_3}
{$ENDIF}

{$IFDEF USE_ASM_SSE_3}
  {$DEFINE USE_ASM}
{$ENDIF}

{$IFDEF USE_ASM_AVX}
  {$DEFINE USE_ASM}
{$ENDIF}

{$DEFINE USE_ASM_SIMD_HIGHPRECISION}

//-----------------------

Interface

Uses
  Classes, Sysutils, GLZVectorMath;

{%region%----[ BoundingBox ]----------------------------------------------------}

Type
  {
  TGLZ2DSingleAffineMatrix : Represent a 2D affine transformation as a 3x3 matrix

  More informations :@br
  @unorderedlist(
    @item(https://computergraphics.stackexchange.com/questions/391/what-are-affine-transformations)
    @item(https://en.wikipedia.org/wiki/Affine_transformation)
    @item(http://blog.lotech.org/2013/05/the-beauty-of-using-matrices-to-apply.html)
    @item(https://webglfundamentals.org/webgl/lessons/fr/webgl-2d-matrices.html)
    @item(https://www.tutorialspoint.com/computer_graphics/2d_transformation.htm)
    @item(https://code.tutsplus.com/tutorials/understanding-affine-transformations-with-matrix-mathematics--active-10884)
    @item(http://negativeprobability.blogspot.in/2011/11/affine-transformations-and-their.html)
    @item(https://homepages.inf.ed.ac.uk/rbf/HIPR2/affine.htm)
    @item(http://ncase.me/matrix/)
   )}
  TGLZ2DSingleAffineMatrix = record
  private
      function GetComponent(const ARow, AColumn: Integer): Single; inline;
      procedure SetComponent(const ARow, AColumn: Integer; const Value: Single); inline;
      function GetRow(const AIndex: Integer): TGLZVector3f; inline;
      procedure SetRow(const AIndex: Integer; const Value: TGLZVector3f); inline;

      function GetDeterminant: Single;
  public

    procedure CreateIdentityMatrix;
    procedure CreateNullMatrix;

    procedure CreateTranslationMatrix(Const OffsetX, OffsetY : Single); overload;
    procedure CreateTranslationMatrix(Constref Offset : TGLZVector2f); overload;

    procedure CreateScaleMatrix(Const ScaleX, ScaleY : Single);overload;
    procedure CreateScaleMatrix(Constref Scale : TGLZVector2f);overload;

    procedure CreateRotationMatrix(Const anAngle : Single);overload;

    procedure CreateShearMatrix(const ShearX, ShearY : Single);overload;
    procedure CreateShearMatrix(constref Shear : TGLZVector2f);overload;

    procedure CreateReflectXMatrix;
    procedure CreateReflectYMatrix;
    procedure CreateReflectMatrix;

    procedure Create(Const ScaleX, ScaleY, ShearX, ShearY, anAngle, OffsetX, OffsetY  : Single); overload;
    procedure Create(Constref Scale, Shear, Offset : TGLZVector2f; Const anAngle : Single); overload;

    { Convert to string }
    { @name : Return Matrix to a formatted string :@br
	  "("x, y, Z")" @br
	  "("x, y, Z")" @br
	  "("0, 0, 1")" @br
      @return(String) }
    function ToString : String;

    { @name : Multiplies two matrices
      @param(A : TGLZ2DSingleAffineMatrix)
      @param(B : TGLZ2DSingleAffineMatrix)
      @return(TGLZ2DSingleAffineMatrix) }
    class operator *(constref A, B: TGLZ2DSingleAffineMatrix): TGLZ2DSingleAffineMatrix; overload;

    { @name : Transforms a vector by multiplying it with a matrix
      @param(A : TGLZ2DSingleAffineMatrix)
      @param(B : TGLZVector2f)
      @return(TGLZVector2f) }
    class operator *(constref A: TGLZ2DSingleAffineMatrix; constref B: TGLZVector2f): TGLZVector2f; overload;

    { @name : Transforms a vector by multiplying it with a matrix
      @param(A : TGLZVector2f)
      @param(B : TGLZ2DSingleAffineMatrix)
      @return(TGLZVector2f) }
    class operator *(constref A: TGLZVector2f; constref B: TGLZ2DSingleAffineMatrix): TGLZVector2f; overload;

    { @name : Computes transpose of the matrix
      @return(TGLZ2DSingleAffineMatrix) }
    function Transpose: TGLZ2DSingleAffineMatrix;

    { @name : Finds the inverse of the matrix
      @return(TGLZ2DSingleAffineMatrix) }
    function Invert : TGLZ2DSingleAffineMatrix;


    property Components[const ARow, AColumn: Integer]: Single read GetComponent write SetComponent; default;

    { Get Determinant of the matrix
      @return(Single)}
    property Determinant: Single read GetDeterminant;

    { Access properties }
    case Byte of
    { The elements of the matrix in row-major order }
      0: (M: array [0..2, 0..2] of Single);
      1: (V: array [0..2] of TGLZVector3f);
      2: (X,Y,Z : TGLZVector3f);
      3: (m11, m12, m13 : Single;
          m21, m22, m23 : Single;
          m31, m32, m33 : Single;
         );
  End;

{%endregion%}

 { Note :
   The records above are used the most in Render, Physics, collision engine.
   For use there records, it will be recommended to wrap those in classes }

{%region%----[ BoundingBox ]----------------------------------------------------}

  { Describe a 3D Oriented Bounding Box "OBB"@br
    An OBB is define by eight point (position of each corner of the "box")

    More informations :@br
    @unorderedlist(
     @item(https://en.wikipedia.org/wiki/Minimum_bounding_box)
     @item(https://geidav.wordpress.com/tag/oriented-bounding-box/)
     @item(https://graphics.ethz.ch/teaching/former/seminar02/handouts/collisiondetection.pdf)
     @item(http://www.idt.mdh.se/~tla/publ/FastOBBs.pdf)
     @item(http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.717.9566&rep=rep1&type=pdf)
     @item(https://www.geometrictools.com/Documentation/DynamicCollisionDetection.pdf)
     @item(http://gamma.cs.unc.edu/users/gottschalk/main.pdf)
    )@br
    @Bold(Note :) For use it, it will be recommended to wrap it in classes @br
    @Bold(UNFINISHED)}
Type
  TGLZBoundingBox = record
  private
  public
    { @name : Create a minimal Oriented Bounding Box from a point
      @param(AValue : TGLZVector -- A Point)}
    procedure Create(Const AValue : TGLZVector);

    { @name : Add two OBB
      @param(A : TGLZBoundingBox)
      @param(B : TGLZBoundingBox)
      @return(TGLZBoundingBox) }
    class operator +(ConstRef A, B : TGLZBoundingBox):TGLZBoundingBox;overload;
    { @name : Add to the OBB a point (Extend the bounding box)
      @param(A : TGLZBoundingBox)
      @param(B : TGLZVector)
      @return(TGLZBoundingBox) }
    class operator +(ConstRef A: TGLZBoundingBox; ConstRef B : TGLZVector):TGLZBoundingBox;overload;
	
    //class operator -(ConstRef A, B : TGLZBoundingBox):TGLZBoundingBox;overload;
    { @name : Compare if two Oriented Bounding Box are equal
      @param(A : TGLZBoundingBox)
      @param(B : TGLZBoundingBox)
      @return(Boolean @True if equal)}
    class operator =(ConstRef A, B : TGLZBoundingBox):Boolean;overload;

    { @name : Applies a 4x4 affine transformation matrix to a bounding sphere.
      @param(M : TGLZMatrix)
      @return(TGLZBoundingBox)}
    function Transform(ConstRef M:TGLZMatrix):TGLZBoundingBox;

    { @name : Return the minimum of X
      @return(single) }
    function MinX : Single;

    { @name : Return the maximum of X
      @return(single) }
    function MaxX : Single;

    { @name : Return the minimum of Y
      @return(single) }
    function MinY : Single;

    { @name : Return the maximum of Y
      @return(single) }
    function MaxY : Single;

    { @name : Return the minimum of Z
      @return(single) }
    function MinZ : Single;

    { @name : Return the maximum of Z
      @return(single) }
    function MaxZ : Single;

    { Access properties }
    Case Integer of
     0 : (Points : Array[0..7] of TGLZVector); //< Array access
     1 : (pt1, pt2, pt3, pt4 :TGLZVector;      //< Legacy access
          pt5, pt6, pt7, pt8 :TGLZVector);
  end;

{%endregion%}

  { Result type for space intersection tests, with Bounding records
    see also : @br
    - TGLZBoundingSphere, TGLZAxisAlignedBoundingBox  (3D)@br
    - TGLZBoundingCircle, TGLZAxisAlignedBoundingRect (2D)@br
  }
  TGLZSpaceContains = (ScNoOverlap, ScContainsFully, ScContainsPartially);

{%region%----[ BoundingSphere ]-------------------------------------------------}

  //TGLZBoundingCircle
  { TGLZBoundingSphere : Describe a very Bounding Sphere system

    More informations :@br
    @unorderedlist(
     @item(https://en.wikipedia.org/wiki/Bounding_sphere)
     @item(https://www.ep.liu.se/ecp/034/009/ecp083409.pdf)
     @item(https://www.mvps.org/directx/articles/using_bounding_spheres.htm)
    )@br
    @Bold(Note :) For use it, it will be recommended to wrap it in classes @br
    @Bold(UNFINISHED)}
  TGLZBoundingSphere = record
  public
    { @name : Create a bounding sphere
      @param(X : Single)
      @param(Y : Single)
      @param(Z : Single)
      @param(R : Single -- Radius default 1.0)}
    procedure Create(Const x,y,z: Single;Const r: single = 1.0); overload;
	
    { @name : Create a bounding sphere
      @param(AValue : TGLZAffineVector)
      @param(R : Single -- Radius default 1.0)}
    procedure Create(Const AValue : TGLZAffineVector;Const r: single = 1.0); overload;
	
    { @name : Create a bounding sphere
      @param(AValue : TGLZVector)
      @param(R : Single -- Radius default 1.0)}
    procedure Create(Const AValue : TGLZVector;Const r: single = 1.0); overload;
	
    { @name : Return Bounding Sphere to a formatted string eg "("x, y, z, Radius")"     
      @return(String) }
    function ToString: String;

    { @name : Determines the space intersection of the Bounding Sphere with another Bounding Sphere
      @param(TestBSphere: TGLZBoundingSphere)
      @return(TGLZSpaceContains)}
    function Contains(const TestBSphere: TGLZBoundingSphere) : TGLZSpaceContains;

    { @name : Determines if the Bounding Sphere intersects another Bounding Sphere
      @param(TestBSphere: TGLZBoundingSphere)
      @return(Boolean @true if Intersect)}
    function Intersect(const TestBSphere: TGLZBoundingSphere): Boolean;

    { Access properties }
    Case Integer of

      0 : (Center: TGLZVector; //< Center of Bounding Sphere
          Radius: Single);     //< Radius of Bounding Sphere
  end;

{%endregion%}

{%region%----[ Axis Aligned BoundingBox ]---------------------------------------}

  (*  Infos :

      "The basic calculation underlying ray tracing is that of the intersection of a line with@br
       the surfaces of an object. A method  for performing this calculation @br
       for a new and powerful class of objects, those defined by sweeping a sphere of varying radius along a 3D trajectory.@br
       When polynomials are used for the parametrization of the centre and radius of the sphere,@br
       the intersection problem reduces to the location of the roots of a polynomial."@br
       @italic(Source : https://www.sciencedirect.com/science/article/pii/009784938590055X)@br
  *)

  { TGLZAABBCorners : Structure for storing the corners of an AABB, used with TGLZAxisAlignedBoundingBox.ExtractCorners }
  TGLZAABBCorners = array [0 .. 7] of TGLZVector;

  // TGLZAABRCorners = array [0 .. 3] of TGLZVector2f;
  // TGLZAxisAlignedBoundingRect

  { TGLZAxisAlignedBoundingBox : Describe a 3D Axis Aligned Bounding Box (AABB)

    More informations :@br
    @unorderedlist(
     @item(https://en.wikipedia.org/wiki/Bounding_volume)
     @item(https://www.gamasutra.com/view/feature/131833/when_two_hearts_collide_.php)
     @item(https://developer.mozilla.org/kab/docs/Games/Techniques/2D_collision_detection)
     @item(https://www.azurefromthetrenches.com/introductory-guide-to-aabb-tree-collision-detection/)
     @item(http://www.gamefromscratch.com/post/2012/11/26/GameDev-math-recipes-Collision-detection-using-an-axis-aligned-bounding-box.aspx)
     @item(https://www.researchgate.net/publication/303703971_An_intensity_recovery_algorithm_IRA_for_minimizing_the_edge_effect_of_LIDAR_data)
     @item(http://www-ljk.imag.fr/Publications/Basilic/com.lmc.publi.PUBLI_Inproceedings@117681e94b6_1860ffd/bounding_volume_hierarchies.pdf)
    )@br
    @Bold(Note :) For use it, it will be recommended to wrap it in classes @br
    @Bold(UNFINISHED)}
  TGLZAxisAlignedBoundingBox =  record
  public
    { @name : Create AABB from one point
      @param(AValue: TGLZVector) }
    procedure Create(const AValue: TGLZVector);overload;
	
    { @name : Create AABB from two bounding points
      @param(AMin: TGLZVector)
      @param(AMax: TGLZVector) }
    procedure Create(const AMin, AMax: TGLZVector);overload;

    { @name : Create the AABB information from an OBB.
      @param(ABB: TGLZBoundingBox)}
    procedure Create(const ABB: TGLZBoundingBox);

    { @name : Make the AABB that is formed by sweeping a sphere (or AABB) from Start to Dest

      More informations :@br
        @unorderedlist(
         @item(http://physicsforgames.blogspot.in/2010/03/narrow-phase-sweeping-sphere-against.html)
         @item(https://www.gamasutra.com/view/feature/131790/simple_intersection_tests_for_games.php)
        )
      @param(Start : TGLZVector)
      @param(Dest : TGLZVector)
      @param(Radius : Single)}
    procedure CreateFromSweep(const Start, Dest: TGLZVector;const Radius: Single);

    { @name : Convert a BSphere to the AABB
      @param(BSphere: TGLZBoundingSphere) }
    procedure Create(const BSphere: TGLZBoundingSphere); overload;
	
    { @name : Convert a BSphere to the AABB
      @param(Center: TGLZVector)
      @param(Radius: Single) }
    procedure Create(const Center: TGLZVector; Radius: Single); overload;

    { @name : Add one AABB to another AABB
      @param( A : TGLZAxisAlignedBoundingBox)
      @param( B : TGLZAxisAlignedBoundingBox)
      @return(TGLZAxisAlignedBoundingBox) }
    class operator +(ConstRef A, B : TGLZAxisAlignedBoundingBox):TGLZAxisAlignedBoundingBox;overload;
	
    { @name : Add one Point to another AABB
      @param( A : TGLZAxisAlignedBoundingBox)
      @param( B : TGLZVector)
      @return(TGLZAxisAlignedBoundingBox) }
    class operator +(ConstRef A: TGLZAxisAlignedBoundingBox; ConstRef B : TGLZVector):TGLZAxisAlignedBoundingBox;overload;
	
    { @name : Scale an AABB by a vector
      @param( A : TGLZAxisAlignedBoundingBox)
      @param( B : TGLZVector)
      @return(TGLZAxisAlignedBoundingBox) }
    class operator *(ConstRef A: TGLZAxisAlignedBoundingBox; ConstRef B : TGLZVector):TGLZAxisAlignedBoundingBox;overload;

    { @name : Compare if two AABB are equal
      @param( A : TGLZAxisAlignedBoundingBox)
      @param( B : TGLZAxisAlignedBoundingBox)
      @return(@True if equal. @False otherwise) }
    class operator =(ConstRef A, B : TGLZAxisAlignedBoundingBox):Boolean;overload;

    { @name : Transform the AABB by a matrix
      @param(M:TGLZMatrix)
      @return(TGLZAxisAlignedBoundingBox) }
    function Transform(Constref M:TGLZMatrix):TGLZAxisAlignedBoundingBox;
	
    { @name : Extend the AABB with the point P
      @param(P:TGLZVector)
      @return(TGLZAxisAlignedBoundingBox) }
    function Include(Constref P:TGLZVector):TGLZAxisAlignedBoundingBox;
	
    { @name  Returns the intersection of the AABB with second AABBs.@br
             If the AABBs don't intersect, will return a degenerated AABB (plane, line or point).
      @param(B: TGLZAxisAlignedBoundingBox)
      @return(TGLZAxisAlignedBoundingBox) }		 
    function Intersection(const B: TGLZAxisAlignedBoundingBox): TGLZAxisAlignedBoundingBox;

    { @name : Converts the AABB to its canonical BB.
      @return(TGLZBoundingBox) }
    function ToBoundingBox: TGLZBoundingBox; overload;

    { @name  : Converts the transformed AABB to a BB.
      @param(M: TGLZMatrix)
      @return(TGLZBoundingBox) }
    function ToBoundingBox(const M: TGLZMatrix) : TGLZBoundingBox; overload;

    { @name : Convert the AABB to a BSphere
      @return(TGLZBoundingSphere) }
    function ToBoundingSphere: TGLZBoundingSphere;

	// Not needed at this stage @TODO MOVE IN A TGLZAABoundingBoxObject class
    //function ToClipRect(ModelViewProjection: TGLZMatrix; ViewportSizeX, ViewportSizeY: Integer): TGLZClipRect;
	
    { @name : Determines if self Intersect with another Axis Aligned Bounding Box.@br
              The matrices are the ones that convert one point to the other's AABB system. @br
	      m1 : Rotation matrix; m2 : TranslationAndScale Matrix ????
      @param(B: TGLZAxisAlignedBoundingBox)
      @param(M1: TGLZMatrix)
      @param(M2: TGLZMatrix)
      @return(@True if intersect. @False otherwise) }		  
    function Intersect(const B: TGLZAxisAlignedBoundingBox;const M1, M2: TGLZMatrix):Boolean;

    { @name : Checks whether self collide with another Axis Aligned Bounding Box in the XY plane.
      @param(B: TGLZAxisAlignedBoundingBox)
      @return(@True if intersect. @False otherwise) }
    function IntersectAbsoluteXY(const B: TGLZAxisAlignedBoundingBox): Boolean;

    { @name : Checks whether self collide with another Axis Aligned Bounding Box in the XZ plane.
      @param(B: TGLZAxisAlignedBoundingBox)
      @return(@True if intersect. @False otherwise) }
    function IntersectAbsoluteXZ(const B: TGLZAxisAlignedBoundingBox): Boolean;

    { @name : Checks whether self collide with another Axis Aligned Bounding Box, aligned with the world axes .
      @param(B: TGLZAxisAlignedBoundingBox)
      @return(@True if intersect. @False otherwise) }
    function IntersectAbsolute(const B: TGLZAxisAlignedBoundingBox): Boolean;

    { @name : Checks whether self fits within another Bounding box, aligned with the world axes .
      @param(B: TGLZAxisAlignedBoundingBox)
      @return(@True if fit. @False otherwise) }
    function FitsInAbsolute(const B: TGLZAxisAlignedBoundingBox): Boolean;

    { @name : Checks if a point "p" is inside the AABB
      @param(P: TGLZVector)
      @return(@True if inside. @False otherwise) }
    function PointIn(const P: TGLZVector): Boolean;

    { @name : Extract the corners from the AABB
      @return(TGLZAABBCorners) }
    function ExtractCorners: TGLZAABBCorners;

    { @name : Determines to which extent the AABB contains another AABB
      @param(TestAABB: TGLZAxisAlignedBoundingBox)
      @return(TGLZSpaceContains) }
    function Contains(const TestAABB: TGLZAxisAlignedBoundingBox): TGLZSpaceContains; overload;
	
    { @name : Determines to which extent the AABB contains a BSphere
      @param(TestBSphere: TGLZBoundingSphere)
      @return(TGLZSpaceContains) }
    function Contains(const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains; overload;

    // @TODO MOVE TO TGLZVectorHelper
    { : Clips a position to the AABB }
    //function Clip(const V: TGLZAffineVector): TGLZAffineVector;

	// @TODO MOVE TO TGLZRayCast
    { : Finds the intersection between a ray and an axis aligned bounding box. }
    //function RayCastIntersect(const RayOrigin, RayDirection: TGLZVector; out TNear, TFar: Single): Boolean; overload;
    //function RayCastIntersect(const RayOrigin, RayDirection: TGLZVector; IntersectPoint: PGLZVector = nil): Boolean; overload;

    Case Integer of
      0 : (Min, Max : TGLZVector);
  end;

{%endregion%}

//{%region%----[ Frustum ]--------------------------------------------------------}
//
//  TGLZFrustum =  record
//  public
//    { Extracts a TFrustum for combined modelview and projection matrices. }
//    function CreateFromModelViewProjectionMatrix(constref modelViewProj : TGLZMatrix) : TGLZFrustum;
//
//    // function ExtractMatrix : TGLZMatrix;
//
//    function Contains(constref TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;overload;
//    // see http://www.flipcode.com/articles/article_frustumculling.shtml
//    function Contains(constref TestAABB: TGLZAxisAlignedBoundingBox) : TGLZSpaceContains;overload;
//
//    // Determines if volume is clipped or not
//    function IsVolumeClipped(constref objPos : TGLZVector; const objRadius : Single):Boolean;overload; //const Frustum : TFrustum) : Boolean; overload;
//    //function IsVolumeClipped(const min, max : TGLZVector):Boolean;overload; //const Frustum : TFrustum) : Boolean; overload;
//
//
//   case byte of
//     0: (pLeft, pTop, pRight, pBottom, pNear, pFar : TGLZHmgPlane;
//         BoundingSphere: TGLZBoundingSphere); //Extended frustum, used for fast intersection testing
//     1: (Planes : Array[0..5] of TGLZHmgPlane);
//
// end;
//
//{%endregion%}

{%region%----[ TGLZBoundingBoxHelper ]------------------------------------------}
{%endregion%}

{%region%----[ TGLZAxisAlignedBoundingBoxHelper ]-------------------------------}
{%endregion%}

{%region%----[ Frustum ]--------------------------------------------------------}

  { Convenience for Frustrum planes access }
  TGLZFrustrumPlanesArray = Array[0..5] of TGLZHmgPlane;
  { Frustum management class }
 (* TGLZFrustum =  Class
  private
    // FpNear, FpFar
    // FpLeft,FpTop,
    // FpRight,FpBottom : TGLZHmgPlane;

    // Boundary planes (front, back, left, top, right, bottom)
    FPlanes : TGLZFrustrumPlanesArray;
    // Extended frustum, used for fast intersection testing
    FBoundingSphere: TGLZBoundingSphere;
    // View matrix
    FViewMatrix: TGLZMatrix;
    // Projection matrix
    FProjectionMatrix: TGLZMatrix;
    // Field of view on Y
    FFOVY: Single;
    // Field of view on X
    FFOVX: Single;
    // Clipping distance
    FClipDistance : TGLZVector2f; //x = Near, Y = Far

    // Theta ????
    FTheta: Single;

    // View width.
    FViewWidth: Single;
    // View height.
    FViewHeight: Single;
    // View Aspect Ratio
    FAspectRatio: Single;

    procedure SetPlane(Const Idx:Integer; aPlane : TGLZHmgPlane);
    function  GetPlane(Const Idx:Integer) : TGLZHmgPlane;
    procedure SetViewPort( const aWidth, aHeight: Single );
    procedure SetFOVy( const AFOVy: Single );
    function GetFOVy( ): Single; inline;
    procedure SetAspectRatio( const fRatio: Single );
    function GetAspectRatio( ): Single;
    procedure SetNearClipDistance( const DistNear: Single );
    function GetNearClipDistance : Single;
    procedure SetFarClipDistance( const DistFar: Single );
    function GetFarClipDistance : Single;
  protected
    // Set to TRUE if Datas need to be updated
    FNeedUpdate: Boolean;
    // Updates the planes.
    procedure DoUpdate();
  public
    // Create
    constructor Create( const VpWidth, VpHeight : Single; const DistNear, DistFar, FOVY: Single); overload;
    // Create from a view matrix
    constructor Create( const ViewMatrix: TGLZMatrix ); overload;

    Destructor Destroy;

    { Extracts a TFrustum for combined modelview and projection matrices. }
    Procedure ExtractFromModelViewProjectionMatrix(constref modelViewProj : TGLZMatrix);
    //  Compute  and return  projection matrix
    function GetProjectionMatrix( ): TGLZMatrix;

    // Returns True, if frustum needs an update.
    function NeedUpdate( ): Boolean; inline;

    // Tests against a bounding sphere.
    function Contains(constref TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;overload;

    // Tests against an axis-aligned bounding box.
    // function ContainsAABB( AABB: TPGAABB ): TGLZHmgPlaneHalfSpace;
    // see http://www.flipcode.com/articles/article_frustumculling.shtml
    function Contains(constref TestAABB: TGLZAxisAlignedBoundingBox) : TGLZSpaceContains;overload;

    // Determines if volume is clipped or not
    function IsVolumeClipped(constref objPos : TGLZVector; const objRadius : Single):Boolean;overload; //const Frustum : TFrustum) : Boolean; overload;
    //function IsVolumeClipped(const min, max : TGLZVector):Boolean;overload; //const Frustum : TFrustum) : Boolean; overload;

    property Planes : TGLZFrustrumPlanesArray read FPlanes;
    property Front  : TGLZHmgPlane index 0 read GetPlane write SetPlane;
    property Back   : TGLZHmgPlane index 1 read GetPlane write SetPlane;
    property Left   : TGLZHmgPlane index 2 read GetPlane write SetPlane;
    property Top    : TGLZHmgPlane index 3 read GetPlane write SetPlane;
    property Right  : TGLZHmgPlane index 4 read GetPlane write SetPlane;
    property Bottom : TGLZHmgPlane index 5 read GetPlane write SetPlane;
 end;  *)

{%endregion%}

{%region%----[ TGLZHmgPlaneHelper ]---------------------------------------------}

  { Helper for TGLZHmgPlane@br
    Used for functions where we use types not declared before TGLZHmgPlane }
  TGLZHmgPlaneHelper = record helper for TGLZHmgPlane
  public
    { @name :
      @param(TestBSphere: TGLZBoundingSphere)
      @return(TGLZSpaceContains) }
    function Contains(const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;

    { @name :
      @param(Location : TGLZVector )
      @param(Normal : TGLZVector)
      @param(TestBSphere : TGLZBoundingSphere)
      @return(TGLZSpaceContains) }
    //function PlaneContains(const Location, Normal: TGLZVector; const TestBSphere: TGLZBoundingSphere): TGLZSpaceContains;

    { @name : Calculates the cross-product between the plane normal and plane to point vector. @br
              This functions gives an hint as to were the point is, if the point is in the half-space pointed by the vector, result is positive. @br
              This function performs an homogeneous space dot-product.
      @param(Point : TGLZVector)
      @return(Single) }
    function EvaluatePoint(constref Point : TGLZVector) : Single;
  end;

{%endregion%}

{%region%----[ OBB Const ]------------------------------------------------------}

const
   // Null Oriented Bounding Box (OBB)
   NullBoundingBox: TGLZBoundingBox =
   (Points:((X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1),
            (X: 0; Y: 0; Z: 0; W: 1)));

{%endregion%}

Implementation

Uses Math, GLZMath;

// ---- Used by Bounding box functions -----------------------------------------

type
  TPlanIndices = array [0 .. 3] of Integer;
  TPlanBB = array [0 .. 5] of TPlanIndices;
  TDirPlan = array [0 .. 5] of Integer;

const
  CBBFront: TPlanIndices = (0, 1, 2, 3);
  CBBBack: TPlanIndices = (4, 5, 6, 7);
  CBBLeft: TPlanIndices = (0, 4, 7, 3);
  CBBRight: TPlanIndices = (1, 5, 6, 2);
  CBBTop: TPlanIndices = (0, 1, 5, 4);
  CBBBottom: TPlanIndices = (2, 3, 7, 6);
  CBBPlans: TPlanBB = ((0, 1, 2, 3), (4, 5, 6, 7), (0, 4, 7, 3), (1, 5, 6, 2),
    (0, 1, 5, 4), (2, 3, 7, 6));
  CDirPlan: TDirPlan = (0, 0, 1, 1, 2, 2);
  {$WARN 5025 off : Local variable "$1" not used}
  {$WARN 5028 off : Local const "$1" not used}

procedure SetPlanBB(Var A:TGLZBoundingBox;const NumPlan: Integer; const Valeur: Double);
var
  I: Integer;
begin
  for I := 0 to 3 do
  begin
    A.Points[CBBPlans[NumPlan][I]].V[CDirPlan[NumPlan]] := Valeur;
    A.Points[CBBPlans[NumPlan][I]].V[3] := 1;
  end;
end;

//-----[ INCLUDE IMPLEMENTATION ]-----------------------------------------------

{$ifdef USE_ASM}
  {$ifdef CPU64}
    {$ifdef UNIX}
      {$IFDEF USE_ASM_AVX}
         {$I vectormathex_boundingbox_native_imp.inc}
         {$I vectormathex_boundingsphere_native_imp.inc}
         {$I vectormathex_axisaligned_boundingbox_native_imp.inc}
         {.$I vectormathex_boundingboxhelper_native_imp.inc}
         {.$I vectormathex_axisaligned_boundingBoxhelper_native_imp.inc}
         {$I vectormathex_frustum_native_imp.inc}
         {$I vectormathex_hmgplanehelper_native_imp.inc}
	 {.$I vectormathex_hmgplanehelper_unix64_avx_imp.inc}
      {$ELSE}
         {$I vectormathex_2DSingleAffineMatrix_native_imp.inc}
         {$I vectormathex_boundingbox_native_imp.inc}
         {$I vectormathex_boundingsphere_native_imp.inc}
         {$I vectormathex_axisaligned_boundingbox_native_imp.inc}
         {.$I vectormathex_boundingboxhelper_native_imp.inc}
         {.$I vectormathex_axisaligned_boundingBoxhelper_native_imp.inc}
         {$I vectormathex_frustum_native_imp.inc}
         {$I vectormathex_hmgplanehelper_native_imp.inc}
	 {$I vectormathex_hmgplanehelper_unix64_sse_imp.inc}
      {$ENDIF}
    {$else} // win64
      {$IFDEF USE_ASM_AVX}
	 {$I vectormathex_boundingbox_native_imp.inc}
         {$I vectormathex_boundingsphere_native_imp.inc}
         {$I vectormathex_axisaligned_boundingbox_native_imp.inc}
         {.$I vectormathex_boundingboxhelper_native_imp.inc}
         {.$I vectormathex_axisaligned_boundingBoxhelper_native_imp.inc}
         {$I vectormathex_frustum_native_imp.inc}
         {$I vectormathex_hmgplanehelper_native_imp.inc}
	 {.$I vectormathex_hmgplanehelper_win64_avx_imp.inc}
       {$ELSE}
         {$I vectormathex_2DSingleAffineMatrix_native_imp.inc}
	 {$I vectormathex_boundingbox_native_imp.inc}
         {$I vectormathex_boundingsphere_native_imp.inc}
         {$I vectormathex_axisaligned_boundingbox_native_imp.inc}
         {.$I vectormathex_boundingboxhelper_native_imp.inc}
         {.$I vectormathex_axisaligned_boundingBoxhelper_native_imp.inc}
         {$I vectormathex_frustum_native_imp.inc}
         {$I vectormathex_hmgplanehelper_native_imp.inc}
	 {$I vectormathex_hmgplanehelper_win64_sse_imp.inc}
       {$ENDIF}
    {$endif}  //unix
  {$else} // CPU32
     {$IFDEF USE_ASM_AVX}
	 {$I vectormathex_boundingbox_native_imp.inc}
         {$I vectormathex_boundingsphere_native_imp.inc}
         {$I vectormathex_axisaligned_boundingbox_native_imp.inc}
         {.$I vectormathex_boundingboxhelper_native_imp.inc}
         {.$I vectormathex_axisaligned_boundingBoxhelper_native_imp.inc}
         {$I vectormathex_frustum_native_imp.inc}
         {$I vectormathex_hmgplanehelper_native_imp.inc}
     {$ELSE}
         {$I vectormathex_boundingbox_native_imp.inc}
         {$I vectormathex_boundingsphere_native_imp.inc}
         {$I vectormathex_axisaligned_boundingbox_native_imp.inc}
         {.$I vectormathex_boundingboxhelper_native_imp.inc}
         {.$I vectormathex_axisaligned_boundingBoxhelper_native_imp.inc}
         {$I vectormathex_frustum_native_imp.inc}
         {$I vectormathex_hmgplanehelper_native_imp.inc}
     {$ENDIF}
  {$endif}
  {$else}  // pascal
    {$I vectormathex_boundingbox_native_imp.inc}
    {$I vectormathex_boundingsphere_native_imp.inc}
    {$I vectormathex_axisaligned_boundingbox_native_imp.inc}
    {.$I vectormathex_boundingboxhelper_native_imp.inc}
    {.$I vectormathex_axisaligned_boundingBoxhelper_native_imp.inc}
    {$I vectormathex_hmgplanehelper_native_imp.inc}
    {$I vectormathex_2DSingleAffineMatrix_native_imp.inc}
    {$I vectormathex_frustum_native_imp.inc}
  {$endif}

initialization
finalization

End.
