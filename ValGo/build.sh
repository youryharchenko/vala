#!/bin/bash

#uncrustify --no-backup -c uncrustify.cfg -l vala -f src/main.vala -o src/main.vala

# valac -g --pkg sdl --pkg sdl-gfx -X -lSDL_gfx -X -I/usr/include/SDL -X -lm \
#     src/World.vala \
#     src/Window.vala \
#     src/Ball.vala \
#     src/main.vala \
#     -o builddir/BouncingBall

go build -o builddir/service go/cmd/main.go

ninja -C builddir/