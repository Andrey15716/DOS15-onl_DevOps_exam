#!/bin/bash

sudo apt update
sudo apt install -y nginx
sudo apt install -y git
export LC_ALL=C.UTF-8
sudo apt install -y openjdk-11-jdk
sudo apt update
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo "Hello World" | sudo tee /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx