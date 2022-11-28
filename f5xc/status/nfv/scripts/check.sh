#!/usr/bin/env bash

attempt_counter=0
max_attempts=1800

echo "URL: $1"
until $(curl --output /dev/null --silent --head --fail $1); do
  if [ ${attempt_counter} -eq ${max_attempts} ]; then
    echo "Max attempts reached. Exiting..."
    exit 1
  fi

  printf '.'
  attempt_counter=$(($attempt_counter + 1))
  sleep 1
done
echo "Success"