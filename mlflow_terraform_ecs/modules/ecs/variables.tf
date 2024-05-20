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
  default = 443
}