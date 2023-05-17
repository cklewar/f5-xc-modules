locals {
  is_multi_nic  = var.f5xc_ce_gateway_type == var.f5xc_ce_gateway_type_ingress_egress ? true : false
  is_multi_node = length(var.f5xc_vsphere_site_nodes) == 3 ? true : false
}