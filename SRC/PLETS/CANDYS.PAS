
Unit Candys;

Interface

Uses 
Graph, Objects, Crt, SndObj;

Var 
  Candy1 : Format;
  Candy2 : Format;

  Fr : PFrames;

Type 
  Around = Array[1..3, 1..2] Of Boolean;

  PCandy = ^TCandy;
  TCandy = Object (TObject)
    Limit  : Around;
    FallingDown : Boolean;
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

Implementation

CONSTRUCTOR TCandy.Init(Sound : PSndObj; SpcWar : PSpace; x, y : Integer);

Var
  i, j : Integer;

Begin
  Frames := Fr;
  TObject.Init(Sound, SpcWar, CANDY, x, y);
  SpaceWar^.Space[x,y] := @Self;
End;

Procedure TCandy.Run;

Var 
  x, y  : Integer;

   {************** DROP DOWN **************}

Function GoDOWN : Boolean;

Var Ok : Boolean;

Begin
  Ok := False;
  If Not Limit[2,2] Then  {if down is not the limit}
    Begin
      If SpaceWar^.Space[posx, posy+1] = Nil Then
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
    If SpaceWar^.Space[posx+1, posy+1] = Nil Then {if nothing}
      If SpaceWar^.Space[posx+1, posy] = Nil Then {if right is nothing}
        Begin
          Move(RIGHT);   {move to right to drop down}
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
  If Not Limit[1,2] Then {if left is limit}
    If SpaceWar^.Space[posx-1, posy+1] = Nil Then {if nothig}
      If SpaceWar^.Space[posx-1, posy] = Nil Then {if left is nothing}
        Begin
          Move(LEFT);     {move left to drop down}
          FallingDown := True;
          Ok := True;
        End;
  GoLEFT := Ok;
End;


Begin
  If InMov Then Move(Direction)
  Else
    Begin
      For x := posx-1 To posx+1 Do   {Take objects around}
        For y := posy To posy+1 Do
          Limit[x-posx+2,y-posy+1] := ((x<1) Or (x>30) Or (y<1) Or (y>20));
      If Not GoDOWN Then
            {if down is not PLETS and not WAY}
        If ((SpaceWar^.Space[posx,posy+1]^.Name <> PLETS) And
           (SpaceWar^.Space[posx,posy+1]^.Name <> WAY))  Then
          If Not GoRIGHT Then
            If Not GoLEFT Then
              FallingDown    := False;
    End;
End;

Procedure TCandy.Draw;

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


Procedure TCandy.Erase;

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


Procedure TCandy.Move(Dir : Integer);
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

DESTRUCTOR TCandy.Done;
Begin
  TObject.Done;
End;

{****************************************************************************}

Begin
  Candy1[01] := '....................';
  Candy1[02] := '..........9.........';
  Candy1[03] := '..........9.........';
  Candy1[04] := '..........9.........';
  Candy1[05] := '....99...F9...F9....';
  Candy1[06] := '....F99..F9..F99....';
  Candy1[07] := '.....F99.F9.F99.....';
  Candy1[08] := '......F99F9F99......';
  Candy1[09] := '.......F9F999.......';
  Candy1[10] := '.FFFFFFFF99FFFFF....';
  Candy1[11] := '....999999999999999.';
  Candy1[12] := '......999F99F.......';
  Candy1[13] := '......99FF999F......';
  Candy1[14] := '.....99F.F9.99F.....';
  Candy1[15] := '....99F..F9..99F....';
  Candy1[16] := '....9F...F9...99....';
  Candy1[17] := '.........F..........';
  Candy1[18] := '.........F..........';
  Candy1[19] := '.........F..........';
  Candy1[20] := '....................';

  Candy2[01] := '....................';
  Candy2[02] := '....................';
  Candy2[03] := '....................';
  Candy2[04] := '..........9.........';
  Candy2[05] := '..........9.........';
  Candy2[06] := '..........9.........';
  Candy2[07] := '......9...9..9......';
  Candy2[08] := '.......9.F9.9.......';
  Candy2[09] := '........9F99........';
  Candy2[10] := '...FFFFFF99FFF......';
  Candy2[11] := '......99999999999...';
  Candy2[12] := '.......99F99F.......';
  Candy2[13] := '.......9.F9.9.......';
  Candy2[14] := '......9..F...9......';
  Candy2[15] := '.........F..........';
  Candy2[16] := '.........F..........';
  Candy2[17] := '.........F..........';
  Candy2[18] := '....................';
  Candy2[19] := '....................';
  Candy2[20] := '....................';

  Fr[1][1] := @Candy1;
  Fr[2][1] := @Candy2;
  Fr[1][2] := @Candy1;
  Fr[2][2] := @Candy2;
  Fr[1][3] := @Candy1;
  Fr[2][3] := @Candy2;
  Fr[1][4] := @Candy1;
  Fr[2][4] := @Candy2;
  Fr[1][5] := @Candy1;
  Fr[2][5] := @Candy2;
End.
