#!/usr/bin/env sh

set -e

if command -v pwsh > /dev/null 2>&1; then
	echo "PowerShell Core is already installed on your system."
	exit 0;
fi

echo "PowerShell Core not found. Installing it..."

OS =$(uname -s)

if [ "$OS" = "Linux" ]; then
	# Install PowerShell Core on Linux
	if [ -f /etc/os-release ]; then
		. /etc/os-release
		case "$ID" in
			ubuntu|debian)
				sudo apt-get update
				sudo apt-get install -y wget apt-transport-https software-properties-common
				wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb
				sudo dpkg -i packages-microsoft-prod.deb
				sudo apt-get update
				sudo apt-get install -y powershell
				;;
			fedora)
				sudo dnf install -y powershell
				;;
			*)
				echo "Unsupported Linux distribution: $ID"
				exit 1;
				;;
		esac
	else
		echo "Cannot determine Linux distribution."
		exit 1;
	fi
elif [ "$OS" = "Darwin" ]; then
	# Install PowerShell Core on macOS using Homebrew
	if command -v brew > /dev/null 2>&1; then
		brew install --cask powershell
	else
		echo "Homebrew is not installed. Please install Homebrew first."
		exit 1;
	fi
else
	echo "Unsupported operating system: $OS"
	exit 1;
fi