#!/usr/bin/env bash
set -euo pipefail

# --- Firefox ---
echo ">>> Ensuring Firefox is installed..."
if ! command -v firefox &> /dev/null; then
    snap install firefox
else
    echo "Firefox already installed."
fi

# --- Brave ---
echo ">>> Installing Brave browser..."
if ! command -v brave-browser &> /dev/null; then
    curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
        tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
    apt-get update
    apt-get install -y brave-browser
else
    echo "Brave already installed."
fi

# --- GIMP ---
echo ">>> Installing GIMP..."
apt-get install -y gimp

# --- digiKam ---
echo ">>> Installing digiKam..."
apt-get install -y digikam

# --- Hugin ---
echo ">>> Installing Hugin panorama stitcher..."
apt-get install -y hugin

# --- LibreOffice ---
echo ">>> Ensuring LibreOffice is installed..."
if ! command -v libreoffice &> /dev/null; then
    apt-get install -y libreoffice
else
    echo "LibreOffice already installed."
fi

# --- VLC ---
echo ">>> Installing VLC..."
apt-get install -y vlc

echo ">>> Applications done."
