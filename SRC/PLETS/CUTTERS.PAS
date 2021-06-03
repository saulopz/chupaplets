
Unit Cutters;

Interface

Uses 
Objects, Crt, SndObj;

Var 
  CutterUP_OPEN     : Format;
  CutterUP_CLOSE    : Format;
  CutterDOWN_OPEN   : Format;
  CutterDOWN_CLOSE  : Format;
  CutterLEFT_CLOSE  : Format;
  CutterLEFT_OPEN   : Format;
  CutterRIGHT_CLOSE : Format;
  CutterRIGHT_OPEN  : Format;

  Fr : PFrames;

Type 
  PCutter = ^TCutter;
  TCutter = Object (TObject)
    Constructor Init(Sound : PSndObj; SpcWar : PSpace; x, y : Integer);
    Procedure   Run;
    Virtual;
    Procedure   Move(Dir : Integer);
    Virtual;
    Procedure   Draw;
    Virtual;
    Destructor  Done;
    Virtual;
  End;

Implementation

CONSTRUCTOR TCutter.Init(Sound : PSndObj; SpcWar : PSpace; x, y : Integer);

Var 
  i, j : Integer;

Begin
  Frames := Fr;
  Scores := 0;
  TObject.Init(Sound, SpcWar, CUTTER, x, y);
  SpaceWar^.Space[x,y] := @Self;
End;

Procedure TCutter.Draw;
Begin
  TObject.Draw;
End;

Procedure TCutter.Run;
Begin
  If GetDirection = STOP Then Direction := RIGHT;
  Move(Direction);
End;

Procedure TCutter.Move(Dir : Integer);

Var 
  ObjBEFORE  : PObject;
  ObjRIGHT   : PObject;
  LimitBEFORE: Boolean;
  LimitRIGHT : Boolean;

Begin
  LimitBEFORE := False;
  LimitRIGHT := False;
  ObjRIGHT   := Nil;
  ObjBEFORE  := Nil;
  If InMov Then TObject.Move(Direction)
  Else
    Begin
      Case Dir Of 
        UP    :
                Begin
                  If posy > 01 Then
                    ObjBEFORE := SpaceWar^.Space[posx, posy-1]
                  Else LimitBEFORE := True;
                  If posx < 30 Then
                    ObjRIGHT := SpaceWar^.Space[posx+1, posy]
                  Else LimitRIGHT := True;
                End;
        DOWN  :
                Begin
                  If posy < 20 Then
                    ObjBEFORE := SpaceWar^.Space[posx, posy+1]
                  Else LimitBEFORE := True;
                  If posx > 01 Then
                    ObjRIGHT := SpaceWar^.Space[posx-1, posy]
                  Else LimitRIGHT := True;
                End;
        LEFT  :
                Begin
                  If posx > 01 Then
                    ObjBEFORE := SpaceWar^.Space[posx-1, posy]
                  Else LimitBEFORE := True;
                  If posy > 01 Then
                    ObjRIGHT := SpaceWar^.Space[posx, posy-1]
                  Else LimitRIGHT := True;
                End;
        RIGHT :
                Begin
                  If posx < 30 Then
                    ObjBEFORE := SpaceWar^.Space[posx+1, posy]
                  Else LimitBEFORE := True;
                  If posy < 20 Then
                    ObjRIGHT := SpaceWar^.Space[posx, posy+1]
                  Else LimitRIGHT := True;
                End;
      End;
      If LimitRIGHT = True Then             {If right is the limit}
        Begin
          If (LimitBEFORE = True) Then      {If front is the limit}
            Begin
              Case Direction Of             {Change direction}
                UP    : Direction := LEFT;
                DOWN  : Direction := RIGHT;
                RIGHT : Direction := UP;
                LEFT  : Direction := DOWN;
              End;
              Draw;
            End
          Else If ObjBEFORE^.Name = PLETS Then   {If PLETS, kill}
                 Begin
                   Snd^.Snd(EXPLOITSND);
                   ObjBEFORE^.Destroy := True;
                   ObjBEFORE^.Explode := True;
                   Destroy := True;
                   Explode := True;
                 End
          Else If ObjBEFORE = Nil Then        {If nothing, move}
                 TObject.Move(Direction)
          Else                                {else change direction}
            Begin
              Case Direction Of 
                UP    : Direction := LEFT;
                DOWN  : Direction := RIGHT;
                RIGHT : Direction := UP;
                LEFT  : Direction := DOWN;
              End;
              Draw;
            End;
        End
      Else If ObjRIGHT^.Name = PLETS Then  {If right is PLETS, kill}
             Begin
               Snd^.Snd(EXPLOITSND);
               ObjRIGHT^.Destroy := True;
               ObjRIGHT^.Explode := True;
               Destroy := True;
               Explode := True;
             End
      Else If ObjRIGHT = Nil Then          {if nothing, turn right}
             Case Direction Of                 {and move}
               UP    : TObject.Move(RIGHT);
               DOWN  : TObject.Move(LEFT);
               RIGHT : TObject.Move(DOWN);
               LEFT  : TObject.Move(UP);
             End
      Else
        Begin
          If (LimitBEFORE = True) Then  {If front is the limit}
            Begin
              Case Direction Of              {change direction}
                UP    : Direction := LEFT;
                DOWN  : Direction := RIGHT;
                RIGHT : Direction := UP;
                LEFT  : Direction := DOWN;
              End;
              Draw;
            End
          Else If ObjBEFORE^.Name = PLETS Then   {if PLETS, kill}
                 Begin
                   Snd^.Snd(EXPLOITSND);
                   ObjBEFORE^.Destroy := True;
                   ObjBEFORE^.Destroy := True;
                   Destroy := True;
                   Explode := True;
                 End
          Else If ObjBEFORE = Nil Then        {If nothing, move}
                 TObject.Move(Direction)
          Else                                {else change direction}
            Begin
              Case Direction Of 
                UP    : Direction := LEFT;
                DOWN  : Direction := RIGHT;
                RIGHT : Direction := UP;
                LEFT  : Direction := DOWN;
              End;
              Draw;
            End;
        End;
    End;
