
Unit Spaces;

Interface

Uses 
Objects, Graph, ODraws, Files, Crt;

Type 
  Space = Array[1..30, 1..20] Of PObject;

  PSpace = ^TSpace;
  TSpace = Object
    Exit   : Boolean;
    Save   : Boolean;
    Map    : Space;
    Switch : Array[1..8] Of PObject;
    Using  : PObject;
    Reg    : RegPlets;
    Name   : String;
    ExistPlets : Boolean;
    ExistExit  : Boolean;
    Constructor Init(MapReg : RegPlets);
    Procedure   Run;
    Virtual;
    Procedure   Show;
    Virtual;
    Destructor  Done(Var MapReg : RegPlets);
    Virtual;
  End;

Procedure Edit(x, y, Size : Integer; Var Str : String);
Procedure Message(PlaySound : Boolean; Msg : String);

Implementation

CONSTRUCTOR TSpace.Init(MapReg : RegPlets);

Var 
  i, j : Integer;

Begin
  Exit := False;
  Save := False;
  Reg  := MapReg;
  Name := MapReg.Name;
  ExistPlets := False;
  ExistExit  := False;

  SetColor(15);

  Rectangle( 20,  20, 621, 421);
  Rectangle( 20, 440, 181, 461);
  Rectangle(600, 440, 621, 461);

  StrWrite(120, 10, 1, 0, 'C H U P A - P L E T S        <Level Editor>', True
  );
  StrWrite( 20, 430, 14, 2, 'Objects', False);
  StrWrite(190, 450, 15, 0, 'Level : ', False);
  StrWrite(250, 450, 15, 0, Name, False);
  StrWrite(450, 430, 14, 4, 'Selected', False);

  Message(False, 'Wait a moment. Initializing objects...');

   {*** Objects ***}

  New(Switch[1], Init(PLETS,   1, 22));
  New(Switch[2], Init(EXITDOR, 2, 22));
  New(Switch[3], Init(CUTTER,  3, 22));
  New(Switch[4], Init(SPHERE,  4, 22));
  New(Switch[5], Init(CANDY,   5, 22));
  New(Switch[6], Init(WAY,     6, 22));
  New(Switch[7], Init(VOID,    7, 22));
  New(Switch[8], Init(WALL,    8, 22));

  New(Using, Init(PLETS, 30, 22));

  For i := 1 To 30 Do
    For j := 1 To 20 Do
      Begin
        New(Map[i,j], Init(MapReg.Space[i,j], i, j));
        If Map[i,j]^.Name = PLETS Then ExistPlets := True;
        If Map[i,j]^.Name = EXITDOR Then ExistExit := True;
      End;
  MouseCursor(True);
  Message(False,
          'ESC - Exit without save | F2 - Save and Exit | N - Change name');
End;

Procedure TSpace.Show;

Var 
  i, j : Integer;

Begin
  Using^.Show;
  For i := 1 To 8 Do
    Switch[i]^.Show;
  For i := 1 To 30 Do
    For j := 1 To 20 Do
      Map[i,j]^.Show;
End;

Procedure TSpace.Run;

Var 
  i, j : Integer;
  Key  : Char;

