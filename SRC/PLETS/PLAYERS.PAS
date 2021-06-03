
Unit Players;

Interface

Uses 
Objects, Crt, SndObj;

Var 
  PlayerSTOP        : Format;
  PlayerUP          : Format;
  PlayerDOWN        : Format;
  PlayerLEFT_CLOSE  : Format;
  PlayerLEFT_OPEN   : Format;
  PlayerRIGHT_CLOSE : Format;
  PlayerRIGHT_OPEN  : Format;

  Fr : PFrames;

Type 
  PPlayer = ^TPlayer;
  TPlayer = Object (TObject)
    Steps  : Integer;
    Etapas : Integer;
    Finished: Boolean;
    PosDestructin : Integer;
    Constructor Init(Sound : PSndObj; SpcWar : PSpace; x, y : Integer);
    Procedure   Run;
    Virtual;
    Procedure   Move(Dir : Integer);
    Virtual;
    Destructor  Done;
    Virtual;
  End;

Implementation

CONSTRUCTOR TPLayer.Init(Sound : PSndObj; SpcWar : PSpace; x, y : Integer);

Var 
  i, j : Integer;

Begin
  Frames := Fr;
  Steps  := 0;
  Etapas := 0;
  Finished := False;
  TObject.Init(Sound, SpcWar, PLETS, x, y);
  SpaceWar^.Space[x,y] := @Self;
End;

Procedure TPlayer.Run;

Var 
  Dir : Integer;
  Key : Char;

Begin
  Inc(Steps);
  If Finished Then
    Begin
      If Etapas = 0 Then
        Direction := STOP
      Else If Etapas < 10 Then
             Begin
               Case Direction Of 
                 STOP : Direction := RIGHT;
                 RIGHT: Direction := LEFT;
                 LEFT : Direction := STOP;
               End;
             End
      Else Destroy := True;
      Draw;
      Inc(Etapas);
    End;
  If InMov Then Move(GetDirection);
  If (Not InMov And KeyPressed) Then
    Begin
      Dir := STOP;
      Key := Readkey;
      Case Key Of 
        #00 :
              Begin
                Key := ReadKey;
                Case Key Of 
                  #72 : Dir := UP;
                  #80 : Dir := DOWN;
                  #77 : Dir := RIGHT;
                  #75 : Dir := LEFT;
                  Else  Dir := STOP;
                End;
              End;
        #27 :
              Begin
                Snd^.Snd(EXPLOITSND);
                Destroy := True;
                Explode := True;
              End;
        Else  Dir  := STOP;
      End;
      Move(Dir);
      Steps := 0;
    End;
  If Destroy Then exit := YES;
  If Steps = 10 Then
    Begin
      Direction := STOP;
      Draw;
    End;
End;

Procedure TPlayer.Move(Dir : Integer);

Var 
  Obj : PObject;
  Limit : Boolean;

