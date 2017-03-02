unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList;

const
 StartTop = 60;  {Koordinata forme od koje pocinje da se crta staza...}
 StartLeft = 25; {... i druga koordinata}
 Size = 32;      {Velicina slike (polja) }
type
  {Pilikom kreiranja glavne (i jedine) forme citaju se podaci iz tekstualne
   datoteke llhc.nediraj i pamte u ovom nizu. Name= Naziv nivoa, Path= Lokacija
   fajla nivoa (textfile ali ekstanzija .lvl- promenio sam), Player= Ime igraca
   koji je imao najbolji rezultat i Moves= Njegov rezultat}
  LevelInfo = record
   Name, Path, Player: String;
   Moves: Word;
  end;
  LevelNiz = array [1..255] of LevelInfo;
  PlayerInfo = record     {Pamti trenutnu poziciju igraca}
   Top,Left:byte;
  end;
  Polje = record
   Broj: byte;
   Slika: TImage;
  end;
  Niz = array [1..30] of Polje;
  Matrica = array [1..25] of Niz;
  {Broj odredjuje koji objekat (predmet) iz igre se nalazi na tom polju i
   odredjuje koja ce se slika citati
   1 = BoxInPlace (box + emptyspot)
   2 = EmptySpot
   3 = Box
   4 = FreeArea
   5 = Player
   6 = Wall
   7 = PlayerOnSpot (player + emptyspot)
   Vise u metodi "ButtonStartClick"}

  TForm1 = class(TForm)
    ComboBoxLevelSelect: TComboBox;
    ButtonStart: TButton;
    ButtonClose: TButton;
    LabelControl: TLabel;
    LabelMoves: TLabel;
    LabelNoOfMoves: TLabel;
    EditName: TEdit;
    LabelHighScore: TLabel;
    LabelPlayer: TLabel;
    LabelHighMoves: TLabel;
    LabelHighMovesNumber: TLabel;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditNameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  procedure MoveCase1 (PNTop, PNLeft, PNTop2, PNLeft2: byte);
  procedure MoveCase2 (PNTop, PNLeft: byte);
  procedure MoveCase3 (PNTop, PNLeft, PNTop2, PNLeft2: byte);
  procedure MoveCase4 (PNTop, PNLeft: byte);

var
  Form1: TForm1;
  LevelList: LevelNiz;
  Staza: Matrica;
  SizeTop, SizeLeft, Boxes, BoxesInPlace, Levels: Byte;
  Moves: Word;
  Player: PlayerInfo;
  MovedPlayer: boolean;
  BmpBox, BmpBoxInPlace, BmpEmptySpot, BmpFreeArea, BmpPlayer, BmpPlayerOnSpot,
  BmpWall: TBitmap;

implementation

{$R *.dfm}

{MoveCase1 je procedura koja se koristi kada igrac krene prema kutiji koja se
 vec nalazi na jednom og mesta odredjenih za kutije (Polje.Broj=1). PNTop i
 PNLeft su kordinate kutije, a PNTop2 i PNLeft2 kordinate polja iza kutije}
procedure MoveCase1 (PNTop, PNLeft, PNTop2, PNLeft2: byte);
var
 Moved:boolean;
begin
 Moved:=false;
 {Uz pomov Polje.Broj saznajemo koji se predmet nalazi na tom polju i menjamo
  ga prema postojecoj situaciji}
 if Staza[PNTop2][PNLeft2].Broj = 4
  then
   begin
    Moved:=true;
    Staza[PNTop2][PNLeft2].Broj := 3;
    Staza[PNTop2][PNLeft2].Slika.Picture.Graphic := BmpBox;
    BoxesInPlace := BoxesInPlace - 1;
   end
  else if Staza[PNTop2][PNLeft2].Broj = 2
        then
         begin
          Moved:=true;
          Staza[PNTop2][PNLeft2].Broj := 1;
          Staza[PNTop2][PNLeft2].Slika.Picture.Graphic := BmpBoxInPlace;
         end;
 if Moved
  then
   begin
    if Staza[Player.Top][Player.Left].Broj = 5
     then
      begin
       Staza[Player.Top][Player.Left].Broj := 4;
       Staza[Player.Top][Player.Left].Slika.Picture.Graphic := BmpFreeArea;
      end
     else if Staza[Player.Top][Player.Left].Broj = 7
           then
            begin
             Staza[Player.Top][Player.Left].Broj := 2;
             Staza[Player.Top][Player.Left].Slika.Picture.Graphic := BmpEmptySpot;
            end;
     Staza[PNTop][PNLeft].Broj := 7;
     Staza[PNTop][PNLeft].Slika.Picture.Graphic := BmpPlayerOnSpot;
     Player.Top := PNTop;
     Player.Left := PNLeft;
    end;
 MovedPlayer := True;
