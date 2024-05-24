terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "${var.app_name}-${var.env}-vpc"

  app_name = var.app_name
  env      = var.env
}

module "mlflow_s3_bucket" {
  source      = "./modules/s3"
  bucket_name = "${var.app_name}-${var.env}-sample-bucket"

  app_name = var.app_name
  env      = var.env
}

resource "aws_security_group" "lb_sg" {
  name   = "${var.app_name}-${var.env}-ecs-lb"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "load balancer ingress"
    from_port   = var.ecs_lb_listener_port
    to_port     = var.ecs_lb_listener_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "load balancer egress"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_service_sg" {
  name   = "${var.app_name}-${var.env}-ecs-service-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = var.ecs_lb_listener_port
    to_port         = var.ecs_lb_listener_port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "mlflow_db_backend" {
  source = "./modules/db"

  db_username          = "${var.db_username}_${var.env}"
  ecs_securitygroup_id = aws_security_group.ecs_service_sg.id
  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.vpc_db_subnet_group_name

  app_name = var.app_name
  env      = var.env
}

module "ecr_repo" {
  source = "./modules/ecr"

}

module "ecs" {
  source = "./modules/ecs"

  vpc_id                = module.vpc.vpc_id
  vpc_public_subnet_ids = module.vpc.vpc_public_subnet_ids

  ecs_lb_listener_port          = var.ecs_lb_listener_port
  lb_security_group_id          = aws_security_group.lb_sg.id
  ecs_service_security_group_id = aws_security_group.ecs_service_sg.id

  mlflow_s3_url_ssm_name = module.mlflow_s3_bucket.mlflow_artifact_url_ssm_name
  mlflow_db_url_ssm_name = module.mlflow_db_backend.mlflow_db_url_ssm_name

  mlflow_ecr_repo_url = module.ecr_repo.ecr_repo_url_tag

  depends_on = [module.mlflow_db_backend.mlflow_db_url_ssm_name, module.mlflow_s3_bucket.mlflow_artifact_url_ssm_name, module.ecr_repo.ecr_repo_url_tag, module.vpc]

}

