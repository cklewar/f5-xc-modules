locals {
  common_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "Owner"                                     = var.owner_tag
    "Name"                                      = var.node_name
  }
}