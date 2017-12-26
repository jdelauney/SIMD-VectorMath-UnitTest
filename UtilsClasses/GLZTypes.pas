(*====< GLZTypes.pas >==========================================================@br
  @created(2018-11-16)
  @author(J.Delauney (BeanzMaster))
  Historique : @br
  @unorderedList(
    @item(18/11/2016 : Creation  )
  )
--------------------------------------------------------------------------------@br

  @bold(Description :)@br
  L'unité GLZTypes regroupe majoritairement les types et constantes relative
  aux classes de la librairie. @br
  Cela évite ainsi de se retouver avec des déclarations redontantes ou appels circulaires.

  ------------------------------------------------------------------------------@br

  @bold(Note :)@br Cette unité est à ajouter à la clause uses dans TOUTES les unités et projets
  utilisant la librairie.

  ------------------------------------------------------------------------------@br

  @bold(Credits :)
     @unorderedList(
       @item(FPC/Lazarus)
     )

  ------------------------------------------------------------------------------@br
  LICENCE : MPL / GPL @br
  @br
 *==============================================================================*)

Unit GLZTypes;

{.$i ..\glzscene_options.inc}

Interface

Uses
  LCLIntf, LCLType,
  Classes, SysUtils, types, Graphics,
  GLZVectorMath;


//==============================================================================

{%region%=====[ Re/définitions de quelques types standard ]====================}

 {
   Ces nouveaux types ont été ajoutés pour être en mesure de gérer des pointeurs
   vers des entiers en mode 64 bits, car dans FPC 'Integer' le type est toujours
   32 bits (ou 16 bits en mode Pascal), mais dans Delphi il est spécifique à la
   plate-forme et peut être 16 , 32 ou 64 bits.
   Et on utilise ainsi des types uniformisés
 @groupbegin }

Type
   {$IFDEF CPU64}
  Int     = Int64;
  UInt    = UInt64;
  PtrInt  = Int64;
 // PtrUInt = UInt64; //QWord;
  {$Else}
  Int     = Integer;
  UInt    = Cardinal;
  PtrInt  = Integer;
  PtrUInt = Cardinal;  //DWord
  {$ENDIF}

  {Types de données nécessaires pour le calcul des graphiques 3D ou autres.
   Alias comme en C, afin d'être en conformité avec la notation
   des types définis dans OpenGL entre autres }
  PByte     = ^Byte;
  PWord     = ^Word;
  PInteger  = ^Integer;
  PCardinal = ^Cardinal;
  PSingle   = ^Single;
  PDouble   = ^Double;
  PExtended = ^Extended;
  PPointer  = ^Pointer;

  DWORD  = System.DWORD;
  TPoint = Types.TPoint;
  PPoint = ^TPoint;
  TRect  = Types.TRect;
  PRect  = ^TRect;
  { @groupend }

Type
  { Tableau de bytes
  @groupbegin }
  TByteArray = Array[0..MaxInt - 1] Of Byte;
  PByteArray = ^TByteArray;
  { @groupend }

{ Quelques constantes basique et utiles
  @groupbegin }
Const
  MinByte     = Low(Byte);
  MaxByte     = High(Byte);
  MinWord     = Low(Word);
  MaxWord     = High(Word);
  MinShortInt = Low(Shortint);
  MaxShortInt = High(Shortint);
  MinSmallInt = Low(Smallint);
  MaxSmallInt = High(Smallint);
  MinLongWord = Longword(Low(Longword));
  MaxLongWord = Longword(High(Longword));
  MinLongInt  = Longint(Low(Longint));
  MaxLongInt  = Longint(High(Longint));
  MaxInt64    = Int64(High(Int64));
  MinInt64    = Int64(Low(Int64));
  MinInteger  = Integer(Low(Integer));
  MaxInteger  = Integer(High(Integer));
  MinCardinal = Cardinal(Low(Cardinal));
  MaxCardinal = Cardinal(High(Cardinal));

  cMaxArray = (MaxInt Shr 4);

  BitsPerByte      = 8;
  BitsPerWord      = 16;
  BitsPerLongWord  = 32;
  BytesPerCardinal = Sizeof(Cardinal);
  BitsPerCardinal  = BytesPerCardinal * 8;

  MinSingle: Single = 1.5E-45;
  MaxSingle: Single = 3.4E+38;
  MinDouble: Double = 5.0E-324;
  MaxDouble: Double = 1.7E+308;
  MinExtended: Extended = 3.4E-4932;
  //  MaxExtended : Extended = 1.1E+4932;
  MinCurrency = -922337203685477.5807;
  MaxCurrency = 922337203685477.5807;

  ZERO_RECT: TRect = (Left: 0; Top: 0; Right: 0; Bottom: 0);
  { @groupend }
