#!/bin/bash

# Required packages
command -v yq >/dev/null 2>&1 || { echo "Please install yq: sudo apt install yq"; exit 1; }

INVENTORY_FILE="inventory.yml"

# Function to read inventory file
parse_inventory() {
    if [ ! -f "$INVENTORY_FILE" ]; then
        echo "Error: inventory.yml not found!"
        exit 1
    }

    # Export variables for use in other scripts
    export SSH_USER=$(yq e '.ssh_user' "$INVENTORY_FILE")
    export SSH_PORT=$(yq e '.ssh_port' "$INVENTORY_FILE")
    export DEFAULT_DOMAIN1=$(yq e '.default_domain1' "$INVENTORY_FILE")
    export DEFAULT_DOMAIN2=$(yq e '.default_domain2' "$INVENTORY_FILE")

    # Create arrays of server information
    export SERVER_NAMES=($(yq e '.servers | keys | .[]' "$INVENTORY_FILE"))
    export SERVER_IPS=($(yq e '.servers[].ip' "$INVENTORY_FILE"))
    export SERVER_LOCAL_IPS=($(yq e '.servers[].local_ip' "$INVENTORY_FILE"))
}

# Function to generate hosts file content
generate_hosts_content() {
    local temp_file=$(mktemp)
    
    echo "# Generated from inventory.yml" > "$temp_file"
    echo "127.0.0.1 localhost" >> "$temp_file"
    echo "::1 localhost" >> "$temp_file"
    
    for i in "${!SERVER_NAMES[@]}"; do
        local name="${SERVER_NAMES[$i]}"
        local ip="${SERVER_IPS[$i]}"
        local aliases=$(yq e ".servers.$name.aliases[]" "$INVENTORY_FILE" | tr '\n' ' ')
        echo "$ip $name $aliases" >> "$temp_file"
    done

    echo "$temp_file"
}

# Function to generate SSH config content
generate_ssh_config() {
    local temp_file=$(mktemp)
    
    # Global SSH settings
    cat <<EOF > "$temp_file"
# Generated from inventory.yml
Host *
    User $SSH_USER
    Port $SSH_PORT
    IdentityFile ~/.ssh/id_rsa
    ForwardAgent no
    ForwardX11 no
    ServerAliveInterval 60
EOF

    # Server-specific configurations
    for i in "${!SERVER_NAMES[@]}"; do
        local name="${SERVER_NAMES[$i]}"
        local ip="${SERVER_IPS[$i]}"
        local local_ip="${SERVER_LOCAL_IPS[$i]}"
        
        cat <<EOF >> "$temp_file"

Host $name
    HostName $ip
    User $SSH_USER

Host $name.local
    HostName $local_ip
    User $SSH_USER
EOF
    done

    # Git configurations
    yq e '.git_servers[] | "Host " + .hostname + "\n    HostName " + .hostname + "\n    User " + .user + "\n    IdentityFile ~/.ssh/id_rsa_git\n    AddKeysToAgent yes\n    ForwardAgent yes"' "$INVENTORY_FILE" >> "$temp_file"

    echo "$temp_file"
} 

# Required packages
command -v yq >/dev/null 2>&1 || { echo "Please install yq: sudo apt install yq"; exit 1; }

INVENTORY_FILE="inventory.yml"

# Function to read inventory file
parse_inventory() {
    if [ ! -f "$INVENTORY_FILE" ]; then
        echo "Error: inventory.yml not found!"
        exit 1
    }

    # Export variables for use in other scripts
    export SSH_USER=$(yq e '.ssh_user' "$INVENTORY_FILE")
    export SSH_PORT=$(yq e '.ssh_port' "$INVENTORY_FILE")
    export DEFAULT_DOMAIN1=$(yq e '.default_domain1' "$INVENTORY_FILE")
    export DEFAULT_DOMAIN2=$(yq e '.default_domain2' "$INVENTORY_FILE")

    # Create arrays of server information
    export SERVER_NAMES=($(yq e '.servers | keys | .[]' "$INVENTORY_FILE"))
    export SERVER_IPS=($(yq e '.servers[].ip' "$INVENTORY_FILE"))
    export SERVER_LOCAL_IPS=($(yq e '.servers[].local_ip' "$INVENTORY_FILE"))
}

# Function to generate hosts file content
generate_hosts_content() {
    local temp_file=$(mktemp)
    
    echo "# Generated from inventory.yml" > "$temp_file"
    echo "127.0.0.1 localhost" >> "$temp_file"
    echo "::1 localhost" >> "$temp_file"
    
    for i in "${!SERVER_NAMES[@]}"; do
        local name="${SERVER_NAMES[$i]}"
        local ip="${SERVER_IPS[$i]}"
        local aliases=$(yq e ".servers.$name.aliases[]" "$INVENTORY_FILE" | tr '\n' ' ')
        echo "$ip $name $aliases" >> "$temp_file"
    done

    echo "$temp_file"
}

# Function to generate SSH config content
generate_ssh_config() {
    local temp_file=$(mktemp)
    
    # Global SSH settings
    cat <<EOF > "$temp_file"
# Generated from inventory.yml
Host *
    User $SSH_USER
    Port $SSH_PORT
    IdentityFile ~/.ssh/id_rsa
    ForwardAgent no
    ForwardX11 no
    ServerAliveInterval 60
EOF

    # Server-specific configurations
    for i in "${!SERVER_NAMES[@]}"; do
        local name="${SERVER_NAMES[$i]}"
        local ip="${SERVER_IPS[$i]}"
        local local_ip="${SERVER_LOCAL_IPS[$i]}"
        
        cat <<EOF >> "$temp_file"

Host $name
    HostName $ip
    User $SSH_USER

Host $name.local
    HostName $local_ip
    User $SSH_USER
EOF
    done

    # Git configurations
    yq e '.git_servers[] | "Host " + .hostname + "\n    HostName " + .hostname + "\n    User " + .user + "\n    IdentityFile ~/.ssh/id_rsa_git\n    AddKeysToAgent yes\n    ForwardAgent yes"' "$INVENTORY_FILE" >> "$temp_file"

    echo "$temp_file"
}