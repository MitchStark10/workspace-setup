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

# Setup init.vim symlink
$REPO_INIT_VIM = Join-Path $PSScriptRoot "init.vim"
$NVIM_CONFIG_DIR = Join-Path $HOME ".config\nvim"
$NVIM_INIT_VIM = Join-Path $NVIM_CONFIG_DIR "init.vim"

if (Test-Path $REPO_INIT_VIM) {
    if (!(Test-Path $NVIM_CONFIG_DIR)) {
        New-Item -Path $NVIM_CONFIG_DIR -ItemType Directory -Force | Out-Null
    }
    $item = Get-Item $NVIM_INIT_VIM -ErrorAction SilentlyContinue
    if ($item -and $item.Attributes -match "ReparsePoint") {
        Write-Host "init.vim is already a symlink." -ForegroundColor Green
    } else {
        if (Test-Path $NVIM_INIT_VIM) {
            Write-Host "Backing up existing init.vim to init.vim.bak" -ForegroundColor Yellow
            Move-Item $NVIM_INIT_VIM "$NVIM_INIT_VIM.bak" -Force
        }
        Write-Host "Creating symlink for init.vim..." -ForegroundColor Yellow
        New-Item -Path $NVIM_INIT_VIM -ItemType SymbolicLink -Value $REPO_INIT_VIM
    }
} else {
    Write-Host "Warning: init.vim not found in repo, skipping symlink." -ForegroundColor Gray
}

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

# 6.1 Install vim-plug for neovim
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force

# 6.2 Setup nvim as default for git
git config --global core.editor "nvim"

# 7. The Silver Searcher (ag)
Install-WingetPackage "hercules-ci.ag" "The Silver Searcher"

# 8. Docker Desktop
Install-WingetPackage "Docker.DockerDesktop" "Docker Desktop"

Write-Host "`nSetup complete! You may need to restart your terminal for all changes to take effect." -ForegroundColor Cyan
