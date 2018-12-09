resource "aws_vpc" "my_vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "terraform-demo-vpc"
    Environment = "${terraform.workspace}"    
  }
}

resource "aws_subnet" "subnet_lb" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "${var.subnet_cidr_block}"

  tags {
    Name = "terraform-demo-subnet-lb"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  tags {
    Name = "terraform-demo-gw"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_route_table" "web-public-rt" {
  vpc_id = "${aws_vpc.my_vpc.id}"

  route {
    cidr_block = "${var.allow_any_cidr_block}"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "terraform-demo-rt"
    Environment = "${terraform.workspace}"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "web-public-rt" {
  subnet_id      = "${aws_subnet.subnet_lb.id}"
  route_table_id = "${aws_route_table.web-public-rt.id}"
}


module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "terraform_demo_test_web"
  description = "Allow incoming HTTP connections & SSH access"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress_cidr_blocks = ["${var.allow_any_cidr_block}"]
  ingress_rules       = ["http-80-tcp", "all-icmp", "ssh-tcp"]
  egress_rules        = ["all-all"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 9500
      to_port     = 9500
      protocol    = "tcp"
      cidr_blocks = "${var.allow_any_cidr_block}"
    }
  ]

  egress_with_cidr_blocks = [
  {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = "${var.vpc_cidr_block}"
  }]

  tags {
    Name = "terraform-demo"
    Environment = "${terraform.workspace}"
  }
}

# Define the security group for public subnet
resource "aws_security_group" "ncv" {
  name        = "terraform_demo_test_ncv"
  description = "Allow Consul communication"
  vpc_id      = "${aws_vpc.my_vpc.id}"

  ingress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 8500
    to_port     = 8500
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  tags {
    Name = "terraform-demo-ncv"
    Environment = "${terraform.workspace}"
  }
}
