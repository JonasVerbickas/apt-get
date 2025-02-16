#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install git -y
sudo apt-get install chromium -y

sudo apt-get install python3-poetry -y

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

# VSCODE
cd ~/Downloads
# wget -O vscode_x64.deb https://go.microsoft.com/fwlink/?LinkID=760868
wget -O vscode_arm.deb https://vscode.download.prss.microsoft.com/dbazure/download/stable/e54c774e0add60467559eb0d1e229c6452cf8447/code_1.97.2-1739406006_arm64.deb
sudo dpkg -i vscode_arm.deb

# TERMINAL
sudo apt-get install tmux btop podman -y
## better search via arrow keys
echo -e '"\e[A": history-search-backward\n"\e[B": history-search-forward' >> ~/.inputrc
## oh-my-zsh like config
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh

# NVM
# install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# install Node v20
nvm i 20
