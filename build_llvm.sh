#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname $(readlink -f $0))
# TODO: fix debug, missing dll?
#$script_dir/run.sh vs_prompt.sh wine cmake llvm -G Ninja -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_BUILD_TYPE=Release
$script_dir/run.sh vs_prompt.sh wine cmake llvm -G Ninja \
    -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CROSSCOMPILING=ON \
    -DCMAKE_C_COMPILER_WORKS=true -DCMAKE_CXX_COMPILER_WORKS=true \
    -DLLVM_TABLEGEN=Z:$(pwd)/x64/llvm-tblgen.exe \
    -DLLVM_NM=Z:/$(pwd)/x64/llvm-nm.exe

$script_dir/run.sh vs_prompt.sh wine ninja "$@"
