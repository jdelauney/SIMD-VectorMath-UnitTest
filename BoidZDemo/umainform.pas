unit umainform;

{$mode objfpc}{$H+}

// ALIGNEMENT
{$ifdef cpu64}
  {$ALIGN 16}

  {$CODEALIGN CONSTMIN=16}
  {$CODEALIGN LOCALMIN=16}
  {$CODEALIGN VARMIN=16}
{$endif}

{$ifdef Windows}
 {$define USE_FRAMEBUFFER}
{$else}
 {$define USE_CANVAS}
 {.$define USE_FRAMEBUFFER}
{$endif}


{===============================================================================
 D'après le code source original en delphi :
 Licence : Creative Common
 - http://codes-sources.commentcamarche.net/source/46214-boids-de-craig-reynoldsAuteur  : cs_barbichetteDate    : 03/08/2013

 Description :
 =============

 C'est une simulation de vol d'oiseau en groupe (ou de banc de poisson)
 Créer par Craig Reynolds, cette simulation se base sur un algo simple

 3 forces agissent sur chaque individu (boids):
 - chaque boids aligne sa direction sur celle de ses voisins.
 - chaque boids est attiré au centre de ses voisins
 - mais chaque boids est repoussé par les autres pour éviter le surpeuplement

 Enfin, une dernière force, classique attire les boids vers la souris.
 Dans tous les cas, le boids ne réagis que par rapport aux voisins qu'il voie
 (distance max et angle de vu). Il ne voit pas les boids derrière lui ni s'ils sont trop loin.
================================================================================}
interface

uses
  LCLType, LCLIntf, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, GLZVectorMath,GLZStopWatch, GLZFastMath;

  { TMainForm }
Const
  maxboidz = 499;
  Cursor_attract = 150;
  cohesion_attract = 25;
  Align_attract = 4;
  Separation_repuls = 25;
  Vitesse_Max = 30;
  Distance_Max = 50*50;
  Angle_Vision = 90; //soit 180° au total



Type
  TMainForm = class(TForm)
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormResize(Sender : TObject);
    procedure FormShow(Sender : TObject);
  private
    {$ifdef USE_FRAMEBUFFER} FBitmapBuffer : TBitmap; {$endif}
    FCadencer : TTimer; // TGLZCadencer;
    FStopWatch : TGLZStopWatch;
    {$ifdef cpu64}
      {$CODEALIGN RECORDMIN=16}
      FBoidz : array[0..MaxBoidz] of TGLZVector4f;
      {$CODEALIGN RECORDMIN=4}
    {$else}
      FBoidz : array[0..MaxBoidz] of TGLZVector4f;
    {$endif}

    FCenterX, FCenterY : Integer;
    FrameCounter :Integer;
    aCounter : Byte;
    FColorMap : array[0..360] of longint;
    //procedure CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
    procedure CadencerProgress(Sender : TObject);
  public
    procedure EraseBackground(DC: HDC); override;

    procedure AnimateScene;
    Procedure RenderScene;
    Procedure InitScene;
    Procedure InitColorMap;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses GLZMath;
// vérifie si b1 vois b2
function CheckAngleOfView(b1,b2:TGLZVector4f):boolean;
var
 angle:extended;
 l:Single;
begin
 b1.ST :=b1.ST - b2.ST;
 angle:=abs(FastArcTangent2(b1.x,b1.y)*c180divPI);
 //angle:=abs(ArcTan2(b1.ST.x,b1.ST.y)*180/cPI);
 l:=b1.ST.LengthSquare;
 result:=(l<Distance_Max) and (angle<=Angle_Vision);
end;

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FStopWatch.Stop;
  FCadencer.Enabled := False;
  FCadencer.OnTimer := nil;
  CanClose := True;
end;

procedure TMainForm.FormCreate(Sender : TObject);
begin
  InitScene;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FStopWatch);
  FreeAndNil(FCadencer);
  {$ifdef USE_FRAMEBUFFER}FreeAndNil(FBitmapBuffer);{$endif}
