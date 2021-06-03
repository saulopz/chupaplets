
Unit ODraws;

Interface

Uses 
Graph;

Type 
  ObjectType = (VOID, SPHERE, PLETS, CUTTER, WALL, CANDY, EXITDOR, WAY);
  Draws  = Array[1..20] Of String[20];
  PDraws = ^Draws;

Var 
  VoidDRAW   : Draws;
  WayDRAW    : Draws;
  WallDRAW   : Draws;
  SphereDRAW : Draws;
  PletsDRAW  : Draws;
  CutterDRAW : Draws;
  ExitDRAW   : Draws;
  CandyDRAW  : Draws;

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


Begin
  VoidDRAW[01] := '....................';
  VoidDRAW[02] := '....................';
  VoidDRAW[03] := '....................';
  VoidDRAW[04] := '....................';
  VoidDRAW[05] := '....................';
  VoidDRAW[06] := '....................';
  VoidDRAW[07] := '....................';
  VoidDRAW[08] := '....................';
  VoidDRAW[09] := '....................';
  VoidDRAW[10] := '....................';
  VoidDRAW[11] := '....................';
  VoidDRAW[12] := '....................';
  VoidDRAW[13] := '....................';
  VoidDRAW[14] := '....................';
  VoidDRAW[15] := '....................';
  VoidDRAW[16] := '....................';
  VoidDRAW[17] := '....................';
  VoidDRAW[18] := '....................';
  VoidDRAW[19] := '....................';
  VoidDRAW[20] := '....................';

  WayDRAW[01] := '22222222222222222222';
  WayDRAW[02] := '22222222222222222222';
  WayDRAW[03] := '22eeeeeeeeeeeeeeee22';
  WayDRAW[04] := '22eeeeeeeeeeeeeeee22';
  WayDRAW[05] := '22ee222222222222ee22';
  WayDRAW[06] := '22ee222222222222ee22';
  WayDRAW[07] := '22ee22eeeeeeee22ee22';
  WayDRAW[08] := '22ee22eeeeeeee22ee22';
  WayDRAW[09] := '22ee22ee2222ee22ee22';
  WayDRAW[10] := '22ee22ee2222ee22ee22';
  WayDRAW[11] := '22ee22ee2222ee22ee22';
  WayDRAW[12] := '22ee22ee2222ee22ee22';
  WayDRAW[13] := '22ee22eeeeeeee22ee22';
  WayDRAW[14] := '22ee22eeeeeeee22ee22';
  WayDRAW[15] := '22ee222222222222ee22';
  WayDRAW[16] := '22ee222222222222ee22';
  WayDRAW[17] := '22eeeeeeeeeeeeeeee22';
  WayDRAW[18] := '22eeeeeeeeeeeeeeee22';
  WayDRAW[19] := '22222222222222222222';
  WayDRAW[20] := '22222222222222222222';

  WallDRAW[01] := 'FFFFFFFFFFFFFFFFFFFF';
  WallDRAW[02] := 'FF7777777777777777F0';
  WallDRAW[03] := 'F7F77777777777777F80';
  WallDRAW[04] := 'F77F777777777777F880';
  WallDRAW[05] := 'F777FFFFFFFFFFFF8880';
  WallDRAW[06] := 'F777F0888888880F8880';
  WallDRAW[07] := 'F777F8088888807F8880';
  WallDRAW[08] := 'F777F8808888077F8880';
  WallDRAW[09] := 'F777F8880880777F8880';
  WallDRAW[10] := 'F777F8888007777F8880';
  WallDRAW[11] := 'F777F88880F7777F8880';
  WallDRAW[12] := 'F777F888077F777F8880';
  WallDRAW[13] := 'F777F8807777F77F8880';
  WallDRAW[14] := 'F777F80777777F7F8880';
  WallDRAW[15] := 'F777F077777777FF8880';
  WallDRAW[16] := 'F777FFFFFFFFFFFF8880';
  WallDRAW[17] := 'F77F8888888888880880';
  WallDRAW[18] := 'F7F88888888888888080';
  WallDRAW[19] := 'FF888888888888888800';
  WallDRAW[20] := 'F0000000000000000000';

  SphereDRAW[01] := '....................';
  SphereDRAW[02] := '.......777777.......';
  SphereDRAW[03] := '.....7777777777.....';
  SphereDRAW[04] := '....777F77777777....';
  SphereDRAW[05] := '...777F7F77777777...';
  SphereDRAW[06] := '..777F7F7777777777..';
  SphereDRAW[07] := '..7777F7F777777777..';
  SphereDRAW[08] := '.777777777777777777.';
  SphereDRAW[09] := '..44466CCEECC66444..';
  SphereDRAW[10] := '..44466CCEECC66444..';
  SphereDRAW[11] := '..44466CCEECC66444..';
  SphereDRAW[12] := '..44466CCEECC66444..';
  SphereDRAW[13] := '.777777777777777777.';
  SphereDRAW[14] := '..7777777777777777..';
  SphereDRAW[15] := '..7777777777777777..';
  SphereDRAW[16] := '...77777777777777...';
  SphereDRAW[17] := '....777777777777....';
  SphereDRAW[18] := '.....7777777777.....';
  SphereDRAW[19] := '.......777777.......';
  SphereDRAW[20] := '....................';

  PletsDRAW[01] := '....................';
  PletsDRAW[02] := '....................';
  PletsDRAW[03] := '......4CCCCCC4......';
  PletsDRAW[04] := '.....ECCCCCCCEE4....';
  PletsDRAW[05] := '....ECCCCCCCCCCE4...';
  PletsDRAW[06] := '...ECCCCCCCCCCCCC...';
  PletsDRAW[07] := '..4CCCBCCCCCCCBCCC..';
  PletsDRAW[08] := '.4CCCB0CCCCCCC0BCCC.';
  PletsDRAW[09] := '.CCCCCCCCCCCCCCCCCC.';
  PletsDRAW[10] := '.CCCCCCCCCCCCCCCCCC.';
  PletsDRAW[11] := '.CCCCCCCCCCCCCCCCCC.';
  PletsDRAW[12] := '.CCCCCCCCCCCCCCCCCC.';
  PletsDRAW[13] := '.44C44CCCCCCCC44CCC.';
  PletsDRAW[14] := '.44CC424CCCC424CC44.';
  PletsDRAW[15] := '..44CCC422224CCC44..';
  PletsDRAW[16] := '...44CCC4444CCC44...';
  PletsDRAW[17] := '....444CCCCCC444....';
  PletsDRAW[18] := '.....4444444444.....';
  PletsDRAW[19] := '.......444444.......';
  PletsDRAW[20] := '....................';


  CutterDRAW[01] := '....................';
  CutterDRAW[02] := '....................';
  CutterDRAW[03] := '....................';
  CutterDRAW[04] := '....................';
  CutterDRAW[05] := '....................';
  CutterDRAW[06] := '..222...............';
  CutterDRAW[07] := '.2...2..............';
  CutterDRAW[08] := '.2...2..............';
  CutterDRAW[09] := '.2...2.FFFFFFFFFFF..';
  CutterDRAW[10] := '..2222FFFFFFFFFFFFF.';
  CutterDRAW[11] := '..22227777777777777.';
  CutterDRAW[12] := '.2...2.77777777777..';
  CutterDRAW[13] := '.2...2..............';
  CutterDRAW[14] := '.2...2..............';
  CutterDRAW[15] := '..222...............';
  CutterDRAW[16] := '....................';
  CutterDRAW[17] := '....................';
  CutterDRAW[18] := '....................';
  CutterDRAW[19] := '....................';
  CutterDRAW[20] := '....................';

  ExitDRAW[01] := 'FFFFFFFFFFFFFFFFFFFF';
  ExitDRAW[02] := 'FFFFFFFFFFFFFFFFFFF4';
  ExitDRAW[03] := 'FFCCCCCCCCCCCCCCCC44';
  ExitDRAW[04] := 'FFCCC..........CCC44';
  ExitDRAW[05] := 'FFCCC.EEEEEEEE.CCC44';
  ExitDRAW[06] := 'FFCCC.EEEEEEEE.CCC44';
  ExitDRAW[07] := 'FFCCC.EE.......CCC44';
  ExitDRAW[08] := 'FFCCC.EE.CCCCCCCCC44';
  ExitDRAW[09] := 'FFCCC.EE.....CCCCC44';
  ExitDRAW[10] := 'FFCCC.EEEEEE.CCCCC44';
  ExitDRAW[11] := 'FFCCC.EEEEEE.CCCCC44';
  ExitDRAW[12] := 'FFCCC.EE.....CCCCC44';
  ExitDRAW[13] := 'FFCCC.EE.CCCCCCCCC44';
  ExitDRAW[14] := 'FFCCC.EE.......CCC44';
  ExitDRAW[15] := 'FFCCC.EEEEEEEE.CCC44';
  ExitDRAW[16] := 'FFCCC.EEEEEEEE.CCC44';
  ExitDRAW[17] := 'FFCCC..........CCC44';
  ExitDRAW[18] := 'FFCCCCCCCCCCCCCCCC44';
  ExitDRAW[19] := 'FF444444444444444444';
  ExitDRAW[20] := 'F4444444444444444444';

  CandyDRAW[01] := '....................';
  CandyDRAW[02] := '..........9.........';
  CandyDRAW[03] := '..........9.........';
  CandyDRAW[04] := '..........9.........';
  CandyDRAW[05] := '....99...F9...F9....';
  CandyDRAW[06] := '....F99..F9..F99....';
  CandyDRAW[07] := '.....F99.F9.F99.....';
  CandyDRAW[08] := '......F99F9F99......';
  CandyDRAW[09] := '.......F9F999.......';
  CandyDRAW[10] := '.FFFFFFFF99FFFFF....';
  CandyDRAW[11] := '....999999999999999.';
  CandyDRAW[12] := '......999F99F.......';
  CandyDRAW[13] := '......99FF999F......';
  CandyDRAW[14] := '.....99F.F9.99F.....';
  CandyDRAW[15] := '....99F..F9..99F....';
  CandyDRAW[16] := '....9F...F9...99....';
  CandyDRAW[17] := '.........F..........';
  CandyDRAW[18] := '.........F..........';
  CandyDRAW[19] := '.........F..........';
  CandyDRAW[20] := '....................';
End.
