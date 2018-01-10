(*====< GLZUtils.pas >==========================================================@br
  @created(2018-11-16)
  @author(J.Delauney (BeanzMaster))
  Historique : @br
  @unorderedList(
    @item(18/11/2016 : Creation  )
  )
--------------------------------------------------------------------------------@br

 @bold(Description :)@br
  L'unité GLZUtils contiens des routines utiles dans différents domaines tel que
  les nombres, les chaine de caractaires, la manipulation de bits, le calcul de CRC32 etc... @br
  Certaines routines ont étés optimisées gràce à l'utilisation de l'assembleur.

 -------------------------------------------------------------------------------@br

  Notes : @br
 -------------------------------------------------------------------------------@br

    Credits :

 -------------------------------------------------------------------------------@br
  LICENCE : MPL / GPL @br
  @br
 *==============================================================================*)
unit GLZUtils;

{.$i ..\glzscene_options.inc}
{$ASMMODE INTEL}
interface

uses
  Classes, SysUtils, GLZTypes;

{ FillLongWord : Remplie un pointer avec des données alignées sur 32 bits }
procedure FillLongword(var X; Count: Integer; Value: Longword);
{ FillWord : Remplie un pointer avec des données alignées sur 16 bits }
procedure FillWord(var X; Count: Cardinal; Value: LongWord);

{ MoveLongWord : Deplace un pointer avec des données alignées sur 32 bits }
procedure MoveLongword(const Source; var Dest; Count: Integer);
{ MoveLongWord : Deplace un pointer avec des données alignées sur 16 bits }
procedure MoveWord(const Source; var Dest; Count: Integer);

{ MilDiv : Multiplier et diviser }
function MulDiv(Multiplicand, Multiplier, Divisor: Integer): Integer;

{ Clamp : Borner une valeur
@groupbegin }
function Clamp(const V,Min,Max : integer) : integer; overload;
function Clamp(const V,Min,Max : Single):  Single; overload;
function ClampMin(const V,aMin:Single):  Single;
function ClampMax(Const Value, Max:Integer):Integer;
function ClampByte(Const Value:Integer):Byte;
{@groupend }

{ Swap : Inverser les bits d'une valeur
@groupbegin }
procedure Swap(var A, B: Integer); overload;
procedure Swap(var X, Y: Word); overload;
procedure SwapShort(P: PWord; Count: Cardinal);
procedure SwapLong(P: PInteger; Count: Cardinal); overload;
function SwapLong(Value: Cardinal): Cardinal; overload;
function SwapLong(Value: Integer): Integer; overload;
procedure SwapDouble(const Source; var Target);
{@groupend }

