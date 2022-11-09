resource "aws_key_pair" "aws-key" {
  key_name   = format("%s-key", var.aws_ec2_instance_name)
  public_key = var.ssh_public_key_file
}

module "aws_network_interface" {
  source                        = "../network_interface"
  for_each                      = var.aws_ec2_network_interfaces
  aws_interface_create_eip      = each.value.create_eip
  aws_interface_private_ips     = each.value.private_ips
  aws_interface_security_groups = each.value.security_groups
  aws_interface_subnet_id       = each.value.subnet_id
  custom_tags                   = each.value.custom_tags
}

resource "aws_instance" "instance" {
  ami                         = lookup(var.amis, var.aws_region)
  instance_type               = var.aws_ec2_instance_type
  key_name                    = aws_key_pair.aws-key.id
  # subnet_id                   = var.aws_subnet_id != "" ? var.aws_subnet_id : null
  user_data                   = local.cloud_init_content
  user_data_replace_on_change = var.aws_ec2_user_data_replace_on_change
  tags                        = var.custom_tags

  /*dynamic "network_interface" {
    for_each = var.aws_ec2_network_interfaces
    content {
      device_index         = network_interface.value.device_index
      network_interface_id = network_interface.value.network_interface_id
    }
  }*/

  dynamic "network_interface" {
    for_each = module.aws_network_interface.aws_network_interface
    content {
      device_index         = index(network_interface.value)
      network_interface_id = network_interface.value.id
    }
  }
}

resource "local_file" "instance_script" {
  depends_on = [aws_instance.instance]
  content    = local.script_content
  filename   = "${var.template_output_dir_path}/${var.aws_ec2_instance_script_file}"
}

resource "null_resource" "ec2_instance_provision_custom_data" {
  depends_on = [aws_instance.instance, local_file.instance_script]
  for_each   = {for item in var.aws_ec2_instance_custom_data_dirs : item.name => item}

  connection {
    type        = var.provisioner_connection_type
    host        = aws_instance.instance.public_ip
    user        = var.provisioner_connection_user
    private_key = var.ssh_private_key_file
  }

  provisioner "file" {
    source      = each.value.source
    destination = each.value.destination
  }
}

resource "null_resource" "ec2_execute_script_file" {
  depends_on = [null_resource.ec2_instance_provision_custom_data]
  connection {
    type        = var.provisioner_connection_type
    host        = aws_instance.instance.public_ip
    user        = var.provisioner_connection_user
    private_key = var.ssh_private_key_file
  }

  provisioner "remote-exec" {
    inline = var.aws_ec2_instance_script.actions
  }
}