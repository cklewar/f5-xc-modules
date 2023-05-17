output "f5xc_aws_tgw" {
  value = {
    tgw                 = data.aws_ec2_transit_gateway.tgw
    tgw_vpc             = data.aws_vpc.tgw_vpc
    tgw_nlb             = var.f5xc_aws_tgw_enable_internet_vip ? data.aws_lb.tgw_nlb[0] : null
    params              = volterra_tf_params_action.aws_tgw_action
    site_name           = volterra_aws_tgw_site.site.name
    namespace           = volterra_aws_tgw_site.site.namespace
    workload_subnet_ids = length(data.aws_subnets.workload) > 0 ? data.aws_subnets.workload.ids : null
    nodes               = {
      master-0 = {
        id         = data.aws_instance.master-0.id
        name       = data.aws_instance.master-0.tags["Name"]
        interfaces = {
          slo = {
            id               = data.aws_network_interface.master-0-slo.*.id[0]
            private_ip       = data.aws_network_interface.master-0-slo.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-0-slo.*.private_dns_name[0]
            public_ip        = data.aws_network_interface.master-0-slo.*.association[0][0].public_ip
            public_dns_name  = data.aws_network_interface.master-0-slo.*.association[0][0].public_dns_name
            subnet_id        = data.aws_network_interface.master-0-slo.*.subnet_id[0]
            security_groups  = data.aws_network_interface.master-0-slo.*.security_groups
          },
          sli = {
            id               = data.aws_network_interface.master-0-sli.*.id[0]
            private_ip       = data.aws_network_interface.master-0-sli.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-0-sli.*.private_dns_name[0]
            subnet_id        = data.aws_network_interface.master-0-sli.*.subnet_id[0]
            route_table_id   = data.aws_route_table.master-0-sli-rt.*.id[0]
            security_groups  = data.aws_network_interface.master-0-sli.*.security_groups
          }
        }
      }
      master-1 = length(var.f5xc_aws_tgw_az_nodes) >= 2 ? {
        id         = data.aws_instance.master-1[0].id
        name       = data.aws_instance.master-1[0].tags["Name"]
        interfaces = {
          slo = {
            id               = data.aws_network_interface.master-1-slo.*.id[0]
            private_ip       = data.aws_network_interface.master-1-slo.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-1-slo.*.private_dns_name[0]
            public_ip        = data.aws_network_interface.master-1-slo.*.association[0][0].public_ip
            public_dns_name  = data.aws_network_interface.master-1-slo.*.association[0][0].public_dns_name
            subnet_id        = data.aws_network_interface.master-1-slo.*.subnet_id[0]
            security_groups  = data.aws_network_interface.master-1-slo.*.security_groups
          },
          sli = {
            id               = data.aws_network_interface.master-1-sli.*.id[0]
            private_ip       = data.aws_network_interface.master-1-sli.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-1-sli.*.private_dns_name[0]
            subnet_id        = data.aws_network_interface.master-1-sli.*.subnet_id[0]
            route_table_id   = data.aws_route_table.master-1-sli-rt.*.id[0]
            security_groups  = data.aws_network_interface.master-1-sli.*.security_groups
          }
        }
      } : null,
      master-2 = length(var.f5xc_aws_tgw_az_nodes) >= 2 ? {
        id         = data.aws_instance.master-2[0].id
        name       = data.aws_instance.master-2[0].tags["Name"]
        interfaces = {
          slo = {
            id               = data.aws_network_interface.master-2-slo.*.id[0]
            private_ip       = data.aws_network_interface.master-2-slo.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-2-slo.*.private_dns_name[0]
            public_ip        = data.aws_network_interface.master-2-slo.*.association[0][0].public_ip
            public_dns_name  = data.aws_network_interface.master-2-slo.*.association[0][0].public_dns_name
            subnet_id        = data.aws_network_interface.master-2-slo.*.subnet_id[0]
            security_groups  = data.aws_network_interface.master-2-slo.*.security_groups
          },
          sli = {
            id               = data.aws_network_interface.master-2-sli.*.id[0]
            private_ip       = data.aws_network_interface.master-2-sli.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-2-sli.*.private_dns_name[0]
            subnet_id        = data.aws_network_interface.master-2-sli.*.subnet_id[0]
            route_table_id   = data.aws_route_table.master-2-sli-rt.*.id[0]
            security_groups  = data.aws_network_interface.master-2-sli.*.security_groups
          }
        }
      } : null
    }
  }
}