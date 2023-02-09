locals {
  common_tags = merge({
    "Name" = var.node_name
  }, var.common_tags)
}