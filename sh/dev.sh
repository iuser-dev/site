#!/usr/bin/env bash
DIR=$( dirname $(realpath "$0") )

cd $DIR/..

if [ -z "$VITE_PORT" ]; then
VITE_PORT=5555
fi

set -ex
kill -9 $(lsof -i:$VITE_PORT -t) 2>/dev/null | true

bun run cep -- -c vite

bun run concurrently --kill-others \
  -r "bun run dev"
