
Unit Exits;

Interface

Uses 
Graph, Objects, Crt;

Var 
  ExitDor1 : Format;

  Fr : PFrames;

Type 
  PExitDor = ^TExitDor;
  TExitDor = Object (TObject)
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

CONSTRUCTOR TExitDor.Init(SpcWar : PSpace; x, y : Integer);

Var 
  i, j : Integer;

Begin
  Etapa  := 1;
  Frames := Fr;
  TObject.Init(Nil, SpcWar, ExitDor, x, y);
  SpaceWar^.Space[x,y] := @Self;
End;

Procedure TExitDor.Run;
Begin
End;

Procedure TExitDor.Draw;

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


Procedure TExitDor.Erase;

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


Procedure TExitDor.Move(Dir : Integer);
Begin
End;

DESTRUCTOR TExitDor.Done;
Begin
  TObject.Done;
End;

{****************************************************************************}

Begin
  ExitDor1[01] := 'FFFFFFFFFFFFFFFFFFFF';
  ExitDor1[02] := 'FFFFFFFFFFFFFFFFFFF4';
  ExitDor1[03] := 'FFCCCCCCCCCCCCCCCC44';
  ExitDor1[04] := 'FFCCC..........CCC44';
  ExitDor1[05] := 'FFCCC.EEEEEEEE.CCC44';
  ExitDor1[06] := 'FFCCC.EEEEEEEE.CCC44';
  ExitDor1[07] := 'FFCCC.EE.......CCC44';
  ExitDor1[08] := 'FFCCC.EE.CCCCCCCCC44';
  ExitDor1[09] := 'FFCCC.EE.....CCCCC44';
  ExitDor1[10] := 'FFCCC.EEEEEE.CCCCC44';
  ExitDor1[11] := 'FFCCC.EEEEEE.CCCCC44';
  ExitDor1[12] := 'FFCCC.EE.....CCCCC44';
  ExitDor1[13] := 'FFCCC.EE.CCCCCCCCC44';
  ExitDor1[14] := 'FFCCC.EE.......CCC44';
  ExitDor1[15] := 'FFCCC.EEEEEEEE.CCC44';
  ExitDor1[16] := 'FFCCC.EEEEEEEE.CCC44';
  ExitDor1[17] := 'FFCCC..........CCC44';
  ExitDor1[18] := 'FFCCCCCCCCCCCCCCCC44';
  ExitDor1[19] := 'FF444444444444444444';
  ExitDor1[20] := 'F4444444444444444444';

  Fr[1][1] := @ExitDor1;
  Fr[2][1] := @ExitDor1;
  Fr[1][2] := @ExitDor1;
  Fr[2][2] := @ExitDor1;
  Fr[1][3] := @ExitDor1;
  Fr[2][3] := @ExitDor1;
  Fr[1][4] := @ExitDor1;
  Fr[2][4] := @ExitDor1;
  Fr[1][5] := @ExitDor1;
  Fr[2][5] := @ExitDor1;
End.
