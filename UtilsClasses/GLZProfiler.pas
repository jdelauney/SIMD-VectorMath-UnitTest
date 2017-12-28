//==============================================================================
// GLZProfiler.pas
//------------------------------------------------------------------------------
// Historique :
// 04/12/16 - BeanzMaster - Creation
//------------------------------------------------------------------------------
// Description :
// Composant servant à effectuer des tests de performances de vos procedures ou
// fonctions dans vos programmes
//
//
// cf :
//   - Source\BZStopWatch.pas
//   - Demos\Profiler\Basic
//   - Demos\Profiler\Extend
//------------------------------------------------------------------------------
// Credits :
//
//------------------------------------------------------------------------------
// Todo :
//
//------------------------------------------------------------------------------
//==============================================================================
unit GLZProfiler;
//==============================================================================

{.$i ..\glzscene_options.inc}

//==============================================================================

interface

uses
  Classes, SysUtils, Laz2_DOM, Laz2_XMLWrite, Laz2_XMLRead,
  GLZTypes, GLZCpuID, GLZSystem,
  GLZStopWatch;

//==============================================================================
const
  MaxProfilerItems = 500;

//==============================================================================
type
  TGLZProfiler = class;

//===[ TGLZPROFILERITEM ]========================================================
type
  TGLZProfilerItem = class
  private
    FProfiler : TGLZProfiler;
    FMinTicks,
    FMaxTicks,
    FStartTicks,
    FLastTicks,
    FTotalTicks,
    FAvgTicks: int64;

    FMinFPS, FMaxFPS, FAvgFPS, FTotalFPS : Single;


    FCount: Integer;
    FFPSMode:Boolean;

    function getAvgTicks : int64;
    function getFPS(Const Value:Int64):single;
   public
    Name: string;
    constructor Create(AOwner: TGLZProfiler);

    function AsString: string;
    function MinTicksAsString:String;
    function MaxTicksAsString:String;
    function AvgTicksAsString:String;
    function TotalTicksAsString: string;

    procedure Clear;
    procedure Start;
    procedure Stop;

    property FPSMode:Boolean read FFPSMode Write FFPSMode;
    property Count: integer read FCount Write FCount;

    property TotalTicks : Int64 read FTotalTicks write FTotalTicks;
    property AvgTicks: Int64 read GetAvgTicks;// write FAvgTicks;
    property LastTicks: Int64 read FLastTicks write FLastTicks;
    property MaxTicks: Int64 read FMaxTicks write FMaxTicks;
    property MinTicks: Int64 read FMinTicks write FMinTicks;

    property AvgFPS:  Single read FAvgFPS write FAvgFPS;// write FAvgTicks;
    property TotalFPS:  Single read FTotalFPS write FTotalFPS;
    property MaxFPS:  Single read FMaxFPS write FMaxFPS;
    property MinFPS:  Single read FMinFPS write FMinFPS;
  end;

type
  TGLZProfilerSystemInformations = record
    CPU_Signature : Integer;
    CPU_Vendor : String;
    CPU_BrandName:String;
    CPU_Speed:Integer;
    CPU_LogicalProcessors:Integer;
    OS_NAME : String;
    OS_Device:String;
  end;

//===[ TGLZPROFILER ]============================================================
Type
  TGLZProfiler = class(TComponent)
  private
    FStopWatch : TGLZStopWatch;
    FList: TList;

    XMLDoc: TXMLDocument;
    Node: TDomNode;
    FFileName:String;

    function GetItem(index: integer): TGLZProfilerItem;

  protected
    FStartStopConstant: Int64;
    function TicksToStr(const Value: Int64): string;
    function TicksToFPSStr(const Value: Int64): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;override;

    function Add(Const AName:string=''): integer;
    procedure Clear;
    function Count: integer;
    procedure Delete(const Index: integer);
    function IndexOfName(const Value: string): integer;

    procedure SaveToFile(Filename:String;const overwrite:boolean=true);
    function  LoadFromFile(Filename:String):TGLZProfilerSystemInformations;



    property StopWatch : TGLZStopWatch read FStopWatch;
    property Items[index: integer]: TGLZProfilerItem read GetItem; default;
  end;

