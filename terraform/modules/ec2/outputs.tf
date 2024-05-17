output "ec2_securitygroup_id" {
  value = aws_security_group.mlops-server-sg.id
}