
Unit Files;

Interface

Type 
  ObjectType = (VOID, SPHERE, PLETS, CUTTER,
                WALL, CANDY, EXITDOR, WAY);

  SpaceMap = Array[1..30, 1..20] Of ObjectType;

  RegPlets  = Record
    Name  : String[20];
    Space : SpaceMap;
  End;
  FilePlets = File Of RegPlets;

Var 
  Arq : FilePlets;
  Reg : RegPlets;

Procedure ClearReg(Var RegOut : RegPlets);
Function  QtdLevels(FileName : String) : Integer;
Function  ReadRegFromFile(FileName   : String;
                          Index      : Integer;
                          Var RegOut : RegPlets) : Boolean;

Implementation

Procedure ClearReg(Var RegOut : RegPlets);

Var 
  i, j : Integer;

Begin
  RegOut.Name := '';
  For i := 1 To 30 Do
    For j := 1 To 20 Do
      RegOut.Space[i,j] := VOID;
End;

Function QtdLevels(FileName : String) : Integer;
Begin
  Assign(Arq, FileName);
   {$I-}
  Reset(Arq);
   {$I+}
  If IOresult = 0 Then
    Begin
      QtdLevels := FileSize(Arq);
      Close(Arq);
    End
  Else QtdLevels := 0;
End;

Function ReadRegFromFile(FileName   : String;
                         Index      : Integer;
                         Var RegOut : RegPlets) : Boolean;

Var 
  Return : Boolean;

Begin
  Return := True;
  ClearReg(RegOut);
  Assign(Arq, FileName);
   {$I-}
  Reset(Arq);
   {$I+}
  If IOresult = 0 Then
    Begin
      If FileSize(Arq) >= Index Then
        Begin
          Seek(Arq, Index-1);
          Read(Arq, RegOut);
        End
      Else
        Return := False;
      Close(Arq);
    End
  Else
    Return := False;
  ReadRegFromFile := Return;
End;
End.
