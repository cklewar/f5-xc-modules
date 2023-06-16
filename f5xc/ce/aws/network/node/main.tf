resource "aws_subnet" "slo" {
  tags              = merge({ "Name" = format("%s-slo", var.node_name) }, var.common_tags)
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_slo_cidr
  availability_zone = var.aws_vpc_az
}

resource "aws_subnet" "sli" {
  count             = var.is_multi_nic ? 1 : 0
  tags              = merge({ "Name" = format("%s-sli", var.node_name) }, var.common_tags)
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_sli_cidr
  availability_zone = var.aws_vpc_az
}

module "network_interface_slo" {
  source                          = "../../../../../aws/network_interface"
  aws_interface_subnet_id         = aws_subnet.slo.id
  aws_interface_create_eip        = var.f5xc_is_secure_cloud_ce ? false : var.has_public_ip
  aws_interface_security_groups   = var.aws_sg_slo_ids
  aws_interface_source_dest_check = true
}

module "network_interface_sli" {
  source                          = "../../../../../aws/network_interface"
  count                           = var.is_multi_nic ? 1 : 0
  aws_interface_subnet_id         = aws_subnet.sli[0].id
  aws_interface_create_eip        = false
  aws_interface_security_groups   = var.aws_sg_sli_ids
  aws_interface_source_dest_check = false
}

resource "aws_route_table_association" "subnet_slo" {
  count          = var.f5xc_is_secure_cloud_ce ? 0 : 1
  subnet_id      = aws_subnet.slo.id
  route_table_id = var.aws_slo_subnet_rt_id
}

resource "aws_route_table_association" "subnet_sli" {
  count          = var.is_multi_nic ? 1 : 0
  subnet_id      = aws_subnet.sli[0].id
  route_table_id = var.aws_sli_subnet_rt_id
}