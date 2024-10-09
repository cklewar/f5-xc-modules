resource "aws_network_interface" "interface" {
  tags                    = var.custom_tags
  subnet_id               = var.aws_interface_subnet_id
  private_ip              = null
  private_ips_count       = null
  private_ip_list         = var.aws_interface_private_ips != null ? var.aws_interface_private_ips : null
  security_groups         = var.aws_interface_security_groups
  source_dest_check       = var.aws_interface_source_dest_check
  private_ip_list_enabled = length(var.aws_interface_private_ips) > 0 ? true : false

  lifecycle {
    ignore_changes = [
      security_groups, subnet_id,
    ]
  }

}

resource "aws_eip" "eip" {
  count             = var.aws_interface_create_eip ? 1 : 0
  tags              = var.custom_tags
  network_interface = aws_network_interface.interface.id
}