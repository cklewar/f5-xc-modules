output "kube_config" {
  value = ""
}

output "kube_config_public" {
  value = ""
}

output "cloud_config_master_primary" {
  value = local.cloud_config_master_primary
}

output "cloud_config_master" {
  value = local.cloud_config_master.*
}

output "cloud_config_pool" {
  value = local.cloud_config_pool
}