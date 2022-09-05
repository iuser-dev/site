#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
. sh/pid.sh
set -ex
export WEBDIR=$DIR
bash -c "sleep 3 && open http://127.0.0.1:9999" &
kill -9 $(lsof -t -i:9999) || true

exec openresty -c $DIR/nginx.conf
