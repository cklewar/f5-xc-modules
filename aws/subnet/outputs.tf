output "aws_subnets" {
  value = {for subnet in aws_subnet.subnet : subnet.tags["Name"] => subnet}
}