#!/usr/bin/env bash

arduino-cli compile \
  -b arduino:avr:mega \
  --build-path build/.arduino-build \
  --build-cache-path build/.arduino-cache \
  --jobs 4 \
  -p /dev/ttyUSB0 -u -v Marlin
