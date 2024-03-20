#!/usr/bin/env bash

set -e

counter=0
sleep_first_step=1
sleep_second_step=30
is_verbose=false

url=$1
tenant=$3
max_timeout=$4
check_type=$5

if [[ "$is_verbose" == true ]] ; then
  echo "1: $1"
  echo "2: $2"
  echo "3: $3"
  echo "4: $4"
  echo "5: $5"
  echo "6: $6"
fi

if [[ "${check_type}" == "cert" ]] ; then
  cert_p12_file=$2
  cert_password=$6
fi

if [[ "${check_type}" == "token" ]] ; then
  api_token=$2
fi

if [[ "${check_type}" == "token" ]] ; then
  echo "Checking status using token"

  if [ -z "$api_token" ]; then
    echo >&2 "Fatal error: API token not set"
    exit 2
  fi

  if [[ "$is_verbose" == true ]] ; then
  echo "Status check URL: $url" \
    -H 'accept: application/data' \
    -H 'Access-Control-Allow-Origin: *' \
    -H 'Authorization: APIToken '"${api_token}" \
    -H 'x-volterra-apigw-tenant: '"${tenant}"
  fi

  status_code=$(curl --write-out '%{http_code}' -s --output /dev/null -X 'GET' \
      "${url}" \
      -H 'accept: application/data' \
      -H 'Access-Control-Allow-Origin: *' \
      -H 'Authorization: APIToken '"${api_token}" \
      -H 'x-volterra-apigw-tenant: '"${tenant}")

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
      -H 'accept: application/data' \
      -H 'Access-Control-Allow-Origin: *' \
      -H 'Authorization: APIToken '"${api_token}" \
      -H 'x-volterra-apigw-tenant: '"${tenant}")

    if jq -e . >/dev/null 2>&1 <<<"$content"; then
      status=$(jq -r '.spec.site_state' <<<"${content}")

      if [[ "${status}" == "ONLINE" ]]; then
        echo "Status: ${status} --> Wait ${sleep_second_step} secs and check status again..."
        echo ""
        sleep $sleep_second_step

        content=$(curl -s -X 'GET' \
          "${url}" \
          -H 'accept: application/data' \
          -H 'Access-Control-Allow-Origin: *' \
          -H 'Authorization: APIToken '"${api_token}" \
          -H 'x-volterra-apigw-tenant: '"${tenant}")
        status=$(jq -r '.spec.site_state' <<<"${content}")

        if [[ "${status}" == "ONLINE" ]]; then
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

if [[ "${check_type}" == "cert" ]] ; then
  echo "Checking status using certificate"

  if [ -z "$cert_password" ]; then
    echo >&2 "Fatal error: Cert password not set"
    exit 2
  fi

  if [ -z "$cert_p12_file" ]; then
    echo >&2 "Fatal error: Cert file not set"
    exit 2
  fi

  if [[ "$is_verbose" == true ]] ; then
  echo "Status check URL: ${url}" \
    -H 'accept: application/data' \
    -H 'Access-Control-Allow-Origin: *' \
    -H 'x-volterra-apigw-tenant: '"${tenant}"
  fi

  status_code=$(curl --cert-type P12 --cert "${cert_p12_file}":"${cert_password}" --write-out '%{http_code}' -s --output /dev/null -X 'GET' \
      "${url}" \
      -H 'accept: application/data' \
      -H 'Access-Control-Allow-Origin: *' \
      -H 'x-volterra-apigw-tenant: '"${tenant}")

  if [[ "$status_code" -ne 200 ]] ; then
    echo "Error in request with status code: ${status_code}. Exiting..."
    exit 0
  else
    echo "200 OK. Good to go..."
  fi

  while true; do
    ((counter+=1))
    content=$(curl --cert-type P12 --cert "${cert_p12_file}":"${cert_password}" -s -X 'GET' \
      "${url}" \
      -H 'accept: application/data' \
      -H 'Access-Control-Allow-Origin: *' \
      -H 'x-volterra-apigw-tenant: '"${tenant}")

    if jq -e . >/dev/null 2>&1 <<<"$content"; then
      status=$(jq -r '.spec.site_state' <<<"${content}")

      if [[ "${status}" == "ONLINE" ]]; then
        echo "Status: ${status} --> Wait ${sleep_second_step} secs and check status again..."
        echo ""
        sleep $sleep_second_step

        content=$(curl --cert-type P12 --cert "${cert_p12_file}":"${cert_password}" -s -X 'GET' \
          "${url}" \
          -H 'accept: application/data' \
          -H 'Access-Control-Allow-Origin: *' \
          -H 'x-volterra-apigw-tenant: '"${tenant}")
        status=$(jq -r '.spec.site_state' <<<"${content}")

        if [[ "${status}" == "ONLINE" ]]; then
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
