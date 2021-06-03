
Unit Ways;

Interface

Uses 
Graph, Objects, Crt;

Var 
  Way1 : Format;

  Fr : PFrames;

Type 
  PWay = ^TWay;
  TWay = Object (TObject)
    Etapa : 1..4;
    Constructor Init(SpcWar : PSpace; x, y : Integer);
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

Implementation

CONSTRUCTOR TWay.Init(SpcWar : PSpace; x, y : Integer);

Var 
  i, j : Integer;

Begin
  Etapa  := 1;
  Frames := Fr;
  TObject.Init(Nil, SpcWar, Way, x, y);
  SpaceWar^.Space[x,y] := @Self;
End;

Procedure TWay.Run;
Begin
End;

Procedure TWay.Draw;

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


Procedure TWay.Erase;

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


Procedure TWay.Move(Dir : Integer);
Begin
End;

DESTRUCTOR TWay.Done;
Begin
  TObject.Done;
End;

{****************************************************************************}

Begin
  Way1[01] := '22222222222222222222';
  Way1[02] := '22222222222222222222';
  Way1[03] := '22eeeeeeeeeeeeeeee22';
  Way1[04] := '22eeeeeeeeeeeeeeee22';
  Way1[05] := '22ee222222222222ee22';
  Way1[06] := '22ee222222222222ee22';
  Way1[07] := '22ee22eeeeeeee22ee22';
  Way1[08] := '22ee22eeeeeeee22ee22';
  Way1[09] := '22ee22ee2222ee22ee22';
  Way1[10] := '22ee22ee2222ee22ee22';
  Way1[11] := '22ee22ee2222ee22ee22';
  Way1[12] := '22ee22ee2222ee22ee22';
  Way1[13] := '22ee22eeeeeeee22ee22';
  Way1[14] := '22ee22eeeeeeee22ee22';
  Way1[15] := '22ee222222222222ee22';
  Way1[16] := '22ee222222222222ee22';
  Way1[17] := '22eeeeeeeeeeeeeeee22';
  Way1[18] := '22eeeeeeeeeeeeeeee22';
  Way1[19] := '22222222222222222222';
  Way1[20] := '22222222222222222222';

  Fr[1][1] := @Way1;
  Fr[2][1] := @Way1;
  Fr[1][2] := @Way1;
  Fr[2][2] := @Way1;
  Fr[1][3] := @Way1;
  Fr[2][3] := @Way1;
  Fr[1][4] := @Way1;
  Fr[2][4] := @Way1;
  Fr[1][5] := @Way1;
  Fr[2][5] := @Way1;
End.
