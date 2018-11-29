output "front-door-url" {
  value = "${aws_instance.lb.public_ip}:80"
}

output "consul-ui" {
  value = "${aws_instance.lb.public_ip}:9500"
}
