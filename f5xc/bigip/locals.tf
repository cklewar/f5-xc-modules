locals {
  random_id          = uuid()
  waf_policy_content = templatefile(format("%s/templates/%s", path.module, var.bigip_as3_awaf_policy_template), {
    vip_name                    = var.bigip_ltm_virtual_server_name
    vip_ip                      = chomp(var.bigip_ltm_virtual_server_ip)
    pool_node_ip                = var.bigip_ltm_pool_node_ip
    bigip_tenant                = var.bigip_tenant
    aws_ec2_instance_private_ip = var.aws_ec2_instance_private_ip
  })
}