//==============================================================================
var
  GlobalProfiler : TGLZProfiler;

//==============================================================================

implementation

uses StrUtils,  LConvEncoding, GLZUtils;
//==============================================================================


//===[ TGLZPROFILERITEM ]========================================================

//------------------------------------------------------------------------------
// Creation de TGLZProfilerItem
//------------------------------------------------------------------------------
constructor TGLZProfilerItem.Create(AOwner: TGLZProfiler);
begin
  FProfiler := AOwner;
  FFPSMode:=False;
  MinTicks := High(Int64);
  MaxTicks := 0;
  TotalTicks := 0;
  LastTicks := 0;
  FAvgTicks := 0;
  Count := 0;
  Name:='';
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
function TGLZProfilerItem.GetAvgTicks: Int64;
begin
  if FCount>0 then
  begin
    result:= FTotalTicks div FCount
  end
  else Result:= 0;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
function TGLZProfilerItem.GetFPS(const Value: Int64):single;
Var
  secPerTick : double;
begin
  secPerTick:=1.0/FProfiler.StopWatch.Frequency;
  if Value>0 then
  begin
    result:=  FCount / (Value*secPerTick);
  end
  else Result:= 0;
end;



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
procedure TGLZProfilerItem.Clear;
begin
  FMinTicks := High(Int64);
  FMaxTicks := 0;
  FTotalTicks := 0;
  FLastTicks := 0;
  FAvgTicks := 0;
  FCount := 0;
  FMinFPS:=FMinTicks;
  FMaxFPS:=0;
  FAvgFPS:=0;
  FTotalFPS:=0;
 // Name:='';
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------

function TGLZProfilerItem.TotalTicksAsString: string;
begin
  //FloatToStrF(getFPS(FTotalTicks), ffFixed, 15, 2)+' fps'
  if FFPSMode then Result := Format('%s',[FProfiler.TicksToStr(FTotalTicks)])  //inttostr(FCount)+' frames'
  else
    Result := Format('%s',[FProfiler.TicksToStr(FTotalTicks)]);
end;

function TGLZProfilerItem.MinTicksAsString: string;
begin
  if FFPSMode then
  begin
    if FMinTicks = High(Int64) then result:='0 fps'
    else Result := FloatToStrF(FMinFPS, ffFixed, 15, 2)+' fps';
    //Format('%s',[FProfiler.TicksToFPSStr(FMinTicks)]);
  end
  else
  begin
    if FMinTicks = High(Int64) then result:='0.00 ms'
    else Result := Format('%s',[FProfiler.TicksToStr(FMinTicks)]);
  end;
end;

function TGLZProfilerItem.MaxTicksAsString: string;
begin
  if FFPSMode then Result := FloatToStrF(FMaxFPS, ffFixed, 15, 2)+' fps'
  //Format('%s',[FProfiler.TicksToFPSStr(FMaxTicks)])
  else Result := Format('%s',[FProfiler.TicksToStr(FMaxTicks)]);
end;

function TGLZProfilerItem.AvgTicksAsString: string;
begin
  if FFPSMode then
  begin
    if FCount>0 then result:=FloatToStrF(FAvgFPS, ffFixed, 15, 2)+' fps'
    //Format('%s',[FProfiler.TicksToFPSStr(GetAvgTicks)])
    else result:='0 fps';
  end
  else
  begin
    if FCount>0 then Result := Format('%s',[FProfiler.TicksToStr(GetAvgTicks)])
    else result:='0.00 ms';
  end;


end;

function TGLZProfilerItem.AsString: string;
var
  s: string;
