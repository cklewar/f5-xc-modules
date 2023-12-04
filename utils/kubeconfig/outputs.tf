output "config" {
  value = data.http.kubeconfig.response_body
}

output "config_base64" {
  value = base64encode(data.http.kubeconfig.response_body)
}

output "file" {
  value = local_file.kubeconfig
}