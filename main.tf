terraform {
  required_version = ">= 0.11.9"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-west-1"
}
