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
  filter {
    name   = "tag:ves-io-site-name"
    values = [var.f5xc_aws_vpc_site_name]
  }
  filter {
    name   = "tag:ves.io/interface-type"
    values = ["site-local-inside"]
  }
}