#!/bin/bash

# Main Setup Entry Point

case "$(uname -s)" in
    Darwin)
        echo "Detected macOS."
        chmod +x ./install-mac.sh
        ./install-mac.sh
        ;;
    Linux)
        echo "Linux detected (not explicitly requested, but often works with macOS script)."
        chmod +x ./install-mac.sh
        ./install-mac.sh
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "Detected Windows (via Shell)."
        powershell.exe -ExecutionPolicy Bypass -File ./install-windows.ps1
        ;;
    *)
        echo "Unsupported OS: $(uname -s)"
        exit 1
        ;;
esac
