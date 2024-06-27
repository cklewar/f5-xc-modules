output "config" {
  value     = fileexists(local.kubeconfig) ? file(local_file.kubeconfig.filename) : data.http.kubeconfig.0.response_body
  # sensitive = true
}

output "filename" {
  value = local_file.kubeconfig.filename
}

output "uri" {
  value = format("%s/%s/%s/%s", var.f5xc_api_url, var.f5xc_rest_uri_sites, var.f5xc_k8s_cluster_name, var.f5xc_k8s_config_types[var.f5xc_k8s_config_type])
}

/*output "command" {
  value = "curl --cert-type P12 --cert ${var.f5xc_api_p12_file}: ${var.f5xc_api_p12_cert_password} -s --output /dev/null -X 'GET ${format("%s/%s/%s/%s", var.f5xc_api_url, var.f5xc_rest_uri_sites, var.f5xc_k8s_cluster_name, var.f5xc_k8s_config_types[var.f5xc_k8s_config_type])} -H 'accept: application/data' -H 'Access-Control-Allow-Origin: *' -H 'x-volterra-apigw-tenant: '${var.f5xc_tenant})"
}

output "cert_password" {
  value = var.f5xc_api_p12_cert_password
}

output "cert" {
  value = var.f5xc_api_p12_file
}*/