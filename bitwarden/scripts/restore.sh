#!/bin/bash

set -e

function check_requirements() {
  if [[ -z "$(command -v docker)" ]]; then
    echo "Please install 'docker' before running this script."
    exit 1
  elif [[ ! -d "$BACKUP_DIRECTORY" ]]; then
    echo "No backup directories exist in the file system. Nothing to restore!"
    exit 1
  elif [[ ! -f "$BACKUP_DIRECTORY/gitea.tar.gz" ]]; then
    echo "No gitea backup exists in the file system. Nothing to restore!"
    exit 1
  elif [[ -z "$GITEA_USER" ]]; then
    echo "Please set an environment variable for 'GITEA_USER' before running this script"
    exit 1
  elif [[ -z "$GITEA_DATABASE" ]]; then
    echo "Please set an environment variable for 'GITEA_DATABASE' before running this script"
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

function unpack_tarred_backup() {
  BACKUP_LOCATION=$BACKUP_DIRECTORY/$1

  if [[ -d "$BACKUP_DIRECTORY" ]]; then
    rm -rf $BACKUP_LOCATION
    mkdir -p $BACKUP_LOCATION

    tar -xf $BACKUP_LOCATION.tar.gz -C $BACKUP_LOCATION
  fi
}

function wait_until_postgres_is_up() {
  RETRIES=5

  until docker exec -i "gitea-db" bash -c "psql -U $GITEA_USER -c \"select 1\"" > /dev/null 2>&1 || [ $RETRIES -eq 0 ]; do
    echo "Waiting for postgres server, $((RETRIES--)) remaining attempts..."
    sleep 1
  done
}

function main() {
  check_requirements

  unpack_tarred_backup "gitea"

  print_preamble "gitea-db"

  wait_until_postgres_is_up

  docker cp "$BACKUP_DIRECTORY/gitea/gitea-db.sql" gitea-db:/tmp

  docker exec -i "gitea-db" \
    bash -c "psql -U $GITEA_USER -d $GITEA_DATABASE < /tmp/gitea-db.sql"

  print_postamble "gitea-db" 

  print_preamble "gitea-web"

  docker cp "$BACKUP_DIRECTORY/gitea/data" gitea-web:/tmp/backup-data

  docker exec -i "gitea-web" \
    bash -c "cp -rf /tmp/backup-data /data/gitea"

  if [[ -d "$BACKUP_DIRECTORY/gitea/repos" ]]; then
    docker cp "$BACKUP_DIRECTORY/gitea/repos" gitea-web:/tmp/backup-repos

    docker exec -i "gitea-web" \
      bash -c "cp -rf /tmp/backup-repos /data/git/repositories"
  fi

  docker exec -i "gitea-web" \
    bash -c "chown -R git:git /data"

  docker exec -u git -i "gitea-web" \
    bash -c "/usr/local/bin/gitea -c '/data/gitea/conf/app.ini' admin regenerate hooks" || true

  print_postamble "gitea-web" 
}

main
