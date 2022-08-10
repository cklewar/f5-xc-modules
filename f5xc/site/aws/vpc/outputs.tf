output "f5xc_aws_vpc_id" {
  value = volterra_aws_vpc_site.site.id
}

output "f5xc_aws_vpc_name" {
  value = volterra_aws_vpc_site.site.name
}

output "aws_vpc" {
  value = {
    name          = volterra_aws_vpc_site.site.name
    id            = volterra_aws_vpc_site.site.id
    region        = volterra_aws_vpc_site.site.aws_region
    instance_type = volterra_aws_vpc_site.site.instance_type
    params        = volterra_tf_params_action.aws_vpc_action
  }
}