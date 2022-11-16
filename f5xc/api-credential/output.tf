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
    "name"                  = length(data.http.credential.*.response_body) > 0 ? jsondecode(data.http.credential.*.response_body[0]).object.metadata.name : null
    "type"                  = length(data.http.credential.*.response_body) > 0 ? jsondecode(data.http.credential.*.response_body[0]).object.spec.gc_spec.type : null
    "virtual_k8s_name"      = length(data.http.credential.*.response_body) > 0 ? jsondecode(data.http.credential.*.response_body[0]).object.spec.gc_spec.virtual_k8s_name : null
    "virtual_k8s_namespace" = length(data.http.credential.*.response_body) > 0 ? jsondecode(data.http.credential.*.response_body[0]).object.spec.gc_spec.virtual_k8s_namespace : null
    "expiration_timestamp"  = length(data.http.credential.*.response_body) > 0 ? jsondecode(data.http.credential.*.response_body[0]).object.spec.gc_spec.expiration_timestamp : null
    "k8s_conf"              = var.f5xc_api_credential_type == var.f5xc_api_credential_type_kube_config ? base64decode(jsondecode(data.local_file.response[0].content).data) : null
    "api_certificate"       = var.f5xc_api_credential_type == var.f5xc_api_credential_type_api_certificate ? jsondecode(data.local_file.response.*.content[0]).data : ""
  }
}