output "f5xc_aws_vpc" {
  value = {
    name               = volterra_aws_vpc_site.site.name
    id                 = volterra_aws_vpc_site.site.id
    sli_ip             = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? data.aws_network_interface.sli[0].private_ip : null
    slo_ip             = data.aws_network_interface.slo.private_ip
    region             = volterra_aws_vpc_site.site.aws_region
    instance_type      = volterra_aws_vpc_site.site.instance_type
    public_ip          = data.aws_network_interface.slo.association[0]["public_ip"]
    params             = volterra_tf_params_action.aws_vpc_action
    vpc_id             = data.aws_vpc.vpc.id
    workload_subnet_id = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? data.aws_subnet.workload[0].id : null
  }
}

