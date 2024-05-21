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

module "mlflow_db_backend" {
  source = "./modules/db"

  db_username          = "${var.db_username}_${var.env}"
  ecs_securitygroup_id = module.ecs.ecs_securitygroup_id
  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.vpc_db_subnet_group_name

  app_name = var.app_name
  env      = var.env
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id                = module.vpc.vpc_id
  vpc_public_subnet_ids = module.vpc.vpc_public_subnet_ids

  mlflow_s3_url_ssm_name = module.mlflow_s3_bucket.mlflow_artifact_url_ssm_name
  mlflow_db_url_ssm_name = module.mlflow_db_backend.mlflow_db_url_ssm_name

  mlflow_ecr_repo_url = module.ecr_repo.ecr_repo_url_tag

}

module "ecr_repo" {
  source = "./modules/ecr"

}