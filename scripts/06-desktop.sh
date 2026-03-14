#!/usr/bin/env bash
set -euo pipefail

# --- JetBrains Mono font ---
echo ">>> Installing JetBrains Mono font..."
FONT_DIR="$REAL_HOME/.local/share/fonts"
if [ ! -f "$FONT_DIR/JetBrainsMono-Regular.ttf" ]; then
    sudo -u "$REAL_USER" mkdir -p "$FONT_DIR"
    TMPDIR=$(mktemp -d)
    curl -fsSL -o "$TMPDIR/JetBrainsMono.zip" \
        "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip"
    unzip -qo "$TMPDIR/JetBrainsMono.zip" "fonts/ttf/*" -d "$TMPDIR"
    cp "$TMPDIR"/fonts/ttf/*.ttf "$FONT_DIR/"
    chown -R "$REAL_USER:$REAL_USER" "$FONT_DIR"
    rm -rf "$TMPDIR"
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
