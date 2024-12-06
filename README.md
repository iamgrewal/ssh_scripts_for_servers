<!--
Description: These Shell scripts help create SSH Automated login and Git and Gitlab login automated.
-->
These Shell scripts help create SSH Automated login and Git and Gitlab login automated

# SSH Automation Scripts

A collection of shell scripts to automate SSH key management, Git/GitLab authentication, and secure server access across multiple hosts.

## 🚀 Features

- Automated SSH key generation and distribution
- SSH config file management
- Git/GitLab SSH authentication setup
- Host file management
- Duplicate SSH key cleanup
- SSH login validation
- GPG key setup support

## 📋 Prerequisites

- Bash shell environment
- SSH client installed
- Root/sudo access (for some operations)
- Git (for Git-related features)

## 🛠️ Quick Start

1. Clone this repository:

```bash
git clone <repository-url>
cd ssh-automation-scripts
```

2. Create an inventory file (`inventory.txt`):

```text
# Format: hostname domain_name ip_address
MY_SERVER1 my_server1.example.com 10.10.10.121
MY_SERVER2 my_server2.example.com 10.10.10.122
MY_SERVER3 my_server3.example.com 10.10.10.123
```

3. Set up SSH keys and configuration:

```bash
# Generate SSH keys if you don't have them
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# Create SSH config
./create_ssh_config.sh

# Load SSH keys
./load_ssh_keys.sh
```

## 📚 Script Descriptions

### Core Scripts

1. `create_ssh_config.sh`
   - Creates/updates SSH config file (~/.ssh/config)
   - Configures default SSH settings and host-specific configurations
   - Sets up Git/GitLab SSH access

2. `load_ssh_keys.sh`
   - Manages SSH agent
   - Loads both local and Git SSH keys
   - Ensures keys are properly loaded into SSH agent

3. `check_ssh_login_colored.sh`
   - Validates SSH connectivity to configured servers
   - Tests both direct and nested SSH connections
   - Provides colored output for success/failure

### Key Management Scripts

4. `copy_ssh_keys_with_validation.sh`
   - Distributes SSH keys between servers
   - Validates key presence before copying
   - Ensures bidirectional SSH access

5. `sort_remove_duplicate_ssh.sh`
   - Cleans up authorized_keys files
   - Removes duplicate entries
   - Maintains key file organization

6. `revalidate_private_key.sh`
   - Verifies SSH key configurations
   - Checks key presence in authorized_keys
   - Repairs broken SSH configurations

### Additional Utilities

7. `copy_hosts_file.sh`
   - Manages /etc/hosts file
   - Configures hostname resolution
   - Supports multiple network interfaces

8. `git_keys.sh`
   - Sets up Git-specific SSH keys
   - Configures Git authentication
   - Manages authorized keys

## 🔧 Configuration

### Creating an Inventory File

1. Create a new file named `inventory.txt`:

```bash
touch inventory.txt
```

2. Add your servers in the following format:

```text
# Server inventory
# Format: hostname domain ip_address [additional_domains]

# Production servers
MY_SERVER1 my_server1.domain1.com 10.10.10.121 my_server1.domain2.com
MY_SERVER2 my_server2.domain1.com 10.10.10.122 my_server2.domain2.com

# Development servers
DEV_SERVER1 dev1.domain1.com 172.122.22.121
DEV_SERVER2 dev2.domain1.com 172.122.22.122
```

### SSH Key Setup

1. Generate a new SSH key pair:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

2. For Git-specific keys:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_git

```inventory.yml

## 🔐 Security Recommendations

- Always use strong SSH keys (minimum 4096 bits)
- Regularly rotate SSH keys
- Keep private keys secure and never share them
- Use different keys for different purposes (e.g., separate Git keys)
- Regularly audit authorized_keys files
- Implement proper file permissions:
  ```bash
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/config
  chmod 600 ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/id_rsa
  chmod 644 ~/.ssh/id_rsa.pub
  ```

## 🐛 Troubleshooting

Common issues and solutions:

1. SSH Connection Failed
   - Check if the server is reachable (ping)
   - Verify SSH service is running
   - Confirm key permissions
   - Check authorized_keys file

2. Git Authentication Issues
   - Verify Git SSH key is loaded
   - Test connection: `ssh -T git@github.com`
   - Check Git configuration

## 📝 License

MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

## 🚀 Initial Setup

### 1. Install Dependencies

```bash
# For Debian/Ubuntu systems
sudo apt-get update
sudo apt-get install -y yq ssh-client

