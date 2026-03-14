#!/usr/bin/env bash
set -euo pipefail
: "${REAL_USER:?Must set REAL_USER}" "${REAL_HOME:?Must set REAL_HOME}"

echo ">>> Cloning repositories..."

clone_if_missing() {
    local repo_url="$1"
    local dest="$2"
    if [ ! -d "$dest/.git" ]; then
        if sudo -u "$REAL_USER" git clone "$repo_url" "$dest"; then
            echo "$(basename "$dest") cloned successfully."
        else
            echo "WARNING: Failed to clone $(basename "$dest"). SSH keys may not be in place yet."
            echo "         Restore keys via iDrive first, then re-run: sudo -E bash scripts/07-repos.sh"
        fi
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
