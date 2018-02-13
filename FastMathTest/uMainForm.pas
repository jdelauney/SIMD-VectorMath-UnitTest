unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids,
  GLZFastMath;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1 : TButton;
    Label1 : TLabel;
    StringGrid1 : TStringGrid;
    procedure Button1Click(Sender : TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender : TObject);
  private
    FTotalCos : Array[0..9] of Single;
    FTotalSin : Array[0..9] of Single;
    FMaxCosError : Array[0..9] of Single;
    FMaxSinError : Array[0..9] of Single;

    function getDiffError(a,b:Single):Single;

  public
    procedure DoTest;
  end;

var
  MainForm : TMainForm;
  //SinCosLUT : array[0..1] of array[0..35999] of single:

implementation

{$R *.lfm}

uses math;


function FastSin1 (fAngle:Double):Double; inline;
var
  fResult, fASqr : Double;
begin
    fASqr := fAngle*fAngle;
    fResult := -2.39e-08;
    fResult := fResult*fASqr;
    fResult := fResult+2.7526e-06;
    fResult := fResult*fASqr;
    fResult := fResult-1.98409e-04;
    fResult := fResult*fASqr;
    fResult := fResult+8.3333315e-03;
    fResult := fResult*fASqr;
    fResult := fResult-1.666666664e-01;
    fResult := fResult*fASqr;
    fResult := fResult+1.0;
    fResult := fResult*fAngle;
    result := fResult;
end;

function fastsin2(x:Double):Double;
var
  k:Integer;
  y,z : Double;
begin
  z := x;
  z := z * 0.3183098861837907;
  z := z + 6755399441055744.0;
  k := round(z);
  z := k;
  z := z*3.1415926535897932;
  x := x-z;
  y := x;
  y := y*x;
  z := 0.0073524681968701;
  z := z*y;
  z := z-0.1652891139701474;
  z := z*y;
  z := z+0.9996919862959676;
  x := x*z;
  k := k and 1;
  k := k+k;
  z := k;
  z := z*x;
  x := x-z;

  result := x;
end;

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  _InitSinLUT;
  with StringGrid1 do
  begin
    Cells[0,1]  :='System.Cos';
    Cells[0,2]  :='Math.SinCos (Cos)';
    Cells[0,3]  :='Taylor Cos';
    Cells[0,4]  :='Taylor Lambert Cos';
    Cells[0,5]  :='Quadratic Curve Cos LP';
    Cells[0,6]  :='Quadratic Curve Cos HP';
    Cells[0,7]  :='Remez Cos';
    Cells[0,8]  :='FastCos1';
    Cells[0,9]  :='FastCos2';
    Cells[0,10]  :='FastCosLUT';

    Cells[0,11]  :='System.Sin';
    Cells[0,12]  :='Math.SinCos (Sin)';
    Cells[0,13]  :='Taylor Sin';
    Cells[0,14]  :='Taylor Lambert Sin';
    Cells[0,15]  :='Quadratic Curve Sin LP';
    Cells[0,16]  :='Quadratic Curve Sin HP';
    Cells[0,17]  :='Remez Sin';
    Cells[0,18]  :='FastSin1';
    Cells[0,19]  :='FastSin2';
    Cells[0,20]  :='FastSinLUT';
  end;
end;

procedure TMainForm.Button1Click(Sender : TObject);
begin
  Screen.Cursor := crHourGlass;
  DoTest;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  _DoneSinLUT;
end;

function TMainForm.getDiffError(a, b : Single) : Single;
begin
  result :=abs(a-b);
end;


procedure TMainForm.DoTest;
Const
 _cPIdiv180: Single = 0.017453292;
var
  Cnt,i:integer;
  v,DiffError, s,c : Single;

