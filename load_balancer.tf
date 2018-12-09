resource "aws_instance" "lb" {
  ami                         = "${var.aws_ami == data.aws_ami.host_image.id ? data.aws_ami.host_image.id : var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${module.consul-cluster-network.subnet_id}"
  vpc_security_group_ids      = ["${module.consul-cluster-network.load_balancer_sg}"]
  key_name                    = "${var.instance_key}"
  associate_public_ip_address = true
  private_ip                  = "10.0.4.130"
  
  tags {
    Name        = "bastion-host"
    Environment = "${terraform.workspace}"
  }

  provisioner "file" {
    source      = "others/scripts/haproxy-clients.cfg"
    destination = "/var/tmp/haproxy-clients.cfg"

    connection {
      type        = "ssh"
      user        = "${var.instance_key}"
      private_key = "${file("ubuntu.pem")}"
    }
  }

  provisioner "file" {
    source      = "others/scripts/haproxy-servers.cfg"
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
