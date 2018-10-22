resource "aws_instance" "lb" {
  ami                         = "${var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  key_name = "${aws_key_pair.default.id}"
  
  tags {
    Name = "terraform-demo"
  }

  # Copies the haproxy.cfg file to /home/haproxy.cfg
  provisioner "file" {
    source      = "scripts/haproxy.cfg"
    destination = "/home/haproxy.cfg"
    
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("ubuntu.pub")}"
    }
  }

  provisioner "remote-exec" {
    scripts = [
      "install-consul.sh",
      "install-docker.sh",
      "run-docker-lb.sh"
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("ubuntu.pub")}"
    }
  }
}
