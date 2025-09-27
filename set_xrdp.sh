#!/bin/bash
# XRDP Setup Script with GNOME and UFW Firewall
# User chooses XRDP port at runtime

set -e

echo "[*] Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "[*] Installing GNOME desktop environment..."
sudo apt install -y ubuntu-gnome-desktop

echo "[*] Installing XRDP..."
sudo apt install -y xrdp
sudo adduser "$USER" ssl-cert

# Prompt user for custom XRDP port (default: 3389)
read -p "Enter XRDP port [default: 3389]: " XRDP_PORT
XRDP_PORT=${XRDP_PORT:-3389}

echo "[*] Changing XRDP port to $XRDP_PORT..."
sudo sed -i "s/3389/$XRDP_PORT/g" /etc/xrdp/xrdp.ini
sudo systemctl enable xrdp
sudo systemctl restart xrdp

echo "[*] Installing and configuring UFW firewall..."
sudo apt install -y ufw
sudo ufw allow ${XRDP_PORT}/tcp
sudo ufw allow 22/tcp
sudo ufw --force enable
sudo ufw reload

echo
echo "=================================================="
echo "[✔] XRDP installed and configured."
echo "-> Connect with RDP client on port $XRDP_PORT"
echo "-> Desktop environment: GNOME"
echo "=================================================="
