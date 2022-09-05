#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

bun run concurrently -- --kill-others \
  "./sh/dev.sh"
