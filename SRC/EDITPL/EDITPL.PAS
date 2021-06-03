
Program EditPl;

Uses 
Crt, Spaces, Files, Graph, ODraws;

Type 
  TEdition = Object
    Private 
      Space : PSpace;
      Reg   : RegPlets;
      RegNum: String;
      OFile : String;
      OLevel : String;
      Procedure Show;
    Public 
      Constructor Init;
      Procedure   EditLevel;
      Procedure   Help;
      Procedure   Run;
      Function    ReadLevel : String;
      Procedure   Message(Msg : String);
      Destructor  Done;
  End;

  CONSTRUCTOR TEdition.Init;

Var 
  d, m : Integer;

Begin
  d := Detect;
  InitGraph(d, m, '');
  ClearReg(Reg);

  If ParamStr(1) <> '' Then
    OFile := ParamStr(1)
  Else
    OFile := 'PLETS.FSE';
  If ReadRegFromFile(OFile, 1, Reg) Then
    Begin
      RegNum := '1';
      OLevel := Reg.Name;
    End
  Else
    Begin
      OFile := '';
      OLevel := '';
      RegNum := '0';
    End;
End;

Procedure TEdition.Help;

Var 
  i  : Integer;
  Key: Char;
  Help1 : String;
  Help2 : String;


Begin
  Help1 := 'Developed by Saulo Popov Zambiasi';
  Help2 := 'e-mail: saulopz@gmail.com';

  Message('Press any key to return');
  SetColor(7);
  For i := 100 To 380 Do
    Line(152, i, 488, i);

  StrWrite(160, 120,  2, 7, 'Command : EDITPL <filename> ', False);
  StrWrite(160, 130, 15, 7, 'If you do not enter with filename, it', False);
  StrWrite(160, 140, 15, 7, 'assumes default file "PLETS.FSE"', False);

  StrWrite(160, 160,  2, 7, 'Level Editor:', False);
  StrWrite(160, 170, 15, 7, 'Uses mouse para navigate over a level.', False);
  StrWrite(160, 180, 15, 7, 'Click over a object to select and put', False)
  ;
  StrWrite(160, 190, 15, 7, 'in a position in the game.', False);

  StrWrite(160, 210,  2, 7, 'Objects:', False);
  StrWrite(160, 220, 15, 7, '- Chupa Plets', False);
  StrWrite(160, 230, 15, 7, '- Walls', False);
  StrWrite(160, 240, 15, 7, '- Plets', False);
  StrWrite(160, 250, 15, 7, '- Spheres', False);
  StrWrite(160, 260, 15, 7, '- Scissors', False);
  StrWrite(160, 270, 15, 7, '- Candy candy', False);
  StrWrite(160, 280, 15, 7, '- Exits', False);

  StrWrite(160, 300,  2, 7, 'Attention:', False);
  StrWrite(160, 310, 15, 7, '- Create only one ChupaPlets.', False);
  StrWrite(160, 320, 15, 7, '- More animated objects, more', False);
  StrWrite(160, 330, 15, 7, '  heavy is the level.', False);

  StrWrite(170, 350, 0, 7, Help1, True);
  StrWrite(200, 360, 0, 7, Help2, True);

  Key := ReadKey;
  If Key = #00 Then Key := Readkey;
  Show;
End;

Procedure TEdition.EditLevel;
Begin
  ClearDevice;
  New(Space, Init(Reg));
  Space^.Run;
  Dispose(Space, Done(Reg));
  ClearDevice;
End;

Function  TEdition.ReadLevel : String;

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
  Stri := RegNum;
  Val(Stri, i, Code);
  Rg := Reg;
  Rg2 := Rg;
  Name := OLevel;
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
              Exit := True;
              Reg  := Rg;
              Str(i, RegNum);
              OLevel := Name;
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
  StrWrite(260, 180, 15, 0, RegNum+' - ', False);
  StrWrite(290, 180, 15, 0, OLevel, False);
End;

Procedure  TEdition.Run;

