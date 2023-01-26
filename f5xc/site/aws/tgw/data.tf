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
    values = [var.f5xc_aws_tgw_owner]
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

  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
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
    values = [var.f5xc_aws_tgw_name]
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
    values = [var.f5xc_aws_tgw_name]
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

  filter {
    name   = "attachment.instance-id"
    values = [data.aws_instance.master-0.id]
  }
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_name]
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

data "aws_route_table" "master-0-sli-rt" {
  depends_on = [module.site_wait_for_online]
  subnet_id  = data.aws_network_interface.master-0-sli[0].subnet_id
}

data "aws_subnets" "workload" {
  depends_on = [module.site_wait_for_online]

  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_tgw_name]
  }
  filter {
    name   = "tag:ves.io/subnet-type"
    values = ["workload"]
  }
  filter {
    name   = "tag:ves-io-creator-id"
    values = [var.f5xc_aws_tgw_owner]
  }
}