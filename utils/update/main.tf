data "http" "get" {
  url = format("%s/%s?response_format=GET_RSP_FORMAT_DEFAULT", var.f5xc_api_url, var.f5xc_api_get_uri)
  method = "GET"
  request_headers = {
    Accept                      = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
    x-volterra-apigw-tenant     = var.f5xc_tenant
    Access-Control-Allow-Origin = "*"
  }
  provider = http-full
}

locals {
  command = var.del_key != "" ? "echo '${data.http.get.response_body}' | jq . | jq 'del(.spec.${var.merge_key}.${var.del_key})' | jq '.spec.${var.merge_key} +=${var.merge_data}' > ${var.output_file_name}" : "echo '${data.http.get.response_body}' | jq . | jq '.spec.${var.merge_key} +=${var.merge_data}' > ${var.output_file_name}"
}

resource "terraform_data" "merge" {
  depends_on = [data.http.get]
  /*lifecycle {
    replace_triggered_by = [data.http.get]
  }*/
  triggers_replace = timestamp()
  provisioner "local-exec" {
    command = local.command
  }
}

data "local_file" "data" {
  depends_on = [terraform_data.merge]
  filename = var.output_file_name
}

data "http" "update" {
  depends_on = [data.local_file.data]
  url = format("%s/%s?response_format=GET_RSP_FORMAT_DEFAULT", var.f5xc_api_url, var.f5xc_api_update_uri)
  method = "PUT"
  request_headers = {
    Accept                      = "application/json"
    Authorization = format("APIToken %s", var.f5xc_api_token)
    x-volterra-apigw-tenant     = var.f5xc_tenant
    Access-Control-Allow-Origin = "*"
  }
  request_body = data.local_file.data.content
  provider     = http-full
}