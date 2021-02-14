provider "consul" {
  address    = "54.149.97.163:8500"
  datacenter = "DC1"
}

resource "consul_keys" "instance-details" {
  key {
    name   = "ami"
    path   = "instance/ami"
    value  = "${var.aws_ami}"
    delete = true
  }

  key {
    name   = "address"
    path   = "instance/type"
    value  = "${aws_instance.consul_client_1.instance_type}"
    delete = true
  }
}

resource "consul_keys" "consul-servers" {
  key {
    name   = "address"
    path   = "consul/cluster/servers"
    value  = "[${aws_instance.consul_server_1.private_ip}, ${aws_instance.consul_server_2.private_ip}, ${aws_instance.consul_server_3.private_ip}]"
    delete = true
  }

  key {
    name   = "address"
    path   = "consul/cluster/clients"
    value  = "[${aws_instance.consul_client_1.private_ip}, ${aws_instance.consul_client_2.private_ip}, ${aws_instance.consul_client_3.private_ip}]"
    delete = true
  }
}

data "consul_services" "read-dc1" {
  query_options {
    datacenter = "DC1"
  }
}

resource "consul_prepared_query" "myapp" {
  name         = "myweb"
  datacenter   = "dc1"
  only_passing = true

  service = "${data.consul_services.read-dc1.names.0}"
  tags    = ["active", "!standby"]

  failover {
    datacenters = ["dc1"]
  }

  dns {
    ttl = "30s"
  }
}

resource "consul_service" "search" {
  name       = "search"
  node       = "${consul_node.search.name}"
  port       = 80
  tags       = ["external-services"]
  datacenter = "dc1"
}

resource "consul_node" "search" {
  name    = "search-google"
  address = "www.google.com"
}
