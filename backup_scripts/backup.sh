#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <app_number>"
    echo "[1] Mealie  [2] Forgejo"
    exit 1
fi

input="$1"
case $input in
    1) app_name="mealie" ;;
    2) app_name="forgejo" ;;
    *) echo "Invalid number"; exit 1 ;;
esac

FILE_NAME="${app_name}-dump-$(date +%Y-%m-%d).zip"

if [ ! -f ".env.$app_name" ]; then
    echo ".env.$app_name not found!"
    exit 1
fi
source .env.$app_name

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
