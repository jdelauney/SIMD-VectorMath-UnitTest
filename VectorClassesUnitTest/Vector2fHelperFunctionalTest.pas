unit Vector2fHelperFunctionalTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}
interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;
type

  { TVector2fHelperFunctionalTest }

  TVector2fHelperFunctionalTest = class(TVectorBaseTestCase)
    published
      //procedure TestRotate;
      //procedure TestRotateX;
      //procedure TestRotateY;
      //
      //procedure TestRotateWithMatrixAroundX;
      //procedure TestRotateWithMatrixAroundY;
      //
      //procedure TestMoveAround;
      //procedure TestShiftObjectFromCenter;


      procedure TestStep;
      //procedure TestFaceForward;
      procedure TestSaturate;
      procedure TestSmoothStep;
      procedure TestLerp;
      //procedure Test;

  end;

implementation

// more of a CanStep and to where function where it compares two vector and decides
// if needs to step in one of the directions. Positive only step functionality.
// or if a colour change transform does this component need changing
procedure TVector2fHelperFunctionalTest.TestStep;
begin
  vtt2.Create(2,2);
  ntt2.Create(2,2);

  vtt1.Create(2,2);
  vtt4 := vtt1.step(vtt2);
  AssertEquals('Step:Sub1 X failed ',  0.0, vtt4.X);
  AssertEquals('Step:Sub2 Y failed ',  0.0, vtt4.Y);

  vtt1.Create(3,2);
  //ntt1.Create(3,2);
  //ntt3 := ntt1.step(ntt2);
  vtt4 := vtt1.step(vtt2);
  AssertEquals('Step:Sub3 X failed  <--> '+vtt1.ToString+' <--> '+vtt4.ToString,  3.0, vtt4.X);
  AssertEquals('Step:Sub4 Y failed  <--> '+vtt1.ToString+' <--> '+vtt4.ToString,  0.0, vtt4.Y);

  vtt1.Create(2,3);
  vtt4 := vtt1.step(vtt2);
  AssertEquals('Step:Sub5 X failed '+vtt1.ToString+' <--> '+vtt4.ToString,  0.0, vtt4.X);
  AssertEquals('Step:Sub6 Y failed '+vtt1.ToString+' <--> '+vtt4.ToString,  3.0, vtt4.Y);
end;

// self is N = normal vector of face /texel
// A is view vector
// B is perturbed Vector
// Note for this to work self must be part of a list of backfaces to test.
// this function will hide visible faces.
//procedure TVector2fHelperFunctionalTest.TestFaceForward;
//begin
//  vtt1.Create(1,1,1,0);  // test result vector, does not play a part in calcs
//  vtt2.Create(0,0,-1,0); // this is eye to screen +z out -z eye to screen
//  vtt3.create(0,0, 1,0); // pV is towards eye hidden face we want to show
//  vtt4 := vtt1.FaceForward(vtt2,vtt3);
//  AssertEquals('FaceForward:Sub1 X failed ',  -1.0, vtt4.X);
//  AssertEquals('FaceForward:Sub2 Y failed ',  -1.0, vtt4.Y);
//  AssertEquals('FaceForward:Sub3 Z failed ',  -1.0, vtt4.Z);
//  AssertEquals('FaceForward:Sub4 W failed ',   0.0, vtt4.W);
//  vtt3.create(0,0,-1,0); // pV is away from eye remain hidden face
//  vtt4 :=  vtt1.FaceForward(vtt2,vtt3);
//  AssertEquals('FaceForward:Sub5 X failed ',  1.0, vtt4.X);
//  AssertEquals('FaceForward:Sub6 Y failed ',  1.0, vtt4.Y);
//  AssertEquals('FaceForward:Sub7 Z failed ',  1.0, vtt4.Z);
//  AssertEquals('FaceForward:Sub8 W failed ',  0.0, vtt4.W);
//  vtt3.create(0,0,-1,0); // pV is away from eye remain hidden face
//  vtt4 :=  vtt1.FaceForward(vtt3,vtt2);  // you can swap eyeV and pV same result.
//  AssertEquals('FaceForward:Sub9 X failed ',   1.0, vtt4.X);
//  AssertEquals('FaceForward:Sub10 Y failed ',  1.0, vtt4.Y);
//  AssertEquals('FaceForward:Sub11 Z failed ',  1.0, vtt4.Z);
//  AssertEquals('FaceForward:Sub12 W failed ',  0.0, vtt4.W);
//end;

