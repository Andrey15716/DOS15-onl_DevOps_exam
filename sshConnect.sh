#!/bin/bash

echo "Hello World from AWS!" | sudo tee /var/www/html/index.html

sudo systemctl start nginx
sudo systemctl enable nginx

