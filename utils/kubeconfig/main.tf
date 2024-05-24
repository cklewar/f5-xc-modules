resource "time_offset" "exp_time" {
  offset_days = 30
}

resource "terraform_data" "kubeconfig" {
  count = fileexists(local.kubeconfig) ? 0 : var.status_check_type == "cert" ? 1 : 0
  provisioner "local-exec" {
    command     = <<EOT
curl --cert-type P12 --cert "${var.f5xc_api_p12_file}":"${var.f5xc_api_p12_cert_password}" -s --output /dev/null -X 'GET' \
"${format("%s/%s/%s/%s", var.f5xc_api_url, var.f5xc_rest_uri_sites, var.f5xc_k8s_cluster_name, var.f5xc_k8s_config_types[var.f5xc_k8s_config_type])}" \
-H 'accept: application/data' \
-H 'Access-Control-Allow-Origin: *' \
-H 'x-volterra-apigw-tenant: '"${var.f5xc_tenant}")
EOT
    interpreter = ["/usr/bin/env", "bash", "-c"]
  }
}

data "http" "kubeconfig" {
  count  = fileexists(local.kubeconfig) ? 0 : var.status_check_type == "token" ? 1 : 0
  url    = format("%s/%s/%s/%s", var.f5xc_api_url, var.f5xc_rest_uri_sites, var.f5xc_k8s_cluster_name, var.f5xc_k8s_config_types[var.f5xc_k8s_config_type])
  method = "POST"
  request_headers = {
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
  request_body = jsonencode({ expiration_timestamp : time_offset.exp_time.rfc3339, site : var.f5xc_k8s_cluster_name })
}

resource "local_file" "kubeconfig" {
  content  = fileexists(local.kubeconfig) ? file(local.kubeconfig) : data.http.kubeconfig.0.response_body
  filename = local.kubeconfig
}