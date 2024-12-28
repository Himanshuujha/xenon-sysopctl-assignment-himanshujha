#!/bin/bash

# Command version
VERSION="v0.1.0"

# Function to show help
show_help() {
    echo "Options:"
    echo "  service list                List all active services."
    echo "  service start <service>     Start a service."
    echo "  service stop <service>      Stop a service."
    echo "  system load                 View current system load."
    echo "  disk usage                  Check disk usage."
    echo "  process monitor             Monitor system processes."
    echo "  logs analyze                Analyze system logs."
    echo "  backup <path>               Backup system files."
    echo "  --help                      Show this help message."
    echo "  --version                   Show version information."
}

# Function to show version
show_version() {
    echo "sysopctl $VERSION"
}

# Function to display an error message
error_message() {
    echo "Error: $1" >&2
}

# Function to list running services
list_services() {
    if systemctl list-units --type=service --state=running; then
        echo "Listed active services successfully."
    else
        error_message "Failed to list active services."
    fi
}

# Function to show system load
show_load() {
    if uptime; then
        echo "System load displayed successfully."
    else
        error_message "Failed to display system load."
    fi
}

# Function to start a service
start_service() {
    local service="$1"
    [[ -z $service ]] && error_message "Service name is required." && return 1

    if systemctl start "$service"; then
        echo "Service '$service' started successfully."
    else
        error_message "Failed to start service '$service'."
    fi
}

# Function to stop a service
stop_service() {
    local service="$1"
    [[ -z $service ]] && error_message "Service name is required." && return 1

    if systemctl stop "$service"; then
        echo "Service '$service' stopped successfully."
    else
        error_message "Failed to stop service '$service'."
    fi
}

# Function to check disk usage
check_disk_usage() {
    if df -h; then
        echo "Disk usage displayed successfully."
    else
        error_message "Failed to display disk usage."
    fi
}

# Function to monitor processes
monitor_processes() {
    if top; then
        echo "Process monitor started successfully."
    else
        error_message "Failed to start process monitor."
    fi
}

# Function to analyze logs
analyze_logs() {
    if journalctl -p 3 -b; then
        echo "Logs analyzed successfully."
    else
        error_message "Failed to analyze logs."
    fi
}

# Function to backup files
backup_files() {
    local source_path="$1"
    [[ -z $source_path ]] && error_message "Source path is required for backup." && return 1

    if rsync -av --progress "$source_path" /path/to/backup/; then
        echo "Backup of '$source_path' completed successfully."
    else
        error_message "Failed to backup '$source_path'."
    fi
}

# Main script logic
case "$1" in
    service)
        case "$2" in
            list) list_services ;;
            start) start_service "$3" ;;
            stop) stop_service "$3" ;;
            *) error_message "Invalid service command. Use --help for usage." ;;
        esac
        ;;
    system) show_load ;;
    disk) check_disk_usage ;;
    process) monitor_processes ;;
    logs) analyze_logs ;;
    backup) backup_files "$2" ;;
    --help) show_help ;;
    --version) show_version ;;
    *) error_message "Invalid command. Use --help for usage." ;;
esac