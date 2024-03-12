output "eut" {
  value = {
    type = "appstack"
    data = {
      tenant = var.f5xc_tenant
      # kubeconfig = module.kubeconfig_testbed.config
    }
  }
}

output "path" {
  value = {
    module   = path.module
    cwd      = path.cwd
    root     = path.root
    absolute = abspath(path.module)
  }
}

output "k8s_config_infra" {
  value = module.kubeconfig_infrastructure
}