locals {
  token_based_auth = jsonencode({
    username          = var.bigip_admin_username,
    password          = var.bigip_admin_password,
    loginProviderName = "tmos"
  })

  commands = [
    "tmsh modify sys db httpd.matchclient value false",
    "killall -9 httpd",
    "tmsh start sys service httpd"
  ]

  bearer             = base64encode(format("%s:%s", var.bigip_admin_username, var.bigip_admin_password))
  vcs_url            = format("%s://%s:%s/%s/%s", var.aws_ec2_vcs_instance_schema, var.aws_ec2_vcs_instance_private_ip, var.aws_ec2_vcs_instance_port, var.aws_ec2_vcs_instance_uri, var.bigip_as3_awaf_policy)
  auth_token         = jsondecode(data.http.auth_token.response_body)["token"]["token"]
  waf_policy_content = templatefile(format("%s/templates/%s", path.module, var.bigip_as3_awaf_policy_template), {
    vip_name     = var.bigip_ltm_virtual_server_name
    vip_ip       = chomp(var.bigip_ltm_virtual_server_ip)
    pool_node_ip = var.bigip_ltm_pool_node_ip
    bigip_tenant = var.bigip_tenant
    vcs_url      = local.vcs_url
  })
}