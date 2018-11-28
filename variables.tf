variable "access_key" {}
variable "secret_key" {}

variable "aws_ami" {
  description = "This AMI has been generated with Packer and containes Docker and Datadog installed"
  default     = "ami-0ffba45bfd18af19c"
}

variable "region" {
  description = "region to deploy the infraestructre"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "type of instance to be used"
  default     = "t2.micro"
}