Begin
  Limit := False;
  Obj  := Nil;
  If InMov Then
    Begin
      Obj := SpaceWar^.Space[posx, posy];
      TObject.Move(Dir);
    End
  Else
    Begin
      Case Dir Of 
        UP    : If posy > 01 Then Obj := SpaceWar^.Space[posx, posy-1]
                Else Limit := True;
        DOWN  : If posy < 20 Then Obj := SpaceWar^.Space[posx, posy+1]
                Else Limit := True;
        LEFT  : If posx > 01 Then Obj := SpaceWar^.Space[posx-1, posy]
                Else Limit := True;
        RIGHT : If posx < 30 Then Obj := SpaceWar^.Space[posx+1, posy]
                Else Limit := True;
      End;
      If Limit Then
        Begin
              {It is limit and do nothing}
        End
      Else If Obj = Nil Then
             Begin
             {if nothing, move}
               If Not ((RShiftPres) Or (LShiftPres)) Then
                 TObject.Move(Dir)
               Else
                 Begin
                   Direction := Dir;
                   Draw;
                 End;
             End
      Else If Obj^.Name = SPHERE Then
             Begin
             {if sphere, push if possible}
               Obj^.Move(Dir);
               Snd^.Snd(PUSHSND);
               If ((Obj^.posx < posx-1) Or (Obj^.posx>posx+1)) Then
                 Tobject.Move(Dir)
               Else
                 Begin
                   Direction := Dir;
                   Draw;
                 End;
             End
      Else If Obj^.Name = WAY Then
             Begin
             {move and eat}
               Obj^.Destroy := True;
               Snd^.Snd(WAYSND);
               If Not ((RShiftPres) Or (LShiftPres)) Then
                 TObject.Move(Dir)
               Else
                 Begin
                   Direction := Dir;
                   Draw;
                 End;
             End
      Else If Obj^.Name = CUTTER Then
             Begin
              {Explode and explode cutter}
               Destroy  := True;
               Obj^.Destroy := True;
               Explode := True;
               Snd^.Snd(EXPLOITSND);
             End
      Else If Obj^.Name = CANDY Then
             Begin
              {eat and incrase points}
               Snd^.Snd(FORCESND);
               Obj^.Destroy := True;
               Inc(Scores);
               If Not ((RShiftPres) Or (LShiftPres)) Then
                 TObject.Move(Dir)
               Else
                 Begin
                   Direction := Dir;
                   Draw;
                 End;
             End
      Else If Obj^.Name = EXPLOIT Then
             Begin
              {Explosion detected, then explode too}
               Destroy := True;
               Snd^.Snd(EXPLOITSND);
             End
      Else If Obj^.Name = WALL Then
             Begin
              {if wall, dont move}
             End
      Else If Obj^.Name = EXITDOR Then
             Begin
              {if eatten all candy}
               Snd^.Snd(DOORSND);
               Finished := Scores = SpaceWar^.ScoreTotal;
             End;
    End;
End;

DESTRUCTOR TPlayer.Done;

Begin
  Exit := YES;
  TObject.Done;
End;

{****************************************************************************}

