resource "aws_instance" "consul_server_1" {
  ami               = "${var.aws_ami}"
  instance_type     = "${var.instance_type}"
  availability_zone = "${var.region}a"

  tags {
    Name        = "consul_server_1"
    Environment = "demo"
    Role        = "cs"
  }
}
