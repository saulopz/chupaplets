
Program Plets;

Uses 
graph, Crt, Dos, SndObj, Levels, MainMenu, Objects, Files;

Type 
  TPlets = Object
    Private 
      Reg    : RegPlets;
      Level  : TLevel;
      Snd    : PSndObj;
      OFile  : String;
      OLevel : String;
      Num    : String;
    Public 
      Constructor Init;
      Procedure   Help;
      Procedure   Show;
      Procedure   Run;
      Procedure   Message(Msg : String);
      Function    ReadLevel : String;
      Procedure   RunLevel;
      Procedure   Error(Msg : String);
      Destructor  Done;
  End;

Procedure Edit(x, y, Size : Integer; Var Str : String);
Forward;

CONSTRUCTOR TPlets.Init;

Var 
  d, m : Integer;

Begin
  ClearReg(Reg);
  If ParamStr(1) = '' Then
    OFile := 'PLETS.FSE'
  Else
    OFile := ParamStr(1);
  If ReadRegFromFile(OFile, 1, Reg) Then
    OLevel := Reg.Name
  Else
    Begin
      OFile  := '';
      OLevel := '';
    End;
  Num := '1';
  New(Snd, Init);
  write('oi');
  d := Detect;
  InitGraph(d, m, '');
End;

DESTRUCTOR TPlets.Done;
Begin
  CloseGraph;
  Dispose(Snd, Done);
End;

Function  TPlets.ReadLevel : String;

Var 
  key : Char;
  Exit: Boolean;
  i, j: Integer;
  Stri: String;
  Code: Integer;
  Name: String;
  Fse : String;
  Rg  : RegPlets;
  Rg2 : RegPlets;

Begin
  Exit := False;
  i    := 1;
  Rg := Reg;
  Rg2 := Rg;
  Name := OLevel;
  Stri := Num;
  Repeat
    SetColor(1);
    For j := 179 To 188 Do
      Line(260, j, 290+(20*8), j);
    StrWrite(260, 180, 14, 1, Stri+' - ', False);
    StrWrite(290, 180, 14, 1, Name, False);
    Key := ReadKey;
    Case Key Of 
      #27 : Exit := True;
      #13 :
            Begin
              Exit  := True;
              Reg   := Rg;
              OLevel := Name;
              Num   := Stri;
            End;
      #00 :
            Begin
              Key := ReadKey;
              Case Key Of 
                #72 :
                      Begin
                        If i > 1 Then
                          Begin
                            dec(i);
                            If ReadRegFromFile(OFile, i, Rg2) Then
                              Begin
                                Rg := Rg2;
                                Str(i, Stri);
                                Name := Rg.Name;
                              End;
                          End;
                      End;
                #80 :
                      Begin
                        inc(i);
                        If ReadRegFromFile(OFile, i, Rg2) Then
                          Begin
                            Rg := Rg2;
                            Str(i, Stri);
                            Name := Rg.Name;
                          End
                        Else dec(i);
                      End;
              End;
            End;
    End;
  Until Exit;

  SetColor(0);
  For j := 179 To 188 Do
    Line(260, j, 290+(20*8), j);
  StrWrite(260, 180, 15, 0, Num +' - ', False);
  StrWrite(290, 180, 15, 0, OLevel, False);
End;


Procedure TPlets.RunLevel;
Begin
  Level.Init(Snd, OFile, Reg);
  Level.Run;
  Level.Done;
End;

Procedure TPlets.Run;

Var 
  Key : Char;
  Sair: Boolean;