end;

procedure TMainForm.FormResize(Sender : TObject);
begin
  FStopWatch.Stop;
  FCadencer.Enabled := False;
  //FBitmapBuffer.SetSize(ClientWidth,ClientHeight);
{$ifdef USE_FRAMEBUFFER}
  FBitmapBuffer.Width:=clientwidth;
  FBitmapBuffer.Height:=clientheight;
{$endif}
  FrameCounter := 0;
  FStopWatch.Start;
  FCadencer.Enabled := True;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  DoubleBuffered:=true;
  FStopWatch.Start;
  FCadencer.Enabled := True;
end;

procedure TMainForm.CadencerProgress(Sender : TObject);
begin
  AnimateScene;
  RenderScene;
  // affiche le résultat
  {$ifdef USE_FRAMEBUFFER} canvas.Draw(0,0,FBitmapBuffer); {$endif}  // DON'T WORK UNDER UNIX !!! LCL BUG ???
  Inc(FrameCounter);
  Caption:='500 BoïdZ Demo : '+Format('%.*f FPS', [3, FStopWatch.getFPS(FrameCounter)]);
end;

procedure TMainForm.AnimateScene;
var
 {$ifdef cpu64}
   {$CODEALIGN VARMIN=16}
   cohesion,balign,separation,center: TGLZVector2f;
   ct : TGLZVector2f;
   ptc : TGLZVector2f;
   {$CODEALIGN VARMIN=4}
 {$else}
   cohesion,balign,separation,center: TGLZVector2f;
   ct : TGLZVector2f;
   ptc : TGLZVector2f;
 {$endif}
 i,j:integer;
 pt:tpoint;
 c:Single;

