#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname $(readlink -f $0))
# TODO: fix debug, missing dll?
if [ ! -f build.ninja ]; then
    $script_dir/run.sh vs_prompt.sh wine cmake llvm -G Ninja -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_BUILD_TYPE=Release
fi
$script_dir/run.sh vs_prompt.sh wine ninja "$@"
