variable "access_key" {}
variable "secret_key" {}

variable "aws_ami" {
  description = "AMI to be used for aws instances"
<<<<<<< HEAD
  default     = "ami-0a6eb6b51bb98545d"
=======
  default     = "ami-07312e5f6a79452c8"
>>>>>>> ea1a39c5516c6b5b64a9ea750db88ebce89af67a
}

variable "region" {
  description = "region to deploy aws infraestructre"
  default     = "us-west-2"
}

variable "instance_type" {
  description = "type of instances to be used"
  default     = "t2.micro"
}
