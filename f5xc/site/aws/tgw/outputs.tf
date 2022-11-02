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
  }
}