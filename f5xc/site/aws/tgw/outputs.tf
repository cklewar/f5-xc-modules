output "f5xc_aws_tgw" {
  value = {
    tgw                 = data.aws_ec2_transit_gateway.tgw
    tgw_vpc             = data.aws_vpc.tgw_vpc
    params              = volterra_tf_params_action.aws_tgw_action
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
          },
          sli = {
            id               = data.aws_network_interface.master-0-sli.*.id[0]
            private_ip       = data.aws_network_interface.master-0-sli.*.private_ip[0]
            private_dns_name = data.aws_network_interface.master-0-sli.*.private_dns_name[0]
            subnet_id        = data.aws_network_interface.master-0-sli.*.subnet_id[0]
            route_table_id   = data.aws_route_table.master-0-sli-rt.*.id[0]
          }
        }
      }
    }
  }
}