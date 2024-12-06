#!/bin/bash

# Define the path to the SSH configuration file and private key
SSH_CONFIG_FILE="$HOME/.ssh/config"
PRIVATE_KEY_FILE="$HOME/.ssh/id_rsa"
PUBLIC_KEY_FILE="$HOME/.ssh/id_rsa.pub"

# Define the server to revalidate
SERVER="localhost"

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if the private key is correctly configured in the SSH config file
check_ssh_config() {
    if grep -q "IdentityFile $PRIVATE_KEY_FILE" "$SSH_CONFIG_FILE"; then
        echo -e "${GREEN}Private key is correctly configured in $SSH_CONFIG_FILE${NC}"
    else
        echo -e "${RED}Private key is not correctly configured in $SSH_CONFIG_FILE${NC}"
        echo "Adding private key to $SSH_CONFIG_FILE..."
        echo "    IdentityFile $PRIVATE_KEY_FILE" >> "$SSH_CONFIG_FILE"
        echo -e "${GREEN}Private key added to $SSH_CONFIG_FILE${NC}"
    fi
}

# Function to check if the public key is present in the authorized_keys file on the server
check_authorized_keys() {
    if ssh "$SERVER" "grep -q '$(cat $PUBLIC_KEY_FILE)' ~/.ssh/authorized_keys"; then
        echo -e "${GREEN}Public key is present in ~/.ssh/authorized_keys on $SERVER${NC}"
    else
        echo -e "${RED}Public key is not present in ~/.ssh/authorized_keys on $SERVER${NC}"
        echo "Adding public key to ~/.ssh/authorized_keys on $SERVER..."
        cat "$PUBLIC_KEY_FILE" | ssh "$SERVER" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
        echo -e "${GREEN}Public key added to ~/.ssh/authorized_keys on $SERVER${NC}"
    fi
}

# Main function to revalidate the private key
revalidate_private_key() {
    echo "Revalidating private key with $SERVER..."

    # Check if the SSH configuration file exists
    if [ ! -f "$SSH_CONFIG_FILE" ]; then
        echo -e "${RED}$SSH_CONFIG_FILE does not exist. Creating it...${NC}"
        mkdir -p "$(dirname "$SSH_CONFIG_FILE")"
        touch "$SSH_CONFIG_FILE"
    fi

    # Check if the private key file exists
    if [ ! -f "$PRIVATE_KEY_FILE" ]; then
        echo -e "${RED}$PRIVATE_KEY_FILE does not exist. Please create or copy the private key.${NC}"
        exit 1
    fi

    # Check if the public key file exists
    if [ ! -f "$PUBLIC_KEY_FILE" ]; then
        echo -e "${RED}$PUBLIC_KEY_FILE does not exist. Please create or copy the public key.${NC}"
        exit 1
    fi

    # Check SSH configuration
    check_ssh_config

    # Check authorized_keys on the server
    check_authorized_keys

    echo -e "${GREEN}Private key revalidation complete.${NC}"
}

# Run the main function
revalidate_private_key
