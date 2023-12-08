#!/bin/bash

sudo curl -o /var/www/html/index.html /var/lib/jenkins/workspace/test-pipeline/application/index.html

sudo systemctl start nginx
sudo systemctl enable nginx

