output "load_balancer_ip" {
  value = "${aws_instance.lb.public_ip}"
}
