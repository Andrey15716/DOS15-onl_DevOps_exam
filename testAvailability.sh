#!/bin/bash

ALB_ADDRESS="http://my-alb-36497665.us-east-1.elb.amazonaws.com/"
responseCode=$(curl -f -s -o /dev/null -w '%{http_code}' "$ALB_ADDRESS")

if [[ "$responseCode" -ne 200 ]]; then
  echo "ALB Address $ALB_ADDRESS responded with code: $responseCode"
  exit 1
fi