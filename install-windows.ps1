# Windows Setup Script

Write-Host "Starting Windows environment setup..." -ForegroundColor Cyan

# 0. Dotfiles Symlinking
Write-Host "Setting up dotfiles..." -ForegroundColor Cyan
$REPO_BASHRC = Join-Path $PSScriptRoot ".bashrc"
$HOME_BASHRC = Join-Path $HOME ".bashrc"

if (Test-Path $REPO_BASHRC) {
    $item = Get-Item $HOME_BASHRC -ErrorAction SilentlyContinue
    if ($item -and $item.Attributes -match "ReparsePoint") {
        Write-Host ".bashrc is already a symlink." -ForegroundColor Green
    } else {
        if (Test-Path $HOME_BASHRC) {
            Write-Host "Backing up existing .bashrc to .bashrc.bak" -ForegroundColor Yellow
            Move-Item $HOME_BASHRC "$HOME_BASHRC.bak" -Force
        }
        Write-Host "Creating symlink for .bashrc..." -ForegroundColor Yellow
        New-Item -Path $HOME_BASHRC -ItemType SymbolicLink -Value $REPO_BASHRC
    }
} else {
    Write-Host "Warning: .bashrc not found in repo, skipping symlink." -ForegroundColor Gray
}

# Setup nvim config symlinks (init.lua, lua/, lazy-lock.json)
$NVIM_CONFIG_DIR = Join-Path $HOME ".config\nvim"
if (!(Test-Path $NVIM_CONFIG_DIR)) {
    New-Item -Path $NVIM_CONFIG_DIR -ItemType Directory -Force | Out-Null
}

function Link-NvimFile {
    param([string]$Name)
    $repoPath = Join-Path $PSScriptRoot $Name
    $targetPath = Join-Path $NVIM_CONFIG_DIR $Name

    if (!(Test-Path $repoPath)) {
        Write-Host "Warning: $Name not found in repo, skipping symlink." -ForegroundColor Gray
        return
    }

    $item = Get-Item $targetPath -ErrorAction SilentlyContinue
    if ($item -and $item.Attributes -match "ReparsePoint") {
        Write-Host "$Name is already a symlink." -ForegroundColor Green
    } else {
        if (Test-Path $targetPath) {
            Write-Host "Backing up existing $Name to $Name.bak" -ForegroundColor Yellow
            Move-Item $targetPath "$targetPath.bak" -Force
        }
        Write-Host "Creating symlink for $Name..." -ForegroundColor Yellow
        New-Item -Path $targetPath -ItemType SymbolicLink -Value $repoPath | Out-Null
    }
}

Link-NvimFile "init.lua"
Link-NvimFile "lua"
Link-NvimFile "lazy-lock.json"

# Ensure Winget is available
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget not found. Please install it from the Microsoft Store."
    exit 1
}

function Install-WingetPackage {
    param([string]$Id, [string]$Name)
    Write-Host "Checking for $Name..." -ForegroundColor Gray
    $check = winget list --id $Id -e
    if ($check -match $Id) {
        Write-Host "$Name is already installed." -ForegroundColor Green
    } else {
        Write-Host "Installing $Name..." -ForegroundColor Yellow
        winget install --id $Id -e --silent --accept-source-agreements --accept-package-agreements
    }
}

# 1. Git
Install-WingetPackage "Git.Git" "Git"

# 2. NVM for Windows
Install-WingetPackage "CoreyButler.NVMforWindows" "NVM for Windows"
# Note: Requires a new shell to use 'nvm' immediately, but we'll attempt to use it if found
if (Get-Command nvm -ErrorAction SilentlyContinue) {
    Write-Host "Installing Node LTS..." -ForegroundColor Yellow
    nvm install lts
    nvm use lts
}

# 3. .NET SDKs (8 and 10)
Install-WingetPackage "Microsoft.DotNet.SDK.8" ".NET SDK 8"
Install-WingetPackage "Microsoft.DotNet.SDK.10" ".NET SDK 10"

# 4. Python
Install-WingetPackage "Python.Python.3.12" "Python"

# 5. uv (Astral)
if (!(Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "Installing uv..." -ForegroundColor Yellow
    powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
} else {
    Write-Host "uv is already installed." -ForegroundColor Green
}

# 6. Neovim
Install-WingetPackage "Neovim.Neovim" "Neovim"

# 6.1 lazy.nvim self-bootstraps from init.lua on first launch, nothing to do here

# 6.2 Setup nvim as default for git
git config --global core.editor "nvim"

# 7. The Silver Searcher (ag)
Install-WingetPackage "hercules-ci.ag" "The Silver Searcher"

# 8. Docker Desktop
Install-WingetPackage "Docker.DockerDesktop" "Docker Desktop"

Write-Host "`nSetup complete! You may need to restart your terminal for all changes to take effect." -ForegroundColor Cyan
