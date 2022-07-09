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
  print_preamble "jellyfin-server"

  pushd $(dirname $JELLYFIN_BASE_DIRECTORY)
    tar -czvf $BACKUP_DIRECTORY/jellyfin-$BACKUP_TIMESTAMP.tar.gz jellyfin/config
  popd

  print_postamble "jellyfin-server"
}

function main() {
  check_requirements

  if [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "Creating backup directory: $BACKUP_DIRECTORY"
    mkdir -p "$BACKUP_DIRECTORY"
  fi

  BACKUP_TIMESTAMP=$(date +%Y%m%d-%H%M%S)

  PROGRAMS=(gitea jellyfin)
  for program in ${PROGRAMS[@]}; do
    backup_$program
  done
}

main
