#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

./sh/init.sh

bun run build
#./sh/filename_min.coffee
