#!/bin/bash
set -e

target=$1

TMPFILE=$(mktemp)
dd if=/dev/urandom of=$TMPFILE count=1024 bs=1024
ID=$(docker create busybox)
docker cp $TMPFILE $ID:/test
rm $TMPFILE
echo create image $target
docker commit $ID $target
docker rm $ID
