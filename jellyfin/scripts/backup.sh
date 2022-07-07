#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  elif [[ -z "$BACKUP_DIRECTORY" ]]; then
    echo "Please set an environment variable for 'BACKUP_DIRECTORY' before running this script."
    exit 1
  elif [[ -z "$BACKUP_TIMESTAMP" ]]; then
    echo "Please set an environment variable for 'BACKUP_TIMESTAMP' before running this script."
    exit 1
  fi
}

function print_preamble() {
  CONTAINER_NAME=$1

  echo "Backing up '$CONTAINER_NAME' container volume..."
}

function print_postamble() {
  CONTAINER_NAME=$1

  echo "Finished backing up: '$CONTAINER_NAME'"
}

function backup_jellyfin() {
  print_preamble "jellyfin-server"

  

  print_postamble "jellyfin-server" 
}

function main() {
  check_requirements

  backup_jellyfin
}

main
