#!/bin/bash

sudo apt update
sudo apt install -y nginx
sudo apt install -y git

echo "Hello World" | sudo tee /var/www/html/index.html

sudo systemctl start nginx
sudo systemctl enable nginx
