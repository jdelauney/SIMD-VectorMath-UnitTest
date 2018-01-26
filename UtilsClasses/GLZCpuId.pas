(*====< GLZCpuId.pas >===========================================================
  ------------------------------------------------------------------------------
  Historique :
   - 18/11/16 - BeanzMaster - Creation
  ------------------------------------------------------------------------------
  Description :
   L'unité GLZCpuId contient des fonctions pour obtenir des informations sur le
   microprocesseur. Cette unité utilise directement l'assembleur.
   Elle initialise également le jeux d'instruction simd SSE
  ------------------------------------------------------------------------------
  Notes : https://en.wikipedia.org/wiki/CPUID
  ------------------------------------------------------------------------------
  @TODO :
  ------------------------------------------------------------------------------
 *==============================================================================*)
unit GLZCpuId;

{.$i ..\lazbeanz_lib.inc}
{$ASMMODE INTEL}
interface

uses

   {$IFDEF Windows}
     Windows,
   {$ENDIF}
   {$IFDEF UNIX}
//     BaseUnix, UnixUtil,
     Unix,
     {$IFDEF X11_SUPPORT}
       xlib,
     {$ENDIF}
   {$ENDIF}
   Classes, SysUtils, GLZTypes;

{%region%---[ CPUID ]----------------------------------------------------------}
Const
  CPU_TYPE_INTEL     = 1;
  CPU_TYPE_CYRIX     = 2;
  CPU_TYPE_AMD       = 3;
  CPU_TYPE_TRANSMETA = 4;
  CPU_TYPE_VIA       = 5;

  VendorIDIntel : Array [0 .. 11] Of AnsiChar     = 'GenuineIntel';
  VendorIDCyrix : Array [0 .. 11] Of AnsiChar     = 'CyrixInstead';
  VendorIDAMD : Array [0 .. 11] Of AnsiChar       = 'AuthenticAMD';
  VendorIDTransmeta : Array [0 .. 11] Of AnsiChar = 'GenuineTMx86';
  VendorIDVIA : Array [0 .. 11] Of AnsiChar       = 'CentaurHauls';

type

  // Definition des technologies spécifiques
  TGLZCPUFeaturesSet = (cf3DNow,    // Extension EDX bit 31
                     cf3DNowExt, // Extension EDX bit 30
                     cfMMX,      // EDX bit 23 + Extension EDX bit 23
                     cfEMMX,     // Extension EDX bit 22
                     cfSSE,      // EDX bit 25
                     cfSSE2,     // EDX bit 26
                     cfSSE3,     // ECX bit 0
                     cfSSSE3,    // ECX bit 9
                     cfSSE41,    // ECX bit 19
                     cfSSE42,    // ECX bit 20
                     cfSSE4A,    // Extension ECX bit 20
                     cfAVX,      // ECX bit 28
                     //cfAVX2,
                     cfFMA3,     // ECX bit 12
                     cfFMA4,     // Extension ECX bit 16
                     cfNX,       // Extension EDX bit 20
                     cfAES       // ECX bit 25
                     );

   TGLZCPUFeatures = set of TGLZCPUFeaturesSet;


   TGLZCPUInfos = record
     Vendor  : String;
     BrandName : String;
     FamillyAsString : String;
     Features  : TGLZCPUFeatures;
     FeaturesAsString : String;
     Signature : Integer;
     Speed : Integer;
     LogicalProcessors : byte;
     ProcessorType:Integer;
     Familly:integer;
     Model:Integer;
     ExtModel:Integer;
     ExtFamilly:Integer;
     Stepping:Integer;
   end;


// Retourne la vitesse approximative du processeur
function CPU_Speed: double;
// Retourne si des des instructions spécifiques sont supportées par le processeur
function CPU_HasFeature(const InstructionSet: TGLZCPUFeaturesSet): Boolean;
// Retourne des infos sur le CPU
//function getCPUInfos:TCPUInfos;
// Retourne la valeur RTC du systeme
function GetClockCycleTickCount: Int64;

Var
  GLZCPUInfos : TGLZCPUInfos;

{%endregion%}

//==============================================================================
implementation

var
  GLZCPUFeaturesInitialized : Boolean = False;
  GLZCPUFeaturesData: TGLZCPUFeatures;


//==============================================================================

{%region%---[ CPUID ]----------------------------------------------------------}

{$IFNDEF NO_ASM_OPTIMIZATIONS}
 function GetClockCycleTickCount: Int64; assembler; register;
{$IFDEF CPU32}
asm
   DB $0F,$31
end;
{$ENDIF}
{$IFDEF CPU64}
asm
    RDTSC //dw 310Fh // rdtsc
    shl rdx, 32
    or rax, rdx
end;
{$ENDIF}
//
//asm
//{$ifdef CPU64}
//  XOR rax, rax
//  CPUID
//  RDTSC  //Get the CPU's time stamp counter.
//  mov [Result], RAX
//{$else}
//  XOR eax, eax
//  CPUID
//  RDTSC  //Get the CPU's time stamp counter.
//  mov [Result], eax
//{$endif}
//end;
{$ELSE}
function GetClockCycleTickCount: Int64;
begin
  result:=getTickCount64;