end;

{MoveCase2 je za Polje.Broj=2}
procedure MoveCase2 (PNTop, PNLeft: byte);
begin
 if Staza[Player.Top][Player.Left].Broj = 5
  then
   begin
    Staza[Player.Top][Player.Left].Broj := 4;
    Staza[Player.Top][Player.Left].Slika.Picture.Graphic := BmpFreeArea;
   end
  else if Staza[Player.Top][Player.Left].Broj = 7
        then
         begin
          Staza[Player.Top][Player.Left].Broj := 2;
          Staza[Player.Top][Player.Left].Slika.Picture.Graphic := BmpEmptySpot;
         end;
 Staza[PNTop][PNLeft].Broj := 7;
 Staza[PNTop][PNLeft].Slika.Picture.Graphic := BmpPlayerOnSpot;
 Player.Top := PNTop;
 Player.Left := PNLeft;
 MovedPlayer := True;
end;

{MoveCase3 je za Polje.Broj=3}
procedure MoveCase3 (PNTop, PNLeft, PNTop2, PNLeft2: byte);
var
 Moved:boolean;
begin
 Moved:=false;
 if Staza[PNTop2][PNLeft2].Broj = 4
  then
   begin
    Moved:=true;
    Staza[PNTop2][PNLeft2].Broj := 3;
    Staza[PNTop2][PNLeft2].Slika.Picture.Graphic := BmpBox;
   end
  else if Staza[PNTop2][PNLeft2].Broj = 2
        then
         begin
          Moved:=true;
          Staza[PNTop2][PNLeft2].Broj := 1;
          Staza[PNTop2][PNLeft2].Slika.Picture.Graphic := BmpBoxInPlace;
          BoxesInPlace := BoxesInPlace + 1;
         end;
 if Moved
  then
   begin
    if Staza[Player.Top][Player.Left].Broj = 5
     then
      begin
       Staza[Player.Top][Player.Left].Broj := 4;
       Staza[Player.Top][Player.Left].Slika.Picture.Graphic := BmpFreeArea;
      end
     else if Staza[Player.Top][Player.Left].Broj = 7
           then
            begin
             Staza[Player.Top][Player.Left].Broj := 2;
             Staza[Player.Top][Player.Left].Slika.Picture.Graphic := BmpEmptySpot;
            end;
     Staza[PNTop][PNLeft].Broj := 5;
     Staza[PNTop][PNLeft].Slika.Picture.Graphic := BmpPlayer;
     Player.Top := PNTop;
     Player.Left := PNLeft;
    end;
 MovedPlayer := True;
end;

{MoveCase4 je za Polje.Broj=4}
procedure MoveCase4 (PNTop, PNLeft: byte);
begin
 if Staza[Player.Top][Player.Left].Broj = 5
  then begin
        Staza[Player.Top][Player.Left].Broj := 4;
        Staza[Player.Top][Player.Left].Slika.Picture.Graphic := BmpFreeArea;
       end
   else if Staza[Player.Top][Player.Left].Broj = 7
         then begin
               Staza[Player.Top][Player.Left].Broj := 2;
               Staza[Player.Top][Player.Left].Slika.Picture.Graphic := BmpEmptySpot;
              end;
 Staza[PNTop][PNLeft].Broj := 5;
 Staza[PNTop][PNLeft].Slika.Picture.Graphic := BmpPlayer;
 Player.Top := PNTop;
 Player.Left := PNLeft;
 MovedPlayer := True;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var
 s: string;
 DoMove: boolean;
 PNTop, PNLeft, PNTop2, PNLeft2: Byte;