begin
  s:='';
  if not(FFPSMode) then
  begin

    if Name<>'' then s :=s+Name+': ';
    Result := Format('%sCount=%d Min=%s Max=%s Avg=%s Last=%s',
                     [s,Count,
                      FProfiler.TicksToStr(MinTicks),
                      FProfiler.TicksToStr(MaxTicks),
                      FProfiler.TicksToStr(AvgTicks),
                      FProfiler.TicksToStr(LastTicks) ]);

  end
  else
  begin
     if Name<>'' then s :=s+Name+': ';
     Result := Format('%sCount=%d Min=%d FPS Max=%d FPS Avg=%d FPS Last=%d FPS',
                     [s,Count,
                      MinTicks,
                      MaxTicks,
                      AvgTicks,
                      LastTicks ]);
  end;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
procedure TGLZProfilerItem.Start;
begin
  if not(FFPSMode) then
  begin
    if (FCount=0) then clear;
    FProfiler.StopWatch.Start(true);
    FStartTicks := FProfiler.StopWatch.PerformanceCountStart;
  end
  else
  begin
    if (FCount=0) then
    begin
      Clear;
      FProfiler.StopWatch.Start(false);
      FStartTicks := FProfiler.StopWatch.PerformanceCountStart;
    end;
    //else inc(FCount);
  end;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
procedure TGLZProfilerItem.Stop;
var
  StopTick : Int64;
  LastFPS:Single;
  //secPerTick : double;
begin
  //secPerTick:=1.0/FProfiler.StopWatch.Frequency;

  if not(FFPSMode) then
  begin
    FProfiler.StopWatch.Stop;
    StopTick:=FProfiler.StopWatch.PerformanceCountStop;
    FLastTicks := StopTick - FStartTicks - FProfiler.FStartStopConstant;
    if FLastTicks<0 then FLastTicks := 0;
    if FLastTicks<FMinTicks then FMinTicks := FLastTicks;
    if FLastTicks>FMaxTicks then FMaxTicks := FLastTicks;
    Inc(FTotalTicks, FLastTicks);
    Inc(FCount);
  end
  else
  begin
    //StopTick :=FProfiler.StopWatch.PerformanceCountStart; //round(FProfiler.StopWatch.getFPS(FCount));
    StopTick := 0;
    QueryPerformanceCounter(StopTick);
    FLastTicks := StopTick - FStartTicks - FProfiler.FStartStopConstant;
    //FLastTicks := StopTick;
    if FLastTicks<0 then FLastTicks := 0;
    LastFPS:=getFPS(FLastTicks);
   // if FLastTicks>0 then
   // begin
      if FLastTicks<FMinTicks then FMinTicks := FLastTicks;
      if FLastTicks>FMaxTicks then FMaxTicks := FLastTicks;
      if LastFPS>0 then
      begin
        if LastFPS<FMinFPS then FMinFPS := LastFPS;
        if LastFPS>FMaxFPS then FMaxFPS := LastFPS;
        FTotalFPS:=FTotalFPS+LastFPS;
      end;

    //end;

    Inc(FTotalTicks, FLastTicks);
    FAvgFPS:=FTotalFPS / FCount;//FCount / (FTotalTicks*secPerTick);
    Inc(FCount);
  end;
end;

//==============================================================================

//===[ TGLZPROFILER ]============================================================

//------------------------------------------------------------------------------
// Creation de TGLZProfiler
//------------------------------------------------------------------------------
constructor TGLZProfiler.Create(AOwner: TComponent);
begin
  inherited;
  FList := TList.Create;
  FStopWatch:=TGLZStopWatch.Create(nil);
  //Add('EntryPoint');
  FStopWatch.Start;
  FStopWatch.Stop;
  FStartStopConstant := Round(FStopWatch.getTimerLap);//Items[0].FLastTicks;
  Clear;
end;

//------------------------------------------------------------------------------
// Destruction de TGLZProfiler
//------------------------------------------------------------------------------
destructor TGLZProfiler.Destroy;
begin
  Clear;
  FList.Free;
  FList:=nil;
  FStopWatch.Free;
  FStopWatch:=nil;
  XMLDoc.Free;
  inherited Destroy;
