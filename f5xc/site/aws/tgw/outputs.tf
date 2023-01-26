output "f5xc_aws_tgw" {
  value = {
    id         = data.aws_ec2_transit_gateway.tgw.id
    name       = volterra_aws_tgw_site.site.name
    owner_id   = data.aws_ec2_transit_gateway.tgw.owner_id
    public_ip  = data.aws_instance.ce_master.public_ip
    public_dns = data.aws_instance.ce_master.public_dns
    //sli_ip  = {for k, v in data.aws_subnet.tgw_subnet_sli : k => v}
    //slo_ip  = {for k, v in data.aws_subnet.tgw_subnet_slo : k => v}
    //tgw_inside_ip  = ""
    //tgw_outside_ip = ""
    //tgw_subnet_workload = {for k, v in data.aws_subnet.tgw_subnet_workload : k => v}
    params     = volterra_tf_params_action.aws_tgw_action
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
  }
}