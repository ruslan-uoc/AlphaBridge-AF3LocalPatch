#!/bin/bash

# Define paths
AFSCONV_DIR="AF3input/AFSConv"
OUTPUT_DIR="AlphaBridge_output"
PYTHON_SCRIPT="./define_interfaces.py"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Iterate over each subdirectory inside AFSConv
for SUBDIR in "$AFSCONV_DIR"/*; do
    # Ensure it's a directory
    if [ -d "$SUBDIR" ]; then
        # Extract the directory name (without the path)
        DIR_NAME=$(basename "$SUBDIR")

        echo "Processing directory: $DIR_NAME"

        # Run the Python script with the correct argument format
        python3 "$PYTHON_SCRIPT" -i "$SUBDIR"

        # Check if the Python script successfully created the AlphaBridge directory
        if [ -d "$SUBDIR/AlphaBridge" ]; then
            # Copy the AlphaBridge directory to the output directory, renaming it
            cp -r "$SUBDIR/AlphaBridge" "$OUTPUT_DIR/$DIR_NAME"
            echo "Copied AlphaBridge to $OUTPUT_DIR/$DIR_NAME"
        else
            echo "Warning: AlphaBridge directory not found in $SUBDIR"
        fi
    fi
done

echo "Processing completed for all directories."
