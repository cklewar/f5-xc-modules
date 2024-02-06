output "appstack" {
  value = {
    cluster    = volterra_k8s_cluster.cluster
    voltstack  = volterra_voltstack_site.cluster
    kubeconfig = module.kubeconfig
  }
}