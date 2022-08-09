output "f5xc_aws_vpc_id" {
  value = volterra_aws_vpc_site.vpc.id
}

output "f5xc_aws_vpc_name" {
  value = volterra_aws_vpc_site.vpc.name
}

output "aws_vpc" {
  value = {
    "name"          = volterra_aws_vpc_site.vpc.name
    "id"            = volterra_aws_vpc_site.vpc.id
    "region"        = volterra_aws_vpc_site.vpc.aws_region
    "instance_type" = volterra_aws_vpc_site.vpc.instance_type
  }
}