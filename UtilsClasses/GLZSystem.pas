(*====< GLZSystem.pas >=========================================================@br
  @created(2018-11-16)
  @author(J.Delauney (BeanzMaster))
  Historique : @br
  @unorderedList(
    @item(18/11/2016 : Creation  )
  )
--------------------------------------------------------------------------------@br

 @bold(Description :)@br
  L'unité GLZSystem regroupe quelques routines pour la detection de l'os et autres
  informations sur le systeme en général. Plus de quelques fonctions utiles pour
  une application. (dossier de l'application, dossier temporaire etc...)

  ------------------------------------------------------------------------------@br

   Notes : @br
  ------------------------------------------------------------------------------@br

    Credits :
     @unorderedList(
       @item(GLScene)
     )

  ------------------------------------------------------------------------------@br
  LICENCE : MPL / GPL @br
  @br
 *==============================================================================*)
unit GLZSystem;

//==============================================================================

{.$i ..\glzscene_options.inc}

//==============================================================================
interface

uses
  {$IFDEF FPC}
  //  LCLVersion,
     LCLIntf, LCLType,
    {$IFDEF Windows}
      Windows,
    {$ENDIF}
    {$IFDEF UNIX}
      //BaseUnix, UnixUtil, 
      Unix,
      {$IFDEF X11_SUPPORT}
        xlib,
      {$ENDIF}
    {$ENDIF}
  {$ELSE}
    Windows,
  {$ENDIF}
    Classes, SysUtils, types, LazUtf8, lazfileutils, DateUtils;

//==============================================================================

Type
  { TPlatformInfo : Information sur le system d'exploitation }
  TPlatformInfo = record
    Major: DWORD;
    Minor: DWORD;
    Revision: DWORD;
    Version: string;
    PlatformId   :DWORD;
    ID: string;
    CodeName: string;
    Description: string;
    ProductBuildVersion: string;
  end;

Type
  { TPlatformInfo : Type et Version du systeme d'exploitation }
  TPlatformVersion = (
      pvUnknown,
      pvWin95,
      pvWin98,
      pvWinME,
      pvWinNT3,
      pvWinNT4,
      pvWin2000,
      pvWinXP,
      pvWin2003,
      pvWinVista,
      pvWinSeven,
      pvWin2008,
      pvWin8,
      pvWin10,
      pvLinuxArc,
      pvLinuxDebian,
      pvLinuxopenSUSE,
      pvLinuxFedora,
      pvLinuxGentoo,
      pvLinuxMandriva,
      pvLinuxRedHat,
      pvLinuxTurboLinux,
      pvLinuxUbuntu,
      pvLinuxXandros,
      pvLinuxOracle,
      pvAppleMacOSX
    );

Type
  { TDeviceCapabilities : Informations sur les capacités de l'affichage }
  TDeviceCapabilities = record
    Xdpi, Ydpi: integer; // Nombre de pixel logique par pouce.
    Depth: integer; // profondeur de couleur (bit).
    NumColors: integer; // Nombre d'entrées dans la table des couleurs de l'appareil.
  end;

//==============================================================================
(*
function CPUID_Available: Boolean;
function CPU_getLargestStandardFunction:integer;
function CPU_DetectFeaturesEDX(B:Byte):boolean;
function CPU_DetectFeaturesECX(B:Byte):boolean;
function CPU_ExtensionsAvailable: Boolean;
function CPU_DetectExtensionFeaturesECX(B:Byte):boolean;
function CPU_DetectExtensionFeaturesEDX(B:Byte):boolean;
function CPU_VendorID: String;
function CPU_Brand: String;
function CPU_LogicalProcessorCount: Integer;
function CPU_Signature: Integer;

//function CPU_Features: Integer;
//function CPU_ExtFeatures: Integer;

function CPU_FeaturesAsString : String;
*)


// Retourne le nombre de processeur configurer par le systeme
function GetProcessorCount: Cardinal;

// Recupere la valeur du timer interne }
procedure QueryPerformanceCounter(var val: Int64);
// QueryPerformanceFrequency
function QueryPerformanceFrequency(var val: Int64): Boolean;

// Retourne les infos sur l'OS
function GetPlatformInfo: TPlatformInfo;
// Retrourne la version de l'OS
function GetPlatformVersion : TPlatformVersion;
// Retrourne la version de l'OS  sous forme de chaine de caratères
function GetPlatformVersionAsString : string;
// Retourne les carateristique d'affichage de l'appareil
function GetDeviceCapabilities: TDeviceCapabilities;
// Retourne le nombre de bit pour l'affichage
function GetCurrentColorDepth: Integer;
// Retourne la largeur de l'affichage en DPI
function GetDeviceLogicalPixelsX({%H-}device: HDC): Integer;
// Retourne les carateristique d'affichage de l'appareil sous forme de chaine de caratères
function GetDeviceCapabilitiesAsString: String;

// Retourne le nom de fichier de l'application en cours
function GetAppFileName : string;
// Retourne le dossier de l'application en cours
function GetAppPath : string;

// Retourne le répertoire temporaire de l'OS
function GetTempFolderPath : string;
// Ouvre un fichier HTML ou une Url dans le navigateur par defaut
procedure ShowHTMLUrl(Url: string);

// Renvoi le format de la decimal de notre systeme
function GetDecimalSeparator: Char;
// Definit le format décimal "." ou "," habituellement
procedure SetDecimalSeparator(AValue: Char);

//==============================================================================

implementation

uses
   resreader, resource, versionresource,forms,
  //fileinfo,process,
   {$IFDEF WINDOWS}
    ShellApi,
    JwaWinBase,{, JwaWinNt}
    winpeimagereader; {need this for reading exe info}
   {$ENDIF}
   {$IFDEF UNIX}
     LCLProc,
     elfreader; {needed for reading ELF executables}
   {$ENDIF}
   {$IFDEF DARWIN}
     XMLRead,
     DOM,
     machoreader; {needed for reading MACH-O executables}
   {$ENDIF}


//==============================================================================

//const
//  CPUFeaturesCheck : array[TCPUFeaturesSet] of byte =(23,25,26,0,9,19,20);
//  CPUExtensionsFeatureCheck : array[TCPUExtensionsFeaturesSet] of byte =(22,23,23,30,31,20);


{$IFDEF UNIX}
const _SC_NPROCESSORS_ONLN = 83;
function sysconf(i: cint): clong; cdecl; external name 'sysconf';
{$ENDIF}

function GetProcessorCount: Cardinal;
{$IFDEF WINDOWS}
var
  lpSysInfo: TSystemInfo;
begin
  //lpSysInfo := nil;
  GetSystemInfo(lpSysInfo);
  Result := lpSysInfo.dwNumberOfProcessors;
end;
{$ELSE}
begin
  //Result := 1;
  result := sysconf(_SC_NPROCESSORS_ONLN);
end;
{$ENDIF}

var
  vGLZStartTime : TDateTime;
{$IFDEF WINDOWS}
  vLastTime: TDateTime;
  vDeltaMilliSecond: TDateTime;
{$ENDIF}

{ @HTML ( Returns time in milisecond from application start.<p>}
function GLZStartTime: Double;
{$IFDEF WINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
    Result :=(wHour * (MinsPerHour * SecsPerMin * MSecsPerSec) +
             wMinute * (SecsPerMin * MSecsPerSec) +
             wSecond * MSecsPerSec +
             wMilliSeconds) - vGLZStartTime;
  // Hack to fix time precession
  if Result - vLastTime = 0 then
  begin
    Result := Result + vDeltaMilliSecond;
    vDeltaMilliSecond := vDeltaMilliSecond + 0.1;
  end
  else begin
    vLastTime := Result;
    vDeltaMilliSecond := 0.1;
  end;
end;
{$ENDIF}

{$IFDEF UNIX}
var
  tz: timeval;
begin
  fpgettimeofday(@tz, nil);
  Result := tz.tv_sec - vGLZStartTime;
  Result := Result * 1000000;
  Result := Result + tz.tv_usec;
// Delphi for Linux variant (for future ;)
//var
//  T: TTime_T;
//  TV: TTimeVal;
//  UT: TUnixTime;
//begin
//  gettimeofday(TV, nil);
//  T := TV.tv_sec;
//  localtime_r(@T, UT);
//  with UT do
//    Result := (tm_hour * (MinsPerHour * SecsPerMin * MSecsPerSec) +
//             tm_min * (SecsPerMin * MSecsPerSec) +
//             tm_sec * MSecsPerSec +
//             tv_usec div 1000) - vGLSStartTime;
end;
{$ENDIF}

{$IFDEF UNIX}
var
  vProgStartSecond: int64;

procedure Init_vProgStartSecond;
var
  tz: timeval;
begin
  fpgettimeofday(@tz, nil);
  vProgStartSecond := tz.tv_sec;
end;
{$ENDIF}

procedure QueryPerformanceCounter(var val: Int64);
{$IFDEF WINDOWS}
begin
  Windows.QueryPerformanceCounter(val);
end;
{$ENDIF}
{$IFDEF UNIX}
var
  tz: timeval;
begin
  fpgettimeofday(@tz, nil);
  val := tz.tv_sec - vProgStartSecond;
  val := val * 1000000;
  val := val + tz.tv_usec;
end;
{$ENDIF}

function QueryPerformanceFrequency(var val: Int64): Boolean;
{$IFDEF WINDOWS}
begin
  Result := Boolean(Windows.QueryPerformanceFrequency(val));
end;
{$ENDIF}
{$IFDEF UNIX}
begin
  val := 1000000;
  Result := True;
end;
{$ENDIF}

function GetPlatformInfo: TPlatformInfo;
var
  {$IFDEF MSWINDOWS}
  OSVersionInfo : windows.TOSVersionInfo;
  //LPOSVERSIONINFOA; //
  {$ENDIF}
  {$IFDEF UNIX}
    {$IFNDEF DARWIN}
  ReleseList: TStringList;
    {$ENDIF}
  str: String;
    {$IFDEF DARWIN}
  Documento: TXMLDocument;
  Child: TDOMNode;
  i:integer;
    {$ENDIF}
  {$ENDIF}
begin
  {$IFDEF WINDOWS}
  With Result do
  begin
    OSVersionInfo.dwOSVersionInfoSize := sizeof(TOSVersionInfo);

    if not windows.GetVersionEx(OSVersionInfo) then Exit;

    Minor := OSVersionInfo.DwMinorVersion;
    Major := OSVersionInfo.DwMajorVersion;
    Revision := OSVersionInfo.dwBuildNumber;
    PlatformId := OSVersionInfo.dwPlatformId;
    Version :=  InttoStr(OSVersionInfo.DwMajorVersion)+'.'+InttoStr(OSVersionInfo.DwMinorVersion)+' Build : '+InttoStr(OSVersionInfo.dwBuildNumber);
  end;
  {$ENDIF}
  {$IFDEF UNIX}
  {$IFNDEF DARWIN}
  ReleseList := TStringList.Create;

  with Result,ReleseList do
  begin
    if FileExists('/etc/lsb-release')  then
      LoadFromFile('/etc/lsb-release')
    else Exit;

    ID := Values['DISTRIB_ID'];
    Version := Values['DISTRIB_RELEASE'];
    CodeName := Values['DISTRIB_CODENAME'];
    Description := Values['DISTRIB_DESCRIPTION'];
    Destroy;
  end;
  {$ENDIF}
  {$IFDEF DARWIN}
  if FileExists('System/Library/CoreServices/ServerVersion.plist')  then
    ReadXMLFile(Documento, 'System/Library/CoreServices/ServerVersion.plist')
  else Exit;
  Child := Documento.DocumentElement.FirstChild;

  if Assigned(Child) then
  begin
    with Child.ChildNodes do
    try
      for i := 0 to (Count - 1) do
      begin
        if Item[i].FirstChild.NodeValue='ProductBuildVersion' then
          Result.ProductBuildVersion:=Item[i].NextSibling.FirstChild.NodeValue;
        if Item[i].FirstChild.NodeValue='ProductName' then
          Result.ID:=Item[i].NextSibling.FirstChild.NodeValue;
        if Item[i].FirstChild.NodeValue='ProductVersion' then
          Result.Version:=Item[i].NextSibling.FirstChild.NodeValue;
      end;
    finally
      Free;
    end;
  end;
  {$ENDIF}
  //Major.Minor.Revision
  str:=Result.Version;
  if str='' then Exit;
  Result.Major:=StrtoInt( Utf8Copy(str, 1, Utf8Pos('.',str)-1) );
  Utf8Delete(str, 1, Utf8Pos('.', str) );

  //10.04
  if Utf8Pos('.', str) = 0 then
  begin
    Result.Minor:=StrtoInt( Utf8Copy(str, 1, Utf8Length(str)) );
    Result.Revision:=0;
  end else
  //10.6.5
    begin
       Result.Minor:=StrtoInt( Utf8Copy(str, 1, Utf8Pos('.',str)-1) );
       Utf8Delete(str, 1, Utf8Pos('.', str) );
       Result.Revision:=StrtoInt( Utf8Copy(str, 1, Utf8Length(str)) );
    end;
  {$ENDIF}
end;

function GetPlatformVersion : TPlatformVersion;
{$IFDEF Unix}
var
  i: integer;
const
VersStr : array[TPlatformVersion] of string = (
  '',  '',  '',  '',  '',  '',
  '',  '',  '',  '',  '',  '', '',
  '',
  'Arc',
  'Debian',
  'openSUSE',
  'Fedora',
  'Gentoo',
  'Mandriva',
  'RedHat',
  'TurboLinux',
  'Ubuntu',
  'Xandros',
  'Oracle',
  'Mac OS X'
  );
{$ENDIF}
begin
  Result := pvUnknown;
  {$IFDEF WINDOWS}
  with GetPlatformInfo do
  begin
        if Version='' then Exit;
        case Major of
          0..2: Result := pvUnknown;
          3:  Result := pvWinNT3;              // Windows NT 3
          4:  case Minor of
                0: if PlatformId = VER_PLATFORM_WIN32_NT
                   then Result := pvWinNT4     // Windows NT 4
                   else Result := pvWin95;     // Windows 95
                10: Result := pvWin98;         // Windows 98
                90: Result := pvWinME;         // Windows ME
              end;
          5:  case Minor of
                0: Result := pvWin2000;         // Windows 2000
                1: Result := pvWinXP;          // Windows XP
                2: Result := pvWin2003;        // Windows 2003
              end;
          6:  case Minor of
                0: Result := pvWinVista;         // Windows Vista
                1: Result := pvWinSeven;          // Windows Seven
                2: Result := pvWin2008;        // Windows 2008
                3..4: Result := pvUnknown;
              end;
          7..8:  Result := pvWin8;
          9..10:  Result := pvWin10;
        end;
   end;
  {$ENDIF}
  {$IFDEF UNIX}
  with GetPlatformInfo do
  begin
    if Version='' then Exit;
    For i:= 13 to Length(VersStr)-1 do
     if ID=VersStr[TPlatformVersion(i)] then
       Result := TPlatformVersion(i);
  end;
  {$ENDIF}
end;

function GetPlatformVersionAsString : string;
const
  VersStr : array[TPlatformVersion] of string = (
    'Inconnu',
    'Windows 95',
    'Windows 98',
    'Windows ME',
    'Windows NT 3',
    'Windows NT 4',
    'Windows 2000',
    'Windows XP',
    'Windows 2003',
    'Windows Vista',
    'Windows Seven',
    'Windows 2008',
    'Windows 8',
    'Windows 10',

    'Linux Arc',
    'Linux Debian',
    'Linux openSUSE',
    'Linux Fedora',
    'Linux Gentoo',
    'Linux Mandriva',
    'Linux RedHat',
    'Linux TurboLinux',
    'Linux Ubuntu',
    'Linux Xandros',
    'Linux Oracle',
    'Apple MacOSX');
begin
  Result := VersStr[GetPlatformVersion]+' ( Version : '+GetPlatformInfo.Version+' )';
end;

function GetDeviceCapabilities: TDeviceCapabilities;
{$IFDEF WINDOWS}
var
  Device: HDC;
begin
  Device := GetDC(0);
  try
    result.Xdpi := GetDeviceCaps(Device, LOGPIXELSX);
    result.Ydpi := GetDeviceCaps(Device, LOGPIXELSY);
    result.Depth := GetDeviceCaps(Device, BITSPIXEL);
    result.NumColors := GetDeviceCaps(Device, NUMCOLORS);
  finally
    ReleaseDC(0, Device);
  end;
end;
{$ELSE}
{$IFDEF X11_SUPPORT}
var
  dpy: PDisplay;
begin
  dpy := XOpenDisplay(nil);
  Result.Depth := DefaultDepth(dpy, DefaultScreen(dpy));
  XCloseDisplay(dpy);

  Result.Xdpi := 96;
  Result.Ydpi := 96;
  Result.NumColors := 1;
end;
{$ELSE}
begin
  {$MESSAGE Warn 'Needs to be implemented'}
end;
{$ENDIF}

{$ENDIF}

function GetDeviceCapabilitiesAsString: String;
Var
  s:String;
begin
  s:='';
  with GetDeviceCapabilities() do
  begin
    s:=  'Resolution : '+Inttostr(Screen.Width)+'x'+Inttostr(Screen.Height)+#13#10;
    s:=s+'DPI        : '+ Inttostr(Xdpi) +'x'+inttostr(Ydpi)+#13#10;
    s:=s+'Format     : '+ Inttostr(Depth)+' Bits'+#13#10;
    //s:=s+'Couleurs : '+ Inttostr(NumColors);
  end;
  result:=s;
end;

function GetDeviceLogicalPixelsX(device: HDC): Integer;
begin
  result := GetDeviceCapabilities().Xdpi;
end;

function GetCurrentColorDepth: Integer;
begin
  result := GetDeviceCapabilities().Depth;
end;

function GetAppFileName : string;
var
{$IFNDEF FPC}
  path: string;
{$ELSE}
  path: UTF8String;
{$ENDIF}
begin
{$IFNDEF FPC}
  path := ExtractFileName(ParamStr(0));
{$ELSE}
  path := ExtractFileName(ParamStrUTF8(0));
{$ENDIF}
  result:=path;
end;

function GetAppPath : string;
var
{$IFNDEF FPC}
  path: string;
{$ELSE}
  path: UTF8String;
{$ENDIF}
begin
{$IFNDEF FPC}
  path := ExtractFilePath(ParamStr(0));
  path := IncludeTrailingPathDelimiter(path);
{$ELSE}
  path := ExtractFilePath(ParamStrUTF8(0));
  path := IncludeTrailingPathDelimiter(path);
{$ENDIF}
  result:=path;
end;

function GetTempFolderPath : string;
{$IFDEF WINDOWS}
var lng: DWORD; thePath: string;
begin
  SetLength(thePath, MAX_PATH);
  lng := GetTempPath(MAX_PATH, PChar(thePath));
  SetLength(thePath, lng);
  result := thePath;
end;
{$ELSE}
begin
  result:=sysutils.GetTempDir;
end;
{$ENDIF}


procedure ShowHTMLUrl(Url: string);
begin
{$IFDEF WINDOWS}
  ShellExecute(0, 'open', PChar(Url), nil, nil, SW_SHOW);
{$ENDIF}
{$IFDEF UNIX}
  fpSystem(PChar('env xdg-open ' + Url));
{$ENDIF}
end;

function GetDecimalSeparator: Char;
begin
  Result :=DefaultFormatSettings.DecimalSeparator;
end;

procedure SetDecimalSeparator(AValue: Char);
begin
{$IFDEF FPC}
  DefaultFormatSettings.DecimalSeparator := AValue;
{$ENDIF}
end;

initialization
   vGLZStartTime := GLZStartTime;
  {$IFDEF UNIX}
    Init_vProgStartSecond;
  {$ENDIF}

 // InitCPUFeaturesData;

finalization

end.

(*procedure FindFiles(StartDir, FileMask: string;
                 recursively: boolean; var FilesList: TStringList);
const
  MASK_ALL_FILES = '*.*';
  CHAR_POINT = '.';
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin

  if (StartDir[length(StartDir)] <> '\') then begin
    StartDir := StartDir + '\';
  end;

  // Crear la lista de ficheos en el dir. StartDir (no directorios!)
  IsFound := FindFirst(StartDir + FileMask,
                  faAnyFile - faDirectory, SR) = 0;

  // MIentras encuentre
  while IsFound do begin
    FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
  end;

  FindClose(SR);

  // Recursivo?
  if (recursively) then begin
    // Build a list of subdirectories
    DirList := TStringList.Create;
    // proteccion
    try
    IsFound := FindFirst(StartDir + MASK_ALL_FILES,
                   faAnyFile, SR) = 0;
    while IsFound do begin
      if ((SR.Attr and faDirectory) <> 0) and
          (SR.Name[1] <>  CHAR_POINT) then begin
        DirList.Add(StartDir + SR.Name);
        IsFound := FindNext(SR) = 0;
      end; // if
    end; // while
    FindClose(SR);
    // Scan the list of subdirectories
    for i := 0 to DirList.Count - 1 do begin
      FindFiles(DirList[i], FileMask, recursively, FilesList);
    end;

    finally
      DirList.Free;
    end;
  end;
end;
*)

