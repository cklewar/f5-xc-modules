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

data "aws_vpc" "vpc_new" {
  depends_on = [module.site_wait_for_online]
  count      = var.f5xc_aws_vpc_existing_name == "" && var.f5xc_aws_vpc_existing_id == "" ? 1 : 0

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_vpc_owner]
  }
}

data "aws_vpc" "vpc_exists" {
  depends_on = [module.site_wait_for_online]
  count      = var.f5xc_aws_vpc_existing_name != "" && var.f5xc_aws_vpc_existing_id != "" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [var.f5xc_aws_vpc_existing_name]
  }
  filter {
    name   = "tag:Owner"
    values = [var.f5xc_aws_vpc_owner]
  }
}