// Clamp anything to between 0 and 1 preserves hmg point
procedure TVector2fHelperFunctionalTest.TestSaturate;
begin
   vtt1.Create(0.5,0.5);
   vtt4 := vtt1.Saturate;
   AssertEquals('Saturate:Sub1 X failed : <'+vtt1.ToString+'>' +vtt4.ToString,   0.5, vtt4.X);
   AssertEquals('Saturate:Sub2 Y failed : <'+vtt1.ToString+'>' +vtt4.ToString,   0.5, vtt4.Y);
   vtt1.Create(1.0,1.5);
   vtt4 := vtt1.Saturate;
   AssertEquals('Saturate:Sub3 X failed ',   1.0, vtt4.X);
   AssertEquals('Saturate:Sub4 Y failed ',   1.0, vtt4.Y);
   vtt1.Create(1.5,0.5);
   vtt4 := vtt1.Saturate;
   AssertEquals('Saturate:Sub5 X failed ',    1.0, vtt4.X);
   AssertEquals('Saturate:Sub6 Y failed ',   0.5, vtt4.Y);
   vtt1.Create(0.5,1.5);
   vtt4 := vtt1.Saturate;
   AssertEquals('Saturate:Sub7 X failed ',   0.5, vtt4.X);
   AssertEquals('Saturate:Sub8 Y failed ',   1.0, vtt4.Y);
   vtt1.Create(-0.5,0.5);
   vtt4 := vtt1.Saturate;
   AssertEquals('Saturate:Sub9 X failed ',   0.0, vtt4.X);
   AssertEquals('Saturate:Sub10 Y failed ',   0.5, vtt4.Y);
   vtt1.Create(0.5,-0.5);
   vtt4 := vtt1.Saturate;
   AssertEquals('Saturate:Sub11 X failed ',   0.5, vtt4.X);
   AssertEquals('Saturate:Sub12 Y failed ',   0.0, vtt4.Y);
   vtt1.Create(-0.5,1.0);
   vtt4 := vtt1.Saturate;
   AssertEquals('Saturate:Sub13 X failed ',   0.0, vtt4.X);
   AssertEquals('Saturate:Sub14 Y failed ',   1.0, vtt4.Y);
end;


// t := (Self - a) / (b - a);   <--- dangerous for point and vec, W will always be 0
// t := t.Saturate;             <--- saturate clamps -inf to 0, saved by this
// result := t * t * (3.0 - (t * 2.0));
// above function behaves like some form of a normal distribution
// if used as add this fraction of diff to A then we get a transition
// which has less mid and more of the ends.  (spotlight/highlight?)
procedure TVector2fHelperFunctionalTest.TestSmoothStep;
begin
   vtt1.Create(1,1);  // self
   vtt2.Create(0,0);  // A
   vtt3.Create(2,2);  // B   lerp would return 0.5 for this
   vtt4 := vtt1.SmoothStep(vtt2,vtt3);
   AssertEquals('TestSmoothStep:Sub1 X failed : <'+vtt1.ToString+'>' +vtt4.ToString,   0.5, vtt4.X);
   AssertEquals('TestSmoothStep:Sub2 Y failed : <'+vtt1.ToString+'>' +vtt4.ToString,   0.5, vtt4.Y);

   vtt1.Create(0.5,0.5);  // self
   vtt4 := vtt1.SmoothStep(vtt2,vtt3);   // lerp would return 0.25 for this
   AssertEquals('TestSmoothStep:Sub3 X failed : <'+vtt1.ToString+'>' +vtt4.ToString, 0.15625, vtt4.X,1e-4);
   AssertEquals('TestSmoothStep:Sub4 Y failed  : <'+vtt1.ToString+'>' +vtt4.ToString, 0.15625, vtt4.Y,1e-4);;


   vtt1.Create(1.5,1.5);  // self
   vtt4 := vtt1.SmoothStep(vtt2,vtt3);   // lerp would return 0.25 for this
   AssertEquals('TestSmoothStep:Sub5 X failed : <'+vtt1.ToString+'>' +vtt4.ToString, 0.84375, vtt4.X,1e-4);
   AssertEquals('TestSmoothStep:Sub6 Y failed : <'+vtt1.ToString+'>' +vtt4.ToString, 0.84375, vtt4.Y,1e-4);;


   vtt2.Create(0,2);  // Make one item the same as upper
   vtt4 := vtt1.SmoothStep(vtt2,vtt3);   // lerp would return 0.75 for this
   AssertEquals('TestSmoothStep:Sub7 X failed : <'+vtt1.ToString+'>' +vtt4.ToString,    0.84375, vtt4.X,1e-4);
   AssertEquals('TestSmoothStep:Sub8 Y failed : <'+vtt1.ToString+'>' +vtt4.ToString,   0.0, vtt4.Y,1e-4);
end;

procedure TVector2fHelperFunctionalTest.TestLerp;
begin
  vtt1.Create(60,60);
  vtt4 := vtt1.Lerp(NullVector2f, 0.5);
  AssertEquals('Lerp:Sub1 X failed ', 30, vtt4.X);
  AssertEquals('Lerp:Sub2 Y failed ', 30, vtt4.Y);
  vtt4 := vtt1.Lerp(NullVector2f, 0.25);
  AssertEquals('Lerp:Sub3 X failed ', 45, vtt4.X);
  AssertEquals('Lerp:Sub4 Y failed ', 45, vtt4.Y);
  vtt4 := vtt1.Lerp(NullVector2f, 0.75);
  AssertEquals('Lerp:Sub5 X failed ',  15, vtt4.X);
  AssertEquals('Lerp:Sub6 Y failed ', 15, vtt4.Y);
  vtt4 := NullVector2f.Lerp(vtt1, 0.75);
  AssertEquals('Lerp:Sub7 X failed ', 45, vtt4.X);
  AssertEquals('Lerp:Sub8 Y failed ', 45, vtt4.Y);
  vtt4 := NullVector2f.Lerp(vtt1, 0.25);
  AssertEquals('Lerp:Sub9 X failed ', 15, vtt4.X);
  AssertEquals('Lerp:Sub10 Y failed ', 15, vtt4.Y);
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR2F, TVector2fHelperFunctionalTest);
end.


