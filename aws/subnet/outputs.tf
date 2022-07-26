output "aws_subnet_id" {
  value = {for idx, val in aws_subnet.subnet : idx => val.id}
}