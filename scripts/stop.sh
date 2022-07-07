#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  fi
}

function stop_program() {
  PROGRAM=$1  
  PROGRAM_DIRECTORY=$(pwd)/$1

  if [[ ! -d "$PROGRAM_DIRECTORY" ]]; then
    echo "$PROGRAM does not exist on path: $(pwd)/$PROGRAM"
    exit 1
  elif [[ ! -f "$PROGRAM_DIRECTORY/docker-compose.yml" ]]; then
    echo "$PROGRAM does not contain docker-compose.yml on path: $PROGRAM_DIRECTORY"
    exit 1
  fi

  pushd $PROGRAM_DIRECTORY
    make stop
  popd
}

function main() {
  check_requirements

  PROGRAMS=(gitea jellyfin)
  for program in ${PROGRAMS[@]}; do
    stop_program $program
  done
}

main
