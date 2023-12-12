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

wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.7.0.linux-amd64.tar.gz
sudo cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo "Hello World" | sudo tee /var/www/html/index.html
sudo systemctl start nginx
sudo systemctl enable nginx