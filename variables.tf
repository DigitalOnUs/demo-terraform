variable "access_key" {}
variable "secret_key" {}

variable "aws_ami" {
  description = "AMI to be used for aws instances"
  value       = "ami-0bbe6b35405ecebdb"
}

variable "region" {
  description = "region to deploy aws infraestructre"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "type of instances to be used"
  default     = "t2.micro"
}
