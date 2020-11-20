#!/bin/bash

set -ex
args="$@"

for module in build/@tvpsoft/*; do
    pushd $module
        npm publish $args
    popd
done
