#!/bin/bash
set -euo pipefail

FILE_NAME="mealie-dump-$(date +%Y-%m-%d).zip"
FOLDER_NAME="mealie-dump-$(date +%Y-%m-%d)"

# Load Mealie env
if [ ! -f .env.mealie ]; then
    echo ".env.mealie not found!"
    exit 1
fi
source .env.mealie

echo "Stopping Mealie container..."
docker stop "$CONTAINER_NAME"

echo "Backing up Mealie data..."
cp -r "$BACKUP_SRC_DIR" "$BACKUP_TARGET_DIR/" && zip -r $FILE_NAME "$BACKUP_TARGET_DIR/$FOLDER_NAME"

echo "Restarting Mealie container..."
docker start "$CONTAINER_NAME"

echo "Mealie backup complete. Files saved to $BACKUP_TARGET_DIR"
