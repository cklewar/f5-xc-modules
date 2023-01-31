output "ce" {
  value = {
    sg         = aws_security_group.sg
    vpc        = var.aws_existing_vpc_id == "" ? aws_vpc.vpc : data.aws_vpc
    nlb        = aws_lb.nlb
    igw        = aws_internet_gateway.igw
    ngw        = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_nat_gateway.ngw : null
    rt_sli     = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_route_table.sli_subnet : null
    slo_subnet = aws_subnet.slo
    sli_subnet = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? aws_subnet.sli : null
  }
}