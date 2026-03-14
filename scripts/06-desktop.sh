#!/usr/bin/env bash
set -euo pipefail
: "${REAL_USER:?Must set REAL_USER}" "${REAL_HOME:?Must set REAL_HOME}"

# --- JetBrains Mono font ---
echo ">>> Installing JetBrains Mono font..."
FONT_DIR="$REAL_HOME/.local/share/fonts"
if [ ! -f "$FONT_DIR/JetBrainsMono-Regular.ttf" ]; then
    sudo -u "$REAL_USER" mkdir -p "$FONT_DIR"
    WORK_DIR=$(mktemp -d)
    curl -fsSL -o "$WORK_DIR/JetBrainsMono.zip" \
        "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip"
    unzip -qo "$WORK_DIR/JetBrainsMono.zip" "fonts/ttf/*" -d "$WORK_DIR"
    cp "$WORK_DIR"/fonts/ttf/*.ttf "$FONT_DIR/"
    chown -R "$REAL_USER:$REAL_USER" "$FONT_DIR"
    rm -rf "$WORK_DIR"
    fc-cache -f
    echo "JetBrains Mono installed. Set it as your terminal font in terminal preferences."
else
    echo "JetBrains Mono already installed."
fi

# --- GNOME extensions ---
echo ">>> Installing GNOME shell extensions..."
apt-get install -y \
    gnome-shell-extension-manager \
    gnome-shell-extensions

# Install specific extensions via apt where available
apt-get install -y gnome-shell-extension-appindicator || true

echo ""
echo ">>> Desktop polish done."
echo ""
echo "Recommended manual steps:"
echo "  1. Open Extension Manager and install:"
echo "     - Dash to Dock (taskbar/dock)"
echo "     - Clipboard Indicator (clipboard history)"
echo "  2. Set terminal font to 'JetBrains Mono' in terminal preferences"
echo "  3. Adjust font size to taste (13-14pt works well)"
