resource "aws_instance" "ec2_instance" {
  ami           = var.ami
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.mlops-server-sg.id]

  associate_public_ip_address = true
  key_name                    = var.key_pair_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("${path.module}/user_data.sh", { MLFLOW_ARTIFACT_URL_SSM_NAME = "${var.MLFLOW_ARTIFACT_URL_SSM_NAME}", MLFLOW_DB_URL_SSM_NAME = "${var.MLFLOW_DB_URL_SSM_NAME}" })

  tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "tf_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "tf_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "${var.key_pair_name}-private-key"
}

resource "aws_security_group" "mlops-server-sg" {
  vpc_id = var.vpc_id
  name   = "${var.instance_name}-sg"

  ingress = [{
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    }, {
    description      = "Custom TCP"
    from_port        = var.MLFLOW_PORT
    to_port          = var.MLFLOW_PORT
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}