output "eut" {
  value = {
    type = "appstack"
    data = {
      tenant     = var.f5xc_tenant
      kubeconfig = module.kubeconfig_testbed.config
    }
  }
}