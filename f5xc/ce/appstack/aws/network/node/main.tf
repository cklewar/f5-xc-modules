resource "aws_subnet" "slo" {
  count             = var.aws_existing_slo_subnet_id == null ? 1 : 0
  tags              = merge({ "Name" = format("%s-slo", var.node_name) }, var.common_tags)
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_slo_cidr
  availability_zone = var.aws_vpc_az
}

module "network_interface_slo" {
  source                          = "../../../../../../aws/network_interface"
  aws_interface_subnet_id         = var.aws_existing_slo_subnet_id != null ? var.aws_existing_slo_subnet_id : aws_subnet.slo.0.id
  aws_interface_create_eip        = var.has_public_ip
  aws_interface_security_groups   = var.aws_sg_slo_ids
  aws_interface_source_dest_check = true
  custom_tags                     = merge(var.common_tags, {
    "ves.io/interface-type" = "site-local-outside"
    "ves-io-eni-type"       = "outside-network"
    "ves-io-eni-az"         = var.aws_existing_slo_subnet_id != null ? var.aws_existing_slo_subnet_id : aws_subnet.slo.0.availability_zone
  })
}

resource "aws_route_table_association" "subnet_slo" {
  subnet_id      = var.aws_existing_slo_subnet_id != null ? var.aws_existing_slo_subnet_id : aws_subnet.slo.0.id
  route_table_id = var.aws_slo_subnet_rt_id
}