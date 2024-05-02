terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "sample_ec2" {

  ami           = "ami-0ddda618e961f2270"
  instance_type = "t2.micro"

  tags = {
    Name = "sample_server"
  }

}