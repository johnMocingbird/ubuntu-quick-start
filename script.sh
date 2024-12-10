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
chmod +x ubuntu_apps.sh
./ubuntu_apps.sh

# Copy files to the appropriate locations
echo "Setup complete!"
