#!/bin/bash

uncrustify --no-backup -c uncrustify.cfg -l vala -f src/main.vala -o src/main.vala
valac -o build/probe src/main.vala