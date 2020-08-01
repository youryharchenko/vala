#!/bin/bash

#uncrustify --no-backup -c uncrustify.cfg -l vala -f src/main.vala -o src/main.vala

# valac -g --pkg sdl --pkg sdl-gfx -X -lSDL_gfx -X -I/usr/include/SDL -X -lm \
#     src/World.vala \
#     src/Window.vala \
#     src/Ball.vala \
#     src/main.vala \
#     -o builddir/BouncingBall

mkdir -p builddir/GtkProbe@exe/src
cp ../MercuryProbeLib/mercuryprobelib_int.h builddir/GtkProbe@exe/src/mercuryprobelib_int.h
cp ../MercuryProbeLib/mercuryprobelib_int.c src/mercuryprobelib_int.c

ninja -C builddir/