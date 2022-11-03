data "aws_instances" "_nodes" {
  depends_on = [module.site_wait_for_online]
  instance_state_names = ["running"]

  filter {
    name   = "tag:Name"
    values = ["master-*"]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
}

data "aws_instance" "nodes" {
  depends_on  = [module.site_wait_for_online]
  count       = length(data.aws_instances._nodes.ids)
  instance_id = data.aws_instances._nodes.ids[count.index]
}

data "aws_network_interface" "slo" {
  depends_on = [module.site_wait_for_online]
  count      = length(data.aws_instance.nodes)

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.nodes[count.index].id]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
}

data "aws_network_interface" "sli" {
  depends_on = [module.site_wait_for_online]
  count      = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? length(data.aws_instance.nodes) : 0

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.nodes[count.index].id]
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
}