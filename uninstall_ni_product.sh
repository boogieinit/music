#!/bin/bash

# Script to uninstall Native Instruments products
# Usage: ./uninstall_ni_product.sh "Product Name"
#
# This script is designed for macOS only.
#
# IMPORTANT: You MUST set the LIBRARY_PATH variable below before running this script.
# This should point to your Native Instruments library folder.
# Example: LIBRARY_PATH="/Users/Shared/Native Instruments"



###########################################################################
# CONFIGURATION - YOU MUST SET THIS BEFORE RUNNING THE SCRIPT
###########################################################################

# Set the path to your Native Instruments library folder
# This must be set before running the script
LIBRARY_PATH="/Volumes/Studio/Libraries/Native Instruments"




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
    echo "You must edit this script and set the LIBRARY_PATH variable before running it."
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

echo "Preparing to uninstall '$PRODUCT_NAME'..."
echo "Using library path: $LIBRARY_PATH"
echo

# Create an array to store paths that exist and will be deleted
declare -a PATHS_TO_DELETE

# Function to check if a file/directory exists and add it to the delete list
check_path() {
    local path="$1"
    if [ -e "$path" ]; then
        PATHS_TO_DELETE+=("$path")
        echo "Found: $path"
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
                PATHS_TO_DELETE+=("$dir")
                echo "Found library: $dir"
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
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo "Operation canceled."
    exit 0
fi

# Delete the files/directories
echo
echo "Deleting files and directories..."
DELETED_COUNT=0
ERROR_COUNT=0

for path in "${PATHS_TO_DELETE[@]}"; do
    echo -n "Deleting $path... "
    
    # Determine if sudo is needed (for system directories)
    if [[ "$path" == "/Library/"* || "$path" == "/Applications/"* || "$path" == "/Volumes/"* ]]; then
        sudo rm -rf "$path" 2>/dev/null
    else
        rm -rf "$path" 2>/dev/null
    fi
    
    # Check if deletion was successful
    if [ $? -eq 0 ]; then
        echo "Done"
        DELETED_COUNT=$((DELETED_COUNT + 1))
    else
        echo "Error"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
done

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

exit 0
