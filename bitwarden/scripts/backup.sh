#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
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

  mkdir -p backups

  docker exec -u git -i "gitea-web" \
    bash -c "/app/gitea/gitea dump --type tar.gz --file /tmp/gitea.tar.gz"

  docker cp gitea-web:/tmp/gitea.tar.gz backups/gitea.tar.gz

  print_postamble "gitea-web" 
}

function main() {
  check_requirements

  backup_gitea
}

main
