#!/bin/bash

# Exit on error
set -e

# Optional: get the current logged-in user or pass one as argument
TARGET_USER="${1:-$USER}"

echo "🚀 Setting up Docker and Docker Compose for user: $TARGET_USER"

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install required dependencies
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update again with Docker repo
sudo apt update

# Install latest Docker and Docker Compose v2
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Add user to docker group (dynamically)
sudo usermod -aG docker "$TARGET_USER"

# Enable Docker on boot
sudo systemctl enable docker

# Success message
echo -e "\n✅ Docker and Docker Compose installed successfully!"
echo -e "👉 User '$TARGET_USER' added to the 'docker' group.\n"

# Remind to reload group membership
if [ "$USER" == "$TARGET_USER" ]; then
    echo "⚠️  You must log out and log back in OR run: newgrp docker"
else
    echo "ℹ️  Make sure user '$TARGET_USER' logs out and back in or runs: newgrp docker"
fi

# Verify versions
docker --version
docker compose version
