# macOS Ansible Playbooks

This directory contains Ansible playbooks for managing macOS systems.

## Available Playbooks

### 1. Xcode Command Line Tools Installation
**File:** `xcode_command_line_tools.yml`

Installs Xcode Command Line Tools on macOS systems. This is the most common requirement for development work on macOS.

**Features:**
- Checks if Command Line Tools are already installed
- Installs Command Line Tools if not present
- Waits for installation to complete
- Accepts Xcode license agreement
- Verifies installation by checking various tools (git, clang, make, python3)

**Usage:**
```bash
ansible-playbook -i ../hosts xcode_command_line_tools.yml
```

**What gets installed:**
- Xcode Command Line Tools
- Git
- Clang compiler
- Make
- Python3
- Various other development tools

### 2. Full Xcode Installation (App Store)
**File:** `xcode_install_appstore.yaml`

Installs the full Xcode IDE from the Mac App Store. This is a much larger download and installation.

**Prerequisites:**
- `mas-cli` must be installed: `brew install mas`
- User must be signed into Mac App Store on target machines

**Usage:**
```bash
ansible-playbook -i ../hosts xcode_install_appstore.yaml
```

### 3. Full Xcode Installation (Direct Download)
**File:** `xcode_install.yaml`

Downloads and installs Xcode directly from Apple Developer Portal.

**Prerequisites:**
- Apple Developer account
- Authentication cookie for downloads

**Usage:**
```bash
ansible-playbook -i ../hosts xcode_install.yaml
```

## Hosts Configuration

Make sure your `hosts` file includes a `[macOS]` group:

```ini
[macOS]
macos-host-1 ansible_user=your_username
macos-host-2 ansible_user=your_username
```

## Requirements

- Ansible 2.9+
- SSH access to macOS hosts
- Sudo privileges on target machines
- For App Store installations: `mas-cli` and App Store login
- For direct downloads: Apple Developer account

## Notes

- The Command Line Tools installation is the most common and recommended approach for most development work
- Full Xcode IDE is only needed for iOS/macOS app development
- Command Line Tools installation is much faster and uses less disk space
- All playbooks include proper error handling and verification steps 