{ PercentRatio : renvoi le ratio d'une valeur par rapport au pourcentage demandé }
function percentRatio(Const Max:Integer;Const apercent:Integer):Integer;
{ Percent : renvoi le pourcentage d'une valeur par rapport au maximum }
function percent(Const Max:Integer;Const Current:Integer):Integer;

{ Fonction d'aide pour la manipulation de bit sur Max 32Bits
@groupbegin }
function ClearBit(const AValue: DWORD; const Bit: Byte): DWORD;
function SetBit(const AValue: DWORD; const Bit: Byte): DWORD;
function EnableBit(const AValue: DWORD; const Bit: Byte; const Enable: Boolean): DWORD;
function GetBit(const AValue: DWORD; const Bit: Byte): Boolean;
function GetBitsValue(const AValue: DWORD; const BitI, BitF: Byte): DWORD;
function GetBits(const AValue: DWORD;const AIndex, numbits: Integer): Integer;
function ReverseBits(b: Byte): Byte;
function CountBits(Value: byte): shortint;
function ShiftCount(Mask: DWORD): shortint;
{ @groupend }

{ FixPathDelimiter : Change les slashs et backslash suivant l'OS }
procedure FixPathDelimiter(var S: string);

{ StringToWideString : Convertie une chaine UTF8 ou Ascii en WideString }
function StringToWideString(const str: String): WideString;
{ UTF8ToWideString : Convertie une chaine UTF8 en WideString }
function UTF8ToWideString(const s: AnsiString): WideString;

//procedure CRC32 (p: pointer; ByteCount: LongWord; VAR CRCValue: LongWord);
//function StringCRC32(const s : string ) : LongWord;

implementation


USes
  //StrUtils,
  LConvEncoding, lazutf8,
  GLZCpuId;

const _CRC_TABLE32 : array[0..255] of LongWord =
 ($00000000, $77073096, $EE0E612C, $990951BA,
  $076DC419, $706AF48F, $E963A535, $9E6495A3,
  $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
  $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
  $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
  $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
  $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
  $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
  $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
  $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
  $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
  $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
  $26D930AC, $51DE003A, $C8D75180, $BFD06116,
  $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
  $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
  $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,

  $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
  $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
  $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
  $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
  $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
  $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
  $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
  $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
  $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
  $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
  $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
  $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
  $5005713C, $270241AA, $BE0B1010, $C90C2086,
  $5768B525, $206F85B3, $B966D409, $CE61E49F,
  $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
  $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,

  $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
  $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
  $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
  $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
  $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
  $F762575D, $806567CB, $196C3671, $6E6B06E7,
  $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
  $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
  $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
  $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
  $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
  $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
  $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
  $CC0C7795, $BB0B4703, $220216B9, $5505262F,
  $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
  $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,

  $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
  $9C0906A9, $EB0E363F, $72076785, $05005713,
  $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
  $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
  $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
  $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
  $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
  $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
  $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
  $A7672661, $D06016F7, $4969474D, $3E6E77DB,
  $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
  $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
  $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
  $BAD03605, $CDD70693, $54DE5729, $23D967BF,
  $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
  $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);

//==============================================================================
//uses
//  GLZCpuId;

Type
  TFillLongWordProc = procedure(var X; Count: Integer; Value: Longword);
Var
 Proc_FillLongWord :TFillLongWordProc;

procedure CRC32 (p: pointer; ByteCount: LongWord; VAR CRCValue: LongWord);
   // The following is a little cryptic (but executes very quickly).
   // The algorithm is as follows:
   // 1. exclusive-or the input byte with the low-order byte of
   // the CRC register to get an INDEX
   // 2. shift the CRC register eight bits to the right
   // 3. exclusive-or the CRC register with the contents of Table[INDEX]
   // 4. repeat steps 1 through 3 for all bytes
VAR
  i:  LongWord;
  q: ^BYTE;
BEGIN
 q := p;
 FOR i := 0 TO ByteCount-1 DO
 BEGIN
   CRCvalue := (CRCvalue SHR 8) XOR _CRC_Table32[ q^ XOR (CRCvalue AND $000000FF) ];
   INC(q)
 END
END {CalcCRC32};


function StringCRC32(const s : string ) : LongWord;
begin
 Result := 0;
 if length(s) > 0 then CRC32(@(s[1]), LENGTH(s), Result);
end;


function StringToWideString(const str: String): WideString;
var strUTF8: String;
begin
 strUTF8 := CP1252ToUTF8(str);
 result := UTF8ToUTF16(strUTF8);
end;

function UTF8ToWideString(const s: AnsiString): WideString;
// Based on Mike Lischke's function (Unicode.pas unit, http://www.delphi-gems.com)
const
 bytesFromUTF8: packed array [0 .. 255] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,
   2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5);
 offsetsFromUTF8: array [0 .. 5] of Cardinal = ($00000000, $00003080, $000E2080, $03C82080, $FA082080, $82082080);
 MaximumUCS2: Cardinal                       = $0000FFFF;
 MaximumUCS4: Cardinal                       = $7FFFFFFF;
 ReplacementCharacter: Cardinal              = $0000FFFD;
 halfShift: Integer                          = 10;
 halfBase: Cardinal                          = $0010000;
 halfMask: Cardinal                          = $3FF;
 SurrogateHighStart: Cardinal                = $D800;
 SurrogateLowStart: Cardinal                 = $DC00;
var
 sLength, L, J, T:  Cardinal;
 ch:                Cardinal;
 extraBytesToWrite: Word;
begin
 sLength := Length(s);
 if sLength = 0 then
 begin
   Result := '';
   Exit;
 end;

 SetLength(Result, sLength); // create enough room

 L := 1;
 T := 1;
 while L <= Cardinal(sLength) do
 begin
   ch                := 0;
   extraBytesToWrite := bytesFromUTF8[Ord(s[L])];
   for J             := extraBytesToWrite downto 1 do
   begin
     ch := ch + Ord(s[L]);
     Inc(L);
     ch := ch shl 6;
   end;
   ch := ch + Ord(s[L]);
   Inc(L);
   ch := ch - offsetsFromUTF8[extraBytesToWrite];

   if ch <= MaximumUCS2 then
   begin
     Result[T] := WideChar(ch);
     Inc(T);
   end
   else if ch > MaximumUCS4 then
   begin
     Result[T] := WideChar(ReplacementCharacter);
     Inc(T);
   end
   else
   begin
     ch        := ch - halfBase;
     Result[T] := WideChar((ch shr halfShift) + SurrogateHighStart);
     Inc(T);
     Result[T] := WideChar((ch and halfMask) + SurrogateLowStart);
     Inc(T);
   end;
 end;
 SetLength(Result, T - 1); // now fix up length
end;


function ReverseBits(b: Byte): Byte;
 var c: Byte;
 begin
   c := b;
   c := ((c shr 1) and $55) or ((c shl 1) and $AA);
   c := ((c shr 2) and $33) or ((c shl 2) and $CC);
   c := ((c shr 4) and $0F) or ((c shl 4) and $F0);
   result := c;
 end;

{$IFNDEF NO_ASM_OPTIMIZATIONS}
function Clamp(const V,Min,Max : integer) : integer; assembler; nostackframe;
asm
{$IFDEF CPU64}
        MOV     EAX,ECX
        MOV     ECX,R8D
{$ENDIF}
        CMP     EDX,EAX
        CMOVG   EAX,EDX
        CMP     ECX,EAX
        CMOVL   EAX,ECX
end;
{$ELSE}
function Clamp(const V,Min,Max : integer) : integer;
begin
  if V > Max then begin result := Max; exit; end else
  if V < Min then begin result := Min; exit; end else
  Result := V;
end;
{$ENDIF}


function ClampMin(const V,aMin:Single):  Single;
begin
  if V < aMin then result := aMin
  else result := V;
end;

function Clamp(const V,Min,Max : Single) : Single;
begin
  if V > Max then begin result := Max; exit; end else
  if V < Min then begin result := Min; exit; end else
  Result := V;
end;

{$IFNDEF NO_ASM_OPTIMIZATIONS}
function ClampByte(const Value: Integer): Byte; assembler; nostackframe;
asm
{$IFDEF CPU64}
  {$IFDEF UNIX}
        MOV     EAX,EDI
  {$ELSE}
        // in win x64 calling convention parameters are passed in ECX, EDX, R8 & R9
        MOV     EAX,ECX
  {$ENDIF}
{$ENDIF}
        TEST    EAX,$FFFFFF00
        JNZ     @above
        RET
@above:
        JS      @below
        MOV     EAX,$FF
        RET
@Below:     XOR     EAX,EAX
end;
{$ELSE}
function ClampByte(const Value: Integer): Byte;
begin
 if Value > 255 then
   Result := 255
 else
 if Value < 0 then
   Result := 0
 else
   Result := Value;
end;
{$ENDIF}


{$IFNDEF NO_ASM_OPTIMIZATIONS}
function ClampMax(Const Value, Max:Integer):Integer; assembler; nostackframe;
asm
{$IFDEF CPU64}
  {$IFDEF UNIX}
   MOV     EAX,EDI
  {$ELSE}
// en 64bit les paramètres sont passés à ECX, EDX, R8 & R9
  MOV     EAX,ECX
  {$ENDIF}
{$ENDIF}
  CMP     EAX,EDX
  JG      @@above
  TEST    EAX,EAX
  JL      @@below
  RET
  @@above:
  MOV     EAX,EDX
  RET
  @@below:
  MOV     EAX,0
  RET
end;
{$ELSE}
function ClampMax(Const Value, Max:Integer):Integer;
begin
  result:=value;
  if Value > Max then result:=Max;
  if Value<0 then result:=0;

end;

{$ENDIF}

function Sar(const AValue: integer; const AShift: Byte): Integer;
begin
  if AValue < 0 then
    Result := not (not AValue shr AShift)
  else
    Result := AValue shr AShift;
end;

{$IFNDEF NO_ASM_OPTIMIZATIONS}
procedure Swap(var A, B: Integer); assembler;nostackframe;register;
asm
// EAX = [A]
// EDX = [B]
 MOV     ECX,[EAX]     // ECX := [A]
 XCHG    ECX,[EDX]     // ECX <> [B];
 MOV     [EAX],ECX     // [A] := ECX
end;
{$ELSE}
procedure Swap(var A, B: Integer);
var
  T: Integer;
begin
  T := A;
  A := B;
  B := T;
end;
{$ENDIF}


{$IFNDEF NO_ASM_OPTIMIZATIONS}
procedure Swap(var X, Y: Word);  assembler;nostackframe;register;
asm
    mov cx, [edx]
    xchg word ptr [eax], cx
    mov [edx], cx
end;
{$ELSE}
procedure Swap(var X, Y: Word);
var F: Word;
begin
  F := X;
  X := Y;
  Y := F;
end;
{$ENDIF}

// swaps high and low byte of 16 bit values
// EAX contains P, EDX contains Count
{$IFNDEF NO_ASM_OPTIMIZATIONS}
procedure SwapShort(P: PWord; Count: Cardinal);assembler;
asm
        TEST    EDX, EDX
        JZ      @@Finish
@@Loop:
        MOV     CX, [EAX]
        XCHG    CH, CL
        MOV     [EAX], CX
        ADD     EAX, 2
        DEC     EDX
        JNZ     @@Loop
@@Finish:
end;
{$ELSE}
procedure SwapShort(P: PWord; Count: Cardinal);
var i: Integer;
begin
  for i := Count-1 downto 0 do begin
    P^ := ((P^ and $FF00) shr 8) or ((P^ and $00FF) shl 8);
    inc(P);
  end;
end;
{$ENDIF}
//----------------------------------------------------------------------------------------------------------------------

// swaps high and low bytes of 32 bit values
// EAX contains P, EDX contains Count
{$IFNDEF NO_ASM_OPTIMIZATIONS}
procedure SwapLong(P: PInteger; Count: Cardinal); assembler;
asm
        TEST    EDX, EDX
        JZ      @@Finish
@@Loop:
        MOV     ECX, [EAX]
        BSWAP   ECX
        MOV     [EAX], ECX
        ADD     EAX, 4
        DEC     EDX
        JNZ     @@Loop
@@Finish:

end;
{$ELSE}
procedure SwapLong(P: PInteger; Count: Cardinal);
var i: Integer;
begin
  for i := Count-1 downto 0 do begin
    P^ := ((P^ and $FF000000) shr 24) or ((P^ and $00FF0000) shr 8) or
          ((P^ and $0000FF00) shl 8) or  ((P^ and $000000FF) shl 24);
    inc(P);
  end;
end;
{$ENDIF}
//----------------------------------------------------------------------------------------------------------------------

// Swaps high and low bytes of the given 32 bit value.
{$IFNDEF NO_ASM_OPTIMIZATIONS}
function SwapLong(Value: Cardinal): Cardinal;assembler;
asm
   BSWAP   EAX
end;
{$ELSE}
function SwapLong(Value: Cardinal): Cardinal;
begin
  Result := ((Value and $FF000000) shr 24) or ((Value and $00FF0000) shr 8) or
            ((Value and $0000FF00) shl 8) or ((Value and $000000FF) shl 24);
end;
{$ENDIF}
//----------------------------------------------------------------------------------------------------------------------

// Swaps high and low bytes of the given 32 bit value.
{$IFNDEF NO_ASM_OPTIMIZATIONS}

function SwapLong(Value: Integer): Integer;assembler;
asm
  BSWAP   EAX
end;
{$ELSE}
function SwapLong(Value: Integer): Integer;
begin
  Result := ((Value and $FF000000) shr 24) or ((Value and $00FF0000) shr 8) or
            ((Value and $0000FF00) shl 8) or ((Value and $000000FF) shl 24);
end;
{$ENDIF}

(*function SwapLongWord (Value : longword) : longword;
begin
  result:=(Value and $FF) shl 24 +
          (Value and $FF00) shl 8 +
          (Value and $FF0000) shr 8 +
          (Value and $FF000000) shr 24;
end; *)

//----------------------------------------------------------------------------------------------------------------------

procedure SwapDouble(const Source; var Target);
// Reverses the byte order in Source which must be 8 bytes in size (as well as the target).
var
  I: Int64;

begin
  I := Int64(Source);
  Int64(Target) := SwapLong(Cardinal(I shr 32)) + Int64(SwapLong(Cardinal(I))) shl 32;
end;


{$IFNDEF NO_ASM_OPTIMIZATIONS}
function MulDiv(Multiplicand, Multiplier, Divisor: Integer): Integer;assembler; nostackframe;
{$IFDEF CPU32}
asm
        PUSH    EBX             // Imperative save
        PUSH    ESI             // of EBX and ESI

        MOV     EBX, EAX        // Result will be negative or positive so set rounding direction
        XOR     EBX, EDX        //  Negative: substract 1 in case of rounding
        XOR     EBX, ECX        //  Positive: add 1

        OR      EAX, EAX        // Make all operands positive, ready for unsigned operations
        JNS     @m1Ok           // minimizing branching
        NEG     EAX
@m1Ok:
        OR      EDX, EDX
        JNS     @m2Ok
        NEG     EDX
@m2Ok:
        OR      ECX, ECX
        JNS     @DivOk
        NEG     ECX
@DivOK:
        MUL     EDX             // Unsigned multiply (Multiplicand*Multiplier)

        MOV     ESI, EDX        // Check for overflow, by comparing
        SHL     ESI, 1          // 2 times the high-order 32 bits of the product (EDX)
        CMP     ESI, ECX        // with the Divisor.
        JAE     @Overfl         // If equal or greater than overflow with division anticipated

        DIV     ECX             // Unsigned divide of product by Divisor

        SUB     ECX, EDX        // Check if the result must be adjusted by adding or substracting
        CMP     ECX, EDX        // 1 (*.5 -> nearest integer), by comparing the difference of
        JA      @NoAdd          // Divisor and remainder with the remainder. If it is greater then
        INC     EAX             // no rounding needed; add 1 to result otherwise
@NoAdd:
        OR      EBX, EDX        // From unsigned operations back the to original sign of the result
        JNS     @Exit           // must be positive
        NEG     EAX             // must be negative
        JMP     @Exit
@Overfl:
        OR      EAX, -1         //  3 bytes alternative for MOV EAX,-1. Windows.MulDiv "overflow"
                                //  and "zero-divide" return value
@Exit:
        POP     ESI             // Restore
        POP     EBX             // esi and EBX
end;
{$ENDIF}
{$IFDEF CPU64}
asm
        MOV     EAX, ECX        // Result will be negative or positive so set rounding direction
        XOR     ECX, EDX        //  Negative: substract 1 in case of rounding
        XOR     ECX, R8D        //  Positive: add 1

        OR      EAX, EAX        // Make all operands positive, ready for unsigned operations
        JNS     @m1Ok           // minimizing branching
        NEG     EAX
@m1Ok:
        OR      EDX, EDX
        JNS     @m2Ok
        NEG     EDX
@m2Ok:
        OR      R8D, R8D
        JNS     @DivOk
        NEG     R8D
@DivOK:
        MUL     EDX             // Unsigned multiply (Multiplicand*Multiplier)

        MOV     R9D, EDX        // Check for overflow, by comparing
        SHL     R9D, 1          // 2 times the high-order 32 bits of the product (EDX)
        CMP     R9D, R8D        // with the Divisor.
        JAE     @Overfl         // If equal or greater than overflow with division anticipated

        DIV     R8D             // Unsigned divide of product by Divisor

        SUB     R8D, EDX        // Check if the result must be adjusted by adding or substracting
        CMP     R8D, EDX        // 1 (*.5 -> nearest integer), by comparing the difference of
        JA      @NoAdd          // Divisor and remainder with the remainder. If it is greater then
        INC     EAX             // no rounding needed; add 1 to result otherwise
@NoAdd:
        OR      ECX, EDX        // From unsigned operations back the to original sign of the result
        JNS     @Exit           // must be positive
        NEG     EAX             // must be negative
        JMP     @Exit
@Overfl:
        OR      EAX, -1         //  3 bytes alternative for MOV EAX,-1. Windows.MulDiv "overflow"
                                //  and "zero-divide" return value
@Exit:
end;
{$ENDIF}
{$ELSE}
function MulDiv(Multiplicand, Multiplier, Divisor: Integer): Integer;
begin
  Result := Int64(Multiplicand) * Int64(Multiplier) div Divisor;
end;
{$ENDIF}

function percentRatio(Const Max:Integer;Const apercent:Integer):Integer;
Begin
  result := MulDiv(Max, apercent, 100)
End;

function percent(Const Max:Integer;Const Current:Integer):Integer;
Begin
  result := MulDiv(Current, 100, Max)
End;

//------------------------------------------------------------------------------
// Fix les problème de délimiteur de path suivant le systeme
procedure FixPathDelimiter(var S: string);
var
  I: Integer;
begin
  for I := Length(S) downto 1 do
    if (S[I] = '/') or (S[I] = '\') then
      S[I] := PathDelim;
end;

function GetBit(const AValue: DWORD; const Bit: Byte): Boolean;
begin
  Result := (AValue and (1 shl Bit)) <> 0;
end;

function GetBits(const AValue: DWORD;const AIndex, numbits: Integer): Integer;
var
  Offset: Integer;
  BitCount: Integer;
  Mask: Integer;
begin
  BitCount := AIndex and numbits; //FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (AValue shr Offset) and Mask;
end;

function ClearBit(const AValue: DWORD; const Bit: Byte): DWORD;
begin
  Result := AValue and not (1 shl Bit);
end;

function SetBit(const AValue: DWORD; const Bit: Byte): DWORD;
begin
  Result := AValue or (DWORD(1) shl DWORD(Bit));
end;

function EnableBit(const AValue: DWORD; const Bit: Byte; const Enable: Boolean): DWORD;
begin
  Result := (AValue or (DWORD(1) shl Bit)) xor (DWord(not Enable) shl Bit);
end;

function GetBitsValue(const AValue: DWORD; const BitI, BitF: Byte): DWORD;
var
 i,j : Byte;
begin
 Result:=0;
  j:=0;
  for i := BitF to BitI do
  begin
    if GetBit(AValue, i) then
       Result:=Result+ (DWORD(1) shl j);
    inc(j);
  end;
end;

function CountBits(Value: byte): shortint;
var
  i, bits: shortint;
begin
  bits := 0;
  for i := 0 to 7 do
  begin
    if (value mod 2) <> 0 then
      inc(bits);
    value := value shr 1;
  end;
  Result := bits;
end;

function ShiftCount(Mask: DWORD): shortint;
var
  tmp: shortint;

begin
  tmp := 0;

  if Mask = 0 then
  begin
    Result := 0;
    exit;
  end;

  while (Mask mod 2) = 0 do // rightmost bit is 0
  begin
    inc(tmp);
    Mask := Mask shr 1;
  end;
  tmp := tmp - (8 - CountBits(Mask and $FF));
  Result := tmp;
end;

procedure FillLongword(var X; Count: Integer; Value: Longword);
begin
 Proc_FillLongWord(X,Count,Value);
end;

procedure nc_FillLongword(var X; Count: Integer; Value: Longword);
var
  I: Integer;
  P: PLongWordArray ;
begin
  P := PLongWordArray (@X);
 // for I := Count - 1 downto 0 do
  I:=Count-1;
  While I>=0 do
  begin
    P^[I] :=LongWord(Value);
    Dec(I);
  End;
end;

{$IFNDEF NO_ASM_OPTIMIZATIONS}
procedure asm_sse2_FillLongword(var X; Count: Integer; Value: Longword); assembler; nostackframe;
{$IFDEF CPU32}
asm
        // EAX = X;   EDX = Count;   ECX = Value

        TEST       EDX, EDX        // if Count = 0 then
        JZ         @Exit           //   Exit

        PUSH       EDI             // push EDI on stack
        MOV        EDI, EAX        // Point EDI to destination

        CMP        EDX, 32
        JL         @SmallLoop

        AND        EAX, 3          // get aligned count
        TEST       EAX, EAX        // check if X is not dividable by 4
        JNZ        @SmallLoop      // otherwise perform slow small loop

        MOV        EAX, EDI
        SHR        EAX, 2          // bytes to count
        AND        EAX, 3          // get aligned count
        ADD        EAX,-4
        NEG        EAX             // get count to advance
        JZ         @SetupMain
        SUB        EDX, EAX        // subtract aligning start from total count

@AligningLoop:
        MOV        [EDI], ECX
        ADD        EDI, 4
        DEC        EAX
        JNZ        @AligningLoop

@SetupMain:
        MOV        EAX, EDX        // EAX = remaining count
        SHR        EAX, 2
        SHL        EAX, 2
        SUB        EDX, EAX        // EDX = remaining count
        SHR        EAX, 2

        MOVD       XMM0, ECX
        PUNPCKLDQ  XMM0, XMM0
        PUNPCKLDQ  XMM0, XMM0
@SSE2Loop:
        MOVDQA     [EDI], XMM0
        ADD        EDI, 16
        DEC        EAX
        JNZ        @SSE2Loop

@SmallLoop:
        MOV        EAX,ECX
        MOV        ECX,EDX

        REP        STOSD           // Fill count dwords

@ExitPOP:
        POP        EDI

@Exit:
end;
{$ENDIF}
{$IFDEF CPU64}
asm
        // RCX = X;   RDX = Count;   R8 = Value

        TEST       RDX, RDX        // if Count = 0 then
        JZ         @Exit           //   Exit

        MOV        R9, RCX         // Point R9 to destination

        CMP        RDX, 32
        JL         @SmallLoop

        AND        RCX, 3          // get aligned count
        TEST       RCX, RCX        // check if X is not dividable by 4
        JNZ        @SmallLoop      // otherwise perform slow small loop

        MOV        RCX, R9
        SHR        RCX, 2          // bytes to count
        AND        RCX, 3          // get aligned count
        ADD        RCX,-4
        NEG        RCX             // get count to advance
        JZ         @SetupMain
        SUB        RDX, RCX        // subtract aligning start from total count

@AligningLoop:
        MOV        [R9], R8D
        ADD        R9, 4
        DEC        RCX
        JNZ        @AligningLoop

@SetupMain:
        MOV        RCX, RDX        // RCX = remaining count
        SHR        RCX, 2
        SHL        RCX, 2
        SUB        RDX, RCX        // RDX = remaining count
        SHR        RCX, 2

        MOVD       XMM0, R8D
        PUNPCKLDQ  XMM0, XMM0
        PUNPCKLDQ  XMM0, XMM0
@SSE2Loop:
        MOVDQA     [R9], XMM0
        ADD        R9, 16
        DEC        RCX
        JNZ        @SSE2Loop

        TEST       RDX, RDX
        JZ         @Exit
@SmallLoop:
        MOV        [R9], R8D
        ADD        R9, 4
        DEC        RDX
        JNZ        @SmallLoop
@Exit:
end;
{$ENDIF}
{$ENDIF}


{$IFNDEF NO_ASM_OPTIMIZATIONS}
procedure FillWord(var X; Count: Cardinal; Value: LongWord);assembler; nostackframe;
{$IFDEF CPU32}
asm
        // EAX = X;   EDX = Count;   ECX = Value
        PUSH    EDI

        MOV     EDI,EAX  // Point EDI to destination
        MOV     EAX,ECX
        MOV     ECX,EDX
        TEST    ECX,ECX
        JZ      @exit

        REP     STOSW    // Fill count words
@exit:
        POP     EDI
end;
{$ENDIF}
{$IFDEF CPU64}
asm
        // ECX = X;   EDX = Count;   R8D = Value
        PUSH    RDI

        MOV     RDI,RCX  // Point EDI to destination
        MOV     EAX,R8D
        MOV     ECX,EDX
        TEST    ECX,ECX
        JZ      @exit

        REP     STOSW    // Fill count words
@exit:
        POP     RDI
end;
{$ENDIF}
{$ELSE}
procedure FillWord(var X; Count: Cardinal; Value: LongWord);
var
  I: Integer;
  P: PWordArray;
begin
  P := PWordArray(@X);
  for I := Count - 1 downto 0 do
   P^[I] := Value;
end;
 {$ENDIF}

{$IFNDEF NO_ASM_OPTIMIZATIONS}
procedure MoveLongword(const Source; var Dest; Count: Integer); assembler; nostackframe;
{$IFDEF CPU32}
asm
        // EAX = Source;   EDX = Dest;   ECX = Count
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX
        CMP     EDI,ESI
        JE      @exit

        REP     MOVSD
@exit:
        POP     EDI
        POP     ESI
end;
{$ENDIF}
{$IFDEF CPU64}
asm
        // RCX = Source;   RDX = Dest;   R8 = Count
        PUSH    RSI
        PUSH    RDI

        MOV     RSI,RCX
        MOV     RDI,RDX
        MOV     RCX,R8
        CMP     RDI,RSI
        JE      @exit

        REP     MOVSD
@exit:
        POP     RDI
        POP     RSI
end;
{$ENDIF}
{$ELSE}
procedure MoveLongword(const Source; var Dest; Count: Integer);
begin
  Move(Source, Dest, Count shl 2);
end;
{$ENDIF}

{$IFNDEF NO_ASM_OPTIMIZATIONS}
procedure MoveWord(const Source; var Dest; Count: Integer); assembler; nostackframe;
{$IFDEF CPU32}
asm
        // EAX = X;   EDX = Count;   ECX = Value
        PUSH    ESI
        PUSH    EDI

        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EAX,ECX
        CMP     EDI,ESI
        JE      @exit

        REP     MOVSW
@exit:
        POP     EDI
        POP     ESI
end;
{$ENDIF}
{$IFDEF CPU64}
asm
        // ECX = X;   EDX = Count;   R8 = Value
        PUSH    RSI
        PUSH    RDI

        MOV     RSI,RCX
        MOV     RDI,RDX
        MOV     RAX,R8
        CMP     RDI,RSI
        JE      @exit

        REP     MOVSW
@exit:
        POP     RDI
        POP     RSI
end;
{$ENDIF}
{$ELSE}
procedure MoveWord(const Source; var Dest; Count: Integer);
begin
  Move(Source, Dest, Count shl 1);
end;
{$ENDIF}

procedure RegisterGLZUtilsFunctions();
begin
  {$IFNDEF NO_ASM_OPTIMIZATIONS}
  if CPU_HasFeature(cfSSE) then
  begin
    Proc_FillLongWord:=@asm_sse2_FillLongword;
  end
  else
  begin
    Proc_FillLongWord:=@nc_FillLongword;
  end;
  {$ELSE}
    Proc_FillLongWord:=@nc_FillLongword;
  {$ENDIF}
end;

initialization
begin
{$ifndef VALGRIND}
  RegisterGLZUtilsFunctions();
{$endif}  
end;
end.

