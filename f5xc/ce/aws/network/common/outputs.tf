output "common" {
  value = {
    vpc              = var.aws_existing_vpc_id == "" ? aws_vpc.vpc[0] : null
    igw              = aws_internet_gateway.igw
    sg_slo           = module.aws_security_group_slo.aws_security_group
    sg_sli           = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? module.aws_security_group_sli[0].aws_security_group : null
    existing_vpc     = var.aws_existing_vpc_id != "" ? data.aws_vpc.vpc : null
    instance_profile = aws_iam_instance_profile.instance_profile
  }
}