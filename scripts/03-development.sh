#!/usr/bin/env bash
set -euo pipefail
: "${REAL_USER:?Must set REAL_USER}" "${REAL_HOME:?Must set REAL_HOME}"

# --- Docker ---
echo ">>> Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
else
    echo "Docker already installed, skipping."
fi

# Add user to docker group
usermod -aG docker "$REAL_USER" || true
echo "Note: Log out and back in for docker group membership to take effect."

# --- Python ---
echo ">>> Installing Python development packages..."
apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev

# --- Node.js via NVM ---
echo ">>> Installing NVM and Node.js..."
if [ ! -d "$REAL_HOME/.nvm" ]; then
    sudo -u "$REAL_USER" bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash'
    # Install latest LTS node
    sudo -u "$REAL_USER" bash -c 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install --lts && nvm alias default node'
else
    echo "NVM already installed, skipping."
fi

# --- Java ---
echo ">>> Installing Java (OpenJDK)..."
apt-get install -y default-jdk

echo ">>> Development tools done."
