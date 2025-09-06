#!/bin/bash
set -euo pipefail

# Load Mealie env
if [ ! -f .env.mealie ]; then
    echo ".env.mealie not found!"
    exit 1
fi
source .env.mealie

echo "Stopping Mealie container..."
docker stop "$CONTAINER_NAME"

echo "Backing up Mealie data..."
cp "$BACKUP_SRC_DIR" "$BACKUP_TARGET_DIR/"

echo "Restarting Mealie container..."
docker start "$CONTAINER_NAME"

echo "Mealie backup complete. Files saved to $BACKUP_TARGET_DIR"
