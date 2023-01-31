locals {
  aws_availability_zone = format("%s%s", var.f5xc_aws_region, var.f5xc_aws_availability_zone)
  server_roles          = {
    node0 = { role = jsonencode(["etcd-server", "k8s-master-primary", "k8s-minion"]) },
    node1 = { role = jsonencode(["etcd-server", "k8s-master", "k8s-minion"])} ,
    node2 = jsonencode(["etcd-server", "k8s-master", "k8s-minion"])
  }
}