#!/bin/bash

# Ansible VM Shutdown Script
# Usage: ./shutdown_script.sh [option]

echo "=== Ansible VM Shutdown Script ==="
echo ""

# Check if ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "Error: Ansible is not installed or not in PATH"
    exit 1
fi

# Function to display usage
show_usage() {
    echo "Usage: $0 [option]"
    echo ""
    echo "Options:"
    echo "  basic     - Basic shutdown (immediate)"
    echo "  graceful  - Graceful shutdown (60 second delay)"
    echo "  force     - Force shutdown (emergency)"
    echo "  all       - Shutdown all VMs (basic)"
    echo "  windows   - Shutdown only Windows VMs"
    echo "  linux     - Shutdown only Linux VMs"
    echo "  macos     - Shutdown only macOS VMs"
    echo "  help      - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 basic"
    echo "  $0 graceful"
    echo "  $0 windows"
    echo "  $0 linux"
}

# Function to run basic shutdown
run_basic_shutdown() {
    echo "Running basic shutdown for all VMs..."
    ansible-playbook -i hosts shutdown_vms.yml
}

# Function to run graceful shutdown
run_graceful_shutdown() {
    echo "Running graceful shutdown for all VMs..."
    ansible-playbook -i hosts shutdown_vms_advanced.yml
}

# Function to run force shutdown
run_force_shutdown() {
    echo "WARNING: This will force shutdown all VMs immediately!"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Running force shutdown..."
        ansible-playbook -i hosts shutdown_vms_advanced.yml -e "force_shutdown=true"
    else
        echo "Force shutdown cancelled."
        exit 0
    fi
}

# Function to shutdown specific OS group
shutdown_os_group() {
    local os_group=$1
    echo "Shutting down $os_group VMs..."
    ansible-playbook -i hosts shutdown_vms.yml --limit $os_group
}

# Main script logic
case "${1:-help}" in
    "basic")
        run_basic_shutdown
        ;;
    "graceful")
        run_graceful_shutdown
        ;;
    "force")
        run_force_shutdown
        ;;
    "all")
        run_basic_shutdown
        ;;
    "windows")
        shutdown_os_group "windows"
        ;;
    "linux")
        shutdown_os_group "linux"
        ;;
    "macos")
        shutdown_os_group "macOS"
        ;;
    "help"|*)
        show_usage
        ;;
esac

echo ""
echo "Shutdown operation completed." 