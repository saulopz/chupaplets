
Unit Objects;

Interface

Uses 
Graph, Crt, SndObj;

Const 
  STOP  = 1;
  UP    = 2;
  DOWN  = 3;
  RIGHT = 4;
  LEFT  = 5;
  SIZE  = 20;

  MID = 0;
  INT = 1;

  NO  = 0;
  YES = 1;
  NOMOVE = 1;
  YESMOVE = 2;

Type 
  ObjectType = (SPHERE, PLETS, CUTTER, WALL, CANDY, WAY, EXPLOIT, EXITDOR);

  Format = Array[1..20] Of String[20];
  PFormat = ^Format;
  PFrames = Array[1..2, 1..5] Of PFormat;

   {************** ENVIRONMENT OBJECT *****************}

  PObject = ^TObject;
  MatrixSpace = Array[1..30, 1..20] Of PObject;
  PSpace = ^TSpace;
  TSpace = Object
    Private 
    Public 
      ScoreTotal : Integer;
      QtdFalta   : Integer;
      Space     : MatrixSpace;
      MoveStage : Boolean;
      Snd       : PSndObj;
      Constructor Init(Sound : PSndObj);
      Procedure   Run;
      Procedure   Exploited(x, y : Integer);
      Destructor  Done;
  End;

   {*************** ROOT OBJECT *********************}

  TObject = Object
    Private 
      oldx, oldy: Integer;
    Public 
      SpaceWar  : PSpace;
      Name      : ObjectType;
      Posx      : Integer;
      Posy      : Integer;
      movie     : 1..2;
      MoveStage : Boolean;
      Direction : Integer;
      Frames  : PFrames;
      Destroy: Boolean;
      Explode: Boolean;
      Scores  : Integer;
      Snd     : PSndObj;
      Constructor Init(Sound : PSndObj; SpcWar : PSpace; NomeIN : ObjectType; x,
                       y : Integer);
      Procedure   Draw;
      virtual;
      Procedure   Erase;
      virtual;
      Procedure   Run;
      Virtual;
      Procedure   Move(Dir : Integer);
      Virtual;
      Function    AsColor(color : Char) : Integer;
      Function    GetDirection : Integer;
      Function    InMov : Boolean;
      Function    Mid : Integer;
      Destructor  Done;
      Virtual;
  End;

   {*********** EXPLOIT ***************}

  PExploit = ^TExploit;
  TExploit = Object (TObject)
    Etapa : 1..4;
    Constructor Init(Sound : PSndObj; SpcWar : PSpace; x, y : Integer);
    Procedure   Run;
    Virtual;
    Procedure   Draw;
    Virtual;
    Procedure   Erase;
    Virtual;
    Procedure   Move(Dir : Integer);
    Virtual;
    Destructor  Done;
    Virtual;
  End;

Var 
  AUTHOR : String;
  exit : Integer;
  ExploitETAPA1 : Format;
  ExploitETAPA2 : Format;
  ExploitETAPA3 : Format;
  Fr : PFrames;
  {Take Alt, Shift, Ctrl and Caps-Lock state}
  KeyBits: word absolute $0040: $0017;

Function LShiftPres : boolean;
Function RShiftPres : Boolean;
Procedure StrWrite(X, Y, Tx, Bk : Integer; ImputStr : String; UP : Boolean);

Implementation

Procedure StrWrite(X, Y, Tx, Bk : Integer; ImputStr : String; UP : Boolean);

Var i : Integer;

Begin
  SetColor(Bk);
  For i:= Y-1 To Y+8 Do
    Line(X-1, i, X+(Length(ImputStr)*8), i);
  If UP Then
    Begin
      SetColor(15);
      OutTextXY(X-1, Y-1, ImputStr);
    End
  Else
    Begin
      SetColor(0);
      OutTextXY(X+1, Y+1, ImputStr);
    End;
  SetColor(Tx);
  OutTextXY(X, Y, ImputStr);
End;

{************** LShiftPres ********************}

