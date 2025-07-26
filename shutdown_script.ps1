# Ansible VM Shutdown Script for PowerShell
# Usage: .\shutdown_script.ps1 [option]

param(
    [Parameter(Position=0)]
    [string]$Option = "help"
)

Write-Host "=== Ansible VM Shutdown Script ===" -ForegroundColor Green
Write-Host ""

# Check if ansible is installed
try {
    $null = Get-Command ansible -ErrorAction Stop
} catch {
    Write-Host "Error: Ansible is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Function to display usage
function Show-Usage {
    Write-Host "Usage: .\$($MyInvocation.MyCommand.Name) [option]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Options:" -ForegroundColor Cyan
    Write-Host "  basic     - Basic shutdown (immediate)" -ForegroundColor White
    Write-Host "  graceful  - Graceful shutdown (60 second delay)" -ForegroundColor White
    Write-Host "  force     - Force shutdown (emergency)" -ForegroundColor White
    Write-Host "  all       - Shutdown all VMs (basic)" -ForegroundColor White
    Write-Host "  windows   - Shutdown only Windows VMs" -ForegroundColor White
    Write-Host "  linux     - Shutdown only Linux VMs" -ForegroundColor White
    Write-Host "  macos     - Shutdown only macOS VMs" -ForegroundColor White
    Write-Host "  help      - Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\$($MyInvocation.MyCommand.Name) basic" -ForegroundColor White
    Write-Host "  .\$($MyInvocation.MyCommand.Name) graceful" -ForegroundColor White
    Write-Host "  .\$($MyInvocation.MyCommand.Name) windows" -ForegroundColor White
    Write-Host "  .\$($MyInvocation.MyCommand.Name) linux" -ForegroundColor White
}

# Function to run basic shutdown
function Run-BasicShutdown {
    Write-Host "Running basic shutdown for all VMs..." -ForegroundColor Yellow
    ansible-playbook -i hosts shutdown_vms.yml
}

# Function to run graceful shutdown
function Run-GracefulShutdown {
    Write-Host "Running graceful shutdown for all VMs..." -ForegroundColor Yellow
    ansible-playbook -i hosts shutdown_vms_advanced.yml
}

# Function to run force shutdown
function Run-ForceShutdown {
    Write-Host "WARNING: This will force shutdown all VMs immediately!" -ForegroundColor Red
    $confirmation = Read-Host "Are you sure you want to continue? (y/N)"
    if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
        Write-Host "Running force shutdown..." -ForegroundColor Yellow
        ansible-playbook -i hosts shutdown_vms_advanced.yml -e "force_shutdown=true"
    } else {
        Write-Host "Force shutdown cancelled." -ForegroundColor Green
        exit 0
    }
}

# Function to shutdown specific OS group
function Shutdown-OSGroup {
    param([string]$OSGroup)
    Write-Host "Shutting down $OSGroup VMs..." -ForegroundColor Yellow
    ansible-playbook -i hosts shutdown_vms.yml --limit $OSGroup
}

# Main script logic
switch ($Option.ToLower()) {
    "basic" {
        Run-BasicShutdown
    }
    "graceful" {
        Run-GracefulShutdown
    }
    "force" {
        Run-ForceShutdown
    }
    "all" {
        Run-BasicShutdown
    }
    "windows" {
        Shutdown-OSGroup "windows"
    }
    "linux" {
        Shutdown-OSGroup "linux"
    }
    "macos" {
        Shutdown-OSGroup "macOS"
    }
    default {
        Show-Usage
    }
}

Write-Host ""
Write-Host "Shutdown operation completed." -ForegroundColor Green 