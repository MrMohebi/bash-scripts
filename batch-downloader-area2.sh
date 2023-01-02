#!/bin/bash

usage() {
  __usage="
  Usage: $(basename $0) [OPTIONS]

  Options:
    -p, executable path <string>    [required] Absolute path to executable file
    -h, help                                   help
  "
  echo "$__usage"
  exit 1;
}

start=$1
end=$2
link=$3
