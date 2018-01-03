unit BaseTimingTest;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BaseTestCase, native, GLZVectorMath;

{$I config.inc}


type


  { TGroupTimingTest }
  TGroupTimingTest = class(TVectorBaseTestCase)
  public
    class var Group: TReportGroup;
    class function RGString: string;
  end;

  { TVectorBaseTimingTest }
  TVectorBaseTimingTest = class(TGroupTimingTest)
  protected
    procedure TearDown; override;
  public
    {$CODEALIGN RECORDMIN=4}
    var
    r1, rs : Single;
    Res: boolean;

    TestDispName: string;

    procedure StartTimer;
    procedure StopTimer;
    procedure InitLists;
  end;

procedure DoInitLists;

const
  asmUnitVector : TGLZVector4f = (X:1; Y:1; Z:1; W:1);
  natUnitVector : TNativeGLZVector4f = (X:1; Y:1; Z:1; W:1);

  asmTwoVector : TGLZVector4f = (X:2; Y:2; Z:2; W:2);
  natTwoVector : TNativeGLZVector4f = (X:2; Y:2; Z:2; W:2);

  asmHalfVector : TGLZVector4f = (X:0.5; Y:0.5; Z:0.5; W:0.5);
  natHalfVector : TNativeGLZVector4f = (X:0.5; Y:0.5; Z:0.5; W:0.5);

  Iterations : integer = 20000000;
  IterationsQuarter = 5000000;
  IterationsTenth = 2000000;

var
  StartTime, TotalTime, elapsedTime : double;
  etGain,
  etNativeMin, etAsmMin,
  etNativeMax, etAsmMax,
  etNativeAvg, etAsmAvg,
  etNative , etAsm : double;

  cnt: Integer;
  sl,ml,hl, fhl: TStringList;

  HeaderPos: integer;

implementation

uses strutils, GLZProfiler, GLZCpuId;

procedure DoInitLists;
var
  infoStr, featuresStr: string;
