#!/bin/bash

sudo apt update
sudo apt install -y nginx
sudo apt install -y git

echo "Hello World" | sudo tee /var/www/html/index.html

sudo systemctl start nginx
sudo systemctl enable nginx

mkdir -p /home/ec2-user/.ssh
#echo "ed25519 " >> /home/ec2-user/.ssh/authorized_keys
chmod 600 /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
