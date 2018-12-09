provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  required_version = ">= 0.11.9"

  // backend "consul" {
  //   address = "34.217.76.104:9500"
  //   scheme  = "http"
  //   path    = "terraform/state"
  // }
}

data "aws_ami" "host_image" {
  most_recent = true
  owners = ["237889007525"]

  filter {
    name = "name"
    values = ["consul*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "consul-cluster-network" {
  source = "./modules/consul-network"

  vpc_cidr_block       = "${var.vpc_cidr_block}"
  subnet_cidr_block    = "${var.subnet_cidr_block}"
}

module "consul-clients" {
  source = "./modules/consul-instance"
  
  command_line = [
    "sh /var/tmp/docker-web.sh ${terraform.workspace}",
    "echo client > /var/tmp/consul.agent",
    "sudo service consul start"
  ]
  aws_ami       = "${var.aws_ami == data.aws_ami.host_image.id ? data.aws_ami.host_image.id : var.aws_ami}"
  ip_prefix     = 11
  instance_key  = "${var.instance_key}"
  instance_type = "${var.instance_type}"
  num_instances = 3
  subnet_id     = "${module.consul-cluster-network.subnet_id}"
  type          = "client"
  vpcs          = "${module.consul-cluster-network.consul_cluster_sg}"
}

module "consul-servers" {
  source = "./modules/consul-instance"
  
  aws_ami      = "${var.aws_ami == data.aws_ami.host_image.id ? data.aws_ami.host_image.id : var.aws_ami}"
  command_line = [
    "echo server > /var/tmp/consul.agent",
    "sudo service consul start"
  ]
  ip_prefix     = 20
  instance_key  = "${var.instance_key}"
  instance_type = "${var.instance_type}"
  num_instances = 3
  subnet_id     = "${module.consul-cluster-network.subnet_id}"
  type          = "server"
  vpcs          = "${module.consul-cluster-network.consul_cluster_sg}"
}