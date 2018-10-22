resource "aws_instance" "consul_server_1" {
  ami               = "${var.aws_ami}"
  instance_type     = "${var.instance_type}"
  availability_zone = "${var.region}a"
  subnet_id                   = "${aws_subnet.subnet_a.id}"
  vpc_security_group_ids      = ["${aws_security_group.ncv.id}"]
  key_name = "ubuntu"

  tags {
    Name        = "consul_server_1"
    Environment = "demo"
    Role        = "cs"
  }

  provisioner "file" {
    source      = "consul.json.server"
    destination = "/var/consul/config/consul.json.template"
    
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("ubuntu.pub")}"
    }
  }

  provisioner "remote-exec" {
    scripts = [
      "install-consul.sh",
      "run-consul-server.sh"
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("ubuntu.pub")}"
    }
  }
}
