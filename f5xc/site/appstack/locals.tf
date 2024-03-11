locals {
  common_tags = {
    "kubernetes.io/cluster/${var.f5xc_cluster_name}" = "owned"
    "Owner"                                          = var.owner_tag
  }
  common_tags_worker = {
    "kubernetes.io/cluster/${var.f5xc_cluster_name}" = "owned"
    "Owner"                                          = var.owner_tag
    "deployment"                                     = var.f5xc_cluster_name
  }
  kubeconfig = format("./%s.kubeconfig", var.f5xc_cluster_name)
}
