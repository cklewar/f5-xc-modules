locals {
  private_subnet_cidr = cidrsubnet(var.fabric_address_pool, 2, 1)
  subnets             = var.disable_public_ip == 1 ? join("", aws_subnet.volterra_subnet_private.*.id) : aws_subnet.volterra_subnet_public.id
  common_tags         = {
    "kubernetes.io/cluster/${var.deployment}" = "owned"
    "Owner"                                   = var.owner_tag
  }
}