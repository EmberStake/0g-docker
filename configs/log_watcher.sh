#!/bin/bash
# This script is a workaround to print process logs in container logs
tail_latest_log() {
  log_dir="$1"
  latest_log=$(ls -t ${log_dir}/* | head -n 1)
  tail -f "$latest_log"
}

log_dir="$1"
tail_latest_log $log_dir &

# Monitor the log directory for new log files
inotifywait -m -e create --format '%w%f' "${log_dir}" | while read new_log
do
  # Kill the current tail process
  pkill -P $$ tail

  # Tail the new log file
  tail -f "$new_log" &
done
