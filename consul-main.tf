// provider "consul" {
//   address    = "${aws_instance.lb.public_ip}:8500"
//   datacenter = "DC1"
// }

// resource "consul_node" "lb" {
//   name    = "lb"
//   address = "${aws_instance.lb.private_ip}"
// }

