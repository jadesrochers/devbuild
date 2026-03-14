#!/usr/bin/env bash
set -euo pipefail

echo ">>> Cloning repositories..."

clone_if_missing() {
    local repo_url="$1"
    local dest="$2"
    if [ ! -d "$dest/.git" ]; then
        sudo -u "$REAL_USER" git clone "$repo_url" "$dest"
    else
        echo "$(basename "$dest") already cloned, skipping."
    fi
}

# Create parent directories
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/dev" "$REAL_HOME/Data"

# Notes repositories
clone_if_missing "git@jadesrochers:jadesrochers/General_Notes.git" "$REAL_HOME/General_Notes"
clone_if_missing "git@jadesrochers:jadesrochers/Tutorial_Notes.git" "$REAL_HOME/Tutorial_Notes"

echo ">>> Repository cloning done."
echo "Note: SSH keys must be in place for git clone over SSH to work."
echo "      Run the iDrive restore script first if keys haven't been restored."
