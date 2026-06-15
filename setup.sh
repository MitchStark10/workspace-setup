#!/bin/bash

# Main Setup Entry Point

case "$(uname -s)" in
    Darwin)
        echo "Detected macOS."
        chmod +x ./install-mac.sh
        ./install-mac.sh
        ;;
    Linux)
        echo "Detected Linux."
        chmod +x ./install-linux.sh
        ./install-linux.sh
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
