variable "access_key" {}
variable "secret_key" {}

variable "aws_ami" {
  description = "AMI to be used for aws instances"
<<<<<<< HEAD
  value       = "ami-0bbe6b35405ecebdb"
=======
  default     = "ami-063aa838bd7631e0b"
>>>>>>> 7e9b7a643599f60696c342356dfe2c94a2468548
}

variable "region" {
  description = "region to deploy aws infraestructre"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "type of instances to be used"
  default     = "t2.micro"
}