end;
{$ENDIF}


function CPU_Speed: double;
{$IFDEF CPU32}
{$IFNDEF NO_ASM_OPTIMIZATIONS}
const
  DelayTime = 500; // measure time in ms
var
  TimerHi, TimerLo: DWOrd;
  PriorityClass, Priority: Integer;
begin
  {$IFDEF WINDOWS}
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetthreadPriority(GetCurrentthread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetthreadPriority(GetCurrentthread, thread_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  {$ENDIF}
  asm
    dw 310Fh // rdtsc
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    dw 310Fh // rdtsc
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  {$IFDEF WINDOWS}
  SetthreadPriority(GetCurrentthread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Result := TimerLo / (1000.0 * DelayTime);
  {$ENDIF}
end;
{$ENDIF}
{$ELSE}
const
  DelayTime = 200;
var
  x, y: UInt64;
  {$IFDEF WINDOWS}
  PriorityClass, Priority: Integer;
  {$ENDIF}
begin
  {$IFDEF WINDOWS}
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority      := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  {$ENDIF}
  x := GetClockCycleTickCount;
  Sleep(DelayTime);
  y := GetClockCycleTickCount;
  {$IFDEF WINDOWS}
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  {$ENDIF}
  Result := ((y - x) and $FFFFFFFF) / (1000 * DelayTime);
end;
{$ENDIF}

{$IFNDEF NO_ASM_OPTIMIZATIONS}


function CPUID_Available: Boolean;  assembler; 
asm
{$IFDEF CPU32}
        MOV       EDX,False
        PUSHFD
        POP       EAX
        MOV       ECX,EAX
        XOR       EAX,$00200000
        PUSH      EAX
        POPFD
        PUSHFD
        POP       EAX
        XOR       ECX,EAX
        JZ        @1
        MOV       EDX,True
@1:     PUSH      EAX
        POPFD
        MOV       EAX,EDX
{$ENDIF}
{$IFDEF CPU64}
        MOV       EDX,False
        PUSHFQ
        POP       RAX
        MOV       ECX,EAX
        XOR       EAX,$00200000
        PUSH      RAX
        POPFQ
        PUSHFQ
        POP       RAX
        XOR       ECX,EAX
        JZ        @1
        MOV       EDX,True
@1:     PUSH      RAX
        POPFQ
        MOV       EAX,EDX
{$ENDIF}
end;

function CPU_getLargestStandardFunction:integer;  assembler;
asm
{$IFDEF CPU32}
      PUSH      EBX
      MOV       EAX,0
      CPUID
      POP       EBX
{$ENDIF}
{$IFDEF CPU64}
       PUSH      RBX
       MOV       EAX,0
       CPUID
       POP RBX
{$ENDIF}
end;

function CPU_Signature: Integer;   assembler; 
asm
{$IFDEF CPU32}
        PUSH      EBX
        MOV       EAX,1
        CPUID
        POP       EBX
{$ENDIF}
{$IFDEF CPU64}
        PUSH      RBX
        MOV       EAX,1
        CPUID
        POP       RBX
{$ENDIF}
end;


function CPU_FeaturesEDX: Integer;  {$IFDEF FPC} assembler; {$ENDIF}
asm
{$IFDEF CPU32}
        PUSH      EBX
        MOV       EAX,1
        CPUID
        POP       EBX
        MOV       EAX,EDX
{$ENDIF}
{$IFDEF CPU64}
        PUSH      RBX
        MOV       EAX,1
        CPUID
        POP       RBX
        MOV       EAX,EDX
{$ENDIF}
end;

function CPU_FeaturesECX: Integer;  {$IFDEF FPC} assembler; {$ENDIF}
asm
{$IFDEF CPU32}
        PUSH      EBX
        MOV       EAX,1
        CPUID
        POP       EBX
        MOV       EAX,EDX
{$ENDIF}
{$IFDEF CPU64}
        PUSH      RBX
        MOV       EAX,1
        CPUID
        POP       RBX
        MOV       EAX,ECX
{$ENDIF}
end;


function CPU_DetectFeaturesEDX(B:Byte):boolean; {$IFDEF FPC} assembler; {$ENDIF}
asm
{$IFDEF CPU64}
        PUSH      RBX
        MOV       R8B,CL
        MOV       EAX,1
        CPUID
        MOV       EAX,EDX
        MOV       CL,R8B
        SHR       EAX,CL
        AND       EAX,1
        POP       RBX
{$ENDIF}
end;

function CPU_DetectFeaturesECX(B:Byte):boolean; {$IFDEF FPC} assembler; {$ENDIF}
asm
{$IFDEF CPU64}
        PUSH      RBX
        MOV       R8B,CL
        MOV       EAX,1
        CPUID
        MOV       EAX,ECX
        MOV       CL,R8B
        SHR       EAX,CL
        AND       EAX,1
        POP       RBX
{$ENDIF}
end;

function CPU_ExtensionsAvailable: Boolean;  {$IFDEF FPC} assembler; {$ENDIF}
asm
{$IFDEF CPU32}
        PUSH      EBX
        MOV       @Result, True
        MOV       EAX, $80000000
        CPUID
        CMP       EAX, $80000000
        JBE       @NOEXTENSION
        JMP       @EXIT
      @NOEXTENSION:
        MOV       @Result, False
      @EXIT:
        POP       EBX
{$ENDIF}
{$IFDEF CPU64}
        PUSH      RBX
        MOV       @Result, True
        MOV       EAX, $80000000
        CPUID
        CMP       EAX, $80000000
        JBE       @NOEXTENSION
        JMP       @EXIT
        @NOEXTENSION:
        MOV       @Result, False
        @EXIT:
        POP       RBX
{$ENDIF}
end;

function CPU_DetectExtensionFeaturesECX(B:Byte):boolean; {$IFDEF FPC} assembler; {$ENDIF}
asm
{$IFDEF CPU64}
        PUSH      RBX
        MOV       R8B,CL
        MOV       EAX,$80000001
        CPUID
        MOV       EAX,ECX
        MOV       CL,R8B
        SHR       EAX,CL
        AND       EAX,1
        POP       RBX
{$ENDIF}
end;

function CPU_DetectExtensionFeaturesEDX(B:Byte):boolean; {$IFDEF FPC} assembler; {$ENDIF}
asm
{$IFDEF CPU64}
        PUSH      RBX
        MOV       R8B,CL
        MOV       EAX,$80000001
        CPUID
        MOV       EAX,EDX
        MOV       CL,R8B
        SHR       EAX,CL
        AND       EAX,1
        POP       RBX
{$ENDIF}
end;


(*
function CPU_ExtFeatures: Integer;  assembler; 
asm
{$IFDEF CPU32}
        PUSH      EBX
        MOV       EAX, $80000001
        CPUID
        POP       EBX
        MOV       EAX,EDX
{$ENDIF}
{$IFDEF CPU64}
        PUSH      RBX
        MOV       EAX, $80000001
        CPUID
        POP       RBX
        MOV       EAX,EDX
{$ENDIF}
end;
*)

function CPU_FeaturesBitsEBX: Integer;  assembler;
asm
{$IFDEF CPU32}
        PUSH      EBX
        MOV       EAX, $80000001
        CPUID
        POP       EBX
        MOV       EAX,EDX
{$ENDIF}
{$IFDEF CPU64}
        PUSH      RBX
        MOV       EAX, $00000007
        CPUID
        MOV       EAX,EBX
        POP       RBX
{$ENDIF}
end;

function CPU_LogicalProcessorCount: Integer;  assembler; 
asm
{$IFDEF CPU64}
  PUSH      RBX
  MOV       EAX, 1
  CPUID
  AND       EBX, 00FF0000h
  MOV       EAX, EBX
  SHR       EAX, 16
  POP       RBX
  {$ENDIF}
end;


function CPU_Brand: String; //{$IFDEF FPC} assembler; {$ENDIF}
var s:array[0..48] of ansichar;
begin
  fillchar(s,sizeof(s),0);
{$IFDEF CPU32}
asm
  //check if necessary extended CPUID calls are
  //supported, if not return null string
  mov eax,080000000h
  CPUID
  cmp eax,080000004h
  jb @@endbrandstr
  //get first name part
  mov eax,080000002h
  CPUID
  mov longword(s[0]),eax
  mov longword(s[4]),ebx
  mov longword(s[8]),ecx
  mov longword(s[12]),edx
  //get second name part
  mov eax,080000003h
  CPUID
  mov longword(s[16]),eax
  mov longword(s[20]),ebx
  mov longword(s[24]),ecx
  mov longword(s[28]),edx
  //get third name part
  mov eax,080000004h
  CPUID
  mov longword(s[32]),eax
  mov longword(s[36]),ebx
  mov longword(s[40]),ecx
  mov longword(s[44]),edx
@@endbrandstr:
end;
{$ENDIF}
{$IFDEF CPU64}
asm
  PUSH      RBX
  mov eax,080000000h
  CPUID
  cmp eax,080000004h
  jb @@endbrandstr
  //get first name part
  mov eax,080000002h
  CPUID
  mov longword(s[0]),eax
  mov longword(s[4]),ebx
  mov longword(s[8]),ecx
  mov longword(s[12]),edx
  //get second name part
  mov eax,080000003h
  CPUID
  mov longword(s[16]),eax
  mov longword(s[20]),ebx
  mov longword(s[24]),ecx
  mov longword(s[28]),edx
  //get third name part
  mov eax,080000004h
  CPUID
  mov longword(s[32]),eax
  mov longword(s[36]),ebx
  mov longword(s[40]),ecx
  mov longword(s[44]),edx
@@endbrandstr:
  POP       RBX
end;
{$ENDIF}
  result:=string(s);
end;

function CPU_VendorID: String; //{$IFDEF FPC} assembler; {$ENDIF}
var s:array[0..50] of char;
begin
  fillchar(s,sizeof(s),0);
{$IFDEF CPU32}
asm
  //check if necessary extended CPUID calls are
  //supported, if not return null string
  mov eax,080000000h
  CPUID
  cmp eax,080000004h
  jb @@endbrandstr
  //get first name part
  mov eax,080000002h
  CPUID
  mov longword(s[0]),eax
  mov longword(s[4]),ebx
  mov longword(s[8]),ecx
  mov longword(s[12]),edx
  //get second name part
  mov eax,080000003h
  CPUID
  mov longword(s[16]),eax
  mov longword(s[20]),ebx
  mov longword(s[24]),ecx
  mov longword(s[28]),edx
  //get third name part
  mov eax,080000004h
  CPUID
  mov longword(s[32]),eax
  mov longword(s[36]),ebx
  mov longword(s[40]),ecx
  mov longword(s[44]),edx
@@endbrandstr:
end;
{$ENDIF}
{$IFDEF CPU64}
asm
  PUSH      RBX
  mov eax,0
  CPUID
  //get first name part
  mov longword(s[0]),ebx
  mov longword(s[4]),edx
  mov longword(s[8]),ecx
  //get second name part
  POP       RBX
end;
{$ENDIF}
  result:=string(s);
end;


function CPU_FeaturesAsString : String;
begin
  result:='';
  if not CPUID_Available then Exit;
  {ciMMX  ,  ciEMMX,  ciSSE   , ciSSE2  , ci3DNow ,  ci3DNowExt}
  if CPU_HasFeature(cf3DNow)  then result:=result+'3DNow';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cf3DNowExt) then result:=result+'3DNowExt';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfMMX) then result:=result+'MMX';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfEMMX) then result:=result+'EMMX';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfSSE) then result:=result+'SSE';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfSSE2) then result:=result+'SSE2';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfSSE3) then result:=result+'SSE3';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfSSSE3) then result:=result+'SSSE3';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfSSE41) then result:=result+'SSE4.1';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfSSE42) then result:=result+'SSE4.2';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfSSE4A) then result:=result+'SSE4A';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfAVX) then result:=result+'AVX';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfFMA3) then result:=result+'FMA3';
  if (result<>'') then result:=result+' / ';
  if CPU_HasFeature(cfFMA4) then result:=result+'FMA4';
