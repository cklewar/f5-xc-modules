locals {
  common_tags = merge({
    "Name" = var.f5xc_node_name
  }, var.common_tags)
}

