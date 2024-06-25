resource "aws_subnet" "slo" {
  count             = var.aws_existing_slo_subnet_id == null ? 1 : 0
  tags              = merge({ "Name" = format("%s-slo", var.node_name) }, var.common_tags)
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_slo_cidr
  availability_zone = var.aws_vpc_az
}

resource "aws_subnet" "sli" {
  count             = var.is_multi_nic && var.aws_existing_sli_subnet_id == null ? 1 : 0
  tags              = merge({ "Name" = format("%s-sli", var.node_name) }, var.common_tags)
  vpc_id            = var.aws_vpc_id
  cidr_block        = var.aws_subnet_sli_cidr
  availability_zone = var.aws_vpc_az
}

module "network_interface_slo" {
  source                          = "../../../../../aws/network_interface"
  aws_interface_subnet_id         = local.aws_subnet_slo_id
  aws_interface_create_eip        = var.f5xc_is_secure_or_private_cloud_ce ? false : var.has_public_ip
  aws_interface_private_ips       = length(var.aws_slo_static_ips) > 0 ? var.aws_slo_static_ips : null
  aws_interface_security_groups   = var.aws_sg_slo_ids
  aws_interface_source_dest_check = false
  custom_tags                     = merge(var.common_tags, {
    "ves.io/interface-type" = "site-local-outside"
    "ves-io-eni-type"       = "outside-network"
    "ves-io-eni-az"         = var.aws_existing_slo_subnet_id != null ? data.aws_subnet.slo.0.availability_zone : aws_subnet.slo.0.availability_zone
  })
}

module "network_interface_sli" {
  source                          = "../../../../../aws/network_interface"
  count                           = var.is_multi_nic ? 1 : 0
  aws_interface_subnet_id         = local.aws_subnet_sli_id
  aws_interface_create_eip        = false
  aws_interface_security_groups   = var.aws_sg_sli_ids
  aws_interface_source_dest_check = false
  custom_tags                     = merge(var.common_tags, {
    "ves.io/interface-type" = "site-local-inside"
    "ves-io-eni-type"       = "inside-network"
    "ves-io-eni-az"         = var.aws_existing_sli_subnet_id != null ? data.aws_subnet.sli.0.availability_zone : aws_subnet.sli.0.availability_zone
  })
}

resource "aws_route_table_association" "subnet_slo" {
  count          = var.f5xc_is_secure_or_private_cloud_ce ? 0 : var.create_new_aws_slo_rta ? 1 : 0
  subnet_id      = local.aws_subnet_slo_id
  route_table_id = var.aws_slo_subnet_rt_id
}

resource "aws_route_table_association" "subnet_sli" {
  count          = var.is_multi_nic && var.create_new_aws_sli_rta? 1 : 0
  subnet_id      = local.aws_subnet_sli_id
  route_table_id = var.aws_sli_subnet_rt_id
}