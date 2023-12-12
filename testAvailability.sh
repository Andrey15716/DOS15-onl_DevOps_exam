#!/bin/bash

curl http://my-alb-36497665.us-east-1.elb.amazonaws.com11/   \
--silent \
--insecure \
--request POST \
--header "your-curl-may-want-a-header" \
--data @my.input.file \
--output site.output \
--write-out %{http_code} \
  > http.response.code 2> error.messages
errorLevel=$?
httpResponse=$(cat http.response.code)


jq --raw-output 'keys | @csv' site.output | sed 's/"//g' > return.keys
hasErrors=`grep --quiet --invert errors return.keys;echo $?`

if [[ $errorLevel -gt 0 ]] || [[ $hasErrors -gt 0 ]] || [[ "$httpResponse" != "200" ]]; then
  echo -e "Error POSTing http://my-alb-36497665.us-east-1.elb.amazonaws.com/ with input my.input (errorLevel $errorLevel, http response code $httpResponse)" >> error.messages
  send_exit_message
  exit 1
fi