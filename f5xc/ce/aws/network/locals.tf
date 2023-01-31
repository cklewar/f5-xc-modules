locals {
  subnets             = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? join("", aws_subnet.sli.*.id) : aws_subnet.slo.*.id
  common_tags         = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "Owner"                                     = var.owner_tag
    "Name"                                      = var.cluster_name
  }
}