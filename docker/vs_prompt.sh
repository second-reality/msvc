#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" >&2
    exit 1
}

arch=x64

vs_path="C:/vs"

#cl.exe
export WINEPATH="$vs_path/vc/tools/msvc/14.33.31629/bin/Hostx64/$arch;${WINEPATH:-}"
#rc.exe
export WINEPATH="$vs_path/kits/10/bin/10.0.19041.0/$arch;${WINEPATH:-}"
# LIBCMT.lib
export LIB="$vs_path/vc/tools/msvc/14.33.31629/lib/$arch/;${LIB:-}"
# kernel32.lib
export LIB="$vs_path/kits/10/lib/10.0.19041.0/um/$arch/;${LIB:-}"
# libucrt.lib
export LIB="$vs_path/kits/10/lib/10.0.19041.0/ucrt/$arch/;${LIB:-}"
#stdio.h
export INCLUDE="$vs_path/kits/10/include/10.0.19041.0/ucrt/;${INCLUDE:-}"
#vsruntime.h
export INCLUDE="$vs_path/vc/tools/msvc/14.33.31629/include/;${INCLUDE:-}"

export LIBPATH="$LIB"
export EXTERNAL_INCLUDE="$INCLUDE"

"$@"
