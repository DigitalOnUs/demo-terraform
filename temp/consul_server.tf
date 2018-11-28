resource "aws_instance" "consul_servers" {
  count = 3

  ami                         = "${var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${aws_subnet.subnet_lb.id}"
  vpc_security_group_ids      = ["${aws_security_group.sgweb.id}", "${aws_security_group.ncv.id}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.4.1${(count.index + 1)*20}"
  key_name                    = "ubuntu"

  tags {
    Name        = "consul-server-${count.index + 1}"
    Environment = "demo"
    Role        = "cs"
  }
  provisioner "remote-exec" {
    inline = [
      "echo server > /var/tmp/consul.agent",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("ubuntu.pem")}"
    }
  }
}