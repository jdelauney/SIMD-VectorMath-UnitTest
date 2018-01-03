unit VectorOtherTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit,  testregistry, BaseTestCase,
  native, GLZVectorMath;

type
  { TVectorOtherTestCase }
  TVectorOtherTestCase = class(TVectorBaseTestCase)
  published
    procedure TestCompare;       // these two test ensure we have data to play
    procedure TestCompareFalse;  // with and tests the compare function.
    procedure TestMinXYZComponent;
    procedure TestMaxXYZComponent;
    procedure TestShuffle;
    procedure TestSwizzle;
    procedure TestMinVector;
    procedure TestMaxVector;
    procedure TestMinSingle;
    procedure TestMaxSingle;
    procedure TestClampVector;
    procedure TestClampSingle;
    procedure TestLerp;
    procedure TestPerp;
    procedure TestReflect;
//      procedure TestMoveAround;
    procedure TestCombine;
    procedure TestCombine2;
    procedure TestCombine3;
  end;

implementation

{%region%====[ TVectorOtherTestCase ]==========================================}

procedure TVectorOtherTestCase.TestCompare;
begin
  AssertTrue('Test Values do not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt1));
end;

procedure TVectorOtherTestCase.TestCompareFalse;
begin
  AssertFalse('Test Values should not match : '+nt1.ToString+' --> '+vt1.ToString, Compare(nt1,vt2));
end;

procedure TVectorOtherTestCase.TestMinXYZComponent;
begin
  Fs1 := nt1.MinXYZComponent;
  Fs2 := vt1.MinXYZComponent;
  AssertTrue('Vector MinXYZComponents do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorOtherTestCase.TestMaxXYZComponent;
begin
  Fs1 := nt1.MaxXYZComponent;
  Fs2 := vt1.MaxXYZComponent;
  AssertTrue('Vector MaxXYZComponents do not match : '+FLoattostrF(fs1,fffixed,3,3)+' --> '+FLoattostrF(fs2,fffixed,3,3), IsEqual(Fs1,Fs2));
end;

procedure TVectorOtherTestCase.TestShuffle;
begin
  nt3 := nt1.Shuffle(1,2,3,0);
  vt3 := vt1.Shuffle(1,2,3,0);
  AssertTrue('Vector Shuffle no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestSwizzle;
begin
  nt3 := nt1.Swizzle(swWZYX);
  vt3 := vt1.Swizzle(swWZYX);
  AssertTrue('Vector Swizzle no match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestMinVector;
begin
  nt3 := nt1.Min(nt2);
  vt3 := vt1.Min(vt2);
  AssertTrue('Vector Min vectors do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestMaxVector;
begin
  nt3 := nt1.Max(nt2);
  vt3 := vt1.Max(vt2);
  AssertTrue('Vector Max vectors do not match'+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestMinSingle;
begin
  nt3 := nt1.Min(Fs1);
  vt3 := vt1.Min(Fs1);
  AssertTrue('Vector Min Singles do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestMaxSingle;
begin
  nt3 := nt1.Max(Fs1);
  vt3 := vt1.Max(Fs1);
  AssertTrue('Vector Max Singles do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestClampVector;
begin
  nt3 := nt1.Clamp(nt2,nt1);
  vt3 := vt1.Clamp(vt2,vt1);
  AssertTrue('Vector Clamp vectors do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));

end;

procedure TVectorOtherTestCase.TestClampSingle;
begin
  nt3 := nt1.Clamp(fs2,fs1);
  vt3 := vt1.Clamp(fs2,fs1);
  AssertTrue('Vector Clamp vectors do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestLerp;
begin
  nt3 := nt1.Lerp(nt1,0.8);
  vt3 := vt1.Lerp(vt1,0.8);
  AssertTrue('Vector Clamp vectors do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestPerp;
begin
  nt3 := nt1.Perpendicular(nt2);
  vt3 := vt1.Perpendicular(vt2);
  AssertTrue('Vector Perpendiculars do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3, 1e-4));
end;

procedure TVectorOtherTestCase.TestReflect;
begin
  nt3 := nt1.Reflect(nt2);
  vt3 := vt1.Reflect(vt2);
  AssertTrue('Vector Reflects do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3, 1e-4));
end;

procedure TVectorOtherTestCase.TestCombine;
begin
  nt3 := nt1.Combine(nt2, fs1);
  vt3 := vt1.Combine(vt2, fs1);
  AssertTrue('Vector Combines do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestCombine2;
begin
  nt3 := nt1.Combine2(nt2, fs1, fs2);
  vt3 := vt1.Combine2(vt2, fs1, fs2);
  AssertTrue('Vector Combine2s do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

procedure TVectorOtherTestCase.TestCombine3;
begin
  nt3 := nt1.Combine3(nt2, nt1, fs1, fs2, fs2);
  vt3 := vt1.Combine3(vt2, vt1, fs1, fs2, fs2);
  AssertTrue('Vector Combine3s do not match : '+nt3.ToString+' --> '+vt3.ToString, Compare(nt3,vt3));
end;

{
procedure TVectorOtherTestCase.TestMoveAround;
begin
  nt3 := nt1.m(nt2);
  vt3 := vt1.Reflect(vt2);
  AssertTrue('Vector Reflects do not match', Compare(nt3,vt3));

end;
}

{%endregion%}

initialization
  RegisterTest(REPORT_GROUP_VECTOR4F, TVectorOtherTestCase);
end.

