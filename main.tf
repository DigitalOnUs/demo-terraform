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

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags {
    Name = "terraform-demo"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.10.1.0/24"
  availability_zone = "${var.region}a"
  tags {
    Name = "tf-example"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.10.2.0/24"
  availability_zone = "${var.region}b"
  tags {
    Name = "tf-example"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.10.3.0/24"
  availability_zone = "${var.region}c"
  tags {
    Name = "tf-example"
  }
}

resource "aws_subnet" "subnet_lb" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.10.4.0/24"
  availability_zone = "${var.region}"
  tags {
    Name = "tf-example"
  }
}
