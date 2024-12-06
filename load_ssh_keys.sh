#!/bin/bash

# Define paths to the SSH keys
LOCAL_SERVER_KEY="$home/.ssh/id_rsa"
GIT_KEY="$home/.ssh/id_rsa_git"

# Define the SSH agent output file
SSH_AGENT_OUTPUT="$HOME/.ssh/agent_out"

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if the SSH agent is running and start it if not
start_ssh_agent() {
    if ! ps -p $SSH_AGENT_PID &> /dev/null; then
        echo -e "${GREEN}Starting SSH agent...${NC}"
        ssh-agent > "$SSH_AGENT_OUTPUT"
        source "$SSH_AGENT_OUTPUT" &> /dev/null
    else
        echo -e "${GREEN}SSH agent is already running.${NC}"
    fi
}

# Function to add SSH keys to the agent
add_ssh_keys() {
    echo -e "${GREEN}Adding SSH keys to the agent...${NC}"
    ssh-add "$LOCAL_SERVER_KEY"
    ssh-add "$GIT_KEY"
}

# Main function to load SSH keys
load_ssh_keys() {
    echo "Loading SSH keys..."

    # Start the SSH agent if not running
    start_ssh_agent

    # Add SSH keys to the agent
    add_ssh_keys

    echo -e "${GREEN}SSH keys loaded successfully.${NC}"
}

# Run the main function
load_ssh_keys