end;

function TGLZProfiler.TicksToStr(const Value: Int64): string;
begin
  //Result := FloatToStrF(Value*(1000.0/FStopWatch.Frequency), fffixed,15,2)+ ' ms';
 Result := FStopWatch.TickToMicroSecond(Value);
end;

function TGLZProfiler.TicksToFPSStr(const Value: Int64): string;
begin
  Result :=inttostr(Value)+' fps';
  //FloatToStrF(Value, fffixed,15,2)+ ' fps';
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
function TGLZProfiler.Add(Const AName:string=''): integer;
var
  p: TGLZProfilerItem;
  c:integer;
begin
  p := TGLZProfilerItem.Create(Self);
  if (AName<>'') then
  begin
    p.Name:=AName;
    Result := FList.Add(p);
  end
  else
  begin
    c := FList.Add(p);
    TGLZProfilerItem(FList[c]).Name:='Profiler '+Inttostr(c);
    result:=c;
  end;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
function TGLZProfiler.GetItem(index: integer): TGLZProfilerItem;
begin
  if Index<0 then Result := nil
   else
  if Index<FList.Count then Result := TGLZProfilerItem(FList.Items[Index])
   else
  if Index<MaxProfilerItems then begin
    While Add<Index do ;
    Result := TGLZProfilerItem(FList.Items[Index]);
  end else Result := nil;
end;


function TGLZProfiler.LoadFromFile(Filename:String):TGLZProfilerSystemInformations;
var
  index:integer;
  NodeList: TDomNodeList;
  Attributes: TDOMNamedNodeMap;
  SysInfos : TGLZProfilerSystemInformations;
begin
  FFileName:=filename;
  if FileExists(FFilename) then
  begin
    ReadXMLFile(XMLDoc, FFilename);
    try
      Node := XMLDoc.FindNode('profile');

      Node:=Node.FindNode('CPU');
      Attributes:=Node.Attributes;
      With SysInfos do
      begin
        CPU_Signature := strToInt(String(Attributes.GetNamedItem('Signature').NodeValue));
        CPU_Vendor:=String(Attributes.GetNamedItem('Vendor').NodeValue);
        CPU_BrandName:=String(Attributes.GetNamedItem('Brand').NodeValue);
        CPU_LogicalProcessors := strToInt(String(Attributes.GetNamedItem('LogicalProcessors').NodeValue));
        CPU_Speed:=strToInt(String(Attributes.GetNamedItem('Speed').NodeValue));
      end;
      Node:=Node.FindNode('OS');
      Attributes:=Node.Attributes;
      With SysInfos do
      begin
        OS_Name:= String(Attributes.GetNamedItem('Name').NodeValue);
        OS_Device:=String(Attributes.GetNamedItem('Device').NodeValue);
      end;

      Node := Node.FindNode('traces');

      NodeList := Node.GetChildNodes;

      for Index := 0 to NodeList.Count -1 do
      begin
        Attributes := NodeList[Index].Attributes;
        if Index<MaxProfilerItems then
        begin
          While Add<Index do ;
          with TGLZProfilerItem(FList[Index]) do
          begin
            Name:=String(Attributes.GetNamedItem('Name').NodeValue);
            Count:= strtoint(String(Attributes.GetNamedItem('Count').NodeValue));
            if Attributes.GetNamedItem('FPSMode').NodeValue = 'True' then
              FPSMode:=true
            else
              FPSMode:=false;
            MinTicks:=strToInt64(String(Attributes.GetNamedItem('MinTicks').NodeValue));
            MaxTicks:=strToInt64(String(Attributes.GetNamedItem('MaxTicks').NodeValue));
            TotalTicks:=strToInt64(String(Attributes.GetNamedItem('TotalTicks').NodeValue));
            LastTicks:=strToInt64(String(Attributes.GetNamedItem('LastTicks').NodeValue));

          end;
        end;
      end;
      result:=SysInfos;
    finally

    end;
  end
  else
  begin
    if not Assigned(XMLDoc) then
    begin
      XMLDoc := TXMLDocument.Create;
      XMLDoc.AppendChild(XMLDoc.CreateElement('profile'));
    end;
    Node := XMLDoc.FindNode('profile');
  end;

