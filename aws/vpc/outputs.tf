output "aws_vpc" {
  value = {
    id                  = aws_vpc.vpc.id
    arn                 = aws_vpc.vpc.arn
    tags                = aws_vpc.vpc.tags
    owner               = aws_vpc.vpc.owner_id
    igw_id              = var.create_igw ? aws_internet_gateway.igw[0].id : null
    cidr_block          = aws_vpc.vpc.cidr_block
    dhcp_options_id     = aws_vpc.vpc.dhcp_options_id
    main_route_table_id = aws_vpc.vpc.main_route_table_id
  }
}