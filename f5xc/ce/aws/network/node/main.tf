resource "aws_subnet" "slo" {
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_slo_cidr
  availability_zone = var.aws_vpc_az
  tags              = local.common_tags
}

resource "aws_subnet" "sli" {
  count             = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_sli_cidr
  availability_zone = var.aws_vpc_az
  tags              = local.common_tags
}

module "network_interface_slo" {
  source                          = "../../../../../aws/network_interface"
  aws_interface_subnet_id         = aws_subnet.slo.id
  aws_interface_create_eip        = var.has_public_ip
  aws_interface_security_groups   = [var.aws_sg_slo_id]
  aws_interface_source_dest_check = false
}

module "network_interface_sli" {
  source                          = "../../../../../aws/network_interface"
  count                           = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  aws_interface_subnet_id         = aws_subnet.sli[0].id
  aws_interface_create_eip        = false
  aws_interface_security_groups   = [var.aws_sg_sli_id]
  aws_interface_source_dest_check = false
}

resource "aws_nat_gateway" "ngw" {
  count         = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  allocation_id = var.aws_eip_nat_gw_eip_id
  subnet_id     = aws_subnet.slo.id
  tags          = local.common_tags
}

resource "aws_route_table" "sli" {
  count  = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? 1 : 0
  vpc_id = var.aws_vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
  }
  tags = local.common_tags
}

resource "aws_route_table_association" "rta_sli_subnet" {
  count          = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? length(aws_route_table.sli) : 0
  subnet_id      = aws_subnet.sli[0].id
  route_table_id = aws_route_table.sli[0].id
}