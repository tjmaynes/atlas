#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  fi
}

function start_gitea() {
  if [[ -z "$BACKUP_DIRECTORY" ]]; then
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

  docker compose up -d
}

function start_jellyfin() {
  if [[ -z "$JELLYFIN_BASE_DIRECTORY" ]]; then
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

  docker compose up -d

  if [[ ! -d "$JELLYFIN_BASE_DIRECTORY" ]]; then
    mkdir -p $JELLYFIN_BASE_DIRECTORY
  fi

  if [[ ! -d "$JELLYFIN_MEDIA_DIRECTORY" ]]; then
    mkdir -p $JELLYFIN_MEDIA_DIRECTORY
  fi
}

function main() {
  check_requirements

  PROGRAMS=(gitea jellyfin)
  for program in ${PROGRAMS[@]}; do
    start_$program
  done
}

main