Begin
  PlayerSTOP[01] := '....................';
  PlayerSTOP[02] := '....................';
  PlayerSTOP[03] := '......4CCCCCC4......';
  PlayerSTOP[04] := '.....ECCCCCCCEE4....';
  PlayerSTOP[05] := '....ECCCCCCCCCCE4...';
  PlayerSTOP[06] := '...ECCCCCCCCCCCCC...';
  PlayerSTOP[07] := '..4CCCBCCCCCCCBCCC..';
  PlayerSTOP[08] := '.4CCCB0CCCCCCC0BCCC.';
  PlayerSTOP[09] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerSTOP[10] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerSTOP[11] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerSTOP[12] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerSTOP[13] := '.44C44CCCCCCCC44CCC.';
  PlayerSTOP[14] := '.44CC424CCCC424CC44.';
  PlayerSTOP[15] := '..44CCC422224CCC44..';
  PlayerSTOP[16] := '...44CCC4444CCC44...';
  PlayerSTOP[17] := '....444CCCCCC444....';
  PlayerSTOP[18] := '.....4444444444.....';
  PlayerSTOP[19] := '.......444444.......';
  PlayerSTOP[20] := '....................';

  PlayerUP[01] := '....................';
  PlayerUP[02] := '....................';
  PlayerUP[03] := '......4CCCCCC4......';
  PlayerUP[04] := '.....ECCCCCCCEE4....';
  PlayerUP[05] := '....ECCCCCCCCCCE4...';
  PlayerUP[06] := '...ECCCCCCCCCCCCC...';
  PlayerUP[07] := '..4CCB0CCCCCCC0BCC..';
  PlayerUP[08] := '.4CCCBBCCCCCCCBBCCC.';
  PlayerUP[09] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerUP[10] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerUP[11] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerUP[12] := '.CCC44CCCCCCCC44CCC.';
  PlayerUP[13] := '.44CC4277777724CCCC.';
  PlayerUP[14] := '.44CCCC477774CCCC44.';
  PlayerUP[15] := '..44CCCC4444CCCC44..';
  PlayerUP[16] := '...44CCCCCCCCCC44...';
  PlayerUP[17] := '....444CCCCCC444....';
  PlayerUP[18] := '.....4444444444.....';
  PlayerUP[19] := '.......444444.......';
  PlayerUP[20] := '....................';

  PlayerDOWN[01] := '....................';
  PlayerDOWN[02] := '....................';
  PlayerDOWN[03] := '.......4CCCCCC4.....';
  PlayerDOWN[04] := '......ECCCCCCCEE4...';
  PlayerDOWN[05] := '.....ECCCCCCCCCCE4..';
  PlayerDOWN[06] := '....ECCCCCCCCCCCCC..';
  PlayerDOWN[07] := '...4CCCCCCCCCCCCCCC.';
  PlayerDOWN[08] := '..4CCCCCCCCCCCCCCCC.';
  PlayerDOWN[09] := '..CCCCBBCCCCCCBBCCC.';
  PlayerDOWN[10] := '..CCCCB0CCCCCC0BCCC.';
  PlayerDOWN[11] := '..CCCCCCCCCCCCCCCCC.';
  PlayerDOWN[12] := '..CCCCCCCCCCCCCCCCC.';
  PlayerDOWN[13] := '..44CCCCCCCCCCCCCCC.';
  PlayerDOWN[14] := '..44C44CCCCCCCC44C4.';
  PlayerDOWN[15] := '...44C424CCCC424C44.';
  PlayerDOWN[16] := '....44C44444444C44..';
  PlayerDOWN[17] := '.....44CC7777CC44...';
  PlayerDOWN[18] := '......4444444444....';
  PlayerDOWN[19] := '........444444......';
  PlayerDOWN[20] := '....................';

  PlayerLEFT_CLOSE[01] := '....................';
  PlayerLEFT_CLOSE[02] := '....................';
  PlayerLEFT_CLOSE[03] := '......CCCCCCCC......';
  PlayerLEFT_CLOSE[04] := '.....CCCCCCCCCCC....';
  PlayerLEFT_CLOSE[05] := '....CCCCCC666CCCC...';
  PlayerLEFT_CLOSE[06] := '...CCCCCCC6666CCC...';
  PlayerLEFT_CLOSE[07] := '..CCCBBCCC66E66CCC..';
  PlayerLEFT_CLOSE[08] := '.CCCC0BCCC6EEE6CCCC.';
  PlayerLEFT_CLOSE[09] := '.CCCCCCCCCC6EECCCCC.';
  PlayerLEFT_CLOSE[10] := '.CCCCCCCCCCC666CCCC.';
  PlayerLEFT_CLOSE[11] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerLEFT_CLOSE[12] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerLEFT_CLOSE[13] := '.44CCCCCCCCCCCCCCCC.';
  PlayerLEFT_CLOSE[14] := '.44CCCCC44CCCCCCC44.';
  PlayerLEFT_CLOSE[15] := '..444444CCCCCCC444..';
  PlayerLEFT_CLOSE[16] := '...4444CCCCCCCC44...';
  PlayerLEFT_CLOSE[17] := '....44444CCCC444....';
  PlayerLEFT_CLOSE[18] := '.....4444444444.....';
  PlayerLEFT_CLOSE[19] := '.......444444.......';
  PlayerLEFT_CLOSE[20] := '....................';

  PlayerLEFT_OPEN[01] := '....................';
  PlayerLEFT_OPEN[02] := '....................';
  PlayerLEFT_OPEN[03] := '......CCCCCCCC......';
  PlayerLEFT_OPEN[04] := '.....CCCCCCCCCCC....';
  PlayerLEFT_OPEN[05] := '....CCCCCC666CCCC...';
  PlayerLEFT_OPEN[06] := '...CCCCCCC6666CCC...';
  PlayerLEFT_OPEN[07] := '..CCCBBCCC66E66CCC..';
  PlayerLEFT_OPEN[08] := '.CCCC0BCCC6EEE6CCCC.';
  PlayerLEFT_OPEN[09] := '.CCCCCCCCCC6EECCCCC.';
  PlayerLEFT_OPEN[10] := '.CCCCCCCCCCC666CCCC.';
  PlayerLEFT_OPEN[11] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerLEFT_OPEN[12] := '...CCCCCCCCCCCCCCCC.';
  PlayerLEFT_OPEN[13] := '....27777CCCCCCCCCC.';
  PlayerLEFT_OPEN[14] := '....777744CCCCCCC44.';
  PlayerLEFT_OPEN[15] := '...77774CCCCCCC444..';
  PlayerLEFT_OPEN[16] := '..77774CCCCCCCC44...';
  PlayerLEFT_OPEN[17] := '...744444CCCC444....';
  PlayerLEFT_OPEN[18] := '....44444444444.....';
  PlayerLEFT_OPEN[19] := '......4444444.......';
  PlayerLEFT_OPEN[20] := '....................';


  PlayerRIGHT_CLOSE[01] := '....................';
  PlayerRIGHT_CLOSE[02] := '....................';
  PlayerRIGHT_CLOSE[03] := '......CCCCCCCC......';
  PlayerRIGHT_CLOSE[04] := '.....CCCCCCCCCCC....';
  PlayerRIGHT_CLOSE[05] := '....CCC666CCCCCCC...';
  PlayerRIGHT_CLOSE[06] := '...CCC6666CCCCCCC...';
  PlayerRIGHT_CLOSE[07] := '..CCC66E66CCCBBCCC..';
  PlayerRIGHT_CLOSE[08] := '.CCC66EEE6CCCB0CCCC.';
  PlayerRIGHT_CLOSE[09] := '.CCC66EE6CCCCCCCCCC.';
  PlayerRIGHT_CLOSE[10] := '.CCCC666CCCCCCCCCCC.';
  PlayerRIGHT_CLOSE[11] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerRIGHT_CLOSE[12] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerRIGHT_CLOSE[13] := '.44CCCCCCCCCCCCCCCC.';
  PlayerRIGHT_CLOSE[14] := '.44CCCCCCC44CCCCC44.';
  PlayerRIGHT_CLOSE[15] := '..44CCCCCCCC444444..';
  PlayerRIGHT_CLOSE[16] := '...44CCCCCCCCC444...';
  PlayerRIGHT_CLOSE[17] := '....444CCCC44444....';
  PlayerRIGHT_CLOSE[18] := '.....4444444444.....';
  PlayerRIGHT_CLOSE[19] := '.......444444.......';
  PlayerRIGHT_CLOSE[20] := '....................';

  PlayerRIGHT_OPEN[01] := '....................';
  PlayerRIGHT_OPEN[02] := '....................';
  PlayerRIGHT_OPEN[03] := '......CCCCCCCC......';
  PlayerRIGHT_OPEN[04] := '.....CCCCCCCCCCC....';
  PlayerRIGHT_OPEN[05] := '....CCC666CCCCCCC...';
  PlayerRIGHT_OPEN[06] := '...CCC6666CCCCCCC...';
  PlayerRIGHT_OPEN[07] := '..CCC66E66CCCBBCCC..';
  PlayerRIGHT_OPEN[08] := '.CCC66EEE6CCCB0CCCC.';
  PlayerRIGHT_OPEN[09] := '.CCC66EE6CCCCCCCCCC.';
  PlayerRIGHT_OPEN[10] := '.CCCC666CCCCCCCCCCC.';
  PlayerRIGHT_OPEN[11] := '.CCCCCCCCCCCCCCCCCC.';
  PlayerRIGHT_OPEN[12] := '.CCCCCCCCCCCCCCCC...';
  PlayerRIGHT_OPEN[13] := '.44CCCCCCC777772....';
  PlayerRIGHT_OPEN[14] := '.44CCCCCCCC77777....';
  PlayerRIGHT_OPEN[15] := '..44CCCCCCCC777777..';
  PlayerRIGHT_OPEN[16] := '...44CCCCCCCCC7777..';
  PlayerRIGHT_OPEN[17] := '....444CCCC444447...';
  PlayerRIGHT_OPEN[18] := '.....44444444444....';
  PlayerRIGHT_OPEN[19] := '.......4444444......';
  PlayerRIGHT_OPEN[20] := '....................';

  Fr[1][1] := @PlayerSTOP;
  Fr[2][1] := @PlayerSTOP;
  Fr[1][2] := @PlayerUP;
  Fr[2][2] := @PlayerUP;
  Fr[1][3] := @PlayerDOWN;
  Fr[2][3] := @PlayerDOWN;
  Fr[1][4] := @PlayerRIGHT_OPEN;
  Fr[2][4] := @PlayerRIGHT_CLOSE;
  Fr[1][5] := @PlayerLEFT_OPEN;
  Fr[2][5] := @PlayerLEFT_CLOSE;
End.
