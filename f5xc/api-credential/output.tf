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
    "k8s_conf"              = var.f5xc_api_credential_type == var.f5xc_api_credential_type_kube_config && length(data.local_file.response) > 0 ? base64decode(jsondecode(data.local_file.response[0].content).data) : ""
    "api_certificate"       = var.f5xc_api_credential_type == var.f5xc_api_credential_type_api_certificate && length(data.local_file.response) > 0 ? jsondecode(data.local_file.response.*.content[0]).data : ""
    "data1"                 = fileexists(null_resource.apply_credential.triggers.filename)
    "data2"                 = fileexists("./_out/response.json")
    "data3"                 = null_resource.apply_credential.triggers.filename
    "data4"                 = fileexists("${path.root}/_out/response.json")
    "data5"                 = abspath(path.root)
    "data6"                 = abspath(path.module)
    "data7"                 = abspath(path.cwd)
    "data8"                 = "${path.root}/_out/response.json"
    "data9"                 = abspath("./_out/response.json")
    "data10"                = fileexists("${path.module}/_out/response.json")
    "data11"                = fileexists("${path.cwd}/_out/response.json")
    "data12"                = fileexists(abspath("${path.module}/_out/response.json"))
    "data13"                = "${abspath(path.module)}/_out/response.json"
    "data14"                = fileexists("${abspath(path.module)}/_out/response.json")
    "data15"                = fileexists(abspath(null_resource.apply_credential.triggers.filename))
  }
}