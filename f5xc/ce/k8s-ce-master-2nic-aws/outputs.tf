output "machine_config" {
  value = var.machine_config
}

output "addresses" {
  value = aws_network_interface.compute_nic_private.*.private_ip
}

output "inside_addresses" {
  value = aws_network_interface.compute_nic_inside.*.private_ip
}

output "public_addresses" {
  value = aws_eip.compute_public_ip.*.public_ip
}

output "machines" {
  value = aws_instance.volterra_ce.*.id
}

output "inside_intf_ids" {
  value = aws_network_interface.compute_nic_inside.*.id
}

output "aws_instance_id" {
  value = aws_instance.volterra_ce.*.id
}
