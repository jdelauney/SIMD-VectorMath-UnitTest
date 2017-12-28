unit VectorOperatorsOnSelfTimingTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

type
  { TVectorOperatorsOnSelfTimingTest }
  TVectorOperatorsOnSelfTimingTest = class(TVectorBaseTimingTest)
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
    procedure TimepClampVector;
    procedure TimepClampSingle;
  end;

implementation

{%region%====[ TVectorOperatorsOnSelfTimingTest ]==============================}

procedure TVectorOperatorsOnSelfTimingTest.TimepAdd;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Add with Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pAdd(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.padd(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepSub;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Sub with Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pSub(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pSub(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepMul;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Multiply by Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pMul(natUnitVector); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pMul(asmUnitVector); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepDiv;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Divide by Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pDiv(natUnitVector); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pDiv(asmUnitVector); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepAddSingle;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Add with Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pAdd(0.0001); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.padd(0.0001); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepSubSingle;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Sub with Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pSub(0.0001); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pSub(0.0001); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepMulSingle;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Multiply by single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pMul(1.0); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pMul(1.0); end;
  GlobalProfiler[1].Stop;
end;

// note in operations on self use 1 to avoid overflow etc
procedure TVectorOperatorsOnSelfTimingTest.TimepDivSingle;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Divide by single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pDiv(1.0); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pDiv(1.0); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepInvert;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Invert';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pInvert; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pInvert; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepNegate;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Negate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pNegate; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pNegate; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepAbs;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Abs';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pAbs; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pAbs; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepNormalize;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Normalize';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pNormalize; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pNormalize; end;
  GlobalProfiler[1].Stop;
end;

//have to a bit more to stop overflows/underflows
procedure TVectorOperatorsOnSelfTimingTest.TimepDivideBy2;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Divideby2';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pAdd(1); nt1.DivideBy2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pAdd(1); vt1.DivideBy2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepCrossProduct;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self CrossProduct Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pCrossProduct(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pCrossProduct(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepMinVector;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Min Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pMin(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pMin(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepMinSingle;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Min Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pMin(r1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pMin(r1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepMaxVector;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Max Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pMax(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pMax(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepMaxSingle;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Max Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pMax(r1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pMax(r1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepClampVector;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Clamp Vector';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pClamp(nt2,nt1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pClamp(vt2,vt1); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorOperatorsOnSelfTimingTest.TimepClampSingle;
begin
  GlobalProfiler.Clear;
  TestDispName := 'Self Clamp Single';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to 20000000 do begin nt1.pClamp(fs2,fs1); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to 20000000 do begin vt1.pClamp(fs2,fs1); end;
  GlobalProfiler[1].Stop;
end;

{%endregion}

initialization

  RegisterTest(TVectorOperatorsOnSelfTimingTest);
end.

