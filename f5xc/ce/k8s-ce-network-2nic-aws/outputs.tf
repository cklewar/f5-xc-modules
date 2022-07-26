output "network_cidr" {
  value = var.fabric_address_pool
}

output "subnet_private_id" {
  value = aws_subnet.volterra_subnet_private.id
}

output "subnet_inside_id" {
  value = aws_subnet.volterra_subnet_inside.id
}

output "dns_zone_id" {
  value = ""
}

output "dns_zone_name" {
  value = ""
}

output "security_group_private_id" {
  value = aws_security_group.volterra_security_group.id
}

output "target_group_arn" {
  value = aws_lb_target_group.controllers.arn
}

output "route_table_inside_id" {
  value = aws_route_table.volterra_inside_rt.id
}

output "dhcp_id" {
  value = ""
}

output "access_map" {
  value = []
}

output "balancer_ip" {
  value = aws_lb.nlb.dns_name
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.instance_profile.name
}