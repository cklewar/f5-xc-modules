output "f5xc_aws_vpc" {
  value = {
    name               = volterra_aws_vpc_site.site.name
    id                 = volterra_aws_vpc_site.site.id
    sli_ip             = data.aws_network_interface.sli.private_ip
    slo_ip             = data.aws_network_interface.slo.private_ip
    region             = volterra_aws_vpc_site.site.aws_region
    instance_type      = volterra_aws_vpc_site.site.instance_type
    public_ip          = data.aws_network_interface.slo.association[0]["public_ip"]
    params             = volterra_tf_params_action.aws_vpc_action
    vpc_id             = data.aws_vpc.vpc.id
    workload_subnet_id = data.aws_subnet.workload.id
  }
}

