#!/usr/bin/env bash

set -euo pipefail
set -x

script_dir=$(dirname $(readlink -f $0))
llvm_root=$(pwd)

# TODO: fix debug, missing dll on path?
# TODO: add possibility to switch to clang-cl
compiler=cl.exe

cmake_args="Z:${llvm_root}/llvm -GNinja -DCMAKE_C_COMPILER=$compiler -DCMAKE_CXX_COMPILER=$compiler -DCMAKE_BUILD_TYPE=Release"
run="$script_dir/run.sh vs_prompt.sh"

mkdir -p x64
pushd x64
$run x64 wine cmake $cmake_args
$run x64 wine ninja
popd

mkdir -p arm64
pushd arm64
$run arm64 wine cmake $cmake_args \
    -DCMAKE_CROSSCOMPILING=ON \
    -DLLVM_TABLEGEN=Z:/${llvm_root}/x64/bin/llvm-tblgen.exe \
    -DLLVM_NM=Z:/${llvm_root}/x64/bin/llvm-nm.exe
$run arm64 wine ninja
popd
