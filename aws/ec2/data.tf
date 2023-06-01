data "aws_network_interface" "outside" {
  depends_on = [aws_instance.instance]
  id         = tolist(aws_instance.instance.network_interface)[0].network_interface_id
}

data "aws_network_interface" "inside" {
  depends_on = [aws_instance.instance]
  count      = length(aws_instance.instance.network_interface) > 1 ? 1 : 0
  id         = tolist(aws_instance.instance.network_interface)[1].network_interface_id
}