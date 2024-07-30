#!/usr/bin/env bash

set -e

counter=0
sleep_first_step=1
sleep_second_step=30
is_verbose=true

url=$1
max_timeout=$4
check_type=$5

if [[ "$is_verbose" == true ]] ; then
  echo "1: $1"
  echo "2: $2"
  echo "3: $3"
  echo "4: $4"
  echo "5: $5"
fi

if [[ "${check_type}" == "basic" ]] ; then
  username=$2
  password=$3
fi

if [[ "${check_type}" == "basic" ]] ; then
  echo "Checking status using username and password"

  if [ -z "$username" ]; then
    echo >&2 "Fatal error: username not set"
    exit 2
  fi

  if [ -z "$password" ]; then
    echo >&2 "Fatal error: password not set"
    exit 2
  fi

  if [[ "$is_verbose" == true ]] ; then
  echo "Status check URL: $url" \
    -H 'accept: application/json' \
    -H 'Access-Control-Allow-Origin: *'
  fi

  status_code=$(curl --write-out '%{http_code}' -s --output /dev/null -X 'GET' \
      "${url}" \
      -H 'accept: application/json' \
      -H 'Access-Control-Allow-Origin: *')

  if [[ "$status_code" -ne 200 ]] ; then
    echo "Error in request with status code: ${status_code}. Exiting..."
    exit 0
  else
    echo "200 OK. Good to go..."
  fi

  while true; do
    ((counter+=1))
    content=$(curl -s -X 'GET' \
      "${url}" \
      -H 'accept: application/json' \
      -H 'Access-Control-Allow-Origin: *')

    if jq -e . >/dev/null 2>&1 <<<"$content"; then
      status=$(jq -r '.["f5-tenants:tenant"][0].state.status' <<<"${content}")

      if [[ "${status}" == "running" ]]; then
        echo "Status: ${status} --> Wait ${sleep_second_step} secs and check status again..."
        echo ""
        sleep $sleep_second_step

        content=$(curl -s -X 'GET' \
          "${url}" \
          -H 'accept: application/json' \
          -H 'Access-Control-Allow-Origin: *')
        status=$(jq -r '.["f5-tenants:tenant"][0].state.status' <<<"${content}")

        if [[ "${status}" == "running" ]]; then
          echo "Done"
          break
        fi
      fi

      if [ "${counter}" -eq "${max_timeout}" ]; then
          echo "Timeout of ${max_timeout} secs reached. Stop checking status now..."
          break
      fi

      echo "Status: ${status} --> Waiting..."
      echo ""
      sleep $sleep_first_step

    else
      echo "Status check failed with error: $content"
    fi
  done
fi