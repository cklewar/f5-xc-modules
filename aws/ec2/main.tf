resource "aws_key_pair" "aws_key" {
  key_name   = format("%s-key", var.aws_ec2_instance_name)
  public_key = var.ssh_public_key
}

module "network_interfaces" {
  source                        = "../network_interface"
  count                         = length(var.aws_ec2_network_interfaces)
  aws_interface_subnet_id       = var.aws_ec2_network_interfaces[count.index].subnet_id
  aws_interface_create_eip      = var.aws_ec2_network_interfaces[count.index].create_eip
  aws_interface_private_ips     = var.aws_ec2_network_interfaces[count.index].private_ips
  aws_interface_security_groups = var.aws_ec2_network_interfaces[count.index].security_groups
}

resource "aws_instance" "instance" {
  ami                         = lookup(var.amis, var.aws_region)
  tags                        = merge({ "Name" : var.aws_ec2_instance_name, "Owner" : var.owner }, var.custom_tags)
  key_name                    = aws_key_pair.aws_key.key_name
  user_data                   = local.cloud_init_content
  instance_type               = var.aws_ec2_instance_type
  user_data_replace_on_change = var.aws_ec2_user_data_replace_on_change


  dynamic "network_interface" {
    for_each = var.aws_ec2_network_interfaces_ref
    content {
      device_index         = network_interface.value.device_index
      network_interface_id = network_interface.value.network_interface_id
    }
  }

  dynamic "network_interface" {
    for_each = [for interface in module.network_interfaces : interface.aws_network_interface]
    content {
      device_index         = network_interface.key
      network_interface_id = network_interface.value.id
    }
  }
}

resource "local_file" "instance_script" {
  depends_on = [aws_instance.instance]
  count      = var.aws_ec2_instance_script_template != "" ? 1 : 0
  content    = local.script_content
  filename   = "${var.template_output_dir_path}/${var.aws_ec2_instance_script_file}"
}

resource "terraform_data" "ec2_instance_provision_custom_data" {
  depends_on = [aws_instance.instance, local_file.instance_script]
  for_each   = {for item in var.aws_ec2_instance_custom_data_dirs : item.name => item if var.aws_ec2_instance_script_template != ""}

  connection {
    type        = var.provisioner_connection_type
    host        = aws_instance.instance.public_ip
    user        = var.provisioner_connection_user
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = each.value.source
    destination = each.value.destination
  }
}

resource "terraform_data" "ec2_execute_script_file" {
  count      = var.aws_ec2_instance_script_template != "" ? 1 : 0
  depends_on = [terraform_data.ec2_instance_provision_custom_data]
  connection {
    type        = var.provisioner_connection_type
    host        = aws_instance.instance.public_ip
    user        = var.provisioner_connection_user
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = var.aws_ec2_instance_script.actions
  }
}