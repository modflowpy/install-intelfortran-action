#!/bin/bash

path="$1"
if [ -z "$path" ]
then
  echo "Must specify path argument"
  exit 1
fi

if [ -d "$path" ]
then
  echo "Install location exists: $path"
else
  echo "Install location doesn't exist: $path"
  exit 1
fi

if command -v ifort &> /dev/null
then
  echo "Command ifort available"
else
  echo "Command ifort not available"
  exit 1
fi

ifort test/hw.f90 -o hw
echo "Compile succeeded"

output=$(./hw '2>&1')
if [[ "$output" == *"hello world"* ]]
then
  echo "$output"
else
  echo "Unexpected output: $output"
  exit 1
fi
