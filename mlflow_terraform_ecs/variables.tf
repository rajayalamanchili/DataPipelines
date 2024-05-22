variable "env" {
  default = "dev"
}

variable "app_name" {
  default = "mlops-training"
}

variable "region" {
  default = "us-east-2"
}

variable "db_username" {
  default = "mlopsuser"
}

variable "ecs_lb_listener_port" {
  type    = number
  default = 443
}