resource "aws_ec2_instance_state" "state" {
  state       = var.aws_ec2_instance_state
  force       = var.aws_ec2_instance_state_forced_stop
  instance_id = var.aws_ec2_instance_id
}