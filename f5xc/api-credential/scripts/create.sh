#!/usr/bin/env bash

MODULES_PATH="modules/f5xc/api-credential"

echo "$PWD"
python3 -m venv "$PWD"/modules/f5xc/api-credential/venv
source "$PWD"/$MODULES_PATH/venv/bin/activate
python3 -m pip install install --upgrade pip
python3 -m pip install -r "$PWD/$MODULES_PATH/scripts/requirements.txt"
echo "python3 $MODULES_PATH/scripts/script.py post $api_url $api_token $tenant -n $api_credentials_name -v $virtual_k8s_name -c $api_credential_type_kube_config"
python3 $MODULES_PATH/scripts/script.py post $api_url $api_token $tenant -n $api_credentials_name -v $virtual_k8s_name -c $api_credential_type_kube_config

