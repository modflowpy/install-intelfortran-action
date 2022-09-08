#!/bin/bash

source /opt/intel/oneapi/setvars.sh
ifort scripts/test/hw.f90 -o hw
output=$(./hw '2>&1')
if [[ "$output" == *"hello world"* ]]
then
  echo "Compiled and ran successfully, output: $output"
else
  exit 1
fi
