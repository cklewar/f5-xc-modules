#!/usr/bin/env bash

counter=0
sleep_step=1
end_outer=0

url=$1
tenant=$3
max_timeout=$4
check_url=$5
check_type=$6

if [[ "${check_type}" == "cert" ]] ; then
  cert_p12_file=$2
  cert_password=$7
fi

if [[ "${check_type}" == "token" ]] ; then
  api_token=$2
fi

if [[ "${check_type}" == "token" ]] ; then
  echo "Status check URL: ${check_url}" \
  -H 'accept: application/data' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Authorization: APIToken '"${api_token}" \
  -H 'x-volterra-apigw-tenant: '"${tenant}"

status_code=$(curl --write-out '%{http_code}' -s --output /dev/null -X 'GET' \
  "${check_url}" \
  -H 'accept: application/data' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Authorization: APIToken '"${api_token}" \
  -H 'x-volterra-apigw-tenant: '"${tenant}")

if [[ "$status_code" -ne 200 ]]; then
  echo "Error in request with status code: ${status_code}. Exiting..."
  exit 0
else
  echo "200 OK. Good to go..."
fi

while true; do
  content=$(
    curl -s -X 'GET' \
      "$4" \
      -H 'accept: application/data' \
      -H 'Access-Control-Allow-Origin: *' \
      -H 'Authorization: APIToken '"${api_token}" \
      -H 'x-volterra-apigw-tenant: '"${tenant}" 2>/dev/null
  )
  status=$(jq 'if (.items | length) > 0 then (.items | length) else empty end' <<<"${content}")

  if [[ "${status}" == 1 ]]; then
    echo "Found labeled vK8s entry. Checking initializers now..."

    while true; do
      ((counter += 1))
      content=$(
        curl -s -X 'GET' \
          "$1" \
          -H 'accept: application/data' \
          -H 'Access-Control-Allow-Origin: *' \
          -H 'Authorization: APIToken '"${api_token}" \
          -H 'x-volterra-apigw-tenant: '"${tenant}" 2>/dev/null

      )
      status=$(jq -r 'if (.system_metadata.initializers.pending | length) > 0 then (.system_metadata.initializers.pending | length) else 0 end' <<<"${content}")

      if [[ "${status}" -gt 0 ]]; then
        initializers=$(jq -r '[ .system_metadata.initializers.pending[].name ] | join(", ")' <<<"${content}")
        echo "Check if initializers running... $initializers"
        echo ""
        sleep $sleep_step
      fi

      if [[ "${status}" -eq 0 ]]; then
        end_outer=1
        break
      fi

      if [ "${counter}" -eq "${max_timeout}" ]; then
        echo "Timeout of ${max_timeout} secs reached. Stop checking status now..."
        break
      fi
    done
  fi

  if [ "${end_outer}" -eq 1 ]; then
    echo "vk8s instance created. Leaving..."
    break
  fi

  if [ "${counter}" -eq "${max_timeout}" ]; then
    echo "Timeout of ${max_timeout} secs reached. Stop checking status now..."
    break
  fi
done
fi

if [[ "${check_type}" == "cert" ]] ; then
   echo "Status check URL: ${check_url}" \
  -H 'accept: application/data' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'x-volterra-apigw-tenant: '"${tenant}"

status_code=$(curl --cert-type P12 --cert "${cert_p12_file}":"${cert_password}" --write-out '%{http_code}' -s --output /dev/null -X 'GET' \
  "${check_url}" \
  -H 'accept: application/data' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'x-volterra-apigw-tenant: '"${tenant}")

if [[ "$status_code" -ne 200 ]]; then
  echo "Error in request with status code: ${status_code}. Exiting..."
  exit 0
else
  echo "200 OK. Good to go..."
fi

while true; do
  content=$(
    curl --cert-type P12 --cert "${cert_p12_file}":"${cert_password}" -s -X 'GET' \
      "$4" \
      -H 'accept: application/data' \
      -H 'Access-Control-Allow-Origin: *' \
      -H 'x-volterra-apigw-tenant: '"${tenant}" 2>/dev/null
  )
  status=$(jq 'if (.items | length) > 0 then (.items | length) else empty end' <<<"${content}")

  if [[ "${status}" == 1 ]]; then
    echo "Found labeled vK8s entry. Checking initializers now..."

    while true; do
      ((counter += 1))
      content=$(
        curl --cert-type P12 --cert "${cert_p12_file}":"${cert_password}" -s -X 'GET' \
          "$1" \
          -H 'accept: application/data' \
          -H 'Access-Control-Allow-Origin: *' \
          -H 'x-volterra-apigw-tenant: '"${tenant}" 2>/dev/null
      )
      status=$(jq -r 'if (.system_metadata.initializers.pending | length) > 0 then (.system_metadata.initializers.pending | length) else 0 end' <<<"${content}")

      if [[ "${status}" -gt 0 ]]; then
        initializers=$(jq -r '[ .system_metadata.initializers.pending[].name ] | join(", ")' <<<"${content}")
        echo "Check if initializers running... $initializers"
        echo ""
        sleep $sleep_step
      fi

      if [[ "${status}" -eq 0 ]]; then
        end_outer=1
        break
      fi

      if [ "${counter}" -eq "${max_timeout}" ]; then
        echo "Timeout of ${max_timeout} secs reached. Stop checking status now..."
        break
      fi
    done
  fi

  if [ "${end_outer}" -eq 1 ]; then
    echo "vk8s instance created. Leaving..."
    break
  fi

  if [ "${counter}" -eq "${max_timeout}" ]; then
    echo "Timeout of ${max_timeout} secs reached. Stop checking status now..."
    break
  fi
  done
fi