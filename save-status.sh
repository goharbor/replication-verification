#!/bin/bash
set  -ex

goodnum=${1}
name=$2

dir=$(dirname $0)
cd $dir

if [ "$goodnum" == "4" ]; then
  echo good $goodnum > results/$name.txt
  sed -e "s/DATE/$(date +"%m%d%H%M")/g" good.svg > results/$name.svg
else
  echo bad $goodnum > results/$name.txt
  sed -e "s/DATE/$(date +"%m%d%H%M")/g" bad$goodnum.svg > results/$name.svg
fi
