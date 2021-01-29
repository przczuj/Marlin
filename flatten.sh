#!/usr/bin/env bash

DEVICE=${1:-/dev/ttyUSB0}
BAUD=${2:-115200}

function echot() {
    echo "[$(date +%H:%M:%S)] $@"
}

fuser -k $DEVICE
stty -F $DEVICE -echo $BAUD

exec 3<> $DEVICE

DIRECTION=S
while : ; do
    if [ "$DIRECTION" == "S" ]; then
        echot "Going south"
        echo "G1 Y200" >&3
        DIRECTION="E"
    elif [ "$DIRECTION" == "E" ]; then
        echot "Going east"
        echo "G1 X200" >&3
        DIRECTION="N"
    elif [ "$DIRECTION" == "N" ]; then
        echot "Going north"
        echo "G1 Y0" >&3
        DIRECTION="W"
    elif [ "$DIRECTION" == "W" ]; then
        echot "Going west"
        echo "G1 X0" >&3
        DIRECTION="S"
    fi
    while read -t 10 gcode_response <&3; do
        RETURN_CODE=$?
        echot "RECV: $gcode_response"
        if [ $RETURN_CODE -gt 128 ] || [[ "$gcode_response" == "ok"* ]]; then
            break
        fi
    done
done

