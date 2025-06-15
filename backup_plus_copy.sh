#!/bin/bash

# Script to copy a target file to a destination directory.
# If the file already exists in the destination, a dated backup
# with a .bkup extension will be created before the new file is copied.

# Usage: ./copy_with_backup.sh <source_file> <destination_directory>

# --- Configuration ---
# Get current date and time for backup filename
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# --- Functions ---

# Function to display script usage
usage() {
    echo "Usage: $0 <source_file> <destination_directory> [new_filename]"
    echo ""
    echo "  <source_file>          : The path to the file you want to copy."
    echo ""
    echo "  <destination_directory> : The directory where the file should be copied."
    echo ""
    echo "  [new_filename]          : (Optional) The new name for the copied file."
    echo ""
    exit 1
}

# --- Main Script Logic ---

# Check if correct number of arguments are provided
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    echo "Error: Incorrect number of arguments."
    echo ""
    usage
fi

SOURCE_FILE="$1"
DEST_DIR="$2"
NEW_FILENAME="$3"

# Validate source file existence
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Source file '$SOURCE_FILE' does not exist."
    echo ""
    exit 1
fi

# Validate destination directory existence
if [ ! -d "$DEST_DIR" ]; then
    echo "Error: Destination directory '$DEST_DIR' does not exist."
    echo ""
    echo "Please create the directory first or provide a valid path."
    echo ""
    exit 1
fi

# Get the base name of the source file
FILENAME=$(basename "$SOURCE_FILE")
DEST_FILE="${DEST_DIR}/${NEW_FILENAME:-$FILENAME}"

echo "Attempting to copy '$SOURCE_FILE' to '$DEST_DIR'..."
echo ""

# Check if the destination file already exists
if [ -f "$DEST_FILE" ]; then
    BACKUP_FILE="${DEST_FILE}.${TIMESTAMP}.bkup"
    echo "Existing file found: '$DEST_FILE'."
    echo ""
    echo "Creating backup: '$BACKUP_FILE'..."
    echo ""
    cp "$DEST_FILE" "$BACKUP_FILE"
    if [ $? -eq 0 ]; then
        echo "Backup created successfully."
        echo ""
    else
        echo "Error: Failed to create backup of '$DEST_FILE'."
        echo ""
        exit 1
    fi
fi

# Copy the source file to the destination
cp "$SOURCE_FILE" "$DEST_FILE"

# Check if the copy operation was successful
if [ $? -eq 0 ]; then
    echo "Successfully copied '$SOURCE_FILE' to '$DEST_FILE'."
    echo ""
else
    echo "Error: Failed to copy '$SOURCE_FILE' to '$DEST_FILE'."
    echo ""
    exit 1
fi

exit 0
