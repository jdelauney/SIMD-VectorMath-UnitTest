unit VectorOnSelfTimingTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest,
  native, GLZVectorMath;

{$I config.inc}

type
  { TOperationOnSelfTimingTest }
  TVectorOnSelfTimingTest = class(TVectorBaseTimingTest)
  published
    procedure TimepAdd;
    procedure TimepSub;
    procedure TimepMul;
    procedure TimepDiv;
    procedure TimepAddSingle;
    procedure TimepSubSingle;
    procedure TimepMulSingle;
    procedure TimepDivSingle;
    procedure TimepInvert;
    procedure TimepNegate;
    procedure TimepAbs;
    procedure TimepNormalize;
    procedure TimepDivideBy2;
    procedure TimepCrossProduct;
    procedure TimepMinVector;
    procedure TimepMinSingle;
    procedure TimepMaxVector;
    procedure TimepMaxSingle;
  end;

implementation

{%region%====[ TVectorOnSelfTimingTest ]=======================================}

procedure TVectorOnSelfTimingTest.TimepAdd;
begin
  TestDispName := 'Self Add with Vector';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pAdd(nt2); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.padd(vt2); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepSub;
begin
  TestDispName := 'Self Sub with Vector';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pSub(nt2); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pSub(vt2); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepMul;
begin
  TestDispName := 'Self Multiply by Vector';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pMul(natUnitVector); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pMul(asmUnitVector); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepDiv;
begin
  TestDispName := 'Self Divide by Vector';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pDiv(natUnitVector); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pDiv(asmUnitVector); end;
  StopTimer;
  etAsm := elapsedTime;

end;

procedure TVectorOnSelfTimingTest.TimepAddSingle;
begin
  TestDispName := 'Self Add with Single';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pAdd(0.0001); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.padd(0.0001); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepSubSingle;
begin
  TestDispName := 'Self Sub with Single';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pSub(0.0001); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pSub(0.0001); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepMulSingle;
begin
  TestDispName := 'Self Multiply by single';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pMul(1.0); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pMul(1.0); end;
  StopTimer;
  etAsm := elapsedTime;
end;

// note in operations on self use 1 to avoid overflow etc
procedure TVectorOnSelfTimingTest.TimepDivSingle;
begin
  TestDispName := 'Self Divide by single';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pDiv(1.0); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pDiv(1.0); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepInvert;
begin
  TestDispName := 'Self Invert';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pInvert; end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pInvert; end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepNegate;
begin
  TestDispName := 'Self Negate';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pNegate; end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pNegate; end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepAbs;
begin
  TestDispName := 'Self Abs';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pAbs; end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pAbs; end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepNormalize;
begin
  TestDispName := 'Self Normalize';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pNormalize; end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pNormalize; end;
  StopTimer;
  etAsm := elapsedTime;
end;

//have to a bit more to stop overflows/underflows
procedure TVectorOnSelfTimingTest.TimepDivideBy2;
begin
  TestDispName := 'Self Divideby2';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pAdd(1); nt1.DivideBy2; end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pAdd(1); vt1.DivideBy2; end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepCrossProduct;
begin
  TestDispName := 'Self CrossProduct Vector';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pCrossProduct(nt2); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pCrossProduct(vt2); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepMinVector;
begin
  TestDispName := 'Self Min Vector';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pMin(nt2); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pMin(vt2); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepMinSingle;
begin
  TestDispName := 'Self Min Single';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pMin(r1); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pMin(r1); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepMaxVector;
begin
  TestDispName := 'Self Max Vector';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pMax(nt2); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pMax(vt2); end;
  StopTimer;
  etAsm := elapsedTime;
end;

procedure TVectorOnSelfTimingTest.TimepMaxSingle;
begin
  TestDispName := 'Self Max Single';
  StartTimer;
  for cnt := 1 to Iterations do begin nt1.pMax(r1); end;
  StopTimer;
  etNative := elapsedTime;
  StartTimer;
  For cnt:= 1 to Iterations do begin vt1.pMax(r1); end;
  StopTimer;
  etAsm := elapsedTime;
end;

{%endregion}

initialization

  RegisterTest(TVectorOnSelfTimingTest);


end.