begin
 MovedPlayer := False;
 DoMove := True;
 {#83=S, #115=s}
 {#65=A, #97=a}
 {#87=W, #119=w}
 {#68=D, #100=d}
 {U zavisnosti od dugmeta na tastaturi koje je pritisnuto uzima koordinate
  2 polja ispred igraca...}
 case Key of
  #83, #115: begin
              PNTop := Player.Top + 1;
              PNLeft := Player.Left;
              PNTop2 := Player.Top + 2;
              PNLeft2 := Player.Left;
             end;
  #65, #97: begin
             PNTop := Player.Top;
             PNLeft := Player.Left - 1;
             PNTop2 := Player.Top;
             PNLeft2 := Player.Left - 2;
            end;
  #87, #119: begin
              PNTop := Player.Top - 1;
              PNLeft := Player.Left;
              PNTop2 := Player.Top - 2;
              PNLeft2 := Player.Left;
             end;
  #68, #100: begin
              PNTop := Player.Top;
              PNLeft := Player.Left + 1;
              PNTop2 := Player.Top;
              PNLeft2 := Player.Left + 2;
             end;
  else DoMove := False;
 end;
 {... a zatim poziva odgovarujuci MoveCase. Staze su ogranicene zidovima
  (Wall= predmet br. 6) pa dodatne provere za uzete kooordinate nisu potrebne.}
 if DoMove
  then
   case Staza[PNTop][PNLeft].Broj of
    1: MoveCase1 (PNTop, PNLeft, PNTop2, PNLeft2);
    2: MoveCase2 (PNTop, PNLeft);
    3: MoveCase3 (PNTop, PNLeft, PNTop2, PNLeft2);
    4: MoveCase4 (PNTop, PNLeft);
   end;
 if MovedPlayer   {Ukoliko se igrac pomerio...}
  then
   begin
    Moves := Moves + 1;  {... povecaca proj poteza...}
    Str(Moves,s);
    LabelNoOfMoves.Caption := s;  {... ispisuje ih na formi...}
    if Boxes=BoxesInPlace {... i proverava da li je ispunjen uslov za zavrsetak
                           nivoa. Po pravilima igre broj kutija mora biti jednak
                           broju odredjenih polja za kutije}
     then
      begin
       if (Moves < LevelList[ComboBoxLevelSelect.ItemIndex].Moves) or
          (LevelList[ComboBoxLevelSelect.ItemIndex].Moves = 0)
        then
         EditName.Visible := True; {Omogucava unos imena na mesto najboljeg igraca}
       Self.KeyPreview := False {Onemogucava dalje pomeranje igraca jer nema potrebe}
      end;
   end;
end;

procedure TForm1.ButtonCloseClick(Sender: TObject);
begin
 close
end;

procedure TForm1.ButtonStartClick(Sender: TObject); {Pokretanje staze}
var
  i,j: Byte;
  s: string;
  f: textFile;
begin
 if LabelControl.Visible {Pre prvog pokretanja staze LabelControl.Visible je
                          False Iskoristio sam ovo umesto novog boolean-a)}
  then
   for i:= 1 to SizeTop do
    for j:= 1 to SizeLeft do
     if Staza[i][j].Broj <> 0
      then Staza[i][j].Slika.free; {Brise stazu pre crtanja nove i cisti zauzetu
                                    memoriju}
 AssignFile (f, LevelList[ComboBoxLevelSelect.ItemIndex].Path);
 Reset (f);
 readln (f,SizeLeft,SizeTop); {Otvorite bilo koje .lvl fajl preko tekstualnog
                               editora i saznacete kako su napravljeni nivoi
                               i sta se zapravo cita}
 for i:= 1 to SizeTop do
  begin
   for j:= 1 to SizeLeft do
    read(f,Staza[i][j].Broj);
   readln (f);
  end;
 CloseFile (f);
 Boxes := 0;
 BoxesInPlace := 0;
  for i:= 1 to SizeTop do
   for j:= 1 to SizeLeft do
    if Staza[i][j].Broj <> 0
     then
      begin
       Staza[i][j].Slika := TImage.Create(Self);
       Staza[i][j].Slika.Parent := Self;
       Staza[i][j].Slika.Height := Size;
       Staza[i][j].Slika.Width := Size;
       Staza[i][j].Slika.Top := StartTop + (Size * (i - 1));
       Staza[i][j].Slika.Left := StartLeft + (Size * (j - 1));
       {U zavisnosti od Polje.Broj crta sliku na tom polju i uzima druge
        bitne podatke: Broj kutija, Pozicija igraca, itd.}
       case Staza[i][j].Broj of
        {Pre sam koristio 4 (FreeArea) za prazne prostore, one van zidova do
         kojih igrac ne moze doci. a onda sam promenio na 0. Kod tih polja
         nema slike koja ce se ucitati i time sam ustedeo na memoriji.}
        1: begin
            Staza[i][j].Slika.Picture.Graphic := BmpBoxInPlace;
            Boxes := Boxes + 1;
            BoxesInPlace := BoxesInPlace + 1;
           end;
        2: Staza[i][j].Slika.Picture.Graphic := BmpEmptySpot;
        3: begin
            Staza[i][j].Slika.Picture.Graphic := BmpBox;
            Boxes := Boxes + 1;
           end;
        4: Staza[i][j].Slika.Picture.Graphic := BmpFreeArea;
        5: begin
            Staza[i][j].Slika.Picture.Graphic := BmpPlayer;
            Player.Top := i;
            Player.Left := j;
            {U slucaju pojavljivanja vise igraca poslednji procitani ce se uzeti
             za pravog ali ce slike ostati i bice tretirane kao zid jer ne
             postoji MoveCase za Polje.Broj=5 (player) kao ni za Polje.Broj=6
             (wall), ali nivoi koje sam ubacio ne sadrze takve slucajeve.}
           end;
        6: Staza[i][j].Slika.Picture.Graphic := BmpWall;
        7: begin
            Staza[i][j].Slika.Picture.Graphic := BmpPlayerOnSpot;
            Player.Top := i;
            Player.Left := j;
           end;
       end;
 Moves := 0; {Ocigledno}
 LabelMoves.Visible := True;
 LabelNoOfMoves.Caption := '0';
 {Ispisuje igraca koji je do sada imao najbolji rezultat...}
 LabelPlayer.Caption := LevelList[ComboBoxLevelSelect.ItemIndex].Player;
 {... i njegov/njen rezultat (broj poteza)}
 str(LevelList[ComboBoxLevelSelect.ItemIndex].Moves, s);
 LabelHighMovesNumber.Caption := s;
 EditName.Visible := False;
 EditName.Text := 'New high score. Write your name here and press enter';
 Self.KeyPreview := True;
 LabelControl.Visible := True;
 end;
end;


procedure TForm1.FormCreate(Sender: TObject);
var
 f: textfile;
 s: string;
 m: word;
begin
 Levels := 0;
 {Cita podatke o nivoima i rezultatima (moze se otvoriti preko tekstualnog
  editora) i pise nazive nivoa u ComboBox}
 AssignFile (f, 'llhs.nediraj');
 Reset (f);
 ComboBoxLevelSelect.Items.BeginUpdate;
 ComboBoxLevelSelect.Items.Clear;
 while not eof (f) do
  begin
   readln (f,s);
   ComboBoxLevelSelect.Items.Add(s);
   LevelList[Levels].Name := s;
   readln (f,s);
   LevelList[Levels].Path := s;
   readln (f,s);
   LevelList[Levels].Player := s;
   readln (f,m);
   LevelList[Levels].Moves := m;
   Levels := Levels + 1;
  end;
 ComboBoxLevelSelect.Items.EndUpdate;
 closeFile (f);
 Levels := Levels - 1;
 {Cita slike}
 BmpBox := TBitmap.Create;
 BmpBox.LoadFromFile('Images/box.bmp');
 BmpBoxInPlace := TBitmap.Create;
 BmpBoxInPlace.LoadFromFile('Images/boxinplace.bmp');
 BmpEmptySpot := TBitmap.Create;
 BmpEmptySpot.LoadFromFile('Images/emptyspot.bmp');
 BmpFreeArea := TBitmap.Create;
 BmpFreeArea.LoadFromFile('Images/freearea.bmp');
 BmpPlayer := TBitmap.Create;
 BmpPlayer.LoadFromFile('Images/player.bmp');
 BmpPlayerOnSpot := TBitmap.Create;
 BmpPlayerOnSpot.LoadFromFile('Images/playeronspot.bmp');
 BmpWall := TBitmap.Create;
 BmpWall.LoadFromFile('Images/wall.bmp');
end;

{Na ENTER u Edit-u cita unet string (ime), pamti i ispisuje na odgovarajucem
 mestu u formi}
procedure TForm1.EditNameKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13
  then
   begin
    LabelPlayer.Caption := EditName.Text;
    LabelHighMovesNumber.Caption := LabelNoOfMoves.Caption;
    LevelList[ComboBoxLevelSelect.ItemIndex].Player := EditName.Text;
    LevelList[ComboBoxLevelSelect.ItemIndex].Moves := Moves;
   end;
end;

{Prilikom zatvaranja pise nove rezultata nazad u llhc.nediraj}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
 f: textfile;
 i: byte;
begin
 AssignFile (f, 'llhs.nediraj');
 ReWrite (f);
 for i:= 0 to Levels do
  begin
   WriteLn (f, LevelList[i].Name);
   WriteLn (f, LevelList[i].Path);
   WriteLn (f, LevelList[i].Player);
   WriteLn (f, LevelList[i].Moves)
  end;
 CloseFile (f);
end;

{Brise postojeci tekst stvarajuci prazno mesto za unos imena igraca}
procedure TForm1.EditNameClick(Sender: TObject);
begin
 EditName.Text := '';
end;

end.
