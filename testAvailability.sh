#!/bin/bash

$ALB_ADDRESS = $1
response=$(wget --spider -S "$ALB_ADDRESS" 2>&1 | grep "HTTP/" | awk '{print $2}')
Check if the HTTP response code is 200 OK
if [ "$response" = "200" ]; then
echo "Website is accessible"
else
echo "Website is not accessible. Response: $response"
exit 1
fi