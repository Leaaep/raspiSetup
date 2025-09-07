#!/bin/bash
set -euo pipefail

if [ ! -f ".env.cleanup" ]; then
    echo ".env.cleanup not found!"
    exit 1
fi
source .env.cleanup

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
