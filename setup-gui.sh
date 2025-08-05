#!/bin/bash

# Run CLI setup first
./setup-cli.sh

# Ensure XKBOPTIONS line is set to caps:escape
if grep -q '^XKBOPTIONS=' /etc/default/keyboard; then
  sudo sed -i 's|^XKBOPTIONS=.*|XKBOPTIONS="caps:escape"|' /etc/default/keyboard
else
  sudo echo 'XKBOPTIONS="caps:escape"' >> /etc/default/keyboard
fi

# GUI apps
sudo apt-get install keepassxc blender qgis -y

## VS Code
cd ~/Downloads
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    wget -O vscode.deb https://vscode.download.prss.microsoft.com/dbazure/download/stable/e54c774e0add60467559eb0d1e229c6452cf8447/code_1.97.2-1739406006_arm64.deb
else
    # otherwise assume x64
    wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868
fi
## VS Code will complain if these deps are missing
sudo apt install libsecret-1-0 libsecret-1-dev
DEBIAN_FRONTEND=noninteractive sudo dpkg -i vscode.deb

## Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
DEBIAN_FRONTEND=noninteractive sudo dpkg -i google-chrome-stable_current_amd64.deb

## Signal
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg;
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
### Add Signal repository to your list of repositories:
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
  sudo tee /etc/apt/sources.list.d/signal-xenial.list
### Update your package database and install Signal:
sudo apt update && sudo apt install signal-desktop
