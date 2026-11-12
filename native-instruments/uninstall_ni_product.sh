#!/bin/bash
# SPDX-License-Identifier: MIT

# Script to uninstall Native Instruments products
# Usage: ./uninstall_ni_product.sh "Product Name"
#
# This script is designed for macOS only.
#
# Every run is recorded in ~/Library/Logs/uninstall_ni_product/uninstall_ni_product.log
# (what was found, your answer, and what was deleted), so you can review it later.
#
# IMPORTANT: You MUST set the LIBRARY_PATH variable below before running this script.
# This should point to your Native Instruments library folder.
# Example: LIBRARY_PATH="/Users/Shared/Native Instruments"



###########################################################################
# CONFIGURATION - YOU MUST SET THIS BEFORE RUNNING THE SCRIPT
###########################################################################

# Set the path to your Native Instruments library folder
# This must be set before running the script. It is left empty on purpose, and the script
# stops with an error until you fill it in.
LIBRARY_PATH=""




###########################################################################
# END OF CONFIGURATION
###########################################################################

# Check if running on macOS
if [ "$(uname)" != "Darwin" ]; then
    echo "Error: This script can only be run on macOS."
    echo "Native Instruments products on other operating systems require different uninstallation methods."
    exit 1
fi

# Check if LIBRARY_PATH is set
if [ -z "$LIBRARY_PATH" ]; then
    echo "ERROR: LIBRARY_PATH is not set."
    echo "You must set it before running this script. Nothing has been deleted."
    echo
    echo "Open this script in a text editor ($0), find the LIBRARY_PATH line near the top,"
    echo "and set it to the folder that holds your Native Instruments libraries, then run it again."
    echo "Example: LIBRARY_PATH=\"/Users/Shared/Native Instruments\""
    exit 1
fi


