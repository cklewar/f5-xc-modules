#output "aws_subnet_id" {
#  value = {for idx, val in aws_subnet.subnet : idx => val.id}
#}

output "aws_subnets" {
  value = {for key, val in aws_subnet.subnet : key => val}
}