begin
  // position de la souris

  pt.Create(FCenterX,FCenterY); //pt.Create(FBitmapBuffer.CenterX,FBitmapBuffer.CenterY);

  GetCursorPos(pt);
  pt := Mainform.ScreenToClient(pt);

  ptc.Create(pt.x,pt.y); //ptc.Create(pt.x+(-320+Random(320)),pt.y+(-240+Random(240)));
  ptc.X := ptc.x - (Mainform.ClientWidth shr 1) ;
  ptc.Y := ptc.Y - (Mainform.ClientHeight shr 1) ;

  // pour chaque boïde
  for i:=0 to maxBoidz do
  begin
   c:=0;
   cohesion.Create(0,0);
   bAlign.Create(0,0);
   separation.Create(0,0);
   // ils suivent le comportement des voisins
   // on parcours toute la liste
   for j:=0 to maxBoidz do
   begin
    // si le FBoidz J est dans le champs de vision de I
    // càd : pas trop loin et devant lui
    if (i<>j) and CheckAngleOfView(FBoidz[i],FBoidz[j]) then
     begin
      // alors on traite les 3 forces qui régissent de comportement du groupe
      c:=c+1;
      // il se rapproche du centre de masse de ses voisins
      Cohesion := Cohesion + FBoidz[j].ST;
      // il aligne sa direction sur celle des autres
      bAlign := bAlign + FBoidz[j].UV;
      // mais il s'éloigne si ils sont trop nombreux
      Separation := Separation - (FBoidz[j].ST - FBoidz[i].ST);
     end;
   end;
   // si il y a des voisins, on fini les calculs des moyennes
   if c<>0 then
    begin
      ct.Create(c,c);
      cohesion    := ((cohesion / ct) - FBoidz[i].ST) / Cohesion_attract;
      bAlign     := ((bAlign / ct) - FBoidz[i].UV) / Align_attract;
      separation := separation / Separation_Repuls;
    end;
   // la dernière force les poussent tous vers la souris
   Center := (ptc*10-FBoidz[i].ST) / Cursor_Attract;
   // on combine toutes les infos pour avoir la nouvelle vitesse
   FBoidz[i].UV := FBoidz[i].UV + cohesion + bAlign + separation + center;
   // attention, si il va trop vite, on le freine
  // c:=round(sqrt(boides[i].UV.x*boides[i].UV.x+boides[i].UV.y*boides[i].UV.y));
   c:=FBoidz[i].UV.Length;
   if c>Vitesse_Max then
    begin
     //c:=(Vitesse_Max / c);
     FBoidz[i].UV := (FBoidz[i].UV * Vitesse_Max) / c//* c;
    end;
   // on le déplace en fonction de sa vitesse
   FBoidz[i].ST := FBoidz[i].ST + (FBoidz[i].UV);

   //rebond sur les bords
   //if FBoidz[i].ST.x>FBitmapBuffer.width then FBoidz[i].UV.x:=-(FBoidz[i].UV.x)
   //else if FBoidz[i].ST.x<0 then FBoidz[i].UV.x:=-(FBoidz[i].UV.x);
   //if FBoidz[i].ST.y>FBitmapBuffer.height then FBoidz[i].UV.y:=-(FBoidz[i].UV.y)
   //else if FBoidz[i].ST.y<0 then FBoidz[i].UV.y:=-(FBoidz[i].UV.y);

   // univers fermé
   {$ifdef USE_FRAMEBUFFER}
     if FBoidz[i].ST.x>FBitmapBuffer.width then FBoidz[i].ST.x:=FBoidz[i].ST.x-FBitmapBuffer.width;
     if FBoidz[i].ST.x<0 then FBoidz[i].ST.x:=FBoidz[i].ST.x+FBitmapBuffer.width;
     if FBoidz[i].ST.y>FBitmapBuffer.height then FBoidz[i].ST.y:=FBoidz[i].ST.y-FBitmapBuffer.height;
     if FBoidz[i].ST.y<0 then FBoidz[i].ST.y:=FBoidz[i].ST.y+FBitmapBuffer.height;
   {$else}
     if FBoidz[i].ST.x>Mainform.ClientWidth then FBoidz[i].ST.x:=FBoidz[i].ST.x-Mainform.ClientWidth;
     if FBoidz[i].ST.x<0 then FBoidz[i].ST.x:=FBoidz[i].ST.x+Mainform.ClientWidth;
     if FBoidz[i].ST.y>Mainform.ClientHeight then FBoidz[i].ST.y:=FBoidz[i].ST.y-Mainform.ClientHeight;
     if FBoidz[i].ST.y<0 then FBoidz[i].ST.y:=FBoidz[i].ST.y+Mainform.ClientHeight;
   {$endif}
  end;
end;

procedure TMainForm.RenderScene;
var
 {$ifdef cpu64}
 {$CODEALIGN VARMIN=16}
 b : TGLZVector4f;
 p : TGLZVector4i;
 //CurColor : TGLZColor;
 {$CODEALIGN VARMIN=4}
 {$else}
 b : TGLZVector4f;
 p : TGLZVector4i;
 {$endif}
 i,c : Integer;
 CurColor : TColor;
begin

  // on efface le buffer et on affiche les boïdes
  {$ifdef USE_FRAMEBUFFER}
  FBitmapBuffer.canvas.Brush.color:=clBlack;
  FBitmapBuffer.canvas.FillRect(clientrect);
  for i:=0 to maxboidz do
  begin
    b := FBoidz[i];
    p := b.Round;

    //calcul de la direction de déplacement pour la couleur
    c:=round(FastArcTangent2(b.UV.X,b.UV.Y)*180/cPi)+180;
    CurColor := FColorMap[c];
    with FBitmapBuffer.Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Color :=  CurColor;
      // dessine un traits de la longueur de la vitesse
      MoveTo(P.ST.x,P.ST.y);
      LineTo(P.ST.x+P.UV.x,P.ST.y+P.UV.y);
    end;
   end;
   {$else}
     mainform.canvas.Brush.color:=clBlack;
     mainform.Canvas.Clear;
     for i:=0 to maxboidz do
     begin
       b := FBoidz[i];
       p := b.Round;
       //calcul de la direction de déplacement pour la couleur
       c:=round(FastArcTangent2(b.UV.X,b.UV.Y)*180/cPi)+180;
       CurColor := FColorMap[c];

       with MainForm.Canvas do
       begin
         Pen.Style := psSolid;
         Pen.Color :=  CurColor;
         // dessine un traits de la longueur de la vitesse
         MoveTo(P.ST.x,P.ST.y);
         LineTo(P.ST.x+P.UV.x,P.ST.y+P.UV.y);
       end;
      end;
   {$endif}

