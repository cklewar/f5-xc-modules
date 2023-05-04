resource "aws_network_interface" "interface" {
  subnet_id         = var.aws_interface_subnet_id
  private_ips       = var.aws_interface_private_ips
  security_groups   = var.aws_interface_security_groups
  source_dest_check = var.aws_interface_source_dest_check
  tags              = var.custom_tags
}

resource "aws_eip" "eip" {
  count             = var.aws_interface_create_eip ? 1 : 0
  vpc               = true
  network_interface = aws_network_interface.interface.id
  tags              = var.custom_tags
}

module "apply_timeout_workaround" {
  depend_on      = aws_eip.eip.id
  source         = "../../utils/timeout"
  count          = var.aws_interface_create_eip ? 1 : 0
  create_timeout = "30s"
  delete_timeout = "30s"
}