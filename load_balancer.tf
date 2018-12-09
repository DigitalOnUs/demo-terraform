resource "aws_instance" "lb" {
  ami                         = "${var.aws_ami == data.aws_ami.host_image.id ? data.aws_ami.host_image.id : var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids      = ["${module.security_group.this_security_group_id}"]
  key_name                    = "${var.instance_key}"
  associate_public_ip_address = true
  private_ip                  = "10.0.4.130"
  
  tags {
    Name        = "bastion-host"
    Environment = "${terraform.workspace}"
  }

  provisioner "file" {
    source      = "scripts/haproxy-clients.cfg"
    destination = "/var/tmp/haproxy-clients.cfg"

    connection {
      type        = "ssh"
      user        = "${var.instance_key}"
      private_key = "${file("ubuntu.pem")}"
    }
  }

  provisioner "file" {
    source      = "scripts/haproxy-servers.cfg"
    destination = "/var/tmp/haproxy-servers.cfg"

    connection {
      type        = "ssh"
      user        = "${var.instance_key}"
      private_key = "${file("ubuntu.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sh /var/tmp/docker-lb.sh",
      "echo client > /var/tmp/consul.agent",
      "sudo service consul start"
    ]

    connection {
      type        = "ssh"
      user        = "${var.instance_key}"
      private_key = "${file("ubuntu.pem")}"
    }
  }
}
