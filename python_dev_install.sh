#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y

echo -e "${GREEN}Installing dependencies...${NC}"
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev git unzip

# Install pyenv
if [ ! -d "$HOME/.pyenv" ]; then
    echo -e "${GREEN}Installing pyenv...${NC}"
    curl https://pyenv.run | bash
else
    echo -e "${GREEN}pyenv already installed.${NC}"
fi

# Ensure python is available system-wide
if ! command -v python &>/dev/null; then
    echo -e "${GREEN}Linking python to python3 system-wide...${NC}"
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
else
    echo -e "${GREEN}python already available system-wide.${NC}"
fi

# Alias python=python3 in .bashrc if not already present
if ! grep -q '^alias python=python3' ~/.bashrc; then
    echo -e "${GREEN}Adding alias python=python3 to .bashrc...${NC}"
    echo "alias python=python3" >> ~/.bashrc
fi

# Set up pyenv in shell
if ! grep -q 'pyenv init' ~/.bashrc; then
    echo -e "${GREEN}Adding pyenv to .bashrc...${NC}"
    echo -e '\n# Pyenv setup' >> ~/.bashrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
fi

# Reload pyenv setup for current shell
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Ensure ensurepip is available (should be in base Python install)
echo -e "${GREEN}Installing pipx and virtualenv...${NC}"
python -m ensurepip --upgrade

# Install pipx using ensurepip
python -m pip install --user pipx
python -m pipx ensurepath

# Install virtualenv (optionally with pip or pipx)
python -m pip install --user virtualenv


source ~/.bashrc