Type
 { Real types :
    Floating point:
      Single    32 bits  7-8 significant digits
      Double    64 bits  15-16 significant digits
      Extended  80 bits  19-20 significant digits

    Fixed point:
      Currency  64 bits  19-20 significant digits, 4 after the decimal point.
 @group begin }
  FloatX  = Extended;
  PFloatX = ^FloatX;

  TExtended80Rec = Packed Record
    Case Integer Of
      1: (Bytes: Array[0..9] Of Byte);
      2: (Float: Extended);
  End;
{ @groupend }

{%endregion%}

{%region%=====[ Types/Variables "mathematique" ]===============================}



Type
  { Types utiles pour le travail avec les vecteurs 2D/3D. @br
    Désactiver la vérification des limites pour accéder aux valeurs au-delà de ces limites (non-recommandé)
  @groupbegin }
  {$IFDEF USE_EXTENDED}
  PFloat    = PDouble;
  {$ELSE}
  PFloat    = PSingle;
  {$ENDIF}
  PTexPoint = ^TTexPoint;

  TTexPoint = Packed Record
    S, T: Single;
  End;

  PByteVector      = ^TByteVector;
  PByteVectorArray = PByteVector;
  TByteVector      = Array [0 .. cMaxArray] Of Byte;

  PWordVector = ^TWordVector;
  TWordVector = Array [0 .. cMaxArray] Of Word;

  PIntegerVector = ^TIntegerVector;
  PIntegerArray  = PIntegerVector;
  TIntegerVector = Array [0 .. cMaxArray] Of Integer;

  PFloatVector = ^TFloatVector;
  PFloatArray  = PFloatVector;
  PSingleArray = PFloatArray;
  TFloatVector = Array [0 .. cMaxArray] Of Single;
  TSingleArray = Array Of Single;

  PDoubleVector = ^TDoubleVector;
  PDoubleArray  = PDoubleVector;
  TDoubleVector = Array [0 .. cMaxArray] Of Double;

  PExtendedVector = ^TExtendedVector;
  PExtendedArray  = PExtendedVector;
  TExtendedVector = Array [0 .. cMaxArray] Of Extended;

  PPointerVector = ^TPointerVector;
  PPointerArray  = PPointerVector;
  TPointerVector = Array [0 .. cMaxArray] Of Pointer;

  TCardinalArray = Array [0 .. cMaxArray] Of Cardinal;
  PCardinalArray = ^TCardinalArray;

  PLongWordVector = ^TLongWordVector;
  PLongWordArray  = PLongWordVector;
  TLongWordVector = Array [0 .. cMaxArray] Of Longword;


//  PBZVectorArray  = ^TGLZVectorArray;
//  TGLZVectorArray = Array [0 .. cMaxArray Shr 1] Of TGLZVector;

//  TGLZQuad2D = array[0..3] of TGLZVector2i;
//  TGLZPolygon2D = array of TGLZVector2i;

  { @groupend }

{%endregion%}

Type
  { TGLZDataFileCapability : Capacité pour les classes de lecture et ou d'ecriture de données dans un fichier
    cf @link(TGLZCustomDataFile)

  @groupbegin }
  TGLZDataFileCapability   = (dfcRead, dfcWrite);
  TGLZDataFileCapabilities = Set Of TGLZDataFileCapability;
  { @groupend }


type
  // Une entrée de la pile de progression pour les sections imbriquées.
  PGLZProgressSection = ^TGLZProgressSection;
  TGLZProgressSection = record
    Position,                //< Position actuelle (en %)
    ParentSize,              //< Taille de la section dans le contexte de la section parente (en %).
    TransformFactor: Single; //< Facteur accumulé pour transformer une étape dans la section en une valeur globale.
    Msg: string;             //< Message à afficher pour la section.
  end;

