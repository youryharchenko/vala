#!/bin/bash

#uncrustify --no-backup -c uncrustify.cfg -l vala -f src/main.vala -o src/main.vala

# valac -g --pkg sdl --pkg sdl-gfx -X -lSDL_gfx -X -I/usr/include/SDL -X -lm \
#     src/World.vala \
#     src/Window.vala \
#     src/Ball.vala \
#     src/main.vala \
#     -o builddir/BouncingBall

mkdir -p builddir/GomokuBase@exe/src
cp ../GomokuBaseLib/builddir/gomokubaselib-1.0.h builddir/GomokuBase@exe/src/gomokubaselib-1.0.h

ninja -C builddir/