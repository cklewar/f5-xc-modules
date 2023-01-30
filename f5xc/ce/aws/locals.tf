locals {
  aws_availability_zone = format("%s%s", var.f5xc_aws_region, var.f5xc_aws_availability_zone)
  server_roles          = [
    jsonencode(["etcd-server", "k8s-master", "k8s-minion"]),
    jsonencode(["etcd-server", "k8s-master-primary", "k8s-minion"])
  ]
  f5xc_aws_vpc_az_nodes = {
    node0 = { f5xc_aws_vpc_local_subnet = "192.168.168.0/24", f5xc_aws_vpc_az_name = local.aws_availability_zone },
    node1 = { f5xc_aws_vpc_local_subnet = "192.168.169.0/24", f5xc_aws_vpc_az_name = local.aws_availability_zone },
    node2 = { f5xc_aws_vpc_local_subnet = "192.168.170.0/24", f5xc_aws_vpc_az_name = local.aws_availability_zone }
  }
}