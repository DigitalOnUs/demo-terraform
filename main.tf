provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  required_version = ">= 0.11.9"

  // backend "consul" {
  //   address = "34.221.56.93:9500"
  //   scheme  = "http"
  //   path    = "terraform/state"
  // }
}

data "aws_ami" "host_image" {
  most_recent = true

  filter {
    name = "name"
    values = ["consul*"]
  }

  filter {
    name = "owner-alias"
    values = ["237889007525"]
  }
}