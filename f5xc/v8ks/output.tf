output "vk8s" {
  value = {
    "name"     = volterra_virtual_k8s.vk8s.name
    "id"       = volterra_virtual_k8s.vk8s.id
    "k8s_conf" = var.f5xc_create_k8s_creds == true && module.api_credential_kubeconfig.*.api_credential.k8s_conf != null ?  module.api_credential_kubeconfig.*.api_credential.k8s_conf[0] : null
    "test123"  = module.api_credential_kubeconfig.*.api_credential.name
  }
}