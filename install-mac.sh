#!/bin/bash

# macOS Setup Script

echo "Starting macOS environment setup..."

# 0. Dotfiles Setup
echo "Setting up dotfiles..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

copy_dotfile() {
    local name="$1"
    local repo_path="$SCRIPT_DIR/$name"
    local target_path="$HOME/$name"

    if [ ! -e "$repo_path" ]; then
        echo "Warning: $repo_path not found, skipping copy."
        return
    fi

    if [ -f "$target_path" ] && [ ! -L "$target_path" ]; then
        echo "Backing up existing $name to $name.bak"
        cp "$target_path" "$target_path.bak"
    fi
    echo "Copying $name to $target_path..."
    cp "$repo_path" "$target_path"
}

# 0.1 Symlink .zshrc so terminal changes stay tracked in the repository
link_dotfile() {
    local name="$1"
    local repo_path="$SCRIPT_DIR/$name"
    local target_path="$HOME/$name"

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

link_dotfile ".zshrc"

# 0.2 Copy .gitconfig to the root directory ($HOME)
copy_dotfile ".gitconfig"

# 0.3 Copy .bashrc
copy_dotfile ".bashrc"

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

# 2. Oh My Zsh Setup
echo "Ensuring Oh My Zsh is installed..."
if ! command -v zsh &> /dev/null; then
    echo "Installing Zsh..."
    brew install zsh
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ] && [ -n "$ZSH_PATH" ]; then
    echo "Setting Zsh as default shell..."
    chsh -s "$ZSH_PATH" || true
fi

# 3. Git
brew install git

# 4. NVM (sh-compatible)
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

# 5. .NET SDKs (6, 8, and 10)
# Use official cask names; check brew search for availability
brew tap isen-ng/dotnet-sdk-versions # Common tap for specific dotnet versions
brew install --cask dotnet-sdk6
brew install --cask dotnet-sdk8
brew install --cask dotnet-sdk10

# 6. Python
brew install python

# 7. uv (Astral)
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv is already installed."
fi

# 8. Neovim
brew install neovim

# 8.1 lazy.nvim self-bootstraps from init.lua on first launch, nothing to do here

# 8.2 setup nvim as default editor in terminal


# 9. The Silver Searcher (ag)
brew install the_silver_searcher

# 10. Docker
brew install --cask docker
brew install docker-compose

echo "Setup complete! Please restart your shell to apply all changes."

