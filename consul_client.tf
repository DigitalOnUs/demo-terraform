resource "aws_instance" "consul_client_1" {
  ami                         = "${var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}", "${aws_security_group.ncv.id}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.4.101"
  key_name                    = "ubuntu"

  tags {
    Name        = "consul-client-1"
    Environment = "demo"
    Role        = "cs"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /var/tmp/docker-web.sh",
      "echo client > /var/tmp/consul.agent",
      "sudo systemctl enable consul",
      "sudo service consul start",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu.pem")}"
    }
  }
}

resource "aws_instance" "consul_client_2" {
  ami                         = "${var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}", "${aws_security_group.ncv.id}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.4.175"
  key_name                    = "ubuntu"

  tags {
    Name        = "consul-client-2"
    Environment = "demo"
    Role        = "cs"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /var/tmp/docker-web.sh",
      "echo client > /var/tmp/consul.agent",
      "sudo systemctl enable consul",
      "sudo service consul start",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu.pem")}"
    }
  }
}

resource "aws_instance" "consul_client_3" {
  ami                         = "${var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}", "${aws_security_group.ncv.id}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.4.214"
  key_name                    = "ubuntu"

  tags {
    Name        = "consul-client-3"
    Environment = "demo"
    Role        = "cs"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /var/tmp/docker-web.sh",
      "echo client > /var/tmp/consul.agent",
      "sudo systemctl enable consul",
      "sudo service consul start",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu.pem")}"
    }
  }
}