begin

  infoStr := Format('CPU Info: %s @ %d MHz', [Trim(GLZCPUInfos.BrandName), GLZCPUInfos.Speed]);
  featuresStr := 'CPU Features: ' + GLZCPUInfos.FeaturesAsString;
  sl := TStringList.Create;
  sl.Add(infoStr);
  sl.Add(featuresStr);
  sl.Add('Compiler Flags: ' + REP_FLAGS);
  sl.Add('Test,Native,Assembler,Gain in %,Speed factor');

  ml := TStringList.Create;
  ml.Add('| Compiler Flags | ' + REP_FLAGS + ' |'+#10);
  ml.Add('| -------------- | -------- |'+#10);
  ml.Add('');
  ml.Add('| Test                     | Total Ticks | Min Ticks | Max Ticks | Avg Ticks | Gain in % | Speed factor |'+#10);
  ml.Add('| ------------------------ | ----------- | --------- | --------- | --------- | --------- | ------------ |'+#10);

  hl := TStringList.Create;

  with hl do
  begin
    Add('<html>');
    Add('<head>');
    Add('<meta charset="utf-8">');
    Add('<title>FPC SSE/AVX Tests Case Result</title>');
    //Add('<link href="minimal-table.css" rel="stylesheet" type="text/css">');
    Add('<style>');
    Add('html {font-family: sans-serif;}');
    Add('table {border-collapse: collapse;border: 2px solid rgb(200,200,200);letter-spacing: 1px;font-size: 0.8rem;}');
    Add('td, th {border: 1px solid rgb(60,60,60);padding: 10px 20px;}');
    Add('th {background-color: rgb(205,205,205);}');
    Add('th.maincol {background-color: rgb(195,195,195);}');
    Add('td {text-align: center;}');
    Add('tr:nth-child(odd) td {background-color: rgb(245,245,245);}');
    Add('tr:nth-child(even) td {background-color: rgb(225,225,225);}');
    Add('caption {padding: 10px;}');
    Add('h1 {text-align: center;}');
    Add('h5 {text-align: center;}');
    Add('</style>');
    Add('</head>');
    Add('<div>');
    HeaderPos := Add('');
    Add('<h5>' + infoStr + '</h5>');
    Add('<h5>' + featuresStr + '</h5>');
    Add('<table>');
    Add('<caption><b>Compiler Flags: ' + REP_FLAGS + '</b></caption>');
    Add('<thead>');
    Add('<tr>');
    Add('  <th scope="col">Test Name</th>');
    Add('  <td colspan="1"></td>');
    Add('  <th scope="col">Total Time</th>');
    Add('  <th scope="col">Min Time</th>');
    Add('  <th scope="col">Max Time</th>');
    Add('  <th scope="col">Average Time</th>');
    Add('  <th scope="col">Gain in %</th>');
    Add('  <th scope="col">Speed Factor</th>');
    Add('</tr>');
    Add('<tbody>');
  end;

  //Add('<tr><td>Test</td><td>Total Ticks</td><td>Min Ticks</td><td>Max Ticks</td><td>Avg Ticks</td><td>Gain in %</td><td>Speed factor</td></tr>');

  fhl := TStringList.Create;
  fhl.Add('[table]');
  fhl.Add('[tr][td] | '+padright('Test',22)+'[/td][td] | '+padright('Total Ticks',16)+'[/td][td] | '+padright('Min Ticks',18)+'[/td][td] | '+padright('Max Ticks',18)+'[/td][td] | '+padright('Avg Ticks',18)+'[/td][td] | '+padright('Gain in %',17)+'[/td][td] | '+padright('Speed factor',14)+'[/td][/tr]');

end;

procedure CheckResultsDir;
var
  rg: TReportGroup;
begin
  If Not DirectoryExists('Results') then
    CreateDir ('Results');
  for rg := low(TReportGroup) to High(TReportGroup) do
    If Not DirectoryExists('Results' + DirectorySeparator + rgArray[rg]) then
      CreateDir ('Results' + DirectorySeparator + rgArray[rg]);
end;

function WriteTimer:String;
begin
  Result := FloatToStr(elapsedTime)+' seconds';
  TotalTime := TotalTime + elapsedTime;
End;

function WriteTime(et:double):String;
begin
  Result := FloatToStrF(et,ffFixed,5,6);
  TotalTime := TotalTime + et;
End;

function WritePct(et:double):String;
begin
  Result := FloatToStrF(et,ffFixed,5,3)+' %';
End;

function WriteTestName(aTest : String):String;
begin
  result := padRight(aTest,26-Length(aTest));
end;

function WriteSpeedFactor: string;
var
  sf : double;
begin
 // sf := etNative/etAsm;
  sf := GlobalProfiler.Items[0].TotalTicks/GlobalProfiler.Items[1].TotalTicks;
  result :=  FloatToStrF(sf,ffFixed,5,6);
end;

{%region%====[ TGroupTimingTest ]=====================================}

class function TGroupTimingTest.RGString: string;
begin
  Result := rgArray[Group];
end;
{%region%}

{%region%====[ TVectorBaseTimingTest etc ]=====================================}

procedure TVectorBaseTimingTest.StartTimer;
begin
  StartTime := 0;
  StartTime := now;
End;

procedure TVectorBaseTimingTest.StopTimer;
begin
  elapsedTime := 0;
  elapsedTime :=(Now() - StartTime) *24 * 60 * 60;
End;

procedure TVectorBaseTimingTest.InitLists;
begin
  DoInitLists;
end;

procedure TVectorBaseTimingTest.TearDown;
begin
  //etGain := 100-((100*etAsm)/etNative);
  etGain := 100 - ((100*GlobalProfiler.Items[1].TotalTicks)/GlobalProfiler.Items[0].TotalTicks);
  inherited TearDown;
  Sl.Add(WriteTestName(TestDispName) + ', ' + WriteTime(etNative) + ', ' + WriteTime(etAsm)+', '+WritePct(etGain)+', '+WriteSpeedFactor);
  ml.Add( '| ' + WriteTestName(TestDispName) + ' | ' + WriteTime(etNative)  + ' | ' +  WriteTime(etAsm) + ' | ' +  WritePct(etGain) + ' | '+ WriteSpeedFactor+#10);
  //hl.Add('<tr><td>' + WriteTestName(TestDispName) + '</td><td>' + WriteTime(etNative)  + '</td><td>' +  WriteTime(etAsm) + '</td><td>' +  WritePct(etGain) + '</td><td>' + WriteSpeedFactor + '</td></tr>');

  with hl do
  begin
    Add('<tr>');
    Add('<th class="maincol" rowspan="2" scope="rowgroup">'+WriteTestName(TestDispName)+'</th>');
    Add('  <th scope="row">Native</th>');
    Add('  <td>' +  GlobalProfiler.Items[0].TotalTicksAsString + '</td>');
    Add('  <td>' +  GlobalProfiler.Items[0].MinTicksAsString + '</td>');
    Add('  <td>' +  GlobalProfiler.Items[0].MaxTicksAsString + '</td>');
    Add('  <td>' +  floattostrF( GlobalProfiler.Items[0].TotalTicks/Iterations,ffGeneral,15,3)+ '</td>');
    //GlobalProfiler.Items[0].AvgTicksAsString + '</td>');
    Add('</tr>');
    Add('<tr>');
    Add('  <th scope="row">Assembler</th>');
    Add('  <td>' +  GlobalProfiler.Items[1].TotalTicksAsString + '</td>');
    Add('  <td>' +  GlobalProfiler.Items[1].MinTicksAsString + '</td>');
    Add('  <td>' +  GlobalProfiler.Items[1].MaxTicksAsString + '</td>');
   // Add('  <td>' +  GlobalProfiler.Items[1].AvgTicksAsString + '</td>');
    Add('  <td>' +  floattostrF( GlobalProfiler.Items[1].TotalTicks/Iterations,ffGeneral,15,3)+ ' ms</td>');
    Add('  <td>' +  WritePct(etGain) + '</td><td>' +  WriteSpeedFactor + '</td>');
    Add('</tr>');
  end;

(*  hl.Add('<tr><td> | ' + WriteTestName(TestDispName) + '</td><td></td><td></td><td></td><td></td><td></td></tr>');
  hl.add('<tr><td> | Native   </td><td> | ' +  GlobalProfiler.Items[0].TotalTicksAsString + '</td>'+
                                  '<td> | ' +  GlobalProfiler.Items[0].MinTicksAsString + '</td>'+
                                  '<td> | ' +  GlobalProfiler.Items[0].MaxTicksAsString + '</td>'+
                                  '<td> | ' +  GlobalProfiler.Items[0].AvgTicksAsString + '</td>'+
                                  '<td> |  </td><td> | </td></tr>');
  hl.add('<tr><td> | Assembler</td><td> | ' +  GlobalProfiler.Items[1].TotalTicksAsString + '</td>'+
                                  '<td> | ' +  GlobalProfiler.Items[1].MinTicksAsString + '</td>'+
                                  '<td> | ' +  GlobalProfiler.Items[1].MaxTicksAsString + '</td>'+
                                  '<td> | ' +  GlobalProfiler.Items[1].AvgTicksAsString + '</td>'+
                                  '<td> | ' +  WritePct(etGain) + '</td><td> | ' +  WriteSpeedFactor + '</td></tr>'); *)

  fhl.Add('[tr][td] | ' + WriteTestName(TestDispName) + '[/td][td][/td][td][/td][td][/td][td][/td][td][/td][/tr]');
  fhl.add('[tr][td] |         Native[/td][td] | ' +  GlobalProfiler.Items[0].TotalTicksAsString + '[/td]'+
                                   '[td] | ' +  GlobalProfiler.Items[0].MinTicksAsString + '[/td]'+
                                   '[td] | ' +  GlobalProfiler.Items[0].MaxTicksAsString + '[/td]'+
                                   '[td] | ' +  GlobalProfiler.Items[0].AvgTicksAsString + '[/td]'+
                                   '[td] |  [/td][td] | [/td][/tr]');
  fhl.add('[tr][td] |      Assembler[/td][td] | ' +  GlobalProfiler.Items[1].TotalTicksAsString + '[/td]'+
                                   '[td] | ' +  GlobalProfiler.Items[1].MinTicksAsString + '[/td]'+
                                   '[td] | ' +  GlobalProfiler.Items[1].MaxTicksAsString + '[/td]'+
                                   '[td] | ' +  GlobalProfiler.Items[1].AvgTicksAsString + '[/td]'+
                                   '[td] | ' +  WritePct(etGain) + '[/td][td] | ' +  WriteSpeedFactor + '[/td][/tr]');
end;

{%endregion%}

initialization
  DoInitLists;
  CheckResultsDir;
Finalization
  sl.Free;
  hl.Free;
  ml.Free;
  fhl.Free;
end.

end.

