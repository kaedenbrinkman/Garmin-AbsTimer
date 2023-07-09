#!/bin/bash

# Check if the CSV file argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide the path to the CSV file."
    exit 1
fi

# Read the CSV file line by line, skipping the header
tail -n +2 "$1" | while IFS=',' read -r deviceId _ _; do
    # Create the folder and the drawables subfolder
    folderName="resources-$deviceId"
    mkdir -p "$folderName/drawables"
    cp -r resources/drawables/* "$folderName/drawables/"
done
