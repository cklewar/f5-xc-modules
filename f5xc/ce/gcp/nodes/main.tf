resource "google_compute_instance" "instance" {
  name                      = var.f5xc_node_name
  tags                      = var.instance_tags
  zone                      = var.availability_zone
  labels                    = var.f5xc_cluster_labels
  machine_type              = var.instance_type
  allow_stopping_for_update = var.allow_stopping_for_update

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = var.instance_disk_size
    }
  }

  network_interface {
    subnetwork = var.slo_subnetwork
    dynamic "access_config" {
      for_each = var.has_public_ip ? [1] : []
      content {
        nat_ip = var.access_config_nat_ip != "" ? var.access_config_nat_ip : null
      }
    }
  }

  dynamic "network_interface" {
    for_each = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? [1] : []
    content {
      subnetwork = var.sli_subnetwork
    }
  }

  metadata = {
    ssh-keys  = "${var.ssh_username}:${var.ssh_public_key}"
    user-data = var.f5xc_ce_user_data
  }

  service_account {
    email  = var.gcp_service_account_email != "" ? var.gcp_service_account_email : null
    scopes = var.gcp_service_account_scopes
  }

  lifecycle {
    ignore_changes = all
  }

  timeouts {
    create = "15m"
    delete = "15m"
    update = "15m"
  }
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [google_compute_instance.instance]
  cluster_name = var.f5xc_cluster_name
  cluster_size = var.f5xc_cluster_size
  hostname     = var.f5xc_node_name
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.f5xc_node_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = var.f5xc_registration_wait_time
  retry      = var.f5xc_registration_retry
}