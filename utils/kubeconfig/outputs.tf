output "config" {
  value = data.http.kubeconfig.response_body
}

output "file" {
  value = local_file.kubeconfig
}