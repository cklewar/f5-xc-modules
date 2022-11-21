resource "aws_network_interface" "interface" {
  subnet_id       = var.aws_interface_subnet_id
  private_ips     = var.aws_interface_private_ips
  security_groups = var.aws_interface_security_groups
  tags            = var.custom_tags
}

resource "aws_eip" "eip" {
  count             = var.aws_interface_create_eip ? 1 : 0
  vpc               = true
  network_interface = aws_network_interface.interface.id
  tags              = var.custom_tags
}