data "aws_key_pair" "existing_aws_key" {
  count              = var.aws_existing_key_pair_id != null ? 1 : 0
  key_pair_id        = var.aws_existing_key_pair_id
  include_public_key = true
}

data "aws_iam_instance_profile" "existing_iam_profile" {
  count = var.aws_existing_iam_profile_name != null ? 1 : 0
  name  = var.aws_existing_iam_profile_name
}

data "aws_iam_role" "existing_iam_role" {
  count = var.aws_existing_iam_profile_name != null ? 1 : 0
  name  = data.aws_iam_instance_profile.existing_iam_profile.0.role_name
}