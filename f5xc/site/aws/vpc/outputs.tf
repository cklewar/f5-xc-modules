output "f5xc_aws_vpc" {
  value = {
    id     = volterra_aws_vpc_site.site.id
    name   = volterra_aws_vpc_site.site.name
    region = volterra_aws_vpc_site.site.aws_region
    params = volterra_tf_params_action.aws_vpc_action
    vpc_id = data.aws_vpc.vpc.id
    nodes  = {
    for id in data.aws_instances.nodes.ids : id => {
      interfaces = {
        slo = {
          id               = data.aws_network_interface.slo.*.id
          private_ip       = data.aws_network_interface.slo.*.private_ip
          private_dns_name = data.aws_network_interface.slo.*.private_dns_name
          public_ip        = data.aws_network_interface.slo.*.association[0][0].public_ip
          public_dns_name  = data.aws_network_interface.slo.*.association[0][0].public_dns_name
          subnet_id        = data.aws_network_interface.slo.*.subnet_id
        }
        sli = {
          id               = data.aws_network_interface.sli.*.id
          private_ip       = data.aws_network_interface.sli.*.private_ip
          private_dns_name = data.aws_network_interface.sli.*.private_dns_name
          subnet_id        = data.aws_network_interface.sli.*.subnet_id
        }
      }
    }
    }
    instance_type      = volterra_aws_vpc_site.site.instance_type
    workload_subnet_id = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? data.aws_subnets.workload[0].ids : null
  }
}