unit uMainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  GLZTypes, GLZArrays, GLZVectorMath;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1 : TButton;
    GroupBox1 : TGroupBox;
    GroupBox2 : TGroupBox;
    GroupBox3 : TGroupBox;
    GroupBox4 : TGroupBox;
    Memo1 : TMemo;
    Memo2 : TMemo;
    Memo3 : TMemo;
    Memo4 : TMemo;
    procedure Button1Click(Sender : TObject);
  private

  public
    FByteList : TGLZByteList;
    FIntegerList : TGLZIntegerList;
    FSingle2DMap : TGLZSingle2DMap;
    FVectorList : TGLZVectorList;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.Button1Click(Sender : TObject);
Var
  rnd, i, j : Integer;
  xr,yr,zr,wr : Single;
  {$CODEALIGN VARMIN=16}
  V : TGLZVector;
  {$CODEALIGN VARMIN=4}
  s:string;
begin
  memo1.Lines.Clear;
  memo2.Lines.Clear;
  memo3.Lines.Clear;
  memo4.Lines.Clear;
  Randomize;

  FByteList := TGLZByteList.Create; // Create Empty list
  rnd := 10+Random(100)-10;
  FByteList.Count := Rnd; // Set how many item we wants
  For i:= 0 to FByteList.Count-1 do
  begin
    FByteList.Items[I]:=Random(255); // set item
  end;
  While Not(FByteList.IsEndOfArray) do
  begin
     memo1.Lines.Add('Item '+inttostr(FByteList.GetPosition)+' = '+InttoStr(FByteList.Next));
  end;

  rnd := 10+Random(100)-10;
  FIntegerList := TGLZIntegerList.Create(rnd);// Set the capacity
  For i:= 0 to rnd+10 do
  begin
    FIntegerList.Add(Random(MaxInt)); // Add Item and Set Count. Grow up the list if needed
  end;
  While Not(FIntegerList.IsEndOfArray) do
  begin
     memo2.Lines.Add('Item '+inttostr(FIntegerList.GetPosition)+' = '+InttoStr(FIntegerList.Next));
  end;

  rnd := 1+Random(10);
  FSingle2DMap := TGLZSingle2DMap.Create(rnd, rnd div 2); // Capacity remember here count is no set
  For i:= 0 to FSingle2DMap.RowCount-1 do
  begin
    For J:=0 to FSingle2DMap.ColCount-1 do
    begin
      FSingle2DMap.Items[j,i]:=0.1+Random*0.8;
    end;
  end;

  // Remember count can be <> capacity.
  // And In the current test we need setup item count manually
  Showmessage('Single 2D Size '+Inttostr(FSingle2DMap.RowCount)+', '+InttoStr(FSingle2DMap.ColCount));
  FSingle2DMap.Count := FSingle2DMap.RowCount * FSingle2DMap.ColCount;
  For i:= 0 to FSingle2DMap.RowCount-1 do
  begin
    FSingle2DMap.MoveTo(i,0);
    For J:=0 to FSingle2DMap.ColCount-1 do
    begin
      s:='Item Row : '+Inttostr(i);
      s:=s+' Col : '+Inttostr(j);
      s:=s+' = '+FloatToStr(FSingle2DMap.Next);
      memo3.Lines.Add(s);
    end;
  end;



  rnd := 10+Random(100)-10;

  FVectorList := TGLZVectorList.Create; //The capacity growup alone
  For i:= 0 to rnd-1 do
  begin
    xr := 1.0+(0.1+Random*0.8);
    yr := 2.0+(0.1+Random*0.8);
    zr := 3.0+(0.1+Random*0.8);
    wr := 4.0+(0.1+Random*0.8);
    V.Create(xr,yr,zr,wr);
    FVectorList.Add(V); //Add more capacity if needed and set item count
  end;
  While Not(FVectorList.IsEndOfArray) do
  begin
     // Iterator next in action
     memo4.Lines.Add('Item '+inttostr(FVectorList.GetPosition)+' = '+FVectorList.Next.ToString);
  end;

end;

end.

