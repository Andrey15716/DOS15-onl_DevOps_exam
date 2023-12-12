#!/bin/bash

WEBPAGE="http://my-alb-36497665.us-east-1.elb.amazonaws.com/"
HTTPCODE=$(curl --max-time 5 --silent --write-out %{response_code} "$WEBPAGE")

if test $HTTPCODE -eq 200; then
    echo "HTTP STATUS CODE $HTTPCODE -> OK"
else
    >&2 echo "HTTP STATUS CODE $HTTPCODE -> Has something gone wrong?"
fi