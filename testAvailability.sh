#!/bin/bash

if curl -f -s -o /dev/null http://my-alb-36497665.u1s-east-1.elb.amazonaws.com1/; then
else
  echo "Приложение недоступно"
  exit 1
fi