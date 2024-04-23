#!/bin/bash

monitor_log() {
    trap 'cleanup' INT  # Trap Ctrl+C to stop monitoring
    tail -n 0 -f "$log_file" | while read -r line; do
        analyze_log "$line"
    done
}


analyze_log() {
    local log_entry="$1"
    if [[ $log_entry == *"ERROR"* ]]; then
        ((error_count++))
    fi
    if [[ $log_entry == *"HTTP ERROR"* ]]; then
        ((http_error_count++))
    fi
    # Display summary report
    echo "=== Log Analysis Summary ==="
    echo "Total ERRORs: $error_count"
    echo "Total HTTP ERRORs: $http_error_count"
}

cleanup() {
    echo "Stopping log monitoring..."
    exit 0
}

main() {
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <log_file>"
        exit 1
    fi

    log_file="$1"
    error_count=0
    http_error_count=0

    echo "Starting log monitoring for '$log_file'..."

    monitor_log
}

main "$@"
