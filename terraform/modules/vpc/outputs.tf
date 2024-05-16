output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "vpc_public_subnet_id" {
  value = aws_subnet.public[*].id
}

output "vpc_private_subnet_id" {
  value = aws_subnet.private[*].id
}