provider "consul" {
  address    = "34.217.76.104:9500"
  datacenter = "DC1"
}


resource "consul_keys" "consul-servers" {
  key {
    name   = "address"
    path   = "consul/cluster/servers"
    value  = "[${join(",", module.consul-servers.servers)}]"
    delete = true
  }

  key {
    name   = "address"
    path   = "consul/cluster/clients"
    value  = "[${join(",", module.consul-clients.servers)}]"
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