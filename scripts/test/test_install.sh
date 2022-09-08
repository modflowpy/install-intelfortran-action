#!/bin/bash

source /opt/intel/oneapi/setvars.sh

path="$1"
if [ -z "$path" ]
then
  echo "Must specify path argument"
  exit 1
fi

# check install location
echo "Checking install location: $path"
if [ ! -d "$path" ]
then
  echo "Install location does not exist: $path"
  exit 1
fi

# check ifort executable
echo "Checking ifort command"
if ! command -v ifort &> /dev/null
then
  echo "ifort command is not available"
  exit 1
fi