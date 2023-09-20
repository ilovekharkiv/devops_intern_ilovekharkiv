#!/bin/bash

# Source variables from .env file
if [ -f .env ]; then
  source .env
fi

# Check if the MAX_BACKUPS environment variable is set and is a valid number
if [[ -n "$MAX_BACKUPS" && "$MAX_BACKUPS" =~ ^[0-9]+$ ]]; then
  MAX_BACKUPS=$MAX_BACKUPS
else
  MAX_BACKUPS=0
fi

# Check if the RUN_AMOUNT environment variable is set and is a valid number
if [[ -n "$RUN_AMOUNT" && "$RUN_AMOUNT" =~ ^[0-9]+$ ]]; then
  RUN_AMOUNT=$RUN_AMOUNT
else
  RUN_AMOUNT=1
fi

# Ensure the backup directory exists
mkdir -p "$BACKUP_DIR"

# Loop to execute the script RUN_AMOUNT times
for ((i=1; i<=$RUN_AMOUNT; i++)); do

  # Get the current date in the desired format
  CURRENT_DATE=$(date +'%d.%m.%Y')

  # Determine the version number by counting existing backups
  if [[ ! -f "$BACKUP_DIR/versions.json" ]]; then
    VERSION="1.0.0"
  else
    LAST_VERSION=$(jq -r '.[-1].version' "$BACKUP_DIR/versions.json")
    LAST_VERSION=${LAST_VERSION:-"0.0.0"}
    
    # Increment the version number
    VERSION_ARRAY=(${LAST_VERSION//./ })
    MAJOR=${VERSION_ARRAY[0]}
    MINOR=${VERSION_ARRAY[1]}
    PATCH=${VERSION_ARRAY[2]}
    
    PATCH=$((PATCH + 1))
    VERSION="$MAJOR.$MINOR.$PATCH"
  fi

  # Clone the repository
  REPO_DIR="$BACKUP_DIR/$REPO_NAME"
  if [[ ! -d "$REPO_DIR" ]]; then
    git clone "$REPO_SSH_URL" "$REPO_DIR"
  else
    # If the repository already exists, update it
    cd "$REPO_DIR" || exit
    git pull
    cd -
  fi

  # Archive the repository and delete it
  ARCHIVE_FILENAME="devops_internship_$VERSION"
  ARCHIVE_PATH="$BACKUP_DIR/$ARCHIVE_FILENAME.tar.gz"
  tar -czf "$ARCHIVE_PATH" -C "$REPO_DIR" .
  rm -rf backup/$REPO_NAME

  # Write backup information to versions.json
  BACKUP_INFO='{
    "version": "'$VERSION'",
    "date": "'$CURRENT_DATE'",
    "size": '$(stat -c %s "$ARCHIVE_PATH")',
    "filename": "'$ARCHIVE_FILENAME'"
  }'

  if [[ ! -f "$BACKUP_DIR/versions.json" ]]; then
    echo "[$BACKUP_INFO]" > "$BACKUP_DIR/versions.json"
  else
    jq ". += [$BACKUP_INFO]" "$BACKUP_DIR/versions.json" > "$BACKUP_DIR/versions.json.tmp" && mv "$BACKUP_DIR/versions.json.tmp" "$BACKUP_DIR/versions.json"
  fi

  # Remove old backups if the MAX_BACKUPS environment variable is set
  if [[ $MAX_BACKUPS -gt 0 ]]; then
    while [[ $(jq 'length' "$BACKUP_DIR/versions.json") -gt $MAX_BACKUPS ]]; do
      OLDEST_VERSION=$(jq -r '.[0].version' "$BACKUP_DIR/versions.json")
      jq 'del(.[0])' "$BACKUP_DIR/versions.json" > "$BACKUP_DIR/versions.json.tmp" && mv "$BACKUP_DIR/versions.json.tmp" "$BACKUP_DIR/versions.json"
      rm "$BACKUP_DIR/devops_internship_${OLDEST_VERSION}.tar.gz"
    done
  fi

  echo "Backup completed: $ARCHIVE_FILENAME"

done
