// provider "consul" {
//   address    = "${aws_instance.lb.public_ip}:8500"
//   datacenter = "DC1"
// }

// resource "consul_service" "lb" {
//   name    = "lb"
//   node    = "${consul_node.lb.name}"
//   port    = 80
//   tags    = ["load-balancer"]
// }

// resource "consul_node" "lb" {
//   name    = "lb"
//   address = "${aws_instance.lb.public_ip}"
// }