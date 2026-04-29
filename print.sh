#!/usr/bin/env bash

DEVICE=${1:-/dev/ttyUSB0}
BAUD=${2:-115200}

function echot() {
    echo "[$(date +%H:%M:%S)] $@"
}

fuser -k $DEVICE
stty -F $DEVICE -echo $BAUD

exec 3<> $DEVICE

while read -t 3 initial_message <&3; do
    if [ $? -gt 128 ]; then
        break
    fi
    echot "RECV: $initial_message"
done

while read gcode_line; do
    if [[ "$gcode_line" == ";"* ]]; then
        echot "IGNR: $gcode_line"
        continue
    elif [ -n "$gcode_line" ]; then
        echot "SEND: $gcode_line"
        echo $gcode_line >&3
        while read -t 10 gcode_response <&3; do
            RETURN_CODE=$?
            echot "RECV: $gcode_response"
            if [ $RETURN_CODE -gt 128 ] || [[ "$gcode_response" == "ok"* ]]; then
                break
            fi
        done
    fi
done
