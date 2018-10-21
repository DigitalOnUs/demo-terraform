terraform {
  required_version = ">= 0.11.9"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-west-1"
}

terraform {
  backend "s3" {
    bucket = "dou-terraform"
    key    = "iac-meetup/terraform.tfstate"
    region = "us-west-1"
  }
}
