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

if [ ! -f ".env.$app_name" ]; then
    echo ".env.$app_name not found!"
    exit 1
fi
source .env.$app_name


echo "Stopping $app_name container..."
docker stop "$CONTAINER_NAME"

echo "Deleting old data..."
rm -rf "$RESTORE_TARGET_PATH/mealie_data"

echo "Loading backup data..."
unzip "$RESTORE_SRC_PATH/mealie-dump-*.zip" -d "$RESTORE_TARGET_PATH/"

echo "Restarting $app_name container..."
docker start "$CONTAINER_NAME"

echo "Restore completed :)"
