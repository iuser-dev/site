#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

bun run concurrently -- --kill-others \
  "watchexec --shell=none -w ./src/s.coffee -r  -- bun run cep -- -c src/s.coffee -o dist"\
  "./preview.sh"

