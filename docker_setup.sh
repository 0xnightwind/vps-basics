#!/bin/bash
# Docker A-Z Setup Script for VPS
# Works on Ubuntu/Debian (adjusts automatically for CentOS/RHEL if detected)

set -e

echo "[*] Updating system packages..."
if [ -f /etc/debian_version ]; then
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        apt-transport-https \
        software-properties-common
elif [ -f /etc/redhat-release ]; then
    sudo yum update -y
    sudo yum install -y \
        yum-utils \
        device-mapper-persistent-data \
        lvm2
else
    echo "[!] Unsupported OS. Exiting."
    exit 1
fi

echo "[*] Installing Docker..."

if [ -f /etc/debian_version ]; then
    # Remove old versions if any
    sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

    # Add Docker’s official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add Docker repo
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

elif [ -f /etc/redhat-release ]; then
    sudo yum remove -y docker \
        docker-client \
        docker-client-latest \
        docker-common \
        docker-latest \
        docker-latest-logrotate \
        docker-logrotate \
        docker-engine || true

    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

echo "[*] Enabling and starting Docker..."
sudo systemctl enable docker
sudo systemctl start docker

echo "[*] Adding current user ($USER) to docker group..."
sudo usermod -aG docker $USER

echo "[*] Installing docker-compose (latest release)..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "[*] Verifying installation..."
docker --version
docker compose version
docker-compose --version

echo
echo "=================================================="
echo "[✔] Docker and Docker Compose installed successfully."
echo "-> You may need to log out and log back in for group changes to take effect."
echo "=================================================="