# Check if a product name was provided
if [ $# -eq 0 ]; then
    echo "Error: No product name provided."
    echo "Usage: $0 \"Product Name\""
    exit 1
fi

# Store the product name
PRODUCT_NAME="$1"
USERNAME="$USER"

# Validate the product name. An empty or very short name would match almost
# everything in the library folder, and a name containing "/" could point
# outside the folders this script is meant to look in.
NAME_NO_SPACES="${PRODUCT_NAME//[[:space:]]/}"
if [ ${#NAME_NO_SPACES} -lt 3 ]; then
    echo "Error: The product name must be at least 3 characters (not counting spaces)."
    echo "An empty or very short name could match far more files than intended."
    exit 1
fi
if [[ "$PRODUCT_NAME" == */* ]]; then
    echo "Error: The product name must not contain a '/' character."
    exit 1
fi

# Set up the log: a record of every run, so you can look back later at what was deleted.
# The script will not delete anything unless it can write this record first.
LOG_DIR="$HOME/Library/Logs/uninstall_ni_product"
LOG_FILE="$LOG_DIR/uninstall_ni_product.log"
if ! mkdir -p "$LOG_DIR" 2>/dev/null || ! touch "$LOG_FILE" 2>/dev/null; then
    echo "Error: Cannot write the log file at $LOG_FILE"
    echo "This script will not delete anything without keeping a record. Nothing has been deleted."
    exit 1
fi

# Add a line to the log, with the date and time
log() {
    printf '%s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOG_FILE"
}

log "===== Run started: product '$PRODUCT_NAME' ====="
log "User: $USERNAME   Library path: $LIBRARY_PATH"

echo "Preparing to uninstall '$PRODUCT_NAME'..."
echo "Using library path: $LIBRARY_PATH"
echo "A record of this run is being saved to: $LOG_FILE"
echo

# Create an array to store paths that exist and will be deleted
declare -a PATHS_TO_DELETE

# Print the size of a file or folder in a readable form (for the log)
item_size() {
    local size
    size=$(du -sk "$1" 2>/dev/null | awk '{ kb = $1
        if (kb >= 1048576) printf "%.1f GB", kb / 1048576
        else if (kb >= 1024) printf "%.1f MB", kb / 1024
        else printf "%d KB", kb }')
    echo "${size:-size unknown}"
}

# Add a path to the delete list, once, and record it in the log
add_path() {
    local path="$1" label="$2" existing
    for existing in "${PATHS_TO_DELETE[@]}"; do
        if [ "$existing" = "$path" ]; then
            return 0
        fi
    done
    PATHS_TO_DELETE+=("$path")
    echo "$label $path"
    log "FOUND      $path  ($(item_size "$path"))"
}

# Function to check if a file/directory exists and add it to the delete list
check_path() {
    local path="$1"
    if [ -e "$path" ]; then
        add_path "$path" "Found:"
    fi
}

# Function to check for library directories that might contain the product name
check_library_path() {
    local base_path="$1"
    local product="$2"
    
    if [ -d "$base_path" ]; then
        # Look for directories in the base path that contain the product name
        for dir in "$base_path"/*; do
            if [ -d "$dir" ] && [[ "$(basename "$dir")" == *"$product"* ]]; then
                add_path "$dir" "Found library:"
            fi
        done
    fi
}

# Check all possible locations
echo "Checking for '$PRODUCT_NAME' files and directories..."
check_path "/Applications/Native Instruments/$PRODUCT_NAME"
check_path "/Library/Preferences/com.native-instruments.$PRODUCT_NAME.plist"
check_path "/Library/Audio/Plug-ins/Components/$PRODUCT_NAME.component"
check_path "/Library/Audio/Plug-ins/VST/$PRODUCT_NAME.vst"
check_path "/Library/Application Support/Digidesign/Plug-ins/$PRODUCT_NAME.dpm"
check_path "/Library/Application Support/Avid/Audio/Plug-ins/$PRODUCT_NAME.aaxplugin"
check_path "/Library/Application Support/Native Instruments/$PRODUCT_NAME"
check_path "/Library/Application Support/Native Instruments/Service Center/$PRODUCT_NAME.xml"
check_path "/Users/Shared/Native Instruments/installed_products/$PRODUCT_NAME.json"
check_path "/Users/$USERNAME/Library/Preferences/com.native-instruments.$PRODUCT_NAME.plist"
check_path "/Users/$USERNAME/Library/Application Support/Native Instruments/$PRODUCT_NAME"

# Check the configured library path
echo "Checking for content in the library path..."
check_path "$LIBRARY_PATH/$PRODUCT_NAME"
check_library_path "$LIBRARY_PATH" "$PRODUCT_NAME"

# Check if any paths were found
if [ ${#PATHS_TO_DELETE[@]} -eq 0 ]; then
    echo "No files or directories related to '$PRODUCT_NAME' were found."
    log "RESULT     nothing found for '$PRODUCT_NAME'; nothing was deleted"
    log "===== Run finished ====="
    exit 0
fi

# Display summary and ask for confirmation
echo
echo "The following files/directories will be deleted:"
for path in "${PATHS_TO_DELETE[@]}"; do
    echo "- $path"
done

echo
read -p "Do you want to proceed with deletion? (y/n): " CONFIRM
log "CONFIRM    asked to delete ${#PATHS_TO_DELETE[@]} item(s); you answered '$CONFIRM'"
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo "Operation canceled."
    log "RESULT     canceled; nothing was deleted"
    log "===== Run finished ====="
    exit 0
fi

# Delete the files/directories
echo
echo "Deleting files and directories..."
DELETED_COUNT=0
ERROR_COUNT=0

for path in "${PATHS_TO_DELETE[@]}"; do
    echo -n "Deleting $path... "
    log "DELETING   $path"
    
    # Determine if sudo is needed (for system directories)
    if [[ "$path" == "/Library/"* || "$path" == "/Applications/"* || "$path" == "/Volumes/"* ]]; then
        sudo rm -rf "$path" 2>/dev/null
    else
        rm -rf "$path" 2>/dev/null
    fi
    
    # Check if deletion was successful
    rm_status=$?
    if [ $rm_status -eq 0 ]; then
        echo "Done"
        log "DELETED    $path"
        DELETED_COUNT=$((DELETED_COUNT + 1))
    else
        echo "Error"
        log "FAILED     $path  (error code $rm_status)"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
done

log "SUMMARY    $DELETED_COUNT of ${#PATHS_TO_DELETE[@]} item(s) deleted, $ERROR_COUNT failed"
log "===== Run finished ====="

# Display summary
echo
echo "Uninstallation summary:"
echo "- Files/directories successfully deleted: $DELETED_COUNT"
if [ $ERROR_COUNT -gt 0 ]; then
    echo "- Errors encountered: $ERROR_COUNT"
    echo "  (You may need to run this script with sudo for system directories)"
fi

if [ $DELETED_COUNT -eq ${#PATHS_TO_DELETE[@]} ]; then
    echo
    echo "'$PRODUCT_NAME' has been successfully uninstalled."
else
    echo
    echo "Uninstallation of '$PRODUCT_NAME' was partially completed."
    echo "You may need to run this script with administrative privileges to complete the process."
fi

echo
echo "A record of everything this run deleted is saved in: $LOG_FILE"

exit 0
