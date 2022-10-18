#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname $(readlink -f $0))

build_container()
{
    docker build $script_dir/arm64 -t msvc_arm64
}

create_wineprefix()
{
    # wine insists to own its prefix, but in container, root owns it.
    # so we fake a user prefix by symlinking the original.
    path=$1; shift

    mkdir -p $path
    trap "rm -rf $path" EXIT

    for link in dosdevices  drive_c  system.reg  userdef.reg  user.reg;
    do
        ln -s /opt/wine/$link $path/
    done
}

run_container()
{
    wineprefix=$1; shift

    all_id=$(id -G | tr ' ' '\n' | sed -e 's/^/--group-add /g' | tr '\n' ' ')
    docker run -it --rm=true -u $UID $all_id \
        -v $wineprefix:$wineprefix \
        -v $(pwd):$(pwd) \
        -v $HOME:$HOME \
        -w $(pwd) \
        -e WINEPREFIX=$wineprefix \
        msvc_arm64 "$@"
}

wineprefix=$(mktemp -d)
trap "rm -rf $wineprefix" EXIT

build_container
create_wineprefix $wineprefix
run_container $wineprefix "$@"
