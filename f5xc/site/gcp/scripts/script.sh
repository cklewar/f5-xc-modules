#!/usr/bin/env bash

set -e

INSTANCE_NAME=$(/opt/homebrew/Cellar/hcl2json/0.3.5/bin/hcl2json test.hcl | jq '.instance_names[0]')
MASTER_PRIVATE_IP_ADDRESS=$(/opt/homebrew/Cellar/hcl2json/0.3.5/bin/hcl2json test.hcl | jq '.master_private_ip_address.'"$INSTANCE_NAME")
MASTER_PUBLIC_IP_ADDRESS=$(/opt/homebrew/Cellar/hcl2json/0.3.5/bin/hcl2json test.hcl | jq '.master_public_ip_address.'"$INSTANCE_NAME")
jq -n --argjson instance_name "$INSTANCE_NAME" --argjson master_private_ip_address "$MASTER_PRIVATE_IP_ADDRESS" --argjson master_public_ip_address "$MASTER_PUBLIC_IP_ADDRESS" '{"instance_name":$instance_name, "master_private_ip_address":$master_private_ip_address, "master_public_ip_address": $master_public_ip_address}'