end;

procedure TMainForm.InitColorMap;
Var
 i : Integer;
 //nc : TGLZColor;
 nc : TColor;
begin
  // on crée la palette de oculeur pour l'affichage
(*  for i:=0 to 360 do
  begin
    Case (i div 60) of
       0,6 : nc.Create(255,(i Mod 60)*255 div 60,0);
       1   : nc.Create(255-(i Mod 60)*255 div 60,255,0);
       2   : nc.Create(0,255,(i Mod 60)*255 div 60);
       3   : nc.Create(0,255-(i Mod 60)*255 div 60,255);
       4   : nc.Create((i Mod 60)*255 div 60,0,255);
       5   : nc.Create(255,0,255-(i Mod 60)*255 div 60);
    end;
    FBitmapBuffer.ColorManager.CreateColor(nc);
  end; *)
  // on crée la palette de oculeur pour l'affichage
  for i:=0 to 360 do
  begin
    Case (i div 60) of
       0,6:FColorMap[i]:=rgb(255,(i Mod 60)*255 div 60,0);
       1: FColorMap[i]:=rgb(255-(i Mod 60)*255 div 60,255,0);
       2: FColorMap[i]:=rgb(0,255,(i Mod 60)*255 div 60);
       3: FColorMap[i]:=rgb(0,255-(i Mod 60)*255 div 60,255);
       4: FColorMap[i]:=rgb((i Mod 60)*255 div 60,0,255);
       5: FColorMap[i]:=rgb(255,0,255-(i Mod 60)*255 div 60);
    end;
  end;
end;

procedure TMainForm.InitScene;
Var
 i: Integer;
begin

  //FCadencer := TGLZCadencer.Create(self);
  FCadencer := TTimer.Create(self);
  FCadencer.Enabled := False;
  FCadencer.Interval := 10;
  //FCadencer.OnProgress := @CadencerProgress;
  FCadencer.OnTimer := @CadencerProgress;

  FStopWatch := TGLZStopWatch.Create(self);

  Randomize;
  {$ifdef USE_FRAMEBUFFER}
  FBitmapBuffer := TBitmap.Create;
  FBitmapBuffer.SetSize(Width,Height);
  FBitmapBuffer.PixelFormat := pf32bit;
  {$endif}

  // Create Color Map
  InitColorMap;

  FrameCounter:=0;

  // on initialise une vitesse et une place aléatoire pour le départ
  for i:=0 to maxboidz do
  with Fboidz[i] do
   begin
    {$ifdef USE_FRAMEBUFFER}
      ST.x:=10+random(FBitmapBuffer.Width-10);
      ST.y:=10+random(FBitmapBuffer.Height-10);
    {$else}
      ST.x:=10+random(Mainform.ClientWidth-10);
      ST.y:=10+random(Mainform.ClientHeight-10);
    {$endif}

    UV.x:=10+random(Vitesse_Max-10);
    UV.y:=10+random(Vitesse_Max-10);
   end;

  aCounter :=0;
end;

procedure Tmainform.EraseBackground(DC: HDC);
begin
 // if EraseBackgroundEnabled then
    inherited EraseBackground(DC);
end;

end.

