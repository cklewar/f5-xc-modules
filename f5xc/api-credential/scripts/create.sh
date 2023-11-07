#!/usr/bin/env bash

MODULES_PATH="modules/f5xc/api-credential"

echo "$MODULES_ROOT/$MODULES_PATH"
python3 -m venv "$MODULES_ROOT"/modules/f5xc/api-credential/venv
source "$MODULES_ROOT"/$MODULES_PATH/venv/bin/activate
python3 -m pip -qqq --exists-action i --no-input --no-color install --progress-bar off --upgrade pip
echo "$MODULES_ROOT/$MODULES_PATH/scripts/requirements.txt"
python3 -m pip -qqq --exists-action i --no-input --no-color install --progress-bar off -r "$MODULES_ROOT/$MODULES_PATH/scripts/requirements.txt"

if [[ $api_credential_type = "KUBE_CONFIG" ]]
then
  python3 "$MODULES_ROOT"/$MODULES_PATH/scripts/script.py post "$api_url" "$api_token" "$tenant" "$api_credentials_name" "$MODULES_ROOT" "s3" -c "$api_credential_type" -v "$virtual_k8s_name" -n $virtual_k8s_namespace -e $api_credential_expiry_days -r $aws_region -b s3_bucket -k $s3_key
else
  python3 "$MODULES_ROOT"/$MODULES_PATH/scripts/script.py post "$api_url" "$api_token" "$tenant" "$api_credentials_name" "$MODULES_ROOT" "s3" -c "$api_credential_type" -p "$api_credential_password" -e $api_credential_expiry_days -r $aws_region -b s3_bucket -k $s3_key
fi
