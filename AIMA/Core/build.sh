#!/bin/bash

#uncrustify --no-backup -c uncrustify.cfg -l vala -f src/Environment.vala -o src/Environment.vala
#uncrustify --no-backup -c uncrustify.cfg -l vala -f src/Agent.vala -o src/Agent.vala

ninja -C builddir/

cp builddir/aimacore-1.0.vapi $HOME/.vala/vapi/
cp builddir/AimaCore-1.0.gir $HOME/.vala/vapi/
cp builddir/libaimacore-1.0.so $HOME/.vala/lib/
cp builddir/aimacore-1.0.h $HOME/.vala/inc/