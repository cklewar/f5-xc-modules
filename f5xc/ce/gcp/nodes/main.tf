resource "google_compute_instance" "instance" {
  name                      = var.instance_name
  machine_type              = var.machine_type
  allow_stopping_for_update = var.allow_stopping_for_update
  tags                      = var.instance_tags

  boot_disk {
    initialize_params {
      image = var.machine_image
      size  = var.machine_disk_size
    }
  }

  network_interface {
    subnetwork = var.slo_subnetwork
    dynamic "access_config" {
      for_each = var.use_public_ip ? [1] : []
      content {}
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
    email = var.gcp_service_account_email
    scopes = ["cloud-platform"]
  }
}

resource "volterra_registration_approval" "nodes" {
  depends_on   = [google_compute_instance.instance]
  cluster_name = var.instance_name
  cluster_size = var.f5xc_cluster_size
  hostname     = var.instance_name
  wait_time    = var.f5xc_registration_wait_time
  retry        = var.f5xc_registration_retry
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.nodes]
  name       = var.instance_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = var.f5xc_registration_wait_time
  retry      = var.f5xc_registration_retry
}

module "site_wait_for_online" {
  depends_on     = [volterra_site_state.decommission_when_delete]
  source         = "../../../status/site"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_namespace = var.f5xc_namespace
  f5xc_site_name = google_compute_instance.instance.name
  f5xc_tenant    = var.f5xc_tenant
}
