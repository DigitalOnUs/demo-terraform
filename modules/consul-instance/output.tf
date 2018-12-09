output "servers" {
  value = "${aws_instance.consul_instance.*.private_ip}"
}