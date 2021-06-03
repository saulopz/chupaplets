
Unit Objects;

Interface

Uses 
ODraws, Graph, Dos;

Const 
  SIZE = 20;

Type 
  PObject = ^TObject;
  TObject = Object
    Name : ObjectType;
    Map  : Draws;
    PosX : Integer;
    PosY : Integer;
    Constructor Init(NameObject : ObjectType; x, y : Integer);
    Procedure   Show;
    Function    AsColor(Color : Char) : Integer;
    Function    InRange : Boolean;
    Destructor  Done;
    Virtual;
  End;

Function  MousePressed : Boolean;
Procedure MouseCursor(on:boolean);
Procedure MouseStatus(Var But : Integer;
                      Var x, y: Integer);


Implementation

CONSTRUCTOR TObject.Init(NameObject : ObjectType; x, y : Integer);
Begin
  Name := NameObject;
  Case NameObject Of 
    SPHERE : Map := SphereDRAW;
    PLETS  : Map := PletsDRAW;
    CUTTER : Map := CutterDRAW;
    WALL   : Map := WallDRAW;
    CANDY  : Map := CandyDRAW;
    WAY    : Map := WayDRAW;
    EXITDOR: Map := ExitDRAW;
    VOID   : Map := VoidDRAW;
  End;
  PosX := X*SIZE;
  PosY := Y*SIZE;
  Show;
End;

Function TObject.AsColor(Color : Char) : Integer;
Begin
  Case Color Of 
    '0' : AsColor := 0;
    '1' : AsColor := 1;
    '2' : AsColor := 2;
    '3' : AsColor := 3;
    '4' : AsColor := 4;
    '5' : AsColor := 5;
    '6' : AsColor := 6;
    '7' : AsColor := 7;
    '8' : AsColor := 8;
    '9' : AsColor := 9;
    'A', 'a' : AsColor := 10;
    'B', 'b' : AsColor := 11;
    'C', 'c' : AsColor := 12;
    'D', 'd' : AsColor := 13;
    'E', 'e' : AsColor := 14;
    'F', 'f' : AsColor := 15;
    Else AsColor := 0;
  End;
End;

Function  TObject.InRange : Boolean;

Var 
  b, x, y : Integer;

Begin
  MouseStatus(b, x, y);
  InRange := ((x > PosX) And (x < (PosX)+20) And
             (y > PosY) And (y < (PosY)+20));
End;

Procedure TObject.Show;

Var 
  i, j : Integer;

Begin
  For i := 1 To SIZE Do
    For j := 1 To SIZE Do
      PutPixel(j+PosX, i+PosY, AsColor(Map[i][j]));
End;

DESTRUCTOR TObject.Done;
Begin
End;

{***************************************************************************}

Var 
  r : Registers;

Function MousePressed : Boolean;

Var 
  b    : Integer;
  x, y : Integer;

Begin
  MouseStatus(b, x, y);
  MousePressed := b <> 0;
End;

Procedure CallMouse(MouseFunction : integer);

Begin
  r.AX := MouseFunction;
  intr ($33, r);
End;

Procedure MouseStatus(Var But : Integer;
                      Var x, y: Integer);

Begin
  CallMouse ($03);
  x   := (r.CX) + 1;
  y   := (r.DX) + 1;
  But := r.BX;
End;

Procedure MouseCursor(on:boolean);
Begin
  If (on) Then
    CallMouse($01)
  Else
    CallMouse($02);
End;


End.
