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

variable "db_port" {
  type    = number
  default = 5432
}

variable "mlflow_db_name" {
  type    = string
  default = "mlflow_db"
}

variable "ecs_securitygroup_id" {
  type = string
}