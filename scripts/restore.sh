#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  elif [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "No backup directories do not exist in the file system. Nothing to restore!"
    exit 1
  fi
}

function unpack_tarred_backup() {
  TAR_BACKUP_LOCATION=$1
  TARGET_BACKUP_DIRECTORY=$2

  if [[ -f "$TAR_BACKUP_LOCATION" ]]; then
    rm -rf $TARGET_BACKUP_DIRECTORY && mkdir -p $TARGET_BACKUP_DIRECTORY

    tar -xf $TAR_BACKUP_LOCATION -C $TARGET_BACKUP_DIRECTORY
  fi
}

function restore_program() {
  PROGRAM=$1
  PROGRAM_DIRECTORY=$(pwd)/$PROGRAM

  if [[ ! -d "$PROGRAM_DIRECTORY" ]]; then
    echo "$PROGRAM does not exist on path: $PROGRAM_DIRECTORY"
    exit 1
  elif [[ ! -f "$PROGRAM_DIRECTORY/docker-compose.yml" ]]; then
    echo "$PROGRAM does not contain docker-compose.yml on path: $PROGRAM_DIRECTORY"
    exit 1
  fi

  LATEST_TAR_BACKUP_LOCATION="$(ls -td $BACKUP_DIRECTORY/$PROGRAM-* | head -1)"

  unpack_tarred_backup "$LATEST_TAR_BACKUP_LOCATION" "$BACKUP_DIRECTORY/$PROGRAM"

  pushd $PROGRAM_DIRECTORY
    make restore
  popd
}

function main() {
  check_requirements

  PROGRAMS=(gitea)
  for program in ${PROGRAMS[@]}; do
    restore_program $program
  done
}

main
