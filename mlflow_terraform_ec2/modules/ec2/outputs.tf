output "ec2_securitygroup_id" {
  value = aws_security_group.mlops-server-sg.id
}

output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

output "mlflow_port" {
  value = var.MLFLOW_PORT
}