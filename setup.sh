#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y

# GIT
sudo apt-get install git -y
git config --global user.name "JonasVerbickas" && git config --global user.email "jonasverbic@gmail.com"
git config --global core.editor "nvim"

# NEOVIM
## install neovim prerequisites
sudo apt-get install ninja-build gettext cmake curl build-essential -y
## install neovim
mkdir git
cd git
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
## install kickstart
git clone https://github.com/nvim-lua/kickstart.nvim ~/.config/nvim

# Ensure XKBOPTIONS line is set to caps:escape
if grep -q '^XKBOPTIONS=' /etc/default/keyboard; then
  sudo sed -i 's|^XKBOPTIONS=.*|XKBOPTIONS="caps:escape"|' /etc/default/keyboard
else
  sudo echo 'XKBOPTIONS="caps:escape"' >> /etc/default/keyboard
fi

# TERMINAL
sudo apt-get install tmux btop python3-poetry -y
## better search via arrow keys
echo -e '"\e[A": history-search-backward\n"\e[B": history-search-forward' >>~/.inputrc
## oh-my-zsh like config
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh -s # silent install without users prompts

# NVM
# install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# PODMAN with NVIDIA support
sudo apt-get install podman -y
# Check if NVIDIA GPU is present
if lspci | grep -i nvidia >/dev/null; then
    echo "NVIDIA GPU detected, installing NVIDIA container toolkit..."
    # install nvidia-container-toolkit
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
        curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    sudo apt-get update
    sudo apt-get install -y nvidia-container-toolkit
    # allow podman to use nvidia devices
    sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
    # test if podman is able to reach nvidia devices
    podman run --rm --device nvidia.com/gpu=all ubuntu nvidia-smi
else
    echo "No NVIDIA GPU detected, skipping NVIDIA container toolkit installation"
fi

# GUI apps
sudo apt-get install keepassxc -y

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

