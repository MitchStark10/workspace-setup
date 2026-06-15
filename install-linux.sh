#!/bin/bash

# Linux (Ubuntu/Debian) Setup Script

echo "Starting Linux environment setup..."

# Disable advanced tiling, just let me move my stuff around
gsettings set org.gnome.shell.extensions.tiling-assistant enable-tiling-popup "false"

# Ensure the package list is up to date and curl is installed
echo "Updating package lists..."
sudo apt update && sudo apt install -y curl build-essential wget gpg

# 1. Linux equivalent of Homebrew checks (Using native apt package manager instead)
echo "Using native apt package manager for system utilities."

# 2. Git
echo "Installing Git..."
sudo apt install -y git

# 3. NVM (sh-compatible)
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    # Source NVM immediately for current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    echo "NVM is already installed."
fi

# Install Node LTS via NVM
# (Ensuring NVM is loaded in case the script is run in a non-interactive shell)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

# 4. .NET SDKs (8 and 10)
# Registers the Microsoft package repository and installs the SDKs natively
echo "Installing .NET SDKs..."
declare -r MicrosoftPackagesUrl="https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
if wget -q "$MicrosoftPackagesUrl" -O packages-microsoft-prod.deb; then
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt update
fi
sudo apt install -y dotnet-sdk-8.0 dotnet-sdk-10.0

# 5. Python
echo "Installing Python and pip..."
sudo apt install -y python3 python3-pip python3-venv

# 6. uv (Astral)
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv is already installed."
fi

# 7. Neovim
echo "Installing Neovim..."
sudo apt install -y neovim

# 7.1 install vim-plug
echo "Installing vim-plug..."
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# 7.2 setup nvim as default editor in terminal
echo "Setting Neovim as default editor..."
# Set for current session
export EDITOR='nvim'
export VISUAL='nvim'
# Append to .bashrc so it persists across restarts
if ! grep -q "export EDITOR='nvim'" "$HOME/.bashrc"; then
    echo -e "\n# Set Neovim as default editor\nexport EDITOR='nvim'\nexport VISUAL='nvim'" >> "$HOME/.bashrc"
fi

# 8. The Silver Searcher (ag)
echo "Installing The Silver Searcher..."
sudo apt install -y silversearcher-ag

# 9. Docker (Installs Docker Engine natively rather than Docker Desktop GUI)
echo "Installing Docker Engine..."
if ! command -v docker &> /dev/null; then
    sudo apt install -y docker.io
    # Allow running docker commands without sudo (requires re-login to take effect)
    sudo usermod -aG docker $USER
else
    echo "Docker is already installed."
fi

# 10. Spotify
echo "Installing Spotify..."
if ! command -v spotify &> /dev/null; then
    curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update && sudo apt install -y spotify-client
else
    echo "Spotify is already installed."
fi

# 11. Bitwarden
echo "Installing Bitwarden..."
if ! command -v bitwarden &> /dev/null; then
    sudo snap install bitwarden
else
    echo "Bitwarden is already installed."
fi

echo "Setup complete! Please log out and log back in (or restart your terminal) to apply all changes."
