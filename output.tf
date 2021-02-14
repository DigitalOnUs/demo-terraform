output "load_balancer_ip" {
  value = "${aws_instance.lb.public_ip}:80"
}

output "consul-ui" {
  value = "${aws_instance.lb.public_ip}:8500"
}
