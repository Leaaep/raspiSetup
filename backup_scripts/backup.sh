#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

if [ $# -lt 1 ]; then
    echo "Usage: $0 <app_name>"
    exit 1
fi

app_name=$1

ENV_FILE="$SCRIPT_DIR/.env.$app_name"
if [ ! -f "$ENV_FILE" ]; then
    echo "$ENV_FILE not found!"
    exit 1
fi
source "$ENV_FILE"

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
