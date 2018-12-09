resource "aws_instance" "consul_instance" {
  count = "${var.num_instances}"
  
  ami                         = "${var.aws_ami}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${var.vpcs}"]
  associate_public_ip_address = true
  private_ip                  = "10.0.4.1${(count.index + 1) * var.ip_prefix}"
  key_name                    = "${var.instance_key}"

  tags {
    Name        = "consul-${var.type}-${count.index + 1}"
    Environment = "${terraform.workspace}"
    Role        = "${var.type}"
  }

  provisioner "remote-exec" {
    inline = ["${var.command_line}"]

    connection {
      type        = "ssh"
      user        = "${var.instance_key}"
      private_key = "${file("ubuntu.pem")}"
    }
  }
}