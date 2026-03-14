#!/usr/bin/env bash
set -euo pipefail
: "${REAL_USER:?Must set REAL_USER}" "${REAL_HOME:?Must set REAL_HOME}"

echo ">>> iDrive Backup Restore Setup"
echo ""
echo "This script sets up iDrive and restores critical data:"
echo "  - ~/Data/keys/           (SSH keys and important credentials)"
echo "  - ~/Data/filed_pictures/ (photo collection, ~185GB)"
echo ""

# Create restore target directories
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/Data/keys"
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/Data/filed_pictures"

# --- Install iDrive CLI ---
echo ">>> Installing iDrive dependencies..."
apt-get install -y perl-base libfile-spec-native-perl build-essential

IDRIVE_DIR="$REAL_HOME/idrive"

if [ ! -d "$IDRIVE_DIR" ]; then
    echo ">>> Downloading iDrive Linux client..."
    WORK_DIR=$(mktemp -d)
    curl -fsSL -o "$WORK_DIR/IDriveForLinux.zip" \
        "https://www.idrivedownloads.com/downloads/linux/download-for-linux/LinuxScripts/IDriveForLinux.zip"
    sudo -u "$REAL_USER" unzip -qo "$WORK_DIR/IDriveForLinux.zip" -d "$REAL_HOME/"
    rm -rf "$WORK_DIR"
    echo "iDrive client extracted to $IDRIVE_DIR"
else
    echo "iDrive directory already exists, skipping download."
fi

echo ""
echo "============================================"
echo "  iDrive Manual Steps Required"
echo "============================================"
echo ""
echo "1. Set up your iDrive account:"
echo "   cd $IDRIVE_DIR/scripts"
echo "   perl account_setting.pl"
echo "   (Account: jadesrochers@gmail.com)"
echo ""
echo "2. Restore SSH keys first (needed for git operations):"
echo "   perl restore_data.pl"
echo "   - Select the backup set containing Data/keys"
echo "   - Restore to: $REAL_HOME/Data/keys/"
echo ""
echo "3. Copy restored SSH keys into place:"
echo "   cp ~/Data/keys/jad-github-* ~/.ssh/"
echo "   cp ~/Data/keys/github_access_* ~/.ssh/"
echo "   chmod 600 ~/.ssh/jad-github-* ~/.ssh/github_access_*"
echo ""
echo "4. Restore photo collection (large, run overnight):"
echo "   perl restore_data.pl"
echo "   - Select the backup set containing Data/filed_pictures"
echo "   - Restore to: $REAL_HOME/Data/filed_pictures/"
echo ""
echo "============================================"
