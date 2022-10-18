#!/usr/bin/env bash

set -euo pipefail
set -x

script_dir=$(dirname $(readlink -f $0))

docker build $script_dir/docker -t msvc

tmp=$(pwd)/prefix/
mkdir -p $tmp
trap "rm -rf $tmp" EXIT

for link in dosdevices  drive_c  system.reg  userdef.reg  user.reg;
do
    ln -s /opt/wine/$link $tmp/
done

all_id=$(id -G | tr ' ' '\n' | sed -e 's/^/--group-add /g' | tr '\n' ' ')
docker run -it --rm=true -u $UID $all_id -v $tmp:$tmp -e WINEPREFIX=$tmp/ msvc "$@"
