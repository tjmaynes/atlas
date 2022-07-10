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

function print_preamble() {
  CONTAINER_NAME=$1

  echo "Backing up '$CONTAINER_NAME' container volume..."
}

function print_postamble() {
  CONTAINER_NAME=$1

  echo "Finished backing up: '$CONTAINER_NAME'"
}

function backup_gitea() {
  print_preamble "gitea-web"

  docker exec -u git -i "gitea-web" \
    bash -c "/app/gitea/gitea dump --type tar.gz --file /tmp/gitea.tar.gz"

  docker cp gitea-web:/tmp/gitea.tar.gz $BACKUP_DIRECTORY/gitea-$BACKUP_TIMESTAMP.tar.gz

  print_postamble "gitea-web" 
}

function backup_jellyfin() {
  if [[ -z "$JELLYFIN_BASE_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'JELLYFIN_BASE_DIRECTORY'"
    exit 1
  fi

  print_preamble "jellyfin-server"

  pushd $(dirname $JELLYFIN_BASE_DIRECTORY)
    tar -czvf $BACKUP_DIRECTORY/jellyfin-$BACKUP_TIMESTAMP.tar.gz jellyfin/config
  popd

  print_postamble "jellyfin-server"
}

function backup_tinyMediaManager() {
  if [[ -z "$TINYMEDIAMANAGER_BASE_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'TINYMEDIAMANAGER_BASE_DIRECTORY'"
    exit 1
  fi

  print_preamble "tinyMediaManager-web"

  pushd $(dirname $TINYMEDIAMANAGER_BASE_DIRECTORY)
    tar -czvf $BACKUP_DIRECTORY/tinyMediaManager-$BACKUP_TIMESTAMP.tar.gz tinyMediaManager/data
  popd

  print_postamble "tinyMediaManager-web"
}

function backup_portainer() {
  if [[ -z "$PORTAINER_BASE_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'PORTAINER_BASE_DIRECTORY'"
    exit 1
  fi

  print_preamble "portainer-web"

  pushd $(dirname $PORTAINER_BASE_DIRECTORY)
    tar -czvf $BACKUP_DIRECTORY/portainer-$BACKUP_TIMESTAMP.tar.gz portainer/data
  popd

  print_postamble "portainer-web"
}

function backup_flame() {
  if [[ -z "$FLAME_BASE_DIRECTORY" ]]; then
    echo "Please set a value for environment variable 'FLAME_BASE_DIRECTORY'"
    exit 1
  fi

  print_preamble "flame-web"

  pushd $(dirname $FLAME_BASE_DIRECTORY)
    tar -czvf $BACKUP_DIRECTORY/flame-$BACKUP_TIMESTAMP.tar.gz flame/data
  popd

  print_postamble "flame-web"
}

function main() {
  check_requirements

  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "Creating backup directory: $BACKUP_DIRECTORY"
    mkdir -p "$BACKUP_DIRECTORY"
  fi

  BACKUP_TIMESTAMP=$(date +%Y%m%d-%H%M%S)

  PROGRAMS=(gitea jellyfin tinyMediaManager portainer flame)
  for program in ${PROGRAMS[@]}; do
    backup_$program
  done
}

main
