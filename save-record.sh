#!/bin/bash
set -e
name=${1-record}

dir=$(dirname $0)
echo converting $(ls record_*.png|wc -l) images
gm convert -loop 1 -delay 100 -fill red -draw 'text 20,20 "%f"' -normalize -depth 2 record_*.png $dir/results/$name.gif && \
rm *.png
ls -l $dir/results/$name.gif
