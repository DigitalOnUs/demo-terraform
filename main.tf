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
  enable_dns_hostnames = true

  tags {
    Name = "terraform-demo"
  }
}

resource "aws_subnet" "subnet_a" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  tags {
    Name = "terraform-demo"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}b"
  tags {
    Name = "terraform-demo"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.region}c"
  tags {
    Name = "terraform-demo"
  }
}

resource "aws_subnet" "subnet_lb" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.region}"
  tags {
    Name = "terraform-demo"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "terraform-demo"
  }
}

resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "terraform-demo"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id = "${aws_subnet.subnet_lb.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}

# Define the security group for public subnet
resource "aws_security_group" "sgweb" {
  name = "terraform_demo_test_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  vpc_id="${aws_vpc.my_vpc.id}"

  tags {
    Name = "terraform-demo"
  }
}