end;

function CPU_StepId:Integer;
begin
  result:= CPU_Signature And $0000000F;// and $0F;
end;

function CPU_Model:Integer;
begin
  result:= (CPU_Signature  And $000000F0) Shr 4;    //shr 4 and $0F;
end;

function CPU_ExtModel:Integer;
begin
 // if CPU_Model >= 15 then
    result:= (CPU_Signature And $000F0000) Shr 16;    //shr 16 and $0F;
 // else
  //  result:=0;
end;

(*ProcSignature->BrandID = (REGEBX & 0xF);
				ProcSignature->CLFLUSHLineSize = ((REGEBX>>8) & 0xF);
				ProcSignature->CountOfLogicalProcessors = ((REGEBX>>16) & 0xF);
				ProcSignature->APICID = ((REGEBX>>24) & 0xF);
*)

function CPU_Familly:Integer;
begin
  result:= (CPU_Signature  And $00000F00) Shr 8;          //  shr 8 and $0F;
end;

function CPU_ExtFamilly:Integer;
begin
  if CPU_Familly >= 15 then
    result:= (CPU_Signature And $0FF00000) Shr 20 //shr 20 and $FF
  else
    result:=0;
end;

function CPU_Type:Integer;
begin
  result:= (CPU_Signature And $00003000) Shr 12; // shr 12 and $03;
