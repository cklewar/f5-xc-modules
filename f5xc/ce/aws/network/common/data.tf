data "aws_vpc" "vpc" {
  count = var.aws_existing_vpc_id != "" ? 1 : 0
  id    = var.aws_existing_vpc_id

  lifecycle {
    postcondition {
      condition     = self.enable_dns_hostnames && self.enable_dns_support
      error_message = "vpc attributes enable_dns_hostnames and enable_dns_support must be enabled"
    }
  }
}
