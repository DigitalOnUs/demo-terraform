variable "num_instances" {}

variable "type" {}

variable "command_line" {
  type = "list"
}

variable "ip_prefix" {}

variable "instance_key" {}

variable "instance_type" {}

variable "aws_ami" {}

variable "vpcs" {
  type = "list"
}

variable "subnet_id" {}