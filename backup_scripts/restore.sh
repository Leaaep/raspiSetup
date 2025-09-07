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