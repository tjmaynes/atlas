#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  elif [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "No jellyfin backup directory exists in the file system: $BACKUP_DIRECTORY. Nothing to restore!"
    exit 1
  elif [[ ! -d "$BACKUP_DIRECTORY/jellyfin" ]]; then
    echo "No jellyfin backup directory exists in the file system: $BACKUP_DIRECTORY. Nothing to restore!"
    exit 1
  elif [[ -z "$JELLYFIN_BASE_DIRECTORY" ]]; then
    echo "Please set an environment variable for 'JELLYFIN_BASE_DIRECTORY' before running this script"
    exit 1
  elif [[ -z "$JELLYFIN_MEDIA_DIRECTORY" ]]; then
    echo "Please set an environment variable for 'JELLYFIN_MEDIA_DIRECTORY' before running this script"
    exit 1
  elif [[ -z "$JELLYFIN_SERVER_URL" ]]; then
    echo "Please set an environment variable for 'JELLYFIN_SERVER_URL' before running this script"
    exit 1
  elif [[ -z "$JELLYFIN_TIMEZONE" ]]; then
    echo "Please set an environment variable for 'JELLYFIN_TIMEZONE' before running this script"
    exit 1
  elif [[ -z "$JELLYFIN_UID" ]]; then
    echo "Please set an environment variable for 'JELLYFIN_UID' before running this script"
    exit 1
  elif [[ -z "$JELLYFIN_GID" ]]; then
    echo "Please set an environment variable for 'JELLYFIN_GID' before running this script"
    exit 1
  fi
}

function print_preamble() {
  CONTAINER_NAME=$1

  echo "Restoring '$CONTAINER_NAME' container volume from backup: $BACKUP_DIRECTORY"
}

function print_postamble() {
  CONTAINER_NAME=$1

  echo "Finished restoring '$CONTAINER_NAME'"
}

function main() {
  check_requirements

  print_preamble "jellyfin-web"

  

  print_postamble "jellyfin-web" 
}

main
