#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

out=li.txt
qshell listbucket2 iuser -o $out
qshell batchdelete --force iuser -i $out
rm -rf $out .id .uploaded/
