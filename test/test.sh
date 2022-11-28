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
  echo "Fortran classic compiler found"
else
  echo "Fortran classic compiler not available"
  exit 1
fi

if [[ ( "$OSTYPE" == "cygwin" ) || ( "$OSTYPE" == "msys" ) || ( "$OSTYPE" == "win32" ) ]]; then
  cmd=$(command -v icl)
else
  cmd=$(command -v icpc)
fi
if [ "$cmd" ]; then
  echo "C/C++ classic compiler found"
else
  echo "C/C++ classic compiler not available"
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
  echo "Fortran program compilation succeeded"
  echo "$output"
else
  echo "Fortran program gave unexpected output: $output"
  exit 1
fi

sudo rm -rf hw
if [[ ( "$OSTYPE" == "cygwin" ) || ( "$OSTYPE" == "msys" ) || ( "$OSTYPE" == "win32" ) ]]; then
  icl test/hw.cpp -o hw.exe
  output=$(./hw.exe '2>&1')
else
  icpc test/hw.cpp -o hw
  output=$(./hw '2>&1')
fi
if [[ "$output" == *"hello world"* ]]
then
  echo "C++ program compilation succeeded"
  echo "$output"
else
  echo "C++ program gave unexpected output: $output"
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