#!/bin/bash

# macOS Setup Script

echo "Starting macOS environment setup..."

# 0. Dotfiles Symlinking
echo "Setting up dotfiles..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_BASHRC="$SCRIPT_DIR/.bashrc"
HOME_BASHRC="$HOME/.bashrc"

if [ -f "$REPO_BASHRC" ]; then
    if [ -L "$HOME_BASHRC" ]; then
        echo ".bashrc is already a symlink."
    else
        if [ -f "$HOME_BASHRC" ]; then
            echo "Backing up existing .bashrc to .bashrc.bak"
            mv "$HOME_BASHRC" "$HOME_BASHRC.bak"
        fi
        echo "Creating symlink for .bashrc..."
        ln -s "$REPO_BASHRC" "$HOME_BASHRC"
    fi
else
    echo "Warning: $REPO_BASHRC not found, skipping symlink."
fi

# Setup nvim config symlinks (init.lua, lua/, lazy-lock.json)
NVIM_CONFIG_DIR="$HOME/.config/nvim"
mkdir -p "$NVIM_CONFIG_DIR"

link_nvim_file() {
    local name="$1"
    local repo_path="$SCRIPT_DIR/$name"
    local target_path="$NVIM_CONFIG_DIR/$name"

    if [ ! -e "$repo_path" ]; then
        echo "Warning: $repo_path not found, skipping symlink."
        return
    fi

    if [ -L "$target_path" ]; then
        echo "$name is already a symlink."
    else
        if [ -e "$target_path" ]; then
            echo "Backing up existing $name to $name.bak"
            mv "$target_path" "$target_path.bak"
        fi
        echo "Creating symlink for $name..."
        ln -s "$repo_path" "$target_path"
    fi
}

link_nvim_file "init.lua"
link_nvim_file "lua"
link_nvim_file "lazy-lock.json"

# 1. Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# 2. Git
brew install git

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
nvm install --lts
nvm use --lts

# 4. .NET SDKs (8 and 10)
# Use official cask names; check brew search for availability
brew tap isen-ng/dotnet-sdk-versions # Common tap for specific dotnet versions
brew install --cask dotnet-sdk8
brew install --cask dotnet-sdk10

# 5. Python
brew install python

# 6. uv (Astral)
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv is already installed."
fi

# 7. Neovim
brew install neovim

# 7.1 lazy.nvim self-bootstraps from init.lua on first launch, nothing to do here

# 7.2 setup nvim as default editor in terminal


# 8. The Silver Searcher (ag)
brew install the_silver_searcher

# 9. Docker
brew install --cask docker

echo "Setup complete! Please restart your shell to apply all changes."
