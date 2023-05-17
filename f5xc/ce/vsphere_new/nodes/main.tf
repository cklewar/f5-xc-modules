resource "volterra_token" "token" {
  name      = var.f5xc_cluster_name
  namespace = var.f5xc_namespace
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.f5xc_node_name
  memory           = var.vsphere_instance_memory_size
  num_cpus         = var.vsphere_instance_cpu_count
  guest_id         = var.vsphere_instance_guest_type
  datastore_id     = data.vsphere_datastore.ds.id
  datacenter_id    = var.f5xc_ova_image != "" ? data.vsphere_datacenter.dc.id : null
  host_system_id   = data.vsphere_host.host.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id

  network_interface {
    network_id   = data.vsphere_network.outside.id
    adapter_type = var.vsphere_instance_network_adapter_type
  }

  dynamic "network_interface" {
    for_each = var.is_multi_nic ? [1] : []
    content {
      network_id   = data.vsphere_network.inside.id
      adapter_type = var.vsphere_instance_network_adapter_type
    }
  }

  disk {
    label            = "disk0"
    size             = var.vsphere_virtual_machine_disk_size
    eagerly_scrub    = false
    thin_provisioned = false
  }

  dynamic "ovf_deploy" {
    for_each = var.f5xc_ova_image != "" ? [1] : []
    content {
      allow_unverified_ssl_cert = true
      local_ovf_path            = var.f5xc_ova_image
      disk_provisioning         = "thick"
      ovf_network_map           = var.is_multi_nic ? {
        OUTSIDE = data.vsphere_network.outside.id
        REGULAR = data.vsphere_network.inside.id
      } : {
        OUTSIDE = data.vsphere_network.outside.id
      }
    }
  }

  dynamic "clone" {
    for_each = var.f5xc_vsphere_instance_template != "" ? [1] : []
    content {
      template_uuid = data.vsphere_virtual_machine.template[0].id
    }
  }

  vapp {
    properties = {
      "guestinfo.ves.certifiedhardware"           = var.f5xc_certified_hardware,
      "guestinfo.interface.0.ip.0.address"        = var.vsphere_instance_outside_interface_ip_address,
      "guestinfo.interface.0.name"                = var.vsphere_instance_outside_interface_name,
      "guestinfo.interface.0.route.0.destination" = var.vsphere_instance_outside_interface_default_route,
      "guestinfo.interface.0.dhcp"                = var.vsphere_instance_outside_interface_dhcp ? "yes" : "no",
      "guestinfo.interface.0.role"                = var.vsphere_instance_outside_interface_role,
      "guestinfo.interface.0.route.0.gateway"     = var.vsphere_instance_outside_interface_default_gateway,
      "guestinfo.dns.server.0"                    = var.vsphere_instance_dns_servers.primary,
      "guestinfo.dns.server.1"                    = var.vsphere_instance_dns_servers.secondary,
      "guestinfo.ves.regurl"                      = var.f5xc_reg_url,
      "guestinfo.hostname"                        = var.f5xc_node_name
      "guestinfo.ves.clustername"                 = var.f5xc_cluster_name,
      "guestinfo.ves.latitude"                    = var.f5xc_site_latitude,
      "guestinfo.ves.longitude"                   = var.f5xc_site_longitude,
      "guestinfo.ves.adminpassword"               = var.vsphere_instance_admin_password,
      "guestinfo.ves.token"                       = volterra_token.token.id
    }
  }

  lifecycle {
    ignore_changes = [
      annotation,
      disk[0].io_share_count,
      disk[1].io_share_count,
      disk[2].io_share_count,
      vapp[0].properties,
    ]
  }
}

resource "volterra_registration_approval" "ce" {
  depends_on   = [vsphere_virtual_machine.vm]
  cluster_name = var.f5xc_cluster_name
  hostname     = var.f5xc_node_name
  cluster_size = length(var.f5xc_vsphere_site_nodes)
  retry        = var.f5xc_registration_retry
  wait_time    = var.f5xc_registration_wait_time
}

resource "volterra_site_state" "decommission_when_delete" {
  depends_on = [volterra_registration_approval.ce]
  name       = var.f5xc_cluster_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  retry      = var.f5xc_registration_retry
  wait_time  = var.f5xc_registration_wait_time
}