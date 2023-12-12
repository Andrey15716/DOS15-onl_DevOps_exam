#!/bin/bash

ALB_ADDRESS="http://my-alb-36497665.us-east-1.elb.amazonaws.com11/"
responseCode=$(curl -f -s -o /dev/null -w '%{http_code}' $ALB_ADDRESS)

if [ "$responseCode" != "200" ]; then
  echo "Code response is $responseCode"
  exit 1
fi