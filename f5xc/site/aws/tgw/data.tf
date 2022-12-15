data "aws_ec2_transit_gateway" "tgw" {
  depends_on = [module.site_wait_for_online]

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_site_name]
  }

  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.custom_tags["Owner"]]
  }
}

data "aws_vpc" "tgw_vpc" {
  depends_on = [volterra_tf_params_action.aws_tgw_action]
  filter {
    name   = "tag:Name"
    values = [format("ves-vpc-auto-%s", var.f5xc_aws_tgw_site_name)]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_site_name]
  }

  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.custom_tags["Owner"]]
  }
}

data "aws_subnet" "tgw_subnet_sli" {
  depends_on = [module.site_wait_for_online]
  for_each   = var.f5xc_aws_tgw_az_nodes
  cidr_block = contains(keys(var.f5xc_aws_tgw_az_nodes[each.key]), "f5xc_aws_tgw_inside_subnet") ? var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_inside_subnet"] : var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_inside_existing_subnet_id"]
  vpc_id     = data.aws_vpc.tgw_vpc.id
}

data "aws_subnet" "tgw_subnet_slo" {
  depends_on = [module.site_wait_for_online]
  for_each   = var.f5xc_aws_tgw_az_nodes
  cidr_block = contains(keys(var.f5xc_aws_tgw_az_nodes[each.key]), "f5xc_aws_tgw_outside_subnet") ? var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_outside_subnet"] : var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_outside_existing_subnet_id"]
  vpc_id     = data.aws_vpc.tgw_vpc.id
}

data "aws_subnet" "tgw_subnet_workload" {
  depends_on = [module.site_wait_for_online]
  for_each   = var.f5xc_aws_tgw_az_nodes
  cidr_block = contains(keys(var.f5xc_aws_tgw_az_nodes[each.key]), "f5xc_aws_tgw_workload_subnet") ? var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_workload_subnet"] : var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_workload_existing_subnet_id"]
  vpc_id     = data.aws_vpc.tgw_vpc.id
}

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
    values = [var.f5xc_aws_tgw_site_name]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
}

data "aws_instance" "master-1" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_tgw_az_nodes) >= 2 ? 1 : 0

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
    values = [var.f5xc_aws_tgw_site_name]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
}

data "aws_instance" "master-2" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_tgw_az_nodes) >= 2 ? 1 : 0

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
    values = [var.f5xc_aws_tgw_site_name]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
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
    values = [var.f5xc_aws_tgw_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
}

data "aws_network_interface" "master-0-sli" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_tgw_az_nodes) >= 2 ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-0.id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
}

data "aws_network_interface" "master-1-slo" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_tgw_az_nodes) >= 2 ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-1[0].id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
}

data "aws_network_interface" "master-1-sli" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_tgw_az_nodes) >= 2 ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-1[0].id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
}

data "aws_network_interface" "master-2-slo" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_tgw_az_nodes) >= 2 ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-2[0].id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
}

data "aws_network_interface" "master-2-sli" {
  depends_on = [module.site_wait_for_online]
  count      = length(var.f5xc_aws_tgw_az_nodes) >= 2 ? 1 : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-2[0].id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
}