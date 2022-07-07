#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  elif [[ -z "$BACKUP_DIRECTORY" ]]; then
    echo "Please set an environment variable for 'BACKUP_DIRECTORY' before running this script"
    exit 1
  elif [[ -z "$GITEA_USER" ]]; then
    echo "Please set an environment variable for 'GITEA_USER' before running this script"
    exit 1
  elif [[ -z "$GITEA_DATABASE" ]]; then
    echo "Please set an environment variable for 'GITEA_DATABASE' before running this script"
    exit 1
  elif [[ -z "$GITEA_DATABASE_PASSWORD" ]]; then
    echo "Please set an environment variable for 'GITEA_DATABASE_PASSWORD' before running this script"
    exit 1
  fi
}

function main() {
  check_requirements

  docker compose up -d

  BACKUP_DIRECTORY="$(ls -td $BACKUP_DIRECTORY/*/ | head -1)"
  if [[ -f "$BACKUP_DIRECTORY/gitea.tar.gz" ]]; then
    make restore
  fi
}

main
