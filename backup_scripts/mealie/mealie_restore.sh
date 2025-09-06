#!/bin/bash
set -euo pipefail

# Load Mealie env
if [ ! -f .env.mealie ]; then
    echo ".env.mealie not found!"
    exit 1
fi
source .env.mealie

echo "Unzipping Mealie dump zip"
unzip "$RESTORE_SRC_PATH/forgejo-dump-*.zip"

echo "Stopping Mealie container..."
docker stop "$CONTAINER_NAME"

echo "Deleting old data..."
rm -rf "$RESTORE_TARGET_PATH/mealie_data"

echo "Loading backup data..."
cp -rf "$RESTORE_SRC_PATH/mealie_data" "$RESTORE_TARGET_PATH"

echo "Restarting Mealie container..."
docker start "$CONTAINER_NAME"

echo "Restore completed :)"
