#!/bin/bash

# To be run from your Devices folder (ex: AppData\Roaming\Garmin\ConnectIQ\Devices)
# Use the result in genResources.py

# Print CSV header
echo "deviceId,launcherIcon.height,launcherIcon.width"

# Loop through each folder in the current directory
for folder in */; do
    # Check if the compiler.json file exists in the folder
    if [ -f "$folder/compiler.json" ]; then
        # Read the compiler.json file and extract the required information
        deviceId=$(jq -r '.deviceId' "$folder/compiler.json")
        height=$(jq -r '.launcherIcon.height' "$folder/compiler.json")
        width=$(jq -r '.launcherIcon.width' "$folder/compiler.json")

        # Output the extracted information in CSV format
        echo "$deviceId,$height,$width"
    fi
done