Begin
  Sair := False;
  Show;
  Repeat
    Key := Readkey;
    Case Key Of 
      #27 : Sair := True;
      #13 :
            Begin
              If (OFile <> '') Then
                Begin
                  ClearDevice;
                  RunLevel;
                  ClearDevice;
                  Show;
                End
              Else
                Begin
                  Message('You need choose a file');
                  Sound(1000);
                  Delay(100);
                  NoSound;
                  Key := ReadKey;
                  If Key = #00 Then
                    Begin
                      Key := ReadKey;
                      Key := #00;
                    End;
                  Message('Choose your option');
                End;
            End;
      #00 :
            Begin
              Key := ReadKey;
              If ((OFile = '') And (Key <> #60) And (Key <> #59)) Then
                Begin
                  Error('You need choose a file');
                  Message('Choose your option');
                End;
              Case Key Of 
                #59 : Help;
                #60 :
                      Begin
                        Message('Enter with your file name');
                        Edit(260, 150, 12, OFile);
                        Message('Choose your option');
                        If ReadRegFromFile(OFile, 1, Reg) Then
                          OLevel := Reg.Name
                        Else
                          Begin
                            Error('File not found');
                            Message('Choose your option');
                            OFile := '';
                          End;
                        Show;
                      End;
                #61 :
                      Begin
                        Message('Choose a level with arrows');
                        ReadLevel;
                        Message('Choose your option');
                      End;
              End;
            End;
    End;
    If Sair Then
      Begin
        Sound(1000);
        Delay(100);
        NoSound;
        Message('Are you sure you want to leave?');
        Key := ReadKey;
        Case Key Of 
          #00 : Key := ReadKey;
          #13 :
                Begin
                End;
          Else
            Begin
              Sair := False;
              Message('Choose your option');
            End;
        End;
      End;
  Until Sair;
End;

Procedure TPlets.Help;

Var 
  i  : Integer;
  Key: Char;
  Help1 : String;
  Help2 : String;

Begin
  Help1 := 'Developed by Saulo Popov Zambiasi';
  Help2 := 'e-mail : saulopz@gmail.com';

  Message('Press any key to return');
  SetColor(7);
  For i := 100 To 380 Do
    Line(152, i, 488, i);

  StrWrite(160, 120,  2, 7, 'Command : PLETS <filename.fse> ', False);
  StrWrite(160, 130, 15, 7, 'If you do not enter with file, the game', False);
  StrWrite(160, 140, 15, 7, 'assumes default file name "PLETS.FSE"', False);

  StrWrite(160, 160,  2, 7, 'ChupaPlets Commands:', False);
  StrWrite(160, 170, 15, 7, 'Arrows         - Move', False);
  StrWrite(160, 180, 15, 7, 'Shift + Arrows - Eat without move', False);
  StrWrite(160, 190, 15, 7, 'ESC            - Exit level', False);

  StrWrite(160, 210,  2, 7, 'Game objects:', False);
  StrWrite(160, 220, 15, 7, '- Chupa Plets', False);
  StrWrite(160, 230, 15, 7, '- Walls', False);
  StrWrite(160, 240, 15, 7, '- Plets', False);
  StrWrite(160, 250, 15, 7, '- Spheres', False);
  StrWrite(160, 260, 15, 7, '- Scissors', False);
  StrWrite(160, 270, 15, 7, '- Candy candy', False);
  StrWrite(160, 280, 15, 7, '- Exits', False);

  StrWrite(160, 300,  2, 7, 'Game goal:', False);
  StrWrite(160, 310, 15, 7, '- You need to eat all force candy and', False);
  StrWrite(160, 320, 15, 7, '  go to a level exit.', False);

  StrWrite(170, 350, 0, 7, Help1, True);
  StrWrite(200, 360, 0, 7, Help2, True);


  Key := ReadKey;
  If Key = #00 Then Key := Readkey;
  Show;
End;

Procedure TPlets.Show;

Var 
  i, j : Integer;

Begin
  SetColor(1);
  For i := 3 Downto 0 Do
    Rectangle(150-i, 50-i, 490+i, 400+i);
  SetColor(0);
  Rectangle(146, 46, 494, 404);
  Rectangle(151, 51, 489, 399);
  SetColor(7);
  For i := 52 To 398 Do
    Line(152, i, 488, i);

  StrWrite(200, 70, 14, 7, '< C H U P A - P L E T S >', False);
  StrWrite(205, 85, 14, 7, 'by Saulo Popov Zambiasi', False);

  StrWrite(180, 150, 9, 7, 'File....: ' , False);
  StrWrite(180, 180, 9, 7, 'Level...: ' , False);

  StrWrite(260, 150, 15, 0, OFile, False);
  StrWrite(260, 180, 15, 0, Num+' - ', False);
  StrWrite(290, 180, 15, 0, OLevel, False);

  StrWrite(200, 270, 0, 7, 'F1    - Help'         , True);
  StrWrite(200, 285, 0, 7, 'F2    - Open File'    , True);
  StrWrite(200, 300, 0, 7, 'F3    - Open Level'   , True);
  StrWrite(200, 315, 0, 7, 'ENTER - Play Level'   , True);
  StrWrite(200, 330, 0, 7, 'ESC   - Exit'         , True);

  Message('Choose your option');
End;

Procedure TPlets.Message(Msg : String);

Var 
  i : Integer;

Begin
  SetColor(4);
  For i := 389 To 399 Do
    Line(153, i, 488, i);
  StrWrite(153, 390, 14, 4, Msg, False);
End;

Procedure TPlets.Error(Msg : String);

Var 
  Key : Char;

Begin
  Message(Msg);
  Sound(1000);
  Delay(100);
  NoSound;
  Key := ReadKey;
  If Key = #00 Then
    Begin
      Key := ReadKey;
      Key := #00;
    End;
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
End;


Var 
  Pl : TPlets;

Begin
  Pl.Init;
  Pl.Run;
  Pl.Done;
End.
