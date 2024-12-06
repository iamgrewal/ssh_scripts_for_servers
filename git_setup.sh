#!/bin/bash

# Global variables
read -p "What is your Github Repo Name :- " REPO_NAME
read -p "What is your GITHUB Username  :- " GITHUB_USER
read -s -p "What is your GITHUB Personal Access Token :- " GITHUB_TOKEN
echo
REMOTE_URL="https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${REPO_NAME}.git"

# Function to check if a repository name is provided
validate_input() {
    if [[ -z "$REPO_NAME" ]]; then
        printf "Usage: %s <repository-name>\n" "$0" >&2
        return 1
    fi
}

# Function to create a local Git repository
create_local_repo() {
    mkdir -p "$REPO_NAME"
    cd "$REPO_NAME" || { printf "Failed to change directory to %s\n" "$REPO_NAME" >&2; return 1; }
    printf "# %s\n" "$REPO_NAME" >> README.md
    git init || { printf "Failed to initialize Git repository.\n" >&2; return 1; }
    git add README.md || { printf "Failed to add README.md to staging.\n" >&2; return 1; }
    git commit -m "first commit" || { printf "Failed to commit initial changes.\n" >&2; return 1; }
    git branch -M main || { printf "Failed to rename the branch to main.\n" >&2; return 1; }
    git remote add origin "$REMOTE_URL" || { printf "Failed to add remote repository.\n" >&2; return 1; }
    git push -u origin main || { printf "Failed to push to remote repository.\n" >&2; return 1; }
}

# Main function
main() {
    validate_input || return 1
    create_local_repo || return 1
    printf "Repository %s has been successfully created and synchronized with the remote repository.\n" "$REPO_NAME"
}

main "$@"