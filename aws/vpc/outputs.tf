output "aws_vpc" {
  value = {
    "id"        = aws_vpc.vpc.id
    "owner"     = aws_vpc.vpc.owner_id
    "ipv4_cidr" = aws_vpc.vpc.cidr_block
  }
}