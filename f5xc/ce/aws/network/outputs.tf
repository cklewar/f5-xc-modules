output "ce" {
  value = {
    sg           = aws_security_group.sg
    vpc          = var.aws_existing_vpc_id == "" ? aws_vpc.vpc[0] : null
    existing_vpc = var.aws_existing_vpc_id != "" ? data.aws_vpc.vpc : null
    nlb          = aws_lb.nlb
    igw          = aws_internet_gateway.igw
    ngw          = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_nat_gateway.ngw : null
    rt_sli       = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_route_table.sli_subnet : null
    master-0     = {
      slo_subnet = aws_subnet.slo["node0"]
      sli_subnet = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_subnet.sli["node0"] : null
    }
    master-1 = length(var.f5xc_aws_vpc_az_nodes) > 1 ? {
      slo_subnet = aws_subnet.slo["node1"]
      sli_subnet = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_subnet.sli["node1"] : null
    } : null
    master-2 =  length(var.f5xc_aws_vpc_az_nodes) > 1 ? {
      slo_subnet = aws_subnet.slo["node2"]
      sli_subnet = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_subnet.sli["node2"] : null
    } : null
  }
}