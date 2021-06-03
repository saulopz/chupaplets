
Unit MainMenu;

Interface

Uses 
Levels;

Type 
   {*************** LEVEL COLLECTIONS **************}

  PNodo = ^Nodo;
  Nodo = Record
    Next : PNodo;
    FName: String;
    Item : Elems;
  End;
  PCollection = ^TCollection;
  TCollection = Object
    Private 
      Size   : Integer;
      First  : PNodo;
      Select : PNodo;
    Public 
      Constructor Init;
      Procedure   InsertItem(LevelName : String; ImputItem : Elems);
      Procedure   GetItem(Index          : Integer;
                          Var LevelName   : String;
                          Var OutPutItem : Elems);
      Function    GetSize : Integer;
      Destructor  Done;
      Virtual;
  End;

   {************** LEVEL OBJECTS ****************}

  PMainMenu = ^TMainMenu;
  TMainMenu = Object
    Private 
      NameFile : String;
      ListLevels: PCollection;
    Public 
      Constructor Init(FileName : String);
      Procedure   Run(FileName, LevelName : String; Elem : Elems);
      Procedure   ReadFile;
      Procedure   Compile;
      Destructor  Done;
  End;

Var 
  LineText : String[80];
  LevelText : Text;

Implementation

Procedure TMainMenu.ReadFile;

Var 
  Name : String;
  Item : Elems;
  i    : Integer;

Begin
  Assign(LevelText, nameFile);
   {$I-}
  Reset(LevelText);
   {$I+}
  If IOresult = 0 Then
    Begin
      While Not Eof(LevelText) Do
        Begin
          Readln(LevelText, LineText);
          {if first char is [, then is a name}
          If LineText[1] = '[' Then
            Begin
              Name := '';
              i    := 2;
              While ((i <= Length(LineText)) And (i <= 22)) Do
                Begin
                  If LineText[i] <> ']' Then
                    Name := Name+LineText[i]
                  Else i := 23
                End;
              Readln;
              For i := 1 To 20 Do
                Begin
                  Readln(LevelText, LineText);
                  Item[i] := Copy(LineText, 1, 30);
                End;
              ListLevels^.InsertItem(Name, Item);
            End;
        End;
      Close(LevelText);
    End;
End;

Procedure TMainMenu.Compile;

Var 
  Posiction : Integer;
  i         : Integer;

Begin
  Assign(LevelText, nameFile);
   {$I-}
  Reset(LevelText);
   {$I+}
  If IOresult = 0 Then
    Begin
      While Not Eof(LevelText) Do
        Begin
          Readln(LevelText, LineText);
          If LineText[1] = '[' Then
            Begin
            End;
        End;
      Close(LevelText);
    End;
End;

CONSTRUCTOR TMainMenu.Init(FileName : String);
Begin
  NameFile := FileName;
  New(ListLevels, Init);
  Compile;
  ReadFile;
End;

Procedure TMainMenu.Run(FileName, LevelName : String; Elem : Elems);
Begin
End;

DESTRUCTOR TMainMenu.Done;
Begin
  Dispose(ListLevels, Done);
End;


{******* TCOLLECTION IMPLEMENTATION **************}

CONSTRUCTOR TCollection.Init;
Begin
  First  := Nil;
  Select := Nil;
  Size   := 0;
End;

{***** INSERT AN ELEMENT ON THE LIST ***********}

Procedure TCollection.InsertItem(LevelName : String; ImputItem : Elems);

Var 
  Pont : PNodo;
  Prev : PNodo;
  Vazio: Boolean;

Begin
  Inc(Size);
  Vazio := True;
  Pont  := First;
  While Pont <> Nil Do
    Begin
      Prev := Pont;
      Pont := Pont^.Next;
      Vazio := False;
    End;
  New(Pont);
  Pont^.FName := LevelName;
  Pont^.Item := ImputItem;
  Pont^.Next := Nil;
  If Not Vazio Then
    Prev^.Next := Pont
  Else
    Begin
      First := Pont;
      Select := First;
    End;
End;

Procedure TCollection.GetItem(Index         : Integer;
                              Var LevelName   : String;
                              Var OutPutItem : Elems);

Var 
  Pont : PNodo;
  N    : String;
  Elem : Elems;
  i    : Integer;

Begin
  N   := '';
  Pont := First;
  i   := 1;
  While (i <= Index) And (Pont <> Nil) Do
    Begin
      If i = Index Then
        Begin
          N    := Pont^.FName;
          Elem := Pont^.Item;
        End;
      Pont := Pont^.Next;
      Inc(i);
    End;
  LevelName  := N;
  OutPutItem := Elem;
End;

Function   TCollection.GetSize;
Begin
  GetSize := Size;
End;

DESTRUCTOR TCollection.Done;

Var 
  Pont : PNodo;

Begin
  While First <> Nil Do
    Begin
      Pont := First;
      First := First^.Next;
      Dispose(Pont);
    End;
End;

End.

End.
