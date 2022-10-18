#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" >&2
    exit 1
}

arch=x64

vs_path="C:/vs"
exe_cl_path="$vs_path/vc/tools/msvc/14.33.31629/bin/Hostx64/$arch"
exe_rc_path="$vs_path/kits/10/bin/10.0.19041.0/$arch"
libcmt_path="$vs_path/vc/tools/msvc/14.33.31629/lib/$arch/"

WINEPATH="$exe_cl_path;${WINEPATH:-}"
WINEPATH="$exe_rc_path;${WINEPATH:-}"
LIB="$libcmt_path;${LIB:-}"
LIBPATH="$LIB"

"$@"
