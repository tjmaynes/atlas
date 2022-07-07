#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  elif [[ -z "$BACKUP_DIRECTORY" ]]; then
    echo "Please set an environment variable for 'BACKUP_DIRECTORY' before running this script"
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
  fi
}

function main() {
  check_requirements

  docker compose up -d

  if [[ ! -d "$JELLYFIN_BASE_DIRECTORY" ]]; then
    mkdir -p $JELLYFIN_BASE_DIRECTORY
  fi

  if [[ ! -d "$JELLYFIN_MEDIA_DIRECTORY" ]]; then
    mkdir -p $JELLYFIN_MEDIA_DIRECTORY
  fi

  BACKUP_DIRECTORY="$(ls -td $BACKUP_DIRECTORY/*/ | head -1)"
  if [[ -f "$BACKUP_DIRECTORY/jellyfin.tar.gz" ]]; then
    make restore
  fi
}

main
