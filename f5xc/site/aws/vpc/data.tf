data "aws_instance" "master-0" {
  depends_on = [module.site_wait_for_online]

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
  filter {
    name   = "tag:Name"
    values = ["master-0"]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_instance" "master-1" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_vpc_az_nodes) >= 2 ? 1 : 0

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
  filter {
    name   = "tag:Name"
    values = ["master-1"]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_instance" "master-2" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_vpc_az_nodes) >= 2 ? 1 : 0

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
  filter {
    name   = "tag:Name"
    values = ["master-2"]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_network_interface" "master-0-slo" {
  depends_on = [module.site_wait_for_online]

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-0.id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_network_interface" "master-0-sli" {
  depends_on = [module.site_wait_for_online]
  count      = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-0.id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_network_interface" "master-1-slo" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_vpc_az_nodes) >= 2 ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-1[0].id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_network_interface" "master-1-sli" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_vpc_az_nodes) >= 2 && var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-1[0].id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_network_interface" "master-2-slo" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_vpc_az_nodes) >= 2 ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-2[0].id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_network_interface" "master-2-sli" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_vpc_az_nodes) >= 2 && var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-2[0].id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_route_table" "master-0-sli-rt" {
  depends_on = [module.site_wait_for_online]
  count      = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? 1 : 0
  subnet_id  = data.aws_network_interface.master-0-sli[0].subnet_id

  /*filter {
    name   = "association.subnet-id"
    values = [data.aws_network_interface.master-0-sli[0].subnet_id]
  }
  filter {
    name   = "tag:ves-io-route-table-type"
    values = ["inside-network"]
  }
  filter {
    name   = "tag:ves-io-route-table-az"
    values = [data.aws_instance.master-0.availability_zone]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }*/
}

data "aws_route_table" "master-1-sli-rt" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_vpc_az_nodes) >= 2 && var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? 1 : 0
  subnet_id  = data.aws_network_interface.master-1-sli[0].subnet_id
}

data "aws_route_table" "master-2-sli-rt" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_vpc_az_nodes) >= 2 && var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? 1 : 0
  subnet_id  = data.aws_network_interface.master-2-sli[0].subnet_id
}

data "aws_subnets" "workload" {
  depends_on = [module.site_wait_for_online]
  count      = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? 1 : 0

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/subnet-type"
    values = ["workload"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_vpc" "vpc" {
  depends_on = [module.site_wait_for_online]
  id         = var.f5xc_aws_vpc_existing_id != "" ? var.f5xc_aws_vpc_existing_id : null

  dynamic "filter" {
    for_each = var.f5xc_aws_vpc_existing_id == "" ? [1] : []
    content {
      name   = "tag:ves-io-site-name"
      values = [var.f5xc_aws_vpc_site_name]
    }
  }
  dynamic "filter" {
    for_each = var.f5xc_aws_vpc_existing_id == "" ? [1] : []
    content {
      name   = "tag:ves-io-creator-id"
      values = [var.f5xc_aws_vpc_owner]
    }
  }
}

data "aws_internet_gateway" "igw" {
  depends_on = [module.site_wait_for_online]
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}