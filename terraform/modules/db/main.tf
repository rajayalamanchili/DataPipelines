resource "aws_db_instance" "mlops-db" {
  instance_class      = "db.t3.micro"
  identifier          = "${var.app_name}-${var.env}-db"
  engine              = "postgres"
  engine_version      = "15.2"
  allocated_storage   = 10
  skip_final_snapshot = true
  storage_encrypted   = true

  db_subnet_group_name = var.db_subnet_id
  db_name              = var.mlflow_db_name
  username             = var.db_username
  password             = random_password.db_password.result

  tags = {
    Name        = "${var.app_name}"
    Environment = var.env
  }
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.app_name}/${var.env}/DB_PASSWORD"
  type  = "SecureString"
  value = random_password.db_password.result

  tags = {
    Name        = "${var.app_name}"
    Environment = var.env
  }
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.app_name}/${var.env}/DB_USERNAME"
  type  = "SecureString"
  value = var.db_username

  tags = {
    Name        = "${var.app_name}"
    Environment = var.env
  }
}

resource "aws_ssm_parameter" "db_url" {
  name  = "/${var.app_name}/${var.env}/DB_URL"
  type  = "SecureString"
  value = "postgresql://${aws_db_instance.mlops-db.username}:${random_password.db_password.result}@${aws_db_instance.mlops-db.address}:5432/${aws_db_instance.mlops-db.db_name}"

  tags = {
    Name        = "${var.app_name}"
    Environment = var.env
  }
}

resource "aws_security_group" "rds_ec2" {
  vpc_id = var.vpc_id
  name   = "/${var.app_name}/${var.env}-vpn-rds-sg"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [var.ec2_securitygroup_id]
  }
}