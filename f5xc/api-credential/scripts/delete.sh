#!/usr/bin/env bash

MODULES_PATH="modules/f5xc/api-credential"

echo "$PWD"
python3 -m venv "$PWD"/modules/f5xc/api-credential/venv
source "$PWD"/$MODULES_PATH/venv/bin/activate
python3 -m pip -qqq --exists-action i --no-input --no-color install --progress-bar off --upgrade pip
python3 -m pip -qqq --exists-action i --no-input --no-color install --progress-bar off -r "$PWD/$MODULES_PATH/scripts/requirements.txt"
python3 "$PWD"/$MODULES_PATH/scripts/script.py delete $api_url $api_token $tenant $api_credentials_name
rm -Rf "$PWD"/modules/f5xc/api-credential/venv