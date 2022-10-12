/*data "aws_network_interface" "slo" {
  # depends_on = [module.site_wait_for_online]
  filter {
    name   = "tag:ves-io-site-name"
    values = [volterra_tf_params_action.aws_vpc_action.site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-outside"]
  }
}

data "aws_network_interface" "sli" {
  # depends_on = [module.site_wait_for_online]
  filter {
    name   = "tag:ves-io-site-name"
    values = [volterra_tf_params_action.aws_vpc_action.site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
}*/