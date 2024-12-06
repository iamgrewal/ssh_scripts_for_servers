#!/bin/bash

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color
GIT_SSH_PRIVATE_KEY="$HOME/.ssh/id_rsa_git"
GIT_SSH_PUBLIC_KEY="$HOME/.ssh/id_rsa_git.pub"
echo -e "${NC} Copying all Keys to authorized keys"
if [ ! -f "$GIT_SSH_PRIVATE_KEY" ]; then
cat ./git_id_ra > $GIT_SSH_PRIVATE_KEY
    echo -e "${RED} GIT PRIVATE FILE CREATED"
else
    echo -e "${GREEN} GIT PRIVATE FILE EXISTED"
fi
echo -e "${NC} now copying GIT PUBLIC KEY"
if [ ! -f "$GIT_SSH_PUBLIC_KEY" ]; then
    cat  ./git_id_rsa.pub > $GIT_SSH_PUBLIC_KEY"

    echo -e "${RED} GIT PUBLIC FILE CREATED"
else
    echo -e "${GREEN} GIT PUBLIC FILE EXISTED"
fi

bash /mymount/SUB//shell_scripts/ssh_files/create_ssh_config.sh

echo "Config Files Created"
# Function to sort and remove duplicates from authorized_keys
sudo /mymount/SUB//shell_scripts/ssh_files/copy_hosts_file.sh
sort_and_remove_duplicates() {
    echo -e "${GREEN}Copying all the new keys to the authorized keys"
    sleep 1
    sudo cat /mymount/SUB//authorized_keys/keys | tee -a ~/.ssh/authorized_keys
    sleep 1
    echo -e "${RED} Now removing Duplicates"
    sleep 1
    sort -u ~/.ssh/authorized_keys -o ~/.ssh/authorized_keys
    sleep 1
    echo -e "${GREEN}Sorted and removed duplicates from ~/.ssh/authorized_keys on this server g${NC}"
}
sort_and_remove_duplicates
cd $HOME
chmod u+rw,go-rwx "$HOME/.ssh/id_"*
chmod u+rw,go-rwx "$HOME/.ssh/id_"*.pub
chmod u+rw,go-rwx "$HOME/.ssh/authorized_keys"
chmod u+rw,go-rwx "$HOME/.ssh/known_hosts"
chmod u+rw,go-rwx "$HOME/.ssh/config"
