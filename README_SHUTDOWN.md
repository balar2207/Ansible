# Ansible VM Shutdown Playbooks

This directory contains Ansible playbooks and scripts to shutdown VMs across different operating systems (macOS, Windows, and Linux).

## Files Overview

- `shutdown_vms.yml` - Basic shutdown playbook (immediate shutdown)
- `shutdown_vms_advanced.yml` - Advanced shutdown playbook with graceful shutdown options
- `shutdown_script.sh` - Bash script for easy execution (Linux/macOS)
- `shutdown_script.ps1` - PowerShell script for easy execution (Windows)
- `hosts` - Ansible inventory file with VM definitions

## Prerequisites

1. **Ansible Installation**: Ensure Ansible is installed on your control machine
2. **SSH Access**: For Linux and macOS VMs, ensure SSH access is configured
3. **WinRM Access**: For Windows VMs, ensure WinRM is configured
4. **Inventory Setup**: Update the `hosts` file with your actual VM hostnames/IPs

## Quick Start

### Using the Scripts (Recommended)

#### On Linux/macOS:
```bash
# Make script executable
chmod +x shutdown_script.sh

# Basic shutdown (immediate)
./shutdown_script.sh basic

# Graceful shutdown (60 second delay)
./shutdown_script.sh graceful

# Shutdown specific OS group
./shutdown_script.sh windows
./shutdown_script.sh linux
./shutdown_script.sh macos
```

#### On Windows (PowerShell):
```powershell
# Basic shutdown (immediate)
.\shutdown_script.ps1 basic

# Graceful shutdown (60 second delay)
.\shutdown_script.ps1 graceful

# Shutdown specific OS group
.\shutdown_script.ps1 windows
.\shutdown_script.ps1 linux
.\shutdown_script.ps1 macos
```

### Using Ansible Playbooks Directly

#### Basic Shutdown (Immediate):
```bash
ansible-playbook -i hosts shutdown_vms.yml
```

#### Graceful Shutdown (60 second delay):
```bash
ansible-playbook -i hosts shutdown_vms_advanced.yml
```

#### Force Shutdown (Emergency):
```bash
ansible-playbook -i hosts shutdown_vms_advanced.yml -e "force_shutdown=true"
```

#### Shutdown Specific OS Groups:
```bash
# Windows VMs only
ansible-playbook -i hosts shutdown_vms.yml --limit windows

# Linux VMs only
ansible-playbook -i hosts shutdown_vms.yml --limit linux

# macOS VMs only
ansible-playbook -i hosts shutdown_vms.yml --limit macOS
```

## Playbook Details

### shutdown_vms.yml
- **Purpose**: Basic immediate shutdown
- **Features**:
  - Uses OS-specific shutdown commands
  - Windows: `win_shutdown` module
  - Linux: `shutdown -h now`
  - macOS: `shutdown -h now`
  - No delay or graceful shutdown

### shutdown_vms_advanced.yml
- **Purpose**: Advanced shutdown with safety features
- **Features**:
  - System information gathering
  - Running process/service checks
  - Graceful shutdown with 60-second delay
  - Force shutdown option for emergencies
  - Better error handling and status reporting

## Configuration

### Inventory File (hosts)
Update the `hosts` file with your actual VM information:

```ini
[macOS]
Ansible-macslave-VM1
Ansible-macslave-VM2

[linux]
Ansible-rockyslave-VM1
Ansible-rockyslave-VM2

[windows]
Ansible-winslave-VM1
Ansible-winslave-VM2

[windows:vars]
ansible_user=administrator
ansible_password=your_password
ansible_port=5985
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
```

### Variables
You can customize shutdown behavior by modifying variables:

```yaml
vars:
  shutdown_timeout: 60  # Timeout in seconds
  force_shutdown: false # Force shutdown flag
```

## Safety Features

1. **Graceful Shutdown**: 60-second delay allows applications to save data
2. **Force Shutdown**: Emergency option for immediate shutdown
3. **Confirmation Prompts**: Scripts ask for confirmation before force shutdown
4. **Status Reporting**: Shows which VMs are being shutdown
5. **Error Handling**: Continues execution even if some VMs fail

## Troubleshooting

### Common Issues

1. **Connection Refused**:
   - Check if VMs are running
   - Verify SSH/WinRM connectivity
   - Check firewall settings

2. **Authentication Failed**:
   - Verify credentials in inventory file
   - Check SSH key permissions (Linux/macOS)
   - Verify WinRM configuration (Windows)

3. **Permission Denied**:
   - Ensure sudo access on Linux/macOS VMs
   - Check administrator privileges on Windows VMs

### Debug Mode
Run playbooks with verbose output for troubleshooting:

```bash
ansible-playbook -i hosts shutdown_vms.yml -vvv
```

## Best Practices

1. **Test First**: Always test on a single VM before running on all
2. **Backup Data**: Ensure important data is saved before shutdown
3. **Monitor**: Watch the output to ensure all VMs shutdown properly
4. **Document**: Keep track of which VMs are shutdown and when
5. **Graceful First**: Use graceful shutdown unless emergency requires immediate shutdown

## Examples

### Shutdown All VMs Gracefully:
```bash
./shutdown_script.sh graceful
```

### Emergency Shutdown of Windows VMs:
```bash
./shutdown_script.sh force
```

### Shutdown Only Linux VMs:
```bash
./shutdown_script.sh linux
```

### Check VM Status Before Shutdown:
```bash
ansible all -i hosts -m ping
```

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Ansible documentation
3. Verify your inventory configuration
4. Test connectivity manually before running playbooks 