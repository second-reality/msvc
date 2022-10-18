#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" >&2
    exit 1
}

[ $# -gt 1 ] || die "usage: arch <command> (arch can be 'x64' or 'arm64')"

arch=$1;shift

#we can't use vcvarsall.bat for 2 reasons:
# - some part is not understood by wine cmd command
# - it uses registry to detect where windows sdk is installed
#   since no installation is done, this is missing

# The goal is to set env var, so cl.exe can find what it needs
# EXTERNAL_INCLUDE, INCLUDE, LIB, LIBPATH (for link.exe)

VC_VER=14.33.31629
SDK_VER=10.0.19041.0

VS_ROOT_DIR="vs"
VS_LINUX_PREFIX=/opt/wine/drive_c/$VS_ROOT_DIR
VS_WINDOWS_PREFIX="C:/$VS_ROOT_DIR"

prepend()
{
    local env_var=$1; shift
    local file_to_find=$1; shift
    local path=$1; shift

    [ -f "$VS_LINUX_PREFIX/$path/$file_to_find" ] || die "can't find $file_to_find in $path"
    # example: export WINEPATH=C:/vs/path/to/bin;$WINEPATH"
    export $env_var="$VS_WINDOWS_PREFIX/$path;${!env_var:-}"
}

prepend WINEPATH    cl.exe          vc/tools/msvc/${VC_VER}/bin/Hostx64/$arch
# always use x64 binaries
prepend WINEPATH    rc.exe          kits/10/bin/${SDK_VER}/x64
prepend LIB         LIBCMT.lib      vc/tools/msvc/${VC_VER}/lib/$arch
prepend LIB         kernel32.lib    kits/10/lib/${SDK_VER}/um/$arch
prepend LIB         libucrt.lib     kits/10/lib/${SDK_VER}/ucrt/$arch
prepend INCLUDE     stdio.h         kits/10/include/${SDK_VER}/ucrt
prepend INCLUDE     winerror.h      kits/10/include/${SDK_VER}/shared
prepend INCLUDE     limits.h        vc/tools/msvc/${VC_VER}/include
prepend INCLUDE     windows.h       kits/10/include/${SDK_VER}/um

# used by link.exe to detect lib, when LIB is used by cl.exe
export LIBPATH="$LIB"
# can be used to identify "system" headers (warnings, ...)
export EXTERNAL_INCLUDE="$INCLUDE"

"$@"