Var 
  Key : Char;
  Exit: Boolean;
  i   : Integer;
  Code: Integer;

Begin
  Exit := False;
  Show;
  Repeat
    Key := Readkey;
    Case Key Of 
      #27 : Exit := True;
      #00 :
            Begin
              Key := Readkey;
              If ((OFile = '') And (Key <> #60) And (Key <> #59)) Then
                Begin
                  Message('Enter with file name.');
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
              Case Key Of 
                #59 : Help;
                #60 :
                      Begin
                        Message('Enter with file name');
                        Edit(260, 150, 12, OFile);
                        Message('Choose your option');
                        RegNum := '1';
                        ReadRegFromFile(OFile, 1, Reg);
                        OLevel := Reg.Name;
                        Show;
                      End;
                #61 :
                      Begin
                        Message('Choose the level');
                        ReadLevel;
                        Message('Choose your option');
                      End;
                #62 :
                      Begin
                        i := QtdLevels(OFile)+1;
                        Str(i, RegNum);
                        StrWrite(260, 180, 15, 0, RegNum+' - ', False);
                        Message('Enter with level name');
                        OLevel := '';
                        Edit(290, 180, 20, OLevel);
                        Message('Choose your option');
                        ClearReg(Reg);
                        Reg.Name := OLevel;
                      End;
                #63 :
                      Begin
                        EditLevel;
                        OLevel := Reg.Name;
                        Val(RegNum, i, Code);
                        InsertRegToFile(OFile, i, Reg);
                        Show;
                      End;
                #64 :
                      Begin
                        Sound(1000);
                        Delay(100);
                        NoSound;
                        Message('Are you sure you want to delete?');
                        Key := ReadKey;
                        Case Key Of 
                          #00 : Key := ReadKey;
                          #13 :
                                Begin
                                  Val(RegNum, i, Code);
                                  DeleteRegFromFile(OFile, i);
                                  RegNum := '1';
                                  ReadRegFromFile(OFile, 1, Reg);
                                  OLevel := Reg.Name;
                                  Show;
                                End;
                        End;
                        Message('Choose your option');
                      End;
              End;
            End;
    End;
    If Exit Then
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
              Exit := False;
              Message('Choose your option');
            End;
        End;
      End;
  Until Exit;

  ClearDevice;
End;

Procedure TEdition.Message(Msg : String);

Var 
  i : Integer;

Begin
  SetColor(4);
  For i := 389 To 399 Do
    Line(153, i, 488, i);
  StrWrite(153, 390, 14, 4, Msg, False);
End;

DESTRUCTOR TEdition.Done;
Begin
  CloseGraph;
End;

Procedure TEdition.Show;

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

  StrWrite(200, 70, 14, 7, 'Level Editor <CHUPA-PLETS>', False);
  StrWrite(220, 85, 14, 7, 'By Saulo Popov Zambiasi', False);

  StrWrite(180, 150, 9, 7, 'File....: ' , False);
  StrWrite(180, 180, 9, 7, 'Level...: ' , False);

  StrWrite(260, 150, 15, 0, OFile, False);
  StrWrite(260, 180, 15, 0, RegNum+' - ', False);
  StrWrite(290, 180, 15, 0, OLevel, False);

  StrWrite(200, 270, 0, 7, 'F1  - Help'         , True);
  StrWrite(200, 285, 0, 7, 'F2  - Open File'    , True);
  StrWrite(200, 300, 0, 7, 'F3  - Open Level'   , True);
  StrWrite(200, 315, 0, 7, 'F4  - New Level'    , True);
  StrWrite(200, 330, 0, 7, 'F5  - Edit Level'   , True);
  StrWrite(200, 345, 0, 7, 'F6  - Delete Level' , True);
  StrWrite(200, 360, 0, 7, 'ESC - Exit'         , True);

  Message('Choose your option');
End;

Var 
  Edition : TEdition;

Begin
  Edition.Init;
  Edition.Run;
  Edition.Done;
End.
