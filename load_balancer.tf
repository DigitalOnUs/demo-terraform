resource "aws_instance" "lb" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
  associate_public_ip_address = true
  
  tags {
    Name = "terraform-demo"
  }

  # Copies the haproxy.cfg file to /home/haproxy.cfg
  provisioner "file" {
    source      = "scripts/haproxy.cfg"
    destination = "/home/haproxy.cfg"
  }

  provisioner "file" {
    source      = "install-consul.sh"
    destination = "/tmp/install-consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-consul.sh",
      "sh /tmp/install-consul.sh",
    ]
  }
  
  provisioner "file" {
    source      = "install-docker.sh"
    destination = "/tmp/install-docker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-docker.sh",
      "sh /tmp/install-docker.sh",
    ]
  }
  
  provisioner "remote-exec" {
    inline = [
      "docker run -d \
           --name haproxy \
           -p 80:80 \
           --restart unless-stopped \
           -v /home/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
           haproxy:1.6.5-alpine"
    ]
  }
}