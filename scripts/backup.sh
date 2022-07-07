#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  elif [[ -z "$BACKUP_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'BACKUP_DIRECTORY'"
    exit 1
  fi
}

function backup_program() {
  PROGRAM_DIRECTORY=$(pwd)/$1

  if [[ ! -d "$PROGRAM_DIRECTORY" ]]; then
    echo "$PROGRAM does not exist on path: $PROGRAM_DIRECTORY"
    exit 1
  elif [[ ! -f "$PROGRAM_DIRECTORY/docker-compose.yml" ]]; then
    echo "$PROGRAM does not contain docker-compose.yml on path: $PROGRAM_DIRECTORY"
    exit 1
  fi

  export BACKUP_TIMESTAMP=$(date +%Y%m%d-%H%M%S)

  pushd $PROGRAM_DIRECTORY
    make backup
  popd
}

function main() {
  check_requirements

  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "Creating backup directory: $BACKUP_DIRECTORY"
    mkdir -p "$BACKUP_DIRECTORY"
  fi

  PROGRAMS=(gitea jellyfin)
  for program in ${PROGRAMS[@]}; do
    backup_program $program
  done
}

main
