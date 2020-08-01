#!/bin/bash
rm -rf Mercury/*

mmc --make libmercuryprobelib \
    --very-verbose

mmc  --ml mercuryprobelib \
	--generate-standalone-interface mercuryprobelib_int \
    --very-verbose

# mmc --make libmercuryprobelib \
#     --very-verbose \
#     --generate-standalone-interface mercuryprobelib_int \
#     --mercury-linkage shared \
#     --mercury-linkage static \
#     --no-make-short-interface
    
