
Unit Walls;

Interface

Uses 
Graph, Objects, Crt;

Var 
  Wall1 : Format;

  Fr : PFrames;

Type 
  PWall = ^TWall;
  TWall = Object (TObject)
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

CONSTRUCTOR TWall.Init(SpcWar : PSpace; x, y : Integer);

Var 
  i, j : Integer;

Begin
  Etapa  := 1;
  Frames := Fr;
  TObject.Init(Nil, SpcWar, WALL, x, y);
  SpaceWar^.Space[x,y] := @Self;
End;

Procedure TWall.Run;
Begin
End;

Procedure TWall.Draw;

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


Procedure TWall.Erase;

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


Procedure TWall.Move(Dir : Integer);
Begin
End;

DESTRUCTOR TWall.Done;
Begin
  TObject.Done;
End;

{****************************************************************************}

Begin
  Wall1[01] := 'FFFFFFFFFFFFFFFFFFFF';
  Wall1[02] := 'FF7777777777777777F0';
  Wall1[03] := 'F7F77777777777777F80';
  Wall1[04] := 'F77F777777777777F880';
  Wall1[05] := 'F777FFFFFFFFFFFF8880';
  Wall1[06] := 'F777F0888888880F8880';
  Wall1[07] := 'F777F8088888807F8880';
  Wall1[08] := 'F777F8808888077F8880';
  Wall1[09] := 'F777F8880880777F8880';
  Wall1[10] := 'F777F8888007777F8880';
  Wall1[11] := 'F777F88880F7777F8880';
  Wall1[12] := 'F777F888077F777F8880';
  Wall1[13] := 'F777F8807777F77F8880';
  Wall1[14] := 'F777F80777777F7F8880';
  Wall1[15] := 'F777F077777777FF8880';
  Wall1[16] := 'F777FFFFFFFFFFFF8880';
  Wall1[17] := 'F77F8888888888880880';
  Wall1[18] := 'F7F88888888888888080';
  Wall1[19] := 'FF888888888888888800';
  Wall1[20] := 'F0000000000000000000';

  Fr[1][1] := @Wall1;
  Fr[2][1] := @Wall1;
  Fr[1][2] := @Wall1;
  Fr[2][2] := @Wall1;
  Fr[1][3] := @Wall1;
  Fr[2][3] := @Wall1;
  Fr[1][4] := @Wall1;
  Fr[2][4] := @Wall1;
  Fr[1][5] := @Wall1;
  Fr[2][5] := @Wall1;
End.
