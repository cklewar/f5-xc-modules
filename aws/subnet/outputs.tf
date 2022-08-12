output "aws_subnets" {
  value = {for val in aws_subnet.subnet : val.tags["Name"] => val}
}