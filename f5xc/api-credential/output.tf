output "api_credential" {
  value = {
    "name"                  = volterra_api_credential.credential.name
    "id"                    = volterra_api_credential.credential.id
    "type"                  = volterra_api_credential.credential.api_credential_type
    "vk8s_name"             = volterra_api_credential.credential.virtual_k8s_name
    "virtual_k8s_namespace" = volterra_api_credential.credential.virtual_k8s_namespace
  }
}