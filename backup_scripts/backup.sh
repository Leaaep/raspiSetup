#!/bin/bash
set -euo pipefail

while true; do
    echo ""
    echo "Which app would you like to backup?"
    echo "[1] Mealie [2] Forgejo"
    read -p "Enter number: " input

    if [[ "$input" =~ ^[0-9]+$ ]]; then
        if (( input >= 1 && input <= 2 )); then
            break
        else
            echo "This number is not available"
        fi
    else
        echo "Invalid input: not a number."
    fi
done

case $input in
    1) app_name="mealie" ;;
    2) app_name="forgejo" ;;
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
zip -r "$BACKUP_TARGET_DIR/$FILE_NAME" "$BACKUP_SRC_DIR"

echo "Restarting $app_name container..."
docker start "$CONTAINER_NAME"

echo "$app_name backup complete. Files saved to $BACKUP_TARGET_DIR/$FILE_NAME"
