
Unit Spheres;

Interface

Uses 
Objects, Crt, SndObj;

Var 
  SphereSTOP : Format;
  SphereMOVE : Format;

  Fr : PFrames;

Type 
  Around = Array[1..3, 1..2] Of Boolean;

  PSphere = ^TSphere;
  TSphere = Object (TObject)
    Limit  : Around;
    FallingDown : Boolean;
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

CONSTRUCTOR TSphere.Init(Sound : PSndObj; SpcWar : PSpace; x, y : Integer);

Var 
  i, j : Integer;

Begin
  Frames := Fr;
  FallingDown := False;
  TObject.Init(Sound, SpcWar, SPHERE, x, y);
  SpaceWar^.Space[x,y] := @Self;
End;

Procedure TSphere.Draw;
Begin
  TObject.Draw;
End;

Procedure TSphere.Run;

Var 
  x, y  : Integer;

   {************** DROP DOWN **************}

Function GoDOWN : Boolean;

Var Ok : Boolean;

Begin
  Ok := False;
  If Not Limit[2,2] Then  {if down is limit}
    Begin
      If SpaceWar^.Space[posx, posy+1] = Nil Then {and there is nothing}
        Begin
          Move(DOWN); {drop down}
          FallingDown := True;
          Ok     := True;
        End
      Else
        If (((SpaceWar^.Space[posx, posy+1]^.Name = PLETS)   Or
           (SpaceWar^.Space[posx, posy+1]^.Name = CUTTER)) And
           (FallingDown))                                       Then
          Begin
            Snd^.Snd(EXPLOITSND);
            SpaceWar^.Space[posx, posy+1]^.Destroy := True;
            Destroy := True;
            Explode := True;
          End
      Else
        Begin
          If FallingDown Then Snd^.Snd(GODOWNSND);
          FallingDown := False;
        End;
    End
  Else FallingDown := False;
  GoDOWN := Ok;
End;

   {************** DROP RIGHT ****************}

Function GoRIGHT : Boolean;

Var Ok : Boolean;

Begin
  Ok := False;
  If Not Limit[3,2] Then {if right is not limit}
    If SpaceWar^.Space[posx+1, posy+1] = Nil Then {and there is nothing}
      If SpaceWar^.Space[posx+1, posy] = Nil Then {and right is nothing}
        Begin
          Move(RIGHT);   {move right and drop down}
          FallingDown := True;
          Ok := True;
        End;
  GoRIGHT := Ok;
End;

   {************** DROP LEFT ****************}

Function GoLEFT : Boolean;

Var Ok : Boolean;

Begin
  Ok := False;
  If Not Limit[1,2] Then {if left is not limit}
    If SpaceWar^.Space[posx-1, posy+1] = Nil Then {and there is nothing}
      If SpaceWar^.Space[posx-1, posy] = Nil Then {and left is nothing}
        Begin
          Move(LEFT);     {move left and drop down}
          FallingDown := True;
          Ok := True;
        End;
  GoLEFT := Ok;
End;


Begin
  If InMov Then Move(Direction)
  Else
    Begin
      {take objects around}
      For x := posx-1 To posx+1 Do
        Begin
          For y := posy To posy+1 Do
            Begin
              Limit[x-posx+2,y-posy+1] := ((x<1) Or (x>30) Or (y<1) Or (y>20));
            End;
        End;
      If Not GoDOWN Then
         {if down is not PLETS and not WAY}
        If ((SpaceWar^.Space[posx,posy+1]^.Name <> PLETS) And
           (SpaceWar^.Space[posx,posy+1]^.Name <> WAY))  Then
          If Not GoRIGHT Then
            If Not GoLEFT Then
              FallingDown := False;
    End;
End;

Procedure TSphere.Move(Dir : Integer);

Begin
  If InMov Then TObject.Move(Direction)
  Else
    Begin
      Case Dir Of 
        RIGHT : If Not Limit[3,1] Then
                  If SpaceWar^.Space[posx+1,posy] = Nil Then
                    TObject.Move(Dir);
        LEFT  : If Not Limit[1,1] Then
                  If SpaceWar^.Space[posx-1,posy] = Nil Then
                    TObject.Move(Dir);
        DOWN  : If Not Limit[2,2] Then
                  If SpaceWar^.Space[posx, posy+1] = Nil Then
                    TObject.Move(Dir);
      End;
    End;
End;

DESTRUCTOR TSphere.Done;

Begin
  TObject.Done;
End;

{****************************************************************************}

Begin
  SphereSTOP[01] := '....................';
  SphereSTOP[02] := '.......777777.......';
  SphereSTOP[03] := '.....7777777777.....';
  SphereSTOP[04] := '....777F77777777....';
  SphereSTOP[05] := '...777F7F77777777...';
  SphereSTOP[06] := '..777F7F7777777777..';
  SphereSTOP[07] := '..7777F7F777777777..';
  SphereSTOP[08] := '.777777777777777777.';
  SphereSTOP[09] := '..44466CCEECC66444..';
  SphereSTOP[10] := '..44466CCEECC66444..';
  SphereSTOP[11] := '..44466CCEECC66444..';
  SphereSTOP[12] := '..44466CCEECC66444..';
  SphereSTOP[13] := '.777777777777777777.';
  SphereSTOP[14] := '..7777777777777777..';
  SphereSTOP[15] := '..7777777777777777..';
  SphereSTOP[16] := '...77777777777777...';
  SphereSTOP[17] := '....777777777777....';
  SphereSTOP[18] := '.....7777777777.....';
  SphereSTOP[19] := '.......777777.......';
  SphereSTOP[20] := '....................';

  SphereMOVE[01] := '....................';
  SphereMOVE[02] := '.......7....7.......';
  SphereMOVE[03] := '.....7774444777.....';
  SphereMOVE[04] := '....777F44447777....';
  SphereMOVE[05] := '...777F7444477777...';
  SphereMOVE[06] := '..777F7F6666777777..';
  SphereMOVE[07] := '..7777F76666777777..';
  SphereMOVE[08] := '.7777777CCCC7777777.';
  SphereMOVE[09] := '.7777777CCCC7777777.';
  SphereMOVE[10] := '77777777EEEE77777777';
  SphereMOVE[11] := '77777777EEEE77777777';
  SphereMOVE[12] := '.7777777CCCC7777777.';
  SphereMOVE[13] := '.7777777CCCC7777777.';
  SphereMOVE[14] := '..7777776666777777..';
  SphereMOVE[15] := '..7777776666777777..';
  SphereMOVE[16] := '...77777444477777...';
  SphereMOVE[17] := '....777744447777....';
  SphereMOVE[18] := '.....7774444777.....';
  SphereMOVE[19] := '.......7....7.......';
  SphereMOVE[20] := '....................';

  Fr[1][1] := @SphereSTOP;
  Fr[2][1] := @SphereMOVE;
  Fr[1][2] := @SphereSTOP;
  Fr[2][2] := @SphereMOVE;
  Fr[1][3] := @SphereSTOP;
  Fr[2][3] := @SphereMOVE;
  Fr[1][4] := @SphereSTOP;
  Fr[2][4] := @SphereMOVE;
  Fr[1][5] := @SphereSTOP;
  Fr[2][5] := @SphereMOVE;
End.