end;

procedure TGLZProfiler.SaveToFile(Filename:String;const overwrite:boolean=true);
var
  Element: TDomElement;
  index:integer;
  CPUInfos : TGLZCPUInfos;
begin
  if FFileName<>FileName then FFileName:=FileName;

  if FileExists(FileName) then
    if (not overwrite) then ReadXMLFile(XMLDoc, FileName)
  else DeleteFile(FileName);


    if not Assigned(XMLDoc) then
    begin
      XMLDoc := TXMLDocument.Create;
      XMLDoc.AppendChild(XMLDoc.CreateElement('profile'));
    end;
    if not(FileExists(FileName)) then
    begin
        Node := XMLDoc.FindNode('profile');
        //Node.AppendChild(XMLDoc.CreateElement('informations'));
        //Node := XMLDoc.FindNode('informations');
        Element := XMLDoc.CreateElement('CPU');
        CPUInfos:=GLZCPUInfos;
        with Element do
        begin
          AttribStrings['Signature'] := IntToStr(CPUInfos.Signature);
          AttribStrings['Vendor'] := CPUInfos.Vendor;
          AttribStrings['Brand'] := CPUInfos.BrandName;
          AttribStrings['LogicalProcessors'] := IntToStr(CPUInfos.LogicalProcessors);
          AttribStrings['Speed'] := IntToStr(CPUInfos.Speed);
        end;
        Node.AppendChild(Element);

        //Node := XMLDoc.FindNode('informations');
        Element := XMLDoc.CreateElement('OS');
        with Element do
        begin
          AttribStrings['Name'] := GetPlatformVersionAsString;
          AttribStrings['Device'] := ReplaceStr(GetDeviceCapabilitiesAsString,#13#10,' - ');
        end;
        Node.AppendChild(Element);
   //   end;
    end;

  Node := XMLDoc.FindNode('profile');

  //create the tracelog element
  if not(FileExists(FileName)) then  Node.AppendChild(XMLDoc.CreateElement('traces'));
  Node := Node.FindNode('traces');
  For Index:=0 to FList.Count-1 do
  begin
    Element := XMLDoc.CreateElement('trace');
    with Element do
    begin
      AttribStrings['Name'] := Items[Index].Name;
      AttribStrings['MinTicks'] := IntToStr(Items[Index].MinTicks);
      AttribStrings['MaxTicks'] := IntToStr(Items[Index].MaxTicks);
      AttribStrings['TotalTicks'] := IntToStr(Items[Index].TotalTicks);
      AttribStrings['LastTicks'] := IntToStr(Items[Index].LastTicks);
      AttribStrings['Count'] := (Inttostr(Items[Index].Count));
      AttribStrings['FPSMode'] := bool2StrFR[Items[Index].FPSMode];
    end;
    Node.AppendChild(Element);
  end;
  WriteXMLFile(XMLDoc, FFilename);
end;



//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
procedure TGLZProfiler.Clear;
begin
  While Count>0 do Delete(0);
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
function TGLZProfiler.Count: integer;
begin
  Result := FList.Count;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
procedure TGLZProfiler.Delete(const Index: integer);
begin
  if (Index>=0) and (Index<FList.Count) then begin
    TGLZProfilerItem(FList.Items[Index]).Free;
    FList.Delete(Index);
  end;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------
function TGLZProfiler.IndexOfName(const Value: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i:=Count-1 downto 0 do
    if AnsiCompareText(Value, Items[i].Name)=0 then begin
      Result := i;
      Break;
    end;
end;

//==============================================================================
//==============================================================================

initialization

  GlobalProfiler := TGLZProfiler.Create(nil);

//------------------------------------------------------------------------------
finalization
  GlobalProfiler.Free;

//==============================================================================
end.