end;

function getCPUFamillyAsString:String;
var
  cpuStepID, cpuFamilly,cpuFamillyEx, cpuModel,cpuModelEx, cpuType : Integer;
begin
  cpuFamilly:= CPU_Familly;
  cpuFamillyEx:= CPU_ExtFamilly;

  cpuModel := CPU_Model;
  cpuModelEx := CPU_ExtModel;
  cpuType:= CPU_Type;
  cpuStepID := CPU_StepID;
  case cpuType of
      $01 : Result:='Other';
      $02 : Result:='Unknown';
      $03 : Result:='Central Processor';
      $04 : Result:='Math Processor';
      $05 : Result:='DSP Processor';
      $06 : Result:='Video Processor'
      else
      Result:='n/a';
   end;
  if cpuFamillyEx<$FF then
  case cpuFamilly of
     1 : result:=result+' :  '+'Other';
     2 : result:=result+' :  '+'Unknown';
     3 : result:=result+' :  '+'8086';
     4 : result:=result+' :  '+'80286';
     5 : result:=result+' :  '+'Intel386 processor';
     6 : result:=result+' :  '+'Intel486 processor';
     7 : result:=result+' :  '+'8087';
     8 : result:=result+' :  '+'80287';
     9 : result:=result+' :  '+'80387';
     10 : result:=result+' :  '+'80487';
     11 : result:=result+' :  '+'Intel® Pentium® processor';
     12 : result:=result+' :  '+'Pentium® Pro processor';
     13 : result:=result+' :  '+'Pentium® II processor';
     14 : result:=result+' :  '+'Pentium® processor with MMX technology';
     15 : result:=result+' :  '+'Intel® Celeron® processor';
     16 : result:=result+' :  '+'Pentium® II Xeon processor';
     17 : result:=result+' :  '+'Pentium® III processor';
     18 : result:=result+' :  '+'M1 Family';
     19 : result:=result+' :  '+'M2 Family';
     20 : result:=result+' :  '+'Intel® Celeron® M processor';
     21 : result:=result+' :  '+'Intel® Pentium® 4 HT processor';
     //22..23 : result:=result+' :  '+'Available for assignment';
     24 : result:=result+' :  '+'AMD Duron Processor Family';
     25 : result:=result+' :  '+'K5 Family';
     26 : result:=result+' :  '+'K6 Family';
     27 : result:=result+' :  '+'K6-2';
     28 : result:=result+' :  '+'K6-3';
     29 : result:=result+' :  '+'AMD Athlon Processor Family';
     30 : result:=result+' :  '+'AMD29000 Family';
     31 : result:=result+' :  '+'K6-2+';
     32 : result:=result+' :  '+'Power PC Family';
     33 : result:=result+' :  '+'Power PC 601';
     34 : result:=result+' :  '+'Power PC 603';
     35 : result:=result+' :  '+'Power PC 603+';
     36 : result:=result+' :  '+'Power PC 604';
     37 : result:=result+' :  '+'Power PC 620';
     38 : result:=result+' :  '+'Power PC x704';
     39 : result:=result+' :  '+'Power PC 750';
     40 : result:=result+' :  '+'Intel® Core Duo processor';
     41 : result:=result+' :  '+'Intel® Core Duo mobile processor';
     42 : result:=result+' :  '+'Intel® Core Solo mobile processor';
     43 : result:=result+' :  '+'Intel® Atom processor';
     //44..47 : result:=result+' :  '+'n/a';
     48 : result:=result+' :  '+'Alpha Family';
     49 : result:=result+' :  '+'Alpha 21064';
     50 : result:=result+' :  '+'Alpha 21066';
     51 : result:=result+' :  '+'Alpha 21164';
     52 : result:=result+' :  '+'Alpha 21164PC';
     53 : result:=result+' :  '+'Alpha 21164a';
     54 : result:=result+' :  '+'Alpha 21264';
     55 : result:=result+' :  '+'Alpha 21364';
     56 : result:=result+' :  '+'AMD Turion II Ultra Dual-Core Mobile';
     57 : result:=result+' :  '+'AMD Turion II Dual-Core Mobile M Processor';
     58 : result:=result+' :  '+'AMD Athlon II Dual-Core M Processor';
     59 : result:=result+' :  '+'AMD Opteron 6100 Series Processor';
     60 : result:=result+' :  '+'AMD Opteron 4100 Series Processor';
     61 : result:=result+' :  '+'AMD Opteron 6200 Series Processor';
     62 : result:=result+' :  '+'AMD Opteron 4200 Series Processor';
     63 : result:=result+' :  '+'Available for assignment';
     64 : result:=result+' :  '+'MIPS Family';
     65 : result:=result+' :  '+'MIPS R4000';
     66 : result:=result+' :  '+'MIPS R4200';
     67 : result:=result+' :  '+'MIPS R4400';
     68 : result:=result+' :  '+'MIPS R4600';
     69 : result:=result+' :  '+'MIPS R10000';
     70 : result:=result+' :  '+'AMD C-Series Processor';
     71 : result:=result+' :  '+'AMD E-Series Processor';
     72 : result:=result+' :  '+'AMD A-Series Processor';
     73 : result:=result+' :  '+'AMD G-Series Processor';
     //74..79 : result:=result+' :  '+'Available for assignment';
     80 : result:=result+' :  '+'SPARC Family';
     81 : result:=result+' :  '+'SuperSPARC';
     82 : result:=result+' :  '+'microSPARC II';
     83 : result:=result+' :  '+'microSPARC IIep';
     84 : result:=result+' :  '+'UltraSPARC';
     85 : result:=result+' :  '+'UltraSPARC II';
     86 : result:=result+' :  '+'UltraSPARC IIi';
     87 : result:=result+' :  '+'UltraSPARC III';
     88 : result:=result+' :  '+'UltraSPARC IIIi';
     89..95 : result:=result+' :  '+'Available for assignment';
     96 : result:=result+' :  '+'68040 Family';
     97 : result:=result+' :  '+'68xxx';
     98 : result:=result+' :  '+'68000';
     99 : result:=result+' :  '+'68010';
     100 : result:=result+' :  '+'68020';
     101 : result:=result+' :  '+'68030';
     //102..111 : result:=result+' :  '+'Available for assignment';
     112 : result:=result+' :  '+'Hobbit Family';
     //113..119 : result:=result+' :  '+'Available for assignment';
     120 : result:=result+' :  '+'Crusoe TM5000 Family';
     121 : result:=result+' :  '+'Crusoe TM3000 Family';
     122 : result:=result+' :  '+'Efficeon TM8000 Family';
     //123..127 : result:=result+' :  '+'Available for assignment';
     128 : result:=result+' :  '+'Weitek';
     129 : result:=result+' :  '+'Available for assignment';
     130 : result:=result+' :  '+'Itanium processor';
     131 : result:=result+' :  '+'AMD Athlon 64 Processor Family';
     132 : result:=result+' :  '+'AMD Opteron Processor Family';
     133 : result:=result+' :  '+'AMD Sempron Processor Family';
     134 : result:=result+' :  '+'AMD Turion 64 Mobile Technology';
     135 : result:=result+' :  '+'Dual-Core AMD Opteron Processor';
     136 : result:=result+' :  '+'AMD Athlon 64 X2 Dual-Core Processor';
     137 : result:=result+' :  '+'AMD Turion 64 X2 Mobile Technology';
     138 : result:=result+' :  '+'Quad-Core AMD Opteron Processor';
     139 : result:=result+' :  '+'Third-Generation AMD Opteron';
     140 : result:=result+' :  '+'AMD Phenom FX Quad-Core Processor';
     141 : result:=result+' :  '+'AMD Phenom X4 Quad-Core Processor';
     142 : result:=result+' :  '+'AMD Phenom X2 Dual-Core Processor';
     143 : result:=result+' :  '+'AMD Athlon X2 Dual-Core Processor';
     144 : result:=result+' :  '+'PA-RISC Family';
     145 : result:=result+' :  '+'PA-RISC 8500';
     146 : result:=result+' :  '+'PA-RISC 8000';
     147 : result:=result+' :  '+'PA-RISC 7300LC';
     148 : result:=result+' :  '+'PA-RISC 7200';
     149 : result:=result+' :  '+'PA-RISC 7100LC';
     150 : result:=result+' :  '+'PA-RISC 7100';
     //151..159 : result:=result+' :  '+'Available for assignment';
     160 : result:=result+' :  '+'V30 Family';
     161 : result:=result+' :  '+'Quad-Core Intel® Xeon® processor 3200 Series';
     162 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor 3000 Series';
     163 : result:=result+' :  '+'Quad-Core Intel® Xeon® processor 5300 Series';
     164 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor 5100 Series';
     165 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor 5000 Series';
     166 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor LV';
     167 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor ULV';
     168 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor';
     169 : result:=result+' :  '+'Quad-Core Intel® Xeon® processor';
     170 : result:=result+' :  '+'Quad-Core Intel® Xeon® processor';
     171 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor';
     172 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor';
     173 : result:=result+' :  '+'Quad-Core Intel® Xeon® processor';
     174 : result:=result+' :  '+'Quad-Core Intel® Xeon® processor';
     175 : result:=result+' :  '+'Multi-Core Intel® Xeon® processor';
     176 : result:=result+' :  '+'Pentium® III Xeon processor';
     177 : result:=result+' :  '+'Pentium® III Processor with Intel';
     178 : result:=result+' :  '+'Pentium® 4 Processor';
     179 : result:=result+' :  '+'Intel® Xeon® processor';
     180 : result:=result+' :  '+'AS400 Family';
     181 : result:=result+' :  '+'Intel® Xeon processor MP';
     182 : result:=result+' :  '+'AMD Athlon XP Processor Family';
     183 : result:=result+' :  '+'AMD Athlon MP Processor Family';
     184 : result:=result+' :  '+'Intel® Itanium® 2 processor';
     185 : result:=result+' :  '+'Intel® Pentium® M processor';
     186 : result:=result+' :  '+'Intel® Celeron® D processor';
     187 : result:=result+' :  '+'Intel® Pentium® D processor';
     188 : result:=result+' :  '+'Intel® Pentium® Processor Extreme';
     189 : result:=result+' :  '+'Intel® Core Solo Processor';
     190 : result:=result+' :  '+'Reserved';
     191 : result:=result+' :  '+'Intel® Core 2 Duo Processor';
     192 : result:=result+' :  '+'Intel® Core 2 Solo processor';
     193 : result:=result+' :  '+'Intel® Core 2 Extreme processor';
     194 : result:=result+' :  '+'Intel® Core 2 Quad processor';
     195 : result:=result+' :  '+'Intel® Core 2 Extreme mobile';
     196 : result:=result+' :  '+'Intel® Core 2 Duo mobile processor';
     197 : result:=result+' :  '+'Intel® Core 2 Solo mobile processor';
     198 : result:=result+' :  '+'Intel® Core i7 processor';
     199 : result:=result+' :  '+'Dual-Core Intel® Celeron® processor';
     200 : result:=result+' :  '+'IBM390 Family';
     201 : result:=result+' :  '+'G4';
     202 : result:=result+' :  '+'G5';
     203 : result:=result+' :  '+'ESA/390 G6';
     204 : result:=result+' :  '+'z/Architectur base';
     205 : result:=result+' :  '+'Intel® Core i5 processor';
     206 : result:=result+' :  '+'Intel® Core i3 processor';
     207..209 : result:=result+' :  '+'Available for assignment';
     210 : result:=result+' :  '+'VIA C7-M Processor Family';
     211 : result:=result+' :  '+'VIA C7-D Processor Family';
     212 : result:=result+' :  '+'VIA C7 Processor Family';
     213 : result:=result+' :  '+'VIA Eden Processor Family';
     214 : result:=result+' :  '+'Multi-Core Intel® Xeon® processor';
     215 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor 3xxx Series';
     216 : result:=result+' :  '+'Quad-Core Intel® Xeon® processor 3xxx Series';
     217 : result:=result+' :  '+'VIA Nano Processor Family';
     218 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor 5xxx Series';
     219 : result:=result+' :  '+'Quad-Core Intel® Xeon® processor 5xxx Series';
     220 : result:=result+' :  '+'Available for assignment';
     221 : result:=result+' :  '+'Dual-Core Intel® Xeon® processor 7xxx Series';
     222 : result:=result+' :  '+'Quad-Core Intel® Xeon® processor 7xxx Series';
     223 : result:=result+' :  '+'Multi-Core Intel® Xeon® processor 7xxx Series';
     224 : result:=result+' :  '+'Multi-Core Intel® Xeon® processor 3400 Series';
     //225..229 : result:=result+' :  '+'Available for assignment';
     230 : result:=result+' :  '+'Embedded AMD Opteron Quad-Core Processor Family';
     231 : result:=result+' :  '+'AMD Phenom Triple-Core Processor Family';
     232 : result:=result+' :  '+'AMD Turion Ultra Dual-Core Mobile Processor Family';
     233 : result:=result+' :  '+'AMD Turion Dual-Core Mobile Processor Family';
     234 : result:=result+' :  '+'AMD Athlon Dual-Core Processor Family';
     235 : result:=result+' :  '+'AMD Sempron SI Processor Family';
     236 : result:=result+' :  '+'AMD Phenom II Processor Family';
     237 : result:=result+' :  '+'AMD Athlon II Processor Family';
     238 : result:=result+' :  '+'Six-Core AMD Opteron Processor Family';
     239 : result:=result+' :  '+'AMD Sempron M Processor Family';
     //240..249 : result:=result+' :  '+'Available for assignment';
     250 : result:=result+' :  '+'i860';
     251 : result:=result+' :  '+'i960';
     //252..253 : result:=result+' :  '+'Available for assignment';
     //254 : result:=result+' :  '+'Indicator to obtain the processor family from the Processor';
     //255 : result:=result+' :  '+'Reserved';
  else
    result:=result+' :  '+'n/a';
  end
  else
  case cpuFamillyEx of
    (* 256..259,
     262..279,
     282..299,
     303..319,
     321..349,
     351..499,
     501..511 : result:=result+' :  '+'These values are available for assignment'; *)
     260 : result:=result+' :  '+'SH-3';
     261 : result:=result+' :  '+'SH-4';
     280 : result:=result+' :  '+'ARM';
     281 : result:=result+' :  '+'StrongARM';
     300 : result:=result+' :  '+'6x86';
     301 : result:=result+' :  '+'MediaGX';
     302 : result:=result+' :  '+'MII';
     320 : result:=result+' :  '+'WinChip';
     350 : result:=result+' :  '+'DSP';
     500 : result:=result+' :  '+'Video Processor';
     //512..65533 : result:=result+' :  '+'Available for assignment';
     //65534..65535 : result:=result+' :  '+'Reserved'
  else
    result:=result+' :  '+'n/a';
  end;
  result:=result+' (Familly Num : '+inttostr(cpuFamilly)+' / FamillyEx : '+inttostr(cpuFamillyEx)+')';
  result:=result+#13#10+' - Model : '+inttostr(cpuModel)+'/'+inttostr(cpuModelEx)+' - StepID : '+inttostr(cpuStepID)+' - Type : '+inttostr(cpuType);
 (* Case cpuFamilly of
    4 :
      Case cpuModel of
        0..7 : result:='486 SX/DX/DX2';
        8: result:='486 DX 4';
        else result:='486 (modèle indéfini)';
      end;
    5 :
      Case cpuModel of
        1: result:='';
        2: result:='';
        3: result:='';
        4: result:='';
        else result:='';
      end;
    6 :
      Case cpuModel of
        1: result:='';
        3: result:='';
        5: result:='';
        6: result:='';
        7: result:='';
        8: result:='';
        9: result:='';
        10: result:='';
        11: result:='';
        else result:='';
      end;
    15 :
      Case cpuModel of
        0 : result:='';
        1 : result:='';
        2 : result:='';
        else result:='';
      end;
  else
      result:='';
  end;
  if cpuType=1 then result:=result+' [OverDrive]'; *)


