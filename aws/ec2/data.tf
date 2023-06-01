data "aws_network_interface" "interfaces" {
  count = length(aws_instance.instance.network_interface)
  id    = tolist(aws_instance.instance.network_interface)[count.index].network_interface_id
}