variable "vpc_cidr_block" {}

variable "subnet_cidr_block" {}

variable "allow_any_cidr_block" {
  default = "0.0.0.0/0"
}