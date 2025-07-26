# macOS Xcode Installation with Ansible

This directory contains Ansible playbooks for installing Xcode and Xcode Command Line Tools on macOS systems.

## Prerequisites

- Ansible installed on the control machine
- macOS target systems accessible via SSH
- Proper SSH key authentication or password authentication configured
- Target systems must be running macOS

## Inventory Configuration

Make sure your macOS hosts are properly configured in your inventory file. Example:

```ini
[macOS]
Ansible-macslave-VM1
Ansible-macslave-VM2

[macOS:vars]
ansible_user=your_macos_user
ansible_ssh_private_key_file=~/.ssh/id_rsa
# or use password authentication:
# ansible_password=your_password
```

## Available Playbooks

### 1. xcode_clt_install.yaml - Command Line Tools Only

This playbook installs only the Xcode Command Line Tools, which is sufficient for most development work including:
- Git
- Clang compiler
- Make tools
- Basic development utilities

**Usage:**
```bash
ansible-playbook -i ../inventory macOS/xcode_clt_install.yaml
```

**Features:**
- Checks if Command Line Tools are already installed
- Installs Command Line Tools if missing
- Accepts Xcode license agreement
- Verifies installation by checking git and clang availability
- Provides detailed status output

### 2. xcode_install.yaml - Full Xcode Installation

This playbook installs the complete Xcode application including:
- Xcode IDE
- iOS Simulator
- Full development tools
- Command Line Tools

**Usage:**
```bash
ansible-playbook -i ../inventory macOS/xcode_install.yaml
```

**Features:**
- Installs Command Line Tools first
- Attempts to install full Xcode from Mac App Store
- Requires mas (Mac App Store CLI) tool
- May require manual App Store sign-in
- Sets Xcode as default developer directory
- Lists available iOS simulators

## Variables

You can customize the installation by modifying the variables in the playbooks:

```yaml
vars:
  xcode_version: "15.2"  # Specify desired Xcode version
  install_command_line_tools: true
  install_full_xcode: true
```

## Important Notes

### Command Line Tools Installation
- The Command Line Tools installation requires user interaction on the target system
- The playbook includes a pause to allow time for manual completion
- Installation may take 5-15 minutes depending on network speed

### Full Xcode Installation
- Requires mas (Mac App Store CLI) tool
- May require manual sign-in to Mac App Store
- Full Xcode is a large download (10+ GB)
- Installation can take 30+ minutes
- Requires sufficient disk space

### Manual Steps Required
1. **Command Line Tools**: When `xcode-select --install` runs, a dialog will appear on the target system. The user must click "Install" and wait for completion.

2. **App Store Sign-in**: For full Xcode installation, the user may need to sign in to the Mac App Store manually.

## Troubleshooting

### Common Issues

1. **SSH Connection Issues**
   ```bash
   # Test SSH connectivity
   ansible macOS -m ping -i ../inventory
   ```

2. **Permission Issues**
   - Ensure the Ansible user has sudo privileges
   - Check SSH key permissions

3. **Installation Timeouts**
   - Increase timeout values in the playbook
   - Check network connectivity on target systems

4. **App Store Issues**
   - Verify mas tool installation
   - Check App Store sign-in status
   - Ensure target system has sufficient disk space

### Verification Commands

After installation, verify the setup:

```bash
# Check Command Line Tools
xcode-select --print-path

# Check Xcode version
xcodebuild -version

# Check git availability
git --version

# Check clang availability
clang --version
```

## Security Considerations

- Store sensitive information (passwords, keys) in Ansible Vault
- Use SSH key authentication when possible
- Limit sudo privileges to necessary commands only
- Regularly update Xcode and Command Line Tools

## Support

For issues or questions:
1. Check the Ansible documentation
2. Verify macOS system requirements
3. Review Apple's Xcode documentation
4. Check network connectivity and firewall settings 