end;

function CPU_HasFeature(const InstructionSet: TGLZCPUFeaturesSet): Boolean;
// Must be implemented for each target CPU on which specific functions rely
begin
  Result := False;
  if not CPUID_Available then Exit;                   // no CPUID available
  if CPU_Signature shr 8 and $0F < 5 then Exit;       // not a Pentium class

  case InstructionSet of
    cf3DNow :
       begin
         if (not CPU_ExtensionsAvailable) or (not CPU_DetectExtensionFeaturesEDX(30)) then Exit;
       end;
    cf3DNowExt :
       begin
         if (not CPU_ExtensionsAvailable) or (not CPU_DetectExtensionFeaturesEDX(31)) then Exit;
       end;
    cfEMMX:
      begin
        // check for SSE, necessary for Intel CPUs because they don't implement the
        // extended info
        if (not(CPU_DetectFeaturesEDX(25)) and
          (not CPU_ExtensionsAvailable) or (not CPU_DetectExtensionFeaturesEDX(22))) then Exit;
      end;
     cfMMX :
       begin
         if (not CPU_DetectFeaturesEDX(23)) then exit;//CPU_DetectExtensionFeaturesEDX(23)) then Exit;     // (not CPU_ExtensionsAvailable or (
       end;
     cfSSE :
       begin
          if (not CPU_DetectFeaturesEDX(25)) then exit;
       end;
     cfSSE2 :
       begin
         if (not CPU_DetectFeaturesEDX(26)) then exit;
       end;
     cfSSE3 :
       begin
         if (not CPU_DetectFeaturesECX(0)) then exit;
       end;
     cfSSSE3 :
       begin
         if (not CPU_DetectFeaturesECX(9)) then exit;
       end;
     cfSSE41 :
       begin
         if (not CPU_DetectFeaturesECX(19)) then exit;
       end;
     cfSSE42 :
       begin
         if (not CPU_DetectFeaturesECX(20)) then exit;
       end;
     cfSSE4A :
       begin
         if (not CPU_ExtensionsAvailable) or (not CPU_DetectExtensionFeaturesECX(6)) then exit;
       end;
     cfAVX:
       begin
         if (not CPU_DetectFeaturesECX(28)) then exit;
       end;
     cfFMA3 :
       begin
         if (not CPU_DetectFeaturesECX(12)) then exit;
       end;
     cfFMA4 :
       begin
         if (not CPU_ExtensionsAvailable) or (not CPU_DetectExtensionFeaturesECX(16)) then exit;
       end;

  else
      Exit; // return -> instruction set not supported
    end;

  Result := True;
