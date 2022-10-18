#!/usr/bin/env bash

set -euo pipefail

script_dir=$(dirname $(readlink -f $0))

docker build $script_dir/docker -t msvc

tmp=$(mktemp -d)
trap "rm -rf $tmp" EXIT

all_id=$(id -G | tr ' ' '\n' | sed -e 's/^/--group-add /g' | tr '\n' ' ')
docker run -it --rm=true -u $UID $all_id msvc "$@"