Function LShiftPres : boolean;
Begin
  LShiftPres := (KeyBits And $02) <> 0;
End;

{************* RShiftPres ********************}
Function RShiftPres : Boolean;
Begin
  RShiftPres := (KeyBits And $01) <> 0;
End;

{**********************************************}

CONSTRUCTOR TSpace.Init(Sound : PSndObj);

Var 
  x, y : Integer;

Begin
  Snd := Sound;
  QtdFalta   := 0;
  ScoreTotal := 0;
  For y := 1 To 20 Do
    For x := 1 To 30 Do
      Space[x,y] := Nil;
  MoveStage := True;
End;

Procedure TSpace.Run;

Var 
  x, y : Integer;
  Score: Integer;

Begin
  Score := 0;
  For x := 1 To 30 Do
    For y := 1 To 20 Do
      Begin
        If Space[x,y] <> Nil Then
          If Space[x,y]^.MoveStage = MoveStage Then
            Begin
              Space[x,y]^.MoveStage := Not MoveStage;
              If Not Space[x,y]^.Destroy Then
                Begin
                  If Space[x,y]^.Name = PLETS Then
                    Score := Space[x,y]^.Scores;
                  Space[x,y]^.Run;
                End
              Else
                If (Space[x,y]^.Explode) Then
                  Exploited(x, y)
              Else
                Begin
                  Space[x,y]^.Done;
                  Space[x,y] := Nil;
                End;
            End;
      End;
  MoveStage := Not MoveStage;
  QtdFalta := ScoreTotal - Score;
End;

Procedure TSpace.Exploited(x, y : Integer);

Var 
  i, j : Integer;
  PExp : PExploit;

Begin
  Space[x,y]^.Done;
  Space[x,y] := Nil;
  For i := x-1 To x+1 Do
    For j := y-1 To y+1 Do
      Begin
        If (((i>=1) And (i<=30) And (j>=1) And (j<=20)) And
           (Space[i,j]^.Name <> EXITDOR))            Then
          New(PExp, Init(Snd, @Self, i, j));
      End;
End;

DESTRUCTOR TSpace.Done;
Begin
End;

{************************************************************************}

CONSTRUCTOR TObject.Init(Sound : PSndObj; SpcWar : PSpace; NomeIN : ObjectType;
                         x, y : Integer);

Begin
  Snd := Sound;
  SpaceWar := SpcWar;
  Scores := 0;
  Name := NomeIN;
  Posx := x;
  posy := y;
  Direction := STOP;
  movie     := NOMOVE;
  Destroy  := False;
  Explode  := False;
  MoveStage := True;
  Draw;
End;

Function TObject.Mid : Integer;
Begin
  If InMov Then
    Begin
      Case GetDirection Of 
        UP   : Mid := +10;
        LEFT : Mid := +10;
        DOWN : Mid := -10;
        RIGHT: Mid := -10;
        Else Mid := 0;
      End;
    End
  Else
    Mid := 0;
End;

Procedure TObject.Draw;

Var 
  initx,
  inity : Integer;
  i, j  : Integer;

Begin
  initx := (posx * SIZE);
  inity := (posy * SIZE);
  If InMov Then
    Begin
      If ((Direction = DOWN) Or (Direction = UP)) Then
        inity := inity+Mid
      Else
        initx := initx+Mid;
    End;
  For i := 1 To SIZE Do
    For j := 1 To SIZE Do
      PutPixel(j+initx, i+inity,
               AsColor(Frames[movie][direction]^[i][j]));
End;


Procedure TObject.Erase;

Var 
  initx,
  inity : Integer;
  i, j  : Integer;

Begin
  initx := (posx * SIZE);
  inity := (posy * SIZE);
  If InMov Then
    Begin
      If ((Direction = DOWN) Or (Direction = UP)) Then
        inity := inity+Mid
      Else
        initx := initx+Mid;
    End;
  For i := 1 To SIZE Do
    For j := 1 To SIZE Do
      PutPixel(i+initx, j+inity, 0);
