(*====[ GLZStopWatch.pas ]======================================================
  Historique :
   04/12/16 - BeanzMaster - Creation
  ------------------------------------------------------------------------------
   Description :
     Composant servant à effectuer un chronometrage de vos procedures ou fonctions
   en micro, nano, milli secondes et secondes. Mais également pour calculer le FPS
   dans des applications graphique.

   Une variable globale "GlobalPerformanceTimer" est créée automatiquement. Vous
   pouvez donc vous servir directement de celle-ci ou bien déposer le composant sur
   vos "form".

  Si vous démarrer le chronometre avec le parametre "AUseTickCount" de la procedure
  "Start" à "TRUE" (par defaut à FALSE) alors TGLZStopWatch utilisera  l'horloge
  temps réel (RTC) (Déconseiller sous FPC en mode 32bit).
  Précise sur de longues périodes, mais n'est pas exacte à la milliseconde.
  Cependant elle est efficace sur certains systèmes.

  Sinon TGLZStopWatch utilisera le compteur de performance "Windows".
  Pour Linux un "hack" est utilisé.
  Le compteur de performance a une meilleure précision, mais il peut quand même
  dériver sur de longues périodes. C'est l'option par défaut car elle permet une
  plus grande précision sur les systèmes rapides. Mais si la procedure est trop rapide
  il vaut mieux utilser la RTC

  cf :
   - Demos\ThreadTimer\Basic
--------------------------------------------------------------------------------
   Credits :

--------------------------------------------------------------------------------
   @Todo :
    - nanosecPerTick = (1000*1000*1000) / Stopwatch.Frequency;
    - microsecPerTick = 1000*1000 / Stopwatch.Frequency;
    - millisecPerTick = 1000 / Stopwatch.Frequency;;
    - secPerTick = 1.0 / Stopwatch.Frequency;
--------------------------------------------------------------------------------
================================================================================*)

unit GLZStopWatch;
//==============================================================================

{.$i ..\glzscene_options.inc}

//==============================================================================
interface

uses
  Classes, SysUtils, GLZTypes, GLZCpuID, GLZSystem;

//==============================================================================
type
  TGLZTimeUnit = (
    tuNanosecond,       // 1/1000000000 s
    tuMicrosecond,      // 1/1000000 s
    tuMillisecond,      // 1/1000 s
    tuSecond           // 1 s
//    tuMinute,           // 60 s
//    tuHour              // 3600 s
  );

//===[ TGLZSTOPWATCH ]===========================================================
type
  TGLZStopWatch = class(TComponent)
  private

  protected
    FFrequency, FPerformanceCountStart, FPerformanceCountStop: Int64;
    FNanoSecPerTick: Double;
    FMicroSecPerTick: Double;
    FMilliSecPerTick: Double;
    FSecPerTick: Double;
    FInvPerformanceCounterFrequencyReady: Boolean;
    FFPS: Single;
    FPrecision : Byte;
    FUseTickCount, FStarted : Boolean;
    FCPUClock :Double;


  public

    constructor Create(AOwner: TComponent); override;

    //--------------------------------------------------------------------------
    procedure Start(Const AUseTickCount:boolean = false);
    procedure Stop;
    //--------------------------------------------------------------------------

    function getTimerLap : Double;
    function TickToTimeUnit(const ATick: Int64; AUnit: TGLZTimeUnit): Extended;
    function getValueAsMicroSeconds: string;
    function getValueAsNanoSeconds: string;
    function getValueAsMilliSeconds: string;
    function getValueAsSeconds: string;
    //function GetValueAsText(TimeUnit:TGLZTime): String;
    function getValue: Int64;
    function getTick: Extended;

    function getFPSAsString(FrameCounter:Integer):String;
    function getFPS(FrameCounter:Integer):Single;
    function TickToMicroSecond(const ATick: Int64): String;
    //--------------------------------------------------------------------------
    property UseTickCount : Boolean read FUseTickCount write FUseTickCount;
    property PerformanceCountStart:Int64 read FPerformanceCountStart;
    property PerformanceCountStop:Int64 read FPerformanceCountStop;
    // Frequence de l'horloge interne
    property Frequency : Int64 read FFrequency;
    // Nombre de chiffre après la virgule pour les resultats
    property Precision : Byte read FPrecision write FPrecision default 12;
  end;

