resource "local_file" "vp_manager_environment" {
  content  = local.vp_manager_environment
  filename = format("%s/_out/%s", path.module, "vp_manager_environment")
}

resource "local_file" "vp_manager_pool" {
  content  = local.vp_manager_pool
  filename = format("%s/_out/%s", path.module, "vp_manager_pool.yml")
} w

resource "local_file" "vp_manager_master" {
  content  = local.vp_manager_master
  filename = format("%s/_out/%s", path.module, "vpm-master.yml")
}

resource "local_file" "vp_manager_master_primary" {
  content  = local.vp_manager_master_primary
  filename = format("%s/_out/%s", path.module, "vp_manager_master_primary.yml")
}

resource "local_file" "cloud_config_master" {
  content  = local.cloud_config_master
  filename = format("%s/_out/%s", path.module, "cloud-config-master-${var.template_suffix}.yml")
}

resource "local_file" "cloud-config-pool" {
  content  = local.cloud_config_pool
  filename = format("%s/_out/%s", path.module, "cloud-config-pool-${var.template_suffix}.yml")
}