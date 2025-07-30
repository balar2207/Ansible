# Windows Update Service Management with Ansible

This directory contains Ansible playbooks to check, enable, and start the Windows Update service on Windows machines.

## Available Playbooks

### 1. `check-windows-update-service.yml` (Simple Version)
A basic playbook that:
- Checks the current status of the Windows Update service
- Enables the service (sets to auto-start) if disabled
- Starts the service if not running
- Displays the final status

### 2. `check-windows-update-service.yml` (Updated Version)
An improved playbook that:
- Checks and starts required dependency services first
- Handles Windows Update service startup errors gracefully
- Provides detailed error reporting and troubleshooting
- Shows comprehensive service information

### 3. `fix-windows-update-service.yml` (Troubleshooting Version)
A robust playbook specifically designed to fix Windows Update service issues:
- Resets the service configuration
- Ensures all dependencies are running
- Provides multiple fallback methods for starting the service
- Offers detailed dependency analysis

## Prerequisites

1. **Windows Hosts**: Ensure your Windows machines are properly configured in the inventory
2. **WinRM**: Windows Remote Management must be enabled on target machines
3. **Credentials**: Valid administrator credentials configured in inventory

## Usage

### Run the simple version:
```bash
ansible-playbook -i inventory check-windows-update-service.yml
```

### Run the updated version:
```bash
ansible-playbook -i inventory check-windows-update-service.yml
```

### Run the troubleshooting version:
```bash
ansible-playbook -i inventory fix-windows-update-service.yml
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

### Common Windows Update Service Issues:

1. **Service won't start**: 
   - The Windows Update service has dependencies that must be running first
   - Use `fix-windows-update-service.yml` to automatically handle dependencies
   - Key dependencies: RpcEptMapper, RpcSs, DcomLaunch, CryptSvc, BITS

2. **"Cannot start service wuauserv" error**:
   - This usually means dependency services are not running
   - The updated playbooks will automatically start required dependencies
   - Try the troubleshooting playbook for more robust handling

3. **Access denied**: 
   - Ensure running with administrator privileges
   - Verify WinRM is properly configured

4. **Service stuck in stopping state**:
   - The troubleshooting playbook will force-stop and restart the service
   - This can resolve stuck service states

### Recommended Approach:

1. **First try**: `check-windows-update-service.yml` (handles dependencies)
2. **If that fails**: `fix-windows-update-service.yml` (more aggressive troubleshooting)
3. **Manual check**: Verify all dependency services are running manually

## Related Playbooks

- `update-windows.yml`: Runs Windows Updates after ensuring service is running
- `iisinstall.yaml`: Installs IIS on Windows machines
- `install_chrome.yml`: Installs Google Chrome on Windows machines 