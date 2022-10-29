# tresses
Synth library inspired by Mutable Instruments Braids

Braids is a macro oscillator, it combines basic synthesis elements in
different ways to produce a wide variety of sounds.

This project aims at providing the same features as Braids in an Ada audio
synthesis library. Most of the code you will find here is a translation from
the C++ code of Braids.

## Give it a try:
Using [Alire](https://alire.ada.dev) on Linux:
```
$ git clone https://github.com/wee-noise-maker/tresses.git
$ cd tresses/tests
$ alr build
$ ./bin/tests | aplay -f S16_LE -c1 -r44100
```
