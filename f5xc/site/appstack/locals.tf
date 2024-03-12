locals {
  common_tags = {
    "kubernetes.io/cluster/${var.f5xc_cluster_name}" = "owned"
    "Owner"                                          = var.owner_tag
  }
  common_tags_worker = {
    "kubernetes.io/cluster/${var.f5xc_cluster_name}" = "owned"
    "Owner"                                          = var.owner_tag
    "deployment"                                     = var.f5xc_cluster_name
  }
  master_vmi_manifest = [
    for counter in range(var.master_nodes_count) :
    templatefile("${path.module}/templates/${var.master_node_manifest_template}.yaml", {
      network                    = counter % 2 == 0 ? "ves-system/sb-infra-lab-v5-eno5np0-251-vfio" : "ves-system/sb-infra-lab-v5-eno6np1-251-vfio"
      latitude                   = var.f5xc_cluster_latitude
      longitude                  = var.f5xc_cluster_longitude
      host_name                  = format("m%d", counter)
      ip_address                 = "${var.master_node_ip_address_prefix}${counter + 10}/${var.master_node_ip_address_suffix}"
      ip_gateway                 = var.ip_gateway
      cluster_name               = var.f5xc_cluster_name
      maurice_endpoint           = module.maurice.endpoints.maurice
      master_node_cpus           = var.master_node_cpus
      master_node_memory         = var.master_node_memory
      f5xc_rhel9_container       = var.f5xc_rhel9_container
      site_registration_token    = var.site_registration_token != "" ? var.site_registration_token : volterra_token.token.id
      maurice_private_endpoint   = module.maurice.endpoints.maurice_mtls
      certified_hardware_profile = var.f5xc_certified_hardware_profile
    })
  ]

  worker_vmi_manifest = [
    for counter in range(var.worker_nodes_count) :
    templatefile("${path.module}/templates/${var.worker_node_manifest_template}.yaml", {
      latitude                   = var.f5xc_cluster_latitude
      longitude                  = var.f5xc_cluster_longitude
      network                    = counter % 2 == 0 ? "ves-system/sb-infra-lab-v5-eno6np1-251-vfio" : "ves-system/sb-infra-lab-v5-eno5np0-251-vfio"
      host_name                  = format("w%d", counter)
      ip_address                 = "${var.worker_node_ip_address_prefix}${counter + 10}/${var.worker_node_ip_address_suffix}"
      ip_gateway                 = var.ip_gateway
      cluster_name               = var.f5xc_cluster_name
      maurice_endpoint           = module.maurice.endpoints.maurice
      worker_node_cpus           = var.worker_node_cpus
      worker_node_memory         = var.worker_node_memory
      f5xc_rhel9_container       = var.f5xc_rhel9_container
      site_registration_token    = var.site_registration_token != "" ? var.site_registration_token : volterra_token.token.id
      maurice_private_endpoint   = module.maurice.endpoints.maurice_mtls
      certified_hardware_profile = var.f5xc_certified_hardware_profile
    })
  ]
}
