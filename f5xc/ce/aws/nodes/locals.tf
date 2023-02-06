locals {
  machine_hostnames = [for dns in aws_instance.instance.*.private_dns : element(split(".", dns), 0)]
  common_tags       = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "Owner"                                     = var.owner_tag
    "Name"                                      = var.cluster_name
  }
}