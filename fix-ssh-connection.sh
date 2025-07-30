#!/bin/bash

# Fix SSH Connection Issues with Legacy Servers
# This script helps resolve SSH key exchange issues with older servers

echo "=== SSH Connection Fix Script ==="
echo "This script will help you connect to servers that use legacy SSH algorithms"
echo ""

# Check if target IP is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <target-ip> [username]"
    echo "Example: $0 192.168.1.91 admin"
    exit 1
fi

TARGET_IP="$1"
USERNAME="${2:-$(whoami)}"

echo "Target IP: $TARGET_IP"
echo "Username: $USERNAME"
echo ""

# Test 1: Try normal SSH connection
echo "=== Test 1: Normal SSH Connection ==="
ssh -o ConnectTimeout=10 "$USERNAME@$TARGET_IP" "echo 'SSH connection successful'" 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Normal SSH connection works!"
    exit 0
else
    echo "❌ Normal SSH connection failed"
fi

echo ""

# Test 2: Try with legacy algorithms
echo "=== Test 2: SSH with Legacy Algorithms ==="
ssh -o KexAlgorithms=+diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group-exchange-sha256 \
    -o Ciphers=+aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc \
    -o HostKeyAlgorithms=+ssh-rsa,ssh-dss \
    -o ConnectTimeout=10 \
    "$USERNAME@$TARGET_IP" "echo 'SSH connection with legacy algorithms successful'" 2>&1

if [ $? -eq 0 ]; then
    echo "✅ SSH connection with legacy algorithms works!"
    echo ""
    echo "=== Solution ==="
    echo "The server requires legacy SSH algorithms. You can now:"
    echo "1. Use the ansible.cfg file that was created"
    echo "2. Or run Ansible with the following command:"
    echo ""
    echo "ansible-playbook -i inventory your-playbook.yml --ssh-extra-args='-o KexAlgorithms=+diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group-exchange-sha256 -o Ciphers=+aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc -o HostKeyAlgorithms=+ssh-rsa,ssh-dss'"
    echo ""
    echo "3. Or add this to your ~/.ssh/config:"
    echo "Host $TARGET_IP"
    echo "    KexAlgorithms +diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group-exchange-sha256"
    echo "    Ciphers +aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc"
    echo "    HostKeyAlgorithms +ssh-rsa,ssh-dss"
else
    echo "❌ SSH connection with legacy algorithms also failed"
    echo ""
    echo "=== Troubleshooting ==="
    echo "1. Check if the server is reachable: ping $TARGET_IP"
    echo "2. Check if SSH service is running on the server"
    echo "3. Verify the username is correct"
    echo "4. Check if SSH keys are properly configured"
    echo "5. Try connecting manually: ssh $USERNAME@$TARGET_IP"
fi

echo ""
echo "=== Additional Information ==="
echo "This error typically occurs with:"
echo "- Older Linux distributions (RHEL 6, CentOS 6, Ubuntu 12.04, etc.)"
echo "- Legacy network devices"
echo "- Servers with outdated SSH configurations"
echo ""
echo "The ansible.cfg file created in this directory should resolve the issue for Ansible playbooks." 