Type
   { TGLZProgressStage : Action de la progression (pour eviter d'utiliser l'uniter FPImage) }
   TGLZProgressStage = (opsStarting, opsRunning, opsEnding);
   { TGLZProgressEvent : Definition du type fonction pour l'evenement OnProgress }
   TGLZProgressEvent = procedure (Sender: TObject; Stage: TGLZProgressStage;
                                  PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
                                  const Msg: string; Var Continue:Boolean) of object;

Type
  { Définitions des paramètres des propriétés pour l'aspect des controls visuels.
  @groupbegin }
  TGLZHorizontalLayout = (hlLeft, hlRight, hlCenter);
  TGLZVerticalLayout = (vlTop, vlBottom, vlCenter);
  TGLZDirection   = (dToTop, dToLeft, dToBottom, dToRight);
  TGLZDirectionEx = (deToTop, deToLeft, deToBottom, deToRight, deToTopLeft, deToTopRight, deToBottomLeft, deToBottomRight);
  TGLZOrientation = (oHorizontal, oVertical);

  TGLZBorderParts = Set Of (bbTop, bbLeft, bbBottom, bbRight);
  TGLZBorderType  = (btNone, btSingle, btDouble, btRaised, btDoubleRaised, btSunken, btDoubleSunken, btBumped, btEtched, btFramed);

  TGLZBackgroundType = (bkgTransparent, bkgFlat, bkgGradient, bkgTexture);

  TGLZShapeType = (stRect, stRoundRect, stEllipse);
  // bsTriangleLeft, bsTriangleRight, bsTriangleUp, bsTriangleDown, bsOctogon, bsHexagon, bsCustom

  TGLZRoundingType = (rtRounded, rtSquared);
  // + rtRoundedLeft, rtRoundedRight, rtSquaredLeft, rtSquaredRight
  TGLZTextStyle    = (tsDefault, tsBevel, tsRaised, tsEmbossed, tsContour);
  { @groupend }

  { TGLZCanvasPenStrokePattern : Tableau type pour definir une "Patterne" }
  TGLZCanvasPenStrokePattern = array of boolean;

  { TGLZCanvasPenStrokePattern : Tableau type pour definir une "Patterne" pour la brosse
  @groupbegin }
  TGLZBrushPattern = array[0..31] of TGLZCanvasPenStrokePattern;
  PGLZBrushPattern = ^TGLZBrushPattern;
  { @groupend }

  { TGLZBrushStyle : Style des differentes brosses pour le Canvas }
  TGLZBrushStyle = (bsClear, bsSolid, bsGradient, bsTexture, bsPattern);
  TGLZGradientStyle = (gsHorizontal, gsVertical,
                       gsFromTopLeft,gsFromTopRight,
                      // gsTopRightToBottomLeft,gsBottomLeftToTopRight,
                       gsRadial,gdCustomAngle, gsPyramid);
  { Autres Types utiles
  @groupbegin }
  TGLZPercentValue = 1 .. 100;
  TGLZInterpolationType = (itLinear, itPower, itSin, itSinAlt, itTan, itLn, itExp);
  { @groupend }
type
  TGLZEaseType= (
    etLinear,
    etQuadIn,
    etQuadOut,
    etQuadInOut,
    etQuadOutIn,
    etCubicIn,
    etCubicOut,
    etCubicInOut,
    etCubicOutIn,
    etQuintIn,
    etQuintOut,
    etQuintInOut,
    etQuintOutIn,
    etSineIn,
    etSineOut,
    etSineInOut,
    etSineOutIn,
    etCircIn,
    etCircOut,
    etCircInOut,
    etCircOutIn,
    etExpoIn,
    etExpoOut,
    etExpoInOut,
    etExpoOutIn,
    etElasticIn,
    etElasticOut,
    etElasticInOut,
    etElasticOutIn,
    etBackIn,
    etBackOut,
    etBackInOut,
    etBackOutIn,
    etBounceIn,
    etBounceOut,
    etBounceInOut,
    etBounceOutIn
  );
Const
  { Constantes pour les vecteurs
  @groupbegin }
  XYZVector: TGLZVector = (X: 1; Y: 1; Z: 1; W: 0);
  XHmgVector: TGLZVector = (X: 1; Y: 0; Z: 0; W: 0);
  YHmgVector: TGLZVector = (X: 0; Y: 1; Z: 0; W: 0);
  ZHmgVector: TGLZVector = (X: 0; Y: 0; Z: 1; W: 0);
  WHmgVector: TGLZVector = (X: 0; Y: 0; Z: 0; W: 1);
  XYHmgVector: TGLZVector = (X: 1; Y: 1; Z: 0; W: 0);
  YZHmgVector: TGLZVector = (X: 0; Y: 1; Z: 1; W: 0);
  XZHmgVector: TGLZVector = (X: 1; Y: 0; Z: 1; W: 0);
  XYZHmgVector: TGLZVector = (X: 1; Y: 1; Z: 1; W: 0);
  XYZWHmgVector: TGLZVector = (X: 1; Y: 1; Z: 1; W: 1);
  NullHmgVector: TGLZVector = (X: 0; Y: 0; Z: 0; W: 0);
  { @groupend }

  { Autres Constantes
  @groupbegin }
  Bool2StrEN: Array[Boolean] Of String = ('False', 'True');
  Bool2StrFR: Array[Boolean] Of String = ('Non', 'Oui');

  { DefaultVirtualBufferSize : Par defaut le tampon alloué à la lecture des données est de 64Mo }
  DefaultVirtualBufferSize = 64 Shl 20;
  { DefaultCharsDelims : filtre entre les mots dans un texte }
  DefaultCharsDelims = #8#9#10#13#32;
  { @groupend }

Implementation

End.
