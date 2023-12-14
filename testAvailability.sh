#!/bin/bash
ALB_ADDRESS="http://my-alb-36497665.us-east-1.elb.amazonaws.com/"
response=$(wget --spider -S "$ALB_ADDRESS" 2>&1 | grep "HTTP/" | awk '{print $2}')

if [ "$response" = "200" ]; then
  sudo curl -o /var/www/html/index.html https://raw.githubusercontent.com/Andrey15716/DOS15-onl_DevOps_exam/main/application/index.html
  sudo systemctl restart nginx
else
  echo "Приложение недоступно"
  exit 1
fi