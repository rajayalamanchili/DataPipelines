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
}

module "server_instance" {
  source        = "./modules/ec2"
  instance_name = "${var.app_name}-${var.env}-sample-server"
  subnet_id = "${element(module.vpc.public_subnets, 0)}"
}

module "mlflow_s3_bucket" {
  source      = "./modules/s3"
  bucket_name = "${var.app_name}-${var.env}-sample-bucket"
}

locals {
  tags = {
    Name        = var.app_name
    Environment = var.env
  }
}