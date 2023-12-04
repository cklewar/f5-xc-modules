output "kubeconfig" {
  value = data.http.kubeconfig.response_body
}

output "local_file" {
  value = local_file.kubeconfig
}