# CHUPA PLETS

Author: Saulo Popov Zambiasi

E-mail: saulopz@gmail.com

## About

This was the first computer game I developed. At the time, the first half of 1997, I wanted to learn how to create digital games, but I didn't have much access to information about it. So, I took as base a game of the time, called SUPA PLEX, and I created a clone in the Pascal Object programming language. I used the Borland Pascal 7 IDE to program and compile.

The goal of getting inspired by a ready-made game was to understand the mechanics and try to replicate them. The code isn't the best and have so many problems, but it's what I was able to do at the time without much knowledge and with very little access to documents about digital game development. Images are hardcoded in source code and manually painted pixel by pixel on the screen.

I also used some third-party code and included it here.

I'm providing the source code and executables. I managed to compile and run smoothly using the DOSBox program. I've tested it on Linux, but I believe you'll have no problem doing the same on Windows or MacOS.

I'd like to fix the code to make it compatible with Free Pascal so I can generate native executable code for Windows, MacOS and Linux, but I've been running out of time for that. Also, I think it would be a lot less work to recreate the game with more up-to-date features, maybe C++ with SFML or Kotlin with LibGDX or some game engine like the Godot Engine.

Well, feel free if you want to contribute and fix my code for Free Pascal. I will be happy to post your contribution here.

## Folders and Files

* BIN: binary files.
  * EDITPL.EXE: level editor executable.
  * EGAVGA.BGI: graphic driver.
  * PLETS.EXE: game executable.
  * PLETS.FSE: default level file.
  * PLETS.SND: sound resources (I really can't remember how I create this file).
* SRC: source codes
  * EDITPL: source code of level editor.
  * PLETS: source code of game.
