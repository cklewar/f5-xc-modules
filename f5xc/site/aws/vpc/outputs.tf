output "f5xc_aws_vpc" {
  value = {
    id     = volterra_aws_vpc_site.site.id
    name   = volterra_aws_vpc_site.site.name
    region = volterra_aws_vpc_site.site.aws_region
    params = volterra_tf_params_action.aws_vpc_action
    vpc_id = data.aws_vpc.vpc.id
    igw_id = data.aws_internet_gateway.igw.id
    nodes  = {
      master-0 = {
        interfaces = {
          slo = {
            id               = data.aws_network_interface.master-0-slo.*.id[0]
            private_ip       = data.aws_network_interface.master-0-slo.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-0-slo.*.private_dns_name[0]
            public_ip        = data.aws_network_interface.master-0-slo.*.association[0][0].public_ip
            public_dns_name  = data.aws_network_interface.master-0-slo.*.association[0][0].public_dns_name
            subnet_id        = data.aws_network_interface.master-0-slo.*.subnet_id[0]
          },
          sli = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? {
            id               = data.aws_network_interface.master-0-sli.*.id[0]
            private_ip       = data.aws_network_interface.master-0-sli.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-0-sli.*.private_dns_name[0]
            subnet_id        = data.aws_network_interface.master-0-sli.*.subnet_id[0]
            route_table_id   = data.aws_route_table.master-0-sli-rt.*.id[0]
          } : null
        }
      },
      master-1 = length(var.f5xc_aws_vpc_az_nodes) >= 2 ? {
        interfaces = {
          slo = {
            id               = data.aws_network_interface.master-1-slo.*.id[0]
            private_ip       = data.aws_network_interface.master-1-slo.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-1-slo.*.private_dns_name[0]
            public_ip        = data.aws_network_interface.master-1-slo.*.association[0][0].public_ip
            public_dns_name  = data.aws_network_interface.master-1-slo.*.association[0][0].public_dns_name
            subnet_id        = data.aws_network_interface.master-1-slo.*.subnet_id[0]
          },
          sli = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? {
            id               = data.aws_network_interface.master-1-sli.*.id[0]
            private_ip       = data.aws_network_interface.master-1-sli.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-1-sli.*.private_dns_name[0]
            subnet_id        = data.aws_network_interface.master-1-sli.*.subnet_id[0]
            route_table_id   = data.aws_route_table.master-1-sli-rt.*.id[0]
          } : null
        }
      } : null,
      master-2 = length(var.f5xc_aws_vpc_az_nodes) >= 2 ? {
        interfaces = {
          slo = {
            id               = data.aws_network_interface.master-2-slo.*.id[0]
            private_ip       = data.aws_network_interface.master-2-slo.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-2-slo.*.private_dns_name[0]
            public_ip        = data.aws_network_interface.master-2-slo.*.association[0][0].public_ip
            public_dns_name  = data.aws_network_interface.master-2-slo.*.association[0][0].public_dns_name
            subnet_id        = data.aws_network_interface.master-2-slo.*.subnet_id
          },
          sli = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic ? {
            id               = data.aws_network_interface.master-2-sli.*.id[0]
            private_ip       = data.aws_network_interface.master-2-sli.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-2-sli.*.private_dns_name[0]
            subnet_id        = data.aws_network_interface.master-2-sli.*.subnet_id[0]
            route_table_id   = data.aws_route_table.master-2-sli-rt.*.id[0]
          } : null
        }
      } : null
    }
    instance_type       = volterra_aws_vpc_site.site.instance_type
    workload_subnet_ids = var.f5xc_aws_ce_gw_type == var.f5xc_nic_type_multi_nic && length(data.aws_subnets.workload) > 0 ? data.aws_subnets.workload[0].ids : null
  }
}