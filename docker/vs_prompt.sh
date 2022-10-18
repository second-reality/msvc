#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" >&2
    exit 1
}

arch=arm64

#we can't use vcvarsall.bat for 2 reasons:
# - some part is not understood by wine cmd command
# - it uses registry to detect where windows sdk is installed
#   since no installation is done, this is missing

# The goal is to set env var, so cl.exe can find what it needs
# EXTERNAL_INCLUDE, INCLUDE, LIB, LIBPATH (for link.exe)

vs_path="C:/vs"

#cl.exe
export WINEPATH="$vs_path/vc/tools/msvc/14.33.31629/bin/Hostx64/$arch;${WINEPATH:-}"
#rc.exe 
# always use x64 binaries
export WINEPATH="$vs_path/kits/10/bin/10.0.19041.0/x64;${WINEPATH:-}"
# LIBCMT.lib
export LIB="$vs_path/vc/tools/msvc/14.33.31629/lib/$arch/;${LIB:-}"
# kernel32.lib
export LIB="$vs_path/kits/10/lib/10.0.19041.0/um/$arch/;${LIB:-}"
# libucrt.lib
export LIB="$vs_path/kits/10/lib/10.0.19041.0/ucrt/$arch/;${LIB:-}"
#stdio.h
export INCLUDE="$vs_path/kits/10/include/10.0.19041.0/ucrt/;${INCLUDE:-}"
# winerror.h
export INCLUDE="$vs_path/kits/10/include/10.0.19041.0/shared/;${INCLUDE:-}"
#vsruntime.h
export INCLUDE="$vs_path/vc/tools/msvc/14.33.31629/include/;${INCLUDE:-}"
# windows.h
export INCLUDE="$vs_path/kits/10/include/10.0.19041.0/um/;${INCLUDE:-}"

export LIBPATH="$LIB"
export EXTERNAL_INCLUDE="$INCLUDE"

"$@"
