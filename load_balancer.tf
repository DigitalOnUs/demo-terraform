resource "aws_instance" "lb" {
  ami                         = "${var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  key_name                    = "ubuntu"

  tags {
    Name = "terraform-demo"
  }

  provisioner "remote-exec" {
    scripts = [
      "/tmp/docker-lb.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu.pem")}"
    }
  }
}
