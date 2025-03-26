#!/bin/bash

# Ensure required environment variables are set
if [[ -z "$INTERVAL" || -z "$BLOCKCHAIN_RPC_ENDPOINT" || -z "$STORAGE_LOG_CONTRACT_ADDRESS" || -z "$STORAGE_MINER_PRIVATE_KEY" || -z "$STORAGE_NODE_RPC_ENDPOINT" ]]; then
    echo "One or more required environment variables are not set. Exiting."
    exit 1
fi

while true; do
    # Generate a random FILE_SIZE between 2000 and 8000
    FILE_SIZE=$(( RANDOM % 6001 + 2000 ))
    INPUT_FILE_PATH=/home/zerog/test.txt
    echo "File Size is $FILE_SIZE"
    # Remove the input file if it exists
    if [ -f "$INPUT_FILE_PATH" ]; then
        rm "$INPUT_FILE_PATH"
    fi

    # Generate a file with the specified size
    0g-storage-client gen --size $FILE_SIZE --file $INPUT_FILE_PATH

    # Upload the file to the blockchain storage
    0g-storage-client upload \
    --url $BLOCKCHAIN_RPC_ENDPOINT \
    --key $STORAGE_MINER_PRIVATE_KEY \
    --node $STORAGE_NODE_RPC_ENDPOINT \
    --file $INPUT_FILE_PATH \
    --gas-limit 25000000 \
    --finality-required true

    # Wait for the specified interval before the next iteration
    echo "Sleeping for $INTERVAL Seconds..."
    sleep "$INTERVAL"
done
