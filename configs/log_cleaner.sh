#!/bin/bash

# This script serve as log rotation, it removes files older than 5 days
remove_old_files() {
    directory="$1"

    cd "$directory" || return 1

    # Find files older than 5 days except empty.log and remove them
    find . -maxdepth 1 -type f ! -name "empty.log" -mtime +5 -exec rm {} \;
}

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

while true
do
    remove_old_files "$1"

    # Sleep for 23 hours
    sleep 82800
done
