#!/usr/bin/env bash

MIN_X=10
MAX_X=190
MIN_Y=10
MAX_Y=190

# init
echo "G90"
echo "G28"

while true; do
    echo "G1 X$MIN_X Y$MIN_Y"
    echo "G1 X$MAX_X Y$MIN_Y"
    echo "G1 X$MAX_X Y$MAX_Y"
    echo "G1 X$MIN_X Y$MAX_Y"
done
