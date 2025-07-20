# Jenkins Firewall Configuration for Rocky Linux 9

This repository contains Ansible playbooks to configure firewall exceptions for Jenkins on Rocky Linux 9 systems.

## Files Overview

- `jenkins_firewall_rocky9.yml` - Standalone playbook for firewall configuration only
- `install_jenkins_rocky9_with_firewall.yml` - Complete Jenkins installation with firewall configuration
- `rocky9_inventory_example` - Example inventory file for Rocky Linux 9 servers

## Prerequisites

1. **Ansible Control Node**: Ensure Ansible is installed on your control machine
2. **Target Servers**: Rocky Linux 9 servers with SSH access
3. **Inventory**: Configure your inventory file with target servers

## Quick Start

### 1. Configure Inventory

Copy the example inventory and update with your server details:

```bash
cp rocky9_inventory_example inventory_jenkins
# Edit inventory_jenkins with your server details
```

### 2. Test Connection

```bash
ansible -i inventory_jenkins jenkins_servers -m ping
```

### 3. Run Firewall Configuration Only

If Jenkins is already installed and you just need firewall configuration:

```bash
ansible-playbook -i inventory_jenkins jenkins_firewall_rocky9.yml
```

### 4. Install Jenkins with Firewall Configuration

For a complete Jenkins installation with firewall setup:

```bash
ansible-playbook -i inventory_jenkins install_jenkins_rocky9_with_firewall.yml
```

## Firewall Configuration Details

The playbooks configure the following:

### Ports Opened
- **Port 8080**: Jenkins web interface (HTTP)
- **Port 50000**: Jenkins agent connections

### Firewall Management
- **firewalld**: Primary firewall management (default on Rocky Linux 9)
- **iptables**: Fallback if firewalld is not active

### Security Features
- Permanent rules that survive reboots
- Proper service integration with firewalld
- Rule comments for easy identification
- Verification of port accessibility

## Customization

### Change Default Ports

Edit the variables in the playbook:

```yaml
vars:
  jenkins_port: 8080        # Change to your preferred port
  jenkins_agent_port: 50000 # Change to your preferred agent port
```

### Additional Firewall Rules

Add more ports or services by extending the firewall configuration tasks.

## Verification

After running the playbook, verify the configuration:

```bash
# Check firewalld status
ansible -i inventory_jenkins jenkins_servers -m shell -a "firewall-cmd --list-ports"

# Check if Jenkins is accessible
ansible -i inventory_jenkins jenkins_servers -m wait_for -a "port=8080 timeout=30"
```

## Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure your user has sudo privileges
2. **SSH Connection**: Verify SSH keys or passwords are correctly configured
3. **Firewall Service**: The playbook automatically detects and uses the appropriate firewall service

### Manual Verification

```bash
# On target server
sudo firewall-cmd --list-ports
sudo firewall-cmd --list-services
sudo systemctl status firewalld
```

## Security Considerations

- The playbooks open specific ports for Jenkins functionality
- Consider restricting access to specific IP ranges if needed
- Review and adjust firewall rules based on your security requirements
- Monitor firewall logs for any suspicious activity

## Support

For issues or questions:
1. Check the Ansible output for detailed error messages
2. Verify your inventory configuration
3. Ensure target servers meet the prerequisites 