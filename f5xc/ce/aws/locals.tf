locals {
  server_roles = {
    node0 = jsonencode(["etcd-server", "k8s-master-primary", "k8s-minion"]),
    node1 = jsonencode(["etcd-server", "k8s-master", "k8s-minion"]),
    node2 = jsonencode(["etcd-server", "k8s-master", "k8s-minion"])
  }
}