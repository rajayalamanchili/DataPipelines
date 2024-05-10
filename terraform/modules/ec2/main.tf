resource "aws_instance" "ec2_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  tags = {
    Name = var.instance_name
  }
}