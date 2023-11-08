#!/usr/bin/env bash

MODULES_PATH="modules/f5xc/api-credential"

echo "$MODULES_ROOT/$MODULES_PATH"
python3 -m venv "$MODULES_ROOT"/$MODULES_PATH//venv
source "$MODULES_ROOT"/$MODULES_PATH/venv/bin/activate
python3 -m pip -qqq --exists-action i --no-input --no-color install --progress-bar off --upgrade pip
python3 -m pip -qqq --exists-action i --no-input --no-color install --progress-bar off -r "$MODULES_ROOT/$MODULES_PATH/scripts/requirements.txt"

if [[ $storage = "INTERNAL" ]]; then
  python3 "$MODULES_ROOT"/$MODULES_PATH/scripts/script.py delete $api_url $api_token $tenant $api_credentials_name "$MODULES_ROOT" "$storage"

else
  python3 "$MODULES_ROOT"/$MODULES_PATH/scripts/script.py delete $api_url $api_token $tenant $api_credentials_name "$MODULES_ROOT" "$storage" -r "$aws_region" -b "$s3_bucket" -k "$s3_key"
fi

rm -Rf "$MODULES_ROOT"/$MODULES_PATH/venv
