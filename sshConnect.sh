#!/bin/bash
export LC_ALL=C.UTF-8

sudo curl -o /var/www/html/index.html https://raw.githubusercontent.com/Andrey15716/DOS15-onl_DevOps_exam/main/application/index.html
sudo systemctl restart nginx

