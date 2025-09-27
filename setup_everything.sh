#!/bin/bash
# Master Setup Script to run all setup scripts

set -e

echo "======================================"
echo "[*] Starting full VPS setup..."
echo "======================================"

# Ensure scripts are executable
chmod +x basics.sh docker_setup.sh set_xrdp.sh

echo "[1/3] Running basics.sh..."
./basics.sh

echo "[2/3] Running docker_setup.sh..."
./docker_setup.sh

echo "[3/3] Running set_xrdp.sh..."
./set_xrdp.sh

echo
echo "======================================"
echo "[✔] All setup scripts completed successfully!"
echo "======================================"

