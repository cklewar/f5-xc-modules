output "vk8s" {
  value = {
    "name"        = volterra_virtual_k8s.vk8s.name
    "id"          = volterra_virtual_k8s.vk8s.id
    "k8s_conf" = var.f5xc_create_k8s_creds == true && length(module.api_credential_kubeconfig) > 0 ? base64decode(module.api_credential_kubeconfig.*.api_credential[0]["data"]) : null
  }
}