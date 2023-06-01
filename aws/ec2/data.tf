/*data "aws_network_interface" "inside" {
  id = aws_instance.instance.network_interface
}*/

/*data "aws_network_interface" "outside" {
  id = aws_instance.instance.network_interface[1]
}*

/*data "aws_network_interface" "interfaces" {
  count = length(aws_instance.instance.network_interface)
  id    = tolist(aws_instance.instance.network_interface)[count.index].network_interface_id
}*/