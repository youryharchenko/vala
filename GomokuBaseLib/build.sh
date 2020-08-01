#!/bin/bash

uncrustify --no-backup -c uncrustify.cfg -l vala -f src/Game.vala -o src/Game.vala
uncrustify --no-backup -c uncrustify.cfg -l vala -f src/Step.vala -o src/Step.vala

ninja -C builddir/

cp builddir/gomokubaselib-1.0.vapi $HOME/.vala/vapi/
cp builddir/GomokuBaseLib-1.0.gir $HOME/.vala/vapi/
cp builddir/libgomokubaselib-1.0.so $HOME/.vala/lib/
cp builddir/gomokubaselib-1.0.h $HOME/.vala/inc/


