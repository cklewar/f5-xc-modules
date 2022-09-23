variable "timeout" {
  type    = string
  default = "5s"
}

variable "dependsOn" {
  type = string
}

variable "action_create" {
  type = string
  default = "CREATE"
}

variable "action_destroy" {
  type = string
  default = "DESTROY"
}

variable "action" {
  type = string

  validation {
    condition     = contains(["CREATE", "DESTROY", ""], var.action)
    error_message = format("Valid values for actiom: CREATE or DESTROY")
  }
}