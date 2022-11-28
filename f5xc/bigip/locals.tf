locals {
  random_id = uuid()
  vcs_url   = format("%s://%s:%s/%s", var.aws_ec2_vcs_instance_protocol, var.aws_ec2_vcs_instance_address, var.aws_ec2_vcs_instance_port, var.aws_ec2_vcs_instance_uri)
  bearer    = base64encode(format("%s:%s", var.bigip_admin_username, var.bigip_admin_password))
    waf_policy_content = templatefile(format("%s/templates/%s", path.module, var.bigip_as3_awaf_policy_template), {
      vip_name     = var.bigip_ltm_virtual_server_name
      vip_ip       = chomp(var.bigip_ltm_virtual_server_ip)
      pool_node_ip = var.bigip_ltm_pool_node_ip
      bigip_tenant = var.bigip_tenant
      vcs_url      = local.vcs_url
    })
    }