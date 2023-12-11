#!/bin/bash
sudo yum update -y
sudo yum install -y wget
wget https://github.com/prometheus/prometheus/releases/download/v2.33.1/prometheus-2.33.1.linux-amd64.tar.gz
tar xvfz prometheus-*.tar.gz
cd prometheus-2.33.1.linux-amd64/
sudo cp prometheus /usr/local/bin/
sudo cp promtool /usr/local/bin/
sudo cp -r consoles /etc/prometheus
sudo cp -r console_libraries /etc/prometheus
sudo cp prometheus.yml /etc/prometheus/prometheus.yml

cat <<EOT > /etc/prometheus/prometheus.yml
global:
 scrape_interval: 15s

scrape_configs:
 - job_name: 'node'
  static_configs:
   - targets: ['54.86.69.28:9090']
EOT

sudo useradd --no-create-home --shell /bin/false prometheus
sudo chown -R prometheus:prometheus /etc/prometheus /usr/local/bin/prometheus
echo '[Unit]
Description=Prometheus Server
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file /etc/prometheus/prometheus.yml \
--storage.tsdb.path /var/lib/prometheus/ \
--web.console.templates=/etc/prometheus/consoles \
--web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus