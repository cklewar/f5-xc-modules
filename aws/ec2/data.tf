/*data "aws_network_interface" "interfaces" {
  for_each = {for interface in aws_instance.instance.network_interface : interface.network_interface_id => interface}
  id = each.value.network_interface_id
}*/

data "aws_network_interface" "interfaces" {
  count = length(aws_instance.instance.network_interface)
  id    = tolist(aws_instance.instance.network_interface)[count.index].network_interface_id
}