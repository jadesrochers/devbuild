#!/usr/bin/env bash
set -euo pipefail
: "${SCRIPT_DIR:?Must set SCRIPT_DIR (run via setup.sh or export manually)}"

echo ">>> Updating system packages..."
apt-get update
apt-get upgrade -y

echo ">>> Installing core system packages..."
apt-get install -y \
    build-essential \
    cmake \
    curl \
    wget \
    git \
    pkg-config \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    unzip \
    xclip

echo ">>> Configuring keyboard (Caps Lock -> Ctrl)..."
cp "$SCRIPT_DIR/config/keyboard" /etc/default/keyboard
dpkg-reconfigure -f noninteractive keyboard-configuration

echo ">>> System packages done."
