
resource "aws_vpc" "vpc" {

  cidr_block = var.cidr_range

  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.app_name}-vpc"
    Environment = var.env
  }
}