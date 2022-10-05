output "fix_uri" {
  value = format("curl -k -v -X POST 'https://%s/mgmt/tm/util/bash' -H 'Content-Type: application/json' -H 'Authorization: Basic %s' --data-binary '@/tmp/custom_data/vcs/fix.json'", var.bigip_interface_internal_ip, local.bearer)
}