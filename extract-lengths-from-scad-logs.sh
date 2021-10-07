#!/bin/bash

set -euo pipefail

# pipe output of scad console log to this script, e.g. `pbpaste | ./extract-lengths-from-scad-logs.sh`
cat - | grep "Element idx:\|Number of" | sed -e 's/.*height: ", //g' | sed -e 's/.*Number of elements.*/$/g' | tr "\n" "," | sed -e 's/$,/\n/g' | sed -e 's/,$//g' | grep -v "^$"
