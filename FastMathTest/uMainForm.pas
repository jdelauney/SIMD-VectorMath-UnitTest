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
    procedure FormCreate(Sender : TObject);
  private
    FTotalCos : Array[0..6] of Single;
    FTotalSin : Array[0..6] of Single;
    FMaxCosError : Array[0..6] of Single;
    FMaxSinError : Array[0..6] of Single;

    function getDiffError(a,b:Single):Single;

  public
    procedure DoTest;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses math;

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  with StringGrid1 do
  begin
    Cells[0,1]  :='System.Cos';
    Cells[0,2]  :='Math.SinCos (Cos)';
    Cells[0,3]  :='Taylor Cos';
    Cells[0,4]  :='Taylor Lambert Cos';
    Cells[0,5]  :='Quadratic Curve Cos LP';
    Cells[0,6]  :='Quadratic Curve Cos HP';
    Cells[0,7]  :='Remez Cos';
    Cells[0,8]  :='System.Sin';
    Cells[0,9]  :='Math.SinCos (Sin)';
    Cells[0,10]  :='Taylor Sin';
    Cells[0,11]  :='Taylor Lambert Sin';
    Cells[0,12]  :='Quadratic Curve Sin LP';
    Cells[0,13]  :='Quadratic Curve Sin HP';
    Cells[0,14]  :='Remez Sin';
  end;
end;

procedure TMainForm.Button1Click(Sender : TObject);
begin
  Screen.Cursor := crHourGlass;
  DoTest;
  Screen.Cursor := crDefault;
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

    inc(cnt);
  end;
  for i:=1 to 7 do
  begin
    With StringGrid1 do
    begin
      Cells[1,i] := FloatToStr((FTotalCos[i-1]/cnt));
      Cells[2,i] := FloatToStr(FMaxCosError[i-1]);
      Cells[3,i] := 'n/a';
    End;
    With StringGrid1 do
    begin
      Cells[1,i+7] := FloatToStr((FTotalSin[i-1]/cnt));
      Cells[2,i+7] := FloatToStr(FMaxSinError[i-1]);
      Cells[3,i+7] := 'n/a';
    End;
  end;
end;

end.

