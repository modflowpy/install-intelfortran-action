#!/bin/bash

path="$1"
if [ -z "$path" ]
then
  echo "must specify path argument"
  exit 1
fi

if [ -d "$path" ]
then
  echo "install location exists: $path"
else
  echo "install location doesn't exist: $path"
  exit 1
fi

if command -v ifort &> /dev/null
then
  echo "ifort found"
else
  echo "ifort not available"
  exit 1
fi

if command -v icpc &> /dev/null
then
  echo "icpc found"
else
  echo "icpc not available"
  exit 1
fi

# if [[ "$OSTYPE" == "darwin"* ]]; then
#   echo "DPC++/C++ not supported on macOS, use classic compilers instead"
# else
#   if command -v icpx &> /dev/null
#   then
#     echo "icpx found"
#   else
#     echo "icpx not available"
#     exit 1
#   fi
# fi

ifort test/hw.f90 -o hw
output=$(./hw '2>&1')
if [[ "$output" == *"hello world"* ]]
then
  echo "ifort compile succeeded"
  echo "$output"
else
  echo "ifort unexpected output: $output"
  exit 1
fi

sudo rm -rf hw
icpc test/hw.cpp -o hw
output=$(./hw '2>&1')
if [[ "$output" == *"hello world"* ]]
then
  echo "icpc compile succeeded"
  echo "$output"
else
  echo "icpc unexpected output: $output"
  exit 1
fi

# if [[ "$OSTYPE" == "darwin"* ]]; then
#   echo "DPC++/C++ not supported on macOS, use classic compilers instead"
# else
#   sudo rm -rf hw
#   icpx test/hw.cpp -o hw
#   output=$(./hw '2>&1')
#   if [[ "$output" == *"hello world"* ]]
#   then
#     echo "icpx compile succeeded"
#     echo "$output"
#   else
#     echo "icpx unexpected output: $output"
#     exit 1
#   fi
# fi