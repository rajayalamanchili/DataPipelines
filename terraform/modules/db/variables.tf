variable "env" {
  type = string
}

variable "app_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "mlflow_db_name" {
  type    = string
  default = "mlflow_db"
}

variable "ec2_securitygroup_id" {
  type = string
}