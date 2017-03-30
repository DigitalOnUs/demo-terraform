//
// Provider
//

variable "access_key" {}
variable "secret_key" {}
variable "ssh_key_name" {}

variable "region" {
  default = "us-west-1"
}

variable "subnet_zone" {
  default = "us-west-1a"
}

variable "instance_type" {
  default = "t2.micro"
}

//
// Variables
//

variable "os" {
  default = "ubuntu"
}

variable "env_name" {
  default = "Hashicorp"
}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "vpc_cidrs" {
  default = "172.31.16.0/20"
}

//
// Outputs
//

output "servers" {
  value = ["${aws_instance.server.*.public_ip}"]
}
