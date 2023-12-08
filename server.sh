#!/bin/bash

sudo apt update
sudo apt install -y nginx
sudo apt install -y git
export LC_ALL=C.UTF-8
echo "Hello World" | sudo tee /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx