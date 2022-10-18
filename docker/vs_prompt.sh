#!/usr/bin/env bash

set -euo pipefail

die()
{
    echo "$@" >&2
    exit 1
}

vs="C:/vs"

arch=x64

WINEPATH="$vs/vc/tools/msvc/14.33.31629/bin/Hostx64/$arch/;${WINEPATH}"

"$@"
