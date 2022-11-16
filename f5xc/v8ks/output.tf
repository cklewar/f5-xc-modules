output "vk8s" {
  value = {
    "name"        = volterra_virtual_k8s.vk8s.name
    "id"          = volterra_virtual_k8s.vk8s.id
    "kube_config" = var.f5xc_create_k8s_creds == true ? base64decode(module.api_credential_kubeconfig.api_credential["data"]) : null
  }
}