locals {
  machine_hostnames = [for dns in aws_instance.instance.*.private_dns : element(split(".", dns), 0)]
  common_tags       = merge({
    "Name" = var.f5xc_node_name
  }, var.common_tags)
}