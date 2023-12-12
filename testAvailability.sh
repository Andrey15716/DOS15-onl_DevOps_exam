#!/bin/bash

status_code=$(curl --write-out %{http_code} --silent --output /dev/null http://my-alb-36497665.us-east-1.elb.amazonaws.com11/)

if [[ "$status_code" -ne 200 ]] ; then
  echo "ALB Address responded with code: $responseCode"
  exit 1
fi