resource "google_compute_instance_template" "instance_template" {
  tags         = var.gcp_instance_tags
  labels       = var.f5xc_cluster_labels
  name_prefix  = format("%s-", var.f5xc_cluster_name)
  description  = var.gcp_instance_template_description
  machine_type = var.gcp_instance_type

  disk {
    auto_delete  = true
    device_name  = format("%s-worker", var.f5xc_cluster_name)
    disk_size_gb = var.gcp_instance_disk_size
    source_image = var.gcp_instance_image
  }

  network_interface {
    subnetwork = var.gcp_subnetwork_slo
    dynamic "access_config" {
      for_each = var.has_public_ip ? [1] : []
      content {
        nat_ip = var.gcp_access_config_nat_ip != "" ? var.gcp_access_config_nat_ip : null
      }
    }
  }

  metadata = {
    ssh-keys           = "${var.ssh_username}:${var.ssh_public_key}"
    user-data          = var.f5xc_ce_user_data
    VmDnsSetting       = "ZonalPreferred"
    serial-port-enable = var.gcp_instance_serial_port_enable
  }

  service_account {
    email  = var.gcp_service_account_email != "" ? var.gcp_service_account_email : null
    scopes = var.gcp_service_account_scopes
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = all
  }

  timeouts {
    create = "15m"
    delete = "15m"
  }
}

resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  name                      = format("%s-worker", var.f5xc_cluster_name)
  region                    = var.gcp_region
  description               = var.gcp_instance_group_manager_description
  target_size               = var.f5xc_cluster_size
  base_instance_name        = format("%s-worker", var.f5xc_cluster_name)
  wait_for_instances        = var.gcp_instance_group_manager_wait_for_instances
  wait_for_instances_status = "STABLE"
  distribution_policy_zones = var.gcp_instance_group_manager_distribution_policy_zones

  version {
    instance_template = google_compute_instance_template.instance_template.id
  }

  stateful_disk {
    device_name = format("%s-worker", var.f5xc_cluster_name)
    delete_rule = "ON_PERMANENT_INSTANCE_DELETION"
  }

  update_policy {
    type                         = "OPPORTUNISTIC"
    minimal_action               = "RESTART"
    max_surge_fixed              = var.f5xc_cluster_size
    max_unavailable_fixed        = var.f5xc_cluster_size
    instance_redistribution_type = "NONE"
  }
}

resource "volterra_registration_approval" "nodes" {
  count        = length(local.node_names)
  retry        = var.f5xc_registration_retry
  hostname     = local.node_names[count.index]
  wait_time    = var.f5xc_registration_wait_time
  cluster_name = var.f5xc_cluster_name
  cluster_size = var.f5xc_cluster_size
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.f5xc_cluster_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  retry      = var.f5xc_registration_retry
  wait_time  = var.f5xc_registration_wait_time
}