#!/usr/bin/env bash

arduino-cli compile -b arduino:avr:mega -p /dev/ttyUSB0 -u -v Marlin
