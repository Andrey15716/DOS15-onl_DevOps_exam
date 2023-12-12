#!/bin/bash

ALB_ADDRESS="$1"
responseCode=$(curl -s -o /dev/null -w '%{http_code}' $ALB_ADDRESS)

if [ "$responseCode" != "200" ]; then
  echo "Code response is $responseCode"
  exit 1
fi