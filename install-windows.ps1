# Windows Setup Script

Write-Host "Starting Windows environment setup..." -ForegroundColor Cyan

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

# 7. The Silver Searcher (ag)
Install-WingetPackage "hercules-ci.ag" "The Silver Searcher"

# 8. Docker Desktop
Install-WingetPackage "Docker.DockerDesktop" "Docker Desktop"

Write-Host "`nSetup complete! You may need to restart your terminal for all changes to take effect." -ForegroundColor Cyan
