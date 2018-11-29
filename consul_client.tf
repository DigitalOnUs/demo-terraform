resource "aws_instance" "consul_clients" {
  count = 3
  
  ami                         = "${var.aws_ami == data.aws_ami.host_image.id ? data.aws_ami.host_image.id : var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}", "${aws_security_group.ncv.id}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.4.1${(count.index + 1) * 11}"
  key_name                    = "${var.instance_key}"

  tags {
    Name        = "consul-client-${count.index + 1}"
    Environment = "demo"
    Role        = "cs"
  }

  provisioner "remote-exec" {
    inline = [
      "sh /var/tmp/docker-web.sh",
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