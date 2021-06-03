{       SMIX is Copyright 1995 by Ethan Brodsky.  All rights reserved.       }
UNIT SndPlets;

INTERFACE

USES
    CRT,
    Detects,
    SMix;

Const
   FORCESND  = 0;
   WAYSND    = 1;
   GODOWNSND = 2;
   EXITSND   = 3;
   PUSHSND   = 4;
   EXPLOITSND= 5;
   DOORSND   = 6;

    XMSRequired   = 190;    {XMS memory required to load the sounds (KBytes) }
    SharedEMB     = true;
      {TRUE:   All sounds will be stored in a shared EMB}
      {FALSE:  Each sound will be stored in a separate EMB}
    NumSounds = 7;
  var
    BaseIO: word; IRQ, DMA, DMA16: byte;
    Sound: array[0..NumSounds-1] of PSound;
    i: byte;
    Counter: LongInt;
    InKey: char;
    Stopsound: boolean;
    Num: byte;
    Temp: integer;
    OldExitProc: pointer;

Function  Init : Boolean;
procedure Shutdown;
Procedure Snd(Num : Integer);

IMPLEMENTATION

Procedure Snd(Num : Integer);
Begin
   StartSound(Sound[Num], Num, false);
End;

  function HexW(W: word): string; {Word}
    const
      HexChars: array [0..$F] of Char = '0123456789ABCDEF';
    begin
      HexW :=
        HexChars[(W and $F000) shr 12] +
        HexChars[(W and $0F00) shr 8]  +
        HexChars[(W and $00F0) shr 4]  +
        HexChars[(W and $000F)];
    end;

  procedure OurExitProc; far;
   {If the program terminates with a runtime error before the extended memory}
   {is deallocated, then the memory will still be allocated, and will be lost}
   {until the next reboot.  This exit procedure is ALWAYS called upon program}
   {termination and will deallocate extended memory if necessary.            }
    var
      i: byte;
    begin
      for i := 0 to NumSounds-1 do
        if Sound[i] <> nil then FreeSound(Sound[i]);
      if SharedEMB then ShutdownSharing;
      ExitProc := OldExitProc; {Chain to next exit procedure}
    end;

  FUNCTION Init : Boolean;

  Label Sair;
  Var Ok : Boolean;

    begin
      Ok := True;
      Randomize;
      writeln;
      writeln('-------------------------------------------');
      writeln('Sound Mixing Library v1.25 by Ethan Brodsky');
      if not(GetSettings(BaseIO, IRQ, DMA, DMA16))
        then
          begin
            writeln('Error initializing:  Invalid or non-existant BLASTER environment variable');
            {Halt(1);} {BLASTER environment variable invalid or non-existant}
            Ok := False;
            Goto Sair;
          end
        else
          begin
            if not(InitSB(BaseIO, IRQ, DMA, DMA16))
              then
                begin
                  writeln('Error initializing sound card');
                  writeln('Incorrect base IO address, sound card not installed, or broken');
                  Halt(2); {Sound card could not be initialized}
                end;
            if SixteenBit
              then writeln('BaseIO=', HexW(BaseIO), 'h    IRQ', IRQ, '    DMA8=', DMA, '    DMA16=', DMA16)
              else writeln('BaseIO=', HexW(BaseIO), 'h        IRQ', IRQ, '        DMA8=', DMA);
          end;
      write('DSP version ', DSPVersion:0:2, ':  ');
      if SixteenBit
        then write('16-bit, ')
        else write('8-bit, ');
      if AutoInit
        then writeln('Auto-initialized')
        else writeln('Single-cycle');
      if not(InitXMS)
        then
          begin
            writeln('Error initializing extended memory');
            writeln('HIMEM.SYS must be installed');
            Halt(3); {XMS driver not installed}
          end
        else
          begin
            writeln('Extended memory succesfully initialized');
            write('Free XMS memory:  ', GetFreeXMS, 'k  ');
            if GetFreeXMS < XMSRequired
              then
                begin
                  writeln('Insufficient free XMS');
                  writeln('You are probably running MIXTEST from the protected mode IDE');
                  writeln('Run it from the command line or read the documentation');
                  Halt(4); {Insufficient XMS memory}
                end
              else
                begin
                  writeln('Loading sounds');
                  if SharedEMB then InitSharing;

                  OpenSoundResourceFile('PLETS.SND');
                  LoadSound(Sound[0], 'FORCE');
                  LoadSound(Sound[1], 'WAY');
                  LoadSound(Sound[2], 'GODOWN');
                  LoadSound(Sound[3], 'EXIT');
                  LoadSound(Sound[4], 'PUSH');
                  LoadSound(Sound[5], 'EXPLOIT');
                  LoadSound(Sound[6], 'DOOR');
                  CloseSoundResourceFile;

                  OldExitProc := ExitProc;
                  ExitProc := @OurExitProc;
                end
          end;
      InitMixing;
      writeln;
    Sair:
      Init := Ok;
    end;

  procedure Shutdown;
    begin
      ShutdownMixing;
      ShutdownSB;

      for i := 0 to NumSounds-1 do
        FreeSound(Sound[i]);
      if SharedEMB then ShutdownSharing;
      writeln;
    end;

  begin
  end.
