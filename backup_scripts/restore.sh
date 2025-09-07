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


echo "Stopping $app_name container..."
docker stop "$CONTAINER_NAME"

echo "Deleting old data..."
rm -rf "$RESTORE_TARGET_PATH"

echo "Loading backup data..."
BACKUP_FILE=$(ls "$RESTORE_SRC_PATH/${app_name}-dump-"*.zip | sort | tail -n1)
unzip -o "$BACKUP_FILE" -d "$RESTORE_TARGET_PATH"

echo "Restarting $app_name container..."
docker start "$CONTAINER_NAME"

echo "Restore completed :)"
