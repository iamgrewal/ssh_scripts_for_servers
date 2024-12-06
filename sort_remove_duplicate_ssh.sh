#!/bin/bash

# List of nodes
nodes=("MY_SERVER5" "MY_SERVER6" "MY_SERVER7" "MY_SERVER8" "MY_SERVER1" "MY_SERVER4" "MY_SERVER3")

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to sort and remove duplicates from authorized_keys
sort_and_remove_duplicates() {
    local MY_SERVER=$1
    echo -e "Processing MY_SERVER: ${GREEN}$MY_SERVER${NC}"

    # Check if the MY_SERVER is alive using ping
    if ping -c 1 -W 1 "$MY_SERVER" > /dev/null 2>&1; then
        echo -e "${GREEN}$MY_SERVER is alive${NC}"

        # Attempt to log in to the remote MY_SERVER
        if ssh -o ConnectTimeout=5 "$MY_SERVER" "echo 'I can log in to $MY_SERVER'"; then
            echo -e "${GREEN}Successfully logged in to $MY_SERVER${NC}"

            # Sort and remove duplicates from ~/.ssh/authorized_keys
            ssh "$MY_SERVER" "sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys"
            echo -e "${GREEN}Sorted and removed duplicates from ~/.ssh/authorized_keys on $MY_SERVER${NC}"
        else
            echo -e "${RED}Failed to log in to $MY_SERVER${NC}"
        fi
    else
        echo -e "${RED}$MY_SERVER is not alive${NC}"
    fi
}

# Loop through each MY_SERVER
for MY_SERVER in "${nodes[@]}"; do
    sort_and_remove_duplicates "$MY_SERVER"
done
