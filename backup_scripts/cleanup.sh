#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

ENV_FILE="$SCRIPT_DIR/.env.cleanup"
if [ ! -f "$ENV_FILE" ]; then
    echo "$ENV_FILE not found!"
    exit 1
fi
source "$ENV_FILE"

RETENTION_DAYS=${RETENTION_DAYS:-14}

echo "Cleaning up backup files older than $RETENTION_DAYS days in $CLEANUP_TARGET_PATH..."

for file in "$CLEANUP_TARGET_PATH"/*-dump-*.zip; do
    [ -e "$file" ] || continue
    filename=$(basename "$file")
    date_part=$(echo "$filename" | grep -oP '\d{4}-\d{2}-\d{2}')

    if [ -z "$date_part" ]; then
        echo "Skipping $filename: no date found"
        continue
    fi

    file_date_sec=$(date -d "$date_part" +%s)
    current_date_sec=$(date +%s)
    age_days=$(( (current_date_sec - file_date_sec) / 86400 ))

    if [ "$age_days" -gt "$RETENTION_DAYS" ]; then
        echo "Deleting $filename (age: $age_days days)"
        rm -f "$file"
    fi
done

echo "Cleanup complete."
