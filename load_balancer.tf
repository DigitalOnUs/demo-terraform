resource "aws_instance" "lb" {
  ami                         = "${var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  key_name                    = "ubuntu"
  private_ip                  = "10.0.4.130"

  tags {
    Name = "terraform-demo"
  }

  provisioner "file" {
    source      = "scripts/haproxy.cfg"
    destination = "/var/tmp/haproxy.cfg"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu.pem")}"
    }
  }

  provisioner "file" {
    source      = "scripts/haproxy2.cfg"
    destination = "/var/tmp/haproxy2.cfg"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sh /var/tmp/docker-lb.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo client > /var/tmp/consul.agent",
      "sudo systemctl enable consul",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu.pem")}"
    }
  }
}
