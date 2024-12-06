#!/bin/bash

# Define the path to the SSH configuration file
SSH_CONFIG_FILE="$HOME/.ssh/config"

# Check if the SSH configuration file exists
if [ ! -f "$SSH_CONFIG_FILE" ]; then
    echo "Creating $SSH_CONFIG_FILE..."

    # Create the directory if it does not exist
    mkdir -p "$(dirname "$SSH_CONFIG_FILE")"

    # Write the content to the SSH configuration file
    cat <<EOF > "$SSH_CONFIG_FILE"
# Enable agent forwarding
AddKeysToAgent yes

# Default settings for all hosts
Host *
    User root
    IdentityFile ~/.ssh/id_rsa
    ForwardAgent no
    ForwardX11 no
    ForwardX11Trusted yes
    Port 22
    Protocol 2
    ServerAliveInterval 60
    ServerAliveCountMax 30
    # Enhanced security settings
    HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
 

# ----------------GIT----------------
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_rsa_git
  AddKeysToAgent yes
  ForwardAgent yes

Host gitlab
  HostName gitlab.io
  IdentityFile ~/.ssh/id_rsa_git
  AddKeysToAgent yes
  ForwardAgent yes
  User git

Host gitlab
  HostName gitlab.com
  IdentityFile ~/.ssh/id_rsa_git
  AddKeysToAgent yes
  ForwardAgent yes
  User git

# Specific host configurations
Host MY_SERVER1
    HostName MY_SERVER1.domain1.example.com
    HostName 10.10.10.121
    HostName MY_SERVER1.domain2.example.com

Host MY_SERVER2
    HostName 10.10.10.122
    HostName MY_SERVER2.domain2.example.com
    HostName MY_SERVER2.domain1.example.com
    HostName MY_SERVER2

Host MY_SERVER3
    HostName MY_SERVER3.domain1.example.com
    HostName 10.10.10.123
    HostName MY_SERVER3.domain2.example.com

Host MY_SERVER4
    HostName MY_SERVER4.domain1.example.com
    HostName 10.10.10.124
    HostName MY_SERVER4.domain2.example.com

Host MY_SERVER5
    HostName MY_SERVER5.domain1.example.com
    HostName 10.10.10.125
    HostName MY_SERVER5.domain2.example.com

Host MY_SERVER6
    HostName MY_SERVER6.domain1.example.com
    HostName 10.10.10.126
    HostName MY_SERVER6.domain2.example.com

Host MY_SERVER7
    HostName MY_SERVER7.domain1.example.com
    HostName 10.10.10.127
    HostName MY_SERVER7.domain2.example.com

Host MY_SERVER8
    HostName MY_SERVER8.domain1.example.com
    HostName 10.10.10.128
    HostName MY_SERVER8.domain2.example.com

Host synology
    HostName synology.domain1.example.com
    HostName 10.10.10.2
    HostName synology.domain2.example.com

Host git.local
    HostName git.domain1.example.com
    HostName 10.10.10.17
    HostName git.rhobyte.me
    Port 222

Host MY_SERVER1.local
    HostName 172.122.22.121
Host MY_SERVER3.local
    HostName 172.122.22.123
Host MY_SERVER4.local
    HostName 172.122.22.124
Host MY_SERVER5.local
    HostName 172.122.22.125
Host MY_SERVER6.local
    HostName 172.122.22.126
Host MY_SERVER7.local
    HostName 172.122.22.127
Host MY_SERVER8.local
    HostName 172.122.22.128
Host green.local
    HostName 172.122.22.71
Host MY_SERVER2.local
    HostName 172.122.22.122
Host synology.local
    HostName 172.122.22.2
    Port 2222
EOF

    echo "$SSH_CONFIG_FILE created successfully."
else
    echo "$SSH_CONFIG_FILE already exists. No action taken."
fi
ssh -T git@github.com
ssh -T git@github.com

echo " Now creating GPG"
