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
}

data "aws_vpc" "vpc" {
  depends_on = [module.site_wait_for_online]

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.custom_tags["Owner"]]
  }
}