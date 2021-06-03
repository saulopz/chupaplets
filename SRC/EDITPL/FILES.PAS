
Unit Files;

Interface

Uses 
ODraws;

Type 
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
Procedure InsertRegToFile(FileName : String;
                          Index    : Integer;
                          RegIn    : RegPlets);
Procedure DeleteRegFromFile(FileName : String;
                            Index    : Integer);
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

Procedure DeleteRegFromFile(FileName : String;
                            Index    : Integer);

Var 
  Arq2 : FilePlets;
  Reg2 : RegPlets;
  i    : Integer;

Begin
  i := 1;
  Assign(Arq, FileName);
   {$I-}
  Reset(Arq);
   {$I+}
  If IOresult = 0 Then
    Begin
      Assign(Arq2, 'Reserva.___');
      ReWrite(Arq2);
      While Not eof(Arq) Do
        Begin
          Read(Arq, Reg);
          If i <> Index Then
            Write(Arq2, Reg);
          inc(i);
        End;
      Close(Arq2);
      Close(Arq);
      Erase(Arq);
      ReName(Arq2, FileName);
    End;
End;

Procedure InsertRegToFile(FileName : String;
                          Index    : Integer;
                          RegIn    : RegPlets);
Begin
  Assign(Arq, FileName);
   {$I-}
  Reset(Arq);
   {$I+}
  If IOresult <> 0 Then Rewrite(Arq)
  Else
    Seek(Arq, Index-1);
  Write(Arq, RegIn);
  Close(Arq);
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
