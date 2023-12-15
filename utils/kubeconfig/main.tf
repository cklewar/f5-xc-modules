resource "time_offset" "exp_time" {
  offset_days = 30
}

data "http" "kubeconfig" {
  count           = fileexists(local.kubeconfig) ? 0 : 1
  url             = format("%s/%s/%s/%s", var.f5xc_api_url, var.f5xc_rest_uri_sites, var.f5xc_k8s_cluster_name, var.f5xc_k8s_config_types[var.f5xc_k8s_config_type])
  method          = "POST"
  request_headers = {
    Authorization = format("APIToken %s", var.f5xc_api_token)
  }
  request_body = jsonencode({ expiration_timestamp : time_offset.exp_time.rfc3339, site : var.f5xc_k8s_cluster_name })
}

resource "local_file" "kubeconfig" {
  content  = fileexists(local.kubeconfig) ? file(local.kubeconfig) : data.http.kubeconfig.0.response_body
  filename = local.kubeconfig
}