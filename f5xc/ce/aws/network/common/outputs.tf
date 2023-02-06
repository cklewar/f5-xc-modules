output "vpc" {
  value = {
    vpc = var.aws_existing_vpc_id == "" ? aws_vpc.vpc[0] : null
    igw = aws_internet_gateway.igw
  }
}