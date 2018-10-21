resource "aws_instance" "lb" {
  ami           = "${var.aws_ami}"
  instance_type = "t2.micro"

  tags {
    Name = "terraform-demo"
  }
}