//==============================================================================

var
  GlobalPerformanceTimer: TGLZStopWatch;

//==============================================================================

implementation

//==============================================================================
const
  {%H-}DefaultDisplayFormat = '#,##0.0';
  TimeUnitName: array[TGLZTimeUnit] of String =
    (' ns', ' µs', ' ms', ' s');//, 'm', 'h');
  TimeUnitCoefficient: array[TGLZTimeUnit] of Extended =
    (1000000000, 1000000, 1000, 1);//, 1/60, 1/3600);

//===[ TGLZSTOPWATCH ]===========================================================

function TGLZStopWatch.TickToTimeUnit(const ATick: Int64; AUnit: TGLZTimeUnit): Extended;
begin
  if FUseTickCount then
  begin
    Result := (ATick /FCPUClock) * TimeUnitCoefficient[AUnit];
  end
  else
  begin
    Result := ATick * FSecPerTick * TimeUnitCoefficient[AUnit];
  end;
end;

function TGLZStopWatch.TickToMicroSecond(const ATick: Int64): String;
begin
  if FUseTickCount then
  begin
     Result := FloatToStrF((ATick/FCPUClock) / (TimeUnitCoefficient[tuMilliSecond]), ffGeneral, 15, 3)+TimeUnitName[tuMilliSecond];
  end
  else
  begin
   // Result := ATick * FSecPerTick * TimeUnitCoefficient[AUnit];
    result:=FloatToStrF(ATick*( TimeUnitCoefficient[tuMilliSecond]/FFrequency), ffGeneral, 15, 3)+TimeUnitName[tuMilliSecond];
  end;
end;

//------------------------------------------------------------------------------
// Creation de TGLZStopWatch
//------------------------------------------------------------------------------
constructor TGLZStopWatch.Create(AOwner: TComponent);
begin
  inherited;
  FPerformanceCountStart:=0;
  FPerformanceCountStop:=0;
  FPrecision:=12;
  QueryPerformanceFrequency(FFrequency);
  Assert(FFrequency > 0);

  FNanoSecPerTick:=1000000000.0/FFrequency; // Resolution du timer en nanosecondes;
  FMicroSecPerTick:=1000000.0/FFrequency;   // Resolution du timer en microsecondes
  FMilliSecPerTick:=1000.0/FFrequency;      // Resolution du timer en millisecondes
  FSecPerTick:=1.0/FFrequency;              // Resolution du timer en secondes
                                            // minute = (1/60)/FFrequency,  heure = (1/3600)/FFrequency
  FFPS:=0.0;
  FUseTickCount:=False;
  FStarted:=false;
  FCPUClock := CPU_Speed;
end;

//------------------------------------------------------------------------------
// Retourne le temps écoulé
//------------------------------------------------------------------------------
function TGLZStopWatch.getTimerLap: Double;
var
  StopTime:Int64;
begin
  StopTime :=0;
    if FPerformanceCountStop > 0 then StopTime := FPerformanceCountStop
    else
    begin
      if FUseTickCount then
      begin
        StopTime:=GetClockCycleTickCount;
      end
      else
      begin
        QueryPerformanceCounter(StopTime);
      end;
    end;

    if FUseTickCount then
    begin
      Result := (StopTime - FPerformanceCountStart);
    end
    else
    begin
      Result := (StopTime - FPerformanceCountStart);
    end;
end;

//------------------------------------------------------------------------------
// Retourne le temps écoulé en nanosecondes
//------------------------------------------------------------------------------
function TGLZStopWatch.getValueAsMicroSeconds: string;
begin
  if FUseTickCount then
  begin
    Result := FloatToStrF((getTimerLap/ FCPUClock)*FMicroSecPerTick, ffGeneral, 15, FPrecision)+' µs';
  end
  else
  begin
    Result:= FloatToStrF(getTimerLap*FMicroSecPerTick, ffGeneral, 15, FPrecision)+' µs';
  end;
end;

