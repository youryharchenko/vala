#!/bin/bash

uncrustify --no-backup -c uncrustify.cfg -l vala -f src/main.vala -o src/main.vala
valac --pkg gtk+-3.0 --pkg webkit2gtk-4.0 -o build/settlers src/main.vala