resource "aws_db_instance" "mlops-db" {
  instance_class      = "db.t3.micro"
  identifier          = "${var.app_name}-${var.env}-db"
  engine              = "postgres"
  engine_version      = "16.1"
  allocated_storage   = 10
  skip_final_snapshot = true
  storage_encrypted   = true

  db_subnet_group_name = var.db_subnet_group_name
  db_name              = var.mlflow_db_name
  username             = var.db_username
  password             = random_password.db_password.result

  vpc_security_group_ids = [aws_security_group.rds.id]


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

# password encoding needed for mlflow serve command to run
resource "aws_ssm_parameter" "db_url" {
  name  = "/${var.app_name}/${var.env}/DB_URL"
  type  = "SecureString"
  value = "postgresql://${aws_db_instance.mlops-db.username}:${urlencode(random_password.db_password.result)}@${aws_db_instance.mlops-db.address}:${var.db_port}/${aws_db_instance.mlops-db.db_name}"

  tags = {
    Name        = "${var.app_name}"
    Environment = var.env
  }
}

resource "aws_security_group" "rds" {
  vpc_id = var.vpc_id
  name   = "/${var.app_name}/${var.env}-rds-sg"

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [var.ecs_securitygroup_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}