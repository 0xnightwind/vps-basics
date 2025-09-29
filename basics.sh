#!/bin/bash

apt update && apt upgrade -y
apt install sudo -y
sudo apt install screen curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev lsof iproute2 g++ -y
sudo apt install python3 python3-pip python3-venv python3-dev -y
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
sudo apt install -y nodejs
node -v
sudo npm install -g yarn
yarn -v

