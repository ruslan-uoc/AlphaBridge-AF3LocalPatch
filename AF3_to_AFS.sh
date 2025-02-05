#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <seed_number> | best"
    exit 1
fi

SEED_OPTION=$1
INPUT_DIR="AF3input"
OUTPUT_PARENT_DIR="AF3input/AFSConv"
PYTHON_SCRIPT="./af3toafsupd.py"

# Ensure output parent directory exists
mkdir -p "$OUTPUT_PARENT_DIR"

# Iterate over subdirectories in AF3input, excluding AFSConv
for ORIGINAL_DIR in "$INPUT_DIR"/*/; do
    DIR_NAME=$(basename "$ORIGINAL_DIR")

    # Skip AFSConv directory
    if [ "$DIR_NAME" == "AFSConv" ]; then
        continue
    fi

    # Determine the seed number
    if [ "$SEED_OPTION" == "best" ]; then
        RANKING_FILE="$ORIGINAL_DIR/ranking_scores.csv"
        if [ ! -f "$RANKING_FILE" ]; then
            echo "Warning: ranking_scores.csv not found in $DIR_NAME, skipping."
            continue
        fi

        # Find the seed with the highest ranking_score
        BEST_SEED=$(awk -F',' 'NR>1 {if ($3 > max) {max=$3; best_seed=$1}} END {print best_seed}' "$RANKING_FILE")

        if [ -z "$BEST_SEED" ]; then
            echo "Error: Could not determine best seed for $DIR_NAME, skipping."
            continue
        fi

        echo "Best seed for $DIR_NAME: $BEST_SEED"
        SEED_NUMBER=$BEST_SEED
    else
        SEED_NUMBER=$SEED_OPTION
    fi

    NEW_DIR="${OUTPUT_PARENT_DIR}/AFS_${DIR_NAME}"
    mkdir -p "$NEW_DIR"

    echo "Processing directory: $DIR_NAME -> $NEW_DIR (Seed: $SEED_NUMBER)"

    # Copy and rename files from seed directories
    for SAMPLE_DIR in "$ORIGINAL_DIR/seed-${SEED_NUMBER}_sample-"*; do
        if [ -d "$SAMPLE_DIR" ]; then
            SAMPLE_NUM=$(basename "$SAMPLE_DIR" | sed -E 's/.*sample-([0-9]+)/\1/')

            # Rename and copy files
            cp "$SAMPLE_DIR/confidences.json" "$NEW_DIR/fold_${DIR_NAME}_full_data_${SAMPLE_NUM}.json" 2>/dev/null
            cp "$SAMPLE_DIR/model.cif" "$NEW_DIR/fold_${DIR_NAME}_model_${SAMPLE_NUM}.cif" 2>/dev/null
            cp "$SAMPLE_DIR/summary_confidences.json" "$NEW_DIR/fold_${DIR_NAME}_summary_confidences_${SAMPLE_NUM}.json" 2>/dev/null
        fi
    done

    # Copy additional required files
    cp "$ORIGINAL_DIR/TERMS_OF_USE.md" "$NEW_DIR/" 2>/dev/null
    cp "$ORIGINAL_DIR"/*_data.json "$NEW_DIR/" 2>/dev/null

    # Find the _data.json file in the new directory and run the Python script
    for DATA_FILE in "$NEW_DIR"/*_data.json; do
        if [ -f "$DATA_FILE" ]; then
            echo "Running Python script on $DATA_FILE"
            python3 "$PYTHON_SCRIPT" "$DATA_FILE"

            # Check if the Python script ran successfully
            if [ $? -eq 0 ]; then
                echo "Python script executed successfully. Removing original file."
                rm -f "$DATA_FILE"
            else
                echo "Error: Python script failed to run on $DATA_FILE"
            fi
        fi
    done

    echo "Finished processing $DIR_NAME"
done

echo "All directories processed successfully."

