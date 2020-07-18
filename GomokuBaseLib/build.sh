#!/bin/bash

uncrustify --no-backup -c uncrustify.cfg -l vala -f src/Game.vala -o src/Game.vala
uncrustify --no-backup -c uncrustify.cfg -l vala -f src/Step.vala -o src/Step.vala

ninja -C builddir/
