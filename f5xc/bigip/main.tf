resource "null_resource" "fix" {
  connection {
    bastion_host        = var.aws_ec2_vcs_instance_public_ip
    bastion_user        = var.provisioner_connection_user
    bastion_private_key = var.ssh_private_key
    host                = var.bigip_interface_internal_ip
    user                = var.bigip_admin_username
    password            = var.bigip_admin_password
    type                = var.provisioner_connection_type
    timeout             = var.provisioner_connection_timeout
  }

  provisioner "remote-exec" {
    inline = local.commands

    connection {
      timeout = "2m"
    }
  }
}

resource "bigip_sys_provision" "asm" {
  depends_on   = [null_resource.fix]
  name         = "asm"
  full_path    = "/Common/asm"
  cpu_ratio    = 0
  disk_ratio   = 0
  level        = "nominal"
  memory_ratio = 0
}

data "http" "auth_token" {
  depends_on      = [null_resource.fix]
  url             = format("https://%s/%s", var.bigip_address, var.bigip_token_based_auth_uri)
  method          = "POST"
  request_headers = {
    Accept = "application/json"
  }
  request_body = local.token_based_auth
}

resource "local_file" "waf_policy" {
  depends_on = [null_resource.fix]
  content    = local.waf_policy_content
  filename   = format("%s/_out/%s", path.module, var.bigip_as3_awaf_policy)
}

data "http" "bigip_waf_policy" {
  depends_on      = [null_resource.fix]
  url             = format("https://%s/%s", var.bigip_address, "mgmt/shared/appsvcs/declare")
  method          = "POST"
  request_headers = {
    Accept          = "application/json"
    X-F5-Auth-Token = local.auth_token
  }
  request_body = local_file.waf_policy.content
}