#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Require root for system-level installs
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo: sudo bash setup.sh"
    exit 1
fi

# Preserve the real user (not root) for user-level operations
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

export REAL_USER REAL_HOME SCRIPT_DIR

echo "=== Machine Setup for $REAL_USER ==="
echo "Home directory: $REAL_HOME"
echo ""

for script in "$SCRIPT_DIR"/scripts/[0-9]*.sh; do
    echo "----------------------------------------"
    echo "Running: $(basename "$script")"
    echo "----------------------------------------"
    bash "$script"
    echo ""
done

echo "=== Setup complete ==="
echo "Log out and back in for all changes to take effect."