Begin
  Using^.Show;
  Repeat
    For i := 1 To 8 Do
      Begin
        If ((MousePressed) And (Switch[i]^.InRange)) Then
          Begin
            MouseCursor(False);
            Dispose(Using, Done);
            New(Using, Init(Switch[i]^.Name, 30, 22));
            MouseCursor(True);
          End;
      End;
    For i := 1 To 30 Do
      For j := 1 To 20 Do
        Begin
          If ((MousePressed) And (Map[i,j]^.InRange)) Then
            Begin
              If ((Not ((ExistPlets) And (Using^.Name = Plets)))
                 And (Map[i,j]^.Name <> Using^.Name)) Then
                Begin
                  MouseCursor(False);
                  If Map[i,j]^.Name = PLETS   Then ExistPlets := False;
                  Dispose(Map[i,j], Done);
                  New(Map[i,j], Init(Using^.Name, i, j));
                  If Map[i,j]^.Name = PLETS   Then ExistPlets := True;
                  MouseCursor(True);
                End;
            End;
        End;
    If KeyPressed Then
      Begin
        Key := ReadKey;
        If Key = #00 Then
          Begin
            Key := ReadKey;
            Case Key Of 
              #60 : {F2}
                    Begin
                      Exit := True;
                      Save := True;
                    End;
            End;
          End
        Else If ((Key = 'n') Or (Key = 'N')) Then
               Begin
                 Message(False,
                         'Changing level name <Esc - Cancel | ENTER - Accept>'
                 );
                 Edit(250, 450, 20, Name);
                 Message (False,
                'ESC - Exit without save | F2 - Save and Exit | N - Change name'
                 );
               End
        Else If Key = #27 Then Exit := True; {ESC}

      End;
    If ((Exit) And (Save)) Then
      Begin
        For i := 1 To 30 Do
          For j := 1 To 20 Do
            If Map[i,j]^.Name = EXITDOR Then ExistExit := True;
        If ((Not ExistPlets) Or (Not ExistExit)) Then
          Begin
            Message(True, 'A level needs 1 Plets and at least 1 Exit!');
            Exit := False;
            Save := False;
            Delay(1000);
            Message(False,
                'ESC - Exit without save | F2 - Save and Exit | N - Change name'
            )
          End;
        ExistExit := False;
      End;
    If Exit Then
      Begin
        Message(True,
                'Are you sure you want leave? ENTER - Yes | ESC - No');
        If ReadKey  <> #13 Then
          Begin
            Exit := False;
            Save := False;
          End;
        Message(False,
                'ESC - Exit without save | F2 - Save and Exit | N - Change name'
        );
      End;
  Until Exit;
  If Save Then
    Begin
      For i := 1 To 30 Do
        For j := 1 To 20 Do
          Reg.Space[i,j] := Map[i,j]^.Name;
      Reg.Name := Name;
    End;
End;

DESTRUCTOR TSpace.Done(Var MapReg : RegPlets);

Var 
  i, j : Integer;

Begin
  If Save Then
    Begin
      For i := 1 To 30 Do
        For j := 1 To 20 Do
          Reg.Space[i,j] := Map[i,j]^.Name;
    End;
  For i := 1 To 30 Do
    For j := 1 To 20 Do
      Dispose(Map[i,j] , Done);
  For i := 1 To 8 Do
    Dispose(Switch[i], Done);
  Dispose(Using, Done);

  MapReg := Reg;
  MouseCursor(False);
End;

{*************************************************************************}

Procedure Message(PlaySound : Boolean; Msg : String);

Var 
  i : Integer;

Begin
  MouseCursor(False);
  SetColor(4);
  For i := 471 To 779 Do
    Line(20, i, 620, i);
  SetColor(14);
  StrWrite(20, 471, 14, 4, Msg, False);
  If PlaySound Then
    Begin
      Sound(1000);
      Delay(100);
      NoSound;
    End;
  MouseCursor(True);
End;


Procedure Edit(x, y, Size : Integer; Var Str : String);

Const 
  MaxSize = 20;

Var 
  ExitEditName : Boolean;
  Accept       : Boolean;
  Edition      : String;
  i            : Integer;
  Key          : Char;

Begin
  MouseCursor(False);
  ExitEditName := False;
  Accept       := False;
  Edition      := Str;
  Repeat
    SetColor(1);
    For i := y-1 To y+8 Do
      Line(x-1, i, x+(Size*8), i);
    StrWrite(x, y, 14, 1, Edition, False);

    SetColor(14);
    Line(x+(Length(Edition)*8), y, x+(Length(Edition)*8), y+8);

    Key := ReadKey;
    Case Key Of 
      #27 : ExitEditName := True;
      #13 :
            Begin
              ExitEditName := True;
              Accept       := True;
            End;
      #08 :
            Begin
              If Length(Edition) > 0 Then
                Edition := Copy(Edition, 1, Length(Edition)-1);
            End;
      Else If Length(Edition) < Size Then
             Edition := Edition+Key;
    End;


    If Key = #27 Then ExitEditName := True;

  Until ExitEditName;
  If Accept Then Str := Edition;

  SetColor(0);
  For i := y-1 To y+8 Do
    Line(x-1, i, x+(Size*8), i);
  StrWrite(x, y, 15, 0, Str, False);
  MouseCursor(True);
End;

End.
