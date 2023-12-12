#!/bin/bash

mkdir -p ~/.ssh
touch ~/.ssh/config
chmod 600 ~/.ssh/config

{
  echo "Host *"
  echo "  StrictHostKeyChecking no"
  echo "  UserKnownHostsFile /dev/null"
} >> ~/.ssh/config

if curl -f -s -o /dev/null https://raw.githubusercontent.com/Andrey15716/DOS15-onl_DevOps_exam/main/application/index.html; then
  sudo curl -o /var/www/html/index.html https://raw.githubusercontent.com/Andrey15716/DOS15-onl_DevOps_exam/main/application/index.html
  sudo systemctl restart nginx
else
  echo "Приложение недоступно"
  exit 1
fi