End;

Procedure TObject.Move(Dir : Integer);

Var 
  OldPosiction : PObject;

Begin
  Direction := Dir;
  Erase;
  If Not InMov Then
    Begin
      Movie := YESMOVE;
      oldx  := posx;
      oldy  := posy;
      OldPosiction := SpaceWar^.Space[posx, posy];
      SpaceWar^.Space[posx,posy] := Nil;
      Case Direction Of 
        UP   : If posy > 01 Then posy := posy-1;
        DOWN : If posy < 20 Then posy := posy+1;
        LEFT : If posx > 01 Then posx := posx-1;
        RIGHT: If posx < 30 Then posx := posx+1;
      End;
      SpaceWar^.Space[posx,posy] := OldPosiction;
    End
  Else
    Begin
      If SpaceWar^.Space[oldx,oldy] <> Nil Then
        SpaceWar^.Space[oldx,oldy]^.Draw;
      Movie := NOMOVE;
    End;
  Draw;
End;

Procedure TObject.Run;
Begin
End;

Function TObject.GetDirection : Integer;
Begin
  GetDirection := Direction;
End;

DESTRUCTOR TObject.Done;
Begin
  Erase;
End;

Function TObject.InMov : Boolean;
Begin
  InMov := Movie = YESMOVE;
End;

Function TObject.AsColor(Color : Char) : Integer;
Begin
  Case Color Of 
    '0' : AsColor := 0;
    '1' : AsColor := 1;
    '2' : AsColor := 2;
    '3' : AsColor := 3;
    '4' : AsColor := 4;
    '5' : AsColor := 5;
    '6' : AsColor := 6;
    '7' : AsColor := 7;
    '8' : AsColor := 8;
    '9' : AsColor := 9;
    'A', 'a' : AsColor := 10;
    'B', 'b' : AsColor := 11;
    'C', 'c' : AsColor := 12;
    'D', 'd' : AsColor := 13;
    'E', 'e' : AsColor := 14;
    'F', 'f' : AsColor := 15;
    Else AsColor := 0;
  End;
End;

{****************************************************************************}

CONSTRUCTOR TExploit.Init(Sound : PSndObj; SpcWar : PSpace; x, y : Integer);

Var 
  i, j : Integer;

Begin
  Etapa  := 1;
  Frames := Fr;
  TObject.Init(Sound, SpcWar, EXPLOIT, x, y);
  SpaceWar^.Space[x,y] := @Self;
End;

Procedure TExploit.Run;

Var 
  Dir : Integer;
  Key : Char;

Begin
  If InMov Then
    Begin
      Direction := UP;
      Move(Dir);
    End
  Else Move(GetDirection);
  Inc(Etapa);
  Destroy := Etapa>=4;
End;

Procedure TExploit.Draw;

Var 
  initx,
  inity : Integer;
  i, j  : Integer;

Begin
  initx := (posx * SIZE);
  inity := (posy * SIZE);
  For i := 1 To SIZE Do
    For j := 1 To SIZE Do
      PutPixel(j+initx, i+inity,
               AsColor(Frames[movie][direction]^[i][j]));
End;

Procedure TExploit.Erase;

Var 
  initx,
  inity : Integer;
  i, j  : Integer;

Begin
  initx := posx * SIZE;
  inity := posy * SIZE;
  For i := 1 To SIZE Do
    For j := 1 To SIZE Do
      PutPixel(i+initx, j+inity, 0);
End;

Procedure TExploit.Move(Dir : Integer);
Begin
  Erase;
  If Movie = YESMOVE Then Movie := NOMOVE
  Else Movie := YESMOVE;
  Draw;
End;

DESTRUCTOR TExploit.Done;
Begin
  TObject.Done;
End;

