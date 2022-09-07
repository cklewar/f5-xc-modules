#!/bin/bash

echo "$1" \
  -H 'accept: application/json' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Authorization: APIToken '"$2" \
  -H 'x-volterra-apigw-tenant: '"$3"

while true; do
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
    sleep 30

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

  echo "Status: ${status} --> Waiting..."
  echo ""
  sleep 1

done
