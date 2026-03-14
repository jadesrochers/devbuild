#!/usr/bin/env bash
set -euo pipefail
: "${REAL_USER:?Must set REAL_USER}" "${REAL_HOME:?Must set REAL_HOME}" "${SCRIPT_DIR:?Must set SCRIPT_DIR}"

echo ">>> Installing Neovim (unstable PPA)..."
add-apt-repository -y ppa:neovim-ppa/unstable
apt-get update
apt-get install -y neovim

echo ">>> Setting Neovim as default editor..."
update-alternatives --set editor /usr/bin/nvim || \
    update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

echo ">>> Deploying Neovim config..."
sudo -u "$REAL_USER" mkdir -p "$REAL_HOME/.config/nvim"
cp "$SCRIPT_DIR/config/init.vim" "$REAL_HOME/.config/nvim/init.vim"
chown "$REAL_USER:$REAL_USER" "$REAL_HOME/.config/nvim/init.vim"

echo ">>> Installing vim-plug..."
sudo -u "$REAL_USER" bash -c '
    curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
'

echo ">>> Installing Neovim plugins (headless)..."
sudo -u "$REAL_USER" nvim --headless +PlugInstall +qall 2>/dev/null || true

echo ">>> Installing Treesitter parsers (headless)..."
sudo -u "$REAL_USER" nvim --headless "+TSInstall all" +qall 2>/dev/null || true

echo ">>> Neovim setup done."
echo "Note: Run :Mason inside Neovim on first launch to install language servers."
echo "Note: Run :Copilot auth inside Neovim to authenticate GitHub Copilot."
