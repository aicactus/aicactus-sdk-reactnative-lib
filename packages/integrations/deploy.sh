#!/bin/bash

set -ex
args="$@"

for module in build/@aicactus/*; do
    pushd $module
        npm publish $args
    popd
done
