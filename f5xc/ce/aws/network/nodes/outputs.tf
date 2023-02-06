output "common" {
  value = {
    sg_slo           = module.aws_security_group_slo.aws_security_group
    sg_sli           = module.aws_security_group_sli.aws_security_group
    vpc              = var.aws_existing_vpc_id == "" ? aws_vpc.vpc[0] : null
    # nlb              = aws_lb.nlb
    igw              = aws_internet_gateway.igw
    ngw              = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_nat_gateway.ngw : null
    rt_sli           = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_route_table.sli : null
    existing_vpc     = var.aws_existing_vpc_id != "" ? data.aws_vpc.vpc : null
    instance_profile = aws_iam_instance_profile.instance_profile.name
  }
}

output "nodes" {
  value = {
    node0 = {
      slo_subnet = aws_subnet.slo["node0"]
      sli_subnet = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_subnet.sli["node0"] : null
    }
    node1 = length(var.f5xc_aws_vpc_az_nodes) > 1 ? {
      slo_subnet = aws_subnet.slo["node1"]
      sli_subnet = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_subnet.sli["node1"] : null
    } : null
    node2 = length(var.f5xc_aws_vpc_az_nodes) > 1 ? {
      slo_subnet = aws_subnet.slo["node2"]
      sli_subnet = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_subnet.sli["node2"] : null
    } : null
  }
}