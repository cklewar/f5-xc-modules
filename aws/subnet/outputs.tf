output "aws_subnets" {
  value = {for subnet in aws_subnet.subnet : subnet.tags["Name"] => subnet}
}

output "aws_subnets_id" {
  value = [for s in aws_subnet.subnet: s["id"]]
}