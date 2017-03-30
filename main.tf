provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "server" {
  ami                         = "${data.aws_ami.main.id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.ssh_key_name}"
  subnet_id                   = "${aws_subnet.main.id}"
  associate_public_ip_address = true

  security_groups = [
    "${aws_security_group.default_egress.id}",
    "${aws_security_group.admin_access.id}",
    "${aws_security_group.all.id}",
  ]

  tags {
    Name = "${var.env_name}"
  }
}

//resource "aws_autoscaling_group" "main" {
//  launch_configuration = "${aws_launch_configuration.main.id}"
//  availability_zones   = ["${data.aws_availability_zones.main.names}"]
//  vpc_zone_identifier  = "${element(aws_subnet.main.*.id,count.index)}"
//
//  min_size = 3
//  max_size = 12
//
//  load_balancers    = ["${aws_elb.main.name}"]
//  health_check_type = "ELB"
//
//  tag {
//    key                 = "Name"
//    value               = "${var.env_name}"
//    propagate_at_launch = true
//  }
//}
//
//resource "aws_launch_configuration" "main" {
//  image_id      = "${data.aws_ami.main.id}"
//  instance_type = "${var.region}"
//  key_name      = "${var.ssh_key_name}"
//
//  vpc_security_group_ids = [
//    "${aws_security_group.default_egress.id}",
//    "${aws_security_group.admin_access.id}",
//    "${aws_security_group.all.id}",
//  ]
//
//  lifecycle {
//    create_before_destroy = true
//  }
//}

