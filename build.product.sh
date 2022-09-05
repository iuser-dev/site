#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex
export NODE_ENV=production
./build.sh

ug(){
bun run uglifyjs -- -o $1.js --compress --mangle --toplevel -- $1.js
}

bun run cep -- -c src/s.coffee -o dist
CDN_JS=dist/cdn/js

cd dist
sd "svelte-" "X" $(fd -e js -e css -e html --follow --hidden --exclude .git)
rm -rf i18n
cd ..

ug dist/s

./sh/m.coffee

ug dist/m

