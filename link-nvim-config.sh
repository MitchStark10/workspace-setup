#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-$HOME/.config/nvim}"

backup_nvim_path() {
    local path="$1"
    local backup_path="${path}.bak"

    if [ -e "$backup_path" ] || [ -L "$backup_path" ]; then
        backup_path="${path}.bak.$(date +%Y%m%d%H%M%S)"
    fi

    echo "Backing up existing $(basename "$path") to $(basename "$backup_path")"
    mv "$path" "$backup_path"
}

link_nvim_file() {
    local name="$1"
    local repo_path="$SCRIPT_DIR/$name"
    local target_path="$NVIM_CONFIG_DIR/$name"

    if [ ! -e "$repo_path" ]; then
        echo "Warning: $repo_path not found, skipping symlink."
        return
    fi

    if [ -L "$target_path" ]; then
        if [ "$(readlink -f "$target_path")" = "$repo_path" ]; then
            echo "$name is already linked to this repository."
            return
        fi
        backup_nvim_path "$target_path"
    elif [ -e "$target_path" ]; then
        backup_nvim_path "$target_path"
    fi

    echo "Creating symlink for $name..."
    ln -s "$repo_path" "$target_path"
}

mkdir -p "$NVIM_CONFIG_DIR"

if [ -e "$NVIM_CONFIG_DIR/init.vim" ] || [ -L "$NVIM_CONFIG_DIR/init.vim" ]; then
    backup_nvim_path "$NVIM_CONFIG_DIR/init.vim"
fi

link_nvim_file "init.lua"
link_nvim_file "lua"
link_nvim_file "lazy-lock.json"
