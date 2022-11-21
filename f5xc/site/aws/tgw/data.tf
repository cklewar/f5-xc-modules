data "aws_ec2_transit_gateway" "tgw" {
  depends_on = [module.site_wait_for_online]

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_name]
  }

  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.custom_tags["Owner"]]
  }
}

data "aws_instance" "ce_master" {
  depends_on = [module.site_wait_for_online]

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_name]
  }

  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.custom_tags["Owner"]]
  }

  filter {
    name   = "tag:Name"
    values = ["master-0"]
  }

  filter {
    name   = format("tag:kubernetes.io/cluster/%s", var.f5xc_aws_tgw_name)
    values = ["owned"]
  }
}

data "aws_vpc" "tgw_vpc" {
  depends_on = [volterra_tf_params_action.aws_tgw_action]
  filter {
    name   = "tag:Name"
    values = [format("ves-vpc-auto-%s", var.f5xc_aws_tgw_name)]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_name]
  }
}

data "aws_subnet" "tgw_subnet_sli" {
  depends_on = [module.site_wait_for_online]
  for_each   = var.f5xc_aws_tgw_az_nodes
  cidr_block = contains(keys(var.f5xc_aws_tgw_az_nodes[each.key]), "f5xc_aws_tgw_inside_subnet") ? var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_inside_subnet"] : var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_inside_existing_subnet_id"]
  vpc_id     = data.aws_vpc.tgw_vpc.id

  filter {
    name   = "tag:ves.io/subnet-type"
    values = ["site-local-inside"]
  }

  filter {
    name   = format("tag:kubernetes.io/cluster/%s", var.f5xc_aws_tgw_name)
    values = ["owned"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_name]
  }
}

data "aws_subnet" "tgw_subnet_slo" {
  depends_on = [module.site_wait_for_online]
  for_each   = var.f5xc_aws_tgw_az_nodes
  cidr_block = contains(keys(var.f5xc_aws_tgw_az_nodes[each.key]), "f5xc_aws_tgw_outside_subnet") ? var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_outside_subnet"] : var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_outside_existing_subnet_id"]
  vpc_id     = data.aws_vpc.tgw_vpc.id

  filter {
    name   = "tag:ves.io/subnet-type"
    values = ["site-local-outside"]
  }

  filter {
    name   = format("tag:kubernetes.io/cluster/%s", var.f5xc_aws_tgw_name)
    values = ["owned"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_name]
  }
}

data "aws_subnet" "tgw_subnet_workload" {
  depends_on = [module.site_wait_for_online]
  for_each   = var.f5xc_aws_tgw_az_nodes
  cidr_block = contains(keys(var.f5xc_aws_tgw_az_nodes[each.key]), "f5xc_aws_tgw_workload_subnet") ? var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_workload_subnet"] : var.f5xc_aws_tgw_az_nodes[each.key]["f5xc_aws_tgw_workload_existing_subnet_id"]
  vpc_id     = data.aws_vpc.tgw_vpc.id

  filter {
    name   = "tag:ves.io/subnet-type"
    values = ["workload"]
  }

  filter {
    name   = format("tag:kubernetes.io/cluster/%s", var.f5xc_aws_tgw_name)
    values = ["owned"]
  }

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_name]
  }
}