output "instance_state" {
  value = {
    state = aws_ec2_instance_state.state
  }
}