#!/usr/bin/env bash

set -euo pipefail
set -x

script_dir=$(dirname $(readlink -f $0))
llvm_root=$(pwd)

# TODO: fix debug, missing dll on path?
# TODO: add possibility to switch to clang-cl
compiler=cl.exe

cmake_args="Z:${llvm_root}/llvm -GNinja
            -DCMAKE_C_COMPILER=$compiler -DCMAKE_CXX_COMPILER=$compiler
            -DCMAKE_BUILD_TYPE=Release
            -DLLVM_ENABLE_PROJECTS=clang"
run="$script_dir/run.sh vs_prompt.sh"

mkdir -p x64
pushd x64
$run x64 wine cmake $cmake_args
$run x64 wine ninja
popd

#mkdir -p arm64
#pushd arm64
## Setting CMAKE_CROSSCOMPILING from command line does not work, it's overriden
## when configuring clang. And calls clang-ast-dump.exe which does not work.
## Thus, we need a toolchain file to make it work.
#cat > arm64.cmake << EOF
#set(CMAKE_SYSTEM_NAME Windows)
#set(CMAKE_CROSSCOMPILING ON)
#set(LLVM_TABLEGEN Z:/${llvm_root}/x64/bin/llvm-tblgen.exe)
#set(CLANG_TABLEGEN Z:/${llvm_root}/x64/bin/clang-tblgen.exe)
#set(DLLVM_NM Z:/${llvm_root}/x64/bin/llvm-nm.exe)
#EOF
#$run arm64 wine cmake $cmake_args -DCMAKE_TOOLCHAIN_FILE=arm64.cmake
#$run arm64 wine ninja
#popd