end;

function CPU_Support_RDRAND:Boolean;
begin
 result:=false;
 if not CPUID_Available then Exit;
 result:= CPU_DetectFeaturesEDX(30);// ((CPU_FeaturesEDX and $40000000) =  $40000000);
end;

function CPU_Support_RDSEED:Boolean;
begin
 result:=false;
 if not CPUID_Available then Exit;
 result:= ((CPU_FeaturesBitsEBX and $40000) =  $40000);
end;

function getCPUInfos:TGLZCPUInfos;
var
  ret:TGLZCPUInfos;
  CPUFeaturesData : TGLZCPUFeatures;
  i : TGLZCPUFeaturesSet;
begin
  CPUFeaturesData := [];


  if CPUID_Available then
  begin
    for I := Low(TGLZCPUFeaturesSet) to High(TGLZCPUFeaturesSet) do
    if CPU_HasFeature(I) then CPUFeaturesData := CPUFeaturesData + [I];
    with ret do
    begin
       Vendor  := CPU_VendorID;
       BrandName := CPU_Brand;
       FamillyAsString := '-';//getCPUFamillyAsString;
       Features  := CPUFeaturesData;
       FeaturesAsString := CPU_FeaturesAsString;
       Signature := CPU_Signature;
       ProcessorType := CPU_Type;
       Model:=CPU_Model;
       Familly:=CPU_Familly;
       ExtModel:=CPU_ExtModel;
       ExtFamilly:=CPU_ExtFamilly;
       Stepping :=CPU_StepID;
       Speed := round(CPU_Speed) ;
       LogicalProcessors :=CPU_LogicalProcessorCount;
    end;
  end
  else
  begin
    with ret do
    begin
       Vendor  := 'n/a';
       BrandName := 'n/a';
       FamillyAsString:='';
       Features  := CPUFeaturesData;
       Signature := 0;
       ProcessorType := 0;
       Model:= 0;
       Familly:= 0;
       ExtModel:= 0;
       ExtFamilly:= 0;
       Stepping := 0;
       Speed :=round(CPU_Speed);
       LogicalProcessors :=1;
    end;
  end;
  result := ret;
end;

{$ELSE}
function CPU_HasFeature(const InstructionSet: TCPUFeaturesSet): Boolean;
begin
  Result := False;
end;

function getCPUInfos:TCPUInfos;
var
  ret:TCPUInfos;
  CPUFeaturesData : TCPUFeatures;
  i : TCPUFeaturesSet;
begin
  CPUFeaturesData := [];

    with ret do
    begin
       Vendor  := 'n/a';
       BrandName := 'n/a';
       Familly:='';
       Features  := CPUFeaturesData;
       Signature := 0;
       Speed :=round(CPU_Speed);
       LogicalProcessors :=1;
    end;

  result:=ret;
end;
{$ENDIF}

{%endregion%}


//==============================================================================

initialization

{$ifndef VALGRIND}
{$ifndef CPU32}
 GLZCpuInfos:=getCPUInfos();
{$endif}
{$endif}
 (* if CPU_HasFeature(cfSSE) then
  begin
    oldmxcsr:=get_mxcsr;
    set_mxcsr (mxcsr_default);
  end; *)

//------------------------------------------------------------------------------
finalization

  //if CPU_HasFeature(cfSSE) then set_mxcsr (oldmxcsr);


//==============================================================================
end.

