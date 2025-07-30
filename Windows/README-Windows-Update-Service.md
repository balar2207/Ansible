# Windows Update Service Management with Ansible

This directory contains Ansible playbooks to check, enable, and start the Windows Update service on Windows machines.

## Available Playbooks

### 1. `check-windows-update-service.yml` (Simple Version)
A basic playbook that:
- Checks the current status of the Windows Update service
- Enables the service (sets to auto-start) if disabled
- Starts the service if not running
- Displays the final status

### 2. `windows-update-service.yml` (Comprehensive Version)
A detailed playbook that:
- Performs all the basic functions above
- Provides detailed service information
- Checks service dependencies
- Shows comprehensive status reports

## Prerequisites

1. **Windows Hosts**: Ensure your Windows machines are properly configured in the inventory
2. **WinRM**: Windows Remote Management must be enabled on target machines
3. **Credentials**: Valid administrator credentials configured in inventory

## Usage

### Run the simple version:
```bash
ansible-playbook -i inventory check-windows-update-service.yml
```

### Run the comprehensive version:
```bash
ansible-playbook -i inventory windows-update-service.yml
```

### Run against specific hosts:
```bash
ansible-playbook -i inventory check-windows-update-service.yml --limit Ansible-winslave-VM1
```

## Service Details

The playbooks manage the **Windows Update service** (`wuauserv`):
- **Service Name**: wuauserv
- **Display Name**: Windows Update
- **Description**: Enables the detection, download, and installation of updates for Windows and other programs

## Expected Output

The playbooks will show:
- Current service status (running/stopped)
- Start mode (auto/manual/disabled)
- Service state after configuration
- Final verification status

## Troubleshooting

1. **Service won't start**: Check if dependencies are running
2. **Access denied**: Ensure running with administrator privileges
3. **Connection issues**: Verify WinRM is properly configured

## Related Playbooks

- `update-windows.yml`: Runs Windows Updates after ensuring service is running
- `iisinstall.yaml`: Installs IIS on Windows machines
- `install_chrome.yml`: Installs Google Chrome on Windows machines 