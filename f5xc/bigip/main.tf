resource "null_resource" "fix" {
  /*triggers = {
    uuid = local.random_id
  }*/

  /*provisioner "local-exec" {
    command = format("curl -k -v -X POST 'https://%s/mgmt/tm/util/bash' -H 'Content-Type: application/json' -H 'Authorization: Basic %s' --data-binary '@./data/fix.json'", "f5xc-bigip-02.adn.helloclouds.app", local.bearer)
  }*/

  connection {
    host        = var.aws_ec2_ssh_address
    user        = var.provisioner_connection_user
    type        = var.provisioner_connection_type
    private_key = var.private_ssh_key
    timeout     = var.provisioner_connection_timeout
  }

  provisioner "remote-exec" {
    inline = [
      format("curl -k -v -X POST 'https://%s/mgmt/tm/util/bash' -H 'Content-Type: application/json' -H 'Authorization: Basic %s' --data-binary '@/tmp/custom_data/vcs/fix.json'", var.bigip_interface_internal_ip, local.bearer)
    ]
  }
}

/*resource "bigip_command" "fix" {
  #commands   = ["tmsh modify sys db httpd.matchclient value false", "bigstart restart httpd"]
  commands = ["modify sys db httpd.matchclient value false", "bigstart restart httpd"]
}*/

resource "bigip_sys_provision" "asm" {
  depends_on   = [null_resource.fix]
  name         = "asm"
  full_path    = "/Common/asm"
  cpu_ratio    = 0
  disk_ratio   = 0
  level        = "nominal"
  memory_ratio = 0
}

resource "local_file" "waf_policy" {
  depends_on = [null_resource.fix]
  content    = local.waf_policy_content
  filename   = format("%s/_out/%s", path.module, var.bigip_as3_awaf_policy)
}

/*resource "bigip_as3" "waf_policy" {
  depends_on = [null_resource.fix, bigip_sys_provision.asm, local_file.waf_policy]
  as3_json   = local_file.waf_policy.content
}*/

resource "null_resource" "apply_waf_policy" {
  depends_on = [null_resource.fix, bigip_sys_provision.asm, local_file.waf_policy]

  /*triggers = {
    uuid = local.random_id
  }*/

  provisioner "local-exec" {
    command = format("curl -k -v -X \"POST\" \"https://%s/mgmt/shared/appsvcs/declare\" -H \"Content-Type: application/json\" -H \"Authorization: Basic %s\" --data-binary \"@%s/_out/%s\"", "f5xc-bigip-02.adn.helloclouds.app", base64encode(format("%s:%s", var.bigip_admin_username, var.bigip_admin_password)), path.module, var.bigip_as3_awaf_policy)
  }

  /*connection {
    host        = var.aws_ec2_ssh_address
    user        = var.provisioner_connection_user
    type        = var.provisioner_connection_type
    private_key = var.private_ssh_key
    timeout     = var.provisioner_connection_timeout
  }

  provisioner "file" {
    source      = format("%s/_out/%s", path.module, var.bigip_as3_awaf_policy)
    destination = format("/tmp/%s", var.bigip_as3_awaf_policy)
  }

  provisioner "remote-exec" {
    inline = [
      format("curl -k -v -X \"POST\" \"https://%s/mgmt/shared/appsvcs/declare\" -H \"Content-Type: application/json\" -H \"Authorization: Basic %s\" --data-binary \"@/tmp/%s\"", var.bigip_interface_internal_ip, base64encode(format("%s:%s", var.bigip_admin_username, var.bigip_admin_password)), var.bigip_as3_awaf_policy)
    ]
  }*/
}