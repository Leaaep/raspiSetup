#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <app_name>"
    echo "mealie, forgejo, portainer or any with an compatible .env.<app_name> file"
    exit 1
fi

app_name = $1

if [ ! -f ".env.$app_name" ]; then
    echo ".env.$app_name not found!"
    exit 1
fi
source .env.$app_name

FILE_NAME="${app_name}-dump-$(date +%Y-%m-%d).zip"

echo "Stopping $app_name container..."
docker stop "$CONTAINER_NAME"

echo "Backing up $app_name data..."
(
    cd "$BACKUP_SRC_DIR" || { echo "Cannot cd to $BACKUP_SRC_DIR"; exit 1; }
    zip -r "$BACKUP_TARGET_DIR/$FILE_NAME" .
)

echo "Restarting $app_name container..."
docker start "$CONTAINER_NAME"

echo "$app_name backup complete. Files saved to $BACKUP_TARGET_DIR/$FILE_NAME"
