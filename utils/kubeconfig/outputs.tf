output "config" {
  value     = fileexists(local.kubeconfig) ? file(local_file.kubeconfig.filename) : data.http.kubeconfig.0.response_body
  # sensitive = true
}

output "filename" {
  value = local_file.kubeconfig.filename
}