End;

DESTRUCTOR TCutter.Done;

Begin
  TObject.Done;
End;

{****************************************************************************}

Begin
  CutterUP_OPEN[01] := '....................';
  CutterUP_OPEN[02] := '....................';
  CutterUP_OPEN[03] := '....F............7..';
  CutterUP_OPEN[04] := '....FF..........77..';
  CutterUP_OPEN[05] := '....FF..........77..';
  CutterUP_OPEN[06] := '....FFF........777..';
  CutterUP_OPEN[07] := '.....FF........77...';
  CutterUP_OPEN[08] := '.....FFF......777...';
  CutterUP_OPEN[09] := '......FF......77....';
  CutterUP_OPEN[10] := '......FFF....777....';
  CutterUP_OPEN[11] := '.......FF....77.....';
  CutterUP_OPEN[12] := '.......FFF..777.....';
  CutterUP_OPEN[13] := '........FF..77......';
  CutterUP_OPEN[14] := '......222.F7.222....';
  CutterUP_OPEN[15] := '.....2...2222...2...';
  CutterUP_OPEN[16] := '.....2....22....2...';
  CutterUP_OPEN[17] := '.....2..22..22..2...';
  CutterUP_OPEN[18] := '......222....222....';
  CutterUP_OPEN[19] := '....................';
  CutterUP_OPEN[20] := '....................';

  CutterUP_CLOSE[01] := '....................';
  CutterUP_CLOSE[02] := '.........F7.........';
  CutterUP_CLOSE[03] := '........FF77........';
  CutterUP_CLOSE[04] := '........FF77........';
  CutterUP_CLOSE[05] := '........FF77........';
  CutterUP_CLOSE[06] := '........FF77........';
  CutterUP_CLOSE[07] := '........FF77........';
  CutterUP_CLOSE[08] := '........FF77........';
  CutterUP_CLOSE[09] := '........FF77........';
  CutterUP_CLOSE[10] := '........FF77........';
  CutterUP_CLOSE[11] := '........FF77........';
  CutterUP_CLOSE[12] := '........FF77........';
  CutterUP_CLOSE[13] := '........FF77........';
  CutterUP_CLOSE[14] := '.........F7.........';
  CutterUP_CLOSE[15] := '......22222222......';
  CutterUP_CLOSE[16] := '.....2...22...2.....';
  CutterUP_CLOSE[17] := '.....2...22...2.....';
  CutterUP_CLOSE[18] := '.....2...22...2.....';
  CutterUP_CLOSE[19] := '......222..222......';
  CutterUP_CLOSE[20] := '....................';

  CutterDOWN_OPEN[01] := '....................';
  CutterDOWN_OPEN[02] := '....................';
  CutterDOWN_OPEN[03] := '.....222....222.....';
  CutterDOWN_OPEN[04] := '....2..222222..2....';
  CutterDOWN_OPEN[05] := '....2....22....2....';
  CutterDOWN_OPEN[06] := '....2...2222...2....';
  CutterDOWN_OPEN[07] := '.....222.F7.222.....';
  CutterDOWN_OPEN[08] := '.......FF..77.......';
  CutterDOWN_OPEN[09] := '......FFF..777......';
  CutterDOWN_OPEN[10] := '......FF....77......';
  CutterDOWN_OPEN[11] := '.....FFF....777.....';
  CutterDOWN_OPEN[12] := '.....FF......77.....';
  CutterDOWN_OPEN[13] := '....FFF......777....';
  CutterDOWN_OPEN[14] := '....FF........77....';
  CutterDOWN_OPEN[15] := '...FFF........777...';
  CutterDOWN_OPEN[16] := '...FF..........77...';
  CutterDOWN_OPEN[17] := '..FFF..........777..';
  CutterDOWN_OPEN[18] := '..FF............77..';
  CutterDOWN_OPEN[19] := '..F..............7..';
  CutterDOWN_OPEN[20] := '....................';

  CutterDOWN_CLOSE[01] := '....................';
  CutterDOWN_CLOSE[02] := '......222..222......';
  CutterDOWN_CLOSE[03] := '.....2...22...2.....';
  CutterDOWN_CLOSE[04] := '.....2...22...2.....';
  CutterDOWN_CLOSE[05] := '.....2...22...2.....';
  CutterDOWN_CLOSE[06] := '......22222222......';
  CutterDOWN_CLOSE[07] := '.........F7.........';
  CutterDOWN_CLOSE[08] := '.........F7.........';
  CutterDOWN_CLOSE[09] := '........FF77........';
  CutterDOWN_CLOSE[10] := '........FF77........';
  CutterDOWN_CLOSE[11] := '........FF77........';
  CutterDOWN_CLOSE[12] := '........FF77........';
  CutterDOWN_CLOSE[13] := '........FF77........';
  CutterDOWN_CLOSE[14] := '........FF77........';
  CutterDOWN_CLOSE[15] := '........FF77........';
  CutterDOWN_CLOSE[16] := '........FF77........';
  CutterDOWN_CLOSE[17] := '........FF77........';
  CutterDOWN_CLOSE[18] := '........FF77........';
  CutterDOWN_CLOSE[19] := '.........F7.........';
  CutterDOWN_CLOSE[20] := '....................';

  CutterRIGHT_OPEN[01] := '....................';
  CutterRIGHT_OPEN[02] := '....................';
  CutterRIGHT_OPEN[03] := '................FFF.';
  CutterRIGHT_OPEN[04] := '..............FFFF..';
  CutterRIGHT_OPEN[05] := '...222......FFFFF...';
  CutterRIGHT_OPEN[06] := '..2...2...FFFFF.....';
  CutterRIGHT_OPEN[07] := '..2...2.FFFFF.......';
  CutterRIGHT_OPEN[08] := '..22..2FFFF.........';
  CutterRIGHT_OPEN[09] := '...2.2.FF...........';
  CutterRIGHT_OPEN[10] := '...222F.............';
  CutterRIGHT_OPEN[11] := '...2227.............';
  CutterRIGHT_OPEN[12] := '...2.2.77...........';
  CutterRIGHT_OPEN[13] := '..22..27777.........';
  CutterRIGHT_OPEN[14] := '..2...2.77777.......';
  CutterRIGHT_OPEN[15] := '..2...2...77777.....';
  CutterRIGHT_OPEN[16] := '...222......77777...';
  CutterRIGHT_OPEN[17] := '..............7777..';
  CutterRIGHT_OPEN[18] := '................777.';
  CutterRIGHT_OPEN[19] := '....................';
  CutterRIGHT_OPEN[20] := '....................';

  CutterRIGHT_CLOSE[01] := '....................';
  CutterRIGHT_CLOSE[02] := '....................';
  CutterRIGHT_CLOSE[03] := '....................';
  CutterRIGHT_CLOSE[04] := '....................';
  CutterRIGHT_CLOSE[05] := '....................';
  CutterRIGHT_CLOSE[06] := '..222...............';
  CutterRIGHT_CLOSE[07] := '.2...2..............';
  CutterRIGHT_CLOSE[08] := '.2...2..............';
  CutterRIGHT_CLOSE[09] := '.2...2.FFFFFFFFFFF..';
  CutterRIGHT_CLOSE[10] := '..2222FFFFFFFFFFFFF.';
  CutterRIGHT_CLOSE[11] := '..22227777777777777.';
  CutterRIGHT_CLOSE[12] := '.2...2.77777777777..';
  CutterRIGHT_CLOSE[13] := '.2...2..............';
  CutterRIGHT_CLOSE[14] := '.2...2..............';
  CutterRIGHT_CLOSE[15] := '..222...............';
  CutterRIGHT_CLOSE[16] := '....................';
  CutterRIGHT_CLOSE[17] := '....................';
  CutterRIGHT_CLOSE[18] := '....................';
  CutterRIGHT_CLOSE[19] := '....................';
  CutterRIGHT_CLOSE[20] := '....................';

  CutterLEFT_OPEN[01] := '....................';
  CutterLEFT_OPEN[02] := '....................';
  CutterLEFT_OPEN[03] := '.FFF................';
  CutterLEFT_OPEN[04] := '..FFFF..............';
  CutterLEFT_OPEN[05] := '...FFFFF......222...';
  CutterLEFT_OPEN[06] := '.....FFFFF...2...2..';
  CutterLEFT_OPEN[07] := '.......FFFFF.2...2..';
  CutterLEFT_OPEN[08] := '.........FFFF2...2..';
  CutterLEFT_OPEN[09] := '...........FF.2.22..';
  CutterLEFT_OPEN[10] := '.............F222...';
  CutterLEFT_OPEN[11] := '.............7222...';
  CutterLEFT_OPEN[12] := '...........77.2.2...';
  CutterLEFT_OPEN[13] := '.........77772..22..';
  CutterLEFT_OPEN[14] := '.......77777.2...2..';
  CutterLEFT_OPEN[15] := '.....77777...2...2..';
  CutterLEFT_OPEN[16] := '...77777......222...';
  CutterLEFT_OPEN[17] := '..7777..............';
  CutterLEFT_OPEN[18] := '.777................';
  CutterLEFT_OPEN[19] := '....................';
  CutterLEFT_OPEN[20] := '....................';

  CutterLEFT_CLOSE[01] := '....................';
  CutterLEFT_CLOSE[02] := '....................';
  CutterLEFT_CLOSE[03] := '....................';
  CutterLEFT_CLOSE[04] := '....................';
  CutterLEFT_CLOSE[05] := '....................';
  CutterLEFT_CLOSE[06] := '...............222..';
  CutterLEFT_CLOSE[07] := '..............2...2.';
  CutterLEFT_CLOSE[08] := '..............2...2.';
  CutterLEFT_CLOSE[09] := '..FFFFFFFFFFF.2...2.';
  CutterLEFT_CLOSE[10] := '.FFFFFFFFFFFFF2222..';
  CutterLEFT_CLOSE[11] := '.77777777777772222..';
  CutterLEFT_CLOSE[12] := '..77777777777.2...2.';
  CutterLEFT_CLOSE[13] := '..............2...2.';
  CutterLEFT_CLOSE[14] := '..............2...2.';
  CutterLEFT_CLOSE[15] := '...............222..';
  CutterLEFT_CLOSE[16] := '....................';
  CutterLEFT_CLOSE[17] := '....................';
  CutterLEFT_CLOSE[18] := '....................';
  CutterLEFT_CLOSE[19] := '....................';
  CutterLEFT_CLOSE[20] := '....................';




  Fr[1][1] := @CutterRIGHT_CLOSE;
  Fr[2][1] := @CutterRIGHT_OPEN;
  Fr[1][2] := @CutterUP_CLOSE;
  Fr[2][2] := @CutterUP_OPEN;
  Fr[1][3] := @CutterDOWN_CLOSE;
  Fr[2][3] := @CutterDOWN_OPEN;
  Fr[1][4] := @CutterRIGHT_CLOSE;
  Fr[2][4] := @CutterRIGHT_OPEN;
  Fr[1][5] := @CutterLEFT_CLOSE;
  Fr[2][5] := @CutterLEFT_OPEN;
End.
