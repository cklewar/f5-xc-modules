output "kube_config" {
  value = ""
}

output "kube_config_public" {
  value = ""
}

output "cloud_config_master_primary" {
  value = data.template_file.cloud_config_master_primary.rendered
}

output "cloud_config_master" {
  value = data.template_file.cloud_config_master.*.rendered
}

output "cloud_config_pool" {
  value = data.template_file.cloud_config_pool.rendered
}