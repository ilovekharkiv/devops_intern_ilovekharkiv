#!/bin/sh

# Specify the name of the directory for backup
BACKUP_DIR="./backup"

# Check whether the directory exists
if [ ! -d "$BACKUP_DIR" ]; then
  # If the directory does not exist, create it
  mkdir -p "$BACKUP_DIR"
  echo "Directory $BACKUP_DIR has been created."
else
  echo "Directory $BACKUP_DIR is laready exists."
fi
  
# Generate a backup version number (1.0.0)

VERSIONS_JSON=$1
echo "$VERSIONS_JSON"

# Version increment
NEW_VERSION=$(echo "$VERSIONS_JSON" | awk -F. -v OFS=. '{ $NF=sprintf("%d",$NF+1); print }')

# Archive the repository (excluding 'backup' folder)
ARCHIVE_NAME="devops_internship_${NEW_VERSION}"
tar czvf "$ARCHIVE_NAME.tar.gz" --exclude="/backup" .

# Move the archived repository to the 'backup' folder
mv "$ARCHIVE_NAME.tar.gz" "$BACKUP_DIR/"

# Update the version file with the new version number
echo "$NEW_VERSION" > "$VERSIONS_JSON"

# Create versions.json if it doesn't exist
VERSIONS_JSON_NEW="${BACKUP_DIR}/versions.json"
if [ ! -f "$VERSIONS_JSON_NEW" ]; then
  echo '[]' > "$VERSIONS_JSON_NEW"
fi

# Calculate the size of the archived file
ARCHIVE_SIZE=$(du -h "${BACKUP_DIR}/${ARCHIVE_NAME}.tar.gz" | cut -f1)

# Create JSON entry for the new backup
BACKUP_INFO='{
  "version": "'"$NEW_VERSION"'",
  "date": "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",
  "size": "'"$ARCHIVE_SIZE"'",
  "filename": "'"$ARCHIVE_NAME.tar.gz"'"
}'

# Append the JSON entry to versions.json
jq --argjson new_entry "$BACKUP_INFO" '. += [$new_entry]' "$VERSIONS_JSON_NEW" > "${VERSIONS_JSON_NEW}.new"
mv "${VERSIONS_JSON_NEW}.new" "$VERSIONS_JSON_NEW"