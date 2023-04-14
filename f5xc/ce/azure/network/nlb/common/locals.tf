locals {
  f5xc_site_set_vip_info_vip_params_per_az = [
    for node in var.f5xc_azure_az_nodes :
    {
      az      = node["f5xc_azure_az"]
      slo_vip = azurerm_lb.lb.private_ip_address
      sli_vip = ""
    }
  ]
}

