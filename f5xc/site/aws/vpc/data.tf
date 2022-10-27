data "aws_network_interface" "slo" {
  depends_on = [module.site_wait_for_online]
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
}

data "aws_network_interface" "sli" {
  depends_on = [module.site_wait_for_online]
  count = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? 1 : 0
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
}

data "aws_subnet" "workload" {
  depends_on = [module.site_wait_for_online]
  count = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? 1 : 0
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
}
