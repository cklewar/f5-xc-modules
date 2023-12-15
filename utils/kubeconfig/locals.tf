locals {
  kubeconfig = format("%s/%s.kubeconfig", local.output_dir_path, var.f5xc_k8s_cluster_name)
  output_dir_path = var.output_dir_path != "" ? var.output_dir_path : abspath("./_out/")
}