begin
  cnt :=0;
  for i:=-180 to 180 do
  begin
    v:= _cPIdiv180 * i; //DegtoRad
    //----------------[ COSINUS ]-----------------------------------------------
    //System.Cos
    DiffError := getDiffError(System.Cos(v), System.Cos(v));
    FTotalCos[0] := FTotalCos[0] + DiffError;
    if FMaxCosError[0] < DiffError then FMaxCosError[0]:= DiffError;
    //Math.SinCos
    Math.SinCos(i,s,c);
    DiffError := getDiffError(c, c);
    FTotalCos[1] := FTotalCos[1] + DiffError;
    if FMaxCosError[1] < DiffError then FMaxCosError[1]:= DiffError;
    //TaylorCos
    DiffError := getDiffError(System.Cos(v), TaylorCos(v));
    FTotalCos[2] := FTotalCos[2] + DiffError;
    if FMaxCosError[2] < DiffError then FMaxCosError[2]:= DiffError;
    //TaylorLambertCos
    DiffError := getDiffError(System.Cos(v), TaylorLambertCos(v));
    FTotalCos[3] := FTotalCos[3] + DiffError;
    if FMaxCosError[3] < DiffError then FMaxCosError[3]:= DiffError;
    //Quadratic Curve Cos LP
    DiffError := getDiffError(System.Cos(v), QuadraticCurveCosLP(v));
    FTotalCos[4] := FTotalCos[4] + DiffError;
    if FMaxCosError[4] < DiffError then FMaxCosError[4]:= DiffError;
    //Quadratic Curve Cos HP
    DiffError := getDiffError(System.Cos(v), QuadraticCurveCosHP(v));
    FTotalCos[5] := FTotalCos[5] + DiffError;
    if FMaxCosError[5] < DiffError then FMaxCosError[5]:= DiffError;
    //Remez Cos
    DiffError := getDiffError(System.Cos(v), RemezCos(v));
    FTotalCos[6] := FTotalCos[6] + DiffError;
    if FMaxCosError[6] < DiffError then FMaxCosError[6]:= DiffError;

    FTotalCos[7] := 0;//FTotalCos[7] + DiffError;
    //if FMaxCosError[9] < DiffError then
    FMaxCosError[7]:= 0;//DiffError;

    FTotalCos[8] := 0;//FTotalCos[7] + DiffError;
    //if FMaxCosError[9] < DiffError then
    FMaxCosError[8]:= 0;//DiffError;

    DiffError := getDiffError(System.Cos(v), FastCosLUT(v));
    FTotalCos[9] := FTotalCos[9] + DiffError;
    if FMaxCosError[9] < DiffError then FMaxCosError[9]:= DiffError;
    //----------------[ SINUS ]-------------------------------------------------
    //System.Sin
    DiffError := getDiffError(System.Sin(v), System.Sin(v));
    FTotalSin[0] := FTotalSin[0] + DiffError;
    if FMaxSinError[0] < DiffError then FMaxSinError[0]:= DiffError;
    //Math.SinCos
    Math.SinCos(i,s,c);
    DiffError := getDiffError(s, s);
    FTotalCos[1] := FTotalSin[1] + DiffError;
    if FMaxSinError[1] < DiffError then FMaxSinError[1]:= DiffError;
    //TaylorSin
    DiffError := getDiffError(System.Sin(v), TaylorSin(v));
    FTotalSin[2] := FTotalSin[2] + DiffError;
    if FMaxSinError[2] < DiffError then FMaxSinError[2]:= DiffError;
    //TaylorLambertSin
    DiffError := getDiffError(System.Sin(v), TaylorLambertSin(v));
    FTotalSin[3] := FTotalSin[3] + DiffError;
    if FMaxSinError[3] < DiffError then FMaxSinError[3]:= DiffError;
    //Quadratic Curve Sin LP
    DiffError := getDiffError(System.Sin(v), QuadraticCurveSinLP(v));
    FTotalSin[4] := FTotalSin[4] + DiffError;
    if FMaxSinError[4] < DiffError then FMaxSinError[4]:= DiffError;
    //Quadratic Curve Sin HP
    DiffError :=getDiffError(System.Sin(v), QuadraticCurveSinHP(v));
    FTotalSin[5] := FTotalSin[5] + DiffError;
    if FMaxSinError[5] < DiffError then FMaxSinError[5]:= DiffError;
    //Remez Sin
    DiffError := getDiffError(System.Sin(v), RemezSin(v));
    FTotalSin[6] := FTotalSin[6] + DiffError;
    if FMaxSinError[6] < DiffError then FMaxSinError[6]:= DiffError;
    //FastSin1
    DiffError := getDiffError(System.Sin(v), FastSin1(v));
    FTotalSin[7] := FTotalSin[7] + DiffError;
    if FMaxSinError[7] < DiffError then FMaxSinError[7]:= DiffError;

    //FastSin2
    DiffError := getDiffError(System.Sin(v), FastSin2(v));
    FTotalSin[8] := FTotalSin[8] + DiffError;
    if FMaxSinError[8] < DiffError then FMaxSinError[8]:= DiffError;

    //FastSinLUT
    DiffError := getDiffError(System.Sin(v), FastSinLUT(v));
    FTotalSin[9] := FTotalSin[9] + DiffError;
    if FMaxSinError[9] < DiffError then FMaxSinError[9]:= DiffError;

    inc(cnt);
  end;
  for i:=1 to 10 do
  begin
    With StringGrid1 do
    begin
      Cells[1,i] := FloatToStr((FTotalCos[i-1]/cnt));
      Cells[2,i] := FloatToStr(FMaxCosError[i-1]);
      Cells[3,i] := 'n/a';
    End;
    With StringGrid1 do
    begin
      Cells[1,i+10] := FloatToStr((FTotalSin[i-1]/cnt));
      Cells[2,i+10] := FloatToStr(FMaxSinError[i-1]);
      Cells[3,i+10] := 'n/a';
    End;
  end;
end;

end.

