locals {
  aws_autoscale_group_tags = [
    {
      key   = "kubernetes.io/cluster/${var.deployment}"
      value = "owned"
    },
    {
      key   = "kubernetes.io/cluster-autoscaler/enabled"
      value = "true"
    },
    {
      key   = "deployment"
      value = var.deployment
    },
    {
      key   = "Name"
      value = "${var.deployment}-pool"
    },
    {
      key   = "iam_owner"
      value = var.iam_owner
    },
  ]
}