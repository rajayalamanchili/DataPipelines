variable "env" {
  default = "dev"
}

variable "app_name" {
  default = "mlops-training"
}

variable "vpc_id" {
  type = string
}

variable "vpc_public_subnet_ids" {
  type = list(string)
}

variable "ecs_lb_listener_port" {
  type    = number
  default = 80
}

variable "ecs_service_cpus" {
  type    = number
  default = 256
}

variable "ecs_service_memory" {
  type    = number
  default = 1024
}

variable "mlflow_s3_url_ssm_name" {
  type = string
}

variable "mlflow_db_url_ssm_name" {
  type = string
}

variable "mlflow_ecr_repo_url" {
  type = string
}

variable "log_rentention_days" {
  type    = number
  default = 7
}

variable "mlflow_port" {
  type    = number
  default = 5000
}

variable "lb_security_group_id" {
  type = string
}

variable "ecs_service_security_group_id" {
  type = string
}