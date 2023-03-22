output "api_credential" {
  value = {
    "name"                  = var.f5xc_api_credentials_name
    "type"                  = length(data.http.credential.response_body) > 0 ? jsondecode(data.http.credential.response_body).object.spec.gc_spec.type : null
    "obj_name"              = length(data.http.credential.response_body) > 0 ? jsondecode(data.http.credential.response_body).object.metadata.name : null
    "k8s_conf"              = var.f5xc_api_credential_type == var.f5xc_api_credential_type_kube_config && length(data.local_file.state) > 0 ? base64decode(jsondecode(data.local_file.state.content).data) : ""
    "api_certificate"       = var.f5xc_api_credential_type == var.f5xc_api_credential_type_api_certificate && length(data.local_file.state) > 0 ? jsondecode(data.local_file.state.content).data : ""
    "virtual_k8s_name"      = length(data.http.credential.response_body) > 0 ? jsondecode(data.http.credential.response_body).object.spec.gc_spec.virtual_k8s_name : null
    "expiration_timestamp"  = length(data.http.credential.response_body) > 0 ? jsondecode(data.http.credential.response_body).object.spec.gc_spec.expiration_timestamp : null
    "virtual_k8s_namespace" = length(data.http.credential.response_body) > 0 ? jsondecode(data.http.credential.response_body).object.spec.gc_spec.virtual_k8s_namespace : null
  }
}