//------------------------------------------------------------------------------
// Retourne le temps écoulé en nanosecondes
//------------------------------------------------------------------------------
function TGLZStopWatch.getValueAsNanoSeconds: string;
begin
  if FUseTickCount then
  begin
    Result := FloatToStrF((getTimerLap/ FCPUClock)*FNanoSecPerTick, ffFixed, 15, FPrecision)+' ns';
  end
  else
  begin
    Result:= FloatToStrF(getTimerLap*FNanoSecPerTick, ffFixed, 15, FPrecision)+' ns';
  end;
end;

//------------------------------------------------------------------------------
// Retourne le temps écoulé en millisecondes
//------------------------------------------------------------------------------
function TGLZStopWatch.getValueAsMilliSeconds: string;
begin
  if FUseTickCount then
  begin
    Result := FloatToStrF((getTimerLap/ FCPUClock)*FMilliSecPerTick, ffFixed, 15, FPrecision)+' ms';
  end
  else
  begin
    Result := FloatToStrF(getTimerLap*FMilliSecPerTick, ffFixed, 15, FPrecision)+' ms';
  end;
end;

//------------------------------------------------------------------------------
// Retourne le temps écoulé en secondes
//------------------------------------------------------------------------------
function TGLZStopWatch.getValueAsSeconds: String;
begin
  if FUseTickCount then
  begin
    Result := FloatToStrF((getTimerLap/ FCPUClock)*FSecPerTick, ffFixed, 15, FPrecision)+' sec';
  end
  else
  begin
    Result := FloatToStrF((getTimerLap*Frequency)*FSecPerTick  , ffFixed, 15, FPrecision)+' sec';
  end;
end;

//------------------------------------------------------------------------------
// Retourne une valeur entiere du temps écoulé microsecondes
//------------------------------------------------------------------------------
function TGLZStopWatch.getValue: Int64;
begin
  if FUseTickCount then
  begin
    Result := Round((getTimerLap/ FCPUClock));
  end
  else
  begin
    Result := Round(getTimerLap);
  end;
end;

function TGLZStopWatch.getTick: Extended;
begin
  if FUseTickCount then
  begin
    Result := (getTimerLap/ FCPUClock);
  end
  else
  begin
    Result := getTimerLap;
  end;
end;

//------------------------------------------------------------------------------
// Démarre le chronometre
//------------------------------------------------------------------------------
procedure TGLZStopWatch.Start(Const AUseTickCount:boolean = false);
begin
  FPerformanceCountStop := 0;
  FPerformanceCountStart:=0;
  FFPS:=0.0;
  FUseTickCount:=AUseTickCount;
  if FUseTickCount then
  begin
   // FUseTickCount:=True;
    FPerformanceCountStart:=GetClockCycleTickCount;
  end
  else
  begin
    QueryPerformanceCounter(FPerformanceCountStart);
  end;
  FStarted:=true;
end;

//------------------------------------------------------------------------------
// Stop le chronometre
//------------------------------------------------------------------------------
procedure TGLZStopWatch.Stop;
begin
  if FUseTickCount then
  begin
    FPerformanceCountStop:=GetClockCycleTickCount;
  end
  else
  begin
    QueryPerformanceCounter(FPerformanceCountStop);
  end;
  FStarted:=False;

end;

//------------------------------------------------------------------------------
// Retourne le nombre de FPS
//------------------------------------------------------------------------------
function TGLZStopWatch.getFPS(FrameCounter:Integer):Single;
begin
  if FrameCounter > 0 then
  begin
    if FUseTickCount then
    begin
      FFPS := FrameCounter / ((getTimerLap/ FCPUClock)*0.000001);
    end
    else
    begin
      FFPS :=FrameCounter / (getTimerLap*FSecPerTick);
    end;
  end;
  result:=FFPS;
end;

//------------------------------------------------------------------------------
// Retourne le nombre de FPS
//------------------------------------------------------------------------------
function TGLZStopWatch.getFPSAsString(FrameCounter:Integer):String;
begin
  result:=Format('%.*f FPS', [3, getFPS(FrameCounter)]);
end;
//==============================================================================
//==============================================================================

initialization

  GlobalPerformanceTimer := TGLZStopWatch.Create(nil);
//------------------------------------------------------------------------------
finalization

  GlobalPerformanceTimer.Free;

//==============================================================================
end.

