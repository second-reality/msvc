#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname $(readlink -f $0))

build_container()
{
    docker build $script_dir/docker -t msvc
    clear
}

create_wineprefix()
{
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
        -w $(pwd) \
        -e WINEPREFIX=$wineprefix \
        msvc "$@"
}

wineprefix=$(mktemp -d)
trap "rm -rf $wineprefix" EXIT

build_container
create_wineprefix $wineprefix
run_container $wineprefix "$@"
