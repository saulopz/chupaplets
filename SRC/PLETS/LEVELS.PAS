
Unit Levels;

Interface

Uses 
Graph, Crt, Dos, Objects, Players, Walls, Ways,
Cutters, Spheres, Candys, Exits, SndObj, Files;

Const 
  XFILENAME = 10;
  YFILENAME = 455;
  XLEVELNAME = 140;
  YLEVELNAME = 455;
  XQTIDADE  = 350;
  YQTIDADE  = 455;

Type 
  Elems = Array[1..20] Of String[30];

  PLevel = ^TLevel;
  TLevel = Object
    Private 
      Sair          : Boolean;
      FileName      : String;
      LevelName      : String;
      Qtidade       : String;
      Spaces        : PSpace;
      ElemPlets     : PPlayer;
      PosDestruction: Integer;
    Public 
      Constructor Init(Sound : PSndObj; FileN : String; Reg : RegPlets);
      Procedure   Run;
      Procedure   InitBoxes;
      Destructor  Done;
  End;

Var 
  strs    : String;
  OldTime : LongInt;
  Time    : LongInt;

Implementation

{----------------------------------------------------------------}

Function GetValTimer : LongInt;

Var 
  h, m, s, ss : Word;
  Timer       : LongInt;

Begin
  GetTime(h, m, s, ss);
  Timer := (h*60)+m;
  Timer := (Timer*60)+s;
  Timer := (Timer*100)+ss;
  GetValTimer := Timer;
End;

Procedure EsvaziaBuffer;
Begin
{ Initialize keyboard buffer and point to end }
  mem[$0040: $001A] := mem[$0040:$001C]; { HeadBuf := TailBuf }
End;

Procedure Wait(TimeToWait : Integer);
Begin
  EsvaziaBuffer;
  Repeat
    Time := GetValTimer;
  Until Time > OldTime+TimeToWait;
End;

Procedure TLevel.InitBoxes;

Var 
  x1, y1  : Integer;
  x2, y2  : Integer;
  i       : Integer;

Begin
  x1 := 2;
  y1 := 2;
  x2 := 637;
  y2 := 438;
  SetColor(8);
  For i := 1 To 16 Do
    Begin
      Rectangle(x1, y1, x2, y2);
      inc(x1);
      inc(y1);
      dec(x2);
      dec(y2);
    End;
  SetColor(15);
  Line(0, 0, 0, 440);
  Line(0, 0, 639, 0);
  Line(1, 1, 1, 439);
  Line(1, 1, 638, 1);

  Line(20, 421, 620, 421);
  Line(19, 422, 621, 422);
  Line(621, 20, 621, 420);
  Line(622, 19, 622, 422);

  SetColor(0);

  Line(20, 19, 620, 19);
  Line(19, 18, 621, 18);
  Line(19, 20, 20, 420);
  Line(18, 19, 19, 421);

  SetColor(4);
  For i := 441 To 479 Do
    Line(0, i, 639, i);

  StrWrite(10,  445, 14, 4, 'File', False);
  StrWrite(140, 445, 14, 4, 'Level', False);
  StrWrite(350, 445, 14, 4, 'Candy candy', False);
  SetTextStyle(DefaultFont, HorizDir, 1);
  StrWrite(XFILENAME, YFILENAME, 15, 1, FileName, False);
  StrWrite(XLEVELNAME, YLEVELNAME, 15, 1, LevelName, False);
  StrWrite(XQTIDADE,  YQTIDADE,  15, 1, Qtidade, False);
End;

{----------------------------------------------------------------}

CONSTRUCTOR TLevel.Init(Sound : PSndObj; FileN : String; Reg : RegPlets);

Var 
  ElemWall  : PWall;
  ElemWay   : PWay;
  ElemCutter: PCutter;
  ElemSphere: PSphere;
  ElemCandy : PCandy;
  ElemExit  : PExitDor;
  x, y      : Integer;

Begin
  Sair := False;
  FileName := FileN;
  LevelName := Reg.Name;
  InitBoxes;
  New(Spaces, Init(Sound));
  For y := 1 To 20 Do
    For x := 1 To 30 Do
      Case Reg.Space[x, y] Of 
        PLETS :
                Begin
                  New(ElemPlets, Init(Sound, Spaces, x,  y));
                  Spaces^.Space[x, y] := ElemPlets;
                End;
        WALL :
               Begin
                 New(ElemWall, Init(Spaces, x,  y));
                 Spaces^.Space[x, y] := ElemWall;
               End;
        WAY :
              Begin
                New(ElemWay, Init(Spaces, x, y));
                Spaces^.Space[x, y] := ElemWay;
              End;
        CUTTER :
                 Begin
                   New(ElemCutter, Init(Sound, Spaces, x, y));
                   Spaces^.Space[x, y] := ElemCutter;
                 End;
        SPHERE :
                 Begin
                   New(ElemSphere, Init(Sound, Spaces, x, y));
                   Spaces^.Space[x, y] := ElemSphere;
                 End;
        CANDY :
                Begin
                  New(ElemCandy, Init(Sound, Spaces, x, y));
                  Spaces^.Space[x, y] := ElemCandy;
                  Inc(Spaces^.ScoreTotal);
                End;
        EXITDOR :
                  Begin
                    New(ElemExit, Init(Spaces, x, y));
                    Spaces^.Space[x, y] := ElemExit;
                  End;
        Else Spaces^.Space[x][y] := Nil;
      End;
End;

Procedure TLevel.Run;

Var 
  Value : Integer;

Begin
  Exit := NO;
  Time := GetValTimer;
  PosDestruction := 0;
  Repeat
    OldTime := Time;
    Spaces^.Run;
    Wait(20);
    If Exit = YES Then
      Inc(PosDestruction);
    Str(Spaces^.QtdFalta, Qtidade);
    StrWrite(XQTIDADE,  YQTIDADE,  15, 1, Qtidade+' ', False);
  Until PosDestruction > 5;

End;

DESTRUCTOR TLevel.Done;

Var 
  x, y : Integer;

Begin
  For y := 1  To 20 Do
    For x := 1 To 30 Do
      If Spaces^.Space[x][y] <> Nil Then
        Dispose(Spaces^.Space[x][y], Done);
  Dispose(Spaces, Done);
End;

End.
