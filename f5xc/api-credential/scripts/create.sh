#!/usr/bin/env bash

MODULES_PATH="modules/f5xc/api-credential"

echo "$PWD"
python3 -m venv "$PWD"/modules/f5xc/api-credential/venv
source "$PWD"/$MODULES_PATH/venv/bin/activate
python3 -m pip -qqq --exists-action i --no-input --no-color install --progress-bar off --upgrade pip
python3 -m pip -qqq --exists-action i --no-input --no-color install --progress-bar off -r "$PWD/$MODULES_PATH/scripts/requirements.txt"

if [[ $api_credential_type = "KUBE_CONFIG" ]]
then
  python3 $MODULES_PATH/scripts/script.py post $api_url $api_token $tenant $api_credentials_name -c $api_credential_type -v $virtual_k8s_name -n $virtual_k8s_namespace -e $api_credential_expiry_days
else
  python3 $MODULES_PATH/scripts/script.py post $api_url $api_token $tenant $api_credentials_name -c $api_credential_type -p $api_credential_password -e $api_credential_expiry_days
fi