# For RHEL/CentOS systems
sudo yum install -y yq openssh-clients

# Make all scripts executable
chmod +x *.sh

# Backup existing SSH configurations
mkdir -p ~/.ssh/backups
cp ~/.ssh/config ~/.ssh/backups/config.$(date +%Y%m%d)
cp ~/.ssh/known_hosts ~/.ssh/backups/known_hosts.$(date +%Y%m%d)
```

### 2. Prepare Environment

```bash
# Create necessary directories
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Set proper permissions
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

## 🔄 Testing and Validation

### 1. Validate Configuration

```bash
# Check inventory file syntax
yq eval . inventory.yml

# Verify inventory parsing
./parse_inventory.sh

# Check generated SSH config
cat ~/.ssh/config
```

### 2. Test Connectivity

```bash
# Test SSH agent
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
ssh-add -l  # List loaded keys

# Test single server connection
ssh SERVER1 "hostname"

# Run full validation
./check_ssh_login_colored.sh
```

### 3. Debug Connection Issues

```bash
# View SSH debug information
ssh -vv SERVER1

# Check server reachability
ping -c 4 SERVER1

# Test SSH port connectivity
nc -zv SERVER1 22

# Check SSH service status on remote server
ssh SERVER1 'systemctl status sshd'
```

## 🔍 Troubleshooting Guide

### Common Issues and Solutions

1. **SSH Agent Issues**
   ```bash
   # Restart SSH agent
   eval $(ssh-agent -k)
   eval $(ssh-agent)
   ssh-add ~/.ssh/id_rsa
   ```

2. **Permission Problems**
   ```bash
   # Fix common permission issues
   find ~/.ssh -type f -exec chmod 600 {} \;
   find ~/.ssh -type d -exec chmod 700 {} \;
   chmod 644 ~/.ssh/*.pub
   ```

3. **Key Authentication Failures**
   ```bash
   # Check authorized_keys on remote server
   ssh SERVER1 'cat ~/.ssh/authorized_keys'

   # Verify key presence in SSH agent
   ssh-add -l

   # Force password authentication for testing
   ssh -o PubkeyAuthentication=no SERVER1
   ```

4. **DNS Resolution Issues**
   ```bash
   # Test DNS resolution
   dig SERVER1

   # Add to /etc/hosts if needed
   sudo sh -c 'echo "10.0.0.1 SERVER1" >> /etc/hosts'
   ```

### Logging and Debugging

Enable detailed SSH logging:

```bash
# Create SSH debug log
ssh -vv SERVER1 2>ssh_debug.log

# Monitor SSH attempts
sudo tail -f /var/log/auth.log    # On Debian/Ubuntu
sudo tail -f /var/log/secure      # On RHEL/CentOS
```

## 📝 Maintenance Tasks

### Regular Updates

```bash
# Update inventory
vim inventory.yml

# Regenerate configurations
./parse_inventory.sh

# Validate changes
./check_ssh_login_colored.sh
```

### Key Rotation

```bash
# Generate new keys
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_new

# Distribute new keys
./copy_ssh_keys_with_validation.sh

# Remove old keys
ssh SERVER1 'sed -i.bak "/old-key-content/d" ~/.ssh/authorized_keys'
```

## 📊 Health Check Commands

Quick commands to verify system health:

```bash
# Check SSH daemon status
systemctl status sshd

# View SSH config syntax
sshd -t

# Check open SSH connections
netstat -tnpa | grep ':22'

# View SSH key fingerprints
ssh-keygen -lf ~/.ssh/id_rsa.pub
```
