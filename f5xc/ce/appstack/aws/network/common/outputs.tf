output "common" {
  value = {
    vpc           = var.aws_existing_vpc_id != "" ? null : aws_vpc.vpc[0]
    igw           = aws_internet_gateway.igw
    sg_slo        = length(module.aws_security_group_slo) > 0 ? module.aws_security_group_slo[0].aws_security_group : null
    sg_slo_ids    = compact([length(module.aws_security_group_slo) > 0 ? module.aws_security_group_slo[0].aws_security_group["id"] : ""])
    existing_vpc  = var.aws_existing_vpc_id != "" ? data.aws_vpc.vpc : null
    slo_subnet_rt = aws_route_table.slo_subnet_rt
  }
}