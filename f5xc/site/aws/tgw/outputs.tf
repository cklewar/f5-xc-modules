output "f5xc_aws_tgw" {
  value = {
    tgw_id                  = data.aws_ec2_transit_gateway.tgw.id
    tgw_owner_id            = data.aws_ec2_transit_gateway.tgw.owner_id
    ce_master_public_ip     = data.aws_instance.ce_master.public_ip
    //tgw_subnet_sli      = {for k, v in data.aws_subnet.tgw_subnet_sli : k => v}
    tgw_subnet_slo_existing = {for k, v in data.aws_subnet.tgw_subnet_slo : k => v}
    tgw_subnet_workload     = {for k, v in data.aws_subnet.tgw_subnet_workload : k => v}
    params                  = volterra_tf_params_action.aws_tgw_action
  }
}

