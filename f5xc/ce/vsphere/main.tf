resource "vsphere_virtual_machine" "vm" {
  for_each         = {for k,v in var.nodes: k => v}
  name             = format("%s-%s", var.cluster_name, each.value.name)
  datacenter_id    = data.vsphere_datacenter.dc.id
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds[each.key].id
  host_system_id   = data.vsphere_host.host[each.key].id

  num_cpus = var.cpus
  memory   = var.memory
  guest_id = var.guest_type

  network_interface {
    network_id   = data.vsphere_network.outside.id
    adapter_type = "vmxnet3"
  }
  dynamic "network_interface" {
    for_each = var.inside_network == "" ? [] : [0]
    content {
      network_id   = data.vsphere_network.inside.id
      adapter_type = "vmxnet3"
    }
  }

  disk {
    label            = "disk0"
    size             = 40
    eagerly_scrub    = false
    thin_provisioned = false
  }

  ovf_deploy {
    allow_unverified_ssl_cert = true
    local_ovf_path            = var.f5xc_ova_image

    disk_provisioning = "thick"

    ovf_network_map = var.inside_network == "" ? { 
      "OUTSIDE" = data.vsphere_network.outside.id 
    } : {
      "OUTSIDE" = data.vsphere_network.outside.id
      "REGULAR" = data.vsphere_network.inside.id
    }
  }

  vapp {
    properties = {
      "guestinfo.ves.certifiedhardware"           = var.certifiedhardware,
      "guestinfo.interface.0.ip.0.address"        = each.value.ipaddress,
      "guestinfo.interface.0.name"                = "eth0",
      "guestinfo.interface.0.route.0.destination" = var.publicdefaultroute,
      "guestinfo.interface.0.dhcp"                = "no",
      "guestinfo.interface.0.role"                = "public",
      "guestinfo.interface.0.route.0.gateway"     = var.publicdefaultgateway,
      "guestinfo.dns.server.0"                    = var.dnsservers["primary"],
      "guestinfo.dns.server.1"                    = var.dnsservers["secondary"],
      "guestinfo.ves.regurl"                      = var.f5xc_reg_url,
      "guestinfo.hostname"                        = each.value.name,
      "guestinfo.ves.clustername"                 = var.cluster_name,
      "guestinfo.ves.latitude"                    = var.sitelatitude,
      "guestinfo.ves.longitude"                   = var.sitelongitude,
      "guestinfo.ves.adminpassword"               = var.admin_password,
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

resource "volterra_token" "token" {
  name = format("%s-token", var.cluster_name)
  namespace = "system"
}

module "site_wait_for_online" {
  depends_on     = [volterra_registration_approval.ce]
  source         = "../../status/site"
  f5xc_namespace = "system"
  f5xc_api_token = var.f5xc_api_token
  f5xc_api_url   = var.f5xc_api_url
  f5xc_site_name = var.cluster_name
  f5xc_tenant    = var.f5xc_tenant
}

resource "volterra_registration_approval" "ce" {
  for_each      = {for k,v in var.nodes: k => v}
  depends_on    = [vsphere_virtual_machine.vm[0]]
  cluster_name  = var.cluster_name
  hostname      = each.value.name
  cluster_size  = length(var.nodes)
  retry = 25
  wait_time = 30
}

resource "volterra_site_state" "decommission_when_delete" {
  name       = var.cluster_name
  when       = "delete"
  state      = "DECOMMISSIONING"
  wait_time  = 60
  retry      = 5
  depends_on = [volterra_registration_approval.ce]
}

resource "volterra_modify_site" "site" {
  namespace               = "system"
  name                    = var.cluster_name
  labels                  = var.custom_labels
  outside_vip             = var.outside_vip
  vip_vrrp_mode           = var.outside_vip == "" ? "VIP_VRRP_DISABLE" : "VIP_VRRP_ENABLE"
  site_to_site_tunnel_ip  = var.outside_vip == "" ? split("/",var.nodes[0]["ipaddress"])[0] : var.outside_vip
  depends_on              = [volterra_registration_approval.ce]
}

output "vm" {
  value = vsphere_virtual_machine.vm
}
