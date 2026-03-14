#!/usr/bin/env bash
set -euo pipefail
: "${REAL_USER:?Must set REAL_USER}" "${REAL_HOME:?Must set REAL_HOME}" "${SCRIPT_DIR:?Must set SCRIPT_DIR}"

echo ">>> Installing fzf..."
if [ ! -d "$REAL_HOME/.fzf" ]; then
    sudo -u "$REAL_USER" git clone --depth 1 https://github.com/junegunn/fzf.git "$REAL_HOME/.fzf"
    sudo -u "$REAL_USER" "$REAL_HOME/.fzf/install" --all --no-zsh --no-fish
else
    echo "fzf already installed, skipping."
fi

echo ">>> Installing ripgrep..."
apt-get install -y ripgrep

echo ">>> Deploying bashrc..."
cp "$SCRIPT_DIR/config/bashrc" "$REAL_HOME/.bashrc"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.bashrc"

echo ">>> Configuring SSH..."
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/.ssh"
chmod 700 "$REAL_HOME/.ssh"
# Only deploy ssh_config if one doesn't already exist (don't overwrite restored keys/config)
if [ ! -f "$REAL_HOME/.ssh/config" ]; then
    cp "$SCRIPT_DIR/config/ssh_config" "$REAL_HOME/.ssh/config"
    chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.ssh/config"
    chmod 600 "$REAL_HOME/.ssh/config"
else
    echo "SSH config already exists, skipping (may have been restored from backup)."
fi

echo ">>> Configuring git..."
sudo -u "$REAL_USER" git config --global user.name "jadesrochers"
sudo -u "$REAL_USER" git config --global user.email "jadesrochers@gmail.com"
sudo -u "$REAL_USER" git config --global core.editor "nvim"
sudo -u "$REAL_USER" git config --global credential.helper "cache --timeout 12000000"

echo ">>> Shell configuration done."
