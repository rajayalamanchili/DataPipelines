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

module "server_instance" {
  source        = "./modules/ec2"
  instance_name = "${var.app_name}-${var.env}-sample-server"
  subnet_id     = module.vpc.vpc_public_subnet_id[0]
  vpc_id        = module.vpc.vpc_id
  key_pair_name = var.ec2_keypair_name
}

module "mlflow_s3_bucket" {
  source      = "./modules/s3"
  bucket_name = "${var.app_name}-${var.env}-sample-bucket"

  app_name = var.app_name
  env      = var.env
}

# module "mlflow_db_backend" {
#   source = "./modules/db"

#   db_username          = "${var.db_username}_${var.env}"
#   ec2_securitygroup_id = module.server_instance.ec2_securitygroup_id

#   vpc_id       = module.vpc.vpc_id
#   db_subnet_group_name =  module.vpc.vpc_db_subnet_group_name

#   app_name = var.app_name
#   env      = var.env
# }

locals {
  tags = {
    Name        = var.app_name
    Environment = var.env
  }
}