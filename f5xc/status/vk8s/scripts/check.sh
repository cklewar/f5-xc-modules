#!/usr/bin/env bash

timeout=60
counter=0
sleep_step=1
end_outer=0

echo "Status check URL: $4" \
  -H 'accept: application/data' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Authorization: APIToken '"$2" \
  -H 'x-volterra-apigw-tenant: '"$3"

status_code=$(curl --write-out '%{http_code}' -s --output /dev/null -X 'GET' \
  "$4" \
  -H 'accept: application/data' \
  -H 'Access-Control-Allow-Origin: *' \
  -H 'Authorization: APIToken '"$2" \
  -H 'x-volterra-apigw-tenant: '"$3")

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
      -H 'Authorization: APIToken '"$2" \
      -H 'x-volterra-apigw-tenant: '"$3" 2>/dev/null
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
          -H 'Authorization: APIToken '"$2" \
          -H 'x-volterra-apigw-tenant: '"$3" 2>/dev/null

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

      if [ "${counter}" -eq "${timeout}" ]; then
        echo "Timeout of ${timeout} secs reached. Stop checking status now..."
        break
      fi
    done
  fi

  if [ "${end_outer}" -eq 1 ]; then
    echo "vk8s instance created. Leaving..."
    break
  fi

  if [ "${counter}" -eq "${timeout}" ]; then
    echo "Timeout of ${timeout} secs reached. Stop checking status now..."
    break
  fi
done
