variable "aws_ami" {
  description = "AMI to be used for aws instances"
  value       = "ami-063aa838bd7631e0b"
}

variable "region" {
  description = "region to deploy aws infraestructre"
  value       = "us-west-2"
}

variable "instance_type" {
  description = "type of instances to be used"
  value       = "t2.micro"
}
