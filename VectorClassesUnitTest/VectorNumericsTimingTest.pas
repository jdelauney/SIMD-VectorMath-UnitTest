unit VectorNumericsTimingTest;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest,
  native, GLZVectorMath, GLZProfiler;

type

  { VectorNumericsTimingTest }

  { TVectorNumericsTimingTest }

  TVectorNumericsTimingTest = class(TVectorBaseTimingTest)
  published
    procedure TimeAbs;
    procedure TimeNegate;
    procedure TimeDivideBy2;
    procedure TimeDistance;
    procedure TimeDistanceSquare;
    procedure TimeLength;
    procedure TimeLengthSquare;
    procedure TimeSpacing;
    procedure TimeDotProduct;
    procedure TimeCrossProduct;
    procedure TimeNormalize;
    procedure TimeNorm;
    procedure TimeMulAdd;
    procedure TimeMulDiv;
    procedure TimeAngleCosine;
    procedure TimeAngleBetween;
  end;

implementation

{%region%====[ TVectorNumericsTimingTest ]=====================================}

procedure TVectorNumericsTimingTest.TimeAbs;
begin
  TestDispName := 'Vector Op Abs';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Abs; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3 := vt1.Abs; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeNegate;
begin
  TestDispName := 'Vector Op Negate';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Negate; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3 := vt1.Negate; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeDivideBy2;
begin
  TestDispName := 'Vector Op DivideBy2';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.DivideBy2; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3 := vt1.DivideBy2; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeDistance;
begin
  TestDispName := 'Vector Op Distance';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin rs := nt1.Distance(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin rs := vt1.Distance(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeDistanceSquare;
begin
  TestDispName := 'Vector Op DistanceSquare';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin rs := nt1.DistanceSquare(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin rs := vt1.DistanceSquare(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeLength;
begin
  TestDispName := 'Vector Op Length';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin rs := nt1.Length; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin rs := vt1.Length; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeLengthSquare;
begin
  TestDispName := 'Vector Op LengthSquare';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin rs := nt1.LengthSquare; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin rs := vt1.LengthSquare; end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeSpacing;
begin
  TestDispName := 'Vector Op Spacing';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin rs := nt1.Spacing(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin rs := vt1.Spacing(vt2);  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeDotProduct;
begin
  TestDispName := 'Vector Op DotProduct';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin rs := nt1.DotProduct(nt2); end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin rs := vt1.DotProduct(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeCrossProduct;
begin
  TestDispName := 'Vector Op CrossProduct';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.CrossProduct(nt2);   end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3 := vt1.CrossProduct(vt2); end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeNormalize;
begin
  TestDispName := 'Vector Op Normalize';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.Normalize; end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3 := vt1.Normalize;  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeNorm;
begin
  TestDispName := 'Vector Op Norm';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin rs := nt1.Norm;  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin rs := vt1.Norm;  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeMulAdd;
begin
  TestDispName := 'Vector Op MulAdd';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.MulAdd(nt2, nt1);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3 := vt1.MulAdd(vt2, vt1);  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeMulDiv;
begin
  TestDispName := 'Vector Op MulDiv';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin nt3 := nt1.MulDiv(nt2, nt1);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin vt3 := vt1.MulDiv(vt2, vt1);  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeAngleCosine;
begin
  TestDispName := 'Vector Op AngleCosine';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin rs := nt1.AngleCosine(nt2);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin rs := vt1.AngleCosine(vt2);  end;
  GlobalProfiler[1].Stop;
end;

procedure TVectorNumericsTimingTest.TimeAngleBetween;
begin
  TestDispName := 'Vector Op AngleBetween';
  GlobalProfiler[0].Clear;
  GlobalProfiler[0].Start;
  for cnt := 1 to Iterations do begin rs := nt1.AngleBetween(nt2, norg);  end;
  GlobalProfiler[0].Stop;
  GlobalProfiler[1].Clear;
  GlobalProfiler[1].Start;
  For cnt:= 1 to Iterations do begin rs := vt1.AngleBetween(vt2, vorg);  end;
  GlobalProfiler[1].Stop;
end;

{%endregion%}

initialization
  RegisterTest(TVectorNumericsTimingTest);
end.




