#!/bin/bash
set -euo pipefail

# Load Mealie env
if [ ! -f .env.mealie ]; then
    echo ".env.mealie not found!"
    exit 1
fi
source .env.mealie

echo "Unzipping forgejo dump zip"
unzip "$RESTORE_SRC_PATH/forgejo-dump-*.zip"

echo "Stopping forgejo container..."
docker stop "$CONTAINER_NAME"

cp -rf "$RESTORE_SRC_PATH/mealie_data" "$RESTORE_TARGET_PATH"

echo "Starting forgejo container"
docker start "$CONTAINER_NAME"

echo "Restore complete"
