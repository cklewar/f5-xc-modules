locals {
  common_tags = {
    "kubernetes.io/cluster/${var.deployment}" = "owned"
    "deployment"                              = var.deployment
    "iam_owner"                               = var.iam_owner
  }
}