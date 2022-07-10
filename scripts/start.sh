#!/bin/bash

set -e

function check_env_var_exists() {
  if [[ -z "$2" ]]; then
    echo "Please set an environment variable for '$1' before running this script"
    exit 1
  fi
}

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  fi

  check_env_var_exists "BACKUP_DIRECTORY" "$BACKUP_DIRECTORY"
  check_env_var_exists "TIMEZONE" "$TIMEZONE"
  check_env_var_exists "GITEA_USER" "$GITEA_USER"
  check_env_var_exists "GITEA_DATABASE" "$GITEA_DATABASE"
  check_env_var_exists "GITEA_DATABASE_PASSWORD" "$GITEA_DATABASE_PASSWORD"
  check_env_var_exists "JELLYFIN_BASE_DIRECTORY" "$JELLYFIN_BASE_DIRECTORY"
  check_env_var_exists "JELLYFIN_MEDIA_DIRECTORY" "$JELLYFIN_MEDIA_DIRECTORY"
  check_env_var_exists "JELLYFIN_SERVER_URL" "$JELLYFIN_SERVER_URL"
  check_env_var_exists "TINYMEDIAMANAGER_PORT" "$TINYMEDIAMANAGER_PORT"
  check_env_var_exists "TINYMEDIAMANAGER_BASE_DIRECTORY" "$TINYMEDIAMANAGER_BASE_DIRECTORY"
  check_env_var_exists "TINYMEDIAMANAGER_MOVIES_DIRECTORY" "$TINYMEDIAMANAGER_MOVIES_DIRECTORY"
  check_env_var_exists "TINYMEDIAMANAGER_TVSHOWS_DIRECTORY" "$TINYMEDIAMANAGER_TVSHOWS_DIRECTORY"
}

function main() {
  check_requirements

  if [[ ! -d "$JELLYFIN_BASE_DIRECTORY" ]]; then
    mkdir -p $JELLYFIN_BASE_DIRECTORY
  fi

  if [[ ! -d "$JELLYFIN_MEDIA_DIRECTORY" ]]; then
    mkdir -p $JELLYFIN_MEDIA_DIRECTORY
  fi

  docker compose up -d
}

main
