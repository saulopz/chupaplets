UNIT SndObj;

INTERFACE

Uses
   SndPlets, Crt;

Const
   FORCESND  = 0;
   WAYSND    = 1;
   GODOWNSND = 2;
   EXITSND   = 3;
   PUSHSND   = 4;
   EXPLOITSND= 5;
   DOORSND   = 6;

TYPE
   PSndObj = ^TSndObj;
   TSndObj = Object
   Private
      SoundOk: Boolean;
      SSound : Boolean;
   Public
      Constructor Init;
      Procedure   Snd(Num : Integer);
      Procedure   NoSound;
      Procedure   PlaySound;
      Destructor  Done;
   End;

IMPLEMENTATION

{********* Sons do PCSpeaker**************}

Var
   A, D : Integer;

PROCEDURE PCSForce;
Begin
   D:=1;
   While D<1900 do
      Begin
         Sound(3000-D);
         Delay(10);
         NoSound;
         D:=D+600;
      End;
   End;

PROCEDURE PCSWay;
Begin
   D:=45;
   While D<900 do
      Begin
         Sound(99+D);
         Delay(20);
         NoSound;
         D:=D+300
      End;
End;

PROCEDURE PCSGoDown;
Begin
   A:=1;
   For A:=1 To 2 Do
      Begin
         D:=1;
         While D<200 do
            Begin
               Sound(800+d);
               Delay(10);
               NoSound;
               D:=d+80;
            End;
      End;
End;


PROCEDURE PCSExploit;
Begin
   Sound(19); Delay (50); Sound(2000); Delay(20);
   Sound(29); Delay (40); Sound(1800); Delay(20);
   Sound(39); Delay (30); Sound(1600); Delay(20);
   Sound(49); Delay (20); Sound(1400); Delay(20);
   Sound(59); Delay (10); Sound(1200); Delay(10);
   Sound(69); Delay (20); Sound(1000); Delay(20);
   NoSound;
End;

PROCEDURE PCSExit;
Begin
   D:=20000;
   While D>19 Do
      Begin
         Sound(d); Delay(1); NoSound;
         D:=D-100;
      End;
End;

PROCEDURE PCSPush;
Begin
   D:=20000;
   While D>19 do
      Begin
         Sound(D); Delay(1); NoSound;
         D:=D-200;
      End;
End;

PROCEDURE PCSDoor;
Begin
   D:=9;
   While D<1000 do
      Begin
         Sound(D); Delay(10); NoSound;
         D:=D+100;
      End;
   D:=1000;
   While D>1 Do
      Begin
         Sound(D); Delay(10); NoSound;
         D:=D-100;
      End;
End;

{************ Objeto ************8}

CONSTRUCTOR TSndObj.Init;
Begin
   SoundOk := SndPlets.Init;
   SSound  := True;
End;

PROCEDURE TSndObj.NoSound;
Begin
   SSound := False;
End;

PROCEDURE TSndObj.PlaySound;
Begin
   SSound := True;
End;

PROCEDURE TSndObj.Snd(Num : Integer);
Begin
   If SSound Then
      If SoundOk Then
         SndPlets.Snd(Num)
      Else
         Case Num of
            FORCESND  : PCSForce;
            WAYSND    : PCSWay;
            GODOWNSND : PCSGoDown;
            EXITSND   : PCSExit;
            PUSHSND   : PCSPush;
            EXPLOITSND: PCSExploit;
            DOORSND   : PCSDoor;
         End;

End;

DESTRUCTOR TSndObj.Done;
Begin
   If SoundOk Then
      SndPlets.ShutDown;
End;

End.