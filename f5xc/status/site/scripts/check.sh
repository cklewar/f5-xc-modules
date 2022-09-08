#!/bin/bash

timeout=1800
counter=0
sleep_first_step=1
sleep_second_step=30

echo "Status check URL: $1" \
  -H 'accept: application/json' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Authorization: APIToken '"$2" \
  -H 'x-volterra-apigw-tenant: '"$3"

#status_code=$(curl --write-out '%{http_code}' --silent --output /dev/null "$1")
status_code=$(curl --write-out '%{http_code}' -s --output /dev/null -X 'GET' \
    "$1" \
    -H 'accept: application/json' \
    -H 'Access-Control-Allow-Origin: *' \
    -H 'Authorization: APIToken '"$2" \
    -H 'x-volterra-apigw-tenant: '"$3")

if [[ "$status_code" -ne 200 ]] ; then
  echo "Error in request with status code: ${status_code}. Exiting..."
  exit 0
else
  echo "200 OK. Good to go..."
fi

while true; do
  ((counter+=1))
  content=$(curl -s -X 'GET' \
    "$1" \
    -H 'accept: application/json' \
    -H 'Access-Control-Allow-Origin: *' \
    -H 'Authorization: APIToken '"$2" \
    -H 'x-volterra-apigw-tenant: '"$3")
  status=$(jq -r '.spec.site_state' <<<"${content}")

  if [[ "${status}" == "ONLINE" ]]; then
    echo "Status: ${status} --> Wait 30 secs and check status again..."
    echo ""
    sleep $sleep_second_step

    content=$(curl -s -X 'GET' \
      "$1" \
      -H 'accept: application/json' \
      -H 'Access-Control-Allow-Origin: *' \
      -H 'Authorization: APIToken '"$2" \
      -H 'x-volterra-apigw-tenant: '"$3")
    status=$(jq -r '.spec.site_state' <<<"${content}")

    if [[ "${status}" == "ONLINE" ]]; then
      echo "Done"
      break
    fi
  fi

  if [ "$counter" -eq "$timeout" ]; then
      echo "Timeout ${timeout}s reached... stop check status..."
      break
  fi

  echo "Status: ${status} --> Waiting..."
  echo ""
  sleep $sleep_first_step

done
