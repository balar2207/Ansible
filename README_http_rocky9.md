# Apache HTTP Server Installation on Rocky Linux 9

This Ansible playbook automates the installation and configuration of Apache HTTP Server on Rocky Linux 9 systems.

## Features

- ✅ Installs Apache HTTP Server (httpd) with SSL support
- ✅ Configures optimized Apache settings for performance
- ✅ Sets up virtual host configuration
- ✅ Configures firewall rules (firewalld)
- ✅ Handles SELinux context settings
- ✅ Creates a sample welcome page
- ✅ Enables and starts the Apache service
- ✅ Verifies the installation with connectivity test

## Prerequisites

1. **Ansible Control Node**: Ensure Ansible is installed on your control machine
2. **Target Servers**: Rocky Linux 9 servers with SSH access
3. **SSH Access**: Either password or SSH key authentication to target servers
4. **Sudo Privileges**: The ansible user must have sudo privileges on target servers

## Quick Start

### 1. Update Inventory

Edit the `inventory_rocky9` file and add your Rocky Linux 9 servers:

```bash
# Add your servers
rocky9-server1 ansible_host=192.168.1.100
rocky9-server2 ansible_host=192.168.1.101
```

### 2. Configure Authentication

Choose one of the following authentication methods:

**Option A: SSH Key Authentication (Recommended)**
```bash
# Generate SSH key if you don't have one
ssh-keygen -t rsa -b 4096

# Copy SSH key to target servers
ssh-copy-id root@your-server-ip

# Update inventory_rocky9
ansible_ssh_private_key_file=~/.ssh/id_rsa
```

**Option B: Password Authentication**
```bash
# Update inventory_rocky9
ansible_password=your_password_here
```

### 3. Run the Playbook

```bash
# Test connectivity first
ansible -i inventory_rocky9 rocky9_servers -m ping

# Run the playbook
ansible-playbook -i inventory_rocky9 install_http_rocky9.yml
```

## Configuration Options

### Default Settings

The playbook uses these default values (can be overridden):

- **HTTP Port**: 80
- **HTTPS Port**: 443
- **Document Root**: `/var/www/html`
- **Server Name**: Uses the target server's hostname

### Customizing Configuration

You can customize the installation by modifying variables in the playbook or inventory:

```yaml
# In inventory_rocky9 or as extra vars
http_port: 8080
https_port: 8443
document_root: /var/www/mysite
server_name: mysite.example.com
```

### Running with Custom Variables

```bash
ansible-playbook -i inventory_rocky9 install_http_rocky9.yml \
  -e "http_port=8080 document_root=/var/www/mysite"
```

## File Structure

```
.
├── install_http_rocky9.yml          # Main playbook
├── inventory_rocky9                  # Inventory file
├── templates/
│   ├── apache_main.conf.j2          # Main Apache configuration
│   ├── virtual_host.conf.j2         # Virtual host configuration
│   └── index.html.j2                # Sample welcome page
└── README_http_rocky9.md            # This file
```

## What the Playbook Does

1. **Package Installation**: Installs `httpd`, `mod_ssl`, and `openssl`
2. **Configuration**: Creates optimized Apache configuration files
3. **Security**: Configures firewall rules and SELinux contexts
4. **Service Management**: Enables and starts Apache service
5. **Verification**: Tests the installation with a connectivity check

## Post-Installation

### Accessing Your Web Server

After successful installation, you can access your web server at:
- **HTTP**: `http://your-server-ip:80`
- **HTTPS**: `https://your-server-ip:443` (when SSL is configured)

### Useful Commands

```bash
# Check Apache status
systemctl status httpd

# View Apache logs
tail -f /var/log/httpd/error_log
tail -f /var/log/httpd/access_log

# Test Apache configuration
apachectl configtest

# Restart Apache
systemctl restart httpd

# Check firewall status
firewall-cmd --list-all
```

### SSL Configuration (Optional)

To enable HTTPS, you'll need to:

1. Obtain SSL certificates
2. Place them in `/etc/pki/tls/certs/` and `/etc/pki/tls/private/`
3. Uncomment the HTTPS virtual host section in `templates/virtual_host.conf.j2`
4. Run the playbook again or restart Apache

## Troubleshooting

### Common Issues

1. **Firewall Blocking Access**
   ```bash
   # Check firewall status
   firewall-cmd --list-all
   
   # Manually add HTTP port if needed
   firewall-cmd --permanent --add-port=80/tcp
   firewall-cmd --reload
   ```

2. **SELinux Issues**
   ```bash
   # Check SELinux status
   getenforce
   
   # Set correct context for web content
   semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"
   restorecon -Rv /var/www/html
   ```

3. **Permission Issues**
   ```bash
   # Fix ownership
   chown -R apache:apache /var/www/html
   chmod -R 755 /var/www/html
   ```

### Log Files

- **Error Log**: `/var/log/httpd/error_log`
- **Access Log**: `/var/log/httpd/access_log`
- **Apache Configuration**: `/etc/httpd/conf/httpd.conf`

## Security Considerations

- The playbook includes basic security headers
- Firewall rules are configured automatically
- SELinux contexts are set appropriately
- Server tokens are minimized for security
- Directory browsing is enabled (can be disabled if needed)

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Apache and Rocky Linux 9 documentation
3. Check Ansible logs for detailed error messages

## License

This playbook is provided as-is for educational and deployment purposes. 