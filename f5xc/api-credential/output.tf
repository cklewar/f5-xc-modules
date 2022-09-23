/*output "api_credential" {
  value = {
    "name"                  = volterra_api_credential.credential.name
    "id"                    = volterra_api_credential.credential.id
    "type"                  = volterra_api_credential.credential.api_credential_type
    "vk8s_name"             = volterra_api_credential.credential.virtual_k8s_name
    "virtual_k8s_namespace" = volterra_api_credential.credential.virtual_k8s_namespace
    "data"                  = volterra_api_credential.credential.data
  }
}*/

output "api_credential" {
  value = {
    "name"                  = jsondecode(data.http.credential.response_body).object.metadata.name
    "type"                  = jsondecode(data.http.credential.response_body).object.spec.gc_spec.type
    "virtual_k8s_name"      = jsondecode(data.http.credential.response_body).object.spec.gc_spec.virtual_k8s_name
    "virtual_k8s_namespace" = jsondecode(data.http.credential.response_body).object.spec.gc_spec.virtual_k8s_namespace
    "expiration_timestamp"  = jsondecode(data.http.credential.response_body).object.spec.gc_spec.expiration_timestamp
    "data"                  = jsondecode(data.local_file.response.content).data
  }
}