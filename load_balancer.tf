resource "aws_network_interface" "lb_network_interface" {
  subnet_id = "${aws_subnet.subnet_lb.id}"
  private_ips = ["10.10.4.1"]
  tags {
    Name = "terraform-demo"
  }
}

resource "aws_instance" "lb" {
  ami           = "${var.aws_ami}"
  instance_type = "${var.instance_type}"

  network_interface {
    network_interface_id = "${aws_network_interface.lb_network_interface.id}"
    device_index = 0
  }

  tags {
    Name = "terraform-demo"
  }
}