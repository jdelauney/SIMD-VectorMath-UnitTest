unit Vector2fFunctionalTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase,
  native, GLZVectorMath;

type

  { TVector2fFunctionalTest }

  TVector2fFunctionalTest = class(TVectorBaseTestCase)
    published
      procedure TestTrunc;
      procedure TestRound;

  end;

implementation


{ TVector2fFunctionalTest }

procedure TVector2fFunctionalTest.TestTrunc;
begin
   vtt1.Create(5.69999,6.99998);
   vt2i :=  vtt1.Trunc;
   AssertEquals('Trunc:Sub1 X failed ', 5, vt2i.X);
   AssertEquals('Trunc:Sub2 Y failed ', 6, vt2i.Y);
   vtt1.Create(5.369999,6.39998);
   vt2i :=  vtt1.Trunc;
   AssertEquals('Trunc:Sub3 X failed ', 5, vt2i.X);
   AssertEquals('Trunc:Sub4 Y failed ', 6, vt2i.Y);
end;

procedure TVector2fFunctionalTest.TestRound;
begin
   vtt1.Create(5.699999,6.699999);
   vt2i :=  vtt1.Round;
   AssertEquals('Round:Sub1 X failed ', 6, vt2i.X);
   AssertEquals('Round:Sub2 Y failed ', 7, vt2i.Y);
   vtt1.Create(5.399999,6.399999);
   vt2i :=  vtt1.Round;
   AssertEquals('Round:Sub3 X failed ', 5, vt2i.X);
   AssertEquals('Round:Sub4 Y failed ', 6, vt2i.Y);
end;

initialization
  RegisterTest(REPORT_GROUP_VECTOR2F, TVector2fFunctionalTest);
end.

