#!/bin/bash

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define the path to the hosts file
HOSTS_FILE="/etc/hosts"

# Function to get the hostname and hostnamectl
get_hostname() {
    HOSTNAME=$(hostname)
    HOSTNAMECTL=$(hostnamectl --static)
}

# Function to get IP addresses from network adapters
get_ip_addresses() {
    # Get the list of network interfaces starting with "e", "zt", "br", "w", "enp", "eth", "en"
    INTERFACES=$(ip addr show | grep -E 'inet\s' | awk '{print $NF}' | grep -E '^e|^zt|^br0|^w|^enp|^eth|^en')

    # Initialize an empty array to store IP addresses
    IP_ADDRESSES=()

    # Loop through each interface and get its IP address
    for iface in $INTERFACES; do
        IP=$(ip addr show dev $iface | grep -E 'inet\s' | awk '{print $2}' | cut -d'/' -f1)
        if [ -n "$IP" ]; then
            IP_ADDRESSES+=("$IP")
        fi
    done
}

# Function to create the hosts file
create_hosts_file() {
    echo -e "${GREEN}Creating $HOSTS_FILE...${NC}"

    # Start with the local hostname and IP addresses
    echo -e "# Localhost entries" > "$HOSTS_FILE"
    echo -e "127.0.0.1\tlocalhost" >> "$HOSTS_FILE"
    echo -e "::1\tlocalhost" >> "$HOSTS_FILE"
    echo -e "127.0.1.1\t$HOSTNAME $HOSTNAMECTL" >> "$HOSTS_FILE"

    # Add IP addresses from network adapters
    for ip in "${IP_ADDRESSES[@]}"; do
        echo -e "$ip\t$HOSTNAME $HOSTNAMECTL" >> "$HOSTS_FILE"
    done

    # Add specific host configurations
    echo -e "\n# Specific host configurations" >> "$HOSTS_FILE"
    echo -e "10.10.10.121\tMY_SERVER1 MY_SERVER1.domain1.example.com MY_SERVER1.domain2.example.com" >> "$HOSTS_FILE"
    echo -e "10.10.10.122\tzima MY_SERVER2.domain2.example.com MY_SERVER2.domain1.example.com" >> "$HOSTS_FILE"
    echo -e "10.10.10.123\tMY_SERVER3 MY_SERVER3.domain1.example.com MY_SERVER3.domain2.example.com" >> "$HOSTS_FILE"
    echo -e "10.10.10.124\tMY_SERVER4 MY_SERVER4.domain1.example.com MY_SERVER4.domain2.example.com" >> "$HOSTS_FILE"
    echo -e "10.10.10.125\tMY_SERVER5 MY_SERVER5.domain1.example.com MY_SERVER5.domain2.example.com" >> "$HOSTS_FILE"
    echo -e "10.10.10.126\tMY_SERVER6 MY_SERVER6.domain1.example.com MY_SERVER6.domain2.example.com" >> "$HOSTS_FILE"
    echo -e "10.10.10.127\tMY_SERVER7 MY_SERVER7.domain1.example.com MY_SERVER7.domain2.example.com" >> "$HOSTS_FILE"
    echo -e "10.10.10.128\tMY_SERVER8 MY_SERVER8.domain1.example.com MY_SERVER8.domain2.example.com" >> "$HOSTS_FILE"
    echo -e "10.10.10.2\tsynology synology.domain1.example.com synology.domain2.example.com" >> "$HOSTS_FILE"
    echo -e "10.10.10.17\tgit.local git.domain1.example.com git.rhobyte.me" >> "$HOSTS_FILE"
    echo -e "172.122.22.121\tMY_SERVER1.local" >> "$HOSTS_FILE"
    echo -e "172.122.22.123\tMY_SERVER3.local" >> "$HOSTS_FILE"
    echo -e "172.122.22.124\tMY_SERVER4.local" >> "$HOSTS_FILE"
    echo -e "172.122.22.125\tMY_SERVER5.local" >> "$HOSTS_FILE"
    echo -e "172.122.22.126\tMY_SERVER6.local" >> "$HOSTS_FILE"
    echo -e "172.122.22.127\tMY_SERVER7.local" >> "$HOSTS_FILE"
    echo -e "172.122.22.128\tMY_SERVER8.local" >> "$HOSTS_FILE"
    echo -e "172.122.22.71\tgreen.local" >> "$HOSTS_FILE"
    echo -e "172.122.22.122\tzima.local" >> "$HOSTS_FILE"
    echo -e "172.122.22.2\tsynology.local" >> "$HOSTS_FILE"

    echo -e "${GREEN}$HOSTS_FILE created successfully.${NC}"
}

# Main function to create the hosts file
main() {
    echo "Creating /etc/hosts file..."

    # Get the hostname and hostnamectl
    get_hostname

    # Get IP addresses from network adapters
    get_ip_addresses

    # Create the hosts file
    create_hosts_file
}

# Run the main function
main
