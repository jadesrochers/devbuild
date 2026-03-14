# Dev Machine Setup

Shell scripts to provision a fresh Ubuntu install with my full development environment.

## Quick Start

After a fresh Ubuntu Desktop install:

```bash
# Install git (may already be present)
sudo apt install -y git

# Clone this repo (use HTTPS initially since SSH keys aren't set up yet)
git clone https://github.com/jadesrochers/dev_machine.git
cd dev_machine

# Run everything
sudo bash setup.sh
```

## What It Does

| Script | Purpose |
|--------|---------|
| `01-system.sh` | System update, core packages, Caps Lock → Ctrl |
| `02-shell.sh` | bashrc, fzf, ripgrep, git config, SSH config |
| `03-development.sh` | Docker, Python, NVM/Node.js, Java |
| `04-neovim.sh` | Neovim (unstable PPA), plugins, LSP, Copilot |
| `05-applications.sh` | Brave, Firefox, GIMP, digiKam, Hugin, LibreOffice, VLC |
| `06-desktop.sh` | JetBrains Mono font, GNOME extensions |
| `07-repos.sh` | Clone General_Notes and Tutorial_Notes |
| `08-idrive-restore.sh` | iDrive setup for restoring keys and photos |

## Running Individual Scripts

Each script can be run independently:

```bash
sudo bash scripts/04-neovim.sh
```

The scripts use `REAL_USER` and `REAL_HOME` env vars (set by `setup.sh`). When running individually:

```bash
export REAL_USER=$USER REAL_HOME=$HOME SCRIPT_DIR=$(pwd)
sudo -E bash scripts/04-neovim.sh
```

## Post-Setup Manual Steps

1. **iDrive restore**: Follow the prompts from `08-idrive-restore.sh` to restore SSH keys and photos
2. **Neovim**: Run `:Copilot auth` and `:Mason` on first launch
3. **Terminal font**: Set to "JetBrains Mono" in terminal preferences
4. **GNOME extensions**: Install Dash to Dock and Clipboard Indicator via Extension Manager
5. **Log out and back in** for docker group and keyboard changes to take effect
