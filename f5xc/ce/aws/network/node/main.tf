resource "aws_subnet" "slo" {
  tags              = local.common_tags
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_slo_cidr
  availability_zone = var.aws_vpc_az
}

resource "aws_subnet" "sli" {
  count             = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  tags              = local.common_tags
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_sli_cidr
  availability_zone = var.aws_vpc_az
}

module "network_interface_slo" {
  source                          = "../../../../../aws/network_interface"
  aws_interface_subnet_id         = aws_subnet.slo.id
  aws_interface_create_eip        = var.has_public_ip
  aws_interface_security_groups   = [var.aws_sg_slo_id]
  aws_interface_source_dest_check = true
}

module "network_interface_sli" {
  source                          = "../../../../../aws/network_interface"
  count                           = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  aws_interface_subnet_id         = aws_subnet.sli[0].id
  aws_interface_create_eip        = false
  aws_interface_security_groups   = [var.aws_sg_sli_id]
  aws_interface_source_dest_check = false
}