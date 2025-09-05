#!/bin/bash
set -euo pipefail

# Load Mealie env
if [ ! -f .env ]; then
    echo ".env not found!"
    exit 1
fi
source .env

echo "Stopping Mealie container..."
docker stop "$CONTAINER_NAME"

echo "Backing up Mealie data..."
cp "$DATA_PATH" "$BACKUP_TARGET_DIR/"

echo "Restarting Mealie container..."
docker start "$CONTAINER_NAME"

echo "Mealie backup complete. Files saved to $BACKUP_TARGET_DIR"
