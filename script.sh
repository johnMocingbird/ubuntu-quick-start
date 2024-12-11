#!/bin/bash

set -e # Exit on any error

# Update and Upgrade the system
echo "Updating and upgrading the system..."
sudo apt update
sudo apt upgrade -y

# Remove unwanted packages
echo "Removing unwanted applications..."
sudo apt remove -y \
	libreoffice* \
	shotwell \
	rhythmbox \
	gnome-mines \
	gnome-sudoku \
	gedit \
	gnome-todo

# Clean up residual packages
echo "Cleaning up unnecessary files..."
sudo apt autoremove -y
sudo apt clean

# Install wget if not already installed
if ! type -p wget >/dev/null; then
	echo "Installing wget..."
	sudo apt-get install wget -y
fi

# Install xclip
echo "Installing xclip for clipboard functionality..."
sudo apt install -y xclip

# Install Neovim via Snap
echo "Installing Neovim..."
sudo snap install nvim --classic

# Install GitHub CLI
echo "Installing GitHub CLI..."
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
sudo apt update
sudo apt install -y gh

# Authenticate with GitHub CLI
echo "Please authenticate with GitHub CLI..."
gh auth login

# Clone required repositories
echo "Cloning required repositories..."
git clone git@github.com:johnMocingbird/mydots-stow.git

# Make the script executable and run it
cd mydots-stow
echo "Making 'ubuntu_apps.sh' executable and running it..."
set -e # Exit on error

echo "Setting up Firefox policies for Vimium..."

# Create the distribution directory if it doesn't exist
sudo mkdir -p /usr/lib/firefox/distribution

# Create the policies.json file
sudo tee /usr/lib/firefox/distribution/policies.json >/dev/null <<EOF
{
  "policies": {
    "Extensions": {
      "Install": [
        "https://addons.mozilla.org/firefox/downloads/file/4259790/vimium_ff-2.1.2.xpi"
      ]
    }
  }
}
EOF

echo "Vimium extension policy has been configured. Restart Firefox to apply the changes."

# Install i3
echo "Downloading and installing i3 keyring..."
/usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2024.03.04_all.deb keyring.deb SHA256:f9bb4340b5ce0ded29b7e014ee9ce788006e9bbfe31e96c09b2118ab91fca734
sudo apt install ./keyring.deb
rm -f keyring.deb

echo "Adding i3 repository..."
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list

echo "Updating package lists..."
sudo apt update

echo "Installing i3..."
sudo apt install i3 -y

# Install dmenu
echo "Installing dmenu..."
sudo apt install dmenu -y

# Install tmux
echo "Installing tmux..."
sudo apt install tmux -y

# Configure Neovim and Kitty
echo "removing old nvim configs"
rm -rf ~/.config/nvim/

echo "Setup complete!"
