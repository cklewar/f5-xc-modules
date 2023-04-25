variable "aws_ec2_instance_id" {
  type = string
}

variable "aws_ec2_instance_state" {
  type = string
  validation {
    condition     = var.aws_ec2_instance_state == "stopped" || var.aws_ec2_instance_state == "running"
    error_message = "aws_ec2_instance_state must be one of <stopped> or <running>"
  }
}

variable "aws_ec2_instance_state_forced_stop" {
  type    = bool
  default = false
}