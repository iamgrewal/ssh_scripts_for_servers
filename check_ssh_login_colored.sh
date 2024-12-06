#!/bin/bash

source ./parse_inventory.sh

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse inventory
parse_inventory

# Loop through each server
for i in "${!SERVER_NAMES[@]}"; do
    SERVER="${SERVER_NAMES[$i]}"
    echo -e "Processing server: ${GREEN}$SERVER${NC}"

    if ping -c 1 -W 1 "$SERVER" > /dev/null 2>&1; then
        echo -e "${GREEN}$SERVER is alive${NC}"

        if ssh -o ConnectTimeout=5 -o BatchMode=yes "$SERVER" "echo 'I can log in to $SERVER'"; then
            echo -e "${GREEN}Successfully logged in to $SERVER${NC}"

            if ssh -o ConnectTimeout=5 -o BatchMode=yes "$SERVER" "ssh -o ConnectTimeout=5 -o BatchMode=yes localhost 'echo \"I can log in from $SERVER to localhost\"'"; then
                echo -e "${GREEN}Successfully logged in from $SERVER to localhost${NC}"
            else
                echo -e "${RED}Failed to log in from $SERVER to localhost${NC}"
            fi
        else
            echo -e "${RED}Failed to log in to $SERVER${NC}"
        fi
    else
        echo -e "${RED}$SERVER is not alive${NC}"
    fi
done
