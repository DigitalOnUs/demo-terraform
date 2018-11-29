provider "consul" {
  address    = "34.221.56.93:9500"
  datacenter = "DC1"
}


resource "consul_keys" "consul-servers" {
  key {
    name   = "address"
    path   = "consul/cluster/servers"
    value  = "[${join(",", aws_instance.consul_servers.*.private_ip)}]"
    delete = true
  }

  key {
    name   = "address"
    path   = "consul/cluster/clients"
    value  = "[${join(",", aws_instance.consul_clients.*.private_ip)}]"
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
  name    = "search"
  node    = "${consul_node.search.name}"
  port    = 80
  tags    = ["external-services"]
  datacenter = "dc1"
}

resource "consul_node" "search" {
  name    = "search-google"
  address = "www.google.com"
}