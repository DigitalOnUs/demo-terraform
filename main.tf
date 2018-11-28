provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  required_version = ">= 0.11.9"

  // backend "consul" {
  //   address = "54.149.97.163:8500"
  //   scheme  = "http"
  //   path    = "terraform/state"
  // }
}