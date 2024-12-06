#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m' 
NC='\033[0m' # No Color

# List of nodes
nodes=("MY_SERVER5" "MY_SERVER6" "MY_SERVER7" "MY_SERVER8")

# Loop through each MY_SERVER
for MY_SERVER in "${nodes[@]}"; do
    echo -e "${NC}Processing MY_SERVER: $MY_SERVER"

    # Check if the MY_SERVER is alive using ping
    if ping -c 1 -W 1 "$MY_SERVER" > /dev/null 2>&1; then
        echo -e "${GREEN}$MY_SERVER is alive${NC}"

        # Get the local public key
        local_key=$(cat ~/.ssh/id_rsa.pub)

        # Check if the local key is already in the remote authorized_keys file
        if ssh "$MY_SERVER" "grep -q '$local_key' ~/.ssh/authorized_keys"; then
            echo -e "${GREEN}Local key is already present on $MY_SERVER${NC}"
        else
            # Copy SSH key from localhost to remote MY_SERVER
            ssh-copy-id "$MY_SERVER"
            echo -e "${GREEN}SSH key copied from localhost to $MY_SERVER${NC}"
        fi

        # Check if the remote key is already in the local authorized_keys file
        remote_key=$(ssh "$MY_SERVER" "cat ~/.ssh/id_rsa.pub")
        if grep -q "$remote_key" ~/.ssh/authorized_keys; then
            echo -e "${GREEN}Remote key is already present on localhost${NC}"
        else
            # Copy SSH key from remote MY_SERVER to localhost
            ssh "$MY_SERVER" "ssh-copy-id localhost"
            echo -e "${GREEN}SSH key copied from $MY_SERVER to localhost${NC}"
        fi

        echo -e "${GREEN}SSH keys copied from localhost to $MY_SERVER, and from $MY_SERVER to localhost${NC}"
    else
        echo -e "${RED}$MY_SERVER is not alive${NC}"
    fi
done
