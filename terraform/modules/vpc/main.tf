data "aws_availability_zones" "available" {
  state = "available"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr_range

  azs = data.aws_availability_zones.available.names

  private_subnets  = var.private_subnet_range
  public_subnets   = var.public_subnet_range
  database_subnets = var.database_subnet_range

  enable_nat_gateway = false

}

output "vpc_id" {
  value = module.vpc.default_vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}