#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

./build.product.sh

./sh/filename_min.coffee

git add -A
git commit -mdist || true

cd dist

config(){
  cat $DIR/sh/config.coffee|grep $1|awk -F\' '{print $2}'
}

wrangler pages publish --project-name $(config CLOUDFLARE_PAGE) .
rclone copy . ali:$(config OSS_SITE)
