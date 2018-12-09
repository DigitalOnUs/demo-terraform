output "subnet_id" {
  value = "${aws_subnet.subnet_lb.id}"
}

output "consul_cluster_sg" {
  value = [
    "${module.security_group.this_security_group_id}", 
    "${aws_security_group.ncv.id}"
  ]
}