Begin
  ExploitETAPA1[01] := '....................';
  ExploitETAPA1[02] := '....................';
  ExploitETAPA1[03] := '....................';
  ExploitETAPA1[04] := '....................';
  ExploitETAPA1[05] := '....................';
  ExploitETAPA1[06] := '....44444..44444....';
  ExploitETAPA1[07] := '...44444444444444...';
  ExploitETAPA1[08] := '...444EEE44EEE444...';
  ExploitETAPA1[09] := '...44E666EEEE6E44...';
  ExploitETAPA1[10] := '...44EEE66EE6EE44...';
  ExploitETAPA1[11] := '...44E6E666EEE44....';
  ExploitETAPA1[12] := '....44EEEEE6644.....';
  ExploitETAPA1[13] := '....44E66EEE6E44....';
  ExploitETAPA1[14] := '...44EEE444E6EE44...';
  ExploitETAPA1[15] := '...44444444444444...';
  ExploitETAPA1[16] := '....4444...44444....';
  ExploitETAPA1[17] := '....................';
  ExploitETAPA1[18] := '....................';
  ExploitETAPA1[19] := '....................';
  ExploitETAPA1[20] := '....................';

  ExploitETAPA2[01] := '....................';
  ExploitETAPA2[02] := '..4444444.....4444..';
  ExploitETAPA2[03] := '.444444444...444444.';
  ExploitETAPA2[04] := '.4444EEE44444444444.';
  ExploitETAPA2[05] := '.4444EEEE44444EE444.';
  ExploitETAPA2[06] := '.444E666EEE666EE444.';
  ExploitETAPA2[07] := '.444EEE66EE666EE444.';
  ExploitETAPA2[08] := '.4444E66EEEEEEEEE44.';
  ExploitETAPA2[09] := '.4444EEEEE666EEE444.';
  ExploitETAPA2[10] := '.444EEE6666EEEE444..';
  ExploitETAPA2[11] := '.444EE66EE666E444...';
  ExploitETAPA2[12] := '.444EE66EEEEEE444...';
  ExploitETAPA2[13] := '.44444EE66EEEEE444..';
  ExploitETAPA2[14] := '..4444EEEE6666EE444.';
  ExploitETAPA2[15] := '...44466EEEEE666444.';
  ExploitETAPA2[16] := '..444E664444EEEE444.';
  ExploitETAPA2[17] := '.444EEE4444444EEE44.';
  ExploitETAPA2[18] := '.44444444..44444444.';
  ExploitETAPA2[19] := '.444444......44444..';
  ExploitETAPA2[20] := '....................';

  ExploitETAPA3[01] := '....................';
  ExploitETAPA3[02] := '....................';
  ExploitETAPA3[03] := '....................';
  ExploitETAPA3[04] := '....................';
  ExploitETAPA3[05] := '....................';
  ExploitETAPA3[06] := '............444.....';
  ExploitETAPA3[07] := '...........4EE4.....';
  ExploitETAPA3[08] := '............444.....';
  ExploitETAPA3[09] := '....................';
  ExploitETAPA3[10] := '.......4444.........';
  ExploitETAPA3[11] := '......46EE64........';
  ExploitETAPA3[12] := '......46EE64........';
  ExploitETAPA3[13] := '......44444.........';
  ExploitETAPA3[14] := '....................';
  ExploitETAPA3[15] := '....................';
  ExploitETAPA3[16] := '....................';
  ExploitETAPA3[17] := '....................';
  ExploitETAPA3[18] := '....................';
  ExploitETAPA3[19] := '....................';
  ExploitETAPA3[20] := '....................';

  Fr[1][1] := @ExploitETAPA1;
  Fr[2][1] := @ExploitETAPA2;
  Fr[1][2] := @ExploitETAPA1;
  Fr[2][2] := @ExploitETAPA3;
  Fr[1][3] := @ExploitETAPA1;
  Fr[2][3] := @ExploitETAPA1;
  Fr[1][4] := @ExploitETAPA1;
  Fr[2][4] := @ExploitETAPA1;
  Fr[1][5] := @ExploitETAPA1;
  Fr[2][5] := @ExploitETAPA1;
End.
